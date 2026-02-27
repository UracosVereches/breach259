ENT.Base = "base_anim" 

ENT.Type = "anim"

ENT.PrintName = "MTF Helicopter"

ENT.Author = "UracosVereches"

ENT.Spawnable = true

ENT.Category = "Breach"

--[[
function ENT:Initialize()
	if CLIENT then
		local rotors = CreateSound(self.Entity, "vehicles/chopper_rotor2.wav")
		rotors:PlayEx(5, 100)
	end
end
--]]

--[[
function ENT:OnRemove()
	if CLIENT then
		rotors:Stop()
	end
end
--]]