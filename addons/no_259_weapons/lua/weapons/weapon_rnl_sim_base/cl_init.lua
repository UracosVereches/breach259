--[[
lua/weapons/weapon_rnl_sim_base/cl_init.lua
--]]
include('shared.lua')

SWEP.PrintName			= "Siminov's Weapon Base"			// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 0							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot
SWEP.DrawAmmo			= true						// Should draw the default HL2 ammo counter?
SWEP.DrawCrosshair		= false 						// Should draw the default crosshair?
SWEP.DrawWeaponInfoBox		= true						// Should draw the weapon info box?
SWEP.BounceWeaponIcon   	= false						// Should the weapon icon bounce?
SWEP.SwayScale			= 1.0							// The scale of the viewmodel sway
SWEP.BobScale			= 1.0							// The scale of the viewmodel bob

SWEP.RenderGroup 			= RENDERGROUP_OPAQUE

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("materials/weapons/swep.vmt","GAME")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/swep")
end

// This is the corner of the speech bubble
if (file.Exists("materials/gui/speech_lid.vmt","GAME")) then
	SWEP.SpeechBubbleLid	= surface.GetTextureID("gui/speech_lid")
end
						
language.Add("thirtyoddsix_ammo", ".30-06 Ammo")
language.Add("fourtyfiveacp_ammo", ".45Acp Ammo")
language.Add("thirtycarbine_ammo", ".30 Carbine Ammo")					
language.Add("usgrenade_ammo", "MK2 Pineapple Grenade")					
language.Add("ussmoke_ammo", "M18 Smoke Grenade")											
language.Add("eightmmgerman_ammo", "7.92mm Mauser Ammo")							
language.Add("ninemmgerman_ammo", "9mm Ammo")
language.Add("germanstick_ammo", "Model 24 Stielhandgranate")					
language.Add("germansmoke_ammo", "Model 39 Nebeltopf")

local Color_Icon = Color( 255, 80, 0, 255 ) 
--killicon.Add("weapon_rnl_sim_bar","--killicons/sim_rnl_bar_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_carbine","--killicons/sim_rnl_carbine_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_colt1911","--killicons/sim_rnl_colt1911_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_g43","--killicons/sim_rnl_g43_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_garand","--killicons/sim_rnl_garand_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_garandb","--killicons/sim_rnl_garandb_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_k98","--killicons/sim_rnl_k98_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_k98b","--killicons/sim_rnl_k98b_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_k98s","--killicons/sim_rnl_k98s_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_mp40","--killicons/sim_rnl_mp40_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_p38","--killicons/sim_rnl_p38_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_thompson","--killicons/sim_rnl_thompson_--killicon",Color_Icon)
--killicon.Add("weapon_rnl_sim_ger_frag","HUD/--killicons/default",Color_Icon)
--killicon.Add("weapon_rnl_sim_ger_smoke","HUD/--killicons/default",Color_Icon)
--killicon.Add("weapon_rnl_sim_us_frag","HUD/--killicons/default",Color_Icon)
--killicon.Add("weapon_rnl_sim_us_smoke","HUD/--killicons/default",Color_Icon)
--killicon.Add("env_explosion","HUD/--killicons/default",Color_Icon)
/*---------------------------------------------------------
   Name: SWEP:SecondDrawHUD()
---------------------------------------------------------*/
function SWEP:SecondDrawHUD()
end

/*---------------------------------------------------------
   Name: SWEP:DrawHUD()
   Desc: You can draw to the HUD here. It will only draw when
	   the client has the weapon deployed.
---------------------------------------------------------*/
cl_crosshair_r 		= CreateClientConVar("sim_crosshair_r", 255, true, false)		// Red
cl_crosshair_g 		= CreateClientConVar("sim_crosshair_g", 255, true, false)		// Green
cl_crosshair_b 		= CreateClientConVar("sim_crosshair_b", 255, true, false)		// Blue
cl_crosshair_a 		= CreateClientConVar("sim_crosshair_a", 200, true, false)		// Alpha
cl_crosshair_l 		= CreateClientConVar("sim_crosshair_l", 30, true, false)		// Lenght
cl_crosshair_t 		= CreateClientConVar("sim_crosshair_t", 1, true, false)		// Enable/Disable
local AccuracyMul = CreateConVar ("sim_accuracymul", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})

function SWEP:DrawHUD()

	self:SecondDrawHUD()
	self:DrawFuelHUD()

	if (self.Weapon:GetDTBool(1) or self.Weapon:GetDTBool(0)) or (cl_crosshair_t:GetBool() == false) or (LocalPlayer():InVehicle()) then return end

	local hitpos = util.TraceLine ({
		start = LocalPlayer():GetShootPos(),
		endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 4096,
		filter = LocalPlayer(),
		mask = MASK_SHOT
	}).HitPos

	local screenpos = hitpos:ToScreen()
	
	local x = screenpos.x
	local y = screenpos.y
	
	if self.Primary.Cone < 0.005 then
		self.Primary.Cone = 0.005
	end
	
	local gap = ((self.Primary.Cone * 275 * AccuracyMul:GetFloat()) + (((self.Primary.Cone * 275 * AccuracyMul:GetFloat()) * (ScrH() / 720))) * (1 / self:CrosshairAccuracy())) * 0.75

	gap = math.Clamp(gap, 0, (ScrH() / 2) - 100)
	local length = cl_crosshair_l:GetInt()

	self:DrawCrosshairHUD(x - gap - length, y - 1, length, 3) 	// Left
	self:DrawCrosshairHUD(x + gap + 1, y - 1, length, 3) 		// Right
 	self:DrawCrosshairHUD(x - 1, y - gap - length, 3, length) 	// Top 
 	self:DrawCrosshairHUD(x - 1, y + gap + 1, 3, length) 		// Bottom
