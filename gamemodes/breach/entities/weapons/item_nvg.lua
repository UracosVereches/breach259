--[[
gamemodes/breach/entities/weapons/item_nvg.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/nightglasses")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/nvg.mdl"
SWEP.WorldModel		= "models/mishka/models/nvg.mdl"
SWEP.PrintName		= "NVG"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true
SWEP.teams					= {2,3,5,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
	if self.Owner:GetNClass() == ROLES.ROLE_MTFJAG or self.Owner:GetNClass() == ROLES.ROLE_HAZMAT then 
	    self.Owner:PrintMessage(HUD_PRINTCENTER, 'Зачем вам очки ночного видения, если у Вас уже они есть?')  
		self:DropWeapon()
        
    end 
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end


SWEP.Lang = nil

function SWEP:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD) 

	if CLIENT then
		self.Lang = GetWeaponLang().NVG
	end
	self:SetHoldType(self.HoldType)
	self:SetSkin( 2 )
end
function SWEP:Think()
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
end
function SWEP:OnRemove()
end
function SWEP:Holster()
	return true
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end




