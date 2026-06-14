import SwiftUI

struct ConnectedSpeakerView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel
    @Binding var currentScreen: WatchInteractionScreen

    var body: some View {
        ZStack {
            WatchScreenBackground()

            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    connectionTile
                    eqTile
                }
                HStack(spacing: 8) {
                    songTile
                    speakersTile
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
    }

    private var connectionTile: some View {
        DashboardMockTile(tone: connectionTone) {
            navigate(to: .speakersConnected)
        } content: {
            VStack(spacing: 6) {
                Spacer(minLength: 0)

                Image(systemName: viewModel.state.syncStatus == .disconnected ? "link.slash" : "link")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(Color(red: 0.96, green: 0.92, blue: 0.90))

                Spacer(minLength: 0)

                Text(viewModel.state.syncStatus == .disconnected ? "UNCONNECTED" : "CONNECTED")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .shadow(color: Color.white.opacity(0.55), radius: 6)
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .padding(.horizontal, 6)
            }
            .padding(.vertical, 12)
        }
    }

    private var eqTile: some View {
        DashboardMockTile(tone: eqTone) {
            navigate(to: .quickPresets)
        } content: {
            VStack(spacing: 4) {
                Spacer(minLength: 0)

                Image(systemName: "slider.vertical.3")
                    .font(.system(size: 32, weight: .regular))
                    .foregroundStyle(Color(red: 0.96, green: 0.92, blue: 0.90))

                Spacer(minLength: 0)

                Text("EQ")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)

                if let eqSubtitle {
                    Text(eqSubtitle)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white)
                        .shadow(color: Color.white.opacity(0.5), radius: 6)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 12)
        }
    }

    private var songTile: some View {
        DashboardMockTile(tone: Color(red: 0.14, green: 0.14, blue: 0.14)) {
            navigate(to: .nowPlaying)
        } content: {
            VStack(spacing: 6) {
                Spacer(minLength: 0)

                ZStack {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundStyle(Color(red: 0.96, green: 0.92, blue: 0.90))

                    Image(systemName: "sparkles")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color(red: 0.96, green: 0.92, blue: 0.90))
                        .offset(x: -16, y: -12)
                }

                Spacer(minLength: 0)

                Text("SONG")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
            }
            .padding(.vertical, 12)
        }
    }

    private var speakersTile: some View {
        DashboardMockTile(tone: Color(red: 0.14, green: 0.14, blue: 0.14)) {
            navigate(to: .speakersBattery)
        } content: {
            VStack(spacing: 4) {
                Spacer(minLength: 0)

                Image(systemName: "hifispeaker.fill")
                    .font(.system(size: 32, weight: .regular))
                    .foregroundStyle(Color(red: 0.96, green: 0.92, blue: 0.90))

                Spacer(minLength: 0)

                Text("SPEAKERS")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                Text(viewModel.state.roomName)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .shadow(color: Color.white.opacity(0.45), radius: 6)
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)
            }
            .padding(.vertical, 12)
        }
    }

    private func navigate(to screen: WatchInteractionScreen) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentScreen = screen
        }
    }

    private var eqSubtitle: String? {
        viewModel.state.syncStatus == .disconnected ? nil : viewModel.state.preset.rawValue
    }

    private var connectionTone: Color {
        viewModel.state.syncStatus == .disconnected ? Color(red: 0.14, green: 0.14, blue: 0.14) : WatchColors.accentRed
    }

    private var eqTone: Color {
        viewModel.state.preset == .none ? Color(red: 0.14, green: 0.14, blue: 0.14) : WatchColors.accentRed
    }

}

private struct DashboardMockTile<Content: View>: View {
    let tone: Color
    let action: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        Button(action: action) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [tone.opacity(0.98), tone.opacity(0.82)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
