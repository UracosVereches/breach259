--[[
lua/weapons/poke_ghost_mirrorcoat.lua
--]]
AddCSLuaFile("poke_ghosttype.lua")
SWEP.Base = "poke_ghosttype"
--[[------------------------------
Configuration
--------------------------------]]
local config = {}
config.SWEPName = "Psychic - Mirror Coat"
config.ActionDelay = 1 -- Time in between each action.
--[[-------------------------------------------------------------------------
Mirror Coat
---------------------------------------------------------------------------]]
config.MirrorCoatDelay = 2
config.MirrorCoatDuration = 5 -- Time until the beam shoots.
config.MirrorCoatDamageMulti = 2 -- Multiply the damage by how much?
config.MirrorCoatDamageCap = 1000 -- Max damage cap? Set to 0 for no cap.

config.MirrorCoatSound = "weapons/physcannon/physcannon_claws_close.wav"
config.MirrorCoatShootSound = "npc/strider/fire.wav"

config.MirrorCoatBeamSize = 16 -- Size of physical beam. ( not visual )
config.MirrorCoatBeamRange = 4567
config.MirrorCoatBeamFX = "fx_poke_mirrorcoatbeam"
--[[-------------------------------------------------------------------------
Messages ( debug )
---------------------------------------------------------------------------]]
config.PrintMessages = false
config.MirrorCoatMessage = "Mirror Coat!"
--[[----------------------
SWEP
------------------------]]
SWEP.PrintName = config.SWEPName
SWEP.Author = "Project Stadium"
SWEP.Purpose = "discord.me/projectstadium"
SWEP.Category = "Project Stadium"
SWEP.Instructions = "Refelect ALL damage taken and send it back x2!"
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
	if SERVER then self:MirrorCoatActivate() end
end
function SWEP:SecondaryAttack() 
	if SERVER then self:MirrorCoatActivate() end
end

