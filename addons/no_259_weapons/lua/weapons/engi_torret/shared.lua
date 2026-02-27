--[[
lua/weapons/engi_torret/shared.lua
--]]
if SERVER then
   AddCSLuaFile( "engi_torret.lua" )
   --resource.AddFile("materials/vgui/ttt/icon_wd_turret.vmt")
end

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
SWEP.ViewModelFlip = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.IronSightsPos = Vector(7.212, -5.41, 1.148)
SWEP.IronSightsAng = Vector(-4.016, -0.575, 28.114)

SWEP.VElements = {
	["VTurret"] = { type = "Model", model = "models/Combine_turrets/Floor_turret.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.519, 1.417, 16.611), angle = Angle(-175.362, -44.231, 7.531), size = Vector(0.416, 0.416, 0.416), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["WTurret"] = { type = "Model", model = "models/Combine_turrets/Floor_turret.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.806, 7.787, 19.087), angle = Angle(0, -39.237, -156.344), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

if CLIENT then
   SWEP.PrintName    = "Автоматическая турель"
   SWEP.Slot         = 6
   SWEP.ViewModelFlip = false
   SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/trap")
   SWEP.BounceWeaponIcon = false
end



--SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable     = true
SWEP.DrawCrosshair      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 0
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 0

--SWEP.Kind = WEAPON_EQUIP
--SWEP.CanBuy = {ROLE_TRAITOR}
--SWEP.LimitedStock = true
--SWEP.WeaponID = AMMO_TURRET
SWEP.dropable = false

SWEP.DeploySpeed = 2


if SERVER then

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

	if SERVER then self:SpawnTurret() end

end

function SWEP:SpawnTurret()
	local ply = self.Owner
	local tr = ply:GetEyeTrace()
    if !tr.HitWorld then return end
	if tr.HitPos:Distance(ply:GetPos()) > 128 then return end
	local Views = self.Owner:EyeAngles().y
   	local ent = ents.Create("tnt_s2_cannon_tu")
        --ent:SetOwner(ply)
  	ent:SetPos(tr.HitPos + tr.HitNormal)
	ent:SetAngles(Angle(0, Views, 0))
   	ent:Spawn()
    ent:Activate()

    local entphys = ent:GetPhysicsObject();
    if entphys:IsValid() then
        entphys:SetMass(entphys:GetMass()+200)
    end
	ent.IsTurret = true
	ent:SetPhysicsAttacker(self.Owner)
	ent:SetTrigger(true)
       ent.IsTurret = true
	self.Owner:StripWeapon("engi_torret")
end

end
function SWEP:Deploy()
	self:SecondaryAttack()
end

function SWEP:Equip()
   self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

function SWEP:OnDrop()
    self:Remove()
end


