import SwiftUI

struct QuickPresetsView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel
    @Binding var currentScreen: WatchInteractionScreen

    var body: some View {
        GeometryReader { proxy in
            let rowHeight = proxy.size.height >= 220
                ? min(max(proxy.size.height * 0.145, 38), 50)
                : min(max(proxy.size.height * 0.125, 34), 44)

            ZStack {
                WatchScreenBackground()

                VStack(spacing: 10) {
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentScreen = .dashboard
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 22, weight: .regular))

                                Image(systemName: "slider.vertical.3")
                                    .font(.system(size: 18, weight: .regular))
                            }
                            .foregroundStyle(Color.white)
                        }
                        .buttonStyle(.plain)

                        Spacer(minLength: 0)

                        topNavButton(systemName: "house.fill") {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentScreen = .dashboard
                            }
                        }
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(QuickPreset.allCases) { preset in
                                Button {
                                    viewModel.applyPreset(preset)
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        currentScreen = .dashboard
                                    }
                                } label: {
                                    HStack {
                                        Text(preset.rawValue)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.white)
                                            .shadow(color: Color.white.opacity(0.55), radius: 6)

                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal, 18)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(Color(red: 0.14, green: 0.14, blue: 0.14))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                                .frame(height: rowHeight)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)
            }
        }
    }

    private func topNavButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 52, height: 52)

                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 30, height: 30)

                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.white)
            }
        }
        .buttonStyle(.plain)
        .frame(width: 52, height: 52)
        .contentShape(Rectangle())
    }
}