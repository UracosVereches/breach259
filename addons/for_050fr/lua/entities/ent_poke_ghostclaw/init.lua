AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/poke/props/pokedarkhand.mdl")
	self:SetColor(Color(5,0,15,155))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)	
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetMaterial("poke/props/plainshiny")

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableGravity(false)
		phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	local life = self.lifetime or 5
	timer.Simple(life,function()
		if IsValid(self) then
			self:Remove()
		end
	end)

	self:SetAngles(Angle(self:GetAngles().p,self:GetAngles().y+90,self:GetAngles().r))
	self.speed = 255
	self.PokeSWEP = true
end

function ENT:DoThink()
	if !IsValid(self) then return end
	local speed = self.speed
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(self:GetRight()*speed)
	end
	local att = self
	if IsValid(self:GetOwner()) then
		att = self:GetOwner()
	end
	for _, v in ipairs(ents.FindInSphere(self:GetPos(),100)) do
		if IsValid(v) then
			if v != att then 
				local dmg = DamageInfo()
				dmg:SetAttacker(att)
				dmg:SetInflictor(self)
				dmg:SetDamageForce(self:GetRight()*15000)
				dmg:SetDamage((v:Health()/4)+1)
				v:TakeDamageInfo(dmg)
			end
		end
	end
end

function ENT:Think()
	self:DoThink()
	return false
end