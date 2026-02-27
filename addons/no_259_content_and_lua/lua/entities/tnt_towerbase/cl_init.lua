--[[
lua/entities/tnt_towerbase/cl_init.lua
--]]

include("shared.lua")

killicon.Add( "tnt_towerbase", "vgui/hud/tnt_watchout", Color( 255, 255, 255, 255 ) )

function ENT:Draw()
	self.Entity:DrawModel()
end

