--[[
gamemodes/breach/entities/weapons/item_snav_300.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/snav")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/snav.mdl"
SWEP.WorldModel		= "models/mishka/models/snav.mdl"
SWEP.PrintName		= "S-Nav 300"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "slam"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = true


SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.UseHands = true

SWEP.betterone = "item_snav_ultimate"
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

SWEP.Enabled = false
SWEP.NextChange = 0
SWEP.Pos = Vector( 3, -3, -4 )
SWEP.Ang = Angle( -90, 180, 180 )

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

function SWEP:CalcView( ply, pos, ang, fov )
	if self.Enabled then
		ang = Vector(90,0,0)
		pos = pos + Vector(0,0,650)
		fov = 90
	end
	return pos, ang, fov
end

function SWEP:CreateWorldModel()

  if ( !self.WModel ) then

    self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
    self.WModel:SetNoDraw( true )
		self.WModel:AddEffects( EF_NORECEIVESHADOW )

  end

  return self.WModel

end

local vec_offset = Vector( 3, -3, -4 )
local angle_offset = Angle( -90, 180, 180 )

function SWEP:Think()

	if ( self.Owner:GetVelocity():Length() <= 0 && !self.Owner:Crouching() ) then

		self.Pos = vec_offset
		self.Ang = angle_offset

  elseif ( self.Owner:GetVelocity():Length() > 0 && self.Owner:OnGround() ) then

		self.Pos = vec_offset
		self.Ang = angle_offset

  end

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:DrawWorldModel()

	if ( ( self.Owner && self.Owner:IsValid() ) ) then

	 	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")

		if ( !bone ) then return end

	 	local pos, ang = self.Owner:GetBonePosition(bone)

		local wm = self:CreateWorldModel()

	  if ( wm && wm:IsValid() ) then

	    ang:RotateAroundAxis(ang:Right(), self.Ang.p)
	    ang:RotateAroundAxis(ang:Forward(), self.Ang.y)
	    ang:RotateAroundAxis(ang:Up(), self.Ang.r)
	    wm:SetRenderOrigin(pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z)
	    wm:SetRenderAngles(ang)
	    wm:DrawModel()

	 	end

	else

		self:DrawModel()

	end

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
	if SERVER then return end
	if self.NextChange > CurTime() then return end
	self.Enabled = !self.Enabled
	
	self.NextChange = CurTime() + 0.25
end
function SWEP:CanPrimaryAttack()
end


