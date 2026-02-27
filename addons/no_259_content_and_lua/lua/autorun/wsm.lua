--[[
lua/autorun/wsm.lua
--]]
-- WHEATLEY'S STEALTH MODULE
-- you are free to use this in your projectes, just don't forget to credit me!

if SERVER then
	AddCSLuaFile()
end

-- !!! DO NOT CHANGE !!! --
local _WSM_Ver = 1.1

if _WSM and _WSM.Version <= _WSM_Ver then return end

_WSM = {}
_WSM.Version = _WSM_Ver

function _WSM:GetVisibilityForPlayer( ply )
	if !IsValid( ply ) or !ply:IsPlayer() then
		MsgC( Color( 200, 0, 0 ), '[Wheatley\'s Stealth Module]: programming error: trying to compute visibility for non-player entity!\n' )
		return 1
	end
	
	return ply:GetNWFloat( '_WSM_Vis', 1 )
end

if SERVER then
	util.AddNetworkString( '_WSM_ComputeVis' )
	
	net.Receive( '_WSM_ComputeVis', function( _, ply )
		local vis = net.ReadFloat()
		ply:SetNWFloat( '_WSM_Vis', vis )
	end )
else
	timer.Create( '_WSM_ComputeVis', 0.1, 0, function()
		if !IsValid( LocalPlayer() ) then return end
		local light = render.ComputeLighting( LocalPlayer():EyePos(), Vector( 0, 0, 1 ) )
		local luminocity = ( light.x + light.y + light.z ) / 3
		
		if LocalPlayer():FlashlightIsOn() or IsValid( LocalPlayer():GetNWEntity( 'TPFLight' ) ) then
			luminocity = 1
		end
		net.Start( '_WSM_ComputeVis' )
			net.WriteFloat( luminocity )
		net.SendToServer()
	end )
end

