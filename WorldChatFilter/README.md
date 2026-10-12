# World Chat Filter v0.3.23 — Beta

**Keep the conversation. Filter the noise.**

World-only advertisement filtering for Vanilla-style WoW (1.12 API / 1.18-based clients). Actual Trade, General, guild, party and other channels are not filtered.

Install this `WorldChatFilter` folder inside `Interface/AddOns/`, then type `/wcf` in-game. Use `/wcf stats` for statistics and the **World Chat Color** submenu for presets or the RGB picker.

v0.3.23 extends the general LFG patterns to recognize **LF + dungeon**, **need + number + role/class**, and **compact dungeon roster listings** (such as `DEADMINES HEAL 2DPS`), while preserving chat and World/Trade separation. It includes previous scheduled PUG, multilingual recruitment and service detection.

Settings are saved per character (`WorldChatFilterDB`). The full documentation is in the repository root README. This beta is **not** an official GitHub v1.0.0 release.

MIT licensed.