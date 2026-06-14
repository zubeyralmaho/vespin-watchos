import SwiftUI

enum StatusViewMode {
    case connected
    case battery
}

struct StatusView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel
    @Binding var currentScreen: WatchInteractionScreen
    let mode: StatusViewMode

    var body: some View {
        ZStack {
            WatchScreenBackground()

            GeometryReader { proxy in
                let speakerUnit = min(proxy.size.width, proxy.size.height * 0.78)

                VStack(spacing: 0) {
                    HStack {
                        Button {
                            navigate(to: mode == .battery ? .speakersConnected : .dashboard)
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 22, weight: .regular))
                                Image(systemName: "hifispeaker.fill")
                                    .font(.system(size: 16, weight: .regular))
                            }
                            .foregroundStyle(Color.white)
                        }
                        .buttonStyle(.plain)

                        Spacer(minLength: 0)
                    }

                    Text(viewModel.state.roomName)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .tracking(0.4)
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.top, 2)

                    if viewModel.state.syncStatus == .connected {
                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 10, weight: .bold))
                            Text("\(viewModel.state.speakerBattery)%")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .monospacedDigit()
                        }
                        .foregroundStyle(WatchColors.success)
                        .padding(.top, 1)
                    }

                    speakerCarousel(unit: speakerUnit)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 6)
                .padding(.bottom, 4)
            }
        }
    }

    private func speakerCarousel(unit: CGFloat) -> some View {
        let overhangReserve = unit * 0.50 * 0.6

        return HStack(alignment: .bottom, spacing: unit * 0.04) {
            ForEach(Array(viewModel.speakerCarousel.enumerated()), id: \.element.id) { index, speaker in
                speakerPedestalButton(for: speaker, slotIndex: index, unit: unit)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, overhangReserve)
        .padding(.bottom, 6)
        .animation(.easeInOut(duration: 0.18), value: viewModel.state.selectedSpeakerName)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 18)
                .onEnded { value in
                    if value.translation.width <= -28 {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            viewModel.nextSpeaker()
                        }
                    } else if value.translation.width >= 28 {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            viewModel.previousSpeaker()
                        }
                    }
                }
        )
    }

    private func speakerPedestalButton(for speaker: SpeakerDisplayItem, slotIndex: Int, unit: CGFloat) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                switch slotIndex {
                case 0: viewModel.previousSpeaker()
                case 2: viewModel.nextSpeaker()
                default: viewModel.toggleConnection()
                }
            }
        } label: {
            speakerPedestal(for: speaker, unit: unit)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func speakerPedestal(for speaker: SpeakerDisplayItem, unit: CGFloat) -> some View {
        let isSelected = speaker.isSelected
        let width: CGFloat = isSelected ? unit * 0.42 : unit * 0.20
        let height: CGFloat = isSelected ? unit * 0.50 : unit * 0.24
        let imageWidth: CGFloat = isSelected ? unit * 0.38 : unit * 0.18
        let pedestalColor = Color(red: 0.94, green: 0.91, blue: 0.87)

        return RoundedRectangle(cornerRadius: width * 0.36, style: .continuous)
            .fill(pedestalColor)
            .frame(width: width, height: height)
            .overlay(alignment: .top) {
                Image(speaker.assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth)
                    .offset(y: isSelected ? -height * 0.55 : -height * 0.38)
            }
            .overlay {
                if isSelected {
                    VStack(spacing: 3) {
                        Spacer(minLength: 0)

                        ZStack {
                            Circle()
                                .fill(viewModel.state.syncStatus == .connected
                                    ? Color(red: 0.10, green: 0.35, blue: 0.14)
                                    : Color(red: 0.22, green: 0.22, blue: 0.24))
                                .shadow(color: viewModel.state.syncStatus == .connected
                                    ? Color.green.opacity(0.5) : .clear,
                                    radius: 4)
                                .frame(width: 36, height: 36)

                            Image(systemName: "power")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(viewModel.state.syncStatus == .connected
                                    ? Color(red: 0.45, green: 0.90, blue: 0.45)
                                    : Color(red: 0.55, green: 0.55, blue: 0.57))
                        }

                        Text(viewModel.state.syncStatus == .connected ? "Connected" : "Unconnected")
                            .font(.system(size: 10, weight: .regular, design: .rounded))
                            .foregroundStyle(Color(red: 0.25, green: 0.25, blue: 0.25))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .allowsTightening(true)
                            .padding(.horizontal, 2)

                        Spacer(minLength: 5)
                    }
                }
            }
    }

    private func navigate(to screen: WatchInteractionScreen) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentScreen = screen
        }
    }
}
