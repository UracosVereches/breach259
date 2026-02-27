
AddCSLuaFile()

SWEP.PrintName =	"Hex-Shield"
SWEP.Author =		"tau"
SWEP.Contact =		"http://steamcommunity.com/id/blue_orng/"

SWEP.Slot =		4
SWEP.SlotPos =		5

SWEP.Spawnable =	true

SWEP.ViewModel =	Model( "models/weapons/c_hexshield_grenade.mdl" )
SWEP.WorldModel =	Model( "models/weapons/w_hexshield_grenade.mdl" )

SWEP.UseHands =		true

SWEP.ViewModelFOV =	54

game.AddAmmoType( { name = "hexshield_grenade" } )

SWEP.Primary.ClipSize =	-1
SWEP.Primary.DefaultClip =	1
SWEP.Primary.Automatic =	true
SWEP.Primary.Ammo =		"hexshield_grenade"

SWEP.Secondary.ClipSize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	true
SWEP.Secondary.Ammo =		"none"

function SWEP:SetupDataTables()

	self:NetworkVar( "Vector",	0,	"ShieldColor" )

end

function SWEP:GetAmmo()

	return self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() )

end

if ( SERVER ) then

--local diagnosticmode =	CreateConVar( "hexshield_diagnostic",	"0",	FCVAR_NOTIFY + FCVAR_REPLICATED,	"Diagnostic mode for the Hex-Shield Grenade." )
--local c_w = Color( 255, 255, 255 )
--local c_h = Color( 31, 0, 255 )

	function SWEP:Initialize()
