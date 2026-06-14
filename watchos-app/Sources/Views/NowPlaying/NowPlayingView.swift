import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel
    @Binding var currentScreen: WatchInteractionScreen

    var body: some View {
        ZStack {
            WatchScreenBackground()

            GeometryReader { proxy in
                // Densest screen: keep the turntable bounded by height so the
                // transport controls and footer always stay on screen (40/41mm).
                let turntableSize = min(proxy.size.width * 0.68, proxy.size.height * 0.46)

                VStack(spacing: 0) {
                    HStack {
                        Button {
                            navigate(to: .dashboard)
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .regular))

                                ZStack(alignment: .topLeading) {
                                    Image(systemName: "music.note")
                                        .font(.system(size: 14, weight: .regular))

                                    Image(systemName: "sparkles")
                                        .font(.system(size: 8, weight: .regular))
                                        .offset(x: -6, y: -2)
                                }
                            }
                            .foregroundStyle(Color.white)
                        }
                        .buttonStyle(.plain)

                        Spacer(minLength: 0)
                    }

                    TurntableView(assetName: albumAssetName, size: turntableSize)
                        .padding(.top, -6)

                    Spacer(minLength: 2)

                    VStack(spacing: 0) {
                        Text(viewModel.state.nowPlayingArtist)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        Text(viewModel.state.nowPlayingTitle)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }

                    Spacer(minLength: 4)

                    HStack(spacing: 22) {
                        PlainIconButton(systemName: "backward.end.fill", size: 15) {
                            viewModel.previousTrack()
                        }

                        Button {
                            viewModel.togglePlayback()
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2.5)
                                    .frame(width: 34, height: 34)

                                Image(systemName: viewModel.state.playbackStatus == .playing ? "pause.fill" : "play.fill")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .buttonStyle(.plain)

                        PlainIconButton(systemName: "forward.end.fill", size: 15) {
                            viewModel.nextTrack()
                        }
                    }

                    Spacer(minLength: 4)

                    HStack(spacing: 4) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color(red: 0.66, green: 0.42, blue: 0.33))

                        Text(viewModel.state.nowPlayingCollection)
                            .font(.system(size: 10, weight: .regular, design: .rounded))
                            .foregroundStyle(Color(red: 0.66, green: 0.42, blue: 0.33))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        Text("•••")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color(red: 0.66, green: 0.42, blue: 0.33))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 10)
                .padding(.top, 4)
                .padding(.bottom, 4)
            }
        }
    }

    private var albumAssetName: String {
        viewModel.state.nowPlayingArtist == "Selena Gomez" ? "AlbumSelena" : "AlbumSona"
    }

    private func navigate(to screen: WatchInteractionScreen) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentScreen = screen
        }
    }

}

private struct TurntableView: View {
    let assetName: String
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.96, green: 0.72, blue: 0.55).opacity(0.55))
                .frame(width: size * 1.15, height: size * 1.15)
                .blur(radius: size * 0.22)

            Circle()
                .fill(Color(red: 0.95, green: 0.91, blue: 0.88))
                .frame(width: size * 0.86, height: size * 0.86)
                .shadow(color: Color.black.opacity(0.45), radius: 18, y: 10)

            Circle()
                .trim(from: 0.03, to: 0.78)
                .stroke(Color(red: 0.63, green: 0.45, blue: 0.42), style: StrokeStyle(lineWidth: size * 0.045, lineCap: .round))
                .rotationEffect(.degrees(184))
                .frame(width: size * 0.78, height: size * 0.78)

            Circle()
                .trim(from: 0.12, to: 0.88)
                .stroke(Color(red: 0.45, green: 0.15, blue: 0.16), style: StrokeStyle(lineWidth: size * 0.045, lineCap: .round))
                .rotationEffect(.degrees(10))
                .frame(width: size * 0.64, height: size * 0.64)

            Image(assetName)
                .resizable()
                .scaledToFill()
                .frame(width: size * 0.46, height: size * 0.46)
                .clipShape(Circle())

            Capsule()
                .fill(Color(red: 0.53, green: 0.28, blue: 0.25))
                .frame(width: size * 0.11, height: size * 0.025)
                .rotationEffect(.degrees(-42))
                .offset(x: size * 0.25, y: size * 0.02)

            Circle()
                .fill(Color(red: 0.48, green: 0.13, blue: 0.17))
                .frame(width: size * 0.08, height: size * 0.08)
                .offset(x: size * 0.31, y: size * 0.05)
                .shadow(color: Color.black.opacity(0.22), radius: 6, y: 3)

            Circle()
                .fill(Color(red: 0.76, green: 0.66, blue: 0.63))
                .frame(width: size * 0.03, height: size * 0.03)
                .offset(x: size * 0.31, y: size * 0.05)
        }
        .frame(width: size, height: size)
    }
}

private struct PlainIconButton: View {
    let systemName: String
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: size, weight: .regular))
                .foregroundStyle(Color.white)
        }
        .buttonStyle(.plain)
    }
}
