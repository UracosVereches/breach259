--[[
gamemodes/breach/entities/weapons/weapon_scp_1471.lua
--]]
AddCSLuaFile()

SWEP.PrintName			= "SCP-1471-A"

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 1
SWEP.Primary.Automatic	= true
SWEP.Primary.Ammo		= "None"
SWEP.Sound					= "scream_phone.mp3"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 3
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
SWEP.HoldType 			= "normal"

--if (CLIENT) then
	--SWEP.WepSelectIcon	= surface.GetTextureID( "vgui/entities/weapon_scp096" )
	--SWEP.BounceWeaponIcon = false
	--killicon.Add( "kill_icon_scp096", "vgui/icons/kill_icon_scp096", Color( 255, 255, 255, 255 ) )
--end

SWEP.Lang = nil

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_1471
	end
	self:SetHoldType("normal")
	self:SetNoDraw(true)
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self.Owner:DrawWorldModel( false )
		self.Owner:DrawViewModel( false )
		self.Owner:SetNWBool("hided1471",false)
	end
	if SERVER then
if not self.Owner:Alive() then return end
self.Owner:SetNoDraw(true)
self.Owner.ShouldReduceFallDamage = true
self.Owner:DrawWorldModel( false )
return true
end
end

function SWEP:Holster()
    self:OnRemove()
	return true
end

SWEP.Freeze = false

function SWEP:Think()
	if !SERVER then return end
	if preparing and (self.Freeze == false) then
		self.Freeze = true
		self.Owner:SetJumpPower(0)
		self.Owner:SetCrouchedWalkSpeed(0)
		self.Owner:SetWalkSpeed(0)
		self.Owner:SetRunSpeed(0)
		self.Owner:SetNoDraw(true)

	end
	if preparing or postround then return end
	if self.Freeze == true then
		self.Freeze = false
		self.Owner:SetCrouchedWalkSpeed(0.6)
		self.Owner:SetJumpPower(200)
		self.Owner:SetWalkSpeed(165)
		self.Owner:SetNoDraw(true)
		self.Owner:SetRunSpeed(185)
	end
  --self.Owner:SetNoDraw(true)

end

SWEP.NextPrimary = 0

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end

	--self.Owner:SetNoDraw(false)


	if !SERVER then return end

	local trace = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50,
		filter = self.Owner,
		mask = MASK_SHOT,
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10 ,10 )
	} )
	if !trace.Hit then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	timer.Create("turnoffinvisible", 0.01, 1, function()
		self.Owner:SetNoDraw(false)
    self.Owner:SetNWBool("hided1471",true)
		timer.Simple(2, function() self.Owner:SetNoDraw(true) self.Owner:SetNWBool("hided1471",false) end)
	end)
  self.Owner:SetNoDraw(false)
	local ent = trace.Entity
	if IsValid( ent ) then
		if ent:IsPlayer() then
			if ent:GTeam() == TEAM_SPEC then return end
			if ent:GTeam() == TEAM_SCP then return end
			ent:ViewPunch( Angle(math.Rand(-15, -10), math.Rand(-10, 10), 0) )
			ent:TakeDamage( math.random(20,30), self.Owner, self.Owner )
			ent:SendLua([[surface.PlaySound('/scream_phone.mp3')]])
			ent:SendLua([[surface.PlaySound('/scream_phone.mp3')]])

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

SWEP.NextSecondary = 0
SWEP.Camera = nil

function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextSecondary > CurTime() then return end
	local trace = self.Owner:GetEyeTrace()
	if !trace.Hit then return end
	local ent = trace.Entity

	if IsValid( ent ) then
		if ent:IsPlayer() and ent:GTeam() != TEAM_SCP and ent:GTeam() != TEAM_SPEC then
			if ent:GetAimVector():Dot( (ent:EyePos() - self.Owner:EyePos() ):GetNormalized() ) > -0.5 then
				self.NextSecondary = CurTime() + self.Secondary.Delay
				if !SERVER then return end

				local dist = self.Owner:GetPos() - ent:GetPos()

				local mult = dist:Length() < 500 and dist:Length() * 0.15 or dist:Length() * 4
				local times = dist:Length() < 500 and 2 or dist:Length() < 1500 and 7 or 15
				local pos  = dist:GetNormalized() * -mult
				if dist:Length() > 50 then
					print( times )

					--self.Owner:SetPos( self.Owner:GetPos() + pos )
					timer.Create( "1471SpeedTimer", 0.001, times, function()
						self.Owner:SetVelocity( pos * 30 + Vector( 0, 0, -1500 ) )
					end )
				end
				if !Camera or !IsValid( Camera ) then
					Camera = ents.Create( "point_camera" )
					Camera:SetKeyValue( "GlobalOverride", 1 )
					Camera:SetKeyValue( "UseScreenAspectRatio", "true" )
					Camera:SetKeyValue( "FOV", 90 )
				end
				--if dist:Length() > 50 then
					Camera:Spawn()
					Camera:Activate()
					Camera:SetPos( ent:GetPos() - dist:GetNormalized() * 25 + Vector( 0, 0, 85 ) )
					Camera:SetAngles( Angle( 10, dist:Angle().y, 0 ) )
					Camera:Fire( "SetOn" )
					timer.Simple( 0.01, function()
						Camera:Remove()
					end )
					local dmd = dist:GetNormalized()
					ent:SendLua( "CamEnable = true" )
					ent:SendLua([[surface.PlaySound('/phone_teleport.mp3')]])
					ent:SendLua([[surface.PlaySound('/phone_teleport.mp3')]])
					ent:SendLua( "dir = Vector( "..dmd.x..", "..dmd.y..", "..dmd.z.." )" )
					--self.Owner:SendLua( "CamEnable = true" )
					--self.Owner:SendLua( "dir = Vector( "..dmd.x..", "..dmd.y..", "..dmd.z.." )" )
				--end
			end
		end
	end
end

function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	--
end

function SWEP:OnRemove()

end

function SWEP:DrawHUD()
	if disablehud == true then return end

	local showtext = "Готов к атаке"
	local showcolor = Color(0,255,0)
	local invisibletext = ""
	local clr = Color(255,0,0)

	if self.NextSecondary > CurTime() then
		showtext = "Перезарядка ".. math.Round(self.NextSecondary - CurTime())
		showcolor = Color(255,0,0)
	end
	if self.Owner:GetNWBool("hided1471") == true then
		invisibletext = "Вас видно!"
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
		text = invisibletext,
		pos = { ScrW() / 2, ScrH() - 50 },
		font = "173font",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end


