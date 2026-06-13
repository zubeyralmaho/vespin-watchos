import SwiftUI

struct WatchCard<Content: View>: View {
    var padding: CGFloat = WatchSpacing.medium
    var spacing: CGFloat = WatchSpacing.small
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content()
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [WatchColors.surfaceAlt, WatchColors.surface],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous)
                .stroke(WatchColors.border.opacity(0.18), lineWidth: 1)
        )
    }
}