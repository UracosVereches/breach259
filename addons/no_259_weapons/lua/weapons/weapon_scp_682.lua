--[[
lua/weapons/weapon_scp_682.lua
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
SWEP.PrintName		= "SCP-682"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.25
SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.SnapSound				= Sound( "snap.wav" )
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.SpecialDelay			= 30
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.NextAttackW			= 0
function SWEP:Deploy()
    self.Owner:DrawViewModel( false )
    self.Owner:SetWalkSpeed(60)
    self.Owner:SetRunSpeed(60)
    self.Owner:SetMaxSpeed(60)
    self.Owner:SetJumpPower(200)
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
    self:SetHoldType("knife")
end
function SWEP:Think()
 
end
 
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
    if self.NextAttackH > CurTime() then return end
    self.NextAttackH = CurTime() + self.AttackDelay1
    if SERVER then
        local ent = nil
        local tr = util.TraceHull( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 ),
            filter = self.Owner,
            mins = Vector( -10, -10, -10 ),
            maxs = Vector( 10, 10, 10 ),
            mask = MASK_SHOT_HULL
        } )
        ent = tr.Entity
        if IsValid(ent) then
            if ent:IsPlayer() then
                if ent:Team() == TEAM_SCP then return end
                if ent:Team() == TEAM_SPEC then return end
                ent:SilentKill()
 
            else
                if ent:GetClass() == "func_breakable" then
                    ent:TakeDamage( 100, self.Owner, self.Owner )
                elseif ent:IsNPC() then
                    ent:TakeDamage( 20000, self.Owner, self.Owner )
                end
            end
        end
    end
end
 
function SWEP:SecondaryAttack()
    if self.NextAttackW > CurTime() then
        if SERVER then
            self.Owner:PrintMessage(3, "Гипер скорость еще не готова!")
            return
        end
    end
    self.NextAttackW = CurTime() + self.AttackDelay2
    local ply = self.Owner
 
    ply:SetWalkSpeed(350)
    ply:SetRunSpeed(350)
    ply:SetMaxSpeed(350)
    ply:SetJumpPower(0)
    local function RemoveBuff()
        ply:SetWalkSpeed(60)
        ply:SetRunSpeed(60)
        ply:SetMaxSpeed(60)
        ply:SetJumpPower(0)
    end
    timer.Create("SCP_PLAYER_WILL_LOSE_BUFF", 5, 1, RemoveBuff)
end


