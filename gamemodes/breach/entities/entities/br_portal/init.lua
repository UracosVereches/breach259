AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self.Entity:SetModel("models/scp_dlan_portal/dlan_portal.mdl")

	self.Entity:PhysicsInit(SOLID_VPHYSICS)

	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

	self.Entity:SetMoveType(MOVETYPE_NONE)

	self.Entity:SetSolid(SOLID_VPHYSICS)

	if SERVER then

		self:SetUseType(SIMPLE_USE)

	end

	self:SetCollisionGroup(COLLISION_GROUP_NONE)

end

function ENT:Use(activator, caller)
	return false
end

function ENT:OnRemove()
	return false
end