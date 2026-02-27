--[[
lua/weapons/arx-160/shared.lua
--]]
CustomizableWeaponry:registerAmmo("6.8MM", "6.8MM Rounds", 7.62, 39)
AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/arx16")
	SWEP.BounceWeaponIcon = false
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "ARX-160"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15
	
	--SWEP.IconLetter = "w"
	--killicon.AddFont("cw_ar15", "CW_--killicons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.DrawTraditionalWorldModel = false
	 SWEP.WM = "models/cw2/weapons/w_cam_arx16.mdl"
	 SWEP.WMPos = Vector( 0, 0, 0)
	 SWEP.WMAng = Vector(-4.452, 0, -171.924)


	SWEP.MuzzleEffect = "muzzleflash_6"
	SWEP.PosBasedMuz = false
	SWEP.MuzzlePosMod = {x = -3, y = -2, z = 3}
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = -2, y = 0, z = -3}
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.65
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.9

	SWEP.M203OffsetCycle_Reload = 0.65
	SWEP.M203OffsetCycle_Reload_Empty = 0.73
	SWEP.M203OffsetCycle_Draw = 0
	
	SWEP.IronsightPos = Vector(-2.05, -2.37, 0.365)
	SWEP.IronsightAng = Vector(-0.071, 0.07, 0)
	
	SWEP.FoldSightPos = Vector(-2.208, -4.3, 0.143)
	SWEP.FoldSightAng = Vector(0.605, 0, -0.217)
		
	SWEP.EoTechPos = Vector(8.887, -5.843, 1.218)
	SWEP.EoTechAng = Vector(0, 0, 0)
	
	SWEP.EoTech552Pos = Vector(-2.07, -4.657, 0.214)
	SWEP.EoTech552Ang = Vector(0, -0.2, 0)

	SWEP.AimpointPos = Vector(-2.092, -1.285, 0.416)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.MicroT1Pos = Vector(-2.087, -1.634, 0.444)
	SWEP.MicroT1Ang = Vector(0, 0, 0)
	
	SWEP.CoD4ReflexPos = Vector(-2.024, -2.823, 0.465)

	SWEP.CoD4ReflexAng = Vector(0, 0, 0)	

	SWEP.HoloPos = Vector(-2.07, -2.623, 0.593)
	SWEP.HoloAng = Vector(0, 0, 0)	

	SWEP.ACOGPos = Vector(-2.133, 0, -0.125)
	SWEP.ACOGAng = Vector(0, 0, 0)
	
	SWEP.MagnifierPos = Vector(-1.999, -0.375, 0.305)
	SWEP.MagnifierAng = Vector(0, 0, 0)

	SWEP.CoyotePos = Vector(-2.064, 0, 0.482)
	SWEP.CoyoteAng = Vector(0, 0, 0)

	SWEP.M203Pos = Vector(-0.562, -2.481, 0.24)
	SWEP.M203Ang = Vector(0, 0, 0)
	
	SWEP.AlternativePos = Vector(-0.32, 0, -0.64)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {["md_acog"] = {[1] = Vector(-2.151, -3.112, -1.274), [2] = Vector(0.071, 0.284, 0)}}

	SWEP.ACOGAxisAlign = {right = 0, up = 0, forward = 0}
	SWEP.M203CameraRotation = {p = -90, y = 0, r = -90}
	
	SWEP.BaseArm = "Bip01 L Clavicle"
	SWEP.BaseArmBoneOffset = Vector(-50, 0, 0)
	
	SWEP.AttachmentModelsVM = {
		["md_aimpoint"] = {model = "models/wystan/attachments/aimpoint.mdl", bone = "body", rel = "", pos = Vector(2, 0.916, -0.209), angle = Angle(90, -90, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_cod4_eotech_v2"] = {model = "models/v_cod4_eotech.mdl", bone = "body", rel = "", pos = Vector(-0.871, -0.945, 0), angle = Angle(0, 0, -90), size = Vector(0.799, 0.799, 0.799)},
		["md_cod4_reflex"] = {model = "models/v_cod4_reflex.mdl", bone = "body", rel = "", pos = Vector(1.526, -1.14, 0.05), angle = Angle(0, 0, -90), size = Vector(0.742, 0.742, 0.742)},
		["md_magnifier_scope"] = {model = "models/c_magnifier_scope.mdl", bone = "body", rel = "", pos = Vector(-4.312, -3.188, 0.097), angle = Angle(-180, 0, -90), size = Vector(0.939, 0.939, 0.939)},
		["md_anpeq15"] = {model = "models/cw2/attachments/anpeq15.mdl", bone = "body", rel = "", pos = Vector(-9.65, -3.513, -0.174), angle = Angle(0, 0, -90), size = Vector(0.412, 0.412, 0.412)},
		["md_acog"] = {model = "models/wystan/attachments/2cog.mdl", bone = "body", rel = "", pos = Vector(2.512, 2.282, -0.436), angle = Angle(90, 0, -90), size = Vector(1.026, 1.026, 1.026)},
		["md_saker"] = {model = "models/cw2/attachments/556suppressor.mdl", bone = "Bone_weapon", rel = "", pos = Vector(0.516, 19.378, 2.63), angle = Angle(0, 0, 0), size = Vector(2.176, 2.176, 2.176)},
		["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "body", pos = Vector(-1.58, -3.753, 0.004), angle = Angle(-90, 90, 0), size = Vector(0.361, 0.361, 0.361)}
	}
	
	SWEP.M203HoldPos = {
		["Bip01 L Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.76, 2.651, 1.386), angle = Angle(0, 0, 0) }
	}

	SWEP.ForeGripHoldPos = {
		["Bip01 L Finger3"] = {pos = Vector(0, 0, 0), angle = Angle(0, 42.713, 0) },
		["Bip01 L Clavicle"] = {pos = Vector(-3.299, 1.235, -1.79), angle = Angle(-55.446, 11.843, 0) },
		["Bip01 L Forearm"] = {pos = Vector(0, 0, 0), angle = Angle(0, 0, 42.41) },
		["Bip01 L Finger02"] = {pos = Vector(0, 0, 0), angle = Angle(0, 71.308, 0) },
		["Bip01 L Finger11"] = {pos = Vector(0, 0, 0), angle = Angle(0, 25.795, 0) },
		["Bip01 L Finger4"] = {pos = Vector(0, 0, 0), angle = Angle(0, 26.148, 0) },
		["Bip01 L Finger1"] = {pos = Vector(0, 0, 0), angle = Angle(6.522, 83.597, 0) },
		["Bip01 L Finger0"] = {pos = Vector(0, 0, 0), angle = Angle(23.2, 16.545, 0) },
		["Bip01 L Finger42"] = {pos = Vector(0, 0, 0), angle = Angle(0, 31.427, 0) },
		["Bip01 L Finger32"] = {pos = Vector(0, 0, 0), angle = Angle(0, 29.565, 0) },
		["Bip01 L Hand"] = {pos = Vector(0, 0, 0), angle = Angle(9.491, 14.793, -15.926) },
		["Bip01 L Finger12"] = {pos = Vector(0, 0, 0), angle = Angle(0, -9.195, 0) },
		["Bip01 L Finger21"] = {pos = Vector(0, 0, 0), angle = Angle(0, 10.164, 0) },
		["Bip01 L Finger01"] = {pos = Vector(0, 0, 0), angle = Angle(0, 18.395, 0) },
		["Bip01 L Finger2"] = {pos = Vector(0, 0, 0), angle = Angle(2.411, 57.007, 0) }
	}
	
	SWEP.AttachmentPosDependency = {["md_anpeq15"] = {["bg_longris"] = Vector(-0.225, 13, 3.15)},
	["md_saker"] = {["bg_longbarrel"] = Vector(-0.042, 9, -0.1), ["bg_longris"] = Vector(-0.042, 9, -0.1)}}
	
	SWEP.LaserPosAdjust = Vector(0, 0, 0)
	SWEP.LaserAngAdjust = Angle(0, 180, 0) 
end

SWEP.SightBGs = {main = 1, none = 1}
SWEP.BarrelBGs = {main = 3, longris = 4, long = 3, magpul = 2, ris = 1, regular = 0}
SWEP.StockBGs = {main = 2, regular = 0, heavy = 1, sturdy = 2}
SWEP.MagBGs = {main = 5, regular = 0, round60 = 1}
SWEP.LuaViewmodelRecoil = true

SWEP.Attachments = {[1] = {header = "0ptics", offset = {200, -200}, atts = {"md_microt1", "md_aimpoint"}},
	[2] = {header = "Rail", offset = {-200, 350}, atts = {"md_anpeq15"}},
	[3] = {header = "Magnifire", offset = {1000, 400}, atts = {}},
	[4] = {header = "Perks", offset = {1000, 00}, atts = {"pk_sleightofhand", "pk_light"}},
	["+reload"] = {header = "Ammo", offset = {500, 400}, atts = {"am_magnum", "am_matchgrade"}}}

SWEP.AttachmentDependencies = {
  ["md_magnifier_scope"] = {"md_cod4_reflex", "md_microt1", "md_cod4_eotech_v2", "md_aimpoint"}
}

if CustomizableWeaponry_KK_HK416 then
  table.insert(SWEP.Attachments[1].atts, 2, "md_cod4_reflex")  
  table.insert(SWEP.Attachments[3].atts, 1, "md_magnifier_scope")
  table.insert(SWEP.Attachments[1].atts, 3, "md_cod4_eotech_v2")
end
	
SWEP.Animations = {fire = {"shoot1", "shoot2", "shoot3"},
	reload = "reload",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {draw = {{time = 0, sound = "CW_FOLEY_MEDIUM"}},

	reload = {[1] = {time = 0.35, sound = "CW_ARX_MAGOUT"},
	[2] = {time = 1.3, sound = "CW_ARX_MAGIN"},
	[3] = {time = 1.8, sound = "CW_ARX_BOLTPULL"}}}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "3burst", "semi"}
SWEP.Base = "cw_base"
--SWEP.Category = "Cameron's CW 2.0 SWEPS"

----SWEP.Author			= "Spy"
----SWEP.Contact		= ""
--SWEP.Purpose		= ""
----SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cw2/weapons/v_cam_arx16.mdl"
SWEP.WorldModel		= "models/cw2/weapons/w_cam_arx16.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Automatic		= true

SWEP.FireDelay = 0.0700116686114352
SWEP.FireSound = "CW_ARX_FIRE"
SWEP.FireSoundSuppressed = "CW_AR15_FIRE_SUPPRESSED"
SWEP.Recoil = 0.65

SWEP.HipSpread = 0.08
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 24
SWEP.DeployTime = 0.6

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 2.3
SWEP.ReloadTime_Empty = 1.65
SWEP.ReloadHalt = 1.9
SWEP.ReloadHalt_Empty = 3.1
SWEP.SnapToIdlePostReload = true

SWEP.CustomizationMenuScale = 0.009

