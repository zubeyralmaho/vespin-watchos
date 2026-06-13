import SwiftUI

struct MiniNowPlaying: View {
    let title: String
    let artist: String
    let preset: QuickPreset
    let playbackStatus: PlaybackStatus
    let isMuted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: WatchSpacing.xSmall) {
            HStack(spacing: WatchSpacing.small) {
                Text(title)
                    .font(WatchTypography.title)
                    .foregroundStyle(WatchColors.cream)
                    .lineLimit(1)

                Spacer(minLength: 0)

                if isMuted {
                    Image(systemName: "speaker.slash.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(WatchColors.muted)
                }
            }

            Text(artist)
                .font(WatchTypography.body)
                .foregroundStyle(WatchColors.creamSoft)
                .lineLimit(1)

            HStack(spacing: WatchSpacing.small) {
                Text(preset.rawValue.uppercased())
                    .font(WatchTypography.caption)
                    .foregroundStyle(WatchColors.creamSoft)

                Circle()
                    .fill(WatchColors.muted)
                    .frame(width: 3, height: 3)

                Text(playbackStatus.rawValue.uppercased())
                    .font(WatchTypography.caption)
                    .foregroundStyle(WatchColors.muted)
            }

            Text(preset.subtitle)
                .font(WatchTypography.caption)
                .foregroundStyle(WatchColors.muted)
        }
    }
}