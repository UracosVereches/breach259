--[[
gamemodes/breach/entities/weapons/flashlight.lua
--]]
AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Фонарь"
--SWEP.Instructions = "Enables your flashlight"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Link2006"

SWEP.HoldType = "normal"
SWEP.ViewModel = "" --No view model; We won't see it.
SWEP.WorldModel = "models/weapons/w_flashlight_zm.mdl" --WorldModel so players can still see a model in the pointshop :)
SWEP.DrawCrosshair = false

--------------------UNUSED?--------------------
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
-----------------------------------------------

--Semi-Unused
SWEP.Slot				= 0
SWEP.SlotPos			= 0
--Link2006's Temporary fix for Nightvision/flashlight; never share (you cant anyway lol)
SWEP.droppable = false

function SWEP:Equip(ply)
	--Send Tutorial
	net.Start( "Link2006_FlashLightTuto" )
	net.Send( ply )
	--Sent, Let's give them stuff.
	ply:AllowFlashlight(true) --Set them to allow using F/flashlight...
	ply:StripWeapon(self:GetClass()) --Remove itself from user's inventory. :)
	--We're done.
end

if (SERVER) then
	util.AddNetworkString( "Link2006_FlashLightTuto" )
end

if (CLIENT) then
	net.Receive( "Link2006_FlashLightTuto", function ()
		timer.Simple(0.25, function()
			local FlKey = input.LookupBinding('impulse 100')
			if type(FlKey) == 'no value' then FlKey = 'NOT BOUND' end -- The key is not bound!
			chat.AddText(Color(255,255,255),'Вы получили ',Color(0,255,0),'фонарь',Color(255,255,255),'! Нажмите "'..FlKey..'" для включения!')
		end)
	end)
end

