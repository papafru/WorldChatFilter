# Changelog

## 1.0.0 — 2026-10-12

First public release, based on the in-game-tested **v0.3.22 beta** branch.

- World-only contextual detection for trade, group finding, guild recruitment, professions/services, summon/taxi listings, and repeat spam.
- Expanded short-hand LFG detection (e.g., `LF7M`, `LF 1M`, `LF1Healer`, `LF 2 DPS`, and class variants).
- Multilingual and indirect guild recruitment detection without guild-name blacklists.
- Expanded English and Italian guild recruitment patterns, including PvP/PvE communities.
- Scheduled PUG/raid recruitment detection using role/class demand and recurring event context.
- Local per-character statistics, sensitivity settings, minimap button, and diagnostic commands.
- Optional World-only color tint with four presets and a native RGB picker.
- Standalone addon, with no SocialChat dependency.
- Performance improvements to classifier lookups and repeat-history cleanup from earlier betas.

**Known limitations:** Rule-based filtering cannot guarantee zero misses or false positives. The channel must be named `World`. Competing chat and color addons may affect appearance/behavior.