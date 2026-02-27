function EFFECT:Init(data)
	self.scale = data:GetScale()
	self.normal = data:GetNormal()
	self.pos = data:GetOrigin()
	self.ext = 0
	self.player = data:GetEntity()
	self.life = 100
	self.alpha = 15
	self.rot = math.random(1,360)
end

function EFFECT:Think()
	if IsValid(self.player) then
		self.pos = self.player:GetShootPos() + (self.normal*(FrameTime()*100)*(self.scale/100)) * self.ext
		self.ext = self.ext + (FrameTime()*155)
	else
		self.pos = self.pos + (self.normal*(FrameTime()*150)*(self.scale/100))
	end
	self.life = self.life - (FrameTime()*125)
	if self.life < 50 then
		self.alpha = math.Clamp(self.alpha - (FrameTime()*256),0,255)
	else
		self.alpha = math.Clamp(self.alpha + (FrameTime()*256),0,255)
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
	render.SetMaterial(Material("particle/particle_ring_wave_additive"))
	render.DrawQuadEasy( 
		self.pos, 
		self.normal, 
		math.Clamp(self.alpha,10,75), 
		math.Clamp(self.alpha,10,100), 
		Color(math.random(0,255),math.random(0,255),math.random(0,255),self.alpha), 
		self.rot
	)
	render.DrawQuadEasy( 
		self.pos, 
		-self.normal, 
		math.Clamp(self.alpha,10,100), 
		math.Clamp(self.alpha,10,75), 
		Color(math.random(0,255),math.random(0,255),math.random(0,255),self.alpha), 
		self.rot
	)
end