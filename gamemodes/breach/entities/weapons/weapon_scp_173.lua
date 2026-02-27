--[[
gamemodes/breach/entities/weapons/weapon_scp_173.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= ""
SWEP.PrintName		= "SCP-173"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.15
SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.SnapSound				= Sound( "snap.wav" )
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.SpecialDelay			= 90
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.NextAttackW			= 0

--SWEP.SantasHatPositionOffset = Vector( -3, 47, 1 )
--SWEP.SantasHatAngleOffset = Angle( -90, -20, -20 )

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
	self.Owner:SetJumpPower(0)
	self.Owner:SetWalkSpeed(380)
	self.Owner:SetRunSpeed(400)
	self.Owner:SetMaxSpeed(400)
end

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_173
	end
	self:SetHoldType(self.HoldType)
end

function SWEP:Remove()
	/*if CLIENT and IsValid( self.SantasHat ) then
		self.SantasHat:Remove()
	end*/
end

function SWEP:IsLookingAt( ply )
	local yes = ply:GetAimVector():Dot( ( self.Owner:GetPos() - ply:GetPos() + Vector( 70 ) ):GetNormalized() )
	return (yes > 0.39)
end

SWEP.DrawRed = 0
function SWEP:Think()
	if CLIENT then
		self.DrawRed = CurTime() + 0.1
	end
	if postround then return end
	local watching = 0
	for k,v in pairs(player.GetAll()) do
		if IsValid(v) and v:GTeam() != TEAM_SPEC and v:Alive() and v != self.Owner and v.canblink and v:GTeam() != TEAM_DZ then
			local tr_eyes = util.TraceLine( {
				start = v:EyePos() + v:EyeAngles():Forward() * 15,
				//start = v:LocalToWorld( v:OBBCenter() ),
				//start = v:GetPos() + (self.Owner:EyeAngles():Forward() * 5000),
				endpos = self.Owner:EyePos(),
				//filter = v
			} )
			local tr_center = util.TraceLine( {
				start = v:LocalToWorld( v:OBBCenter() ),
				endpos = self.Owner:LocalToWorld( self.Owner:OBBCenter() ),
				filter = v
			} )
			if tr_eyes.Entity == self.Owner or tr_center.Entity == self.Owner then
				//self.Owner:PrintMessage(HUD_PRINTTALK, tostring(tr_eyes.Entity) .. " : " .. tostring(tr_center.Entity) .. " : " .. tostring(tr_center.Entity))
				if self:IsLookingAt( v ) and v.isblinking == false then
					watching = watching + 1
					//if self:GetPos():Distance(v:GetPos()) > 100 then
						//self.Owner:PrintMessage(HUD_PRINTTALK, v:Nick() .. " смотрит на тебя")
					//end
				end
			end
		end
	end
	if watching > 0 then
		self.Owner:Freeze(true)
	else
		self.Owner:Freeze(false)
	end
end
local NextBreachded = 0
local cdNextBreachded = 5
function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end


	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end


    local ent = self.Owner:GetEyeTrace().Entity
	if NextBreachded > CurTime() then return end
	NextBreachded = CurTime() + cdNextBreachded
    if ent:GetClass() == 'prop_dynamic' then
		if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then
			if SERVER then
			    ent:TakeDamage( math.Round(math.random(15,24)), self.Owner, self.Owner )
			end

			ent:EmitSound("door_break.wav")

		elseif string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
		                if SERVER then
			                ent:TakeDamage( math.Round(math.random(9,11)), self.Owner, self.Owner )
			            end

			            ent:EmitSound("door_break.wav")
		end
	end


end

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
		local ent = nil
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 ),
			filter = self.Owner,
			mins = Vector( -20, -20, -20 ),
			maxs = Vector( 20, 20, 20 ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_DZ then return end
				if ent:GTeam() == TEAM_SPEC then return end
				--print(ent:GetInflictor())
				self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 100, 0, self.Owner:GetMaxHealth() ) )
				ent:TakeDamage(8000, self.Owner, self.Owner)
				self.Owner:SetNWInt("EXP", self.Owner:GetNWInt("EXP") + 1)
				roundstats.snapped = roundstats.snapped + 1
				ent:EmitSound( "sfx/scp/173/NeckSnap"..math.random(1, 3)..".mp3", 500, 100 )
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
	end
end

function SWEP:Holster()
	self.Owner:SetWalkSpeed(1)
	self.Owner:SetRunSpeed(1)
	self.Owner:SetJumpPower(1)
	return true
end

