AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/props/cs_office/tv_plasma.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMaxHealth(1000)
	self:SetHealth(1000)
	self:PrecacheGibs()
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:OnTakeDamage(dmg)
	self.Damage = ( self.Damage or 1350 ) - dmg:GetDamage()
	if self.Damage <= 0 then
		self:GibBreakClient(VectorRand(-50, 50))
		self:Remove()
	elseif dmg:GetDamageType() == DMG_BLAST then
		self:GibBreakClient(VectorRand(-50, 50))
		self:Remove()
	end
end

function ENT:Use( activator, caller )
	return false
end

function ENT:Think()

end