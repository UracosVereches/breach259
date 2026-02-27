ENT.Base 			= "npc_vj_animal_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "SCP-131A"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "SCP"

if (CLIENT) then
local Name = "SCP-131A"
local LangName = "npc_scp_131a"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end