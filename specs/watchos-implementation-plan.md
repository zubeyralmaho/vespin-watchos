# Feature: Apple Watch Implementation Plan

## Summary

For this team, the easiest way to build a real smartwatch application is to
create a separate Apple Watch app using SwiftUI and Xcode.

The current mobile app should remain in the existing Expo + React Native
frontend. The watch experience should be implemented as a separate native app,
not embedded into the Expo project.

This plan gives the team a real watchOS application while still respecting the
course-project scope: the watch app is real, but the speaker behavior it
controls remains simulated.

## Why This Is The Easiest Path

The team is working on a Mac. Because of that, Apple Watch development has the
lowest setup cost.

Reasons:

1. Xcode includes the watchOS SDK and simulator.
2. SwiftUI is the standard and fastest way to build small watch interfaces.
3. There is no need to fight Expo limitations for watch targets.
4. UI prototyping for watch screens is much faster in SwiftUI than trying to
   force a cross-platform mobile stack into a watch workflow.
5. The watch app can be demonstrated in the simulator even without a physical
   Apple Watch.

## Recommended Product Direction

Build a real Apple Watch companion app for Vespin.

The watch app should support fast, glanceable speaker controls rather than full
feature parity with the phone app.

The core value of the watch app is quick interaction in a few seconds:

1. See the connected speaker.
2. See now playing information.
3. Play or pause.
4. Skip track.
5. Adjust volume.
6. Apply a quick EQ preset.
7. Check speaker connection and battery state.

## Scope Boundaries

This implementation plan must still follow the repository scope rules.

Allowed:

1. Real watchOS UI.
2. Real native SwiftUI screens.
3. Real app navigation.
4. Real networking to the existing backend when needed.
5. Simulated speaker control state.

Not allowed for this course scope:

1. Real Bluetooth or BLE communication.
2. Real speaker discovery.
3. Real audio playback control over hardware.
4. Real firmware updates.
5. Push notifications infrastructure.

The watch app is real. The hardware behavior behind it is still simulated.

## Recommended Architecture

### Separation of projects

Keep the current structure as-is for phone development:

- `backend/` stays the backend.
- `frontend/` stays the Expo phone app.

Add a separate native watch project alongside them:

```text
vespin/
├── backend/
├── frontend/
├── specs/
└── watchos-app/
```

Do not try to place the watch app inside the Expo app.

### App ownership

The watch app should be its own client surface.

It can evolve in three stages:

1. Mock-first watch app
2. Backend-connected watch app
3. Optional iPhone companion sync later

This keeps delivery practical.

## Platform Choice

### Recommended now

- Apple Watch
- SwiftUI
- Xcode
- watchOS simulator

### Not recommended for first implementation

- Wear OS as the first target
- React Native watch experiments
- Expo-based watch targets

Wear OS can be considered later only if the team needs a second platform.

## Development Strategy

### Phase 0: Setup

Create a new watchOS app project in Xcode.

Recommended initial choices:

1. SwiftUI app lifecycle.
2. Standalone watch app structure.
3. Minimal dependency footprint.
4. Mock data enabled from day one.

The goal of this phase is simply to get a runnable watch app in the simulator.

### Phase 1: Static UI

Implement the watch screens visually first.

Do not connect to the backend yet.

Focus on:

1. Screen structure.
2. Layout proportions.
3. Navigation.
4. Watch-specific typography sizing.
5. Color system matching the Vespin concept.

At the end of this phase, the team should have a navigable watch prototype.

### Phase 2: Local Interaction Logic

Add local state for:

1. Speaker name.
2. Playback status.
3. Volume.
4. Quick preset.
5. Connection status.
6. Battery level.

This phase makes the watch app feel real before any backend dependency exists.

### Phase 3: Backend Integration

Once the watch UI is stable, connect it to the existing backend where useful.

Good candidates for backend integration:

