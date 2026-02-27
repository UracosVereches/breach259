--[[
addons/lua_crap/lua/entities/proj_sh_electricgrenade/shared.lua
--]]
ENT.Type = "anim"
ENT.PrintName = "Electric Grenade"

ENT.Spawnable = false

ENT.Model = Model("models/weapons/w_eq_flashbang.mdl")
ENT.BounceSound = Sound("weapons/flashbang/grenade_hit1.wav")
ENT.LifeTime = 3

util.PrecacheSound("weapons/smokegrenade/sg_explode.wav")

