--[[
gamemodes/breach/entities/weapons/scp_cannibal/shared.lua
--]]
if SERVER then
AddCSLuaFile( "shared.lua" )
end

-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_tttbase"
--- Standard GMod values

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/can")
	SWEP.BounceWeaponIcon = false
end


SWEP.PrintName = "Каннибализм"
--SWEP.Category = "SCP"
--SWEP.Purpose = "Жрите трупы"
--SWEP.Instructions = "Пиздец культист"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModel		= "models/vinrax/props/eyedrops.mdl"
SWEP.WorldModel		= "models/vinrax/props/eyedrops.mdl"

SWEP.Primary.ClipSize    = -1
SWEP.Primary.ClipMax     = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.droppable = false
SWEP.Secondary.Ammo = "none"

SWEP.Primary.Delay       = 15
SWEP.Slot               = 1
SWEP.SlotPos 			= 10
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = false
SWEP.HoldType		= "normal"

SWEP.IronSightsPos = Vector( 6.05, -5, 2.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )

function SWEP:ShouldDropOnDie()
	self:Remove()
end

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:OnDrop()
self:Remove()
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	local tracedata = {}
	tracedata.start = self.Owner:GetShootPos()
	tracedata.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 100)
	tracedata.filter = self.Owner
	tracedata.mins = Vector(1,1,1) * -10
	tracedata.maxs = Vector(1,1,1) * 10
	tracedata.mask = MASK_SHOT_HULL
	local tr = util.TraceHull( tracedata )

	local ply = self.Owner

		if IsValid(tr.Entity) then
	if ( SERVER and string.find(tr.Entity:GetClass(),"prop_ragdoll")) then
	timer.Simple(0.1, function()
    ply:Freeze(true)
    ply:SetColor(Color(255,0,0,255))
		end)
          self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

          timer.Create("GivePlyHealth_"..self.Owner:UniqueID(),0.5,6,function() self.Owner:SetHealth(self.Owner:Health()+5) end)

			timer.Simple(5, function()
			ply:Freeze(false)
			ply:SetColor(Color(255,255,255,255))
          tr.Entity:Remove()
					end )


				end
		end
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

end

--- TTT config values


