function EFFECT:Init(data)
	self.startpos = data:GetStart()
	self.endpos = data:GetOrigin()
	self.length = (self.startpos-self.endpos):Length()
	self.alpha = 255
	self.width = 10
end

function EFFECT:Think()
	self.alpha = self.alpha-FrameTime()*400
	if self.alpha < 0 then return false end
	return true
end

function EFFECT:Render()
	if self.alpha < 1 then return end
	local alpha = self.alpha+((self.alpha/2)*math.sin(CurTime()*((255-self.alpha)*0.08))) 
	local col = Color(215,155,255,alpha)
	local life = CurTime()*15
	local laser = Material("trails/laser")
	render.SetMaterial(laser)
	render.DrawBeam(self.startpos,self.endpos,self.width,life+(self.length*0.01),life,col)
	render.DrawBeam(self.startpos,self.endpos,self.width*4,life+(self.length*0.01),life,col)
	local glow = Material("sprites/glow04_noz")
	local glowsize = self.width*12
	render.SetMaterial(glow)
	render.DrawSprite(self.startpos,glowsize,glowsize,col)
	render.DrawSprite(self.endpos,glowsize,glowsize,col)
end