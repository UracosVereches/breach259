--[[
addons/lua_crap/lua/entities/npc_shuriken/shared.lua
--]]
ENT.Type 			= "anim"
ENT.PrintName		= "Shuriken"
ENT.Author			= "Worshipper, well, sort of. most of it is his anyway"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""

if SERVER then

AddCSLuaFile("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	
	self:SetModel("models/jaanus/knife_small.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1
	local trail = util.SpriteTrail(self.Entity, 0, Color(138,138,138), false, 15, 1, 0.5, 1/(15+1)*0.5, "trails/laser.vmt")

	util.PrecacheSound("weapons/shuriken/hit3.wav")
	util.PrecacheSound("physics/metal/metal_canister_impact_hard1.wav")

	self:GetPhysicsObject():SetMass(1)	
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	
	self.lifetime = self.lifetime or CurTime() + 20

	if CurTime() > self.lifetime then
		self:Remove()
	end
end

/*---------------------------------------------------------
   Name: ENT:Disable()
---------------------------------------------------------*/
function ENT:Disable()

	self.PhysicsCollide = function() end
	self.lifetime = CurTime() + 30

	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetOwner(NUL)
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollided()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, phys)
	
	local Ent = data.HitEntity
	if !(Ent:IsValid() or Ent:IsWorld()) then return end
	
	if Ent:IsWorld() then
			util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
				self:EmitSound(Sound("physics/metal/metal_canister_impact_hard1.wav"))
				self:SetPos(data.HitPos - data.HitNormal)
				self:SetAngles(self.Entity:GetAngles())
				self:GetPhysicsObject():EnableMotion(false)

			self:Disable()


	elseif Ent.Health then
		if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			self:EmitSound("physics/metal/metal_canister_impact_hard1.wav")
		end
		local plydmg = math.random(40,45)
		local entdmg = math.random(40,50)
		if Ent:IsPlayer() then 
		Ent:TakeDamage(plydmg, self:GetOwner(), self.Entity)
		end
		if Ent:IsNPC() then
		Ent:TakeDamage(entdmg, self:GetOwner(), self.Entity)
		end
		if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			local effectdata = EffectData()
			effectdata:SetStart(data.HitPos)
			effectdata:SetOrigin(data.HitPos)
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)
		
			end
				self:EmitSound(Sound("weapons/shuriken/hit3.wav"))
			self:Remove()
		end
		
	end

end

/*---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------*/
function ENT:Use(activator, caller)

end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()

	self.Entity:DrawModel()
end
end


