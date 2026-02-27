--[[
gamemodes/breach/entities/weapons/weapon_scp_8602.lua
--]]
AddCSLuaFile()
	if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName			= "SCP-860-2"

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 1.5
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Delay			= 0.1
SWEP.Secondary.Ammo		= "None"
SWEP.AttackDelay			= 15
SWEP.ISSCP 				= true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.teams					= {1}
SWEP.Sound					= "scp/689/689Attack.ogg"
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
SWEP.NextAttackW			= 15
SWEP.Lang = nil

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_8602
	end
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self.Owner:DrawWorldModel( false )
		self.Owner:DrawViewModel( false )
	end
end

function SWEP:Holster()
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
	end
	if preparing or postround then return end
	if self.Freeze == true then
		self.Freeze = false
		self.Owner:SetCrouchedWalkSpeed(0.6)
		self.Owner:SetJumpPower(200)
		self.Owner:SetWalkSpeed(190)
		self.Owner:SetRunSpeed(240)
	end
	--
end

SWEP.NextPrimary = 0

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if !SERVER then return end
	local trace = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50,
		filter = self.Owner,
		mask = MASK_SHOT,
		maxs = Vector( 10, 10, 10 ),
		mins = Vector( -10, -10, -10 )
	} )
	if trace.Hit then
		local trace2 = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
			filter = player:GetAll(),
			mask = MASK_SOLID,
			maxs = Vector( 10, 10, 10 ),
			mins = Vector( -10, -10, -10 )
		} )
		if trace2.Hit and trace.Entity:IsPlayer() and !trace2.Entity:IsPlayer() then
			if self.Owner:GetAimVector():Dot( Vector( 0, 0, -1 ) ) < 0.40 then --dont trigger charge when tr2 probably hit floor
				self:SpecialAttack( trace, trace2 )
			else
				self:NormalAttack( trace )
			end
		else
			self:NormalAttack( trace )
		end
	end
end

SWEP.Angles = { Angle( -10, -5, 0 ), Angle( 10, 5, 0 ), Angle( -10, 5, 0 ), Angle( 10, -5, 0 ) }

function SWEP:NormalAttack( trace )
	local ent = trace.Entity
	if !IsValid( ent ) then return end
	if ent:IsPlayer() then
		if ent:GTeam() == TEAM_SPEC then return end
		if ent:GTeam() == TEAM_SCP then return end
		ent:TakeDamage( math.random( 60, 80 ), self.Owner, self.Owner )
		self.Owner:EmitSound( "npc/antlion/shell_impact3.wav" )
		self.Owner:ViewPunch( table.Random( self.Angles ) )
	else
		if ent:GetClass() == "func_breakable" then
			ent:TakeDamage( 100, self.Owner, self.Owner )
			self.Owner:ViewPunch( table.Random( self.Angles ) )
		end
	end
end

function SWEP:SpecialAttack( trace )
	local ent = trace.Entity
	if !IsValid( ent ) then return end
	if ent:IsPlayer() then
		if ent:GTeam() == TEAM_SPEC then return end
		if ent:GTeam() == TEAM_SCP then return end
		ent:TakeDamage( math.random( 50, 110 ), self.Owner, self.Owner )
		self.Owner:TakeDamage( math.random( 30, 100 ), self.Owner, self.Owner )
		self.Owner:EmitSound( "npc/antlion/shell_impact4.wav" )
		self.Owner:ViewPunch( Angle( -30, 0, 0 ) )
		ent:ViewPunch( Angle( -50, 0, 0 ) )
		self.Owner:SetVelocity( self.Owner:GetAimVector() * 1300 )
		ent:SetVelocity( self.Owner:GetAimVector() * 1300 )
	end
end

function SWEP:SecondaryAttack()
	//if ( !self:CanPrimaryAttack() ) then return end
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
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				if ent:GTeam() == TEAM_DZ then return end
				local pos = Vector(5364.761230, 3831.989258, -1012.825439)
				if pos then
					roundstats.teleported = roundstats.teleported + 1
					self.Owner:SetHealth(self.Owner:Health() + 100)
					ent:TakeDamage( math.random( 50, 110 ), self.Owner, self.Owner )
					ent:SetPos(pos)
					ent:SendLua([[surface.PlaySound('/860_tp.mp3')]])
					--ent:SendLua([[surface.PlaySound('/860_tp.mp3')]])
          timer.Simple(0.2, function() ent:SetNWBool("Victim",true) end)
					timer.Simple(10, function() ent:SetNWBool("Victim",false) end) --ent:SetNWBool("Victim",true)
					local pose = Vector(6274.838867, 5457.647461, -1026.251709)
					self.Owner:SetPos(pose)
					self.Owner:SetNWInt("EXP", self.Owner:GetNWInt("EXP") + 1)
				end
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )

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
local NextBreachde = 0
local cdNextBreachde = 5
function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end


    local ent = self.Owner:GetEyeTrace().Entity
	if NextBreachde > CurTime() then return end
	NextBreachde = CurTime() + cdNextBreachde
    if ent:GetClass() == 'prop_dynamic' then
		if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then
			if SERVER then
			    ent:TakeDamage( math.Round(math.random(2,3)), self.Owner, self.Owner )
			end

			ent:EmitSound("door_break.wav")
		end
		elseif string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
		    if SERVER then
			    ent:TakeDamage( math.Round(math.random(4,5)), self.Owner, self.Owner )
			end

			ent:EmitSound("door_break.wav")

	end

end

function SWEP:DrawHUD()
	if disablehud == true then return end

	local showtext = "Готов телепортировать моего соперника в лес"

	local showcolor = Color(0,255,0)

	if self.NextAttackW > CurTime() then
		showtext = "Я набираю силы, через " .. math.Round(self.NextAttackW - CurTime()) .. " секунд они познают мою ненависть"
		showcolor = Color(255,0,0)
		--self.Owner:EmitSound(self.Sound)
	end

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
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