SWEP.NextSpecial = 0
function SWEP:SecondaryAttack()
	local time = 4.4
	if self.NextSpecial > CurTime() then return end
	self.NextSpecial = CurTime() + self.SpecialDelay
	if CLIENT then
		surface.PlaySound("Horror2.ogg")
	end
	local findents = ents.FindInSphere( self.Owner:GetPos(), 5000 )
	local foundplayers = {}
	for k,v in pairs(findents) do

		if v:IsPlayer() then
			if (v:GetPos():Distance(self.Owner:GetPos()) < 200) then
				time = 6
			--	print(v, " 1")
			end
			if (v:GetPos():Distance(self.Owner:GetPos()) > 400) and (v:GetPos():Distance(self.Owner:GetPos()) < 1000) then
				time = 5
		--		print(v, " 2")
			end
			if (v:GetPos():Distance(self.Owner:GetPos()) > 1000) and (v:GetPos():Distance(self.Owner:GetPos()) < 1500) then
				time = 4
			--	print(v, " 3")
			end
			if (v:GetPos():Distance(self.Owner:GetPos()) > 1500) and (v:GetPos():Distance(self.Owner:GetPos()) < 2000) then
				time = 3.8
			--	print(v, " 4")
			end
			if (v:GetPos():Distance(self.Owner:GetPos()) > 2000) and (v:GetPos():Distance(self.Owner:GetPos()) < 3000) then
				time = 3.5
			--	print(v, " 5")
			end
			if (v:GetPos():Distance(self.Owner:GetPos()) > 3000) and (v:GetPos():Distance(self.Owner:GetPos()) < 4000) then
				time = 3.3
			--	print(v, " 6")
			end
			if (v:GetPos():Distance(self.Owner:GetPos()) > 4000) and (v:GetPos():Distance(self.Owner:GetPos()) < 5000) then
				time = 3
				--print(v, " 7")
			end
			if !(v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_DZ or v:GTeam() == TEAM_SPEC or v.Using714 ) then
				if v.usedeyedrops == false then
					table.ForceInsert(foundplayers, v)
				end
			end
		end
	end
	if #foundplayers > 0 then
		local fixednicks = "Ослеплены: "
		if CLIENT then return end
		local numi = 0
		for k,v in pairs(foundplayers) do
			numi = numi + 1

			if numi == 1 then
				fixednicks = fixednicks .. v:Nick()
			elseif numi == #foundplayers then
				fixednicks = fixednicks .. " и " .. v:Nick()
			else
				fixednicks = fixednicks .. ", " .. v:Nick()
			end
			v:SendLua( 'surface.PlaySound("Horror2.ogg")' )
			--print(time)
			net.Start("PlayerBlink")
				net.WriteFloat(time)
			net.Send(v)

			v.isblinking = true
			v.blinkedby173 = true
		end
		self.Owner:PrintMessage(HUD_PRINTTALK, fixednicks)
		timer.Create("UnBlinkTimer173", time + 0.2, 1, function()
			for k,v in pairs(player.GetAll()) do
				if v.blinkedby173 then
					v.isblinking = false
					v.blinkedby173 = false
				end
			end
		end)
	end
end
hook.Add("PlayerDeath", "173dies", function(victim)
  if victim:GetNClass() != ROLES.ROLE_SCP173 then return end

	victim:Freeze(false)
  local timed = 15
    if CLIENT then
		surface.PlaySound("Horror2.ogg")
	end
  local findoslep = ents.FindInSphere( victim:GetPos(), 2000 )
	local foundpl = {}
	for k,v in pairs(findoslep) do
		if v:IsPlayer() then
			if v.blinkedby173 then return end
			if !(v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_DZ or v:GTeam() == TEAM_SPEC or v.Using714 ) then
				if v.usedeyedrops == false then
					table.ForceInsert(foundpl, v)
				end
			end
		end
	end
	if #foundpl > 0 then

		if CLIENT then return end
		local numi = 0
		for k,v in pairs(foundpl) do
			numi = numi + 1


			v:SendLua( 'surface.PlaySound("Horror2.ogg")' )
			net.Start("PlayerBlink")
				net.WriteFloat(timed)
			net.Send(v)
			v.isblinking = true
			v.blinkedby173 = true
		end

		timer.Create("UnBlinkTimer173dies", timed + 0.2, 1, function()
			for k,v in pairs(player.GetAll()) do
				if v.blinkedby173 then
					v.isblinking = false
					v.blinkedby173 = false
				end
			end
		end)
	end
end)
function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	local showtext = ""
	local showtextlook = self.Lang.HUD.nlook
	local lookcolor = Color(0,255,0)
	local showcolor = Color(17, 145, 66)
	if self.NextSpecial > CurTime() then
		showtext = self.Lang.HUD.specCD.." "..math.Round(self.NextSpecial - CurTime())
		showcolor = Color(145, 17, 62)
	else
		showtext = self.Lang.HUD.specReady
	end
	if self.DrawRed < CurTime() then
		self.CColor = Color(255,0,0)
		showtextlook = self.Lang.HUD.slook
		lookcolor = Color(145, 17, 62)
	else
		self.CColor = Color(0,255,0)
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
		text = showtextlook,
		pos = { ScrW() / 2, ScrH() - 25 },
		font = "173font",
		color = lookcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0

	local scale = 0.3
	surface.SetDrawColor( self.CColor.r, self.CColor.g, self.CColor.b, 255 )

	local gap = 5
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
end


