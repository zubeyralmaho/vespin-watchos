import SwiftUI

struct ControlButton: View {
    let systemName: String
    var tint: Color = WatchColors.surfaceAlt
    var foreground: Color = WatchColors.cream
    var size: CGFloat = 38
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: size * 0.34, weight: .bold))
                .foregroundStyle(foreground)
                .frame(width: size, height: size)
                .background(tint)
                .overlay(
                    Circle()
                        .stroke(WatchColors.border.opacity(0.18), lineWidth: 1)
                )
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}