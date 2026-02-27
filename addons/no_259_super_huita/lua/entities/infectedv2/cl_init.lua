--[[
addons/super_huita/lua/entities/infectedv2/cl_init.lua
--]]
include("shared.lua")

function ENT:Draw() 
	self:DrawModel()--Makes the ent visible for players
end

local tab = {

	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.15, --Changes the players screen to a desaturated tint, with red boosted by 500%
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 5,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0

}



 --SCREEN EFFECTS--
net.Receive("infected2", function(len, ply)

	surface.PlaySound("ambient/misc/metal2.wav")


		hook.Add("RenderScreenspaceEffects","008Overlay", function()

			DrawMaterialOverlay( "models/scp_008_overlay/overlay.vtf", 0.06 )

		end)

		hook.Add("RenderScreenspaceEffects", "008Ef", function()
		
		
			DrawMotionBlur( 0.4, 0.8, 0.05 )		
			DrawColorModify(tab)
		
		end)

		util.ScreenShake(LocalPlayer():GetPos(),7,2,7,1) --Shakes the camera to the point where the player feels sad

end)

--SCREEN EFFECT REMOVER--

net.Receive("dedPlay2", function(len, ply, v)

	hook.Remove("RenderScreenspaceEffects", "008Ef")	
    hook.Remove("RenderScreenspaceEffects", "008Overlay")

end)


