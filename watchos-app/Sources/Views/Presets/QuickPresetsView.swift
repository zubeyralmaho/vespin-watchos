import SwiftUI

struct QuickPresetsView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel
    @Binding var currentScreen: WatchInteractionScreen

    var body: some View {
        ZStack {
            WatchScreenBackground()

            VStack(spacing: 6) {
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
                    .padding(.leading, 8)

                    Spacer(minLength: 0)
                }

                VStack(spacing: 6) {
                    ForEach(QuickPreset.allCases) { preset in
                        Button {
                            viewModel.applyPreset(preset)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentScreen = .dashboard
                            }
                        } label: {
                            HStack {
                                Text(preset.rawValue)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                    .shadow(color: Color.white.opacity(0.55), radius: 6)

                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(viewModel.state.preset == preset
                                        ? WatchColors.accentRed
                                        : Color(red: 0.14, green: 0.14, blue: 0.14))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .frame(height: 32)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 6)
        }
    }

}