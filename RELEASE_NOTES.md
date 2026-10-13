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
- **Custom Filters:** A compact two-tab manager with dark slate and bronze controls, subtle hover effects, muted green ON state, Dusty Gold highlights, and an opaque backdrop.
- **Statistics:** Restyled category/session/all-time counts, including a dedicated **Custom** category. Reset All uses an in-window confirmation instead of printing prompts in chat.
- **Help / Commands:** A new in-game reference window with **General**, **Custom Filters**, and **Tools** tabs. Use `/wcf help` or Settings → Help / Commands to open it; the command list is no longer spammed into chat.

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
