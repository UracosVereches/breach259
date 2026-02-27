--[[
lua/weapons/poke_ghost_confuseray.lua
--]]
AddCSLuaFile("poke_ghosttype.lua")
SWEP.Base = "poke_ghosttype"
--[[------------------------------
Configuration
--------------------------------]]
local config = {}
config.SWEPName = "Ghost - Confuse Ray"
config.ActionDelay = 1 -- Time in between each action.
config.ConfuseRayDelay = 2
config.ConfuseRayDamageLow = 0
config.ConfuseRayDamageHigh = 0
config.ConfuseRaySize = 16   -- How big is the ray itself?
config.ConfuseRayRadius = 96 -- Radius of ray impact.
config.ConfuseRayRange = 512 -- How far the ray will travel.
config.ConfuseRayInterval = 0.1 -- Time in between rings.
config.ConfuseRayNumber = 10 -- How many rings? ( these deal damage )

config.ConfusionExpire = 7 -- How long until confusion expires?
config.ConfusionRandomAim = true -- Will this fling their aim around?
config.ConfusionHurtDamageLow = 3
config.ConfusionHurtDamageHigh = 5
config.ConfusionHurtChance = 50 -- Out of 100, if it is greater than this.

config.ConfuseRayFX = "fx_poke_confuseray"
config.ConfuseRaySound = "npc/manhack/bat_away.wav"
--[[-------------------------------------------------------------------------
Messages ( debug )
---------------------------------------------------------------------------]]
config.PrintMessages = false
config.ConfuseRayMessage = "Confuse Ray!"
--[[----------------------
SWEP
------------------------]]
SWEP.PrintName = config.SWEPName
SWEP.Author = "Project Stadium"
SWEP.Purpose = "discord.me/projectstadium"
SWEP.Category = "Project Stadium"
SWEP.Instructions = "Confuse your enemy with a ray of light!"
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
	if SERVER then self:ConfuseRay() end
end
function SWEP:SecondaryAttack() 
end

