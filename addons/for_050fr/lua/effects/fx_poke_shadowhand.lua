function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local dir = data:GetNormal()
	local normal = Vector(0,0,1)
	local scale = data:GetScale()
	scale = math.Round(scale/2)
	for i=1,scale+2 do
		local pos = (normal:Angle():Up()*math.random(-scale,scale))+(normal:Angle():Right()*math.random(-scale,scale))
		local part = emit:Add(
			"poke/particles/tendril"..math.random(1,3),
			data:GetOrigin()+pos
		)
		part:SetVelocity(VectorRand()*100+(normal*math.random(-300,300)))
		part:SetDieTime(1)
		part:SetStartAlpha(175)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,20))
		part:SetEndSize(35)
		part:SetColor(0,0,0) 
		part:SetRoll(math.Rand(-5,5))
		part:SetGravity(Vector(0,0,150))
		part:SetAirResistance(355)
	end

	for i=1,math.Round(scale/2)+2 do
		local pos = (normal:Angle():Up()*math.random(-scale,scale))+(normal:Angle():Right()*math.random(-scale,scale))
		local part = emit:Add(
			"poke/particles/tendril"..math.random(1,3),
			data:GetOrigin()+pos
		)
		part:SetVelocity(VectorRand()*55+(normal*math.random(-300,755)))
		part:SetDieTime(1)
		part:SetStartAlpha(175)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,20))
		part:SetEndSize(15)
		part:SetColor(0,0,0) 
		part:SetRoll(-5)
		part:SetGravity(Vector(0,0,150))
		part:SetAirResistance(255)
	end
	emit:Finish()

	self.dir = dir
	self.nextemit = 0
	self.build = 1
	self.pos = data:GetOrigin()
	self.life = 100
	self.alpha = 0
	self.rot = math.random(1,360)
	self.ang = -45

	self.cap1pos = self.pos + Vector(0,5,0)
	self.cap1 = ClientsideModel("models/poke/props/pokedarkhand.mdl",RENDERGROUP_TRANSLUCENT)
	self.cap1:SetAngles(Angle(0,dir:Angle().y+90,0))
	self.cap1:SetModelScale(10)
	self.cap1:SetMaterial("poke/props/plainshiny")
	self.cap1:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.cap1:SetColor(Color(5,0,15))
end

function EFFECT:Think()
	local ft = FrameTime()
	if self.life < 55 then 
		self.alpha = math.Clamp(self.alpha - (ft*355),0,200) 
		self.build = self.build - (ft*65)
	else
		self.alpha = math.Clamp(self.alpha + (ft*355),0,200) 
		self.build = self.build + (ft*65)
	end
	if self.life < 1 then
		if IsValid(self.cap1) then self.cap1:Remove() end
		return false
	end
	self.life = self.life - (ft*65)
	return true
end

function EFFECT:Render()
	local ft = FrameTime()
	if IsValid(self.cap1) then
		self.cap1:SetColor(Color(self.cap1:GetColor().r,self.cap1:GetColor().g,self.cap1:GetColor().b,self.alpha))
		self.ang = math.Clamp(self.ang + (ft*55),-135,135)
		self.cap1:SetAngles(Angle(self.cap1:GetAngles().p,self.cap1:GetAngles().y,self.ang))
		self.pos = self.pos + (self.dir*(ft*64))		
		self.cap1pos = self.pos + Vector(0,0,-3+self.build)
		self.cap1:SetPos(self.cap1pos)
	end
	if self.nextemit && self.nextemit < CurTime() then
		local emit = ParticleEmitter(self.pos)
		for i=0, 1 do
			local part = emit:Add ("poke/particles/tendril"..math.random(1,3),self.pos+Vector(math.random(-self.build,self.build),math.random(-self.build,self.build),8))
			part:SetVelocity(VectorRand()*35)
			part:SetDieTime(1)
			part:SetStartAlpha(125)
			part:SetStartSize(math.random(1,2))
			part:SetEndSize(15)
			part:SetColor(0,0,0) 
			part:SetGravity(Vector(0,0,35))
			part:SetRoll(math.random(0,360))
			part:SetAirResistance(2)
			part:SetEndSize(25)
		end
		self.nextemit = CurTime() + 0.01
	end
end