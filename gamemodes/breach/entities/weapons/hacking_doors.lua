--[[
lua/weapons/hacking_doors.lua
--]]
if SERVER then
	util.AddNetworkString("lockpick_time")
end

if CLIENT then
	SWEP.PrintName = "Gartic Phone"
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/hack")
	SWEP.BounceWeaponIcon = false
end

SWEP.droppable = false
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel						= Model( "models/jessev92/weapons/buddyfinder_c.mdl" )
SWEP.WorldModel						= Model( "models/jessev92/weapons/buddyfinder_w.mdl" )

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true
--SWEP.Category = "More Lockpicks"

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1     
SWEP.Primary.DefaultClip = 0    
SWEP.Primary.Automatic = false    
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        
SWEP.Secondary.DefaultClip = -1   
SWEP.Secondary.Automatic = false       
SWEP.Secondary.Ammo = ""
SWEP.LockPickTime = 60

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

if CLIENT then
	net.Receive("lockpick_time", function()
		local wep = net.ReadEntity()
		local time = net.ReadUInt(5)

		wep.IsLockPicking = true
		wep.StartPick = CurTime()
		wep.LockPickTime = time
		wep.EndPick = CurTime() + time
	end)
end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	if self.IsLockPicking then return end

	local trace = self.Owner:GetEyeTrace()
	local e = trace.Entity
	if not IsValid(e) or trace.HitPos:Distance(self.Owner:GetShootPos()) > 60 or
		(e:GetClass() != "prop_dynamic" ) then
		return
	end

	--if not GAMEMODE.Config.canforcedooropen and e:getKeysNonOwnable() then
	--	return
	--end

	if SERVER then
		self.IsLockPicking = true
		self.StartPick = CurTime()
		self.LockPickTime = math.Rand(30, 45)
		net.Start("lockpick_time")
			net.WriteEntity(self)
			net.WriteUInt(self.LockPickTime, 5)
		net.Send(self.Owner)
		self.EndPick = CurTime() + self.LockPickTime
	end

	self:SetWeaponHoldType("slam")
	if SERVER then
		timer.Create("LockPickSounds", 1, self.LockPickTime, function()
			if not IsValid(self) then return end
			local snd = {1,3,4}
			self:EmitSound("beep.ogg", 50, 100)
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		end)
	elseif CLIENT then
		self.Dots = self.Dots or ""
		timer.Create("LockPickDots", 0.5, 0, function()
			if not self:IsValid() then timer.Destroy("LockPickDots") return end
			local len = string.len(self.Dots)
			local dots = {[0]=".", [1]="..", [2]="...", [3]=""}
			self.Dots = dots[len]
		end)
	end
end

function SWEP:Holster()
	self.IsLockPicking = false
	if SERVER then timer.Destroy("LockPickSounds") end
	if CLIENT then timer.Destroy("LockPickDots") end
	return true
end

function SWEP:Succeed()
	self.IsLockPicking = false
	self:SetWeaponHoldType("normal")
	
	local trace = self.Owner:GetEyeTrace()
	local ent = trace.Entity
	local doorsAss = ents.FindInSphere( self.Owner:GetPos(), 82 )
	
if SERVER then
	for k, v in pairs( doorsAss ) do
		if v:GetClass() == "func_door" then
			v:Fire("unlock")
			v:Fire("open")
			v:EmitSound("camera.ogg")
		end
	timer.Destroy("LockPickSounds") end
	end
	if CLIENT then timer.Destroy("LockPickDots") end
end

function SWEP:Fail()
	self.IsLockPicking = false
	self:SetWeaponHoldType("normal")
	if SERVER then timer.Destroy("LockPickSounds") end
	if CLIENT then timer.Destroy("LockPickDots") end
end

function SWEP:Think()

	if self.IsLockPicking and self.EndPick then
		local trace = self.Owner:GetEyeTrace()
		if not IsValid(trace.Entity) then
			self:Fail()
		end
		if trace.HitPos:Distance(self.Owner:GetShootPos()) > 60 or (trace.Entity:GetClass() != "prop_dynamic") then
			self:Fail()
		end
		if self.EndPick <= CurTime() then
			self:Succeed()
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

