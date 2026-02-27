--[[
gamemodes/breach/entities/weapons/weapon_stungun/shared.lua
--]]
local SWEPConfig = {}


if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/stungun")
	SWEP.BounceWeaponIcon = false
end


SWEPConfig.StunTime = 10
SWEPConfig.MaxDist = 400
SWEPConfig.DrawPostProcess = false
SWEPConfig.Damage = 5
SWEPConfig.WantedOnly = false -- taser on wanted only

timer.Simple(3,function() -- timer, because we need some wait for loading all addons and jobs

SWEPConfig.RestrictJobs = {
TEAM_MAYOR,
TEAM_POLICE,

}

end)




SWEPConfig.gameRP = type(DarkRP) == "table"
SWEPConfig.gameTTT = ROLE_TRAITOR != nil

SWEPConfig.ImGirl = {
	"models/player/alyx.mdl",
	"models/player/p2_chell.mdl"
}

if SWEPConfig.gameRP then
	AddCustomShipment("StunGun", {
	model = "models/weapons/Custom/w_scanner.mdl",
	entity = "weapon_stungun",
	price = 215,
	amount = 10,
	seperate = true,
	pricesep = 3000,
	noship = true,
	allowed = {TEAM_POLICE}
})
end

if SWEPConfig.gameTTT then
	SWEP.Base = "weapon_tttbase"
	SWEP.Kind = WEAPON_EQUIP1
	SWEP.AutoSpawnable = false
	SWEP.CanBuy = { ROLE_DETECTIVE }
	SWEP.InLoadoutFor = nil
	SWEP.LimitedStock = false
	SWEP.AllowDrop = true
end



function SWEP:GGetSound(mdl)
	if table.HasValue(SWEPConfig.ImGirl,mdl) or string.find(mdl, "female") then
		return "vo/npc/female01/pain0"..math.random(1,9)..".wav"
	end
	return 'vo/npc/male01/pain0'..math.random(1,9)..'.wav'
end


if CLIENT then

	local function MakeAllGood()
		timer.Create('AllGood2',0.05,0,function()
			if LocalPlayer().Sens > 0 then	LocalPlayer().Sens = LocalPlayer().Sens - 2 end 
			if LocalPlayer().alpha_value > 0 then LocalPlayer().alpha_value = LocalPlayer().alpha_value - 2 end
			if LocalPlayer().relation > 0 then	LocalPlayer().relation = LocalPlayer().relation - 0.02	end
			if LocalPlayer().bloom < 1 then	LocalPlayer().bloom = LocalPlayer().bloom + 0.01	end
			
		end) 	
	end




	net.Receive('fucking_stun',function()
		local ply = net.ReadEntity()
		local tims = net.ReadDouble() if tims<=0 then tims =  SWEPConfig.StunTime end

		if not IsValid(ply) or not ply:IsPlayer() then return end


		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY, true)

		if ply == LocalPlayer() then
			LocalPlayer().StunShit = false
			LocalPlayer().Sens = LocalPlayer().Sens or 0
			LocalPlayer().relation = math.Clamp((LocalPlayer().relation or 0) + 330.33,0,1)
			LocalPlayer().alpha_value = math.Clamp( (LocalPlayer().alpha_value or 0)+333,0,100)
			LocalPlayer().bloom = 0
			
			timer.Destroy('AllGood')
			timer.Create('MakeAllGood',3,1,MakeAllGood)
		end

		timer.Create('ShittyFuckFuckStun2',0.33,3*tims,function()
			ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY, true)
		end)

		timer.Create('ShittyFuckFuckStun',0.05,20*tims,function()
			if LocalPlayer() == ply then
				LocalPlayer().StunShit = !LocalPlayer().StunShit
				if LocalPlayer().StunShit then
					LocalPlayer():SetEyeAngles(Angle(0,LocalPlayer():GetAngles().y+math.random(-10,10),LocalPlayer():GetAngles().r))
				else
					LocalPlayer():SetEyeAngles(Angle(-20,LocalPlayer():GetAngles().y+math.random(-10,10),LocalPlayer():GetAngles().r))
				end
			end
		end)

	end)

	net.Receive('fucking_stun2',function()
		local ply = net.ReadEntity()
		if ply == LocalPlayer() then
			LocalPlayer().StunShit = false
			LocalPlayer().Sens = LocalPlayer().Sens or 0
			LocalPlayer().relation = math.Clamp((LocalPlayer().relation or 0) + 330.33,0,1)
			LocalPlayer().alpha_value = math.Clamp( (LocalPlayer().alpha_value or 0)+333,0,100)
			LocalPlayer().bloom = 0
			LocalPlayer().Sens =  100
			timer.Destroy('AllGood')
			timer.Create('MakeAllGood',3,1,MakeAllGood)
		end
		timer.Create('ShittyFuckFuckStun2',0.33,3*4,function()
			ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD,ACT_HL2MP_WALK_ZOMBIE_01, true)
		end)
	end)
