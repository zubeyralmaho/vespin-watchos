import SwiftUI

@main
struct VespinWatchApp: App {
    @StateObject private var viewModel = WatchSpeakerViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel)
        }
    }
}