--if ( diagnosticmode:GetBool() ) then MsgC( c_w, "\tHex-Shield diagnostic: Weapon <"..tostring( self ).."> " ) MsgC( c_h, "Initialize" ) MsgC( c_w, " called with "..tostring( self.Owner ).." at "..tostring( CurTime() ).."\n" ) end
		self.Events = {}

	end

	function SWEP:OutOfAmmo()

		return self:GetAmmo() < 1

	end

	function SWEP:On_Deploy()

		self:SetShieldColor( Vector( self.Owner:GetInfo( "cl_hexshieldcolor" ) ) )

		if ( self:OutOfAmmo() ) then

			self:On_OutOfAmmo()

			return

		end

		self:SetHoldType( "slam" )
		self:SendWeaponAnim( ACT_VM_DRAW )

		self.NextEvent = CurTime() + ( self:SequenceDuration() - 0.25 )
		self.Events[ 1 ] = self.Event_Idle

	end

	function SWEP:On_Holster()

	end

	function SWEP:Event_Idle()

		if ( self:OutOfAmmo() ) then

			self:On_OutOfAmmo()

			return

		end

		if ( CurTime() < self.NextEvent ) then return end

		self:SendWeaponAnim( ACT_VM_IDLE )

		self.Events[ 1 ] = self.Event_Hold

	end

	function SWEP:Event_Hold()

		if ( self:OutOfAmmo() ) then

			self:On_OutOfAmmo()

			return

		end

		if ( self:WasPrimaryAttackPressed() ) then

			self:SetHoldType( "grenade" )
			self:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )

			self.NextEvent = CurTime() + self:SequenceDuration()
			self.Events[ 1 ] = self.Event_Lift

		end

	end

	function SWEP:Event_Lift()

		if ( self:OutOfAmmo() ) then

			self:On_OutOfAmmo()

			return

		end

		if ( CurTime() < self.NextEvent ) then return end

		if ( self:WasSecondaryAttackPressed() ) then

			self:SetHoldType( "slam" )
			self:SendWeaponAnim( ACT_VM_IDLE )

			self.Events[ 1 ] = self.Event_Hold

		elseif ( not self:IsPrimaryAttackDown() ) then

			self:SendWeaponAnim( ACT_VM_THROW )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )

			self.ThrowTime = CurTime() + 0.1
			self.NextEvent = CurTime() + self:SequenceDuration()
			self.Events[ 1 ] = self.Event_Throw

		end

	end

	function SWEP:Event_Throw()

		if ( self:OutOfAmmo() ) then

			self:On_OutOfAmmo()

			return

		end

		if ( CurTime() < self.ThrowTime ) then return end

		self:Throw()
		self.Owner:RemoveAmmo( 1, self:GetPrimaryAmmoType() )

		self.Owner:DrawWorldModel( false )

		self.Events[ 1 ] = self.Event_Draw

	end

	function SWEP:Event_Draw()

		if ( CurTime() < self.NextEvent ) then return end

		if ( self:OutOfAmmo() ) then

			self:On_OutOfAmmo()

			return

		end

		self.Owner:DrawWorldModel( true )
		self:SetHoldType( "slam" )
		self:SendWeaponAnim( ACT_VM_DRAW )

		self.NextEvent = CurTime() + ( self:SequenceDuration() - 0.25 )
		self.Events[ 1 ] = self.Event_Idle

	end

	function SWEP:On_OutOfAmmo()

		self.Owner:DrawViewModel( false )
		self.Owner:DrawWorldModel( false )
		self:SetHoldType( "normal" )

		self.Events[ 1 ] = self.Event_None

	end

	function SWEP:Event_None()

		if ( self:OutOfAmmo() ) then return end

		self.Owner:DrawViewModel( true )
		self.Owner:DrawWorldModel( true )
		self:SetHoldType( "slam" )
		self:SendWeaponAnim( ACT_VM_DRAW )

		self.NextEvent = CurTime() + ( self:SequenceDuration() - 0.25 )
		self.Events[ 1 ] = self.Event_Idle

	end

	function SWEP:Throw()

		local tr = self.Owner:GetEyeTrace()

		local pos, ang = LocalToWorld( Vector( -7.372986, -22.582741, 6.5 ), Angle( -49.604, -95.015, 176.585 ), tr.StartPos, tr.Normal:Angle() )

		local ent = ents.Create( "hexshield_grenade" )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:SetShieldColor( self:GetShieldColor() )
		ent:Spawn()

		ent.OwnerPlayer = self.Owner

		local physobj = ent:GetPhysicsObject()

		if ( IsValid( physobj ) ) then

			physobj:Wake()

			physobj:SetVelocityInstantaneous( self.Owner:GetVelocity() )

			local fw = tr.HitPos - pos
			local dist = fw:Length()
			if ( dist > 0 ) then

				fw:Mul( 750 / dist )

				local up = ang:Up()
				up:Mul( 4 )
				up:Add( pos )

				physobj:ApplyForceOffset( fw, up )

			end

		end

	end

	function SWEP:On_Deployed()

		for k, Event in pairs( self.Events ) do Event( self ) end

	end

	function SWEP:On_Holstered()
	end

	function SWEP:IsActive()

		return self.Owner:GetActiveWeapon() == self

	end

	function SWEP:On_Equip()

		if ( self:IsActive() ) then

			self.WasActive = true

			self:On_Deploy()

		else

			self.WasActive = false

		end

	end

	function SWEP:On_Drop()

	end

	function SWEP:On_Equipped()

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
		self:CheckSecondaryAttack()

	end

	hook.Add( "Tick", "weapon_hexshield", function()

		for k, ent in pairs( ents.FindByClass( "weapon_hexshield" ) ) do ent:OnTick() end

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

	function SWEP:IsPrimaryAttackDown()

		if ( self.Owner:KeyDown( IN_ATTACK ) ) then return true end

		return self.PrimaryAttackDown

	end

	function SWEP:SecondaryAttack()

		self.SecondaryAttackDown = true

	end

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

--[[
	function SWEP:IsSecondaryAttackDown()

		if ( self.Owner:KeyDown( IN_ATTACK2 ) ) then return true end

		return self.SecondaryAttackDown

	end
]]

----------------------------------------------------------------

end

if ( CLIENT ) then

	function SWEP:CustomAmmoDisplay()

		if ( not self.AmmoDisplay ) then self.AmmoDisplay = {} end

		self.AmmoDisplay.Draw = true
		self.AmmoDisplay.PrimaryClip = self:GetAmmo()

		return self.AmmoDisplay

	end

	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/icons/hexshield_grenadew" )

	function SWEP:DrawWeaponSelection( x, y, w, h, a )

		local xx = x + 10
		local yy = y + 10
		local ww = w - 20

		surface.SetDrawColor( 255, 235, 20, a )
		surface.SetTexture( self.WepSelectIcon )
		surface.DrawTexturedRect( xx, yy, ww, ww / 2 )

	end

	language.Add( "hexshield_grenade_ammo", "Hex-Shield Grenade" )

end