end


if SERVER then
  util.AddNetworkString('fucking_stun')
  util.AddNetworkString('fucking_stun2')

util.AddNetworkString('omglaser')
  AddCSLuaFile( "shared.lua" )
  --resource.AddWorkshop("346003955")

  local function DeleteHelpEnt(ply)
	if IsValid(ply) and IsValid(ply.HelpEnt) then
		ply.HelpEnt:Remove()
	end
  end
 hook.Add('PlayerDeath','diesbitch',DeleteHelpEnt)
 hook.Add('PlayerSpawn','spawnedbitch',DeleteHelpEnt)
 hook.Add('PlayerDisconnected','leavingbitch',DeleteHelpEnt)
end


if CLIENT then
   SWEP.PrintName = "Шокер"
   SWEP.Slot      = 2
   SWEP.SlotPos		= 1
end


SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/Custom/taser.mdl"
SWEP.WorldModel = "models/weapons/Custom/w_taser.mdl"
SWEP.HoldType = "pistol"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Primary.Sound = Sound("weapons/clipempty_rifle.wav")
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.05
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.06
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"

SWEP.DrawCrosshair = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IronSightsPos = Vector(-6, 2.2, -2)
SWEP.IronSightsAng = Vector(0.9, 0, 0)
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 65

	function SWEP:Initialize()
		if SERVER then
			self.Laser = false
			self.LastUpdated = CurTime()
		end
	end

	function SWEP:MinutkaBreda(ply,ent)
		ent:SetPoint(ply:GetShootPos()+ply:GetForward()*SWEPConfig.MaxDist/2)
	end


	function SWEP:CreateFakeRope()
		if  IsValid(self.ent2) then self.ent2:Remove()  end
		self.ent2 = ents.Create("im_prop")
		self.ent2:Spawn()
		self.ent2:SetColor(Color(0,0,0,0))
		self.ent2:SetMoveType(0)
		self.ent2:SetPos(self.Owner:GetShootPos()+self.Owner:GetForward()*20)


		local dist = 400
		local const,rop1 = constraint.Rope( self.ent, self.ent2, 0, 0,Vector(0.1,0.1,0),Vector(0,0,0),dist, 80,0,1, "cable/blue_elec",false )
		local const,rop2 = constraint.Rope( self.ent, self.ent2, 0, 0,Vector(-0.1,-0.1,0),Vector(0,0,0),dist,80,0,1, "cable/redlaser",false )
		self.Target = self.ent2
		self.dist = dist
		self:MinutkaBreda(self.Owner,self.ent2)
	end


	function SWEP:CreateMarionete(ply)
		if not IsValid(ply) or not ply:IsPlayer() then return end
		if  IsValid(ply.HelpEnt) then ply.HelpEnt:Remove()  end
		ply.HelpEnt = ents.Create("prop_physics")
		ply.HelpEnt:SetModel("models/hunter/plates/plate.mdl")
		ply.HelpEnt:PhysicsInit(SOLID_VPHYSICS)
		ply.HelpEnt:Spawn()
		ply.HelpEnt:DrawShadow(false)
		ply.HelpEnt:SetMoveType(MOVETYPE_VPHYSICS)
		ply.HelpEnt:Activate()
		ply.HelpEnt:GetPhysicsObject():SetMass(5500)
		ply.HelpEnt:SetAngles(Angle(0,0,0))
		ply.HelpEnt:SetPos(ply:GetPos())
		ply.HelpEnt:SetModelScale(0.2,0)
		ply.HelpEnt:SetSolid(SOLID_NONE)
		ply.HelpEnt:SetParent(ply)
		ply.HelpEnt:Fire("SetParentAttachmentMaintainOffset", "chest", 0.01)
		return ply.HelpEnt
	end



	function SWEP:CreateHelpingProp()
		if  IsValid(self.ent) then self.ent:Remove()  end
		self.ent = ents.Create("im_prop")
		self.ent:Spawn()

		local hand = self.Owner:LookupBone("ValveBiped.Bip01_r_hand")
		if hand == nil then
			return
		end
		local pos,ang= self.Owner:GetBonePosition(hand)
		self.ent:SetAngles(ang)
		self.ent:SetPos(pos+self.ent:GetForward()*3+self.ent:GetUp()*-3 + self.ent:GetRight()*1.2)
		self.ent:SetParentAE(self.Owner)
		self.OverPower = false
		self.Taser = nil
		self.Target = nil
	end

	function SWEP:FuckingStun(ply,tims)
		if not IsValid(ply) or not ply:IsPlayer() then return end
		ply:SetMoveType(MOVETYPE_FLYGRAVITY)
		ply:EmitSound(self:GGetSound(ply:GetModel()))
		timer.Create("antistun"..ply:SteamID(),1,1,function()
			if IsValid(ply) then
				ply:SetMoveType(2)
			end
			if IsValid(self) then
				self.Taser = false
			end
		end)
		net.Start('fucking_stun') net.WriteEntity(ply) net.WriteDouble(tims) net.Broadcast()
	end

