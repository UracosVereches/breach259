--[[
gamemodes/breach/entities/weapons/weapon_scp_999.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName				= "SCP-999"

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 2
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo		= "None"

SWEP.ISSCP 				= true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.teams					= {1}

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
--SWEP.IconLetter			= "w"
SWEP.HoldType 			= "knife"

SWEP.Lang = nil

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_999
	end
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if self:GetOwner():IsValid() then
		--self:GetOwner():DrawWorldModel( false )
		--self:GetOwner():DrawViewModel( false )
		self:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self:SetColor(Color(255, 255, 255, 0))
	end
end

function SWEP:Holster()
	return true;
end

function SWEP:Think()
	if postround then return end
	--
end

SWEP.NextPrimary = 0
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextPrimary then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if SERVER then
		local totalheal = 0
		local tr = util.TraceHull({
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 150,
			maxs = Vector(10, 10, 10),
			mins = Vector(-10, -10, -10),
			filter = self:GetOwner(),
			mask = MASK_SHOT
		})
		local ent = tr.Entity
		if !IsValid(ent) then return end
		--ent:TakeDamage( 450, self:GetOwner(), self:GetOwner() )
		if ent:IsPlayer() then
			if ent:GTeam() != TEAM_SPEC then

				--ent:TakeDamage( 800, self:GetOwner(), ent )
				if ent:Health() == ent:GetMaxHealth() then return end
				local hp = ent:Health() + math.random(5, 10)
				if hp < ent:GetMaxHealth() then
					totalheal = totalheal + (hp - ent:Health())
					self:GetOwner():SetNWInt("EXP", self:GetOwner():GetNWInt("EXP") + 1)
					ent:SetHealth(hp)
					self:GetOwner():AddExp(totalheal, false)
				end
			end
		else
			if ent:GetClass() == "func_breakable" then
				ent:TakeDamage(100, self:GetOwner(), self:GetOwner())
			end
		end
	end
end

SWEP.NextSecondary = 0
function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextSecondary then return end
	self.NextSecondary = CurTime() + self.Secondary.Delay
	if SERVER then
		local fent = ents.FindInSphere(self:GetOwner():GetPos(), 300)
		local hp = 0
		local totalheal = 0
		for k, v in pairs(fent) do
			if v:IsPlayer() then
				if v:GTeam() != TEAM_SPEC and v != self:GetOwner() then
					hp = v:Health() + math.random(5, 15)
					if hp < v:GetMaxHealth() then
						totalheal = totalheal + (hp - v:Health())
						v:SetHealth(hp)
						hp = 0
					end
				end
			end
		end
		if totalheal > 0 then self:GetOwner():AddExp(totalheal, false) end
	end
end

function SWEP:DrawHUD()
	if disablehud == true then return end

	local showtext = self.Lang.HUD.ghealReady
	local showtext2 = self.Lang.HUD.healReady
	local showcolor = Color(0,255,0)
	local showcolor2 = Color(0,255,0)

	if self.NextSecondary > CurTime() then
		showtext = self.Lang.HUD.ghealCD.." ".. math.Round(self.NextSecondary - CurTime()).."s"
		showcolor = Color(255,0,0)
	end

	if self.NextPrimary > CurTime() then
		showtext2 = self.Lang.HUD.healCD.." "..math.Round(self.NextPrimary - CurTime()).."s"
		showcolor2 = Color(255,0,0)
	end

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	draw.Text( {
		text = showtext2,
		pos = { ScrW() / 2, ScrH() - 60 },
		font = "173font",
		color = showcolor2,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end


