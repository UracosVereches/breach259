
AddCSLuaFile()

SWEP.PrintName =	"Shield"
SWEP.Author =		"tau"
SWEP.Contact =		"http://steamcommunity.com/id/blue_orng/"

SWEP.Slot =		4
SWEP.SlotPos =		6

SWEP.Spawnable =	true

SWEP.ViewModel =	Model( "models/weapons/c_hexshield_grenade.mdl" )
SWEP.WorldModel =	Model( "models/weapons/w_hexshield_grenade.mdl" )

SWEP.UseHands =		true

SWEP.ViewModelFOV =	54

SWEP.Primary.ClipSize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic =	true
SWEP.Primary.Ammo =		"none"

SWEP.Secondary.ClipSize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	true
SWEP.Secondary.Ammo =		"none"

util.PrecacheSound( "items/medshotno1.wav" )

function SWEP:SetupDataTables()

	self:NetworkVar( "Vector",	0,	"ShieldColor" )

	self:NetworkVar( "Bool",	0,	"ShieldActive" )

end

if ( SERVER ) then

	function SWEP:Initialize()

		self.Events = {}

		self.NextFire = CurTime()

		ShieldMehDurability = 100

	end

	function SWEP:On_Deploy()

		self:SetShieldColor( Vector( self.Owner:GetInfo( "cl_hexshieldcolor" ) ) )

		self:SetHoldType( "slam" )
		self:SendWeaponAnim( ACT_VM_DRAW )

		self.NextEvent = CurTime() + ( self:SequenceDuration() - 0.25 )
		self.Events[ 1 ] = self.Event_Idle

	end

	function SWEP:On_Holster()
		hook.Remove("FinishMove", "hexshield")
	end

	function SWEP:Event_Idle()

		if ( CurTime() < self.NextEvent ) then return end

		self:SendWeaponAnim( ACT_VM_IDLE )

		self.Events[ 1 ] = self.Event_Hold

	end

	function SWEP:FindShield()

		for k, ent in pairs( ents.FindByClass( "hexshield" ) ) do

			if ( ent:GetTargetActivePlayer() == self.Owner ) then return ent end

		end

	end

	function SWEP:CreateShield()

		local min, max = self.Owner:GetCollisionBounds()
		min:Add( max )
		min:Mul( 0.5 )

		local ent = ents.Create( "hexshield" )
		ent:SetPos( self.Owner:LocalToWorld( min ) )
		ent:SetAngles( Angle( 0, self.Owner:GetAngles().y, 0 ) )
		ent:SetShieldColor( self:GetShieldColor() )
		ent:Spawn()
		ent:Activate()

		ent:SetGenerator( self )
		ent:SetTargetActivePlayer( self.Owner )
		ent:SetLocalMode( true )

		if SERVER then

			hook.Add( "FinishMove", "hexshield", function( ply, mv )

				for k, ent in pairs( ents.FindByClass( "hexshield" ) ) do

					if ( isfunction( ent.GetTargetActivePlayer ) ) and ( ent:GetTargetActivePlayer() == ply ) then

						local min, max = ply:GetCollisionBounds()
						min:Add( max )
						min:Mul( 0.5 )
						local pos, ang = LocalToWorld( min, angle_zero, mv:GetOrigin(), angle_zero )
						ang.p, ang.y, ang.r = 0, mv:GetAngles().y, 0

						ent:SetNetworkOrigin( pos )
						ent:SetAngles( ang )
						ent:SetAbsVelocity( mv:GetVelocity() )

						if ( SERVER ) then

							local physobj = ent:GetPhysicsObject()

							if ( IsValid( physobj ) ) then

								physobj:SetPos( pos )
								physobj:SetAngles( ang )
								physobj:Wake()

							end

						end

						return

					end

				end

			end )

		end

		return ent

	end

	function SWEP:Event_Hold()

		if ( self:WasPrimaryAttackPressed() ) then

			local t = CurTime()

			if ( t < self.NextFire ) then return end

			self.NextFire = t + 0.1

			if ( self:GetShieldActive() ) then

				if ( IsValid( self.Shield ) ) then self.Shield:ExpireLocal() end
				self.Shield = nil

				self:SetShieldActive( false )

			else

				local armor = self.Owner:Armor()

				if ( ShieldMehDurability < 1 ) then

					self:EmitSound( "items/medshotno1.wav", 75, 100, 0.75, CHAN_WEAPON )

					hook.Remove("FinishMove", "hexshield")

					return

				end

				self.Shield = self:FindShield()

				if ( IsValid( self.Shield ) ) then

					self.Shield:DeployLocal()

				else

					self.Shield = self:CreateShield()

					self.Shield:StartDeployLocal()

				end

				ShieldMehDurability = ShieldMehDurability - 1

				self.LastArmor_time = t
				self.LastArmor = ShieldMehDurability
				self.CurArmor = ShieldMehDurability

				self:SetShieldActive( true )

			end

		end

	end

	function SWEP:On_Deployed()

		for k, Event in pairs( self.Events ) do Event( self ) end

	end

	function SWEP:On_Holstered()
	end

	--There was an error saying that GetTargetPlayer, the Get function for the networked variable TargetPlayer, was nil. The error gave a few other messages referencing things that weren't related to my addon.
	--This referenced other addons, potentially.
	--Someone said they stopped the errors with a change to the code. The change had nothing to do woth the problem.
	--Unrealted to the function, they removed the parentheses from the function below which should have no connection with the problem.
	--The error mentioned ULib, so I looked it up and it is another addon that errors with everything.
	--The issue almost certainly is not related.
	--It is almost certainly caused by the conflicting ULib addon stuff.
	--I changed the function as the person reported and also chnaged some other things.
	--I changed TargetPlayer to TargetActivePlayer
	--A test was added.
	function SWEP:IsActive()

