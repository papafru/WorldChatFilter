# World Chat Filter v1.1.1 — Multilingual Guild Filter Hotfix

This maintenance release improves guild advertisement detection in the **World** channel for **OctoWoW 1.18 (Vanilla 1.12 addon API)**, while preserving normal conversations and other chat channels.

## What's fixed

- **Swedish:** Guild welcome messages with `alla är välkomna` and activities like `levla`, `chilla` and `raida`.
- **Polish:** Tagged guild invitations searching for players (`szuka osób` / `szukamy graczy`), plus leveling/raider recruitment (`rekrutują lvlujących i Raiderów`) with Azeroth context. Handles Polish diacritics and plain-ASCII spellings.
- **Spanish:** Guild/community advertisements featuring active members, `raids semanales`, `MC25`, `Kara10`, `ZG` and direct invitations such as `/whisp para info`, even without explicit recruitment verbs.
- **French:** Tagged guild advertisements using `recrute tout joueur`, `nous sommes ouverts aux joueurs` and leveling / MC / Ony / Octo terminology.
- **False positives:** More careful contextual checks for ordinary conversations, quotations, translation questions, and negated WoW references. **Guild and player names are never blacklisted.**

## What stays the same

- **World only.** Trade, General, LookingForGroup, Party, Guild, Raid and whispers remain untouched.
- Existing **Custom Filters**, **Statistics**, **Help / Commands**, World tint, settings, blocked-player/phrase lists and all-time counts remain intact.
- Everything operates locally with **no additional dependencies**.
- **39/39 Lua regression tests passed**, including new multilingual examples and World-only / toggle checks.

## Installation / update

1. Download **[WorldChatFilter-v1.1.1.zip](https://github.com/papafru/WorldChatFilter/releases/download/v1.1.1/WorldChatFilter-v1.1.1.zip)** from the assets below. Use this ZIP, **not** GitHub's automatic source archive.
2. Close WoW. Replace `Interface/AddOns/WorldChatFilter/` with the single `WorldChatFilter` folder inside the ZIP, with no extra nested directory.
3. Restart WoW; no SavedVariables migration is needed. **Do not delete** your `WTF/.../SavedVariables/WorldChatFilter.lua`.

GitHub addon managers can update from `https://github.com/papafru/WorldChatFilter`.

For the full v1.1 feature overview and interface screenshots, see **[v1.1.0 release notes](https://github.com/papafru/WorldChatFilter/releases/tag/v1.1.0)**. All older releases remain available.
