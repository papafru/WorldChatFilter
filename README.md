# World Chat Filter

> **Version 1.0.0 source.** The latest implicit-LFG improvements from beta v0.3.23 are included.

**Keep the conversation. Filter the noise.**

**World Chat Filter** is a lightweight, rule-based chat addon for Vanilla-style World of Warcraft. It filters unwanted advertisements from the **`World` channel**, leaving room for normal conversations.

> [!IMPORTANT]
> **World only.** This addon does **not** filter actual **Trade, General, LookingForGroup, Guild, Party, Raid, or Whisper** chat. The *Trade* setting means **trade advertisements posted in World**.

## Features

- **Context-aware spam detection:** Combines advertising intent with context, rather than blocking every message containing a certain word.
- **Ad categories:** Trade (WTS/WTB/selling), group finding (LFG/LFM, raids, elite quests), guild recruitment, services (crafting, enchants, boosts, summons/taxi), and repeated messages.
- **Language-aware guild detection:** Curated signals from multiple languages and some transliterations. No guild names or player names are blacklisted.
- **Sensitivity:** **Careful**, **Balanced** (default), or **Aggressive**.
- **Blizzard-style settings:** Dropdown menu with toggles, a circular minimap icon, and **Shift + drag** to reposition it.
- **World chat colors:** Optional World-only tint; four presets with swatches, plus a built-in **RGB Color Picker**. Default color: **Warm Stone** (`#C9B8A2`). The tint is local and can be disabled.
- **Statistics:** Session and all-time hidden-message counts by category, saved per character.
- **Diagnostics:** Explain sample classifications and troubleshoot channel identification.
- **No dependencies:** Works without SocialChat or external libraries.

## Compatibility

- Built for the **Vanilla WoW 1.12 API** (`## Interface: 11200`) and **1.18-based custom clients**.
- Tested in-game on an **OctoWoW 1.18** client. Other 1.12/1.18 clients may differ.
- Assumes the channel is actually named **`World`**; numbered positions such as `4. World` and `5. World` are handled dynamically.
- Filtering is **client-side**: it cannot stop other people from posting or change what they see.

## Installation

**GitHub addon managers:** Add this repository URL directly: `https://github.com/papafru/WorldChatFilter`. The addon `.toc` and `.lua` files are at the repository root so compatible managers can detect and install it as `WorldChatFilter`.

**Manual installation:**

1. Download **`WorldChatFilter-v1.0.0.zip`** from [GitHub Releases](https://github.com/papafru/WorldChatFilter/releases) once the release asset is available. Do **not** use the automatically generated source ZIP for normal installation.
2. Close WoW and extract the ZIP.
3. Copy the **`WorldChatFilter`** directory into `World of Warcraft/Interface/AddOns/`.
4. Make sure this file exists: `Interface/AddOns/WorldChatFilter/WorldChatFilter.toc` (no extra nesting).
5. Start the game and type **`/wcf`** to open the settings menu.

**Upgrading from a beta:** Replace only `Interface/AddOns/WorldChatFilter/`; **do not delete your `WTF/.../SavedVariables/WorldChatFilter.lua`** file. The existing `WorldChatFilterDB` settings and statistics are preserved.

**Coming from the old SocialChat:** This addon has **no SocialChat dependency** and does not itself import the old SocialChat settings. If you already migrated, the old helper is no longer needed.

## Settings

Click the minimap icon or type `/wcf`. Available controls include:

- Enable/disable filtering and individual categories.
- Choose **Careful**, **Balanced**, or **Aggressive** detection.
- Open the **World Chat Color** submenu to enable the tint, choose a preset, open **Choose Custom Color...**, or reset to **Warm Stone**.
- Open the **Statistics** panel and reset session/all-time counters.

Preset colors:

| Preset | Color |
| --- | --- |
| Warm Stone (default) | `#C9B8A2` |
| Soft Sage | `#A9BDA5` |
| Muted Lavender | `#B8A9CE` |
| Dusty Gold | `#D1B77F` |

The color is applied to **new World messages only**, not previously displayed lines. When filtering or the tint is disabled, the addon restores the previous channel color while it is running. It does not write a new global chat color preference. Other chat-color addons may conflict.

## Slash commands

| Command | Action |
| --- | --- |
| `/wcf` | Open the settings menu |
| `/wcf stats` | Toggle the statistics panel |
| `/wcf on` / `/wcf off` | Enable / disable filtering |
| `/wcf status` | Print current filter status and counts |
| `/wcf mode careful` | Lower detection sensitivity |
| `/wcf mode balanced` | Default sensitivity |
| `/wcf mode aggressive` | Higher detection sensitivity |
| `/wcf color on` / `/wcf color off` | Enable / disable World chat tint |
| `/wcf color picker` | Open the RGB Color Picker |
| `/wcf color reset` | Restore the Warm Stone preset |
| `/wcf test <message>` | Explain the decision for a sample message |
| `/wcf debug` | Toggle classification reasons in chat |
| `/wcf channeldebug` | Toggle channel metadata diagnostics |
| `/wcf help` | Show the command list |

## How it works

1. **Check the channel first.** Only messages whose actual channel name is `World` are eligible for filtering. Conflicting or unrecognized channel metadata is allowed through, not blocked.
2. **Evaluate advertising intent.** The classifier combines recruitment wording, roles/classes, item links, contact instructions, prices, activities, destination lists, repeated posts, and other context.
3. **Apply filters and sensitivity.** Messages that meet the chosen threshold are hidden locally and counted in statistics.

For example, `LF 1Healer Hinterlands Elites` is a group-finding advertisement, while `What does LF1Mage mean?` is an ordinary question. This is a **rule-based classifier, not an AI model**; misses and false positives are still possible.

## Privacy and troubleshooting

- **World ads still appear:** Check `/wcf status` and verify the channel is named `World`. Try `/wcf test <message>` or temporarily use `/wcf channeldebug`.
- **Regular chat is hidden:** Try Careful sensitivity and report the text and the `/wcf test` explanation.
- **Errors or conflicts:** Mention the exact client version and other chat/color addons. The legacy chat event hook can conflict with another addon replacing the same handler.
- **No network telemetry:** The addon does not transmit chat messages, player names, or statistics to an external service.

Please redact player names and private information from screenshots before opening a public issue.

## Screenshots

### Minimap button

A compact minimap button for quick access to the filter settings.

![World Chat Filter circular minimap button](docs/screenshots/minimap-icon.webp)

### Settings menu

A lightweight, Blizzard-style dropdown for filter categories, detection sensitivity, chat colors and statistics.

![World Chat Filter settings menu](docs/screenshots/settings-menu.webp)



## Contributing and license

Report missed ads **and** false positives so we can improve context recognition without resorting to player/guild blacklists. See [CONTRIBUTING.md](CONTRIBUTING.md) and the [changelog](CHANGELOG.md).

Distributed under the [MIT License](LICENSE).