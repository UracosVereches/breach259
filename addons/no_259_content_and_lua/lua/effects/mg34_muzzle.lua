--[[
addons/lua_crap/lua/effects/mg34_muzzle.lua
--]]

AddCSLuaFile()
function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)


	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	self.Up = self.Angle:Up()

	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()
	local emitter = ParticleEmitter(self.Position)

	local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), self.Position)
	--particle:SetVelocity(self.Forward*(10+(1*5)))
	particle:SetDieTime(0.04)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(200)
	particle:SetStartSize(14)
	particle:SetEndSize(15)
	particle:SetRoll(180)
	particle:SetRollDelta(math.Rand(-1,1))
	particle:SetColor(255,120,120)	

	local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
	particle:SetVelocity(100 * self.Forward + 8 * VectorRand())
	particle:SetAirResistance(400)
	particle:SetGravity(Vector(0, 0, math.Rand(25, 100)))
	particle:SetDieTime(math.Rand(1.0, 2.0))
	particle:SetStartAlpha(math.Rand(100, 125))
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(2, 7))
	particle:SetEndSize(math.Rand(15, 25))
	particle:SetRoll(math.Rand(-25, 25))
	particle:SetRollDelta(math.Rand(-0.05, 0.05))
	particle:SetColor(50, 50, 50)

	emitter:Finish()

	local dlight = DynamicLight(self:EntIndex())
		
	dlight.r = 255 
	dlight.g = 120
	dlight.b = 60
	dlight.Brightness = 4
	dlight.Pos = self.Position
	dlight.Size = 96
	dlight.Decay = 128
	dlight.DieTime = CurTime() + 0.04
end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()

	
end





