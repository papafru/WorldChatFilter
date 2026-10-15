-- v1.1.3 regression: three /World leaks, repeated Polish leak, and real
-- hook recovery. All checks use the same classifier/handler as the addon.
table.getn=table.getn or function(t) return #t end
SlashCmdList={}
local printed,now,delivered={},100,0
DEFAULT_CHAT_FRAME={AddMessage=function(_,s) table.insert(printed,s) end}
function UnitName() return "CurrentCharacter" end
function GetTime() return now end
function ChatFrame_OnEvent() delivered=delivered+1 end
local frames={}
function CreateFrame(kind,name)
 local f={name=name,scripts={}}
 function f:RegisterEvent() end
 function f:SetScript(which,fn) self.scripts[which]=fn end
 if name then frames[name]=f; _G[name]=f end
 return f
end
WorldChatFilterDB={
 enabled=true,filterGuild=true,filterLFG=true,filterTrade=true,
 filterServices=true,filterRepeats=false,sensitivity="balanced"
}
for _,file in ipairs({"Core.lua","Statistics.lua","Classifier.lua","Filter.lua"}) do
 dofile(file)
end
local W=WorldChatFilter
W.Initialize()
local polish="Polska gildia Chlopaki z Barrensow rekrutuje. Od zera do niskiej klasy sredniej - i to w 60 lvli. Robimy wszystkie dostepne rajdy. Bober kurwa"
local avalon="Want to enjoy OctoWoW for fun, friendship and community instead of speed-running dungeons and rushing to end-game? <Avalon> is a family-friendly and drama-free social, leveling and casual raiding guild for mature and helpful players just like you!"
local ru="lf ru guild leveling"
local cleave="Cleave is hosting a MC/Ony/ZG/K10 -> checkout on: [https://discord.gg/N8DzAxDa3S] fast runs, high efficiency"
local ads={
 avalon,
 "<Lantern> is a welcoming social leveling and casual raiding guild for new players looking for friendship in OctoWoW.",
 "<Fellowship> is a friendly community guild for mature players, casual raid nights and dungeon fun.",
 "<Garden> is a helpful guild for new players, community and leveling together on Turtle WoW.",
 ru,
 "LF russian guild leveling",
 "lf guild",
 "Looking for EU guild leveling",
 "LF english guild pve",
 cleave,
 "Nightfall is hosting MC/Ony/ZG -> check out our discord: https://discord.gg/a1B2c3",
 "Starfall hosts MC/ZG/BWL, join our Discord https://discord.gg/ABCxyz",
 "<Midnight> hosting MC/Ony/ZG, discord for info: https://discord.gg/abcd",
 polish,
 "Polska gildia Nowy Brzeg rekrutuje, robimy wszystkie rajdy.",
}
local chat={
 "I think <Avalon> is a family-friendly social guild for mature players leveling in OctoWoW.",
 "I heard <Fellowship> is a social and friendly guild for helpful players on Turtle WoW.",
 "I saw that <Lantern> is a casual raiding guild for new players yesterday.",
 "What do you think about <Avalon> being a casual guild for mature players?",
 "Our guild is social and helpful, I play with friends.",
 "<Avalon> is a guild, do you know any members?",
 "I like OctoWoW for fun, friendship and community.",
 "Does anyone know a friendly guild for new players on OctoWoW?",
 "What does LF RU guild mean?",
 "LF guild advice about leveling classes",
 "LF guild name suggestions",
 "LF guild tips and resources",
 "Is there an RU guild for casual leveling?",
 "I saw someone say LF ru guild yesterday.",
 "Cleave is hosting MC/Ony/ZG/K10 next week, what is the schedule?",
 "Cleave is hosting MC/Ony/ZG/K10. Where is the entrance?",
 "We ran MC/Ony/ZG/K10 yesterday, it was fun.",
 "The link https://discord.gg/N8DzAxDa3S is a Discord invite.",
 "Someone said Cleave is hosting MC/Ony/ZG on Discord.",
 "A friend sent me https://discord.gg/a1B2c3 for a guild discussion.",
 "I wonder how to host MC/Ony/ZG runs.",
 "What does checkout on Discord mean?",
 "Polska gildia Chlopaki z Barrensow rekrutuje? Czy to prawda?",
 "Czytałem że polska gildia Chlopaki z Barrensow rekrutuje, robimy rajdy.",
 "My guild has 60 levels and does MC raids, what do you think?",
}
for _,mode in ipairs({"careful","balanced","aggressive"}) do
 W.db.sensitivity=mode
 for _,msg in ipairs(ads) do
  local category,score,why,blocked,threshold=W.ClassifyMessage(msg)
  assert(blocked and category=="Guild" and score>=threshold,
     mode.." MISSED: "..msg.." category="..tostring(category)..
     " score="..tostring(score).." threshold="..tostring(threshold)..
     " why="..tostring(why))
 end
 for _,msg in ipairs(chat) do
  local category,score,why,blocked=W.ClassifyMessage(msg)
  assert(not blocked,mode.." FALSE POSITIVE: "..msg..
     " category="..tostring(category).." score="..tostring(score)..
     " why="..tostring(why))
 end
