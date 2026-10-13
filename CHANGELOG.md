# Changelog

## 1.0.1 — 2026-10-13

- Detect direct guild join invitations without the literal word `recruiting` (for example `Join THE CULT, we're a social guild`).
- Default World color is now Dusty Gold (`#D1B77F`); Color Presets submenu opens to the left instead of overlapping the main menu. Existing user-selected colors are retained.
- Reset Color returns to Dusty Gold.
- Detect `LF` immediately followed by a linked enchant/recipe (`LF[Enchant Weapon - Spell Power]`), with or without spaces/counts; support native enchant/spell/item/tradeskill hyperlinks. Keep crafting links under Services rather than Trade and allow normal link discussions.

- Recognize leading `LF` with or without a number plus class/role/spec or dungeon/raid/BG, including Vanilla and Turtle WoW full names/abbreviations (`LF4 RAZORFEN KRAUL`, `LF RFK`).
- Regression tests for optional counts, ordinary chat and World-channel isolation.


## 0.3.23 — Beta (2026-10-12)

- Recognize short `LF + dungeon` ads, including Scarlet Graveyard variants.
- Recognize numbered group needs such as `need 1 heal for ...` with unknown destinations.
- Recognize compact role compositions like `DEADMINES HEAL 2DPS`.
- Add regression tests for these patterns, ordinary chat and World/Trade isolation.
- Keep the color picker, statistics and other features unchanged.

## 1.0.0 — 2026-10-12

Initial stable release based on **v0.3.23**, including the latest contextual LFG fixes.

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