1. Fetching device list.
2. Fetching selected device details.
3. Reading EQ profiles.
4. Reading simulated device status.

Poor candidates for backend integration at this stage:

1. Realtime playback sync.
2. Socket-based communication.
3. Native Bluetooth communication.

Use lightweight request-response flows only.

### Phase 4: Presentation Polish

After the app works end-to-end, add:

1. Smooth transitions.
2. Better loading and empty states.
3. Better icons.
4. Small haptic-inspired interaction cues if desired.
5. Demo mode support.

## Screen Plan

### Screen 1: Welcome

Purpose:
Introduce the watch app and Vespin brand.

Content:

1. Vespin mark.
2. Short message.
3. Continue action.

### Screen 2: Connected Speaker

Purpose:
Show the currently selected speaker.

Content:

1. Speaker name.
2. Connection badge.
3. Battery indicator.
4. Jump to controls.

### Screen 3: Now Playing

Purpose:
Main watch control screen.

Content:

1. Track title.
2. Play or pause.
3. Previous and next.
4. Quick volume actions.

### Screen 4: Remote Controls

Purpose:
Expanded quick controls.

Content:

1. Volume up.
2. Volume down.
3. Mute if desired.
4. Device state summary.

### Screen 5: Quick Presets

Purpose:
Allow fast sound-mode switching.

Content:

1. Chill.
2. Bass.
3. Focus.
4. Acoustic.

### Screen 6: Status

Purpose:
Show device health information.

Content:

1. Connection state.
2. Speaker battery.
3. Watch battery.
4. Last sync information.

## Recommended State Model

The watch app should begin with local state.

Suggested model:

```swift
struct WatchSpeakerState {
    var selectedSpeakerName: String
    var playbackStatus: PlaybackStatus
    var nowPlayingTitle: String
    var volume: Int
    var preset: QuickPreset
    var speakerBattery: Int
    var watchBattery: Int
    var syncStatus: SyncStatus
}

enum PlaybackStatus {
    case playing
    case paused
}

enum QuickPreset {
    case chill
    case bass
    case focus
    case acoustic
}

enum SyncStatus {
    case connected
    case syncing
    case weak
    case disconnected
}
```

This can later be backed by service calls.

## Recommended SwiftUI Structure

Suggested project layout:

```text
watchos-app/
├── VespinWatchApp.swift
├── Models/
│   ├── WatchSpeakerState.swift
│   └── WatchPreset.swift
├── ViewModels/
│   └── WatchSpeakerViewModel.swift
├── Views/
│   ├── Welcome/
│   ├── Speaker/
│   ├── Playback/
│   ├── Presets/
│   └── Status/
├── Components/
│   ├── StatusBadge.swift
│   ├── ControlButton.swift
│   ├── MiniNowPlaying.swift
│   └── BatteryRing.swift
└── Services/
    ├── MockSpeakerService.swift
    └── BackendService.swift
```

## Xcode Project Setup

Create the watch app in Xcode with these choices:

1. Open Xcode.
2. Choose New Project.
3. Select watchOS.
4. Choose App.
5. Product name: `VespinWatch`.
6. Interface: SwiftUI.
7. Language: Swift.
8. Lifecycle: SwiftUI App.
9. Save the project as `watchos-app/` next to `frontend/` and `backend/`.

Recommended project settings:

1. Keep the watch app standalone for the first version.
2. Use a bundle identifier related to `com.vespin.watch`.
3. Start with the latest stable watchOS target available in Xcode.
4. Do not add third-party packages in the first pass.

## Figma To SwiftUI Workflow

The watch app should be built in SwiftUI by using Figma as a design source,
not as a direct one-click code generator.

That distinction is important.

For this project, the recommended workflow is:

1. Use Figma to inspect layout, sizes, spacing, colors, and assets.
2. Export visual assets from Figma.
3. Rebuild the UI manually in SwiftUI.
4. Use the exported assets only where they are truly images or icons.

