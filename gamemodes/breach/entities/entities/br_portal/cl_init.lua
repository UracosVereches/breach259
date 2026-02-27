include('shared.lua')



surface.CreateFont( "shit4111", {

	font = "Comic Sans",

	size = 45,

	weight = 700,

	antialias = true,

	shadow = false,

	outline = false,

} )



function ENT:Draw()

	self:DrawModel()

end

--[[
portal = "adidas"
function ENT:Think()
	if CLIENT then
		if !portal:IsPlaying() then
			local portal = CreateSound(self.Entity, "ambient/levels/citadel/portal_beam_loop1.wav")
			portal:PlayEx(1, 100)
		end
	end
end
--]]

--[[
function ENT:OnRemove()
	if CLIENT then
		portal:Stop()
	end
end
--]]
