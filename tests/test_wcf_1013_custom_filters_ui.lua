-- Vanilla UI mocks: end-to-end custom manager, dropdown and saved entries.
table.getn=table.getn or function(t) return #t end
SlashCmdList={}
DEFAULT_CHAT_FRAME={AddMessage=function() end}
function UnitName() return "Tester" end
local frames={}
local function mock(kind,name,parent)
  local f={kind=kind, name=name, parent=parent, scripts={}, text="",visible=true,enabled=true}
  function f:GetName() return self.name end
  function f:SetPoint(...) self.point={...} end
  function f:SetWidth(x) self.width=x end
  function f:SetHeight(x) self.height=x end
  function f:SetText(x) self.text=x end
  function f:GetText() return self.text end
  function f:Show() self.visible=true end
  function f:Hide() self.visible=false end
  function f:IsShown() return self.visible end
  function f:Enable() self.enabled=true end
  function f:Disable() self.enabled=false end
  function f:EnableMouse() end
  function f:SetMovable() end
  function f:RegisterForDrag() end
  function f:RegisterEvent() end
  function f:SetFrameStrata() end
  function f:SetBackdrop() end
  function f:SetAutoFocus() end
  function f:SetMaxLetters() end
  function f:ClearFocus() self.unfocused=true end
  function f:SetScript(name,fn) self.scripts[name]=fn end
  function f:GetScript(name) return self.scripts[name] end
  function f:CreateFontString()
    local result=mock("FontString",nil,self)
    function result:SetJustifyH() end
    return result
  end
  function f:StartMoving() end
  function f:StopMovingOrSizing() end
  frames[#frames+1]=f
  if name then _G[name]=f end
  return f
end
UIParent=mock("Frame","UIParent",nil)
function CreateFrame(kind,name,parent) return mock(kind,name,parent) end
function getglobal(name) return _G[name] end
local entries,closed={},0
function UIDropDownMenu_CreateInfo() return {} end
function UIDropDownMenu_AddButton(info,level)
  entries[#entries+1]={info=info,level=level}
end
function UIDropDownMenu_Initialize(frame,fn) frame.initialize=fn end
function CloseDropDownMenus() closed=closed+1 end
WorldChatFilterDB=nil
for _,name in ipairs({"Core.lua","CustomFilters.lua","CustomFiltersUI.lua","UI.lua"}) do dofile(name) end
local W=WorldChatFilter
W.Initialize()
W.BuildUI()
assert(WorldChatFilterSettingsDropdown.initialize,"settings menu missing")
entries={}
WorldChatFilterSettingsDropdown.initialize(nil,1)
local menuItem=nil
for _,entry in ipairs(entries) do
 if entry.info.text=="Custom Filters" then menuItem=entry.info end
end
assert(menuItem and menuItem.hasArrow and menuItem.value=="custom","missing Custom Filters submenu")
entries={}
UIDROPDOWNMENU_MENU_VALUE="custom"
WorldChatFilterSettingsDropdown.initialize(nil,2)
local enabled,manager=nil,nil
for _,entry in ipairs(entries) do
 if entry.info.text=="Enable Custom Filters" then enabled=entry.info end
 if entry.info.text=="Manage Blocked Players & Phrases..." then manager=entry.info end
end
assert(enabled and manager and type(manager.func)=="function","custom submenu controls missing")
manager.func()
local panel=WorldChatFilterCustomFiltersFrame
assert(panel and panel:IsShown() and closed==1,"manager frame must open from dropdown")
assert(panel.customState:GetText()=="Custom filtering: ON","custom status default")
local edits,adds={},{}
for _,frame in ipairs(frames) do
 if frame.kind=="EditBox" then edits[#edits+1]=frame end
 if frame.kind=="Button" and frame.text=="Add" then adds[#adds+1]=frame end
end
assert(#edits==2 and #adds==2,"player and phrase editing controls missing")
edits[1]:SetText("ChatSpammer")
adds[1].scripts.OnClick()
assert(W.IsBlockedPlayer("chatspammer") and edits[1]:GetText()=="","GUI Add player")
edits[2]:SetText("discord.gg")
adds[2].scripts.OnClick()
assert(#W.db.blockedPhrases==1 and W.db.blockedPhrases[1].wholeWord==false,
       "GUI default partial phrase")
local wholeToggle
for _,frame in ipairs(frames) do
 if frame.kind=="Button" and frame.text=="Partial match" then wholeToggle=frame end
end
assert(wholeToggle and wholeToggle.scripts.OnClick,"match mode toggle missing")
wholeToggle.scripts.OnClick()
assert(wholeToggle:GetText()=="Whole word","whole word UI state")
edits[2]:SetText("Boost")
adds[2].scripts.OnClick()
assert(#W.db.blockedPhrases==2 and W.db.blockedPhrases[2].wholeWord,
       "GUI whole word must persist with entry")
local foundPlayer,foundWhole=false,false
for _,frame in ipairs(frames) do
 if frame.kind=="FontString" and frame.text=="ChatSpammer" then foundPlayer=true end
 if frame.kind=="FontString" and frame.text=="Boost  [word]" then foundWhole=true end
end
assert(foundPlayer and foundWhole,"GUI list must show saved entries and match mode")
local removePlayer
for _,frame in ipairs(frames) do
 if frame.kind=="Button" and frame.text=="X" and frame.point and frame.point[4]==249 then
  removePlayer=frame
  break
 end
end
assert(removePlayer and removePlayer:IsShown(),"player row must show a remove button")
removePlayer.scripts.OnClick()
assert(not W.IsBlockedPlayer("chatspammer"),"GUI removal must update SavedVariables")
enabled.func()
assert(not W.db.customEnabled,"custom submenu enabled toggle")
W.RefreshCustomFiltersUI()
assert(panel.customState:GetText()=="Custom filtering: OFF","manager must reflect submenu change")
enabled.func()
assert(W.db.customEnabled,"custom submenu should re-enable filter")
W.ToggleCustomFiltersUI()
assert(not panel:IsShown(),"manager should close")
W.ToggleCustomFiltersUI()
assert(panel:IsShown(),"manager should re-open")
print("PASS v1.1 custom GUI: native submenu, two inputs, modes, rows/removal, enable, frame toggle")
