import Foundation

struct SpeakerDisplayItem: Identifiable {
    let id: String
    let assetName: String
    let name: String
    let collectionName: String
    let battery: Int
    let isSelected: Bool
}

private struct QueueTrack {
    let title: String
    let artist: String
}

private struct SpeakerProfile {
    let name: String
    let assetName: String
    let collectionName: String
    let battery: Int
}

final class WatchSpeakerViewModel: ObservableObject {
    @Published var hasCompletedWelcome = false
    @Published private(set) var state: WatchSpeakerState

    private static let speakerProfiles: [SpeakerProfile] = [
        SpeakerProfile(name: "LivingRoom", assetName: "BlueSpeaker", collectionName: "Living room speaker", battery: 76),
        SpeakerProfile(name: "BedRoom", assetName: "RedSpeaker", collectionName: "Bed room speaker", battery: 50),
        SpeakerProfile(name: "Studio", assetName: "YellowSpeaker", collectionName: "Studio speaker", battery: 63)
    ]

    private let queue: [QueueTrack] = [
        QueueTrack(title: "Balance", artist: "Sona Jobarteh"),
        QueueTrack(title: "For You", artist: "Selena Gomez")
    ]

    private var currentTrackIndex: Int
    private var currentSpeakerIndex: Int

    init(service: MockSpeakerService = MockSpeakerService()) {
        let initialState = service.loadInitialState()

        self.state = initialState
        self.currentTrackIndex = 0
        self.currentSpeakerIndex = Self.speakerProfiles.firstIndex(where: {
            $0.name.caseInsensitiveCompare(initialState.selectedSpeakerName) == .orderedSame ||
            $0.name.caseInsensitiveCompare(initialState.roomName) == .orderedSame
        }) ?? 0

        applyDebugLaunchOptions()

        if let matchingIndex = queue.firstIndex(where: { $0.title == state.nowPlayingTitle }) {
            self.currentTrackIndex = matchingIndex
        }

        syncSelectedSpeaker()
        syncCurrentTrack()
    }

    var speakerCarousel: [SpeakerDisplayItem] {
        [-1, 0, 1].map { offset in
            let index = wrappedSpeakerIndex(currentSpeakerIndex + offset)
            let speaker = Self.speakerProfiles[index]

            return SpeakerDisplayItem(
                id: speaker.name,
                assetName: speaker.assetName,
                name: speaker.name,
                collectionName: speaker.collectionName,
                battery: speaker.battery,
                isSelected: offset == 0
            )
        }
    }

    func continueFromWelcome() {
        hasCompletedWelcome = true
    }

    func togglePlayback() {
        if state.playbackStatus == .playing {
            state.playbackStatus = .paused
            return
        }

        if state.isMuted {
            state.isMuted = false
        }

        state.playbackStatus = .playing
    }

    func increaseVolume() {
        state.volume = min(state.volume + 5, 100)
        if state.volume > 0 {
            state.isMuted = false
        }
    }

    func decreaseVolume() {
        state.volume = max(state.volume - 5, 0)
        if state.volume == 0 {
            state.isMuted = true
        }
    }

    func applyPreset(_ preset: QuickPreset) {
        state.preset = preset
    }

    func setSyncStatus(_ status: SyncStatus) {
        state.syncStatus = status
    }

    func toggleConnection() {
        state.syncStatus = state.syncStatus == .disconnected ? .connected : .disconnected
    }

    func toggleMute() {
        if state.isMuted {
            state.isMuted = false
            if state.volume == 0 {
                state.volume = 35
            }
            return
        }

        state.isMuted = true
    }

    func nextTrack() {
        guard !queue.isEmpty else { return }
        currentTrackIndex = (currentTrackIndex + 1) % queue.count
        syncCurrentTrack()
    }

    func previousTrack() {
        guard !queue.isEmpty else { return }
        currentTrackIndex = (currentTrackIndex - 1 + queue.count) % queue.count
        syncCurrentTrack()
    }

    func nextSpeaker() {
        currentSpeakerIndex = wrappedSpeakerIndex(currentSpeakerIndex + 1)
        syncSelectedSpeaker()
        syncCurrentTrack()
    }

    func previousSpeaker() {
        currentSpeakerIndex = wrappedSpeakerIndex(currentSpeakerIndex - 1)
        syncSelectedSpeaker()
        syncCurrentTrack()
    }

    private func syncCurrentTrack() {
        let track = queue[currentTrackIndex]
        state.nowPlayingTitle = track.title
        state.nowPlayingArtist = track.artist
        state.nowPlayingCollection = Self.speakerProfiles[currentSpeakerIndex].collectionName
    }

    private func syncSelectedSpeaker() {
        let speaker = Self.speakerProfiles[currentSpeakerIndex]
        state.selectedSpeakerName = speaker.name
        state.roomName = speaker.name
        state.speakerBattery = speaker.battery
        state.nowPlayingCollection = speaker.collectionName
    }

    private func applyDebugLaunchOptions() {
        let options = DebugLaunchOptions.current

        if let syncStatus = options.syncStatus {
            state.syncStatus = syncStatus
        }

        if let preset = options.preset {
            state.preset = preset
        }

        if let playbackStatus = options.playbackStatus {
            state.playbackStatus = playbackStatus
        }

        if let speaker = options.speaker {
            switch speaker {
            case .livingRoom:
                currentSpeakerIndex = 0
            case .bedRoom:
                currentSpeakerIndex = 1
            case .studio:
                currentSpeakerIndex = 2
            }
        }

        switch options.track {
        case .sona:
            currentTrackIndex = 0
        case .selena:
            currentTrackIndex = 1
        case nil:
            break
        }
    }

    private func wrappedSpeakerIndex(_ index: Int) -> Int {
        let count = Self.speakerProfiles.count
        return (index % count + count) % count
    }
}