function SWEP:FuckingOverStun(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if ply:GTeam() == TEAM_SCP then return end
	ply:TakeDamage(SWEPConfig.Damage,nil,nil)
	ply:Freeze(true)
	ply:EmitSound(self:GGetSound(ply:GetModel()))
	timer.Create("antistun2"..ply:SteamID(),SWEPConfig.StunTime,1,function()
		if IsValid(ply) then
			ply:SetMoveType(2)
			ply:Freeze(false)
		end
	end)
	net.Start('fucking_stun2') net.WriteEntity(ply) net.Broadcast()
end

function SWEP:FuckThis(numb)
	if IsValid(self.ent) then
		self.ent:SetTarget(self.Target,self.dist)
	end

	local shit = self.Target and self.Target.HelpEnt or nil
	self.Target = nil

	timer.Simple(numb,function()
	if IsValid(self.ent) then self.ent:Remove() self:CreateHelpingProp() end
	if IsValid(self.ent2) then  self.ent2:Remove() end
	if IsValid(shit) then shit:Remove() end
	end)
end

function SWEP:Deploy()
	self.Power = 100
	self.Taser = nil

	if SERVER then
		if IsValid(self.ent) then return end
		self:CreateHelpingProp()
	end
	return true
end


function SWEP:Holster()
	if SERVER then
		self.Target =nil
		if IsValid(self.ent2) then self.ent2:Remove() end
		if not IsValid(self.ent) then return end
		self:FuckThis(2)
	end
	return true
end

function SWEP:OnDrop()
	if SERVER then
		self.Target =nil
		if IsValid(self.ent2) then self.ent2:Remove() end
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end

function SWEP:OnRemove()
	if SERVER then
		self.Target = nil
		if IsValid(self.ent2) then self.ent2:Remove() end
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end

function SWEP:Reload()
	if not self.Weapon:DefaultReload(ACT_VM_RELOAD) then return end
	if SERVER then
		self:FuckThis(3)
		self:SetNextPrimaryFire(CurTime() +3)
		self.Laser = false
		self:SetNWInt('power',0)
		net.Start('omglaser') net.WriteEntity(self) net.WriteBit(self.Laser) net.Broadcast()
	end
	self.Reloading = true
	self.Owner:SetAnimation(PLAYER_RELOAD)
	timer.Simple(2, function()
		if not IsValid(self) then return end
		self.Reloading = false
		self.Power = 100
		self:SetNWInt('power',self.Power)
	end)
end


function SWEP:Think()
 if SERVER and  IsValid(self.Target) and self.dist and IsValid(self.ent) then
	if self.ent:GetPos():Distance(self.Target:GetPos()) > self.dist+100 then
		self:FuckThis(10)
	end
 end
end

function SWEP:SecondaryAttack()
self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
 if SERVER then
if self.Power > 0 then
	timer.Simple(0.6,function()
		if IsValid(self) then
			 self.Owner:EmitSound(Sound("Weapon_Pistol.Empty"))
			self.Laser = !self.Laser
			net.Start('omglaser') net.WriteEntity(self) net.WriteBit(self.Laser) net.Broadcast()
		end
	end)
end
 end
 return
end

function SWEP:PrimaryAttack()
	if not self.Power then self.Power = 0 end
	if SERVER and self.LastUpdated + 0.2 < CurTime() then
		self.LastUpdated = CurTime()
		self:SetNWInt('power',self.Power)
	end
	if self.Power <= 0 then  if not self.OverPower then
		if SERVER then
			self.Laser = false
			net.Start('omglaser') net.WriteEntity(self) net.WriteBit(self.Laser) net.Broadcast()
			self:FuckingOverStun(self.Target)end  self.OverPower = true
		end
		return
	end
	self.Power = self.Power -1


	if self:Clip1() <= 0 then
		if self.Target then

			self.Owner:EmitSound( "Weapon_Pistol.Empty")
			self.Owner:EmitSound( "Weapon_SMG1.Empty")

			self.LastPrimaryAttack = CurTime()
			if not self.Taser then
				self.Taser = true
				self:FuckingStun(self.Target,0.9)
			end
		else
			self:EmitSound("weapons/clipempty_rifle.wav")
			self:SetNextPrimaryFire(CurTime() + 2)
		end
		return
	end

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Weapon:EmitSound(self.Primary.Sound)

	if SERVER then
		local Target = self.Owner:GetEyeTrace().Entity
		if SWEPConfig.gameRP and IsValid(Target) and IsValid(self.ent) and Target:IsPlayer() and ((SWEPConfig.WantedOnly and not Target:isWanted()) or table.HasValue(SWEPConfig.RestrictJobs,Target:Team())) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
				self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0))
				self.LastPrimaryAttack = CurTime()
				return
		end
		if IsValid(self.ent) and IsValid(Target) and  Target:IsPlayer() and self.Owner:GetPos():Distance(Target:GetPos()) <= SWEPConfig.MaxDist then
			self.Target = Target
			self.dist = self.Owner:GetPos():Distance(self.Target:GetPos())
			if not IsValid(self.Target.HelpEnt) then self:CreateMarionete(self.Target) end

			local pos = self.Target.HelpEnt:WorldToLocal(self.Owner:GetEyeTrace().HitPos)
			local const1,rop1 = constraint.Rope( self.ent, self.Target.HelpEnt, 0, 0,Vector(0.1,0.1,0),pos,self.dist,80,0,1, "cable/blue_elec",false )
			local const2,rop2 = constraint.Rope( self.ent,  self.Target.HelpEnt, 0, 0,Vector(-0.1,-0.1,0),pos,self.dist,80,0,1, "cable/redlaser",false )

		elseif self.Target == nil then
			self:CreateFakeRope()
		end
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	end


	self:TakePrimaryAmmo(1)
	if self.Owner:IsNPC() then return end
	self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0))
	self.LastPrimaryAttack = CurTime()
