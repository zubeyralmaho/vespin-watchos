import SwiftUI

struct StatusBadge: View {
    let title: String
    var systemName: String? = nil
    var tone: Color = WatchColors.accentRed

    var body: some View {
        HStack(spacing: WatchSpacing.xSmall) {
            if let systemName {
                Image(systemName: systemName)
                    .font(.system(size: 9, weight: .bold))
            }

            Text(title)
                .font(WatchTypography.caption)
        }
        .foregroundStyle(WatchColors.cream)
        .padding(.horizontal, WatchSpacing.small)
        .padding(.vertical, WatchSpacing.xSmall)
        .background(tone.opacity(0.22))
        .overlay(
            Capsule()
                .stroke(tone.opacity(0.55), lineWidth: 1)
        )
        .clipShape(Capsule())
    }
}