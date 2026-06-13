# Vespin Watch

Standalone Apple Watch companion app for the Vespin HCI project.

This repository is intentionally separate from the Expo phone app. It targets
watchOS with SwiftUI and uses the existing Vespin project as a conceptual and
backend reference.

## What is included

- A standalone watchOS app scaffold
- SwiftUI starter screens
- Theme and component primitives for watch-specific UI
- Planning documents copied from the main project
- An XcodeGen project spec to generate the Xcode project

## Repository layout

```text
vespin-watchos/
├── project.yml
├── specs/
├── watchos-app/
│   ├── Sources/
│   └── Resources/
└── README.md
```

## Getting started

1. Install XcodeGen if it is not already installed.
2. From the repo root, run `xcodegen generate`.
3. Open `VespinWatch.xcodeproj` in Xcode.
4. Select an Apple Watch simulator.
5. Run the `VespinWatch` scheme.

## Current status

The app starts with local mock data and a simple SwiftUI navigation flow:

- Welcome
- Connected Speaker
- Now Playing
- Remote Controls
- Quick Presets
- Status

Backend connectivity can be added later after the watch UI is stable.

## Related planning docs

- `specs/watchos-implementation-plan.md`
- `specs/smartwatch-simulation.md`