--[[
gamemodes/breach/entities/weapons/weapon_scp_023.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end


SWEP.PrintName			= "SCP-023"			

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay       	= 30
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo			= "None"
SWEP.Primary.Sound			= "dog.mp3"
SWEP.Sound					= "dog.mp3"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo			= "None"

SWEP.ISSCP 					= true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.teams					= {1}

SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos					= 4
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.ViewModel				= ""
SWEP.WorldModel			= ""
--SWEP.IconLetter				= "w"
SWEP.HoldType 				= "knife"

SWEP.Lang = nil
SWEP.Targets = {}
function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "NCurTarget" )
	self:SetNCurTarget( nil )
end

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_023
		--self.Author		= self.Lang.author
		--self.Contact		= self.Lang.contact
		--self.Contact		= self.Lang.purpose
		--self.Instructions	= self.Lang.instructions
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
SWEP.NextSpec = 0
SWEP.ntabupdate = 0
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
		self.Owner:SetWalkSpeed(150)
		self.Owner:SetRunSpeed(150)
	end
	if self.Speed and self.NextSecondary < CurTime() then
		self.Owner:SetWalkSpeed(150)
		self.Owner:SetRunSpeed(150)
	end
	if postround or preparing then return end
	if self.ntabupdate < CurTime() then
		self.ntabupdate = CurTime() + 1 --delay for performance
		if SERVER then
			net.Start( "689" )
				net.WriteTable( self.Targets )
			net.Send( self.Owner )
		end
	end
	
	if CLIENT then return end
	for k, v in pairs( self.Targets ) do
	    if ( v:GetPos():Distance( v:GetPos()) < 400 ) then
		if !IsValid( v ) or !v:Alive() or v:GTeam() == TEAM_SPEC or v:GTeam() == TEAM_SCP then
			table.RemoveByValue(self.Targets, v)
		end
		end
	end
	for k, v in pairs( player.GetAll() ) do
		if v != self.Owner and !table.HasValue( self.Targets, v ) then
		    if ( v:GetPos():Distance( v:GetPos()) < 400 ) then
			if v:IsPlayer() and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_DZ then
				local treyes = util.TraceLine( {
					start = v:EyePos(),
					endpos = self.Owner:EyePos(),
					mask = MASK_SHOT_HULL,
					filter = { v, self.Owner }
				} )
				local trpos = util.TraceLine( {
					start = v:EyePos(),
					endpos = self.Owner:GetPos(),
					mask = MASK_SHOT_HULL,
					filter = { v, self.Owner }
				} )
				if !treyes.Hit or !trpos.Hit then
					local trnormal = !treyes.Hit and treyes.Normal or !trpos.Hit and trpos.Normal
					local eyenormal = v:EyeAngles():Forward()
					if eyenormal:Dot( trnormal ) > 0.70 then
						table.insert( self.Targets, v )
					end
				end
			end
			end
		end
		
	end
end

SWEP.NextPrimary = 0

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	//if not IsFirstTimePredicted() then return end
	if #self.Targets < 1 then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if SERVER then
		local at = self:GetNCurTarget()
		
		if !table.HasValue( self.Targets, at ) then at = nil print( "689 tried to attack invalid entity!" ) end
		if !IsValid( at ) then
			at = table.Random(self.Targets)
			self:SetNCurTarget( at )
		end
		self.Owner:EmitSound(self.Sound)
		at:EmitSound(self.Sound)
		timer.Create("CheckTimer"..self.Owner:SteamID64(), 0.5, math.floor(self.Primary.Delay), function()
			if !( IsValid( self.Owner ) and self.Owner:Alive() and IsValid( at ) and at:Alive() and at:GTeam() != TEAM_SPEC ) then
				timer.Destroy("CheckTimer")
				timer.Destroy( "KillTimer"..self.Owner:SteamID64() )
			end
		end )
		timer.Create("KillTimer"..self.Owner:SteamID64(), math.floor(self.Primary.Delay / 2), 1, function()
			if IsValid(self.Owner) and self.Owner:Alive() and IsValid(at) and at:Alive() and at:GTeam() != TEAM_SPEC then
				
				at:Kill()
				
				self.Owner:AddExp(125, true)
				table.RemoveByValue(self.Targets, at)
				self:SetNCurTarget( nil )
			end
		end )
		
	end
	
end

SWEP.NextSecondary = 0
SWEP.Speed = false

function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextSecondary > CurTime() then return end
	self.Speed = false
	if self.Owner:Health() < 250 then
		if CLIENT then
			self.Owner:PrintMessage( HUD_PRINTTALK, self.Lang.HUD.lowhealth )
		end
		self.NextSecondary = CurTime() + 1
	else
		self.Owner:SetHealth( self.Owner:Health() - 5 )
		self.NextSecondary = CurTime() + 0.15
		self.Speed = true
		self.Owner:SetWalkSpeed(250)
		self.Owner:SetRunSpeed(250)
	end
end
SWEP.LastReload = 0

function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextPrimary > CurTime() then return end
	if self.LastReload > CurTime() then return end
	self.LastReload = CurTime() + 0.25
	local CurTarget = self:GetNCurTarget()
	if !IsValid( CurTarget ) then
		self:SetNCurTarget( self.Targets[1] )
		return
	end
	for i, v in ipairs( self.Targets ) do
		if v == CurTarget then
			if i == #self.Targets then self:SetNCurTarget( self.Targets[1] ) return end
			self:SetNCurTarget( self.Targets[i + 1] ) 
			return
		end
	end
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	--
end
function isInTable( element, tab )
	for k, v in pairs( tab ) do
		if v == element then return true end
	end
	return false
end

