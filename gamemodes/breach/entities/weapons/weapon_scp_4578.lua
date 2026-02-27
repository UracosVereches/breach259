--[[
gamemodes/breach/entities/weapons/weapon_scp_4578.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

--SWEP.Author			= "Kanade"
--SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
--SWEP.Purpose		= "Burn"
--SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-457"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
	--self.Owner:StopParticles()
	timer.Simple(0.1, function()
		ParticleEffectAttach("env_embers_large",PATTACH_ABSORIGIN_FOLLOW,self.Owner,0)
		ParticleEffectAttach("fire_medium_01_glow",PATTACH_ABSORIGIN_FOLLOW,self.Owner,0)
		ParticleEffectAttach("env_fire_small_coverage",PATTACH_ABSORIGIN_FOLLOW,self.Owner,0)
	end)
	if CLIENT then
		if self.Owner == LocalPlayer() then
			LocalPlayer():StopParticles()
		end
	end

end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("normal")
	timer.Simple(0.1, function()
		ParticleEffectAttach("env_embers_large",PATTACH_ABSORIGIN_FOLLOW,self.Owner,0)
		ParticleEffectAttach("fire_medium_01_glow",PATTACH_ABSORIGIN_FOLLOW,self.Owner,0)
		ParticleEffectAttach("env_fire_small_coverage",PATTACH_ABSORIGIN_FOLLOW,self.Owner,0)
		RunConsoleCommand("stopsound");
	end)
	--self.Owner:StopParticles()
	if CLIENT then
		if self.Owner == LocalPlayer() then
			LocalPlayer():StopParticles()
		end
	end
end


SWEP.DrawRed = 0

function SWEP:RenderLight()
	if self.toggleLight ~= true then return end --If Not true, return.
	if CLIENT then
		if IsValid(scp_nightVision) == false then
			scp_nightVision = DynamicLight( self.Owner:EntIndex() ) --Do not take 0, Used for NV. This should be
		end
		if ( scp_nightVision ) then --Welp. :|
			scp_nightVision.Pos = self.Owner:GetPos()
			scp_nightVision.r = 128
			scp_nightVision.g = 128
			scp_nightVision.b = 128
			scp_nightVision.Brightness = 0.85
			scp_nightVision.Size = 900
			scp_nightVision.DieTime = CurTime()+0.25 --Don't let it stay please.
			scp_nightVision.Style = 0 -- https://developer.valvesoftware.com/wiki/Light_dynamic#Appearances
		end
	end
end
function SWEP:Think()
	if CLIENT then self:RenderLight() end
end

scp_toggleLight_cooldown = 0
function SWEP:Reload()
	if scp_toggleLight_cooldown >= CurTime() then return end
	if self.toggleLight then
		self.toggleLight = false
	else
		self.toggleLight = true
	end
	scp_toggleLight_cooldown = CurTime() + 2
end

local cooldown = 0
function SWEP:Think()
	if CLIENT then
		if self.Owner == LocalPlayer() then
			LocalPlayer():StopParticles()
		end
	end
	if SERVER then
		--self.Owner:Ignite(0.1,100)
		for k,v in pairs(ents.FindInSphere( self.Owner:GetPos(), 125 )) do
			if v:IsPlayer() then
				--print(v:GTeam())
				if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_DZ then
					--print(v)
					v:Ignite(1,250)

					if CurTime() > cooldown then
						local d = DamageInfo()
						d:SetAttacker(self.Owner)
						d:SetDamage(3)
						d:SetDamageType(DMG_BURN)
						v:TakeDamageInfo(d)
						cooldown = CurTime() + 0.5
					end

					if self.Owner.nextexp == nil then self.Owner.nextexp = 0 end
					if self.Owner.nextexp < CurTime() and self.Owner:Health() < self.Owner:GetMaxHealth() then
						--self.Owner:SetHealth(self.Owner:Health() + 50)
						--self.Owner:AddExp(1)
						self.Owner.nextexp = CurTime() + 1
					end
				end
			end
		end
	end
end

function SWEP:Reload()
end
function SWEP:OnRemove()
	if SERVER then
		self.Owner:Extinguish()
	end
end
function SWEP:PrimaryAttack()
	//if ( !self:CanPrimaryAttack() ) then return end
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if(ent:GetPos():Distance(self.Owner:GetPos()) < 125) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				//ent:SetSCP0492()
				//roundstats.zombies = roundstats.zombies + 1
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 1000, self.Owner, self.Owner )
				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
						ent:TakeDamage( math.Round(math.random(10,50)), self.Owner, self.Owner )
						ent:EmitSound(Sound('MetalGrate.BulletImpact'))
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


