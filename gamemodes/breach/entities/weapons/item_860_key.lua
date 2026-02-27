--[[
gamemodes/breach/entities/weapons/item_860_key.lua
--]]
--SWEP.Author			= ""
--SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
--SWEP.Purpose		= "Open certain doors"
--SWEP.Instructions	= "If you hold it, you can open doors with level 3"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/scp860key/scp860key.mdl"
SWEP.WorldModel		= "models/scp860key/scp860key.mdl"

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/key")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName		= "SCP 860"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.clevel					= 1


SWEP.droppable				= true
SWEP.teams					= {2,3,4,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands				= true


function SWEP:Deploy()
	self.Owner:DrawViewModel( true )
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end
function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetSkin(8)
end
function SWEP:Think()
	--When IN_USE then
	if self.Owner:KeyPressed(IN_USE) then
		self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end

