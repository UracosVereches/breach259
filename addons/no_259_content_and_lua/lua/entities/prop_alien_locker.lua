--[[
lua/entities/prop_alien_locker.lua
--]]

AddCSLuaFile()
local BaseClass = baseclass.Get( "base_anim" )

ENT.PrintName = "New Locker"
ENT.Spawnable = true
ENT.Category = "Breach"
ENT.AdminOnly = false
ENT.Editable = false

ENT.IsPlayerInside = false


if ( SERVER ) then

  util.AddNetworkString( "GetEntityInsideLocker" )

end

if ( CLIENT ) then

  net.Receive( "GetEntityInsideLocker", function( len )

    local entityinside = net.ReadEntity()
    local caller = net.ReadEntity()

    caller:SetNWEntity( "RagdollEntityNO", entityinside )

  end)

end

function ENT:Initialize()

  if ( CLIENT ) then return end

  self:SetModel( "models/scp_locker/scp_locker.mdl" )
  self:SetMoveType( MOVETYPE_NONE )
  self:SetSolid( SOLID_VPHYSICS )

  self:SetUseType( USE_TOGGLE )
  self:SetAutomaticFrameAdvance( true )

  self:DrawShadow( false )

end

function ENT:OnTakeDamage( dmg )

  dmg:ScaleDamage( .15 )

  if ( self.PlayerInside ) then

    if ( self.PlayerInside:Health() > dmg:GetDamage() ) then

      self.PlayerInside:TakeDamage( dmg:GetDamage(), dmg:GetDamage(), dmg:GetAttacker():GetActiveWeapon() )

    else

      self.NextUse = CurTime() + 2
      self:ResetSequence( self:LookupSequence( "getout" ) )
      self.IsPlayerInside = false
      self.PlayerInside:GetNWEntity( "RagdollEntityNO" ):Remove()
      self.PlayerInside:SetNWEntity( "RagdollEntityNO", NULL )

      self.PlayerInside:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
      self.PlayerInside:SetNoDraw( false )
      self.PlayerInside:DrawViewModel( true )
      if ( IsValid( self.PlayerInside:GetActiveWeapon() ) ) then

        self.PlayerInside:GetActiveWeapon():SetNoDraw( false )

      end
      self.PlayerInside = nil;


    end

  end


end

function ENT:OnRemove()

  if ( self.IsPlayerInside ) then

    self.IsPlayerInside = false
    self.PlayerInside:GetNWEntity( "RagdollEntityNO" ):Remove()
    self.PlayerInside:SetNWEntity( "RagdollEntityNO", NULL )

    --self.PlayerInside:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
    self.PlayerInside:SetNoDraw( false )
    self.PlayerInside:DrawViewModel( true )
    if ( IsValid( self.PlayerInside:GetActiveWeapon() ) ) then

      self.PlayerInside:GetActiveWeapon():SetNoDraw( false )

    end
    self.PlayerInside = nil;

  end

end


function ENT:Use( caller )

  if ( ( self.NextUse || 0 ) >= CurTime() ) then return end

  if ( self.IsPlayerInside && caller:GTeam() == TEAM_SCP ) then

    self.NextUse = CurTime() + 2


    self:ResetSequence( self:LookupSequence( "getout" ) )
    self.IsPlayerInside = false
    self.PlayerInside:GetNWEntity( "RagdollEntityNO" ):Remove()
    self.PlayerInside:SetNWEntity( "RagdollEntityNO", NULL )

    self.PlayerInside:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
    self.PlayerInside:SetNoDraw( false )
    self.PlayerInside:DrawViewModel( true )


    if ( IsValid( self.PlayerInside:GetActiveWeapon() ) ) then

      self.PlayerInside:GetActiveWeapon():SetNoDraw( false )

    end


    self.PlayerInside = nil;

  elseif ( !self.IsPlayerInside && caller:GTeam() == TEAM_SCP ) then

    self.NextUse = CurTime() + 2
    self:ResetSequence( self:LookupSequence( "getout" ) )

  end

  if ( !self.IsPlayerInside && caller:GTeam() != TEAM_SCP ) then

    self.NextUse = CurTime() + 2
    self:ResetSequence( self:LookupSequence( "getin" ) )

    self.IsPlayerInside = true
    local fakeplayer = ents.Create( "base_gmodentity" )
    fakeplayer:SetModel( caller:GetModel() )
    fakeplayer:SetPos( self:GetPos() )
    fakeplayer:SetAngles( self:GetAngles() )
    fakeplayer:SetSkin( caller:GetSkin() )
    fakeplayer:Spawn()
    fakeplayer:SetParent( self )
    fakeplayer:ResetSequence( 2 )

    timer.Simple( .1, function()

      net.Start( "GetEntityInsideLocker" )

        net.WriteEntity( fakeplayer )
        net.WriteEntity( caller )

      net.Send( caller )

    end )
    caller:SetPos( self:GetPos() )
    caller:SetNoDraw( true )
    caller:DrawViewModel( false )
    self.PlayerInside = caller;

    if ( IsValid( caller:GetActiveWeapon() ) ) then

      caller:GetActiveWeapon():SetNoDraw( true )

    end

    caller:SetNWEntity( "RagdollEntityNO", fakeplayer )

  elseif ( self.IsPlayerInside && caller == self.PlayerInside && caller:GTeam() != TEAM_SCP ) then

    self.NextUse = CurTime() + 2
    self:ResetSequence( self:LookupSequence( "getout" ) )
    self.IsPlayerInside = false

		if ( caller:GetNWEntity( "RagdollEntityNO" ) ) then

	    caller:GetNWEntity( "RagdollEntityNO" ):Remove()
	    caller:SetNWEntity( "RagdollEntityNO", NULL )

		end

	  caller:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
	 	caller:SetNoDraw( false )
	  caller:DrawViewModel( true )
	  self.PlayerInside = nil;

	  if ( IsValid( caller:GetActiveWeapon() ) ) then

	    caller:GetActiveWeapon():SetNoDraw( false )

	  end

  end


end


