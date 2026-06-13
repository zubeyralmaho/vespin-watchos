import Foundation

struct MockSpeakerService {
    func loadInitialState() -> WatchSpeakerState {
        WatchSpeakerState(
            selectedSpeakerName: "BedRoom",
            speakerModelName: "Vesper Sonic",
            roomName: "BedRoom",
            nowPlayingTitle: "Balance",
            nowPlayingArtist: "Sona Jobarteh",
            nowPlayingCollection: "Living room speaker",
            playbackStatus: .playing,
            volume: 50,
            preset: .none,
            speakerBattery: 50,
            watchBattery: 91,
            syncStatus: .connected,
            isMuted: false
        )
    }
}