Do not rely on automatic "Figma to app" generation for the final watch app.
Auto-generated SwiftUI usually creates poor hierarchy, too much absolute
positioning, and code that becomes hard to maintain.

### What should be imported from Figma

Import these from Figma:

1. Icons
2. Brand marks
3. Album art placeholders
4. Background illustrations if any
5. Exact color values
6. Typography sizes and weights
7. Spacing and padding measurements
8. Component states

### What should be rebuilt in SwiftUI

Rebuild these directly in code:

1. Screen layouts
2. Navigation
3. Buttons
4. Pills and chips
5. Playback controls
6. Status indicators
7. Rings, circles, and control dials when possible

If a Figma element is geometric and simple, it is better to redraw it in
SwiftUI than to import it as a flattened image.

## Recommended Figma Export Process

For each watch screen in Figma:

1. Export the full frame as PNG for visual reference only.
2. Export icons as SVG if they are vector-based.
3. Export static artwork as PNG or PDF depending on quality needs.
4. Record the frame size.
5. Record spacing values between major elements.
6. Record text styles used on that frame.

Recommended folder structure inside `watchos-app/`:

```text
watchos-app/
├── Assets.xcassets/
│   ├── Brand/
│   ├── Icons/
│   ├── Artwork/
│   └── AlbumCovers/
```

## How To Translate One Figma Screen

For each Figma watch screen, follow this sequence:

### Step 1: Freeze the frame

Choose one frame only.

For example:

1. Welcome
2. Now Playing
3. EQ Presets

Do not try to implement all frames at once.

### Step 2: Extract a layout map

Write down the screen as a stack of regions:

1. top status area
2. title area
3. main circular control area
4. album or artwork strip
5. bottom controls

This becomes the SwiftUI layout plan.

### Step 3: Build the layout with stacks first

Start with:

1. `VStack`
2. `HStack`
3. `ZStack`
4. `Spacer`
5. `padding`

Do not begin with custom graphics or animation.

### Step 4: Replace placeholders gradually

Use simple shapes and placeholder text first.

Then replace them with:

1. exported assets
2. custom buttons
3. styled text
4. ring/dial components

### Step 5: Add behavior only after the screen matches visually

Do not mix visual reconstruction and state logic too early.

## Figma Dev Mode Usage

If Dev Mode is available, use it to collect:

1. frame dimensions
2. spacing values
3. font sizes
4. color hex values
5. border radius values

But still write the SwiftUI manually.

Dev Mode should be treated as measurement help, not as production code output.

## SwiftUI Implementation Strategy For Figma Screens

### Layer 1: Design tokens

Create watch-specific tokens first:

1. colors
2. spacing
3. corner radius
4. font styles

Suggested structure:

```text
watchos-app/
├── Theme/
│   ├── WatchColors.swift
│   ├── WatchSpacing.swift
│   ├── WatchTypography.swift
│   └── WatchRadius.swift
```

### Layer 2: Reusable components

Turn repeated Figma pieces into components:

1. `WatchPrimaryButton`
2. `WatchStatusBadge`
3. `WatchPlaybackControls`
4. `WatchPresetPill`
5. `WatchBatteryRing`

### Layer 3: Full screens

Build screens by composing those parts.

This is much easier to maintain than exporting a full Figma frame and placing
it as one image.

## What Not To Do

Avoid these mistakes:

1. Importing the whole screen as a single screenshot.
2. Building every element with manual absolute coordinates.
3. Mixing exported image text with native text.
4. Trying to auto-convert the whole Figma file into final SwiftUI.
5. Solving animation before layout is stable.

## Best Practical Workflow

For this project, the best practical process is:

1. Open Figma.
2. Pick one watch frame.
3. Export assets.
4. Copy measurements.
5. Build the screen in SwiftUI manually.
6. Compare side by side with the exported PNG.
7. Only after matching the design, move to the next screen.

