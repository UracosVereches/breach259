--[[
gamemodes/breach/entities/weapons/weapon_br_zombie.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.Base			= "weapon_breach_basemelee"

SWEP.ViewModelFOV	= 75
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "knife"
SWEP.ViewModel		= "models/weapons/v_models/v_demhands.mdl"
SWEP.WorldModel		= ""
--SWEP.UseHands = True
SWEP.PrintName		= "Лапы"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 0

SWEP.Spawnable			= false
SWEP.AdminOnly			= false
SWEP.ISSCP				= true

SWEP.droppable				= false
SWEP.Primary.Automatic		= false
SWEP.Primary.NextAttack		= 0.25
SWEP.Primary.AttackDelay	= 0.4
SWEP.Primary.Damage			= 14
SWEP.Primary.Force			= 3250
SWEP.Primary.AnimSpeed		= 2.8

SWEP.Secondary.Automatic	= true
SWEP.HoldType = "knife"
SWEP.Secondary.NextAttack	= 0.7
SWEP.Secondary.AttackDelay	= 1.6
SWEP.Secondary.Damage		= 82
SWEP.Secondary.Force		= 6000
SWEP.Secondary.AnimSpeed	= 2.4
SWEP.Primary.Delay = 0.6
SWEP.Range					= 100
SWEP.AttackTeams			= {2,3,5,6,7} // Attack only humans
SWEP.UseHands				= true
SWEP.DrawCustomCrosshair	= true
SWEP.DeploySpeed			= 1
SWEP.AttackTeams			= {2,3,5,6} // Attack only humans
SWEP.AttackNPCs				= false

SWEP.ZombieWeapon			= true


function SWEP:Precache()
	util.PrecacheModel(self.ViewModel)

    util.PrecacheSound("npc/zombie/zombie_voice_idle1.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle2.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle3.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle4.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle5.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle6.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle7.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle8.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle9.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle10.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle11.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle12.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle13.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle14.wav")
    util.PrecacheSound("npc/zombie/claw_strike1.wav")
    util.PrecacheSound("npc/zombie/claw_strike2.wav")
    util.PrecacheSound("npc/zombie/claw_strike3.wav")
    util.PrecacheSound("npc/zombie/claw_miss1.wav")
    util.PrecacheSound("npc/zombie/claw_miss2.wav")
    util.PrecacheSound("attackzombie.wav")

end

function SWEP:Initialize()
    self:SetHoldType( "knife" )
	self:Precache()
    --timer.Simple(17.5, function() print("Set idle animation") self:SetHoldType( "normal" ) end)
    --timer.Simple(18, function() print("Set knife animation") self:SetHoldType( "knife" ) end)
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) )
	if self.Owner:IsValid() then

	self:SendWeaponAnim(ACT_VM_DEPLOY)
	timer.Simple(1.1, function(wep) self:SendWeaponAnim(ACT_VM_IDLE) end)
	--timer.Simple(1.5, function(wep) self:SetHoldType( "knife" ) end)
	end
	return true;
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:IsMoaning()
	return false
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/stalker/breathing3.wav", 70, math.random(110, 120))
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/fast_zombie/wake1.wav", 70, math.random(115, 140))
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	local vm = self.Owner:GetViewModel()

    if CurTime() < self.NextSwing then return end

	local attack = math.random(1,2)
	if attack == 1 then vm:SendViewModelMatchingSequence( vm:LookupSequence( "attack1" ))
 else
	if attack == 2 then vm:SendViewModelMatchingSequence( vm:LookupSequence( "attack2" ))
 end
end

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)

    self.Owner:EmitSound("attackzombie.wav")
	timer.Simple(0.6, function(wep)
		local pl = self.Owner

    local vStart = pl:EyePos() + Vector(0, 0, -10)
    local trace = util.TraceLine({start=vStart, endpos = vStart + pl:GetAimVector() * 71, filter = pl, mask = MASK_SHOT})

    local ent
    if trace.HitNonWorld then
        ent = trace.Entity
    elseif self.PreHit and self.PreHit:IsValid() and not (self.PreHit:IsPlayer() and not self.PreHit:Alive()) and self.PreHit:GetPos():Distance(vStart) < 110 then
        ent = self.PreHit
        trace.Hit = true
    end

    if trace.Hit then
        pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
    end

    pl:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
    self.PreHit = nil
    if SERVER then
    if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
	if ent:GTeam() == TEAM_SCP or ent:GTeam() == TEAM_DZ or ent:GTeam() == TEAM_SPEC then return end
            local damage = self.Primary.Damage
            local phys = ent:GetPhysicsObject()
            if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
                local vel = damage * 487 * pl:GetAimVector()

                phys:ApplyForceOffset(vel, (ent:NearestPoint(pl:GetShootPos()) + ent:GetPos() * 2) / 3)
                ent:SetPhysicsAttacker(pl)
            end
            if not CLIENT and SERVER then
            ent:TakeDamage(damage, pl, self)
        end
    end
	end
	self:SendWeaponAnim(ACT_VM_IDLE)
end)
    self.NextSwing = CurTime() + self.Primary.Delay
    self.NextHit = CurTime() + 1
    local vStart = self.Owner:EyePos() + Vector(-20, -20, -20)
    local trace = util.TraceLine({start=vStart, endpos = vStart + self.Owner:GetAimVector() * 65, filter = self.Owner, mask = MASK_SHOT})

    if trace.HitNonWorld then
        self.PreHit = trace.Entity
    end
	if SERVER then
	if trace.Entity:GetClass() == 'prop_dynamic' then
		if string.lower(trace.Entity:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(trace.Entity:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then
			if SERVER then
			    trace.Entity:TakeDamage( math.Round(math.random(1,2)), self.Owner, self.Owner )
			end

			trace.Entity:EmitSound("door_break.wav")

		elseif string.lower(trace.Entity:GetModel()) == 'models/foundation/containment/door01.mdl' then
		    if SERVER then
			    trace.Entity:TakeDamage( math.Round(math.random(4,5)), self.Owner, self.Owner )
			end

			trace.Entity:EmitSound("door_break.wav")
		end
	end
  end
end

function SWEP:SecondaryAttack()
    return false
end

function SWEP:Move(mv)
	if self:GetClimbing() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)

		local owner = self:GetOwner()
		local tr = self:GetClimbSurface()
		local angs = self:GetOwner():SyncAngles()
		local dir = tr and tr.Hit and (tr.HitNormal.z <= -0.5 and (angs:Forward() * -1) or math.abs(tr.HitNormal.z) < 0.75 and tr.HitNormal:Angle():Up()) or Vector(0, 0, 1)
		local vel = Vector(0, 0, 4)

		if owner:KeyDown(IN_FORWARD) then
			owner:SetGroundEntity(nil)
			vel = vel + dir * 60
		end
		if owner:KeyDown(IN_BACK) then
			vel = vel + dir * -60
		end

		if vel.z == 4 then
			if owner:KeyDown(IN_MOVERIGHT) then
				vel = vel + angs:Right() * 35
			end
			if owner:KeyDown(IN_MOVELEFT) then
				vel = vel + angs:Right() * -35
			end
		end

		mv:SetVelocity(vel)

		return true
	end
end


