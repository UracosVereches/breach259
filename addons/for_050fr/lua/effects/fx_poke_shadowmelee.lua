function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local normal = data:GetNormal()
	local scale = data:GetScale()

	for i=1,math.Round(scale/5)+2 do
		local pos = (normal:Angle():Up()*math.random(-scale,scale))+(normal:Angle():Right()*math.random(-scale,scale))
		local part = emit:Add(
			"poke/particles/tendril"..math.random(1,3),
			data:GetOrigin()+pos
		)
		part:SetVelocity(VectorRand()*55)
		part:SetDieTime(0.5)
		part:SetStartAlpha(155)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(25,30))
		part:SetEndSize(45)
		part:SetColor(0,0,0) 
		part:SetRoll(math.Rand(-5,5))
		part:SetAirResistance(500)
	end
	emit:Finish()

	self.pos = data:GetOrigin()
	self.life = 100
	self.alpha = 215
	self.rot = math.random(1,360)
	self.normal = normal
end

function EFFECT:Think()
	self.life = self.life - (FrameTime()*200)
	if self.life < 50 then
		self.alpha = math.Clamp(self.alpha - (FrameTime()*512),0,215)
	end
	if self.life < 0 then
		return false
	end
	return true
end

function EFFECT:Render()
	local v1 = self.pos+Vector(-self.life,-self.life,0)
	local v2 = self.pos+Vector(-self.life,self.life,0)
	local v3 = self.pos+Vector(self.life,self.life,0)
	local v4 = self.pos+Vector(self.life,-self.life,0)
	render.SetMaterial(Material("particles/smokey"))
	render.DrawQuadEasy( 
		self.pos, 
		self.normal, 
		self.life, 
		self.life, 
		Color(0,0,0,self.alpha), 
		self.rot
	)
end