-- WorldChatFilter v1.1: compact two-tab Vanilla 1.12 custom filter manager.
-- Uses original TabButtonTemplate / PanelTemplates and a single named input.
local WCF = WorldChatFilter
local panel, entryInput, addButton, modeButton, modeLabel, inputLabel
local listTitle, listCount, hint, pageLabel, prevButton, nextButton
local rows, tabs = {}, {}
local activeTab = "players"
local pages = {players=1, phrases=1}
local wholeWord = false
local perPage = 6

local function label(parent, font, text, x, y, width)
  local fs = parent:CreateFontString(nil, "OVERLAY", font)
  fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  fs:SetWidth(width)
  fs:SetHeight(20)
  fs:SetJustifyH("LEFT")
  fs:SetText(text or "")
  return fs
end

local function button(parent, title, x, y, width, onclick)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetWidth(width)
  btn:SetHeight(23)
  btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  btn:SetText(title)
  btn:SetScript("OnClick", onclick)
  return btn
end

local function itemsForTab(tab)
  if tab == "players" then return WCF.db.blockedPlayers end
  return WCF.db.blockedPhrases
end

local function addEntry()
  local value = entryInput:GetText()
  local ok, result
  if activeTab == "players" then
    ok, result = WCF.AddBlockedPlayer(value)
  else
    ok, result = WCF.AddBlockedPhrase(value, wholeWord)
  end
  if ok then
    entryInput:SetText("")
    entryInput:ClearFocus()
    -- Show the newly added item instead of leaving it on an earlier page.
    pages[activeTab] = math.max(1, math.ceil(table.getn(itemsForTab(activeTab)) / perPage))
    WCF.Print((activeTab == "players" and "Blocked World player: " or
               "Blocked World phrase: ") .. result)
    WCF.RefreshCustomFiltersUI()
  else
    WCF.Print(result or "Unable to add custom filter.")
  end
end

function WCF.SetCustomFiltersTab(tab)
  if tab ~= "players" and tab ~= "phrases" then return false end
  if not panel then WCF.BuildCustomFiltersUI() end
  if not panel then return false end
  if activeTab ~= tab then
    entryInput:ClearFocus()
    entryInput:SetText("")
  end
  activeTab = tab
  if type(PanelTemplates_SetTab) == "function" then
    PanelTemplates_SetTab(panel, tab == "players" and 1 or 2)
  end
  WCF.RefreshCustomFiltersUI()
  return true
end

function WCF.RefreshCustomFiltersUI()
  if not panel or not WCF.db then return end
  local db = WCF.db
  panel.customState:SetText(db.customEnabled and "Custom Filtering: ON" or "Custom Filtering: OFF")
  local phrases = activeTab == "phrases"

  inputLabel:SetText(phrases and "Add a word or phrase" or "Add a player")
  listTitle:SetText(phrases and "Blocked Words / Phrases" or "Blocked Players")
  modeLabel:SetText("Matching method")
  modeButton:SetText(wholeWord and "Whole word" or "Partial match")
  if phrases then
    modeLabel:Show()
    modeButton:Show()
    hint:Hide()
  else
    modeLabel:Hide()
    modeButton:Hide()
    hint:Show()
  end

  local items = itemsForTab(activeTab)
  local count = table.getn(items)
  listCount:SetText(tostring(count) .. (count == 1 and " entry" or " entries"))
  local maxPage = math.max(1, math.ceil(count / perPage))
  if pages[activeTab] > maxPage then pages[activeTab] = maxPage end

  local i
  for i=1,perPage do
    local item = items[(pages[activeTab]-1)*perPage+i]
    local row = rows[i]
    if item then
      row.value = phrases and item.text or item
      local text = phrases and (item.text .. (item.wholeWord and
          "  |cffd1b77f[whole word]|r" or "  |cffd1b77f[partial]|r")) or item
      row.label:SetText(text)
      row.background:Show()
      row.remove:Show()
    else
      row.value = nil
      row.label:SetText("")
      row.background:Hide()
      row.remove:Hide()
    end
  end
  pageLabel:SetText("Page " .. pages[activeTab] .. " / " .. maxPage)
  if pages[activeTab] > 1 then prevButton:Enable() else prevButton:Disable() end
  if pages[activeTab] < maxPage then nextButton:Enable() else nextButton:Disable() end
end

