# Feature: Smartwatch Companion Simulation

## Summary

This project already treats hardware behavior as simulated rather than real.
The smartwatch work should follow the same rule: build the smartwatch as a
simulated companion control surface for the Vespin speaker, not as a real
watchOS or Wear OS app.

The primary goal is to demonstrate the user experience of controlling a Vespin
speaker from a watch-sized interface. The simulation should feel believable,
testable, and presentable in an HCI context without requiring native watch
build targets, Bluetooth integration, or live device communication.

## Recommendation

Start with a frontend-only simulation.

Do not model the smartwatch as a first-class backend device in phase 1.
The current device model is speaker-centric and only supports speaker device
types. A watch is better treated as a companion interface attached to an
already selected speaker.

This keeps scope low and lets the team validate the interaction model before
changing the API.

## Product Framing

The smartwatch experience should answer one question:

"What are the most valuable actions a user would want to perform from their
watch in under five seconds?"

The watch should not mirror the full phone app. It should focus on quick,
frequent, glanceable actions.

## Core Smartwatch Use Cases

Phase 1 should cover these flows:

1. View the currently connected speaker.
2. See now playing information at a glance.
3. Play or pause audio.
4. Skip to the next or previous track.
5. Adjust volume with quick step controls.
6. Apply a quick EQ preset such as Chill, Bass, or Focus.
7. See connection and battery status.

Phase 2 can add:

1. Find my phone.
2. Find my speaker.
3. Switch between saved speakers.
4. View recent EQ presets.
5. Trigger lightweight party mode actions.

## What To Simulate

The simulation should explicitly fake these layers:

### 1. Connectivity

- Connected
- Syncing
- Weak connection
- Disconnected

These are UI states only. No real Bluetooth work is needed.

### 2. Playback

- Playing
- Paused
- Track changed
- Volume changed
- Preset changed

This can be driven by local state and mirrored from the selected speaker.

### 3. Permissions

- Notification permission prompt
- Bluetooth permission prompt
- Background sync explanation

These should be simulated as onboarding or setup states, not real OS flows.

### 4. Device Health

- Speaker battery
- Watch battery
- Last synced time
- Firmware status badge if desired

## UX Principles

The smartwatch UI should follow these rules:

1. One main action per screen.
2. Large tap targets.
3. Minimal text.
4. Strong visual hierarchy.
5. State must be readable in under one second.
6. Anything complex belongs on the phone, not the watch.

## Screen Set

### Screen 1: Watch Welcome

Purpose:
Introduce the idea of controlling Vespin from the wrist.

Content:
- Vespin mark
- Short value statement
- Continue button

### Screen 2: Quick Setup

Purpose:
Explain the companion relationship between phone, speaker, and watch.

Content:
- Tiny diagram or simple stacked cards
- Watch controls speaker through phone sync
- Continue button

### Screen 3: Permissions

Purpose:
Simulate the setup permissions required for a believable onboarding flow.

Content:
- Notifications toggle state
- Bluetooth toggle state
- Background sync explanation
- Continue button

### Screen 4: Watch Home

Purpose:
Primary glanceable dashboard.

Content:
- Connected speaker name
- Now playing title
- Play or pause button
- Volume quick controls
- Battery or sync badge

### Screen 5: Playback Remote

Purpose:
Give quick transport controls.

Content:
- Previous
- Play or pause
- Next
- Current progress summary

### Screen 6: Quick Presets

Purpose:
Provide instant sound mood switching.

Content:
- Chill
- Bass
- Focus
- Acoustic

### Screen 7: Status

Purpose:
Show health and connection state.

Content:
- Watch connected or disconnected state
- Speaker battery
- Watch battery
- Last sync timestamp

## Simulation Model

Use a dedicated frontend store for watch state.

Suggested state shape:

```ts
type WatchCompanionState = {
  selectedSpeakerId: string | null
  watchConnected: boolean
  watchBattery: number
  speakerBattery: number
  nowPlayingTitle: string
  playbackStatus: "playing" | "paused"
  volume: number
  quickPreset: "chill" | "bass" | "focus" | "acoustic"
  notificationPermission: "unknown" | "granted" | "denied"
  bluetoothPermission: "unknown" | "granted" | "denied"
  syncStatus: "connected" | "syncing" | "weak" | "disconnected"
  lastSyncedAt: string | null
}
```

Suggested actions:

```ts
type WatchCompanionActions = {
  connectWatch: () => void
  disconnectWatch: () => void
  togglePlayback: () => void
  nextTrack: () => void
  previousTrack: () => void
  stepVolumeUp: () => void
  stepVolumeDown: () => void
  applyPreset: (preset: "chill" | "bass" | "focus" | "acoustic") => void
  grantNotificationPermission: () => void
  grantBluetoothPermission: () => void
  simulateWeakConnection: () => void
  simulateSyncing: () => void
}
```

## Where It Should Live

The repo structure already separates routes from feature logic. The watch work
should follow that pattern.

Suggested structure:

```text
frontend/
├── app/
│   └── (app)/
│       └── watch/
│           ├── index.tsx
│           ├── setup.tsx
│           ├── remote.tsx
│           ├── presets.tsx
│           └── status.tsx
└── src/
    └── features/
        └── watch-companion/
            ├── components/
            ├── hooks/
            ├── store.ts
            └── types.ts
```

The route files should stay thin. The real UI should live in feature
components.

## Integration With Existing App

The watch simulation should attach to the existing speaker flow rather than
competing with it.

Recommended integration points:

1. Add a "Watch Companion" entry point from the home or devices area.
2. Use the currently selected speaker as the active speaker for watch control.
3. Reuse existing speaker data where possible.
4. Keep watch-only state in its own store.

## Why Not Real Watch Native Development Yet

There are three reasons not to start with a real watch app:

1. The project stack is Expo managed, which is not a good fit for a real
   Apple Watch or Wear OS companion build in this phase.
2. The repo scope already states that device communication is simulated.
3. For HCI evaluation, the interaction model matters more than actual hardware
   integration.

## If Backend Support Is Needed Later

Only add backend support after the frontend interaction model is validated.

Possible backend phase 2 additions:

1. Persist watch setup state per user.
2. Store last used preset from watch.
3. Store preferred quick actions.
4. Store companion pairing metadata.

Avoid adding `vespin_watch` to the device enum unless the product decision is
that the watch must behave like a separate pairable device in the system.
In most cases, it should remain a companion surface, not a speaker device.

## Demo Mode

For class presentation, add a hidden or visible demo mode panel.

Suggested controls:

1. Toggle watch connected/disconnected.
2. Change battery from 100 to 15.
3. Toggle sync status.
4. Switch current track title.
5. Apply EQ preset instantly.

This gives you predictable states during presentation and usability testing.

## HCI Testing Scenarios

Use these scenarios for evaluation:

1. User lowers volume while walking.
2. User quickly pauses playback in a classroom.
3. User changes to Chill preset without opening the phone.
4. User checks whether the speaker is still connected.
5. User opens a complex action and realizes it should be handed off to the
   phone app.

## Recommended Build Order

1. Define watch state store.
2. Build watch home screen.
3. Build playback remote screen.
4. Build quick preset screen.
5. Add setup and permissions screens.
6. Add demo controls.
7. Run quick usability checks.

## Success Criteria

The smartwatch work is successful if:

1. The watch flow feels believable without real hardware.
2. The UI clearly communicates quick control rather than full app parity.
3. Users can complete the top three watch tasks in a few seconds.
4. The feature integrates cleanly with the current speaker-first app model.