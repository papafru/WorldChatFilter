-- WorldChatFilter v0.3 beta statistics (Vanilla Lua 5.0 compatible).
-- Counters are updated only for messages actually hidden in /World.
local WCF = WorldChatFilter
local categories = {"Trade", "LFG", "Guild", "Services", "Repeats"}
local session = nil
local statsFrame, cells, resetAllButton
local confirmReset = false

local function freshCounts()
  return {total = 0, Trade = 0, LFG = 0, Guild = 0, Services = 0, Repeats = 0}
end

local function normalizeCounts(value)
  if type(value) ~= "table" then value = {} end
  local defaults = freshCounts()
  local key
  for key in pairs(defaults) do
    local n = tonumber(value[key]) or 0
    if n < 0 then n = 0 end
    value[key] = math.floor(n)
  end
  return value
end

function WCF.InitializeStats()
  if not WCF.db then return end
  WCF.db.stats = normalizeCounts(WCF.db.stats)
  if not session then session = freshCounts() end
  WCF.sessionHidden = session.total
end

function WCF.GetStats()
  if not WCF.db then WCF.Initialize() end
  if not session then WCF.InitializeStats() end
  return session, WCF.db.stats
end

function WCF.RecordHiddenMessage(category)
  local current, lifetime = WCF.GetStats()
  if category ~= "Trade" and category ~= "LFG" and category ~= "Guild" and category ~= "Services" then
    category = "Repeats"
  end
  current.total = current.total + 1
  lifetime.total = lifetime.total + 1
  current[category] = current[category] + 1
  lifetime[category] = lifetime[category] + 1
  WCF.sessionHidden = current.total
  if WCF.UpdateStatsUI then WCF.UpdateStatsUI() end
end

function WCF.ResetSessionStats()
  session = freshCounts()
  WCF.sessionHidden = 0
  if WCF.UpdateStatsUI then WCF.UpdateStatsUI() end
end

function WCF.ResetAllStats()
  if not WCF.db then WCF.Initialize() end
  WCF.db.stats = freshCounts()
  WCF.ResetSessionStats()
end

-- A dedicated (optional) statistics panel; main settings remain a compact dropdown.
local function label(parent, font, text, x, y, width, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", font)
  fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  fs:SetWidth(width)
  fs:SetHeight(20)
  fs:SetJustifyH(justify or "LEFT")
  fs:SetText(text or "")
  return fs
end

function WCF.UpdateStatsUI()
  if not statsFrame or not statsFrame:IsShown() then return end
  local current, lifetime = WCF.GetStats()
  local i
  for i = 1, table.getn(categories) do
    local category = categories[i]
    cells[category][1]:SetText(tostring(current[category]))
    cells[category][2]:SetText(tostring(lifetime[category]))
  end
  cells.total[1]:SetText(tostring(current.total))
  cells.total[2]:SetText(tostring(lifetime.total))
end

function WCF.BuildStatsUI()
  if statsFrame then return statsFrame end
  local f = CreateFrame("Frame", "WorldChatFilterStatisticsFrame", UIParent)
  f:SetWidth(440)
  f:SetHeight(360)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function() f:StartMoving() end)
  f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
  f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = {left=11, right=12, top=12, bottom=11}
  })
  f:Hide()
  statsFrame = f
  cells = {}

  local close = CreateFrame("Button", "WorldChatFilterStatsClose", f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
  close:SetScript("OnClick", function() f:Hide() end)

  label(f, "GameFontNormalLarge", "World Chat Filter  |cff80e4a0Statistics|r", 23, -23, 365)
  label(f, "GameFontHighlightSmall", "Advertisements hidden from /World (this character)", 24, -54, 390)
  label(f, "GameFontNormal", "Category", 27, -86, 155)
  label(f, "GameFontNormal", "Session", 217, -86, 78, "RIGHT")
  label(f, "GameFontNormal", "All-time", 319, -86, 84, "RIGHT")

  local i
  for i = 1, table.getn(categories) do
    local category = categories[i]
    local top = -115 - (i-1) * 27
    label(f, "GameFontHighlight", category == "Repeats" and "Repeated Messages" or category, 29, top, 175)
    cells[category] = {
      label(f, "GameFontHighlight", "0", 220, top, 75, "RIGHT"),
      label(f, "GameFontHighlight", "0", 321, top, 80, "RIGHT")
    }
  end

  label(f, "GameFontNormal", "TOTAL HIDDEN", 29, -261, 168)
  cells.total = {
    label(f, "GameFontNormal", "0", 220, -261, 75, "RIGHT"),
    label(f, "GameFontNormal", "0", 321, -261, 80, "RIGHT")
  }

  local sessionButton = CreateFrame("Button", "WorldChatFilterResetSession", f, "UIPanelButtonTemplate")
  sessionButton:SetWidth(130)
  sessionButton:SetHeight(23)
  sessionButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, 24)
  sessionButton:SetText("Reset Session")
  sessionButton:SetScript("OnClick", function()
    WCF.ResetSessionStats()
    confirmReset = false
    if resetAllButton then resetAllButton:SetText("Reset All") end
  end)

  resetAllButton = CreateFrame("Button", "WorldChatFilterResetAll", f, "UIPanelButtonTemplate")
  resetAllButton:SetWidth(125)
  resetAllButton:SetHeight(23)
  resetAllButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -25, 24)
  resetAllButton:SetText("Reset All")
  resetAllButton:SetScript("OnClick", function()
    if not confirmReset then
      confirmReset = true
      resetAllButton:SetText("Confirm Reset")
      WCF.Print("Click Confirm Reset to clear all-time statistics for this character.")
    else
      WCF.ResetAllStats()
      confirmReset = false
      resetAllButton:SetText("Reset All")
    end
  end)
  f:SetScript("OnHide", function()
    confirmReset = false
    resetAllButton:SetText("Reset All")
  end)
  return f
end

function WCF.ToggleStatsUI()
  local f = WCF.BuildStatsUI()
  if f:IsShown() then
    f:Hide()
  else
    f:Show()
    WCF.UpdateStatsUI()
  end
end
