import SwiftUI

struct BatteryRing: View {
    let value: Int
    let label: String
    var tint: Color = WatchColors.accentBlue

    var body: some View {
        VStack(spacing: WatchSpacing.xSmall) {
            ZStack {
                Circle()
                    .stroke(WatchColors.border.opacity(0.18), lineWidth: 6)

                Circle()
                    .trim(from: 0, to: CGFloat(value) / 100)
                    .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 1) {
                    Text("\(value)")
                        .font(WatchTypography.metric)
                        .monospacedDigit()
                    Text("%")
                        .font(WatchTypography.caption)
                }
                .foregroundStyle(WatchColors.cream)
            }
            .frame(width: 44, height: 44)

            Text(label)
                .font(WatchTypography.caption)
                .foregroundStyle(WatchColors.muted)
        }
    }
}