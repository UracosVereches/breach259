--[[
lua/weapons/weapon_rnl_sim_bar/cl_init.lua
--]]
include('shared.lua')


SWEP.PrintName			= "B.A.R. M1918A2"			
----SWEP.Author				= "Siminov"					// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 3							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot
----SWEP.Instructions			= "Uses .30-06 Ammo, Alternate Mode: E + Right Click, Switch Weapons: E + Left Click"

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("materials/weapons/weapon_rnl_sim_bar.vmt","GAME")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_rnl_sim_bar")
end

