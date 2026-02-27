ENT.Base = "base_gmodentity"

ENT.Type = "anim"

ENT.PrintName = "CI APC"

ENT.Author = "UracosVereches"

ENT.Spawnable = true

ENT.Category = "Breach"

--[[
apc_engine = "LOX"
function ENT:Think()
	if CLIENT then
		if !apc_engine:IsPlaying() then
			local apc_engine = CreateSound(self.Entity, "car_driving_2.mp3")
			apc_engine:PlayEx(3, 100)
		end
	end
end
--]]

--[[
function ENT:OnRemove()
	if CLIENT then
		apc_engine:Stop()
	end
end
--]]