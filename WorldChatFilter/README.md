# World Chat Filter v1.0.0

**Keep the conversation. Filter the noise.**

World Chat Filter is a client-side rule-based spam filter for the **World** channel only, built for Vanilla WoW 1.12 API and 1.18-based clients such as OctoWoW.

- Detects context-based Trade, LFG (including open-world group requests), guild recruitment, services and repeated advertisements in World.
- Does not filter messages in the actual Trade, General, LookingForGroup, Guild, Party, Raid or Whisper channels.
- Blizzard-style options via `/wcf`, sensitivity settings, minimap button and World chat tint presets + RGB Color Picker.
- Statistics via `/wcf stats`; diagnostics via `/wcf test <message>`.
- SavedVariables are preserved when upgrading from WorldChatFilter betas.

Install the `WorldChatFilter` directory into `Interface/AddOns/`, then type `/wcf` in game. For full instructions, see https://github.com/papafru/WorldChatFilter.

This is a rule-based classifier, not AI. Some advertisements may be missed and false positives are possible; bug reports are welcome.

Licensed under the MIT License, see `LICENSE`.
