# World Chat Filter v1.1.0

**Keep the conversation. Filter the noise.**

A major quality-of-life update for the **Vanilla 1.12 API / Turtle-style 1.18 clients**. World Chat Filter remains 100% local and continues to hide messages **only from /World**, never from Party, Raid, Trade, Guild, General, or whispers.

## New in v1.1

### One-button ON/OFF macro
Use `/wcf toggle` in a WoW macro to enable or disable filtering without opening Settings. Existing `/wcf on` and `/wcf off` continue to work. Your saved preferences and custom lists remain intact.

### Personal World-only player filtering
Keep a per-character list of players whose messages you do not want to see in World chat. Right-click a player's name in chat and select **Block from World Chat**; repeat to **Unblock from World Chat**. This does **not** add them to WoW's global Ignore list; their messages in other channels and whispers remain visible.

### Custom words and phrases
Add case-insensitive filters for words and phrases with **Partial match** or **Whole word** matching. Manage entries in the new **Blocked Players / Words & Phrases** interface with one input, two tabs, pagination, and per-entry Remove controls. Edit or disable custom filtering without affecting the main automatic ad classifier.

### Unified Dark Arcane Blizzard interface

All three panels share the dark slate-and-bronze style, subtle hover effects, Dusty Gold highlights and a more opaque backdrop.

#### Custom Filters

A compact manager with **Blocked Players** / **Words & Phrases** tabs, an Enabled control, pagination, Remove buttons and Partial / Whole word matching.

<img src="https://github.com/user-attachments/assets/fe01b6ef-b251-4957-bba9-f9e921b7f0db" width="650" alt="World Chat Filter v1.1 — Custom Filters window in OctoWoW" />

#### Statistics

Session and all-time hidden-message counts, including the new **Custom** category. Reset All asks for confirmation inside the window.

<img src="https://github.com/user-attachments/assets/add029db-3b51-4314-ac73-b3b95dc4d2a2" width="650" alt="World Chat Filter v1.1 — Statistics window in OctoWoW" />

#### Help / Commands

The new in-game command reference has **General**, **Custom Filters** and **Tools** tabs. Open it with `/wcf help` or via the settings menu.

<img src="https://github.com/user-attachments/assets/47ffc44a-dbf4-45e6-8d36-74155da7e2c3" width="760" alt="World Chat Filter v1.1 — Help and Commands window in OctoWoW" />

### Useful commands

| Command | Purpose |
| --- | --- |
| `/wcf` | Settings menu |
| `/wcf toggle` | Toggle World filtering, suitable for macros |
| `/wcf custom` | Open personal block lists |
| `/wcf block player NAME` | Block a player from World only |
| `/wcf unblock player NAME` | Unblock a player |
| `/wcf block text PHRASE` | Block a text substring |
| `/wcf block word PHRASE` | Block a whole word / phrase |
| `/wcf unblock text PHRASE` | Remove a phrase |
| `/wcf stats` | Statistics panel |
| `/wcf help` | In-game help and command reference |

## Upgrade / installation

1. Download the **[WorldChatFilter-v1.1.0.zip](https://github.com/papafru/WorldChatFilter/releases/download/v1.1.0/WorldChatFilter-v1.1.0.zip)** release asset. Use this ZIP rather than GitHub's automatically generated source archive for manual installation.
2. Close WoW, extract the included `WorldChatFilter` folder to `Interface/AddOns/` (no extra nested folder), and restart.
3. Keep your `WTF/.../SavedVariables/WorldChatFilter.lua` file; preferences, custom lists, and historical statistics survive the upgrade.

Compatible addon managers can install/update using `https://github.com/papafru/WorldChatFilter`.

## Compatibility, safety and tests

- Vanilla API 1.12 / Turtle-style 1.18 custom clients.
- **35/35 Lua regression tests** for the release build, covering filter behavior, category stats, custom lists, slash commands, GUI interactions, and World-only isolation.
- No AI, external servers, telemetry, or network dependencies; chat is classified locally.
- Purely client-side filtering; the addon cannot moderate other players or change their chat.
- User-interface behavior has been reviewed in game on OctoWoW 1.18. Other custom clients or chat addons may require further compatibility testing.

Previous releases, including **v1.0.1**, remain available.
