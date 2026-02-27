--[[
gamemodes/breach/entities/weapons/weapon_scp_0822.lua
--]]
AddCSLuaFile()

if CLIENT then
    SWEP.WepSelectIcon  = surface.GetTextureID("vgui/entities/scp")
    SWEP.BounceWeaponIcon = false
end

SWEP.Author         = "Varus & BroJou"
SWEP.Contact        = ""
SWEP.Purpose        = ""
SWEP.Instructions   = ""

SWEP.ViewModelFOV   = 62
SWEP.ViewModelFlip  = false
SWEP.ViewModel      = "models/vinrax/props/keycard.mdl"
SWEP.WorldModel     = "models/vinrax/props/keycard.mdl"
SWEP.PrintName      = "SCP-082"
SWEP.Slot           = 0
SWEP.SlotPos        = 0
SWEP.DrawAmmo       = false
SWEP.DrawCrosshair  = false
SWEP.HoldType       = "knife"
SWEP.Spawnable      = false
SWEP.AdminSpawnable = false

SWEP.AttackDelay            = 3
SWEP.ISSCP = true
SWEP.droppable              = false
SWEP.teams                  = {1}
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false

SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.NextAttackW            = 0

function SWEP:Deploy()
    self:GetOwner():DrawViewModel( false )
end


function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
    self:SetHoldType("knife")
end

function SWEP:Think()
    if self:GetOwner():GetNWBool("Anger") == false then
        self:GetOwner():SetWalkSpeed(90)
        self:GetOwner():SetCrouchedWalkSpeed(10)
        self:GetOwner():SetRunSpeed(90)
        self:GetOwner():SetJumpPower(0)
		self:SetHoldType("knife")
		self.AttackDelay = 3
    else
        self:GetOwner():SetWalkSpeed(420)
        self:GetOwner():SetCrouchedWalkSpeed(10)
        self:GetOwner():SetRunSpeed(420)
        self:GetOwner():SetJumpPower(0)
		self:SetHoldType("melee2")
		self.AttackDelay = 1
    end

end

function SWEP:Reload()
    if preparing or postround then return end
    if not IsFirstTimePredicted() then return end
end

function SWEP:PrimaryAttack()
    if preparing or postround then return end
    if not IsFirstTimePredicted() then return end
    if self.NextAttackW > CurTime() then return end
    self.NextAttackW = CurTime() + self.AttackDelay
	if self:GetOwner():GetNWBool("Anger") == false then
	    self:GetOwner():DoAnimationEvent(ACT_HL2MP_WALK_ZOMBIE_02)

	    else
		local kek = math.random(1,2)
	    if kek == 1 then self:GetOwner():DoAnimationEvent(ACT_HL2MP_IDLE_CROUCH_ZOMBIE) else
	    if kek == 2 then self:GetOwner():DoAnimationEvent(ACT_HL2MP_WALK_ZOMBIE_01)
		end
		end

	end

    if SERVER then
        local ent = nil
        local tr = util.TraceHull({
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + (self:GetOwner():GetAimVector() * 75),
		mins = Vector(-10, -10, -10),
		maxs = Vector(10, 10, 10),
		filter = self:GetOwner(),
		mask = MASK_SHOT,
	})
        ent = tr.Entity
		if !IsValid(ent) then
		    self:GetOwner():EmitSound("scp_sounds/scp_082/attack_miss.mp3")
		end
        if IsValid(ent) then
            if ent:IsPlayer() then
                if ent:GTeam() == TEAM_SCP then return end
                if ent:GTeam() == TEAM_SPEC then return end
				if ent:GTeam() == TEAM_DZ then return end
                if self:GetOwner():GetNWBool("Anger") == false then




                    local d = DamageInfo()
                    d:SetDamage(150)
                    d:SetDamageType(DMG_CRUSH)
                    d:SetAttacker(self.Owner)
                    ent:TakeDamageInfo(d)

					self:GetOwner():EmitSound("scp_sounds/scp_082/attack_hit.mp3")
                    if ent:Health() <= 0 then
                        ent:Kill()
						self:GetOwner():EmitSound("scp_sounds/scp_082/kill_"..math.random(1,8)..".mp3" )
                        self:GetOwner():SetNWInt("EXP", self:GetOwner():GetNWInt("EXP") + 1)
						self:GetOwner():SetHealth(self:GetOwner():Health() + 250)
                    end
                else
				    self:GetOwner():SetNWInt("EXP", self:GetOwner():GetNWInt("EXP") + 1)
                    ent:Kill()
                    self:GetOwner():AddExp(150, true)
					self:GetOwner():SetHealth(self:GetOwner():Health() + 400)
                end
            else

                if ent:GetClass() == "func_breakable" then
                    ent:TakeDamage( 100, self:GetOwner(), self:GetOwner() )
				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then
					    if self:GetOwner():GetNWBool("Anger") == false then
						ent:TakeDamage( math.Round(math.random(5,10)), self:GetOwner(), self:GetOwner() )
            print(ent:Health())
						else
						ent:TakeDamage( math.Round(math.random(25,30)), self:GetOwner(), self:GetOwner() )
						end
						ent:EmitSound("door_break.wav")
						elseif string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then

			                ent:TakeDamage( math.Round(math.random(4,5)), self:GetOwner(), self:GetOwner() )

			                   print(ent:Health())
			            ent:EmitSound("door_break.wav")

					end


                end
            end
        end
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
    return true
end

function SWEP:DrawHUD()
    if disablehud == true then return end

    local showtext = "Готов дать в лицо"
    local showcolor = Color(0,255,0)
    local kek = Color(0,255,0)
    if self.NextAttackW > CurTime() then
        showtext = "След.атака через " .. math.Round(self.NextAttackW - CurTime())
        showcolor = Color(255,0,0)
    end

    local ragetext = "Бля буду через " .. math.Round(900 - self:GetOwner():GetNWFloat("amountDamage"))

	if self:GetOwner():GetNWBool("Anger") == true then
	    ragetext = "АААААА СУКА РАЗОЗЛИЛИ ТВАРИ"
		kek = Color(255,0,0)
		else
		ragetext = "Злость " .. math.Round(100/900 * self:GetOwner():GetNWFloat("amountDamage")) .. "%"
	end


    draw.Text( {
        text = showtext,
        pos = { ScrW() / 2, ScrH() - 60 },
        font = "173font",
        color = showcolor,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })
    draw.Text( {
        text = ragetext,
        pos = { ScrW() / 2, ScrH() - 30 },
        font = "173font",
        color = kek,
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
    })
    local x = ScrW() / 2.0
    local y = ScrH() / 2.0

    local scale = 0.3
    surface.SetDrawColor( 0, 255, 0, 255 )

    local gap = 5
    local length = gap + 20 * scale
    surface.DrawLine( x - length, y, x - gap, y )
    surface.DrawLine( x + length, y, x + gap, y )
    surface.DrawLine( x, y - length, x, y - gap )
    surface.DrawLine( x, y + length, x, y + gap )
end


