import SwiftUI

private enum WelcomeOpeningPhase: Equatable {
    case idle
    case connecting
    case connected

    var title: String {
        switch self {
        case .idle:
            return "Tap to connect"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        }
    }

    var footer: String {
        switch self {
        case .idle:
            return "Tap It!"
        case .connecting, .connected:
            return ""
        }
    }
}

private enum WelcomeOpeningPalette {
    static let background = Color(red: 0.97, green: 0.95, blue: 0.92)
    static let header = Color.black.opacity(0.88)
    static let titleWarm = Color(red: 0.62, green: 0.25, blue: 0.20)
    static let titleCool = Color(red: 0.47, green: 0.57, blue: 0.39)
    static let caption = Color(red: 0.77, green: 0.76, blue: 0.72)
    static let vinyl = Color(red: 0.08, green: 0.08, blue: 0.09)
    static let groove = Color.white.opacity(0.055)
    static let label = Color(red: 0.58, green: 0.10, blue: 0.09)
    static let labelDark = Color(red: 0.43, green: 0.08, blue: 0.08)
    static let arm = Color(red: 0.98, green: 0.97, blue: 0.95)
    static let ringWarm = Color(red: 0.88, green: 0.80, blue: 0.76)
    static let ringCool = Color(red: 0.73, green: 0.82, blue: 0.71)
}

struct WelcomeView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel
    @State private var phase: WelcomeOpeningPhase = .idle
    @State private var connectionProgress: CGFloat = 0
    @State private var connectionTask: Task<Void, Never>?

    var body: some View {
        GeometryReader { proxy in
            let artSize = min(proxy.size.width * 0.90, proxy.size.height * 0.68)

            ZStack {
                WelcomeOpeningPalette.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerRow
                        .padding(.top, 4)

                    Text(phase.title)
                        .font(.system(size: 15, weight: .regular, design: .rounded).italic())
                        .foregroundStyle(phase == .connected ? WelcomeOpeningPalette.titleCool : WelcomeOpeningPalette.titleWarm)
                        .padding(.top, 6)

                    Spacer(minLength: 8)

                    TurntableConnectionArt(
                        phase: phase,
                        progress: connectionProgress
                    )
                    .frame(width: artSize, height: artSize)

                    Spacer(minLength: 10)

                    Text(phase.footer)
                        .font(.system(size: 8, weight: .medium, design: .rounded))
                        .foregroundStyle(WelcomeOpeningPalette.caption)
                        .opacity(phase.footer.isEmpty ? 0 : 1)
                        .padding(.bottom, 6)
                }
                .padding(.horizontal, 16)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                handleTap()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            connectionTask?.cancel()
            connectionTask = nil
        }
    }

    private var headerRow: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(WelcomeOpeningPalette.header)

            Spacer(minLength: 0)

            Text("9:41")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(WelcomeOpeningPalette.header)
                .monospacedDigit()
        }
    }

    private func handleTap() {
        guard phase == .idle, connectionTask == nil else { return }

        phase = .connecting
        connectionProgress = 0.10

        connectionTask = Task {
            let marks: [CGFloat] = [0.22, 0.36, 0.51, 0.67, 0.82, 0.96]

            for mark in marks {
                try? await Task.sleep(nanoseconds: 170_000_000)
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.16)) {
                        connectionProgress = mark
                    }
                }
            }

            try? await Task.sleep(nanoseconds: 160_000_000)
            guard !Task.isCancelled else { return }

            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.24)) {
                    connectionProgress = 1.0
                    phase = .connected
                }
            }

            try? await Task.sleep(nanoseconds: 900_000_000)
            guard !Task.isCancelled else { return }

            await MainActor.run {
                viewModel.continueFromWelcome()
            }
        }
    }
}

private struct TurntableConnectionArt: View {
    let phase: WelcomeOpeningPhase
    let progress: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let discSize = size * 0.72

            ZStack {
                if phase != .idle {
                    ConnectionRingLayer(
                        color: phase == .connected ? WelcomeOpeningPalette.ringCool : WelcomeOpeningPalette.ringWarm,
                        progress: progress,
                        lineWidth: size * 0.028,
                        dash: [size * 0.17, size * 0.06],
                        diameter: size * 0.90,
                        rotation: -101
                    )

                    ConnectionRingLayer(
                        color: phase == .connected ? WelcomeOpeningPalette.ringCool : WelcomeOpeningPalette.ringWarm,
                        progress: progress * 0.96,
                        lineWidth: size * 0.026,
                        dash: [size * 0.15, size * 0.055],
                        diameter: size * 1.04,
                        rotation: -72
                    )

                    ConnectionRingLayer(
                        color: phase == .connected ? WelcomeOpeningPalette.ringCool : WelcomeOpeningPalette.ringWarm,
                        progress: progress * 0.92,
                        lineWidth: size * 0.024,
                        dash: [size * 0.13, size * 0.05],
                        diameter: size * 1.18,
                        rotation: -122
                    )
                }

                TurntableDisc(size: discSize)

                TonearmView(size: discSize)
                    .offset(x: discSize * 0.28, y: discSize * 0.10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct ConnectionRingLayer: View {
    let color: Color
    let progress: CGFloat
    let lineWidth: CGFloat
    let dash: [CGFloat]
    let diameter: CGFloat
    let rotation: Double

    var body: some View {
        Circle()
            .trim(from: 0.03, to: min(0.97, 0.03 + max(progress, 0.0) * 0.94))
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .butt,
                    dash: dash
                )
            )
            .rotationEffect(.degrees(rotation))
            .frame(width: diameter, height: diameter)
            .opacity(0.96)
    }
}

private struct TurntableDisc: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.black.opacity(0.9), WelcomeOpeningPalette.vinyl],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )

            ForEach(0..<7, id: \.self) { index in
                Circle()
                    .stroke(WelcomeOpeningPalette.groove, lineWidth: max(0.8, size * 0.008))
                    .padding(size * 0.035 + CGFloat(index) * size * 0.034)
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [WelcomeOpeningPalette.label, WelcomeOpeningPalette.labelDark],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.32
                    )
                )
                .frame(width: size * 0.62, height: size * 0.62)

            Circle()
                .fill(WelcomeOpeningPalette.vinyl)
                .frame(width: size * 0.24, height: size * 0.24)

            Circle()
                .fill(WelcomeOpeningPalette.background)
                .frame(width: size * 0.05, height: size * 0.05)
        }
        .frame(width: size, height: size)
        .shadow(color: Color.black.opacity(0.10), radius: 4, x: 0, y: 2)
    }
}

private struct TonearmView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.black.opacity(0.14))
                .frame(width: size * 0.37, height: size * 0.032)
                .offset(x: 2, y: 2)

            Capsule()
                .fill(WelcomeOpeningPalette.arm)
                .frame(width: size * 0.37, height: size * 0.032)

            RoundedRectangle(cornerRadius: size * 0.012, style: .continuous)
                .fill(WelcomeOpeningPalette.arm)
                .frame(width: size * 0.12, height: size * 0.056)
                .offset(x: -size * 0.09, y: size * 0.055)

            Rectangle()
                .fill(WelcomeOpeningPalette.arm)
                .frame(width: size * 0.016, height: size * 0.08)
                .offset(x: -size * 0.145, y: size * 0.08)
                .rotationEffect(.degrees(26))
        }
        .rotationEffect(.degrees(-54))
    }
}
