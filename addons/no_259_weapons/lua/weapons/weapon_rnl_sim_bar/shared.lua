--[[
lua/weapons/weapon_rnl_sim_bar/shared.lua
--]]
local WeightMod	= CreateClientConVar("sim_weightmod_t", 1, true, false)		// Enable/Disable
local Walkspeed = CreateConVar ("sim_walk_speed", "250", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local Runspeed = CreateConVar ("sim_run_speed", "500", {FCVAR_REPLICATED, FCVAR_ARCHIVE})

SWEP.ViewModelFOV      = 65
SWEP.Base				= "weapon_rnl_sim_base"
SWEP.ViewModelFlip		= false
SWEP.HoldType				= "ar2"
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/c_bar.mdl"
SWEP.WorldModel			= "models/weapons/d_bar.mdl"

SWEP.Primary.Sound			= Sound( "Weapor_Bar.Shoot" )
SWEP.Primary.Recoil			= 2.2
SWEP.Primary.Damage			= 47
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.10909090909090909090909090909091
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "thirtyoddsix"

SWEP.ShellEffect			= "sim_shelleject_rnl_3006"

SWEP.ShellDelay			= 0.03
SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.IronSightsPos = Vector (-3.5714, -2.0029, 1.3301)
SWEP.IronSightsAng = Vector (0.1673, 0.0164, 0)
SWEP.RunArmOffset  = Vector (4.0928, 0.4246, 2.3712)
SWEP.RunArmAngle   = Vector (-18.4406, 33.1846, 0)


// Burst options
SWEP.Burst				= true
SWEP.BurstShots			= 1
SWEP.BurstDelay			= 0
SWEP.BurstCounter			= 0
SWEP.BurstTimer			= 0.17142857142857142857142857142857

// Custom mode options (Do not put a burst mode and a custom mode at the same time, it will not work)
SWEP.Type				= 3					// 1 = Automatic/Semi-Automatic mode, 2 = Suppressor mode, 3 = Burst fire mode
SWEP.Mode				= true

SWEP.data 				= {}
SWEP.data.NormalMsg		= "Switched to fast-auto."
SWEP.data.ModeMsg			= "Switched to slow-auto."
SWEP.data.Delay			= 1				// You need to wait 0.5 second after you change the fire mode

SWEP.Speed = 0.6 
SWEP.Mass = 0.75 
SWEP.WeaponName = "weapon_rnl_sim_bar"
SWEP.WeaponEntName = "weapon_rnl_sim_ent_bar"

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    util.PrecacheSound("weapons_rnl/bar/bar_boltback.wav")
	util.PrecacheSound("weapons_rnl/bar/bar_boltforward.wav")
	util.PrecacheSound("weapons_rnl/bar/bar_clipout.wav")
	util.PrecacheSound("weapons_rnl/bar/bar_clipin.wav")
	util.PrecacheSound("weapons_rnl/bar/bar_fire.wav")
	util.PrecacheSound("weapons_rnl/bar/bar_fire3.wav")
	util.PrecacheSound("weapons_rnl/bar/bar_fire2.wav")	
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if (not self.Owner:IsNPC() and not self.Owner:KeyDown(IN_SPEED) and self.Owner:KeyDown(IN_USE)) then
		
		if (SERVER) then
			bHolsted = !self.Weapon:GetDTBool(0)
			self:SetHolsted(bHolsted)
		end

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end
	
	if (not self:CanPrimaryAttack()) then return end
	
	self.Reloadaftershoot = CurTime() + self.Primary.Delay
	self.ActionDelay = (CurTime() + self.Primary.Delay + 0.05)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	// If the burst mode is activated, it's going to shoot the three bullets (or more if you're dumb and put 4 or 5 bullets for your burst mode)
	if self.Weapon:GetDTBool(3) and self.Type == 3 then
		self.BurstTimer 	= CurTime()
		self.BurstCounter = self.BurstShots - 1
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.17142857142857142857142857142857)
	end

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo(1)

	self:ShootBulletInformation()
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
function SWEP:ShootAnimation()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
end

/*---------------------------------------------------------
   Name: SWEP:SetHolsted()
---------------------------------------------------------*/
function SWEP:SetHolsted(b)

	if (self.Owner) then
		if (b) then
			self.Weapon:SendWeaponAnim(ACT_VM_LOWERED_TO_IDLE)
		else
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE_LOWERED)
		end
	end

	if (self.Weapon) then
		self.Weapon:SetDTBool(0, b)
	end
end
/*---------------------------------------------------------
   Name: SWEP:SetIronsights()
---------------------------------------------------------*/
function SWEP:SetIronsights(b)

	if (self.Owner) then
		if (b) then
			if (SERVER) then
				self.Owner:SetFOV(65, 0.2)
			end
	
			if self.AllowIdleAnimation then
				
				self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
				self.Owner:GetViewModel():SetPlaybackRate(0)
			end
			if WeightMod:GetBool() then
				self.Weapon:EmitSound("Universar.IronIn")
				self.Owner:SetRunSpeed(Walkspeed:GetFloat()*self.Speed*self.Mass)
				self.Owner:SetWalkSpeed(Walkspeed:GetFloat()*self.Speed*self.Mass)
			else
				self.Weapon:EmitSound("Universar.IronIn")
			end
		else
			if (SERVER) then
				self.Owner:SetFOV(0, 0.2)
			end

			if self.AllowPlaybackRate and self.AllowIdleAnimation then
				self.Owner:GetViewModel():SetPlaybackRate(1)
			end	
			if WeightMod:GetBool() and not self.Weapon:GetDTBool(0) then
				self.Owner:SetRunSpeed(Runspeed:GetFloat()*self.Mass)
				self.Owner:SetWalkSpeed(Walkspeed:GetFloat()*self.Mass)
				self.Weapon:EmitSound("Universar.IronOut")
			else
				self.Weapon:EmitSound("Universar.IronOut")
			end
		end
	end

	if (self.Weapon) then
		self.Weapon:SetDTBool(1, b)
	end
end
/*---------------------------------------------------------
   Name: SWEP:ReloadAnimation()
---------------------------------------------------------*/
function SWEP:ReloadAnimation()
	
	if (self.Weapon:Clip1() == 0) then
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	else
		self.Weapon:DefaultReload(ACT_VM_HITCENTER)
		timer.Simple(self.Owner:GetViewModel():SequenceDuration() + 0.01, function()
			if (not IsValid(self.Owner) or not IsValid(self.Weapon) or not self.Owner:Alive())then return end
			self:SetClip1( self.Primary.ClipSize + 1 )
			self.Owner:RemoveAmmo( 1, self:GetPrimaryAmmoType() )
		end)
	end
end
/*---------------------------------------------------------
   Name: SWEP:DeployAnimation()
---------------------------------------------------------*/
function SWEP:DeployAnimation()

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE_LOWERED)

end


