--[[
lua/weapons/poke_ghost_nightshade.lua
--]]
AddCSLuaFile("poke_ghosttype.lua")
SWEP.Base = "poke_ghosttype"
--[[------------------------------
Configuration
--------------------------------]]
local config = {}
config.SWEPName = "Ghost - Night Shade"
config.ActionDelay = 1 -- Time in between each action.
--[[-------------------------------------------------------------------------
Night Shade
---------------------------------------------------------------------------]]
config.NightShadeDelay = 0.7
config.NightShadeClawLife = 3 -- How long does each claw last?
config.NightShadeClawSpeed = 512

config.NightShadeSound = "weapons/underwater_explode4.wav"
--[[-------------------------------------------------------------------------
Messages ( debug )
---------------------------------------------------------------------------]]
config.PrintMessages = false
config.NightShadeMessage = "Night Shade!"
--[[----------------------
SWEP
------------------------]]
SWEP.PrintName = config.SWEPName
SWEP.Author = "Project Stadium"
SWEP.Purpose = "discord.me/projectstadium"
SWEP.Category = "Project Stadium"
SWEP.Instructions = "Send a line of shadowy claws that hurt your target based on their hp."
SWEP.HoldType = "fist"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false
SWEP.UseHands = false
SWEP.ViewModelFOV = 54

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"
--[[-------------------------------------------------------------------------
Default SWEP functions
---------------------------------------------------------------------------]]
function SWEP:Think()
end

function SWEP:PrimaryAttack() 
	if SERVER then self:NightShade() end
end
function SWEP:SecondaryAttack() 
end