## Recommendation For This Team

If the goal is "I want to do this in Xcode with SwiftUI by importing from
Figma," the correct interpretation should be:

1. Import assets and measurements from Figma.
2. Implement the interface manually in SwiftUI.
3. Use Figma as the visual source of truth.

That is the easiest, cleanest, and most maintainable way to build the Apple
Watch app.

## Screen Navigation Tree

Use a shallow flow. The watch app should avoid deep navigation.

```text
WelcomeView
  -> ConnectedSpeakerView
      -> NowPlayingView
          -> RemoteControlsView
          -> QuickPresetsView
          -> StatusView
```

Recommended navigation behavior:

1. `WelcomeView` appears only on the first launch or demo reset.
2. `ConnectedSpeakerView` confirms the selected device and current sync state.
3. `NowPlayingView` acts as the main hub.
4. `RemoteControlsView`, `QuickPresetsView`, and `StatusView` should be reachable in one tap from the main hub.

## Starter File Responsibilities

### `VespinWatchApp.swift`

Purpose:
Create the app entry point and inject the shared view model.

### `RootView.swift`

Purpose:
Control the first screen and decide whether the user sees the welcome screen or
goes directly into the watch experience.

### `WatchSpeakerViewModel.swift`

Purpose:
Store and mutate all simulated watch state for the first implementation.

### `MockSpeakerService.swift`

Purpose:
Provide static speaker and playback data until backend integration is added.

### `WelcomeView.swift`

Purpose:
Display the Vespin watch intro and route the user into the app.

### `NowPlayingView.swift`

Purpose:
Serve as the primary smartwatch control surface.

## Starter SwiftUI Skeleton

Use this as the initial structure.

### `VespinWatchApp.swift`

```swift
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
```

### `RootView.swift`

```swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel

    var body: some View {
        NavigationStack {
            if viewModel.hasCompletedWelcome {
                NowPlayingView()
            } else {
                WelcomeView()
            }
        }
    }
}
```

### `WatchSpeakerViewModel.swift`

```swift
import Foundation

final class WatchSpeakerViewModel: ObservableObject {
    @Published var hasCompletedWelcome = false
    @Published var selectedSpeakerName = "Speaker 1"
    @Published var nowPlayingTitle = "Josef"
    @Published var playbackStatus: PlaybackStatus = .playing
    @Published var volume = 68
    @Published var preset: QuickPreset = .chill
    @Published var speakerBattery = 82
    @Published var watchBattery = 91
    @Published var syncStatus: SyncStatus = .connected

    func continueFromWelcome() {
        hasCompletedWelcome = true
    }

    func togglePlayback() {
        playbackStatus = playbackStatus == .playing ? .paused : .playing
    }

    func increaseVolume() {
        volume = min(volume + 5, 100)
    }

    func decreaseVolume() {
        volume = max(volume - 5, 0)
    }

    func applyPreset(_ preset: QuickPreset) {
        self.preset = preset
    }
}
```

### `WelcomeView.swift`

```swift
import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Vespin")
                .font(.headline)
            Text("Control your speaker from your wrist.")
                .font(.caption)
                .multilineTextAlignment(.center)
            Button("Continue") {
                viewModel.continueFromWelcome()
            }
            Spacer()
        }
        .padding()
    }
}
```

### `NowPlayingView.swift`

```swift
import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var viewModel: WatchSpeakerViewModel

    var body: some View {
        VStack(spacing: 10) {
            Text(viewModel.selectedSpeakerName)
                .font(.caption2)

            Text(viewModel.nowPlayingTitle)
                .font(.headline)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button("-") {
                    viewModel.decreaseVolume()
                }

                Button(viewModel.playbackStatus == .playing ? "Pause" : "Play") {
                    viewModel.togglePlayback()
                }

                Button("+") {
                    viewModel.increaseVolume()
                }
            }

            NavigationLink("Presets") {
                QuickPresetsView()
            }

            NavigationLink("Status") {
                StatusView()
            }
        }
        .padding()
    }
}
```