end




function SWEP:GetViewModelPosition(pos, ang)
	if not self.IronSightsPos then return pos, ang end
	pos = pos + ang:Forward() * -5

	local Offset = self.IronSightsPos

	if self.IronSightsAng then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 	self.IronSightsAng.x)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right
	pos = pos + Offset.y * Forward
	pos = pos + Offset.z * Up

	return pos, ang
end



if CLIENT then
local LASER = Material( 'cable/redlaser' )

net.Receive('omglaser',function()
local ent = net.ReadEntity()
if IsValid(ent) then
	ent.Laser = net.ReadBit()
end
end)

local function DrawLaser()
		for i,ply in pairs(player.GetAll()) do
		if not ply:Alive() or LocalPlayer()==ply or ply:GetActiveWeapon()==NULL or ply:GetActiveWeapon():GetClass()!='weapon_stungun' or ply:GetActiveWeapon().Laser!=1 then continue  end
		render.SetMaterial( LASER )

		local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone == nil then return end
		 local m = ply:GetBoneMatrix(bone)
		 if not IsValid(m) then return end
			local pos =m:GetTranslation()+ply:EyeAngles():Forward()*8+Vector(0,0,0.1)+ply:EyeAngles():Right()*-1
			local hitpos = ply:GetShootPos()+ply:EyeAngles():Forward()*SWEPConfig.MaxDist
			if(ply:GetEyeTrace().HitPos:Length()<=SWEPConfig.MaxDist) then hitpos = ply:GetEyeTrace().HitPos end
	--		if hitpos:Length() > 100 then hitpos = ply:GetEyeTrace().HitNormal end
		render.DrawBeam( pos,hitpos, 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
		end
end



hook.Add('PostDrawOpaqueRenderables','PlyMustSeeLaset',function()
DrawLaser()
end)




function SWEP:ViewModelDrawn()
	local vm = self.Owner:GetViewModel()
	if !IsValid(vm) then return end

		local bones = vm:LookupBone("Trigger")
		local bone = vm:LookupBone("cartridge")

		if (!bone) then return end

		pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = vm:GetBoneMatrix(bone)
		local m2 = vm:GetBoneMatrix(bones)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
			pos2, ang2 = m2:GetTranslation(), m2:GetAngles()
		else
			return
		end



		if self.Laser == 1 then
			render.SetMaterial( LASER )
			render.DrawBeam( pos, self.Owner:GetEyeTrace().HitPos, 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
		end

			ang2:RotateAroundAxis(ang2:Forward(), 90)
			ang2:RotateAroundAxis(ang2:Right(), 90)

			cam.Start3D2D(pos2+ang2:Right()*-1+ang2:Up()*3.12+ang2:Forward()*0.12, ang2, 0.1)
				self:DrawScreen(0,0,65,123)
			cam.End3D2D()
end

function SWEP:DrawScreen(x, y, w, h)


	local power =  self:GetNWInt('power',0)
	local i =  power / 10

	draw.RoundedBox( 0,0,0,6,10,Color(25,25,25,255))
	draw.RoundedBox( 0,1,0,4,math.Clamp(i,0,10),Color(255-power,10+power*2,25,255))



end

end


