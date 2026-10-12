# World Chat Filter v1.0.0

Initial public release, now with post-release classifier bugfixes in the downloadable ZIP. The current `main` branch contains 22 regression tests; the original `v1.0.0` source tag is intentionally unchanged.

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

Download **[WorldChatFilter-v1.0.0-Bugfix.zip](https://github.com/papafru/WorldChatFilter/releases/download/v1.0.0/WorldChatFilter-v1.0.0-Bugfix.zip)** from the release assets and extract the `WorldChatFilter` folder into `Interface/AddOns/`. Type `/wcf` to open settings. Existing SavedVariables are preserved when upgrading. Do **not** use the auto-generated **Source code (ZIP)**, which still reflects the original release tag.

**Note:** False positives and undetected ads are still possible; please file reports with sanitized examples. Real in-game screenshots are included in the README.