end

W.db.sensitivity="balanced"
local function event(msg,channel,author,base,decorated)
 now=now+1
 arg1,arg2,arg4,arg7,arg9=msg,author or "AnotherPlayer",
    decorated or ("4. "..channel),7,base or channel
 local beforeShown,beforeCount=delivered,W.GetStats().total
 ChatFrame_OnEvent("CHAT_MSG_CHANNEL")
 return delivered-beforeShown,W.GetStats().total-beforeCount
end
for _,ad in ipairs({avalon,ru,cleave,polish}) do
 local displayed,filtered=event(ad,"World")
 assert(displayed==0 and filtered==1,"should block /World advert")
 for _,channel in ipairs({"Trade","General","LookingForGroup","Guild","Party","Raid","Whisper"}) do
  displayed,filtered=event(ad,channel)
  assert(displayed==1 and filtered==0,"must never hide "..channel)
 end
 displayed,filtered=event(ad,"World","AnotherPlayer","world","5. World")
 assert(displayed==0 and filtered==1,"must detect dynamic numbered /World")
end
local stats=W.GetStats()
assert(stats.Guild==8,"all blocked messages must count once as Guild")
for _,msg in ipairs({chat[1],chat[9],chat[12],chat[17],chat[22]}) do
 local shown,hidden=event(msg,"World")
 assert(shown==1 and hidden==0,"ordinary World conversation was filtered")
end
W.db.filterGuild=false
for _,ad in ipairs({avalon,ru,cleave,polish}) do
 local shown,hidden=event(ad,"World")
 assert(shown==1 and hidden==0,"Guild toggle OFF must allow all")
end
W.db.filterGuild=true
W.db.enabled=false
local shown,hidden=event(polish,"World")
assert(shown==1 and hidden==0,"master OFF must allow Polish ad")
W.db.enabled=true
shown,hidden=event(polish,"World","CurrentCharacter")
assert(shown==1 and hidden==0,"own messages must pass")

-- Explicitly reproduce a second addon REPLACING the central handler after
-- login: this is a separate failure mode from poor classifier scoring.
local replaced=0
ChatFrame_OnEvent=function() replaced=replaced+1; delivered=delivered+1 end
shown,hidden=event(polish,"World")
assert(shown==1 and hidden==0,"missing hook should reproduce visible Polish leak")
assert(W.CheckChatHook and W.chatHook ~= ChatFrame_OnEvent)
local watchdog=frames.WorldChatFilterInitFrame.scripts.OnUpdate
assert(type(watchdog)=="function")
now=now+6
watchdog()
assert(ChatFrame_OnEvent==W.chatHook and W.hookRepairs>=1,
 "watchdog must recover overwritten chat handler")
shown,hidden=event(polish,"World")
assert(shown==0 and hidden==1,"Polish ad should be blocked again after recovery")
assert(replaced==1,"replaced wrapper should not receive blocked event")

-- "doctor" diagnoses loaded version, toggles, hook, channel gate & actual
-- classification. It should not modify saved variables or rely on UI.
local before=#printed
SlashCmdList.WORLDCHATFILTER("doctor")
assert(#printed>=before+3)
local messages=table.concat(printed," ")
assert(string.find(messages,"version 1.1.3-dev",1,true))
assert(string.find(messages,"Polish test=BLOCK",1,true))
assert(string.find(messages,"hook=attached",1,true))
assert(string.find(messages,"World gate=OK",1,true))
W.db.filterGuild=false
SlashCmdList.WORLDCHATFILTER("doctor")
assert(string.find(printed[#printed-3],"Guild=OFF",1,true),
 "doctor should expose a disabled Guild toggle")
W.db.filterGuild=true

-- Manual repair supports addon managers/third-party chat hooks.
ChatFrame_OnEvent=function() delivered=delivered+1 end
SlashCmdList.WORLDCHATFILTER("rehook")
assert(ChatFrame_OnEvent==W.chatHook)
shown,hidden=event(avalon,"World")
assert(shown==0 and hidden==1,"manual rehook must restore filtering")
print("PASS guild showcase, LF RU guild, Discord promotion, Polish repeat and chat-hook self-repair")
