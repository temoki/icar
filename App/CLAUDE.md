# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

iCar is an iOS 27 demo app showcasing BEV (battery electric vehicle) connected services using Siri and Apple Intelligence. It targets iPhone and iPad (`TARGETED_DEVICE_FAMILY = "1,2"`), with bundle ID `space.hiraku.icar`.

## Build & Run

Use the Xcode MCP tools rather than the command line for all build/run operations:

- **Build**: `BuildProject` MCP tool
- **Run on simulator**: `RunProject` MCP tool
- **Quick diagnostics** (type errors, missing imports): `XcodeRefreshCodeIssuesInFile` MCP tool — much faster than a full build
- **Run a code snippet**: `RunCodeSnippet` MCP tool

There are no unit tests in this project yet.

## Architecture

### State: `VehicleStore`

`VehicleStore` (`Models/VehicleStore.swift`) is the single source of truth. It is `@MainActor @Observable final class` with `static let shared`. All vehicle state lives here: battery %, charging, charge limit, departure time, climate, temperature, lock state.

- The `App` struct creates `@State private var store = VehicleStore.shared` and injects it via `.environment(store)`.
- Views read state with `@Environment(VehicleStore.self)`.
- State is persisted to `UserDefaults` as a `Codable` snapshot on every mutation so Siri/Shortcuts changes (which run in a separate process) survive app restarts.

### All Actions Flow Through App Intents

Every state-changing action — **including taps inside the app** — goes through an `AppIntent`. This is intentional: it ensures Siri/Shortcuts and in-app UI share identical code paths and that the system records donations for suggestions.

- **Single-tap actions** (start/stop charging, lock/unlock, climate on/off): `Button(intent: SomeIntent())` directly.
- **Value-input actions** (charge limit, cabin temperature, departure time): UI controls (`Slider`, `Stepper`, `DatePicker`) adjust a local `@State` draft value, then a `Button(intent: SetXxxIntent(value: draft))` confirms and executes the intent.
- Each intent's `perform()` is `@MainActor` and calls `VehicleStore.shared` methods directly.

### Intent Files (`Intents/`)

| File | Intents |
|---|---|
| `BatteryIntents.swift` | `CheckBatteryIntent` — returns Siri snippet view |
| `ChargingIntents.swift` | `Start/StopCharging`, `SetChargeLimit`, `SetDepartureTime` |
| `ClimateIntents.swift` | `Start/StopClimate`, `SetCabinTemperature` |
| `SecurityIntents.swift` | `Lock/UnlockVehicle` |
| `ICarShortcuts.swift` | `AppShortcutsProvider` — 8 shortcuts with Japanese + English Siri phrases |
| `VehicleEntity.swift` | `AppEntity` + `IndexedEntity` for Spotlight exposure |
| `IntentSnippets.swift` | `BatterySnippetView` — SwiftUI view shown in Siri after CheckBattery |

### Views (`Views/`)

`DashboardView` is the root: `NavigationStack` → `ScrollView` → `CarHeroView`, `StatusSummaryView`, then one card per domain (`BatteryCard`, `ChargingCard`, `ClimateCard`, `SecurityCard`). Each card is an independent View struct.

`StatusSummaryView` uses `FoundationModels` (`SystemLanguageModel`) to generate a one-sentence vehicle status summary. It checks `model.availability` and falls back to a static string when Apple Intelligence is unavailable.

### Localization

The project is fully localized in English (Base) and Japanese (`ja`):

- `Localizable.xcstrings` — all UI strings (70 keys)
- `AppShortcuts.xcstrings` — Siri shortcut phrase translations (8 keys, each with 3 Japanese variants)
- `ICar-InfoPlist.xcstrings` — app name

When adding new `Text("...")` literals in SwiftUI views or `LocalizedStringResource` values in intents, run `BuildProject` to extract them into the catalogs, then use the `xcode-integration:translation-coordinator` skill to add Japanese translations.

## Key Conventions

- **SwiftUI state**: use `@Observable` + `@State`, never `ObservableObject`/`@Published`.
- **Async in views**: use `.task(id:)` modifier, never `Task {}` inside `onAppear`.
- **View decomposition**: extract into independent View structs, not `@ViewBuilder` computed properties.
- **Vehicle data is mocked**: `VehicleStore` holds in-memory state. Replacing these with real vehicle API calls is the main extension point.
- **No Assistant Schema**: the app uses custom `AppIntent` (not `@AppIntent(schema:)`) because no Apple-defined schema covers automotive/EV domains.
