--[[
gamemodes/breach/entities/weapons/weapon_kleyto/shared.lua
--]]
AddCSLuaFile()
if( SERVER ) then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

if( CLIENT ) then
    SWEP.PrintName = "SCP-638"
    SWEP.Slot = 0
    SWEP.SlotPos = 0
	SWEP.MoveType = 3
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = true;
end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.HoldType = "rpg"
SWEP.droppable				= false
SWEP.ViewModel= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel= "models/vinrax/props/keycard.mdl"
SWEP.ISSCP = true
SWEP.RunHoldType = "rpg"
SWEP.Primary.Recoil		= 1
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 5

SWEP.NextInfection = 0;
SWEP.NextSecondary = 0;
SWEP.NextSoun = 0;


local SWEPConf = {}
SWEPConf.sounds = {
	"models/player/alyx.mdl",
	"models/player/p2_chell.mdl"
}




function SWEP:Infection()

end


function SWEP:Initialize()

	if (SERVER) then

		self:SetWeaponHoldType("rpg")

	end

end

function SWEP:DrawWorldModel()
end


function SWEP:Deploy()

			local tr = util.TraceLine(util.GetPlayerTrace( self.Owner ))
			local ent = tr.Entity

			ent.Deafened = false

			self.Owner:SetRunSpeed( 160 )

			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

			self.Weapon:SetNextPrimaryFire(CurTime() + 1)

			self.Owner:Freeze( false );

			self.Owner:DrawViewModel( false )


	return true

end


function SWEP:PrimaryAttack()
local tr = util.TraceLine(util.GetPlayerTrace( self.Owner ))
local ent = tr.Entity

if self.Owner:GetPos():Distance(ent:GetPos()) > 500 then return end
if ent.Deafened then return end
if not ent:IsPlayer() then return end
    if ent:IsPlayer() then
			if ent:GTeam() == TEAM_SCP then return end
			if ent:GTeam() == TEAM_SPEC then return end
			if ent:GTeam() == TEAM_DZ then return end
	    end

if SERVER then
	self:GetOwner():AddExp(10, false)
end

self:GetOwner():EmitSound("npc/stalker/go_alert2a.wav")

self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )

  local bullet = {}
	bullet.Num 		= 3
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector( 0.06, 0.01, 0.03 )
	bullet.Tracer	= 0
	bullet.Force	= 1
	bullet.Damage	= 0
	bullet.AmmoType = "none"

	if not ent:HasWeapon("weapon_kleyto") then
	self.Owner:FireBullets( bullet )

	self:EmitSound ( "cry/attack.wav" )

	ent:Freeze( true );



	ent.Deafened = true

	timer.Create("health_degen", 1, 4, function()
	if (!IsValid(ent) or !ent:Alive())  then return end
	if (ent:GTeam() == TEAM_CLASSD) then
	    ent:SetHealth(ent:Health() - 10)
	end
	if !(ent:GTeam() == TEAM_CLASSD) then
	    ent:SetHealth(ent:Health() - 15)
	end

	self.Owner:Freeze( false );
	    if ((ent:Health() <= 0) and (SERVER) and ent:Alive()) then
 	     ent:Kill()
	    end
	end)


	timer.Simple(4, function()
	if (!IsValid(ent) or !ent:Alive()) then
	ent:Freeze( false );	return end
	ent:Freeze( false );
	end)


	timer.Simple(5, function()
	if (!IsValid(ent) or !ent:Alive() ) then return end
	self.Owner:Freeze( false );
	end)

	timer.Simple(30, function()
	if (!IsValid(ent) or !ent:Alive()) then return end
	ent.Deafened = false
	end)

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self.Owner:Alive() then
	self.Owner:Freeze( false );
	ent:Freeze( false );
	end
end
end




function SWEP:SecondaryAttack()

end
local NextBreach = 0
local cdNextBreach = 4
function SWEP:Reload()
    local ent = self.Owner:GetEyeTrace().Entity
	if NextBreach > CurTime() then return end
	NextBreach = CurTime() + cdNextBreach
    if ent:GetClass() == 'prop_dynamic' then
		if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then

			ent:TakeDamage( math.Round(math.random(2,3)), self.Owner, self.Owner )


			ent:EmitSound("door_break.wav")
		end
	end
end
function SWEP:Think()
self.Owner:DrawViewModel(false)
end


