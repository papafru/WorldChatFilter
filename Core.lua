-- WorldChatFilter 1.0.0: World-only chat filter
-- WoW Vanilla 1.12 API / 1.18-based clients; Lua 5.0 syntax only.
WorldChatFilter = {}
local WCF = WorldChatFilter
WCF.VERSION = "1.0.0"
WCF.CHANNEL = "World"
WCF.sessionHidden = 0
WCF.db = nil

local function trim(text)
  text = tostring(text or "")
  text = string.gsub(text, "^%s+", "")
  text = string.gsub(text, "%s+$", "")
  return text
end
WCF.Trim = trim

function WCF.Print(message)
  if DEFAULT_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage("|cff80e4a0[World Chat Filter]|r " .. tostring(message or ""))
  end
end

-- Standalone addon: retain existing per-character WorldChatFilterDB values.
local defaults = {
  enabled = true,
  filterTrade = true,
  filterLFG = true,
  filterGuild = true,
  filterServices = true,
  filterRepeats = true,
  sensitivity = "balanced",
  debug = false,
  minimapAngle = 225,
  tintWorld = true, -- optional World-only color override
  worldColorPreset = "gold", -- Dusty Gold (#D1B77F)
  worldColorCustom = {}, -- RGB (0..1) saved per character
}

function WCF.Initialize()
  -- Settings/stats from prior WorldChatFilter betas load automatically.
  -- A legacy SocialChat folder is no longer required or referenced.
  if type(WorldChatFilterDB) ~= "table" then
    WorldChatFilterDB = {}
  end
  local key, value
  for key, value in pairs(defaults) do
    if WorldChatFilterDB[key] == nil then
      if type(value) == "table" then
        WorldChatFilterDB[key] = {}
      else
        WorldChatFilterDB[key] = value
      end
    end
  end
  -- Legacy local mute lists are not imported (WoW has /ignore).
  if WorldChatFilterDB.sensitivity ~= "careful" and WorldChatFilterDB.sensitivity ~= "balanced" and WorldChatFilterDB.sensitivity ~= "aggressive" then
    WorldChatFilterDB.sensitivity = "balanced"
  end
  WCF.db = WorldChatFilterDB
  if WCF.InitializeStats then WCF.InitializeStats() end
end

-- Vanilla CHAT_MSG_CHANNEL: arg9 is the base channel name, arg4 the numbered name.
-- Some private 1.18 clients populate arg7 (zone-channel ID) for /World even
-- though it is a user-facing World channel. It is NOT a reliable /World gate.
 -- Match ONLY exact channel names. If both labels are present, they must agree;
 -- never hide a message on Trade, General, LookingForGroup, etc.
function WCF.IsWorldChannel(baseName, decoratedName, zoneChannelID)
  local function normalized(name)
    if type(name) ~= "string" then return nil end
    name = trim(name)
    if name == "" then return nil end
    name = trim(string.gsub(name, "^%d+%.%s*", ""))
    return string.lower(name)
  end
  local base = normalized(baseName)
  local decorated = normalized(decoratedName)
  if not base and not decorated then return false end
  if base and base ~= "world" then return false end
  if decorated and decorated ~= "world" then return false end
  -- Deliberately DO NOT inspect zoneChannelID/arg7 here: server variations
  -- made every real /World message bypass the filter in v0.3.6.
  return true
end

function WCF.Status()
  if not WCF.db then WCF.Initialize() end
  local status = "ON"
  if not WCF.db.enabled then status = "OFF" end
  WCF.Print("World filtering: " .. status .. ". Sensitivity: " .. tostring(WCF.db.sensitivity) .. ". Hidden this session: " .. tostring(WCF.sessionHidden) .. ".")
end

function WCF.Help()
  WCF.Print("/wcf = options | /wcf on | /wcf off | /wcf status | /wcf help")
  WCF.Print("/wcf test <message> = explain classification | /wcf debug = toggle block reasons")
  WCF.Print("/wcf mode careful|balanced|aggressive = set detection sensitivity")
  WCF.Print("/wcf stats = show session and all-time statistics")
  WCF.Print("/wcf channeldebug = log channel metadata (not message contents) for diagnosis")
  WCF.Print("/wcf color on|off|picker|reset = World chat color options")
  WCF.Print("This addon NEVER joins/leaves channels or moderates other players.")
end

SLASH_WORLDCHATFILTER1 = "/wcf"

SlashCmdList["WORLDCHATFILTER"] = function(raw)
  raw = trim(raw)
  local _, _, command, rest = string.find(raw, "^(%S+)%s*(.*)$")
  if not command then
    if WCF.ToggleUI then WCF.ToggleUI() end
    return
  end
  command = string.lower(command)
  if command == "help" then
    WCF.Help()
  elseif command == "options" or command == "settings" then
    if WCF.ToggleUI then WCF.ToggleUI() end
  elseif command == "stats" or command == "statistics" then
    if WCF.ToggleStatsUI then WCF.ToggleStatsUI() end
  elseif command == "status" then
    WCF.Status()
  elseif command == "on" or command == "off" then
    if not WCF.db then WCF.Initialize() end
    WCF.db.enabled = (command == "on")
    WCF.Status()
    if WCF.RefreshWorldColor then WCF.RefreshWorldColor() end
    if WCF.RefreshUI then WCF.RefreshUI() end
  elseif command == "color" then
    if not WCF.db then WCF.Initialize() end
    rest = string.lower(trim(rest))
    if rest == "on" or rest == "off" then
      WCF.db.tintWorld = rest == "on"
      if WCF.RefreshWorldColor then WCF.RefreshWorldColor() end
      WCF.Print("World color: " .. (WCF.db.tintWorld and "ON" or "OFF"))
    elseif rest == "picker" or rest == "custom" then
      if WCF.OpenWorldColorPicker then WCF.OpenWorldColorPicker() end
    elseif rest == "reset" or rest == "default" then
      if WCF.ResetWorldColorSelection then WCF.ResetWorldColorSelection() end
      WCF.Print("World color preset: Dusty Gold (#D1B77F)")
    else
      WCF.Print("Usage: /wcf color on|off|picker|reset (or /wcf -> World Chat Color)")
    end
  elseif command == "test" then
    if not WCF.db then WCF.Initialize() end
    if rest == "" then WCF.Print("Usage: /wcf test <message>") return end
    local category, score, why, blocked, threshold = WCF.ClassifyMessage(rest)
    WCF.Print((blocked and "BLOCK" or "ALLOW") .. " | " .. (category or "Chat") ..
             " | score " .. tostring(score) .. "/" .. tostring(threshold) .. " | " .. tostring(why))
  elseif command == "channeldebug" then
    WCF.channelDebug = not WCF.channelDebug
    WCF.channelDebugSeen = {}
    WCF.channelDebugCount = 0
    WCF.Print("Channel diagnostics: " .. (WCF.channelDebug and "ON" or "OFF") .. ". Prints unique channel metadata only, no chat text or player names.")
  elseif command == "debug" then
    if not WCF.db then WCF.Initialize() end
    WCF.db.debug = not WCF.db.debug
    WCF.Print("Blocked-message diagnostics: " .. (WCF.db.debug and "ON" or "OFF"))
  elseif command == "mode" then
    if not WCF.db then WCF.Initialize() end
    rest = string.lower(trim(rest))
    if rest == "careful" or rest == "balanced" or rest == "aggressive" then
      WCF.db.sensitivity = rest
      WCF.Print("Detection sensitivity: " .. rest)
    else
      WCF.Print("Usage: /wcf mode careful|balanced|aggressive")
    end
  else
    WCF.Print("Unknown command. Type /wcf help.")
  end
end

local initFrame = CreateFrame("Frame", "WorldChatFilterInitFrame")
initFrame:RegisterEvent("VARIABLES_LOADED")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
initFrame:SetScript("OnEvent", function()
  if event == "VARIABLES_LOADED" then
    WCF.Initialize()
    if WCF.BuildUI then WCF.BuildUI() end
  elseif event == "PLAYER_ENTERING_WORLD" then
    if not WCF.db then WCF.Initialize() end
    -- Other addons can replace the default chat handler during login.
    if WCF.InstallChatHook then WCF.InstallChatHook() end
    if WCF.RefreshWorldColor then WCF.RefreshWorldColor() end
  end
end)
