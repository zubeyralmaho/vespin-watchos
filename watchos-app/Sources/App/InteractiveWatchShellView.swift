import SwiftUI

enum WatchInteractionScreen: String, Hashable {
    case quickPresets
    case dashboard
    case nowPlaying
    case speakersConnected
    case speakersBattery
}

struct InteractiveWatchShellView: View {
    @State private var currentScreen: WatchInteractionScreen

    init() {
        _currentScreen = State(initialValue: DebugLaunchOptions.current.initialScreen ?? .dashboard)
    }

    var body: some View {
        ZStack {
            screenView(for: currentScreen)
        }
    }

    @ViewBuilder
    private func screenView(for screen: WatchInteractionScreen) -> some View {
        switch screen {
        case .quickPresets:
            QuickPresetsView(currentScreen: $currentScreen)
        case .dashboard:
            ConnectedSpeakerView(currentScreen: $currentScreen)
        case .nowPlaying:
            NowPlayingView(currentScreen: $currentScreen)
        case .speakersConnected:
            StatusView(currentScreen: $currentScreen, mode: .connected)
        case .speakersBattery:
            StatusView(currentScreen: $currentScreen, mode: .battery)
        }
    }
}