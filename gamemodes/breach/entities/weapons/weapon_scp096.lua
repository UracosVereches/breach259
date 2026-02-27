--[[
gamemodes/breach/entities/weapons/weapon_scp096.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"

SWEP.PrintName		= "SCP 096"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.HoldType		= "melee2"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
-- SWEP.SnapSound		= Sound( "snap.wav" )

SWEP.AttackDelay	= 0.25
SWEP.ISSCP 			= true
SWEP.droppable		= false
SWEP.NextAttackW	= 0

SWEP.IsInRage 		= false
SWEP.IsCrying		= false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("melee2")
end
function SWEP:Holster()
	return true
end
function SWEP:CanPrimaryAttack()
	return true
end
function SWEP:HUDShouldDraw( element )
	local hide = {
		CHudAmmo = true,
		CHudSecondaryAmmo = true,
	}
	if hide[element] then return false end
	return true
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
		if self.IsInRage then
			local ent = self.Owner:GetEyeTrace().Entity
			if not ent:IsPlayer() then return end
			if ent:GTeam() == TEAM_SCP then return end
			if ent:GTeam() == TEAM_SPEC then return end
			if ent:GTeam() == TEAM_DZ then return end
			if not (ent:GetPos():Distance(self.Owner:GetPos()) < 150) then return end

			local weapon = ent:GetActiveWeapon()
			if not weapon then return end
			if weapon.ISSCP then return end
			ent:Kill()
			self.Owner:SetNWInt("EXP", self.Owner:GetNWInt("EXP") + 1)
			self.Owner:StopSound( "scream" )
			self.Owner:DoAnimationEvent(ACT_GESTURE_MELEE_ATTACK1)
		end
			self.IsInRage = false

			self.Owner:SetWalkSpeed(80)
			self.Owner:SetRunSpeed(80)
			self.Owner:SetMaxSpeed(80)
			self:SetHoldType("melee2")
	end
	end


sound.Add( {
	name = "scream",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "cult/scp/096/chase.wav"
} )

function SWEP:SecondaryAttack()
	return false
end

hook.Add("PlayerDeath","Sounds",function(ply)
		ply:StopSound("scream")

end)

function SWEP:IsLookingAt( ply ) -- FROM 1.0 BREACH XD
	if ( ply != self.Owner ) then
		yes = ply:GetAimVector():Dot( ( self.Owner:GetPos() - ply:GetPos() ):GetNormalized() )
		return ( yes > 0.9 )
	end
end

function SWEP:StartWatching()
	self.IsCrying = true
	self.Owner:Freeze(true)
	self.Owner:EmitSound( "cult/scp/096/alert1.wav" )
	self.Owner:EmitSound( "cult/scp/096/start.mp3" )
	self.Owner:SetHealth(1400)
	self:SetHoldType("melee")
	-- Start Crying --
    timer.Create( "CryTime" ..self.Owner:SteamID(), 10, 1, function()
		self.IsCrying = false
		self.IsInRage = true
		self.Owner:StopSound( "cult/scp/096/alert1.wav" )
		self.Owner:EmitSound( "scream" )
		self.Owner:Freeze(false)
		self.Owner:SetWalkSpeed(500)
		self.Owner:SetRunSpeed(500)
		self.Owner:SetHealth(1400)
		self.Owner:SetMaxSpeed(500)
		timer.Create( "Rage" ..self.Owner:SteamID(), 5, 1, function()
		end)
	end)
end
function SWEP:Think()
	if not SERVER then return end
	if self.IsCrying then return end
	if self.IsInRage then

	  local scp096breaching = ents.FindInSphere( self.Owner:GetPos(), 30 )
		for k, prop in pairs( scp096breaching ) do

			if ( prop:GetClass() != "func_door" ) then continue end

		  if string.lower(prop:GetModel()) == 'models/foundation/containment/door01.mdl' then continue end

      --prop:Fire('Open') --Force it to open.

	  end
		return
	end

	if not self.Owner:Alive() then return end
	local watching = false
	for k,v in pairs(player.GetAll()) do
		if not IsValid(v) or not v:Alive() then continue end

		local wep = v:GetActiveWeapon()
		if not wep then continue end
		if v:GTeam() == TEAM_DZ then continue end
		if v:GTeam() == TEAM_SPEC then continue end
		if v:GTeam() == TEAM_SCP then continue end
		if wep.ISSCP then continue end
		local tr_eyes = util.TraceLine( {
				start = v:EyePos() + v:EyeAngles():Forward() * 15,
				endpos = self.Owner:EyePos(),
			} )
		--if ( v:IsSuperAdmin() && v:GTeam() != TEAM_SCP ) then

			--local yes = v:GetAimVector():Dot( ( self.Owner:EyePos() - v:GetPos() + Vector( 70 ) ):GetNormalized() )
			--print( yes, v:Nick() )

		--end

		if tr_eyes.Entity == self.Owner then
			if self:IsLookingAt( v ) and ((v.IsBlinking and isfunction(v.IsBlinking) and v:IsBlinking()) or not isfunction(v.IsBlinking)) then

				watching = true
				break -- Optimalization :)
			end
		end
	end
	if watching then
		self:StartWatching()
	end
end


