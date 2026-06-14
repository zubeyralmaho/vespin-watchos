import Foundation

enum PlaybackStatus: String, CaseIterable {
    case playing = "Playing"
    case paused = "Paused"
}

extension PlaybackStatus {
    var symbolName: String {
        switch self {
        case .playing:
            return "pause.fill"
        case .paused:
            return "play.fill"
        }
    }
}

enum QuickPreset: String, CaseIterable, Identifiable {
    case none = "None"
    case jazz = "Jazz"
    case rock = "Rock"
    case demo = "Demo"

    var id: String { rawValue }
}

extension QuickPreset {
    var subtitle: String {
        switch self {
        case .none:
            return "Neutral house tuning"
        case .jazz:
            return "Warm and spacious tuning"
        case .rock:
            return "Sharper attack and presence"
        case .demo:
            return "Showroom speaker balance"
        }
    }

    var symbolName: String {
        switch self {
        case .none:
            return "slider.horizontal.3"
        case .jazz:
            return "music.note.list"
        case .rock:
            return "waveform.path"
        case .demo:
            return "sparkles"
        }
    }
}

enum SyncStatus: String, CaseIterable {
    case connected = "Connected"
    case syncing = "Syncing"
    case weak = "Weak"
    case disconnected = "Disconnected"
}

extension SyncStatus {
    var symbolName: String {
        switch self {
        case .connected:
            return "dot.radiowaves.left.and.right"
        case .syncing:
            return "arrow.triangle.2.circlepath"
        case .weak:
            return "wifi.exclamationmark"
        case .disconnected:
            return "wifi.slash"
        }
    }

    var detail: String {
        switch self {
        case .connected:
            return "The watch and speaker are aligned and responsive."
        case .syncing:
            return "Applying recent control changes to the speaker state."
        case .weak:
            return "Control commands may take a moment to land."
        case .disconnected:
            return "The demo is local-only until the connection returns."
        }
    }

    var shortLabel: String {
        switch self {
        case .connected:
            return "Live"
        case .syncing:
            return "Sync"
        case .weak:
            return "Weak"
        case .disconnected:
            return "Off"
        }
    }
}

struct WatchSpeakerState {
    var selectedSpeakerName: String
    var speakerModelName: String
    var roomName: String
    var nowPlayingTitle: String
    var nowPlayingArtist: String
    var nowPlayingCollection: String
    var playbackStatus: PlaybackStatus
    var volume: Int
    var preset: QuickPreset
    var speakerBattery: Int
    var watchBattery: Int
    var syncStatus: SyncStatus
    var isMuted: Bool
}