AddCSLuaFile( "lootable_corpses_config.lua" )
include( "lootable_corpses_config.lua" )
include('shared.lua')   

function ENT:Draw()  
	self:DrawModel()
	
	local dist = self:GetPos():Distance( LocalPlayer():GetPos() )
	if(dist)>200 then return end
	
	local mul = 1
	if(dist>100) then
		mul = 1-((dist-100)/100)
	end

	local pos = self:GetPos()+self:GetUp()*5
	local ang = self:GetAngles()
	ang:RotateAroundAxis( self:GetUp(), 90 ) 

	local Victim = LCVictim or ""
	cam.Start3D2D(pos, ang, 0.1)
			draw.SimpleTextOutlined( LC.TextBox, "LC.MenuHeader", 8, 4, Color(LC.MenuColor.r,LC.MenuColor.g,LC.MenuColor.b,255*mul), 1, 1, 2, Color(LC.MenuAltColor.r,LC.MenuAltColor.g,LC.MenuAltColor.b,255*mul))
	cam.End3D2D()
end  

local LCSpacing = -30
hook.Add("HUDPaint", "LC_DrawBoxInfo", function()
	local tr = LocalPlayer():GetEyeTrace()
	local ent = tr.Entity
	if(!IsValid(ent)) then return end
	
	if (ent:GetClass() == "prop_ragdoll" and LocalPlayer():Health()>0) then
		if LocalPlayer():GTeam() == TEAM_SCP then return end
		if LocalPlayer():GTeam() == TEAM_SPEC then return end
		local Distance = ent:GetPos():Distance(LocalPlayer():GetPos())
		if(Distance<100 and !IsValid(LC_LootMenu)) then
			--surface.SetDrawColor( LC.MenuAltColor.r, LC.MenuAltColor.g, LC.MenuAltColor.b, 140 )
			--surface.DrawRect( ScrW()/2-20+LCSpacing, ScrH()/2-20, 40, 40 )
			--
			--surface.SetDrawColor( LC.MenuAltColor )
			--surface.DrawRect( ScrW()/2-22+LCSpacing, ScrH()/2-22, 44, 7 )
			--surface.DrawRect( ScrW()/2-22+LCSpacing, ScrH()/2-22, 7, 44 )
			--surface.DrawRect( ScrW()/2-22+37+LCSpacing, ScrH()/2-22, 7, 44 )
			--surface.DrawRect( ScrW()/2-22+LCSpacing, ScrH()/2-22+37, 44, 7 )
			--
			--surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 255 )
			--surface.DrawRect( ScrW()/2-20+LCSpacing, ScrH()/2-20, 40, 3 )
			--surface.DrawRect( ScrW()/2-20+LCSpacing, ScrH()/2-20, 3, 40 )
			--surface.DrawRect( ScrW()/2-20+37+LCSpacing, ScrH()/2-20, 3, 40 )
			--surface.DrawRect( ScrW()/2-20+LCSpacing, ScrH()/2-20+37, 40, 3 )
			--draw.SimpleTextOutlined( language.GetPhrase(input.GetKeyName( 15 )).."      "..LC.TextLoot, "LC.MenuFont", ScrW()/2+LCSpacing-5, ScrH()/2, LC.MenuColor, 0, 1, 2, LC.MenuAltColor)
			if ent:GetNWBool("DiedFromPistolBullets") then
				draw.SimpleTextOutlined("На теле видны пулевые ранения от малого калибра", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			elseif ent:GetNWBool("DiedFromSMG1Bullets") then
				draw.SimpleTextOutlined("На теле видны пулевые ранения от среднего калибра", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			elseif ent:GetNWBool("DiedFromAR2Bullets") then
				draw.SimpleTextOutlined("На теле видны пулевые ранения от высокого калибра", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			elseif ent:GetNWBool("DiedFromSlash") then
				draw.SimpleTextOutlined("Всё тело в колотых и резаных ранах", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			elseif ent:GetNWBool("DiedFromCrush") then
				draw.SimpleTextOutlined("Конечности в неестественном положении, открытые переломы", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			elseif ent:GetNWBool("DiedFromBlast") then
				draw.SimpleTextOutlined("На теле видны ожоги и ранения, это был взрыв", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			elseif ent:GetNWBool("DiedFromBurn") then
				draw.SimpleTextOutlined("Тело имеет значительные ожоги", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			else
				draw.SimpleTextOutlined("Причина смерти неизвестна", "LC.MenuFont", ScrW()/2, ScrH()/2-50, Color(128, 128, 128), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			end

			if ent:GetNWBool("DiedFromHeadshot") then
				draw.SimpleTextOutlined("Чётко в жбан", "LC.MenuFont", ScrW()/2, ScrH()/2-90, Color(255, 0, 0), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0))
			end

		end
	end
end)