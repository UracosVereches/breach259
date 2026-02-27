--[[
lua/weapons/hacking_doors.lua
--]]
if SERVER then
	util.AddNetworkString("lockpick_time")
end

if CLIENT then
	SWEP.PrintName = "Взлом дверей"
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.droppable = false
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel						= Model( "models/jessev92/weapons/buddyfinder_c.mdl" )
SWEP.WorldModel						= Model( "models/jessev92/weapons/buddyfinder_w.mdl" )

if CLIENT then
	function SWEP:ShouldDrawViewModel()
		return false
	end
end

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
	self:SetWeaponHoldType("knife")
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self:SetColor(Color(255, 255, 255, 0))
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

	if SERVER then
		if e:GetPos() == Vector(-484.000000, 4836.000000, 50.000000) then return end
		if e:GetPos() == Vector(-412.000000, 4836.000000, 50.000000) then return end
		if e:GetPos() == Vector(-3612.000000, 2468.000000, 49.750000) then return end
		if e:GetPos() == Vector(-3684.000000, 2468.000000, 49.750000) then return end
	end

	--if not GAMEMODE.Config.canforcedooropen and e:getKeysNonOwnable() then
	--	return
	--end

	if SERVER then
		self.IsLockPicking = true
		self.StartPick = CurTime()
		self.LockPickTime = 20
		net.Start("lockpick_time")
			net.WriteEntity(self)
			net.WriteUInt(self.LockPickTime, 5)
		net.Send(self.Owner)
		self.EndPick = CurTime() + self.LockPickTime
	end

	self:SetWeaponHoldType("knife")
	if SERVER then
		self:GetOwner():RXSENDNotify("Вы начали процесс взлома двери.")
		timer.Create("LockPickSounds", 1, self.LockPickTime, function()
			if not IsValid(self) then return end
			--if timer.RepsLeft("LockPickSounds") == 20 then
				--self:GetOwner():RXSENDNotify("Вы начали процесс взлома двери.")
			if timer.RepsLeft("LockPickSounds") == 3 then
				self:EmitSound("door_break.wav")
			elseif timer.RepsLeft("LockPickSounds") == 6 then
				self:EmitSound("door_break.wav")
			elseif timer.RepsLeft("LockPickSounds") == 9 then
				self:EmitSound("door_break.wav")
			elseif timer.RepsLeft("LockPickSounds") == 12 then
				self:EmitSound("door_break.wav")
			elseif timer.RepsLeft("LockPickSounds") == 15 then
				self:EmitSound("door_break.wav")
			elseif timer.RepsLeft("LockPickSounds") == 18 then
				self:EmitSound("door_break.wav")
			end
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
	if self.IsLockPicking then
		self:GetOwner():RXSENDWarning("Процесс взлома прерван!")
	end
	self.IsLockPicking = false
	if SERVER then timer.Destroy("LockPickSounds") end
	if CLIENT then timer.Destroy("LockPickDots") end
	return true
end

function SWEP:Succeed()
	self.IsLockPicking = false
	self:SetWeaponHoldType("knife")
	
	local trace = self.Owner:GetEyeTrace()
	local ent = trace.Entity
	local doorsAss = ents.FindInSphere( self.Owner:GetPos(), 82 )
	
if SERVER then
	for k, v in pairs( doorsAss ) do
		if v:GetClass() == "func_door" then
			v:Fire("unlock")
			v:Fire("open")
			v:EmitSound("door_break.wav")
			v:EmitSound("ambient/energy/spark"..math.random(1, 6)..".wav")
			v:Fire("Open")
			local DamagedPlayerSpark    =    ents.Create( "env_spark" )
			
			DamagedPlayerSpark:SetPos(v:GetPos())
			
			DamagedPlayerSpark:SetKeyValue( "Magnitude" , "2" )
			DamagedPlayerSpark:SetKeyValue( "spawnflags" , "256" )
			DamagedPlayerSpark:SetKeyValue( "TrailLength" , "2" )
			DamagedPlayerSpark:Spawn()
			
			if IsValid( DamagedPlayerSpark ) then
			
			    DamagedPlayerSpark:Fire( "SparkOnce" , 0 , 0 )
			    DamagedPlayerSpark:Fire( "SparkOnce" , 0 , 0 )
			
			
			
			end
			
			timer.Simple( 0.02 , function()
			
			    if IsValid( DamagedPlayerSpark ) then
			
			        DamagedPlayerSpark:Remove()
			
			    end
			
			end)
		end
	timer.Destroy("LockPickSounds") end
	end
	if CLIENT then timer.Destroy("LockPickDots") end
end

function SWEP:Fail()
	self.IsLockPicking = false
	self:SetWeaponHoldType("knife")
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

