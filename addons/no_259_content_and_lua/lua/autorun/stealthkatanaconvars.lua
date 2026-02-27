--[[
addons/lua_crap/lua/autorun/stealthkatanaconvars.lua
--]]
if GetConVar("RSK_Cloak_Cooldown") == nil then
CreateConVar("RSK_Cloak_Cooldown", 5, { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Sets the cooldown period between cloaks, default is 5 seconds")
print("RSK_Cloak_Cooldown Con Var Created")
end





if GetConVar("RSK_Shuriken_Cooldown") == nil then
CreateConVar( "RSK_Shuriken_Cooldown", 5, { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Sets the cooldown time of Shurikens in seconds, default is 5 seconds") 
print("RSK_Shuriken_Cooldown Con Var Created")
end

if GetConVar("RSK_1st_Person") == nil then
CreateConVar( "RSK_1st_Person", 1, { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Sets the view to 1st person, 1 for true, 0 for false") 
print("Server RSK_1st_Person Con Var Created")
end

if GetConVar("RSK_1st_Person") == nil then
CreateClientConVar( "RSK_1st_Person", 0, false, true)
print("Client RSK_1st_Person Con Var Created")
end

