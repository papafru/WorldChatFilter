# World Chat Filter v1.0.0 — DRAFT

> This release has **not yet been published**. The current repository source is v0.3.23 beta.

**Keep the conversation. Filter the noise.**

A lightweight, standalone World-chat spam filter for Vanilla-style WoW clients (1.12 API, OctoWoW 1.18 tested).

### What's included

- Context-aware detection of trade ads, group finding (including scheduled raid/PUG demands), multilingual guild recruitment, profession services, summons/taxi listings, and repeated posts.
- World-only filtering: the actual Trade, General, LookingForGroup, Guild, Party, and Whisper channels remain untouched.
- Careful / Balanced / Aggressive sensitivity levels.
- Optional World chat tint, four color presets and RGB Color Picker (default Warm Stone).
- Minimap settings dropdown, statistics, and `/wcf test` diagnostics.
- No external dependencies.

### Installation

Download **`WorldChatFilter-v1.0.0.zip`** from the release assets and extract the `WorldChatFilter` folder into `Interface/AddOns/`. Type `/wcf` to open settings. Existing SavedVariables are preserved when upgrading.

**Note:** False positives and undetected ads are still possible; please file reports with sanitized examples. Screenshots will be added after an in-game capture.