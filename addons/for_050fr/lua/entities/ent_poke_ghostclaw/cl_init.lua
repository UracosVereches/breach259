include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	self.cap1 = ClientsideModel("models/poke/props/pokedarkhand.mdl",RENDERGROUP_TRANSLUCENT)
	self.cap1:SetPos(self:GetPos())
	self.cap1:SetAngles(Angle(0,self:GetAngles().y,0))
	self.cap1:SetModelScale(10)
	self.cap1:SetMaterial("poke/props/plainshiny")
	self.cap1:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.cap1:SetColor(Color(5,0,15,0))

	self.alpha = 0

	self.nextemit = 0
end

function ENT:DoShadow()
	if self.nextemit < CurTime() then
		local tr = util.TraceLine({
			start = self:GetPos()+Vector(0,0,16),
			endpos = self:GetPos()+Vector(0,0,-32),
			filter = self
		})
		local fx = EffectData()
		fx:SetOrigin(tr.HitPos)
		fx:SetNormal(Vector(0,0,1))
		fx:SetScale(50)
		util.Effect("fx_poke_shadow",fx)
		self.nextemit = CurTime()+0.1
	end
end

function ENT:Think()
	local ft = FrameTime()
	self.cap1:SetPos(self:GetPos())
	self.alpha = math.Clamp(self.alpha + (ft*150),0,150)

	self:DoShadow()
	return true
end

function ENT:OnRemove()
	if IsValid(self.cap1) then
		self.cap1:Remove()
		self.cap1 = nil
	end
end

function ENT:Draw()
	--self:DrawModel()
	self.cap1:SetColor(Color(5,0,15,self.alpha))
end