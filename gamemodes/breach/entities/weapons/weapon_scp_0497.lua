--[[
gamemodes/breach/entities/weapons/weapon_scp_0497.lua
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
SWEP.PrintName		= "SCP-049"
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
SWEP.AttackDelay = 3
SWEP.NextAttackW			= 0

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

function SWEP:Remove()
	/*if CLIENT and IsValid( self.SantasHat ) then
		self.SantasHat:Remove()
	end*/
end

SWEP.Lang = nil

function SWEP:Initialize()
	self:SetHoldType("normal")
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_049
		self.Author		= self.Lang.author
		self.Contact		= self.Lang.contact
		self.Purpose		= self.Lang.purpose
		self.Instructions	= self.Lang.instructions
	end
	for i=0, 4 do
		sound.Add( {
			name = "attack"..i,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 130,
			pitch = 100,
			sound = "scp/049/attack"..i..".ogg"
		} )
	end
	/*if CLIENT then
		if !self.SantasHat then
			self.SantasHat = ClientsideModel( "models/player/barney.mdl" )
			self.SantasHat:SetModelScale( 1 )
			self.SantasHat:SetNoDraw( true )
		end
	end*/
end

function SWEP:Think()
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	//if ( !self:CanPrimaryAttack() ) then return end
	if preparing or postround then return end
	if self.NextAttackW > CurTime() then return end
    self.NextAttackW = CurTime() + self.AttackDelay
	if not IsFirstTimePredicted() then return end

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
				if ent:GTeam() == TEAM_SPECIAL then
					local d = DamageInfo()
					d:SetDamageType(DMG_GENERIC)
					d:SetDamage(10000)
					d:SetAttacker(self:GetOwner())
					ent:TakeDamageInfo(d)
					self.Owner:AddExp(25, true)
					return
				end
				if ent:GetNClass() == ROLES.ROLE_BIO then return end
				if ent:GetNClass() == ROLES.ROLE_MTFJAG then return end
				if ent:GTeam() == TEAM_SPEC then return end
				if ent:GTeam() == TEAM_DZ then return end
				if ent.Using714 then return end

				self.Owner:SetNWInt("EXP", self.Owner:GetNWInt("EXP") + 1)
				ent:SetSCP0492()
				roundstats.zombies = roundstats.zombies + 1
				ent:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 0.2, 16 )
				timer.Simple(3, function() ent:SendLua('surface.PlaySound("scp/049/attack"..math.random( 0, 4 )..".ogg")') end)
				timer.Simple(4, function() ent:SendLua('surface.PlaySound("sfx/Character/D9341/Cough"..math.random( 0, 3 )..".ogg")') end)
				timer.Simple(6, function() ent:SendLua('surface.PlaySound("sfx/Character/D9341/Damage3.ogg")') end)
				timer.Simple(7.5, function() ent:SendLua('surface.PlaySound("weapons/966/death.wav")') end)
				timer.Simple(7.7, function() ent:ScreenFade(SCREENFADE.OUT, COLOR( 255, 0, 0, 170), 0.5, 2) end)
				timer.Simple(8, function() ent:SendLua('surface.PlaySound("scp/049/attack"..math.random( 0, 4 )..".ogg")') end)

				self.Owner:EmitSound( "attack"..math.random( 0, 4 ) )
				ent:AddExp(-25, true)
				timer.Create("idle" ..ent:SteamID(), 0.1, 98, function()

					ent:Freeze(true)
					ent:DoAnimationEvent(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)

				end)
				timer.Simple(10, function() ent:DoAnimationEvent(ACT_HL2MP_ZOMBIE_SLUMP_RISE) end)
				timer.Simple(15, function() ent:Freeze(false) end)
				self.Owner:AddExp(25, true)


			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )

				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then

						ent:TakeDamage( math.Round(math.random(2,3)), self.Owner, self.Owner )


						ent:EmitSound("door_break.wav")
					elseif string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
		                if SERVER then
			                ent:TakeDamage( math.Round(math.random(8,9)), self.Owner, self.Owner )
			            end

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

	local showtext = "Ready for cure"
	local showcolor = Color(0,255,0)

	if self.NextAttackW > CurTime() then
		showtext = "Next CURE ".. math.Round(self.NextAttackW - CurTime())
		showcolor = Color(255,0,0)
	end

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "char_titleescape2",
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

/*function SWEP:DrawWorldModel()
	if !IsValid( self.SantasHat ) then return end
	local boneid = self.Owner:LookupBone( "ValveBiped.Bip01_Head1" )
	if not boneid then
		for i=0, self.Owner:GetBoneCount()-1 do
			print( i, self.Owner:GetBoneName( i ) )
		end
		return
	end

	local matrix = self.Owner:GetBoneMatrix( boneid )
	if not matrix then
		return
	end

	local newpos, newang = LocalToWorld( self.SantasHatPositionOffset, self.SantasHatAngleOffset, matrix:GetTranslation(), matrix:GetAngles() )

	self.SantasHat:SetPos( newpos )
	self.SantasHat:SetAngles( newang )
	self.SantasHat:SetupBones()
	self.SantasHat:DrawModel()
end*/


