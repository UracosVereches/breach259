--[[
lua/autorun/scp_unity_106_npc.lua
--]]
local Category = "SCP Unity"
local NPC = {
		 		Name = "Friendly SCP-106", 
				Class = "npc_citizen",
				KeyValues = { citizentype = 4 },
				Model = "models/scp/106/unity/unity_scp_106_npc_cm.mdl",
				Health = "100",
				Category = Category	
		}
list.Set( "NPC", "npc_friendly_scp106", NPC )
local Category = "SCP Unity"
local NPC = {
		 		Name = "Hostile SCP-106", 
				Class = "npc_combine_s",
				KeyValues = { citizentype = 4 },
				Model = "models/scp/106/unity/unity_scp_106_npc_cs.mdl",
				Health = "100",
				Category = Category	
		}
list.Set( "NPC", "npc_hostile_scp106", NPC )


