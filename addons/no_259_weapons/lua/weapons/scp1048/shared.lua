--[[
lua/weapons/scp1048/shared.lua
--]]
SWEP.PrintName				= "SCP-1048"		-- Weapon name (Shown on HUD)	

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end


SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 0.1
SWEP.Primary.Automatic	= true
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 3
SWEP.Secondary.Ammo		= "None"

SWEP.ISSCP 				= true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.teams					= {1}

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
--SWEP.IconLetter			= "w"
SWEP.HoldType 			= "melee"


function SWEP:PrimaryAttack() --On Mouse1
if SERVER then
	if (  !self:CanPrimaryAttack() ) then return end
	self:SetNextPrimaryFire( CurTime() + 1.0 )
	local randomgun = { 
      "ОРУЖЕЧКИ",
};
	local randomgun = table.Random(randomgun)
	local player = self.Owner
	local weapon = ents.Create(randomgun)
	weapon:SetPos( player:GetPos() )
	weapon:SetOwner( player )
	weapon:Spawn()
	end
end

function SWEP:TakePrimaryAmmo( num )
end

