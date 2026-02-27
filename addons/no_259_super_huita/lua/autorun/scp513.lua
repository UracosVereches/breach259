--[[
addons/super_huita/lua/autorun/scp513.lua
--]]

if (CLIENT) then
	-- Variables 
	SCP513Next, ply = CurTime(), LocalPlayer()
	if IsValid(ply) then
		SCP513Pos = ply:GetPos() + Vector(math.random(-200,200),math.random(-200,200),0) 
	else
		SCP513Pos = Vector(0,0,0)
	end
	
	-- Hooks
	hook.Add( "PostDrawOpaqueRenderables", "SCP513Visual", function()
		if ( LocalPlayer():GetNWBool("SCP513Enabled") ) then 
			local lang = LocalPlayer():GetAngles().y - 90
			local angle = Angle(0,lang,90)
			cam.Start3D2D( SCP513Pos + Vector(0,0,math.sin(CurTime() * 3)), angle, 0.75 )
				surface.SetDrawColor( 255, 255, 255, 200 )
				surface.SetMaterial( Material( "scp_pack/scp513.png" ) ) 
				surface.DrawTexturedRect( -35, -128, 70, 128 )
			cam.End3D2D()
		
			if CurTime() > SCP513Next then
				SCP513Pos = LocalPlayer():GetPos() + Vector(math.random(-400,400),math.random(-400,400),0)   
				SCP513Next = CurTime() + 2
				
				if SCP513Pos:Distance(LocalPlayer():GetPos()) < 75 then
					SCP513Next = CurTime() + 0.75
					surface.PlaySound("scp_pack/horror" .. math.random(1,2) ..".ogg")
				end
			end
		end 
	end)
end

if (SERVER) then
	hook.Add( "PlayerSpawn", "SCPSpawnReset", function(ply)
		ply:SetNWBool("SCP513Enabled", false)
	end)
	hook.Add( "PlayerDeath", "SCPDeathReset", function(ply)
		ply:SetNWBool("SCP513Enabled", false)
	end)	
end