## Recommended Build Sequence

Build in this order so the team avoids design drift:

1. Make the Xcode project run in the watch simulator.
2. Add `VespinWatchApp.swift`, `RootView.swift`, and `WatchSpeakerViewModel.swift`.
3. Build `WelcomeView`.
4. Build `NowPlayingView`.
5. Add `QuickPresetsView` and `StatusView`.
6. Replace plain text controls with the final Figma-inspired components.
7. Connect read-only backend data only after the static flow is stable.

## Figma Translation Strategy

When implementing the Figma screens, translate them in three layers:

1. Layout layer:
   screen proportions, padding, stacks, and navigation flow.
2. Component layer:
   playback buttons, rings, badges, and preset pills.
3. State layer:
   connected, playing, paused, syncing, and disconnected variants.

Do not start by reproducing every visual detail. First match the layout and
interaction model, then add styling polish.

## Data Strategy

### First implementation

Use mock data.

Why:

1. Faster iteration.
2. No backend contract changes required.
3. Better for early demos and HCI testing.

### Second implementation

Add simple backend reads.

Recommended backend usage:

1. Get speaker list.
2. Get selected speaker details.
3. Read EQ profile information.

### Third implementation

If needed, simulate remote actions against local watch state and optionally log
those actions for demo consistency.

## UI Guidance For watchOS

The watch UI should not try to reproduce the full phone app.

Use these rules:

1. One primary action per screen.
2. Large touch targets.
3. Short labels.
4. Glanceable content.
5. Very limited text entry.
6. Minimal navigation depth.

If a flow becomes too complex on the watch, hand it back to the phone app.

## Integration Options

### Option A: Standalone watch demo app

Best for speed.

Characteristics:

1. Uses local mock data.
2. No phone-app dependency.
3. Best for fast HCI presentation.

### Option B: Watch app with backend reads

Best for stronger technical demo.

Characteristics:

1. Reads real device rows from backend.
2. Still simulates playback behavior.
3. Good balance between realism and scope.

### Option C: Full phone-watch sync layer

Not recommended for the first version.

Characteristics:

1. More native complexity.
2. Requires iPhone companion coordination.
3. Higher debugging cost.

## Best Recommended Option

For this team, use Option B as the target and Option A as the starting point.

Meaning:

1. Build the watch app as a real native watchOS app.
2. Start with local mock data.
3. Then connect it to the backend for device and status reads.
4. Keep all speaker control behavior simulated.

## Risks

1. Trying to support both Apple Watch and Wear OS at the same time.
2. Trying to force the watch into the Expo app.
3. Spending time on Bluetooth or hardware communication.
4. Making the watch UI too similar to the phone UI.
5. Adding too many screens before the core remote-control flow is stable.

## Milestone Plan

### Milestone 1

1. Create Xcode watchOS project.
2. Run simulator successfully.
3. Build welcome and now-playing screens.

### Milestone 2

1. Add playback state.
2. Add volume controls.
3. Add quick preset screen.

### Milestone 3

1. Add status screen.
2. Connect to backend read endpoints.
3. Polish navigation and visuals.

### Milestone 4

1. Prepare demo mode.
2. Record usage scenario.
3. Validate top user tasks.

## Immediate Next Steps

1. Create `watchos-app/` as a new Xcode project.
2. Build the Welcome screen.
3. Build the Now Playing screen.
4. Add local mock state.
5. Recreate one Figma watch screen faithfully before expanding the rest.

## Success Criteria

This plan is successful if:

1. The team ships a real runnable Apple Watch app.
2. The core speaker-control experience is demonstrated clearly.
3. The app feels believable without requiring real hardware connectivity.
4. The scope stays aligned with the HCI course constraints.