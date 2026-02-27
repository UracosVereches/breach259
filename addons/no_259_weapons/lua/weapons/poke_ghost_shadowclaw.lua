--[[
lua/weapons/poke_ghost_shadowclaw.lua
--]]
AddCSLuaFile("poke_ghost_shadowclaw.lua")
SWEP.Base = "poke_ghosttype"
--[[------------------------------
Configuration
--------------------------------]]
local config = {}
config.SWEPName = "Ghost - Shadow Claw"
config.ActionDelay = 1 -- Time in between each action.
--[[-------------------------------------------------------------------------
Shadow Claw
---------------------------------------------------------------------------]]
config.ShadowClawDelay = 2
config.ShadowClawDuration = 10
config.MeleeAttackDelay 		= 1   -- Time in between punches.
config.MeleePunchRange 			= 135  -- Distance between you and the target.
config.MeleeDamageLow 			= 15
config.MeleeDamageHigh 			= 25
config.MeleePunchForce 			= 20 -- How much force to apply to targets?

config.MeleeSwingSound = Sound( "WeaponFrag.Throw" )
config.MeleePunchSound = Sound( "Flesh.ImpactHard" )
config.MeleeEffect = "fx_poke_shadowmelee"
--[[-------------------------------------------------------------------------
Messages ( debug )
---------------------------------------------------------------------------]]
config.PrintMessages = false
config.ShadowClawMessage = "Shadow Claw!"
config.MeleeAttackMessage 	= "Shadow Claw Attack!"
--[[----------------------
SWEP
------------------------]]
SWEP.PrintName = config.SWEPName
SWEP.Author = "Project Stadium"
SWEP.Purpose = "discord.me/projectstadium"
SWEP.Category = "Project Stadium"
SWEP.Instructions = "Grasp your claws and strike your foe with this melee attack!"
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
	local owner = self:GetOwner()
	if owner:KeyDown(IN_USE) && owner:KeyDown(IN_RELOAD) then
		if self.NextMeleeToggle < CurTime() then
			self:ShadowClawActivate()
			self.NextMeleeToggle = CurTime() + config.ShadowClawDelay
		end
	end
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	if (idletime > 0 && CurTime() > idletime) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0"..math.random(1,2)))
		self:UpdateNextIdle()
	end
	if (self.MeleeAttacked > 0) then
		self:DealDamage()
		self.MeleeAttacked = 0
	end
	if (SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1) then
		self:SetCombo(0)
	end
end

function SWEP:PrimaryAttack() 
	if self.UsingMelee then self:MeleeAttack() end
end
function SWEP:SecondaryAttack() 
	if self.UsingMelee then self:MeleeAttack() end
end