--		return ( self.Owner:GetActiveWeapon() == self )
		return self.Owner:GetActiveWeapon() == self

	end

	function SWEP:On_Equip()

		if ( self:GetShieldActive() ) then

			if ( IsValid( self.Shield ) ) then self.Shield:ExpireLocal() end
			self.Shield = nil

			self:SetShieldActive( false )

		end

		if ( self:IsActive() ) then

			self.WasActive = true

			self:On_Deploy()

		else

			self.WasActive = false

		end

	end

	function SWEP:On_Drop()

		if ( self:GetShieldActive() ) then

			if ( IsValid( self.Shield ) ) then self.Shield:ExpireLocal() end
			self.Shield = nil

			self:SetShieldActive( false )

		end

	end

	function SWEP:HandleArmor()

		local armor = self.Owner:Armor()

		if ( ShieldMehDurability ~= self.LastArmor ) then

			self.LastArmor = ShieldMehDurability
			self.CurArmor = ShieldMehDurability

		end

		local t = CurTime()

		self.CurArmor = self.CurArmor - ( ( t - self.LastArmor_time ) * 2 )

		self.LastArmor_time = t

		self.LastArmor = math.ceil( self.CurArmor )

		if ( self.LastArmor < 1 ) then

			ShieldMehDurability = 0

			self.Shield:ExpireLocal()
			self.Shield = nil

			self:SetShieldActive( false )

		else

			ShieldMehDurability = self.LastArmor

		end

	end

	function SWEP:On_Equipped()

		if ( self:GetShieldActive() ) then

			if ( IsValid( self.Shield ) ) then

				self:HandleArmor()

			else

				self:SetShieldActive( false )

			end

		end

		if ( self:IsActive() ) then

			if ( self.WasActive ) then

				self:On_Deployed()

			else

				self.WasActive = true

				self:On_Deploy()

			end

		else

			if ( self.WasActive ) then

				self.WasActive = false

				self:On_Holster()

			else

				self:On_Holstered()

			end

		end

	end

	function SWEP:On_Dropped()
	end

	function SWEP:OnTick()

		if ( IsValid( self.Owner ) ) then

			if ( self.Owner == self.LastOwner ) then

				self:On_Equipped()

			else

				self.LastOwner = self.Owner

				self:On_Equip()

			end

		else

			if ( self.Owner == self.LastOwner ) then

				self:On_Dropped()

			else

				self.LastOwner = self.Owner

				self:On_Drop()

			end

		end

		self:CheckPrimaryAttack()
--		self:CheckSecondaryAttack()

	end

	hook.Add( "Tick", "weapon_hexshield_local", function()

		for k, ent in pairs( ents.FindByClass( "weapon_hexshield_local" ) ) do ent:OnTick() end

	end )

----------------------------------------------------------------
--	So about 1 out of every 10 players was having an issue where Player.KeyDown and Player.KeyPressed were simply not returning true when they should.
--	This is a temporary fix.
----------------------------------------------------------------

	function SWEP:PrimaryAttack()

		self.PrimaryAttackDown = true

	end

	function SWEP:CheckPrimaryAttack()

		if ( self.PrimaryAttackDown ) then

			if ( not self.PrimaryAttackWasDown ) then self.PrimaryAttackWasDown = true end

			self.PrimaryAttackDown = false

		elseif ( self.PrimaryAttackWasDown ) then

			self.PrimaryAttackWasDown = false

		end

	end

	function SWEP:WasPrimaryAttackPressed()

		if ( self.Owner:KeyPressed( IN_ATTACK ) ) then return true end

		return self.PrimaryAttackDown and ( not self.PrimaryAttackWasDown )

	end

--[[
	function SWEP:IsPrimaryAttackDown()

		if ( self.Owner:KeyDown( IN_ATTACK ) ) then return true end

		return self.PrimaryAttackDown

	end
]]

	function SWEP:SecondaryAttack()