end

/*---------------------------------------------------------
   Name: SWEP:DrawCrosshairHUD()
---------------------------------------------------------*/
function SWEP:DrawCrosshairHUD(x, y, width, height)
end
/*---------------------------------------------------------
   Name: SWEP:DrawFuelHUD()
---------------------------------------------------------*/
// Based on the Condition SWEPs HUD made by SB Spy

function SWEP:DrawFuelHUD()

end


/*---------------------------------------------------------
   Name: SWEP:DrawWeaponSelection()
   Desc: Checks the objects before any action is taken.
	   This is to make sure that the entities haven't been removed.
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	
	// Set us up the texture
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetTexture(self.WepSelectIcon)
	
	// Lets get a sin wave to make it bounce
	local fsin = 0
	
	if (self.BounceWeaponIcon == true) then
		fsin = math.sin(CurTime() * 10) * 5
	end
	
	// Borders
	y = y + 10
	x = x + 10
	wide = wide - 20
	
	// Draw that mother
	surface.DrawTexturedRect(x + (fsin), y - (fsin), wide - fsin * 2, (wide / 2) + (fsin))
	
	// Draw weapon info box
	self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
end

/*---------------------------------------------------------
   Name: SWEP:PrintWeaponInfo()
   Desc: Draws the weapon info box.
---------------------------------------------------------*/
function SWEP:PrintWeaponInfo(x, y, alpha)

	if (self.DrawWeaponInfoBox == false) then return end

	if (self.InfoMarkup == nil) then
		local str
		local title_color = "<color = 130, 0, 0, 255>"
		local text_color = "<color = 255, 255, 255, 200>"
		
		str = "<font=HudSelectionText>"
		if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse(str, 250)
	end

	alpha = 180
	
	surface.SetDrawColor(0, 0, 0, alpha)
	surface.SetTexture(self.SpeechBubbleLid)
	
	surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
	draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))
	
	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end

/*---------------------------------------------------------
   Name: SWEP:GetViewModelPosition()
   Desc: Allows you to re-position the view model.
---------------------------------------------------------*/
local IRONSIGHT_TIME = 0.2

function SWEP:GetViewModelPosition(pos, ang)

	local bIron = self.Weapon:GetDTBool(1)	
	
	local DashDelta = 0
	if (self.Owner:KeyDown(IN_SPEED)) and (self.Owner:GetVelocity():Length() > self.Owner:GetWalkSpeed()) then
		if (!self.DashStartTime) then
			self.DashStartTime = CurTime()
		end
		
		DashDelta = math.Clamp(((CurTime() - self.DashStartTime) / 0.1) ^ 1.2, 0, 1)
	else
		if (self.DashStartTime) then
			self.DashEndTime = CurTime()
		end
	
		if (self.DashEndTime) then
			DashDelta = math.Clamp(((CurTime() - self.DashEndTime) / 0.1) ^ 1.2, 0, 1)
			DashDelta = 1 - DashDelta
			if (DashDelta == 0) then self.DashEndTime = nil end
		end
	
		self.DashStartTime = nil
	end
	
	if (DashDelta) then
		local Down = ang:Up() * -1
		local Right = ang:Right()
		local Forward = ang:Forward()
	
		local bUseVector = false
		
		if(!self.RunArmAngle.pitch) then
			bUseVector = true
		end
		
		if (bUseVector == true) then
			ang:RotateAroundAxis(ang:Right(), self.RunArmAngle.x * DashDelta)
			ang:RotateAroundAxis(ang:Up(), self.RunArmAngle.y * DashDelta)
			ang:RotateAroundAxis(ang:Forward(), self.RunArmAngle.z * DashDelta)
			
			pos = pos + self.RunArmOffset.x * ang:Right() * DashDelta 
			pos = pos + self.RunArmOffset.y * ang:Forward() * DashDelta 
			pos = pos + self.RunArmOffset.z * ang:Up() * DashDelta 
		else
			ang:RotateAroundAxis(Right, elf.RunArmAngle.pitch * DashDelta)
			ang:RotateAroundAxis(Down, self.RunArmAngle.yaw * DashDelta)
			ang:RotateAroundAxis(Forward, self.RunArmAngle.roll * DashDelta)

			pos = pos + (Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z) * DashDelta			
		end
		
		if (self.DashEndTime) then
			return pos, ang
		end
	end

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if (bIron) then 
			self.SwayScale 	= 0.1
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if (!bIron && fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return pos, ang
	end
	
	local Mul = 1.0
	
	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if (!bIron) then Mul = 1 - Mul end
	end

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 	self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 	self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	pos = pos + self.IronSightsPos.x * Right * Mul
	pos = pos + self.IronSightsPos.y * Forward * Mul
	pos = pos + self.IronSightsPos.z * Up * Mul
	
	return pos, ang
end

/*---------------------------------------------------------
   Name: SWEP:AdjustMouseSensitivity()
   Desc: Allows you to adjust the mouse sensitivity.
---------------------------------------------------------*/
function SWEP:AdjustMouseSensitivity()

	return nil
end

/*---------------------------------------------------------
   Name: SWEP:GetTracerOrigin()
   Desc: Allows you to override where the tracer comes from (in first person view)
	   returning anything but a vector indicates that you want the default action.
---------------------------------------------------------*/
function SWEP:GetTracerOrigin()

	if (self.Weapon:GetDTBool(1)) then
		local pos = self:GetOwner():EyePos() + self:GetOwner():EyeAngles():Up() * -4
		return pos
	end
end


