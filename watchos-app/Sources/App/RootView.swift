import SwiftUI

struct RootView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel

    var body: some View {
        if viewModel.hasCompletedWelcome || DebugLaunchOptions.current.skipWelcome {
            InteractiveWatchShellView()
        } else {
            WelcomeView()
        }
    }
}