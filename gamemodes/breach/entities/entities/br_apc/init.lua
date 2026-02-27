AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/scp_chaos_jeep/chaos_jeep.mdl")

	self:PhysicsInit(SOLID_NONE)

	self:SetMoveType(MOVETYPE_NONE)

	self:SetSolid(SOLID_NONE)

	if SERVER then

		self:SetUseType(SIMPLE_USE)

	end

end

function ENT:Use(activator, caller)
	return false
end

--[[
function ENT:OnTakeDamage(dmg)
	self.Damage = ( self.Damage or 2500 ) - dmg:GetDamage()
	if self.Damage <= 0 then
		self:Boom()
	elseif dmg:GetDamageType() == DMG_BLAST then
		self:Boom()
	end
end
--]]

function ENT:OnRemove()
	return false
end

--[[
function ENT:Boom()

end
--]]