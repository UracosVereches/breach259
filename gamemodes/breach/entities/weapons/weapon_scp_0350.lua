--[[
gamemodes/breach/entities/weapons/weapon_scp_0350.lua
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
SWEP.PrintName		= "SCP-035"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.Weight = 5
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.Spawnable		= true


SWEP.AttackDelay			= 0.25
SWEP.ISSCP					= true
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
SWEP.Secondary.Automatic	= false
SWEP.NextAttackW			= 0


SWEP.DrawRed = 0


function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Think()
end

function SWEP:Reload()
end
SWEP.cdfordoor = 5
function SWEP:PrimaryAttack()
//if ( !self:CanPrimaryAttack() ) then return end
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
    self.NextAttackW = CurTime() + self.cdfordoor
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if(ent:GetPos():Distance(self.Owner:GetPos()) < 400) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				--ent:SetSCP0492()
				--roundstats.zombies = roundstats.zombies + 1
				else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 10000, self.Owner, self.Owner )
				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then

						ent:TakeDamage( math.Round(math.random(5,6)), self.Owner, self.Owner )


						ent:EmitSound("door_break.wav")

					elseif string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
		                if SERVER then
			                ent:TakeDamage( math.Round(math.random(7,10)), self.Owner, self.Owner )
			            end

			            ent:EmitSound("door_break.wav")
		            end
				end
			end
		end
	end
end
SWEP.NextAbillity = 0
SWEP.cdNextAbillity = 70 -- Кд способности 035
function SWEP:SecondaryAttack()
    if preparing or postround then return end
	if self.NextAbillity > CurTime() then return end

	local findvictims = ents.FindInSphere( self.Owner:GetPos(), 250 )
	local pEntity = self.Owner:GetEyeTrace().Entity
	local victimplayers = {}
	for k,v in pairs(findvictims) do
		if v:IsPlayer() then
			if !(v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_SPEC) then
				table.ForceInsert(victimplayers, v)
			end
		elseif v:GetClass() == "func_breakable" then
			if v.TakeDamage then
				v:TakeDamage( 100, self.Owner, self.Owner )
			end
		end
	end
	if #victimplayers > 0 then
	    self.NextAbillity = CurTime() + self.cdNextAbillity
		local fixednicks = "Под влияние попал: "
		if CLIENT then return end
		local numi = 0
		for k,v in pairs(victimplayers) do
			numi = numi + 1

			if numi == 1 then
				fixednicks = fixednicks .. v:Nick()
			elseif numi == #victimplayers then
				fixednicks = fixednicks .. " and " .. v:Nick()
			else
				fixednicks = fixednicks .. ", " .. v:Nick()
			end
			--v:SendLua( 'surface.PlaySound("sfx/scp/1048a/shriek.ogg")' )
			self.Owner:EmitSound("scp_sounds/scp_035/jump_scare.mp3")
    	timer.Create("Vlianue", 0, 450, function()
				for k,v in pairs(victimplayers) do
				  if v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_SPEC or v:GTeam() == TEAM_SPECIAL then return end
        	v:SetEyeAngles((self.Owner:EyePos() - v:GetShootPos()):Angle():Normalize() )
      	end
			end)

		end
		self.Owner:PrintMessage(HUD_PRINTTALK, fixednicks)
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:DrawHUD()
	if disablehud == true then return end

	local showtext = "Выбивание окна готово"
	local showcolor = Color(0,255,0)
	local maskcolor = Color(75, 0, 130)
	local maskabillity = "Special thing is ready to use"
	local kek = Material("243292-200.png")
	if self.NextAttackW > CurTime() then
		showtext = "След удар через " .. math.Round(self.NextAttackW - CurTime())
		showcolor = Color(255,0,0)
	end
	if self.NextAbillity > CurTime() then
	    maskabillity = "Перезарядка: ".. math.Round(self.NextAbillity - CurTime())
	    maskcolor = Color(255,0,0)
		kek = Material("696399_unhappy_512x512.png")
	end
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(kek)
	surface.DrawTexturedRect(ScrW()/4.7, ScrH()/1.1, 64, 64)
	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	draw.Text( {
		text = maskabillity,
		pos = { ScrW() / 4.3, ScrH() - 120 },
		font = "HUDFont",
		color = maskcolor,
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

function SWEP:IsLookingAt( ply ) -- FROM 1.0 BREACH XD
	if ( ply != self.Owner ) then
		yes = ply:GetAimVector():Dot( ( self.Owner:GetPos() - ply:GetPos() ):GetNormalized() )
		return ( yes > 0.9 )
	end
end

function SWEP:Think()
	if SERVER then
		for k, v in ipairs(player.GetAll()) do
			if v:GTeam() != TEAM_SPEC or v:GTeam() != TEAM_DZ or v:GTeam() != TEAM_SCP then
				if self:IsLookingAt(v) and self:GetOwner():GetPos():Distance(v:GetPos()) < 100 and v:IsLineOfSightClear(self.Owner) then
					if v:Alive() then
						if v == self:GetOwner() then continue end
						if !IsValid(v) then continue end
						if v:GetNClass() == ROLES.ROLE_DZDD then continue end
						if v:GTeam() == TEAM_DZ then continue end
						if v:GTeam() == TEAM_SPEC then continue end

						d = DamageInfo()
						d:SetDamage(10000)
						d:SetAttacker(self:GetOwner())
						d:SetDamageType(DMG_GENERIC)
						if IsValid(v) then
							v:TakeDamageInfo(d)
						end
					end
				end
			end
		end
	end
end
