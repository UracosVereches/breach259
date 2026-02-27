--[[
lua/weapons/weapon_ai_scanner.lua
--]]
AddCSLuaFile()



if CLIENT then

	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/motion_tracker")

	SWEP.BounceWeaponIcon = false

end



SWEP.PrintName				= "Детектор Движения"

--SWEP.Category 				= 'Alien: Isolation'



----SWEP.Author					= "Wheatley"

--SWEP.Purpose				= ""



SWEP.Spawnable				= true

SWEP.UseHands				= true

SWEP.DrawAmmo				= false



SWEP.ViewModel				= "models/weapons/c_motion_tracker.mdl"

SWEP.WorldModel				= "models/weapons/w_motion_tracker.mdl"



SWEP.ViewModelFOV			= 75

SWEP.Slot					= 0

SWEP.SlotPos				= 5



SWEP.Primary.ClipSize		= -1

SWEP.Primary.DefaultClip	= -1

SWEP.Primary.Automatic		= true

SWEP.Primary.Ammo			= "none"



SWEP.Secondary.ClipSize		= -1

SWEP.Secondary.DefaultClip	= -1

SWEP.Secondary.Automatic	= false

SWEP.Secondary.Ammo			= "none"



if SERVER then

	resource.AddSingleFile( 'models/weapons/c_motion_tracker.mdl' )

	resource.AddSingleFile( 'models/weapons/w_motion_tracker.mdl' )

end



function SWEP:Initialize()

end



function SWEP:PrimaryAttack()

end



function SWEP:SecondaryAttack()

end



function SWEP:Deploy()

	--self:EmitSound( 'weapons/motiontracker_turnon01.wav' )

	return true

end



function SWEP:Holster()

	--self:EmitSound( 'weapons/motiontracker_turnoff01.wav' )

	return true

end