--		self.SecondaryAttackDown = true

	end

--[[
	function SWEP:CheckSecondaryAttack()

		if ( self.SecondaryAttackDown ) then

			if ( not self.SecondaryAttackWasDown ) then self.SecondaryAttackWasDown = true end

			self.SecondaryAttackDown = false

		elseif ( self.SecondaryAttackWasDown ) then

			self.SecondaryAttackWasDown = false

		end

	end

	function SWEP:WasSecondaryAttackPressed()

		if ( self.Owner:KeyPressed( IN_ATTACK2 ) ) then return true end

		return self.SecondaryAttackDown and ( not self.SecondaryAttackWasDown )

	end

	function SWEP:IsSecondaryAttackDown()

		if ( self.Owner:KeyDown( IN_ATTACK2 ) ) then return true end

		return self.SecondaryAttackDown

	end
]]

----------------------------------------------------------------

end

if ( CLIENT ) then

--[[
	ent.GetAttachment returns the wrong pos/ang in viewmodel draw hooks, so use the bone to get the right pos/ang.

	From c_hexshield_grenade.qc
	$attachment top "ValveBiped.Grenade_body" 0.182042 0.091960 -5.719451 rotate -0.019297 -3.117651 0.762499
	$attachment bottom "ValveBiped.Grenade_body" 0.070623 0.357805 4.597977 rotate -0.019295 -3.117651 0.762499

	From w_hexshield_grenade.qc
	$attachment top "ValveBiped.Bip01_R_Hand" 4.378477 -2.145518 -4.365536 rotate -1.288153 -0.067792 -1.488272
	$attachment bottom "ValveBiped.Bip01_R_Hand" 1.434943 -1.710799 5.589245 rotate 1.853438 -0.067792 -1.488271
]]

	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/icons/hexshield_grenadew" )

	function SWEP:DrawWeaponSelection( x, y, w, h, a )

		local xx = x + 10
		local yy = y + 10
		local ww = w - 20

		surface.SetDrawColor( 255, 235, 20, a )
		surface.SetTexture( self.WepSelectIcon )
		surface.DrawTexturedRect( xx, yy, ww, ww / 2 )

	end

	local refract = Material( "effects/hexshield/hexshield_r1" )
	local spritemat = Material( "sprites/light_ignorez" )

	function SWEP:ViewModelDrawn( viewmdl )

		if ( not self:GetShieldActive() ) then return end

		local shield_color = self:GetShieldColor()
		shield_color = Color( shield_color.x, shield_color.y, shield_color.z )

		local matr = viewmdl:GetBoneMatrix( viewmdl:LookupBone( "ValveBiped.Grenade_body" ) )
		local bonepos, boneang = matr:GetTranslation(), matr:GetAngles()
		local t_pos, t_ang = LocalToWorld( Vector( 0.182042, 0.091960, -5.719451 ), Angle( -0.019297, -3.117651, 0.762499 ), bonepos, boneang )
		local b_pos, b_ang = LocalToWorld( Vector( 0.070623, 0.357805, 4.597977 ), Angle( -0.019295, -3.117651, 0.762499 ), bonepos, boneang )

		local t = CurTime()

		local i = ( math.sin( t * 8 ) + 1 ) + ( ( math.sin( t * 4 ) + 1 ) * 2 )

		refract:SetFloat( "$refractamount", i * 0.003 )

		local size = ( i + 32 ) * 0.25

		render.UpdateRefractTexture()

		render.SetMaterial( refract )
		render.DrawSprite( t_pos, size, size, color_white )
		render.DrawSprite( b_pos, size, size, color_white )

		render.SetMaterial( spritemat )
		render.DrawSprite( t_pos, size, size, shield_color )
		render.DrawSprite( b_pos, size, size, shield_color )

	end

	function SWEP:DrawWorldModel()

		self:DrawModel()

		if ( not self:GetShieldActive() ) then return end

		local shield_color = self:GetShieldColor()
		shield_color = Color( shield_color.x, shield_color.y, shield_color.z )

		local posang = self:GetAttachment( self:LookupAttachment( "top" ) )
		local t_pos = posang.Pos
		posang = self:GetAttachment( self:LookupAttachment( "bottom" ) )
		local b_pos = posang.Pos

		local t = CurTime()

		local i = ( math.sin( t * 8 ) + 1 ) + ( ( math.sin( t * 4 ) + 1 ) * 2 )

		refract:SetFloat( "$refractamount", i * 0.003 )

		local size = ( i + 32 ) * 0.25

		render.UpdateRefractTexture()

		render.SetMaterial( refract )
		render.DrawSprite( t_pos, size, size, color_white )
		render.DrawSprite( b_pos, size, size, color_white )

		render.SetMaterial( spritemat )
		render.DrawSprite( t_pos, size, size, shield_color )
		render.DrawSprite( b_pos, size, size, shield_color )

	end

end