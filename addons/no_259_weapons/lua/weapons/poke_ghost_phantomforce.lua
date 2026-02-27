--[[
lua/weapons/poke_ghost_phantomforce.lua
--]]
AddCSLuaFile("poke_ghost_phantomforce.lua")
SWEP.Base = "poke_ghosttype"
--[[------------------------------
Configuration
--------------------------------]]
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end



local config = {}
config.SWEPName = "SCP 050-FR"
config.ActionDelay = 1 -- Time in between each action.
--[[-------------------------------------------------------------------------
Phantom Force
---------------------------------------------------------------------------]]
config.PhantomForceDelay = 3 -- How long until you can use it again after attack?
config.PhantomForceDuration = 15 -- How long can you use this for?
config.PhantomForceRadius = 100 -- Radius around the player shadow to deal damage?
config.PhantomForceDamageLow = 100
config.PhantomForceDamageHigh = 150
config.PhantomForceDamageForce = 50000 -- Force applied on damage.

config.PhantomForceSound = "scp_sounds/scp_smoke/becoming_smoke.mp3"
config.PhantomForceStartSound = "scp_sounds/scp_smoke/hit_from_smoke.mp3"
config.PhantomForceSoundPitch = 75
--[[-------------------------------------------------------------------------
Messages ( debug )
---------------------------------------------------------------------------]]
config.PrintMessages = false
config.PhantomForceMessage = "Phantom Force!"
--[[----------------------
SWEP
------------------------]]
SWEP.PrintName = config.SWEPName
SWEP.Author = "Varus"

SWEP.Category = "Project Stadium"
SWEP.Instructions = "Become the shadow and attack an enemy at will!"
SWEP.HoldType = "none"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.ISSCP = true
SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false
SWEP.UseHands = false
SWEP.ViewModelFOV = 0
SWEP.droppable				= false
SWEP.AttackDelay            = 3
SWEP.SAttackDelay            = 90
SWEP.NextSecondary = 0
SWEP.NextAttackW            = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"
SWEP.ThrownProjectile = "vru_sj_damage"
--[[-------------------------------------------------------------------------
Default SWEP functions
---------------------------------------------------------------------------]]
function SWEP:Think()
	local owner = self:GetOwner()
	if self.PhantomForceEnabled then
		if self.NextFX < CurTime() then
			local shadow = EffectData()
			shadow:SetOrigin(self:GetOwner():GetPos())
			shadow:SetNormal(Vector(10,10,10))
			shadow:SetScale(120)
			util.Effect("fx_poke_shadow",shadow)

			self.NextFX = CurTime() + self.FXDelay
			self.NextAttackW = CurTime() + self.AttackDelay
		end
	end
end

function SWEP:PrimaryAttack()
	if SERVER then self:PhantomForceStart() end

end
function SWEP:SecondaryAttack()
    if self.NextSecondary > CurTime() then return end
	self.NextSecondary = CurTime() + self.SAttackDelay
    if SERVER and IsFirstTimePredicted() then
		--[[
        local projectile = ents.Create(self.ThrownProjectile)
	    projectile:SetPos(self:GetOwner():GetPos())
		projectile:SetAngles(Angle(math.random(0, 180), math.random(0, 180), math.random(0, 180)))
		projectile:SetOwner(ply)
		projectile:Spawn()
		projectile:Activate()
		--]]
		for k, v in ipairs(ents.FindInSphere(self:GetOwner():GetPos(), 100)) do
			if v:IsPlayer() then
				if v:GTeam() != TEAM_SCP or v:GTeam() != TEAM_DZ or v:GTeam() != TEAM_SPEC then
					if v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_DZ or v:GTeam() == TEAM_SPEC or v == self.Owner then continue end
				if IsValid(v) and !v.Poisoned then
					local d = DamageInfo()
					d:SetDamage((v:GetMaxHealth() / 3) * 2)
					d:SetAttacker(self:GetOwner())
					d:SetDamageType(DMG_POISON)
					v:TakeDamageInfo(d)
					v:RXSENDWarning("Вы себя очень плохо чувствуете...")
					v.Poisoned = true
					timer.Simple(1, function()
						v.Poisoned = false
					end)
				end

				end
			end
		end
	end
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	if self.NextAttackW < CurTime() and !self.PhantomForceEnabled then
	    showtext = "Готова войти в призрачную форму"
	end
	local showcolor = Color(128, 128, 128)
	if self.PhantomForceEnabled then
	    showtext = "Нахожусь в призрачной форме!"
		showcolor = Color(106, 90, 205)
	end

	local kok = "Готова использовать массовое отравление"
	local kek = Color(233, 150, 122)
	if self.NextAttackW > CurTime() and !self.PhantomForceEnabled then
        showtext = "Призрачная форма будет готова через " .. math.Round(self.NextAttackW - CurTime())
        showcolor = Color(255,0,0)
    end
	if self.NextSecondary > CurTime() then
		kok = "Массовое отравление будет готово через ".. math.Round(self.NextSecondary - CurTime())
		kek = Color(255,0,0)
	end

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 50 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	draw.Text( {
		text = kok,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = kek,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end


