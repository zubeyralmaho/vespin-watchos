import SwiftUI

struct RemoteControlsView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel

    private let columns = [
        GridItem(.flexible(), spacing: WatchSpacing.small),
        GridItem(.flexible(), spacing: WatchSpacing.small),
        GridItem(.flexible(), spacing: WatchSpacing.small)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: WatchSpacing.medium) {
                WatchCard {
                    Text("Playback Remote")
                        .font(WatchTypography.hero)
                        .foregroundStyle(WatchColors.cream)

                    Text("Fast corrections when the speaker is across the room.")
                        .font(WatchTypography.caption)
                        .foregroundStyle(WatchColors.muted)

                    LazyVGrid(columns: columns, spacing: WatchSpacing.small) {
                        remoteButton(symbol: "backward.fill", title: "Prev") {
                            viewModel.previousTrack()
                        }

                        remoteButton(
                            symbol: viewModel.state.playbackStatus.symbolName,
                            title: viewModel.state.playbackStatus == .playing ? "Pause" : "Play",
                            tint: WatchColors.accentRed
                        ) {
                            viewModel.togglePlayback()
                        }

                        remoteButton(symbol: "forward.fill", title: "Next") {
                            viewModel.nextTrack()
                        }

                        remoteButton(symbol: "speaker.minus.fill", title: "-5") {
                            viewModel.decreaseVolume()
                        }

                        remoteButton(
                            symbol: viewModel.state.isMuted ? "speaker.wave.2.fill" : "speaker.slash.fill",
                            title: viewModel.state.isMuted ? "On" : "Mute",
                            tint: WatchColors.surface
                        ) {
                            viewModel.toggleMute()
                        }

                        remoteButton(symbol: "speaker.plus.fill", title: "+5") {
                            viewModel.increaseVolume()
                        }
                    }
                }

                WatchCard {
                    HStack(spacing: WatchSpacing.medium) {
                        VStack(alignment: .leading, spacing: WatchSpacing.xSmall) {
                            Text("Device")
                                .font(WatchTypography.caption)
                                .foregroundStyle(WatchColors.muted)
                            Text(viewModel.state.selectedSpeakerName)
                                .font(WatchTypography.title)
                                .foregroundStyle(WatchColors.cream)
                        }

                        Spacer(minLength: 0)

                        VStack(alignment: .trailing, spacing: WatchSpacing.xSmall) {
                            Text("Volume")
                                .font(WatchTypography.caption)
                                .foregroundStyle(WatchColors.muted)
                            Text(viewModel.state.isMuted ? "Muted" : "\(viewModel.state.volume)%")
                                .font(WatchTypography.metric)
                                .foregroundStyle(WatchColors.cream)
                                .monospacedDigit()
                        }
                    }

                    Text(viewModel.state.nowPlayingCollection)
                        .font(WatchTypography.caption)
                        .foregroundStyle(WatchColors.accentGold)

                    MiniNowPlaying(
                        title: viewModel.state.nowPlayingTitle,
                        artist: viewModel.state.nowPlayingArtist,
                        preset: viewModel.state.preset,
                        playbackStatus: viewModel.state.playbackStatus,
                        isMuted: viewModel.state.isMuted
                    )
                }
            }
            .padding(WatchSpacing.large)
        }
        .background(WatchColors.background.ignoresSafeArea())
        .navigationTitle("Remote")
    }

    private func remoteButton(symbol: String, title: String, tint: Color = WatchColors.surfaceAlt, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: WatchSpacing.xSmall) {
                Image(systemName: symbol)
                    .font(.system(size: 14, weight: .semibold))

                Text(title)
                    .font(WatchTypography.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
            }
            .foregroundStyle(WatchColors.cream)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(tint)
            .overlay(
                RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous)
                    .stroke(WatchColors.border.opacity(0.18), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}