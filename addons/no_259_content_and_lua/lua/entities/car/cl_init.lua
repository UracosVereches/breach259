--[[
lua/entities/car/cl_init.lua
--]]
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

