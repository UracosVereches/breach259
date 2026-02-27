--[[
gamemodes/breach/entities/weapons/item_medkit.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/first_aid2")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.WorldModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.PrintName		= "Аптечка первой помощи"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.betterone				= "item_ultramedkit"
SWEP.droppable				= true
SWEP.teams					= {2,3,5,6,10}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self:GetOwner():DrawViewModel( false )
end
function SWEP:DrawWorldModel()
	if !IsValid(self:GetOwner()) then
		self:DrawModel()
	end
end

SWEP.Lang = nil

function SWEP:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	if CLIENT then
		self.Lang = GetWeaponLang().MEDKIT
	end
	self:SetHoldType(self.HoldType)
	self:SetSkin( 0 )
end
function SWEP:Think()
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
	if self:GetOwner():GTeam() == TEAM_SCP then return end
	if self:GetOwner():Health() / self:GetOwner():GetMaxHealth() <= 0.8 then
		if SERVER then
			self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth())
			self:GetOwner():StripWeapon("item_medkit")
		end
	else
		if SERVER then
			self:GetOwner():RXSENDNotify("У Вас и так достаточно здоровья")
		end
	end
end
function SWEP:SecondaryAttack()
	if SERVER then
		local ent = self:GetOwner():GetEyeTrace().Entity
		if ent:IsPlayer() then
			if ent:GTeam() == TEAM_SCP then return end
			if ent:GTeam() == TEAM_SPEC then return end
			if(ent:GetPos():Distance(self:GetOwner():GetPos()) < 95) then
				if ent:Health() / ent:GetMaxHealth() <= 0.8 then
					ent:SetHealth(ent:GetMaxHealth())
					self:GetOwner():StripWeapon("item_medkit")
				else
					self:GetOwner():RXSENDNotify(ent:Nick() .. " не нуждается в лечении")
				end
			end
		end
	end
end
function SWEP:CanPrimaryAttack()
	return true
end


