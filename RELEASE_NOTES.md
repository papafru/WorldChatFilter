# World Chat Filter v1.0.1

**Keep the conversation. Filter the noise.**

Bugfix and UI update for Vanilla WoW 1.12 API / Turtle-style 1.18 clients, incorporating all fixes developed after v1.0.0.

## What's new

- **More accurate group-finding detection:** leading `LF` with or without a number followed by a class, role, spec, dungeon, raid, or battleground. Handles full instance names and common abbreviations, including Vanilla and Turtle WoW custom content (e.g. `LF4 RAZORFEN KRAUL`, `LF RFK`, `LF WSG`, `LF KARA10`).
- **Crafting and enchantment requests:** recognize recipe/enchant hyperlinks with or without spaces after `LF`, including `LF[Enchant Weapon - Spell Power]`. These are grouped under **Services**, while unrelated item links and normal discussion remain separate.
- **Guild recruitment improvements:** detect direct invitations such as `Join THE CULT, we're a social guild` even without traditional recruitment keywords.
- **World color improvements:** **Dusty Gold** (`#D1B77F`) is the new default preset; the Color Presets submenu opens to the **left** to avoid overlapping the settings menu. Reset now selects Dusty Gold. **Existing custom/preset selections are preserved** during upgrades.
- **Safer filtering:** the newly introduced patterns are scoped to relevant advertising context and respect each category toggle. Other chat channels remain untouched.

## Installation

Download **[WorldChatFilter-v1.0.1.zip](https://github.com/papafru/WorldChatFilter/releases/download/v1.0.1/WorldChatFilter-v1.0.1.zip)** from the release assets.

1. Close World of Warcraft.
2. Extract the included `WorldChatFilter` folder to `Interface/AddOns/`.
3. Check that `Interface/AddOns/WorldChatFilter/WorldChatFilter.toc` exists and that there is **no extra nested folder**.
4. Start WoW and type `/wcf` for settings.

For existing installations, replace the addon folder but retain the character's `WTF/.../SavedVariables` files to keep settings and statistics. Compatible GitHub addon managers can continue using the repository URL.

## Compatibility and testing

- WoW Vanilla 1.12 API / Turtle-style 1.18 clients; no external dependencies.
- **31/31 Lua 5.1 regression tests passing** prior to packaging, including the new LF and crafting-link cases, existing filters, and World-channel isolation.
- In-client behavior still depends on the particular client and other chat addons; reports with sanitized examples are welcome.

This release has its own `v1.0.1` source tag and an installation-ready ZIP. The previous `v1.0.0` release remains available.
