import SwiftUI

extension SyncStatus {
    var tintColor: Color {
        switch self {
        case .connected:
            return WatchColors.success
        case .syncing:
            return WatchColors.accentBlue
        case .weak:
            return WatchColors.warning
        case .disconnected:
            return WatchColors.accentRed
        }
    }
}

extension QuickPreset {
    var tintColor: Color {
        switch self {
        case .none:
            return WatchColors.border
        case .jazz:
            return WatchColors.accentGold
        case .rock:
            return WatchColors.accentBlue
        case .demo:
            return WatchColors.success
        }
    }
}

struct WatchScreenBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.08), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color(red: 0.39, green: 0.22, blue: 0.15).opacity(0.20))
                .frame(width: 180, height: 180)
                .blur(radius: 50)
                .offset(x: 0, y: -70)
        }
        .ignoresSafeArea()
    }
}

struct SpeakerLineupView: View {
    var batteryValue: Int? = nil

    var body: some View {
        HStack(alignment: .bottom, spacing: WatchSpacing.small) {
            SpeakerCabinetView(tint: WatchColors.accentBlue, style: .side)
                .rotationEffect(.degrees(-6))
                .offset(y: 10)

            VStack(spacing: WatchSpacing.small) {
                SpeakerCabinetView(tint: WatchColors.accentRed, style: .center)

                if let batteryValue {
                    SpeakerBatteryPill(value: batteryValue)
                }
            }

            SpeakerCabinetView(tint: WatchColors.warning, style: .side)
                .rotationEffect(.degrees(6))
                .offset(y: 10)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DashboardTileButton: View {
    let title: String
    let subtitle: String
    let systemName: String
    let tone: Color
    var emphasis: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: WatchSpacing.xSmall) {
                HStack(alignment: .top, spacing: WatchSpacing.xSmall) {
                    Image(systemName: systemName)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(tone)

                    Spacer(minLength: 0)

                    if let emphasis {
                        Text(emphasis)
                            .font(WatchTypography.caption)
                            .foregroundStyle(WatchColors.creamSoft)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(tone.opacity(0.18))
                            .clipShape(Capsule())
                    }
                }

                Spacer(minLength: 0)

                Text(title)
                    .font(WatchTypography.title)
                    .foregroundStyle(WatchColors.cream)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(subtitle)
                    .font(WatchTypography.caption)
                    .foregroundStyle(WatchColors.muted)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            .padding(WatchSpacing.small)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [tone.opacity(0.16), WatchColors.surface],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous)
                    .stroke(WatchColors.border.opacity(0.16), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct PresetRowButton: View {
    let preset: QuickPreset
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: WatchSpacing.small) {
                Image(systemName: preset.symbolName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(preset.tintColor)
                    .frame(width: 18)

                VStack(alignment: .leading, spacing: 2) {
                    Text(preset.rawValue)
                        .font(WatchTypography.body)
                        .foregroundStyle(WatchColors.cream)
                        .lineLimit(1)

                    Text(preset.subtitle)
                        .font(WatchTypography.caption)
                        .foregroundStyle(WatchColors.muted)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(WatchColors.cream)
                } else {
                    Circle()
                        .stroke(preset.tintColor.opacity(0.55), lineWidth: 1.2)
                        .frame(width: 14, height: 14)
                }
            }
            .padding(.horizontal, WatchSpacing.small)
            .padding(.vertical, WatchSpacing.small)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous)
                    .fill(isSelected ? preset.tintColor.opacity(0.18) : WatchColors.surface.opacity(0.92))
            )
            .overlay(
                RoundedRectangle(cornerRadius: WatchRadius.medium, style: .continuous)
                    .stroke((isSelected ? preset.tintColor : WatchColors.border).opacity(0.22), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private enum SpeakerCabinetStyle {
    case side
    case center
}

private struct SpeakerCabinetView: View {
    let tint: Color
    let style: SpeakerCabinetStyle

    private var speakerWidth: CGFloat {
        style == .center ? 72 : 42
    }

    private var speakerHeight: CGFloat {
        style == .center ? 96 : 58
    }

    private var cornerRadius: CGFloat {
        style == .center ? 18 : 12
    }

    private var driverSize: CGFloat {
        style == .center ? 38 : 22
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [tint.opacity(0.94), tint.opacity(0.62)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(WatchColors.border.opacity(0.22), lineWidth: 1)
            )
            .overlay(alignment: .top) {
                Circle()
                    .fill(Color.black.opacity(0.95))
                    .overlay(
                        Circle()
                            .stroke(WatchColors.cream.opacity(0.28), lineWidth: style == .center ? 2 : 1)
                    )
                    .frame(width: driverSize, height: driverSize)
                    .padding(.top, style == .center ? 9 : 6)
            }
            .overlay(alignment: .center) {
                HStack(spacing: 3) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == 1 ? WatchColors.success : WatchColors.accentGold.opacity(0.45))
                            .frame(width: style == .center ? 4 : 3, height: style == .center ? 4 : 3)
                    }
                }
                .offset(y: style == .center ? 12 : 8)
            }
            .overlay(alignment: .bottom) {
                HStack(spacing: style == .center ? 12 : 7) {
                    Circle()
                        .fill(WatchColors.cream.opacity(0.85))
                        .frame(width: style == .center ? 7 : 5, height: style == .center ? 7 : 5)

                    Capsule()
                        .fill(WatchColors.cream.opacity(0.55))
                        .frame(width: style == .center ? 20 : 11, height: 3)
                }
                .padding(.bottom, style == .center ? 8 : 6)
            }
            .frame(width: speakerWidth, height: speakerHeight)
    }
}

private struct SpeakerBatteryPill: View {
    let value: Int

    var body: some View {
        HStack(spacing: 4) {
            Text("\(value)%")
                .font(WatchTypography.caption)
                .monospacedDigit()

            Image(systemName: "bolt.fill")
                .font(.system(size: 9, weight: .bold))
        }
        .foregroundStyle(Color.black.opacity(0.82))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(WatchColors.accentGold)
        .clipShape(Capsule())
    }
}