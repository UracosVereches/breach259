--[[
gamemodes/breach/entities/weapons/weapon_scp_9668.lua
--]]
if SERVER then
    AddCSLuaFile()

    SWEP.Weight = 5

    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false

elseif CLIENT then

    SWEP.PrintName = "SCP-999"

    SWEP.Slot = 1
    SWEP.SlotPos = 5

    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true

	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end


SWEP.Spawnable              = true
SWEP.ViewModel              = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel = ""
SWEP.ISSCP = true
SWEP.Primary.ClipSize           = -1
SWEP.Primary.DefaultClip        = -1
SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo           = "none"
SWEP.droppable				= false
SWEP.HoldType = "fist"
SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = false
SWEP.Secondary.Ammo             = "none"
SWEP.Category = "SCP"

SWEP.init = Sound("scp/35/helpme.mp3")
SWEP.mindcontrol = Sound("mindcontrol.wav")
SWEP.annoyed = Sound("weapons/966/death.wav")
SWEP.staticSound = Sound("scp/35/whispers1.mp3")
SWEP.staticVolume = 90.0

SWEP.vanishTimer = CurTime()
SWEP.VanishTime = 4
SWEP.VanishDelay = 2
SWEP.Vanished = false
SWEP.UseHands = true
SWEP.Entity = nil

SWEP.attackTime = CurTime()
SWEP.attackDelay = 3
SWEP.soundStart = 0
SWEP.lookingatEntity = false
SWEP.attacking = false

local ConVars =
{
    dollas = CreateConVar("slender_gimmedollas", "0", FCVAR_SERVER_CAN_EXECUTE, "can you fix this shiet?")
}


function SWEP:Initialize()
    self:SetHoldType(self.HoldType)

	if game.SinglePlayer() then
        self:CallOnClient("PrimaryAttack", "")
        self:CallOnClient("SecondaryAttack", "")
    end

end



function SWEP:Deploy()

    self.Owner:EmitSound(self.init)

    if ConVars.dollas:GetInt() == 1 then
        self.SoundSet = false
        if not self.SoundSet then
            self.staticSound = Sound("static.wav")
            self.SoundSet = true
        end
    end

    self.staticDuration = SoundDuration(self.staticSound)
    self.attackTime = CurTime() + self.attackDelay

if SERVER then
if not self.Owner:Alive() then return end
self.Owner:SetMaterial( "sprites/heatwave" )
self.Owner.ShouldReduceFallDamage = true
self.Owner:DrawWorldModel( false )
return true
end
end







function SWEP:Think()
    if self.VanishTime > 0 and self.Vanished then
        self.VanishTime = self.VanishTime - FrameTime()
    elseif self.VanishTime < 0 and self.Vanished then
        self:Vanish(false)
    end


    local tr = self.Owner:GetEyeTrace()
    if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
        self:SetTarget(tr.Entity)
    end

    if IsValid(self.Entity) then
	    if self.Entity:IsPlayer() then
			if self.Entity:GTeam() == TEAM_SCP then return end
			if self.Entity:GTeam() == TEAM_SPEC then return end
			if self.Entity:GTeam() == TEAM_DZ then return end

	    if SERVER then
            if tr.Entity == self.Entity and not self.attacking then
                self.lookingatEntity = true
            else
                self.lookingatEntity = false
            end

            if self.lookingatEntity and not self.Vanished then
                self.soundStart = self.soundStart + FrameTime()
                if self.soundStart > self.staticDuration then
                    self.looping = false
                    self.soundStart = 0
                end

                if self:GetPos():Distance(self.Entity:GetPos()) < 2000 then
                    if not self.looping then
                        self:EmitSound(self.staticSound)
                        self.looping = true
                    end
                    if self:GetPos():Distance(self.Entity:GetPos()) < 250 then
                        if CurTime() > self.attackTime then
                            self:Attack(self.Entity)
                            self.attackTime = CurTime() + self.attackDelay
                        end
                    end
                else
                    self:StopEmittingStatic()
                end
            else
                self:StopEmittingStatic()
            end
        end
		end
    else
        self:StopEmittingStatic()
    end
end



function SWEP:StopEmittingStatic()
    self:StopSound(self.staticSound)
    self.looping = false
    self.soundStart = 0
end

function SWEP:Holster()
   self:OnRemove()
   return true
end


function SWEP:OnRemove()
    self:Vanish(false)
    self:StopEmittingStatic()

    if timer.Exists("die") then
        timer.Destroy("die")
    end
end

function SWEP:Vanish(blnVan)
    if not IsValid(self.Owner) then
        return
    end

    if blnVan == true then
        self.Owner:SetMaterial( "engine/occlusionproxy" )

        if SERVER then
            self.Owner:EmitSound("buttons/combine_button1.wav")
            self.Owner:PlayStepSound( 0 )
        end
    elseif blnVan == false then
        self.Owner:SetMaterial( "" )
        self.VanishTime = 4

        if SERVER then
            self.Owner:PlayStepSound( 1 )
            self.Owner:EmitSound("buttons/combine_button7.wav")
        end
    end

    if SERVER then
        self.Owner:DrawWorldModel(not blnVan)
    end

    self.Owner:DrawShadow(not blnVan)

    self.Vanished = blnVan
end

function SWEP:Attack(ent)
    if IsValid(ent) then
	    if ent:IsPlayer() then
	    if ent:GTeam() == TEAM_SCP then return end
	    if ent:GTeam() == TEAM_SPEC then return end
		if ent:GTeam() == TEAM_DZ then return end
		end

        self.attacking = true

        local dmg = 10
        if self.Owner:GetPos():Distance(ent:GetPos()) < 100 then
            ent:SetEyeTarget( self.Owner:EyePos() )
            dmg = ent:Health()
            ent:SetMoveType(MOVETYPE_NONE)
            self.Owner:ConCommand("act zombie")
            self:EmitSound(self.annoyed)
        end

        local time = 0.3
        if dmg == ent:Health() then
            time = 1
        end

        timer.Create("die", time, 1, function()
            ent:TakeDamage(dmg, self.Owner, self)
        end)
    end

    self.attacking = false
end
local delay = 0
local delaytime = 2
function SWEP:PrimaryAttack()
//if ( !self:CanPrimaryAttack() ) then return end
    if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
  if delay > CurTime() then return end
  delay = CurTime() + delaytime
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if(ent:GetPos():Distance(self.Owner:GetPos()) < 125) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				if ent:GTeam() == TEAM_DZ then return end
				//ent:SetSCP0492()
				//roundstats.zombies = roundstats.zombies + 1
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 10000, self.Owner, self.Owner )
				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then

						ent:TakeDamage( math.Round(math.random(1,2)), self.Owner, self.Owner )


						ent:EmitSound("door_break.wav")
					end
				end
			end
		end
	end
end



function SWEP:SecondaryAttack()

end



function SWEP:SetTarget(ent)
    if IsValid(self.Entity) then
        if ent:IsNPC() or ent:IsPlayer() then
            self.Entity = ent
        end

    end
	 if not IsValid(self.Entity) then
        if ent:IsNPC() or ent:IsPlayer() then
            self.Entity = ent
        end

    end
end


