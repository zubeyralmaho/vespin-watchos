import SwiftUI

struct BrandMarkView: View {
    var size: CGFloat = 76

    var body: some View {
        ZStack {
            Circle()
                .stroke(WatchColors.cream, lineWidth: size * 0.095)
                .frame(width: size, height: size)

            Circle()
                .stroke(WatchColors.cream, lineWidth: size * 0.08)
                .frame(width: size * 0.69, height: size * 0.69)

            Circle()
                .stroke(WatchColors.cream, lineWidth: size * 0.07)
                .frame(width: size * 0.43, height: size * 0.43)

            Circle()
                .fill(WatchColors.background)
                .frame(width: size * 0.18, height: size * 0.18)

            HStack {
                Spacer(minLength: 0)

                Text("VESPIN")
                    .font(WatchTypography.brand)
                    .foregroundStyle(WatchColors.cream)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, size * 0.08)
            }
            .frame(width: size * 0.96, height: size * 0.18)
            .background(WatchColors.accentRed)
            .clipShape(Capsule())
            .offset(x: size * 0.16)
        }
        .frame(width: size, height: size)
    }
}