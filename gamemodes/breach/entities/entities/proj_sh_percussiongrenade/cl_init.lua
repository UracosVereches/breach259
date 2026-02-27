--[[
addons/lua_crap/lua/entities/proj_sh_percussiongrenade/cl_init.lua
--]]
include("shared.lua")

function ENT:Initialize()
	self:SetSubMaterial(0, "models/weapons/w_models/w_eq_percussiongrenade/w_eq_percussiongrenade")
end

