# Pouncio Assumptions

This file documents the key assumptions and design decisions made during the autonomous build.

## Phase 1 (Frontend)

1. **Relative Mock Timestamps**:
   To ensure that the mock data always showcases the freshness tiers ("Posted Now" <30m, "Recent" <1h, "Today" <24h) regardless of when the app is run, the raw `jobs.json` and `notifications.json` files contain relative offsets (e.g., `-10m`, `-45m`, `-6h`, `-2d`). The `MockJobService` parses these offsets at runtime and converts them to actual `DateTime` instances relative to the current clock.
   
2. **Hive Type Adapters**:
   All core configurations (app settings, active job filter) are persisted in Hive boxes. For code cleanliness and compile-time safety, all Freezed models and enums are registered with explicit Hive adapters (type IDs 0-12).
   
3. **Glassmorphism Style**:
   The "glass" aesthetics are built using custom Cupertino-themed wrappers with standard `BackdropFilter` set to `sigmaX: 20` and `sigmaY: 20`, overlaying a white/black surface at 60% opacity.
