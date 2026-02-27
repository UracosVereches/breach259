--[[
lua/entities/livetab/cl_init.lua
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
surface.CreateFont( "shitonp", {
	font = "Gotham Nights",
	size = 1200,
	weight = 1400,
	antialias = true,
	shadow = false,
	outline = false,
} )
function Fluctuate(c) --used for flashing colors
	return (math.cos(CurTime()*c)+1)/2
end
function Pulsate(c) --Использование флешей
  return (math.abs(math.sin(CurTime()*c)))
end
local onpopenup = Material("overlays/fbi_openup")
function ENT:Draw()
	local oang = self:GetAngles()
	local opos = self:GetPos()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis( oang:Up(), 90 )
	ang:RotateAroundAxis( oang:Right(), - 90 )
	ang:RotateAroundAxis( oang:Up(), - 0)

    self:DrawModel()
		local Distance = LocalPlayer():GetPos():DistToSqr( self:GetPos() )
		if (Distance < 62500) and LocalPlayer():IsLineOfSightClear( self ) then
	cam.Start3D2D(pos + oang:Forward()*6.3 + oang:Up() * 33 + oang:Right() * 0, ang, 0.07 )

			draw.RoundedBox(0, -405, -50, 810, 480, Color(0, 0, 0, 250))
		if gteams.NumPlayers(TEAM_USA) >= 1 then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(onpopenup)
			surface.DrawTexturedRect(-405, -50, 810, 480)
			draw.SimpleTextOutlined( "DANGER", "shitonp", 0, 180, Color( 255, 0, 0, 180*Pulsate(4) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		end
		if gteams.NumPlayers(TEAM_USA) < 1 then
			draw.SimpleTextOutlined( ">>> СОСТОЯНИЕ КОМПЛЕКСА", "shit4111", -100, -10, Color( 100, 100, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "Foundation OS v 1.3.5", "DermaDefaultBold", 330, -25, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "Научные сотрудники: "..gteams.NumPlayers(TEAM_SCI) + gteams.NumPlayers(TEAM_SPECIAL), "shit4111", 0, 60, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "Служба безопасности: "..gteams.NumPlayers(TEAM_GUARD) + gteams.NumPlayers(TEAM_CHAOS), "shit4111", 0, 130, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "Персонал Класса-Д: "..gteams.NumPlayers(TEAM_CLASSD), "shit4111", 0, 200, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "Неустановленные личности: "..gteams.NumPlayers(TEAM_USA) + gteams.NumPlayers(TEAM_DZ) + gteams.NumPlayers(TEAM_GOC), "shit4111", 0, 270, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			local textonthescreen
			if gteams.NumPlayers(TEAM_SCP) > 0 then
				textonthescreen = "SCP объекты в комплексе!"
			else
				textonthescreen = "В комплексе нету SCP объектов!"
			end
			draw.SimpleTextOutlined( textonthescreen, "shit4111", 0, 340, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			draw.RoundedBox(0, -405, 380, 810, 70, Color(0, 0, 0, 250))
			draw.SimpleTextOutlined( "ИНИЦИАЛИЗИРОВАН РЕЖИМ БЛОКИРОВКИ! Проследуйте в ближайщее эвакуационное убежище и ожидайте спасательного отряда.", "DermaDefaultBold", 0, 405, Color( 255 * Fluctuate(3), 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		end
	cam.End3D2D()
end
end


