-- WorldChatFilter v1.1: Vanilla-compatible personal filters manager.
-- Two paginated lists; no modern ScrollBox/Settings widgets required.
local WCF = WorldChatFilter
local panel, playerEntry, phraseEntry, modeButton
local page = {players=1, phrases=1}
local rows = {players={}, phrases={}}
local pageControls = {}
local wholeWord = false
local perPage = 7

local function label(parent, font, text, x, y, width)
  local fs = parent:CreateFontString(nil, "OVERLAY", font)
  fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  fs:SetWidth(width)
  fs:SetHeight(21)
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

local function input(parent, name, x, y, width)
  -- Vanilla InputBoxTemplate uses $parentLeft / $parentMiddle / $parentRight
  -- and anchors the middle texture to its named siblings. Every input MUST
  -- have a unique global name or the second input can lose its center border.
  local edit = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
  edit:SetWidth(width)
  edit:SetHeight(22)
  edit:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  edit:SetAutoFocus(false)
  edit:SetMaxLetters(120)
  edit:SetScript("OnEscapePressed", function() edit:ClearFocus() end)
  return edit
end

local function logResult(ok, message, labelText)
  if ok then WCF.Print(labelText .. ": " .. message)
  else WCF.Print(message or "Unable to update custom filters.") end
end

local function addPlayer()
  local ok, result = WCF.AddBlockedPlayer(playerEntry:GetText())
  if ok then playerEntry:SetText("") playerEntry:ClearFocus() end
  logResult(ok, result, "Blocked World player")
end

local function addPhrase()
  local ok, result = WCF.AddBlockedPhrase(phraseEntry:GetText(), wholeWord)
  if ok then phraseEntry:SetText("") phraseEntry:ClearFocus() end
  logResult(ok, result, "Blocked World phrase")
end

local function buildRows(group, left)
  local i
  for i=1,perPage do
    local entry = {}
    entry.label = label(panel, "GameFontHighlightSmall", "", left, -214-(i-1)*27, 205)
    entry.remove = button(panel, "X", left+219, -214-(i-1)*27, 28, function()
      if entry.value then
        if group == "players" then WCF.RemoveBlockedPlayer(entry.value)
        else WCF.RemoveBlockedPhrase(entry.value) end
      end
    end)
    entry.remove:Hide()
    rows[group][i] = entry
  end
  local groupKey=group
  local prev = button(panel, "< Prev", left, -404, 75, function()
    if page[groupKey] > 1 then
      page[groupKey] = page[groupKey]-1
      WCF.RefreshCustomFiltersUI()
    end
  end)
  local next = button(panel, "Next >", left+170, -404, 75, function()
    page[groupKey]=page[groupKey]+1
    WCF.RefreshCustomFiltersUI()
  end)
  local pageText = label(panel, "GameFontHighlightSmall", "", left+81, -403, 90)
  pageControls[groupKey] = {prev=prev,next=next,text=pageText}
end

function WCF.RefreshCustomFiltersUI()
  if not panel then return end
  local db = WCF.db
  if not db then return end
  if panel.customState then
    panel.customState:SetText(db.customEnabled and "Custom filtering: ON" or
                                "Custom filtering: OFF")
  end
  if modeButton then
    modeButton:SetText(wholeWord and "Whole word" or "Partial match")
  end
  local groups = {
    {key="players",items=db.blockedPlayers},
    {key="phrases",items=db.blockedPhrases}
  }
  local _,group
  for _,group in ipairs(groups) do
    local key,items = group.key,group.items
    local n = table.getn(items)
    local maxPage=math.max(1,math.ceil(n/perPage))
    if page[key]>maxPage then page[key]=maxPage end
    local i
    for i=1,perPage do
      local index=(page[key]-1)*perPage+i
      local entry=items[index]
      local row=rows[key][i]
      if entry then
        row.value=key=="players" and entry or entry.text
        local shown=key=="players" and entry or (entry.text .. (entry.wholeWord and "  [word]" or "  [partial]"))
        row.label:SetText(shown)
        row.remove:Show()
      else
        row.value=nil
        row.label:SetText("")
        row.remove:Hide()
      end
    end
    local controls=pageControls[key]
    controls.text:SetText(page[key].."/"..maxPage)
    if page[key]>1 then controls.prev:Enable() else controls.prev:Disable() end
    if page[key]<maxPage then controls.next:Enable() else controls.next:Disable() end
  end
end

function WCF.BuildCustomFiltersUI()
  if panel then return panel end
  if not WCF.db then WCF.Initialize() end
  local f=CreateFrame("Frame","WorldChatFilterCustomFiltersFrame",UIParent)
  f:SetWidth(625)
  f:SetHeight(470)
  f:SetPoint("CENTER",UIParent,"CENTER",0,0)
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart",function() f:StartMoving() end)
  f:SetScript("OnDragStop",function() f:StopMovingOrSizing() end)
  f:SetBackdrop({
    bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
    tile=true,tileSize=32,edgeSize=32,
    insets={left=11,right=12,top=12,bottom=11}
  })
  f:Hide()
  panel=f

  local close=CreateFrame("Button","WorldChatFilterCustomFiltersClose",f,"UIPanelCloseButton")
  close:SetPoint("TOPRIGHT",f,"TOPRIGHT",-5,-5)
  close:SetScript("OnClick",function() f:Hide() end)

  label(f,"GameFontNormalLarge","World Chat Filter  |cff80e4a0Custom Filters|r",22,-22,460)
  label(f,"GameFontHighlightSmall","Your personal lists affect ONLY /World. Other channels and whispers are untouched.",25,-51,570)
  local enabled=button(f,"",24,-78,178,function()
    WCF.db.customEnabled=not WCF.db.customEnabled
    if WCF.InvalidateMessageCache then WCF.InvalidateMessageCache() end
    WCF.RefreshCustomFiltersUI()
  end)
  f.customState=enabled
  label(f,"GameFontNormal","Blocked Players",26,-114,240)
  label(f,"GameFontNormal","Blocked Words / Phrases",332,-114,260)

  playerEntry=input(f,"WorldChatFilterBlockedPlayerInput",30,-142,175)
  playerEntry:SetMaxLetters(64)
  playerEntry:SetScript("OnEnterPressed",addPlayer)
  button(f,"Add",217,-142,65,addPlayer)

  phraseEntry=input(f,"WorldChatFilterBlockedPhraseInput",336,-142,175)
  phraseEntry:SetScript("OnEnterPressed",addPhrase)
  button(f,"Add",523,-142,65,addPhrase)
  modeButton=button(f,"Partial match",334,-172,170,function()
    wholeWord=not wholeWord
    WCF.RefreshCustomFiltersUI()
  end)
  label(f,"GameFontHighlightSmall","Match mode",510,-171,100)

  buildRows("players",30)
  buildRows("phrases",335)
  label(f,"GameFontHighlightSmall","X removes an entry. Changes save automatically per character.",27,-444,570)

  WCF.RefreshCustomFiltersUI()
  return panel
end

function WCF.ToggleCustomFiltersUI()
  local f=WCF.BuildCustomFiltersUI()
  if f:IsShown() then
    f:Hide()
  else
    if type(CloseDropDownMenus)=="function" then CloseDropDownMenus() end
    WCF.RefreshCustomFiltersUI()
    f:Show()
  end
end