function WCF.BuildCustomFiltersUI()
  if panel then return panel end
  if not WCF.db then WCF.Initialize() end
  local f = CreateFrame("Frame", "WorldChatFilterCustomFiltersFrame", UIParent)
  f:SetWidth(530)
  f:SetHeight(460)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function() f:StartMoving() end)
  f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
  -- More opaque than the former dialog, so World/gameplay does not visually
  -- compete with list entries. Original Blizzard backdrop and border assets.
  f:SetBackdrop({
    bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
    tile=true, tileSize=16, edgeSize=32,
    insets={left=11, right=12, top=12, bottom=11}
  })
  f:SetBackdropColor(0.085, 0.065, 0.13, 0.97)
  f:Hide()
  panel = f

  local close = CreateFrame("Button", "WorldChatFilterCustomFiltersClose", f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
  close:SetScript("OnClick", function() f:Hide() end)

  label(f, "GameFontNormalLarge", "World Chat Filter  |cff80e4a0Custom Filters|r", 23, -22, 455)
  label(f, "GameFontHighlightSmall", "Only /World is affected. Other channels and whispers are untouched.", 26, -52, 485)
  local enabled = button(f, "", 25, -79, 183, function()
    WCF.db.customEnabled = not WCF.db.customEnabled
    if WCF.InvalidateMessageCache then WCF.InvalidateMessageCache() end
    WCF.RefreshCustomFiltersUI()
  end)
  f.customState = enabled
  label(f, "GameFontHighlightSmall", "Saved automatically per character", 228, -80, 275)

  -- These are the genuine Vanilla Blizzard tab textures, not modern retail UI.
  local tab1 = CreateFrame("Button", f:GetName() .. "Tab1", f, "TabButtonTemplate")
  tab1:SetText("Blocked Players")
  tab1:SetPoint("TOPLEFT", f, "TOPLEFT", 27, -114)
  local tab2 = CreateFrame("Button", f:GetName() .. "Tab2", f, "TabButtonTemplate")
  tab2:SetText("Words & Phrases")
  tab2:SetPoint("LEFT", tab1, "RIGHT", 5, 0)
  if type(PanelTemplates_TabResize) == "function" then
    PanelTemplates_TabResize(0, tab1, 216)
    PanelTemplates_TabResize(0, tab2, 216)
  end
  tabs[1], tabs[2] = tab1, tab2
  tab1:SetScript("OnClick", function() WCF.SetCustomFiltersTab("players") end)
  tab2:SetScript("OnClick", function() WCF.SetCustomFiltersTab("phrases") end)
  if type(PanelTemplates_SetNumTabs) == "function" then PanelTemplates_SetNumTabs(f, 2) end
  if type(PanelTemplates_SetTab) == "function" then PanelTemplates_SetTab(f, 1) end

  inputLabel = label(f, "GameFontNormal", "", 30, -158, 410)
  -- InputBoxTemplate uses $parentLeft/Middle/Right; it MUST have a name.
  entryInput = CreateFrame("EditBox", "WorldChatFilterCustomEntryInput", f, "InputBoxTemplate")
  entryInput:SetWidth(348)
  entryInput:SetHeight(22)
  entryInput:SetPoint("TOPLEFT", f, "TOPLEFT", 34, -185)
  entryInput:SetAutoFocus(false)
  entryInput:SetMaxLetters(120)
  entryInput:SetScript("OnEscapePressed", function() entryInput:ClearFocus() end)
  entryInput:SetScript("OnEnterPressed", addEntry)
  addButton = button(f, "Add", 404, -185, 89, addEntry)

  hint = label(f, "GameFontHighlightSmall", "Tip: Right-click a chat name to block from /World.", 31, -216, 470)
  modeLabel = label(f, "GameFontHighlightSmall", "Matching method", 31, -216, 200)
  modeButton = button(f, "", 312, -216, 180, function()
    wholeWord = not wholeWord
    WCF.RefreshCustomFiltersUI()
  end)

  listTitle = label(f, "GameFontNormal", "", 31, -252, 322)
  listCount = label(f, "GameFontHighlightSmall", "", 415, -251, 90)

  local i
  for i=1,perPage do
    local row = {}
    local top = -280-(i-1)*24
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    bg:SetVertexColor(0.24, 0.20, 0.32, 0.6)
    bg:SetWidth(475)
    bg:SetHeight(23)
    bg:SetPoint("TOPLEFT", f, "TOPLEFT", 27, top)
    row.background = bg
    row.label = label(f, "GameFontHighlightSmall", "", 38, top-1, 362)
    row.remove = button(f, "Remove", 414, top, 79, function()
      if row.value then
        if activeTab == "players" then WCF.RemoveBlockedPlayer(row.value)
        else WCF.RemoveBlockedPhrase(row.value) end
      end
    end)
    row.remove:SetHeight(21)
    row.remove:Hide()
    bg:Hide()
    rows[i] = row
  end

  prevButton = button(f, "< Previous", 30, -426, 103, function()
    if pages[activeTab] > 1 then
      pages[activeTab] = pages[activeTab] - 1
      WCF.RefreshCustomFiltersUI()
    end
  end)
  nextButton = button(f, "Next >", 390, -426, 103, function()
    pages[activeTab] = pages[activeTab] + 1
    WCF.RefreshCustomFiltersUI()
  end)
  pageLabel = label(f, "GameFontHighlightSmall", "", 228, -425, 150)

  WCF.RefreshCustomFiltersUI()
  return f
end

function WCF.ToggleCustomFiltersUI()
  local f = WCF.BuildCustomFiltersUI()
  if f:IsShown() then
    f:Hide()
  else
    if type(CloseDropDownMenus) == "function" then CloseDropDownMenus() end
    WCF.RefreshCustomFiltersUI()
    f:Show()
  end
end
