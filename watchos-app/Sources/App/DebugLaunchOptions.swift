import Foundation

struct DebugLaunchOptions {
    let skipWelcome: Bool
    let initialScreen: WatchInteractionScreen?
    let syncStatus: SyncStatus?
    let preset: QuickPreset?
    let playbackStatus: PlaybackStatus?
    let track: DebugTrack?
    let speaker: DebugSpeaker?

    enum DebugTrack {
        case sona
        case selena
    }

    enum DebugSpeaker {
        case livingRoom
        case bedRoom
        case studio
    }

    static let current = DebugLaunchOptions(environment: ProcessInfo.processInfo.environment)

    init(environment: [String: String]) {
        skipWelcome = environment["VESPIN_DEBUG_SKIP_WELCOME"] == "1"
        initialScreen = WatchInteractionScreen(environmentValue: environment["VESPIN_DEBUG_SCREEN"])
        syncStatus = SyncStatus(environmentValue: environment["VESPIN_DEBUG_SYNC_STATUS"])
        preset = QuickPreset(environmentValue: environment["VESPIN_DEBUG_PRESET"])
        playbackStatus = PlaybackStatus(environmentValue: environment["VESPIN_DEBUG_PLAYBACK"])

        switch environment["VESPIN_DEBUG_TRACK"]?.lowercased() {
        case "sona", "balance":
            track = .sona
        case "selena", "foryou", "for-you":
            track = .selena
        default:
            track = nil
        }

        switch environment["VESPIN_DEBUG_SPEAKER"]?.lowercased() {
        case "living", "livingroom", "living-room", "blue":
            speaker = .livingRoom
        case "bed", "bedroom", "bed-room", "red":
            speaker = .bedRoom
        case "studio", "yellow":
            speaker = .studio
        default:
            speaker = nil
        }
    }
}

extension WatchInteractionScreen {
    init?(environmentValue: String?) {
        switch environmentValue?.lowercased() {
        case "eq", "quickpresets", "quick-presets", "presets":
            self = .quickPresets
        case "dashboard", "home":
            self = .dashboard
        case "nowplaying", "now-playing", "song":
            self = .nowPlaying
        case "speakers", "speaker", "speakersconnected", "speakers-connected":
            self = .speakersConnected
        case "battery", "speakersbattery", "speakers-battery":
            self = .speakersBattery
        default:
            return nil
        }
    }
}

extension SyncStatus {
    init?(environmentValue: String?) {
        switch environmentValue?.lowercased() {
        case "connected":
            self = .connected
        case "syncing":
            self = .syncing
        case "weak":
            self = .weak
        case "disconnected", "unconnected", "offline":
            self = .disconnected
        default:
            return nil
        }
    }
}

extension QuickPreset {
    init?(environmentValue: String?) {
        switch environmentValue?.lowercased() {
        case "none":
            self = .none
        case "bassboots", "bass-boots", "bass":
            self = .bassBoots
        case "rock":
            self = .rock
        case "demo":
            self = .demo
        default:
            return nil
        }
    }
}

extension PlaybackStatus {
    init?(environmentValue: String?) {
        switch environmentValue?.lowercased() {
        case "playing", "play":
            self = .playing
        case "paused", "pause":
            self = .paused
        default:
            return nil
        }
    }
}