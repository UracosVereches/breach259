--[[
lua/weapons/clawa36/shared.lua
--]]
AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/claw")
	SWEP.BounceWeaponIcon = false
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "CLAW A36"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15
	
	--SWEP.IconLetter = "w"
	--killicon.AddFont("cw_ar15", "CW_--killicons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "muzzleflash_6"
	SWEP.PosBasedMuz = true
	SWEP.MuzzlePosMod = {x = 0, y = -1, z = 0}
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = -2, y = 0, z = -3}
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.65
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.9
	
	SWEP.DrawTraditionalWorldModel = false
	 SWEP.WM = "models/cw2/weapons/w_cam_clawa.mdl"
	 SWEP.WMPos = Vector( 0, 0, 0)
	 SWEP.WMAng = Vector(-4.452, 0, -171.924)


	SWEP.M203OffsetCycle_Reload = 0.65
	SWEP.M203OffsetCycle_Reload_Empty = 0.73
	SWEP.M203OffsetCycle_Draw = 0
	
	SWEP.IronsightPos =Vector(-5.132, -2.256, 1.626)
	SWEP.IronsightAng = Vector(0, 0, 0)
	
	SWEP.FoldSightPos = Vector(-2.208, -4.3, 0.143)
	SWEP.FoldSightAng = Vector(0.605, 0, -0.217)
		
	SWEP.EoTechPos = Vector(-5.151, -5.16, 1.05)
	SWEP.EoTechAng = Vector(0, 0, 0)
	
	SWEP.AimpointPos = Vector(-5.161, -5.194, 1.162)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.MicroT1Pos = Vector(-5.146, -5.049, 1.192)
	SWEP.MicroT1Ang = Vector(0, 0, 0)

	SWEP.CoD4ReflexPos = Vector(-5.141, -4.654, 1.261)
	SWEP.CoD4ReflexAng = Vector(0, 0, 0)

	SWEP.ACOGPos = Vector(-5.112, -5.198, 1.105)
	SWEP.ACOGAng = Vector(0, 0, 0)

	SWEP.CoyotePos = Vector(-5.156, -5.349, 1.141)
	SWEP.CoyoteAng = Vector(0, 0, 0)

	SWEP.M203Pos = Vector(-0.562, -2.481, 0.24)
	SWEP.M203Ang = Vector(0, 0, 0)
	
	SWEP.AlternativePos = Vector(-0.32, 0, -0.64)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {["md_acog"] = {[1] = Vector(-5.121, -5.198, 0.092), [2] = Vector(0, 0, 0)}}

	SWEP.ACOGAxisAlign = {right = 0, up = 0, forward = 0}
	SWEP.M203CameraRotation = {p = -90, y = 0, r = -90}
	
	SWEP.BaseArm = "Bip01 L Clavicle"
	SWEP.BaseArmBoneOffset = Vector(-50, 0, 0)
	
	SWEP.AttachmentModelsVM = {
		["md_aimpoint"] = {model = "models/wystan/attachments/aimpoint.mdl", bone = "Main_Gun", rel = "", pos = Vector(0.119, 9.753, -3.102), angle = Angle(0, 180, 0), size = Vector(1.049, 1.049, 1.049)},
		["md_eotech"] = {model = "models/wystan/attachments/2otech557sight.mdl", bone = "Main_Gun", rel = "", pos = Vector(-0.431, 15.755, -9.509), angle = Angle(0, 90, 0), size = Vector(1.149, 1.149, 1.149)},
		["md_cyotesight"] = {model = "models/rageattachments/cyotesight.mdl", bone = "Main_Gun", rel = "", pos = Vector(-0.11, 1.756, 2.19), angle = Angle(0, 90, 0), size = Vector(1.149, 1.149, 1.149)},            
		["md_cod4_reflex"] = {model = "models/v_cod4_reflex.mdl", bone = "Main_Gun", rel = "", pos = Vector(-0.128, 8.175, -0.489), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},
		["md_acog"] = {model = "models/wystan/attachments/2cog.mdl", bone = "Main_Gun", rel = "", pos = Vector(0.18, 8.31, -2.336), angle = Angle(0, 180, 0), size = Vector(0.899, 0.899, 0.899)},
		["md_saker"] = {model = "models/cw2/attachments/556suppressor.mdl", bone = "Bone_weapon", rel = "", pos = Vector(0.516, 19.378, 2.63), angle = Angle(0, 0, 0), size = Vector(2.176, 2.176, 2.176)},
		["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "Main_Gun", rel = "", pos = Vector(-0.129, 3.599, 3.013), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5)},
		["md_m203"] = {model = "models/cw2/attachments/m203.mdl", bone = "smdimport001", pos = Vector(2.299, -6.611, 4.138), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), animated = true}
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
	
	SWEP.LaserPosAdjust = Vector(1, 0, 0)
	SWEP.LaserAngAdjust = Angle(2, 180, 0) 
end

SWEP.SightBGs = {main = 2, none = 1}
SWEP.BarrelBGs = {main = 3, longris = 4, long = 3, magpul = 2, ris = 1, regular = 0}
SWEP.StockBGs = {main = 2, regular = 0, heavy = 1, sturdy = 2}
SWEP.MagBGs = {main = 5, regular = 0, round60 = 1}
SWEP.LuaViewmodelRecoil = true

SWEP.Attachments = {[1] = {header = "0ptics", offset = {200, -200}, atts = {"md_microt1", "md_aimpoint", "md_acog", "md_cyotesight", "md_eotech"}},
	[2] = {header = "Perks", offset = {1000, 00}, atts = {"pk_sleightofhand", "pk_light"}},
	["+reload"] = {header = "Ammo", offset = {500, 400}, atts = {"am_magnum", "am_matchgrade"}}}
	
if CustomizableWeaponry_KK_HK416 then
  table.insert(SWEP.Attachments[1].atts, 2, "md_cod4_reflex")  
end

SWEP.Animations = {fire = {"shoot1", "shoot2", "shoot3"},
	reload = "reload",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {draw = {{time = 0, sound = "CW_FOLEY_MEDIUM"},
	[2] = {time = 0.3, sound = "CW_CLAW_BOLTPULL"},
	[3] = {time = 0.6, sound = "CW_CLAW_BOLTIN"}},

	reload = {[1] = {time = 0.35, sound = "CW_CLAW_MAGOUT"},
	[2] = {time = 1.3, sound = "CW_CLAW_MAGIN"},
	[3] = {time = 2.3, sound = "CW_CLAW_TAP"},
	[4] = {time = 3, sound = "CW_CLAW_BOLTPULL"},
	[5] = {time = 3.5, sound = "CW_CLAW_BOLTIN"}}}

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
SWEP.ViewModel		= "models/cw2/weapons/v_cam_clawa.mdl"
SWEP.WorldModel		= "models/cw2/weapons/w_cam_clawa.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 31
SWEP.Primary.DefaultClip	= 620
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Automatic		= true

SWEP.FireDelay = 0.066666666666667
SWEP.FireSound = "CW_CLAW_FIRE"
SWEP.FireSoundSuppressed = "CW_AR15_FIRE_SUPPRESSED"
SWEP.Recoil = 0.7

SWEP.HipSpread = 0.08
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 25
SWEP.DeployTime = 0.6

SWEP.ReloadSpeed = 1.5
SWEP.ReloadTime = 2.9
SWEP.ReloadTime_Empty = 3.7
SWEP.ReloadHalt = 3.1
SWEP.ReloadHalt_Empty = 3.9
SWEP.SnapToIdlePostReload = true
SWEP.Chamberable = true

SWEP.CustomizationMenuScale = 0.02

