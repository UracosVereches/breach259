--[[
lua/weapons/nightvision.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/nightglasses")
	SWEP.BounceWeaponIcon = false
end


SWEP.Base = "weapon_base"
SWEP.PrintName = "Очки ночноговидения"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.HoldType = "normal"
SWEP.ViewModel		= "models/props_junk/cardboard_box004a.mdl"
SWEP.WorldModel		= "models/props_junk/cardboard_box004a.mdl"
SWEP.DrawCrosshair = false

SWEP.HitDistance = 50

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize		= 5
SWEP.Secondary.DefaultClip	= 5
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay = 5

SWEP.Nightvision = false
SWEP.NextReload = CurTime()

SWEP.Slot				= 0
SWEP.SlotPos			= 0
--Link2006's fix for Nightvision;
SWEP.droppable				= true
SWEP.teams					= {2,3,4,6}

if ( SERVER ) then
	util.AddNetworkString( "RASKO_NightvisionOn" )
	util.AddNetworkString( "RASKO_NightvisionOff" )
	util.AddNetworkString( "Link2006_NightVisionTuto" )
end

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD) 

	if ( SERVER ) then
		self.NvOwner = self:GetOwner() --Just in case ;)
	end

	self:SetHoldType("normal")
end


function SWEP:PrimaryAttack()

	if ( SERVER ) then
	end
end


function SWEP:SecondaryAttack()

	if ( SERVER ) then
	end
end


function SWEP:Reload()

	if ( SERVER ) then
		if self.NextReload > CurTime() then return end

		self.NextReload = CurTime() + 2
		local ply = self:GetOwner()
		if self.Nightvision == false then
			self.Nightvision = true
			net.Start( "RASKO_NightvisionOn" )
			net.WriteEntity( ply )
			net.Send( ply )
		elseif self.Nightvision == true then
			self.Nightvision = false
			net.Start( "RASKO_NightvisionOff" )
			net.WriteEntity( ply )
			net.Send( ply )
		end
	end

end

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
	if ( SERVER ) then
		self.NvOwner = self:GetOwner()
	end
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

--[[
function SWEP:Holster()

	if ( SERVER ) then
		local ply = self:GetOwner()
		self.Nightvision = false
		net.Start( "RASKO_NightvisionOff" )
		net.WriteEntity( ply )
		net.Send( ply )
		return true
	end

end
]]--

--Link2006's Fix for NV Not turning off when dropped
function SWEP:OnDrop()
	if SERVER then
		self.Nightvision = false
		net.Start( "RASKO_NightvisionOff" )
		net.WriteEntity( self.Owner )
		net.Send( self.Owner )
		return true
	end
end

--Same here when they die, delete themselves. ...?
function SWEP:OnRemove()
	if SERVER then
		if self.Owner then
			self.Nightvision = false
			net.Start( "RASKO_NightvisionOff" )
			net.WriteEntity( self.Owner )
			net.Send( self.Owner )
			return true
		elseif self.NvOwner then
			self.Nightvision = false
			net.Start( "RASKO_NightvisionOff" )
			net.WriteEntity( self.NvOwner )
			net.Send( self.NvOwner )
			return true
		else
			--Last resort :(
			self.Nightvision = false
			net.Start( "RASKO_NightvisionOff" )
			net.WriteEntity( self:GetOwner() )
			net.Send( self:GetOwner() )
			return true
		end
	end
end


--When someone gets this 'weapon'
function SWEP:Equip(ply)
	net.Start( "Link2006_NightVisionTuto" )
	self.Owner:DrawViewModel( false )
	net.Send( ply ) --Owner
end
if( CLIENT ) then

	net.Receive( "RASKO_NightvisionOn", function ( len, ply )
		--SetNoDraw on 966 to false ;)
		for k,v in pairs(player.GetAll()) do
			if v:GetNClass() == ROLES.ROLE_SCP966 then
				v:SetNoDraw(false)
			end
		end
		local ply = net.ReadEntity()
		ply.CanSee966 = true
		am_nightvision = DynamicLight( 0 )
		if ( am_nightvision ) then
			am_nightvision.Pos = ply:GetPos()
			am_nightvision.r = 11
			am_nightvision.g = 50
			am_nightvision.b = 4
			am_nightvision.Brightness = 1
			am_nightvision.Size = 2000
			am_nightvision.DieTime = CurTime()+100000
			am_nightvision.Style = 1
		end
		timer.Create( "RASKO_LightTimer", 0.05, 0, function()
			am_nightvision.Pos = ply:GetPos()
		end)
	end)

	net.Receive( "RASKO_NightvisionOff", function ( len, ply )
		for k,v in pairs(player.GetAll()) do
			if v:GetNClass() == ROLES.ROLE_SCP966 then
				v:SetNoDraw(true)
			end
		end
		--SetNoDraw on 966 to true
		local ply = net.ReadEntity()
		ply.CanSee966 = false
		timer.Destroy( "RASKO_LightTimer" )
		if am_nightvision then
			am_nightvision.DieTime = CurTime()+0.1
		end
	end)
	--Link2006's ChatPrint Thing.
	net.Receive( "Link2006_NightVisionTuto", function ()
		timer.Simple(0.25, function()
			local NvKey = input.LookupBinding('+reload') --Get key for reload
			if type(NvKey) == 'no value' then NvKey = 'NOT BOUND' end -- The key is not bound!
			chat.AddText(Color(255,255,255),'Вы получили ',Color(0,255,0),'Очки ночноговидения',Color(255,255,255),'! Выберите их и нажмите "'..NvKey..'", чтобы включить!')
		end)
	end)
end


