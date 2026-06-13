import SwiftUI

enum StatusViewMode {
    case connected
    case battery
}

struct StatusView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel
    @Binding var currentScreen: WatchInteractionScreen
    let mode: StatusViewMode

    var body: some View {
        ZStack {
            WatchScreenBackground()

            GeometryReader { proxy in
                // Drive speaker sizing from both axes so the carousel never
                // overflows the bottom on short screens (40/41mm).
                let speakerUnit = min(proxy.size.width, proxy.size.height * 0.78)

                VStack(spacing: 0) {
                    HStack {
                        navButton(systemName: "chevron.left") {
                            navigate(to: mode == .battery ? .speakersConnected : .dashboard)
                        }

                        Spacer(minLength: 0)

                        navButton(systemName: "house.fill") {
                            navigate(to: .dashboard)
                        }
                    }

                    Spacer(minLength: 2)

                    powerButton

                    Spacer(minLength: 6)

                    connectionLabel

                    Text(viewModel.state.roomName)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .tracking(0.4)
                        .foregroundStyle(Color(red: 0.89, green: 0.82, blue: 0.84))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.top, 4)

                    Spacer(minLength: 4)

                    speakerCarousel(unit: speakerUnit)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 6)
                .padding(.bottom, 4)
            }
        }
    }

    private var powerButton: some View {
        Button {
            viewModel.toggleConnection()
            navigate(to: .dashboard)
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.34, green: 0.34, blue: 0.36), Color(red: 0.17, green: 0.17, blue: 0.18)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color.white.opacity(0.08), radius: 4, y: -1)
                    .frame(width: 38, height: 38)

                Image(systemName: "power")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(Color.black.opacity(0.88))
            }
        }
        .buttonStyle(.plain)
    }

    private func speakerCarousel(unit: CGFloat) -> some View {
        // Speaker images overhang above their pedestals via a negative offset,
        // which sits outside the HStack's layout bounds. Reserve top room so the
        // overhang does not collide with the room name above.
        let overhangReserve = unit * 0.28 * 0.5

        return HStack(alignment: .bottom, spacing: unit * 0.04) {
            ForEach(Array(viewModel.speakerCarousel.enumerated()), id: \.element.id) { index, speaker in
                speakerPedestalButton(for: speaker, slotIndex: index, unit: unit)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, overhangReserve)
        .padding(.bottom, 6)
        .animation(.easeInOut(duration: 0.18), value: viewModel.state.selectedSpeakerName)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 18)
                .onEnded { value in
                    if value.translation.width <= -28 {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            viewModel.nextSpeaker()
                        }
                    } else if value.translation.width >= 28 {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            viewModel.previousSpeaker()
                        }
                    }
                }
        )
    }

    private var connectionLabel: some View {
        Group {
            if viewModel.state.syncStatus == .connected {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 10, height: 10)

                    Text("Connected")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.9))
                }
            } else {
                Text("Unconnected")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.9))
            }
        }
    }

    private func speakerPedestalButton(for speaker: SpeakerDisplayItem, slotIndex: Int, unit: CGFloat) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                switch slotIndex {
                case 0:
                    viewModel.previousSpeaker()
                case 2:
                    viewModel.nextSpeaker()
                default:
                    currentScreen = mode == .connected ? .speakersBattery : .speakersConnected
                }
            }
        } label: {
            speakerPedestal(for: speaker, unit: unit)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func speakerPedestal(for speaker: SpeakerDisplayItem, unit: CGFloat) -> some View {
        let isSelected = speaker.isSelected
        let width: CGFloat = isSelected ? unit * 0.28 : unit * 0.21
        let height: CGFloat = isSelected ? unit * 0.30 : unit * 0.24
        let imageWidth: CGFloat = isSelected ? unit * 0.26 : unit * 0.22
        let pedestalColor = isSelected && mode == .connected ? Color.white : Color(red: 0.70, green: 0.82, blue: 0.61)

        return RoundedRectangle(cornerRadius: width * 0.36, style: .continuous)
            .fill(pedestalColor)
            .frame(width: width, height: height)
            .overlay(alignment: .top) {
                VStack(spacing: 8) {
                    Image(speaker.assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth)
                        .offset(y: -height * 0.38)

                    if mode == .battery && isSelected {
                        HStack(spacing: 6) {
                            Text("\(speaker.battery)%")
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .monospacedDigit()

                            Image(systemName: "bolt.fill")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundStyle(Color.black.opacity(0.88))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(red: 1.0, green: 0.84, blue: 0.20))
                        .clipShape(Capsule())
                        .offset(y: -height * 0.2)
                    }
                }
            }
    }

    private func navButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 30, height: 30)

                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.white)
            }
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }

    private func navigate(to screen: WatchInteractionScreen) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentScreen = screen
        }
    }
}
