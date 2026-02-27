--[[
gamemodes/breach/gamemode/cl_scoreboard.lua
--]]
// Made by Kanade



if not Frame then

	Frame = nil

end

function Pulsate(c) --Использование флешей

  return (math.abs(math.sin(CurTime()*c)))

end

function Fluctuate(c) --used for flashing colors

	return (math.cos(CurTime()*c)+1)/2

end

surface.CreateFont("sb_names", {font = "Trebuchet18", size = 15, weight = 700})



function RanksEnabled()

	return GetConVar("br_scoreboardranks"):GetBool()

end



function firstToUpper(str)

    return (str:gsub("^%l", string.upper))

end



function role_GetPlayers(role)

	local all = {}

	for k,v in pairs(player.GetAll()) do

		if v:Alive() then

			if not v.GetNClass then

				player_manager.RunClass( v, "SetupDataTables" )

			end



			if v.GetNClass then

				if v:GetNClass() == role then

					table.ForceInsert(all, v)

				end

			end

		end

	end

	return all

end



function ShowScoreBoard()

	local ply = LocalPlayer()

	if !(ply:GTeam() == TEAM_SPEC) then return end

	local allplayers = {}

	table.Add(allplayers, player.GetAll())

  local head = Material("hudforspectators/nextorenscoreboardheadd_"..math.random(1,6)..".png")

	local mtfs = {}

	local classds = {}

	local researchers = {}

	local orts = {}

	local chaosins = {}

	local usasins = {}

	local gocs = {}

	local special = {}

	local ntfs = {}

	local dz = {}

	local survivald = {}

	local scoreboard_sovets = {}

	local scoreboard_nazis = {}


	local ci_added = false
	local ww2tdm_added = false
	for k,v in pairs(ALLCLASSES["security"]["roles"]) do

		if v.team == 2 then

		  table.Add(mtfs, role_GetPlayers(v.name))

		end

		--print(v.team, v.name)

		--if v.team == 6 then
		if !ci_added then

		  table.Add(chaosins, role_GetPlayers(ROLES.ROLE_CHAOSSPY))

		  ci_added = true
		  
		end

		if !ww2tdm_added then

			table.Add(scoreboard_sovets, role_GetPlayers(ROLES.ROLE_USSR))

			table.Add(scoreboard_nazis, role_GetPlayers(ROLES.ROLE_NAZI))

		  ww2tdm_added = true
		  
		end

		--end

	end

	for k,v in pairs(ALLCLASSES["support"]["roles"]) do

    --print(v.team, v.name)

		if v.team == 8 then

			table.Add(dz, role_GetPlayers(v.name))

		end

		if v.team == 2 then

		  table.Add(mtfs, role_GetPlayers(v.name))

		end

		if v.team == 6 then

		  table.Add(chaosins, role_GetPlayers(v.name))

		end

		if v.team == 7 then

		  table.Add(gocs, role_GetPlayers(v.name))

		end

		if v.team == 11 then

		  table.Add(usasins, role_GetPlayers(v.name))

		end



	end

	--[[for k,v in pairs(ALLCLASSES["support"]["roles"][2]) do

		table.Add(chaosins, role_GetPlayers(v.name))

	end

	for k,v in pairs(ALLCLASSES["support"]["roles"][3]) do

		table.Add(chaosins, role_GetPlayers(v.name))

	end

	for k,v in pairs(ALLCLASSES["support"]["roles"][4]) do

		table.Add(gocs, role_GetPlayers(v.name))

	end

	for k,v in pairs(ALLCLASSES["support"]["roles"][5]) do

		table.Add(usasins, role_GetPlayers(v.name))

	end

	for k,v in pairs(ALLCLASSES["support"]["roles"][6]) do

		table.Add(dz, role_GetPlayers(v.name))

	end]]



	/*

	for k,v in pairs(ALLCLASSES["security"]["roles"]) do

		if v.team == TEAM_GUARD then

			table.Add(mtfs, role_GetPlayers(v.name))

		end

	end

	*/



	//for k,v in pairs(ALLCLASSES["security"]["roles"]) do

	//	if v.gteams == TEAM_CHAOS then

	//		table.Add(chaosins, role_GetPlayers(v.name))

	//	end

	//end



	//for k,v in pairs(ALLCLASSES["security"]["roles"]) do

	//	if v.gteams == TEAM_GOC then

	//		table.Add(chaosins, role_GetPlayers(v.name))

	//	end

	//end

	//for k,v in pairs(ALLCLASSES["security"]["roles"]) do

	//	if v.gteams == TEAM_USA then

	//		table.Add(usasins, role_GetPlayers(v.name))

	//	end

	//end

	//for k,v in pairs(ALLCLASSES["security"]["roles"]) do

	//	if v.gteams == TEAM_NTF then

	//		table.Add(chaosins, role_GetPlayers(v.name))

	//	end

	//end



	//for k,v in pairs(ALLCLASSES["security"]["roles"]) do

	//	if v.gteams == TEAM_DZ then

	//		table.Add(chaosins, role_GetPlayers(v.name))

	//	end

	//end



	for k,v in pairs(ALLCLASSES["classds"]["roles"]) do

		if v.name == "GOC Spy" then

			table.Add(gocs, role_GetPlayers(v.name))

		end

		--table.Add(classds, role_GetPlayers(v.name))

	end



	for k,v in pairs(ALLCLASSES["researchers"]["roles"]) do

		--if v.name != "SPY DZ" then

		if v.name != "SPY DZ" then

			table.Add(researchers, role_GetPlayers(v.name))

		end

		if v.name == "SPY DZ" then

			table.Add(dz, role_GetPlayers(v.name))

		end

	end

	for k,v in pairs(ALLCLASSES["special"]["roles"]) do

		table.Add(special, role_GetPlayers(v.name))

	end







	local playerlist = {}



	table.ForceInsert(playerlist, {

		name = "SCPs",

		list = gteams.GetPlayers( TEAM_SCP ),

		color = Color(237, 28, 63, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

	  name = "Global Oculation C",

		list = gocs,

		color = Color(184, 134, 11, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

	  name = "Dlan Zmeya",

		list = dz,

		color = Color(46, 139, 87, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

		name = "USA",

		list = usasins,

		color = Color(0, 0, 0, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

		name = "Security",

		list = gteams.GetPlayers( TEAM_GUARD ),

		color = Color(0, 100, 255, 170),

		color2 = color_white

	})



	table.ForceInsert(playerlist,{

		name = "Special Researchers",

		list = special,

		color = Color(238, 130, 238, 170),

		color2 = color_white

	})



	table.ForceInsert(playerlist,{

		name = "Researches",

		list = researchers,

		color = Color(66, 188, 244, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

		name = "Chaos Insurgency",

		list = chaosins,

		color = Color(29, 81, 56, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

		name = "Red Army",

		list = scoreboard_sovets,

		color = Color(255, 0, 0, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

		name = "Germany",

		list = scoreboard_nazis,

		color = Color(90, 90, 90, 170),

		color2 = color_white

	})

	table.ForceInsert(playerlist,{

		name = "Class D Personell",

		list = gteams.GetPlayers( TEAM_CLASSD ),

		color = Color(255, 130, 0, 170),

		color2 = color_white

	})



	table.ForceInsert(playerlist,{

		name = "Spectators",

		list = gteams.GetPlayers( TEAM_SPEC ),

		color = Color(255,255,255,170),

		color2 = color_black

	})



	table.ForceInsert(playerlist,{

	    name = "Nine Tailed Foxes",

		list = ntfs,

		color = Color(0, 0, 255),

		color2 = color_black

	})



	// Sort all

	for k,v in pairs(playerlist) do

		table.sort( v.list, function( a, b ) return a:Frags() > b:Frags() end )



	end



	local color_main = 45



	Frame = vgui.Create( "DFrame" )

	Frame:Center()

	Frame:SetSize(ScrW(), ScrH() )

	Frame:SetTitle( "" )

	Frame:SetVisible( true )

	Frame:SetDraggable( true )

	Frame:SetDeleteOnClose( true )

	Frame:SetDraggable( false )

	Frame:ShowCloseButton( false )

	Frame:Center()

	Frame:MakePopup()

	Frame.Paint = function( self, w, h )





		surface.SetMaterial(head)

		surface.SetDrawColor(255,255,255,250)

		surface.DrawTexturedRect(ScrW() / 5.8, -5, 240, 180)

		surface.SetFont( "HUDFontTitle" );

    surface.SetTextColor( 200, 200, 200, 255 );

    surface.SetTextPos( ScrW() / 2.5, 10 );

    surface.DrawText( "NextOren Breach (Gamemode Version: 2.5.9-C #2)" );

		surface.SetFont( "HUDFontTitle" );

    --[[surface.SetTextColor( 200, 200, 200, 255 );

    surface.SetTextPos( ScrW() / 2.35, 40 );

    surface.DrawText( "Crea" );]]



 	end





	local width = 25



	local mainpanel = vgui.Create( "DPanel", Frame )

	mainpanel:SetSize(ScrW() / 1.5, ScrH() / 1.3)

	mainpanel:CenterHorizontal( 0.5 )

	mainpanel:CenterVertical( 0.5 )

	mainpanel.Paint = function( self, w, h )

		//draw.RoundedBox( 0, 0, 0, w, h, Color( color_main, color_main, color_main, 240 ) )

		--surface.SetMaterial(Material("material/scp.png"))

	end



	local panel_backg = vgui.Create( "DPanel", mainpanel )

	panel_backg:Dock( FILL )

	panel_backg:DockMargin( 8, 50, 8, 8 )

	panel_backg.Paint = function( self, w, h )

		//draw.RoundedBox( 0, 0, 0, w, h, Color( color_main, color_main, color_main, 180 ) )

		--surface.SetMaterial(Material("material/scp.png"))



		surface.SetMaterial(Material("scoreboardnew2.png"))

		surface.SetDrawColor(255, 255, 255, 180)

		surface.DrawTexturedRect(0, 0, w, h )



		surface.SetFont( "MTF_Main" )

	  surface.SetTextColor( 255, 255, 255, 255 )

	  surface.SetTextPos( 10, 0 )

	  surface.DrawText( "NextOren Breach 2.5.9-C #2" )

	end



	local DScrollPanel = vgui.Create( "DScrollPanel", panel_backg )

	DScrollPanel:Dock( FILL )



	local color_dark = Color( 35, 35, 35, 180 )

	local color_light = Color(80,80,80,180)

	local sbar = DScrollPanel:GetVBar()

function sbar:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )

	surface.SetMaterial(Material("material/texture_blanc.png"))

	surface.SetDrawColor(255, 255, 255)

	surface.DrawTexturedRect(0, 0, w, h )

end

function sbar.btnUp:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0 ) )

	surface.SetMaterial(Material("material/red.png"))

	surface.SetDrawColor(255, 255, 255)

	surface.DrawTexturedRect(0, 0, w, h )

end

function sbar.btnDown:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0 ) )

	surface.SetMaterial(Material("material/red.png"))

	surface.SetDrawColor(255, 255, 255)

	surface.DrawTexturedRect(0, 0, w, h )

end

function sbar.btnGrip:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 200, 0 ) )

	surface.SetMaterial(Material("material/menublack.png"))

	surface.SetDrawColor(255, 255, 255)

	surface.DrawTexturedRect(0, 0, w, h )

end

	local panelname_backg = vgui.Create( "DPanel", DScrollPanel )

	panelname_backg:Dock( TOP )

	//if i != 1 then

	//	panelname_backg:DockMargin( 0, 15, 0, 0 )

	//end

	panelname_backg:SetSize(0,width)

	panelname_backg.Paint = function( self, w, h )

		//draw.RoundedBox( 0, 0, 0, w, h, color_dark )





	end



	local panelwidth = 55



	local sbpanels = {

		{

			name = "Пинг",

			size = panelwidth

		},

		{

			name = "Смерти",

			size = panelwidth

		},

		{

			name = "Опыт",

			size = panelwidth

		},

		{

			name = "Уровень",

			size = panelwidth

		}

	}

	if KarmaEnabled() then

		table.ForceInsert(sbpanels, {

			name = "Карма",

			size = panelwidth

		})

	end

	if RanksEnabled() then

		table.ForceInsert(sbpanels, {

			name = "Группа",

			size = panelwidth * 2

		})

	end





	local MuteButtonFix = vgui.Create( "DPanel", panelname_backg )

	MuteButtonFix:Dock(RIGHT)

	MuteButtonFix:SetSize( width - 2, width - 2 )

	MuteButtonFix.Paint = function() end

	for i,pnl in ipairs(sbpanels) do

		local ping_panel = vgui.Create( "DLabel", panelname_backg )

		ping_panel:Dock( RIGHT )

		if i == 1 then

			ping_panel:DockMargin( 0, 0, 25, 0 )

		end

		--local ping = Color(0, 255, 0, 255)

		ping_panel:SetSize(pnl.size, 0)

		ping_panel:SetText(pnl.name)

		ping_panel:SetFont("sb_names")

		ping_panel:SetTextColor(Color(255,255,255,100))

		ping_panel:SetContentAlignment(5)

		ping_panel.Paint = function( self, w, h )

		end

		drawb = !drawb

	end





	local i = 0

	for key,tab in pairs(playerlist) do

		i = i + 1

		if #tab.list > 0 then



			// players

			local panelwidth = 55

			local dark = true

			for k,v in pairs(tab.list) do

				local expplsyrr = v:GetNEXP()

				if v:GetNEXP() == nil then

					expplsyrr = "0"

				end

				if ( v:SteamID() == "STEAM_0:0:29588295" || v:SteamID() == "STEAM_0:1:13462260" ) then continue end

				--local ping = Color(0, 255, 0, 255)



				local panels = {

					{

						name = "Пинг",

						text = "",

						color = color_white,

						size = panelwidth

					},

					{

						name = "Смерти",

						text = v:Deaths(),

						color = color_white,

						size = panelwidth

					},

					{

						name = "Опыт",

						text = expplsyrr,

						color = color_white,

						size = panelwidth

					},

					{

						name = "Уровень",

						text = v:GetNLevel(),

						color = color_white,

						size = panelwidth

					},

				}

				if KarmaEnabled() then

					local tkarma = v:GetKarma()

					if tkarma == nil then tkarma = 999 end

					table.ForceInsert(panels, {

						name = "Карма",

						text = v:GetKarma(),

						color = color_white,

						size = panelwidth

					})

				end

				local rank = v:GetUserGroup()

				if rank == "user" then

					rank = "Игрок"

				end

				if rank == "superadmin" or rank == "Developer" then

					rank = "RXSEND Team"

				end
				
				if rank == "premium" then
					
					rank = "Premium"
				
				end

				if rank == "spectator" then

					rank = "Смотритель"

				end
				
				if v:SteamID64() == "76561197987190249" then --культист
					
					rank = "NO Team"
				
				end
				
				if v:SteamID64() == "76561198019442318" then --варус
					
					rank = "NO Team"
				
				end
				
				if v:SteamID64() == "76561198286190382" then --буржуазия
				
					rank = "NO Team"
				
				end
				
				if v:SteamID64() == "76561198049524525" then --шварц
				
					rank = "NO Team"
				
				end

				if v:SteamID() == "STEAM_0:1:95927294" then --суох

					rank = "RXSEND Team"

				end

				if v:SteamID() == "STEAM_0:1:233420776" then --сыс

					rank = "Respectable"

				end

				if rank == "testadmin" or rank == "admin" then

					rank = "Администратор"

				end

				if rank == "Смотрящийдебил" then

					rank = "Смотритель"

				end

				if rank == "HeadAdmin" then

					rank = "Главный АДМ"

					--ded = Color(255,0,0)

				end

				rank = firstToUpper(rank)

				if RanksEnabled() then

					table.ForceInsert(panels, {

						name = "Группа",

						text = rank,

						ded = color_white,

						size = panelwidth * 2

					})

				end



				local scroll_panel = vgui.Create( "DPanel", DScrollPanel )

				scroll_panel:Dock( TOP )

				scroll_panel:DockMargin( 0,5,0,0 )

				scroll_panel:SetSize(0,width)

				//scroll_panel.clr = gteams.GetColor(v:GTeam())

				scroll_panel.clr = tab.color



				if not v.GetNClass then

					player_manager.RunClass( v, "SetupDataTables" )

				end

				scroll_panel.Paint = function( self, w, h )

					if !IsValid(v) or not v then

						Frame:Close()

						return

					end



					local vclass = "ERROR"

					local txt = "ERROR"

					if not v.GetNClass then

						player_manager.RunClass( v, "SetupDataTables" )

					else

						vclass = v:GetNClass()

						txt = GetLangRole(vclass)

					end

					local tcolor = scroll_panel.clr

				if v:GTeam() == TEAM_CHAOS then

						if LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_CLASSD then

							tcolor = Color(29, 81, 56, 120)

						else

							if vclass == ROLES.ROLE_CHAOSSPY then

								txt = GetLangRole(ROLES.ROLE_CHAOSSPY)

							end

						end

					end

					if txt == "Шпион Повстанцев Хаоса" then

						txt = "ШПХ"

					end

					if txt == "Шпион Длани Змея" then

						txt = "ШДЗ"

					end

					--[[if v:GTeam() == TEAM_SCP then

						txt = "SCP Объект"

					end]]

					--print(v:Nick(), v:GetFriendStatus())



          local cop = tab.color2



					local Zatemn = math.abs(math.sin(CurTime() * 2) * 255)

					--[[local friend = math.abs(math.sin(CurTime() * 1) * 255)

					if v:GetFriendStatus() == "friend" then

						if !v:IsAdmin() then

						  cop = ColorAlpha(tab.color2, friend)

						else

							cop = Color(255,0,0,Zatemn)

						end



					end]]

					if v:IsAdmin() and v:GTeam() != TEAM_SCP then

						cop = Color(255,0,0, 220)

					end

          if v:GetUserGroup() == "testadmin" then

						cop = Color(127, 255, 212, 220)

					end

					if v:IsAdmin() and v:GTeam() == TEAM_SCP then

						cop = Color(0,0,0, 255)



					end

					if v == LocalPlayer() then

            if !v:IsAdmin() then

						  cop = ColorAlpha(tab.color2, Zatemn)

						else

							cop = Color(255,0,0, Zatemn)

						end



					end



					draw.RoundedBoxEx( 8, 0, 0, w, h, tcolor, true, true, true, true )

					local texttodraw = string.sub(v:Nick(), 1, 18)
					--[[
					if v:Nick() == "Loaskyial [Varus] SUS" then

						texttodraw = "DickFaggetson"

					end
					--]]
					--[[
					if v:Nick() == "Cultist_kun" or v:SteamID() == "STEAM_0:1:13462260" then

						texttodraw = "TheCowardlyFa**ot"

					end
					--]]
					draw.Text( {

						text = texttodraw,

						pos = { width + 2, h / 2 },

						font = "sb_names",

						color = cop,

						xalign = TEXT_ALIGN_LEFT,

						yalign = TEXT_ALIGN_CENTER

					})

					--[[hook.Add( "HUDPaint", "MyRect", function()

	          surface.SetDrawColor( 0, 0, 0, 180 )

	          surface.DrawRect( width + 150, 0, 125, h )

          end )]]

					draw.RoundedBoxEx(8, width + 150, 0, 125, h, Color(0,0,0,120),true,true,true,true)

					--print(h)

					draw.Text( {

						text = txt,

						pos = { width + 212, h / 2 },

						font = "sb_names",

						color = tab.color2,

						xalign = TEXT_ALIGN_CENTER,

						yalign = TEXT_ALIGN_CENTER

					})

					local panel_x = w / 1.1175

					local panel_w = w / 14

					--print(tab.Color2)

				end



				local MuteButton = vgui.Create( "DButton", scroll_panel )

				MuteButton:Dock(RIGHT)

				MuteButton:SetSize( width - 4, width - 4 )

				MuteButton:SetText( "" )

				MuteButton.DoClick = function()

					v:SetMuted( !v:IsMuted() )

					if v:IsMuted() then

					  RXSENDNotify("Игрок " .. v:Nick() .." был заглушен для вас")

					end

					if !v:IsMuted() then

					  RXSENDNotify("Теперь вы слышите игрока " .. v:Nick())

					end

				end

				MuteButton.Paint = function( self, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255,0) )

				end



				local MuteIMG = vgui.Create( "DImage", MuteButton )

				MuteIMG.img = "icon32/unmuted.png"

				MuteIMG:SetPos( MuteButton:GetPos() )

				MuteIMG:SetSize( MuteButton:GetSize() )

				MuteIMG:SetImage( "icons32/unmuted.png" )

				MuteIMG.Think = function( self, w, h )

					if !IsValid(v) then return end

					if v:IsMuted() then

						self.img = "icon32/muted.png"

					else

						self.img = "icon32/unmuted.png"

					end

					self:SetImage( self.img )

				end





				local drawb = true

				for i,pnl in ipairs(panels) do

					local ping_panel = vgui.Create( "DLabel", scroll_panel )

					ping_panel:Dock( RIGHT )

					if i == 1 then

						ping_panel:DockMargin( 0, 0, 25, 0 )

					end

					ping_panel:SetSize(pnl.size, 0)

					ping_panel:SetText(pnl.text)

					ping_panel:SetFont("sb_names")

					ping_panel:SetTextColor(tab.color2)

					ping_panel:SetContentAlignment(5)

					if drawb then

						ping_panel.Paint = function( self, w, h )

							ping_panel:SetText(pnl.text)

							draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,120) )

							--[[if v:IsValid() then

								if v:Ping() < 100 then

									ping = Color(0, 255, 0, 255)

									ping = Color(0, 255, 0, 255)

									ping = Color(0, 255, 0, 255)

								elseif v:Ping() < 225 then

									ping = Color(255, 255, 0, 255)

									ping = Color(255, 255, 0, 255)

									ping = Color(155, 155, 155, 255)

								else

									ping = Color(255, 0, 0, 255)

									ping = Color(155, 155, 155, 255)

									ping = Color(155, 155, 155, 255)

								end

							end]]

							if v:IsValid() and v:IsPlayer() then

								--print(ping_panel, pnl.text)

								--local pingcolor = Color(255,255,255,150)

								if pnl.name == "Пинг" then

								if v:Ping() < 100 then

									draw.RoundedBox(0,40,20,4,4,Color(0, 255, 0, 255))

									draw.RoundedBox(0,45,16,4,8,Color(0, 255, 0, 255))

									draw.RoundedBox(0,50,12,4,12,Color(0, 255, 0, 255))

									--pingcolor = Color(255,255,255,150)

								elseif v:Ping() < 225 then

									draw.RoundedBox(0,40,20,4,4,Color(255, 255, 0, 255))

									draw.RoundedBox(0,45,16,4,8,Color(255, 255, 0, 255))

									draw.RoundedBox(0,50,12,4,12,Color(155, 155, 155, 255))

									--pingcolor = Color(255,255,255,150)

								else

									draw.RoundedBox(0,40,20,4,4,Color(255, 0, 0, 255))

									draw.RoundedBox(0,45,16,4,8,Color(155, 155, 155, 255))

									draw.RoundedBox(0,50,12,4,12,Color(155, 155, 155, 255))



								end

								draw.DrawText(v:Ping().." ms", "sb_names", 46, 4, Color(255, 255, 255, 150),TEXT_ALIGN_RIGHT)

							  end



								--draw.DrawText(v:Ping().."ms", "Cyb_HudTEXTSmall", 33, 3, Color(255, 255, 255, 150),TEXT_ALIGN_RIGHT)

							end

						end

					end

					drawb = !drawb

				end



				--[[local oName = vgui.Create("BLabel",scroll_panel)

				oName:SetTextColor(Color(0,0,0))

				--local ply = player.GetBySteamID64(v)

				if (IsValid(v)) then

					--ip.OnlineIndicator:SetImage("icon16/user_green.png")

					--oName:SetText(ply:Nick())

          print(v:GetNWString("blogs_country"))

					if (v:GetNWString("blogs_country")) then



						if (file.Exists("materials/flags16/" .. v:GetNWString("blogs_country"):lower() .. ".png","GAME")) then

							flag:SetVisible(true)

							flag:SetImage("flags16/" .. v:GetNWString("blogs_country"):lower() .. ".png")

						end

					end

				else

					oName:SetText(v)

				end]]

				local Avatar = vgui.Create( "AvatarImage", scroll_panel )

				Avatar:SetSize( width, width )

				Avatar:SetPos( 0, 0 )

				Avatar:SetPlayer( v, 32 )

				local Avatarprofile = vgui.Create( "DButton", scroll_panel )

				Avatarprofile:SetSize( width, width )

				Avatarprofile:SetPos( 0, 0 )

				Avatarprofile:SetPlayer( v, 32 )

				Avatarprofile:SetText("")

				--[[Avatarprofile.DoClick = function()

					gui.OpenURL( "https://steamcommunity.com/profiles/"..v:SteamID64() )

				end]]

				Avatarprofile.DoRightClick = function()

					local menu = DermaMenu()

			    --menu.Player = self:GetPlayer()



			    --local close = GAMEMODE:ScoreboardHide()

			    --if !close then menu:Remove() return end



			    local CopyMenu = menu:AddSubMenu("Скопировать")

			    CopyMenu:AddOption("SteamID", function()

			    	SetClipboardText(v:SteamID())

			    end):SetIcon("icon16/page_copy.png")



			    CopyMenu:AddOption("SteamID64", function()

			    	SetClipboardText(v:SteamID64())

			    end):SetIcon("icon16/page_copy.png")

					CopyMenu:AddOption("Скопировать имя", function()

						if !v:IsSuperAdmin() then

							SetClipboardText(v:Nick())

						else

							surface.PlaySound("ambient/levels/citadel/citadel_ambient_scream_loop1.wav")

							LocalPlayer():ChatPrint("Не делай этого....")

							SetClipboardText("Kill yourself")

							timer.Simple(1, function() LocalPlayer():ChatPrint("Тебя предупреждали...") end)

						end

						surface.PlaySound("buttons/button9.wav")

					end):SetImage("icon16/tag_blue.png")

					if LocalPlayer():IsAdmin() then

					menu:AddSpacer()



					local adminmenu = menu:AddSubMenu("Администратор")



						adminmenu:AddOption("Замутить", function() RunConsoleCommand("ulx","mute",v:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/comment_delete.png")

            adminmenu:AddOption("Размутить", function() RunConsoleCommand("ulx","unmute",v:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/comment.png")

            adminmenu:AddOption("Гаг", function() RunConsoleCommand("ulx","gag",v:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/sound_delete.png")

            adminmenu:AddOption("Ангаг", function() RunConsoleCommand("ulx","ungag",v:Nick()) surface.PlaySound("buttons/button9.wav") end):SetImage("icon16/sound.png")



					menu:AddSpacer()

				  end

			    menu:AddOption("Открыть профиль в стиме", function()

			    	v:ShowProfile()

						surface.PlaySound("buttons/button9.wav")

			    end):SetIcon("icon16/world_link.png")

          menu:AddOption("Закрыть", function()

					  print("Closed")

					end):SetIcon("icon16/cross.png")

			    menu:AddSpacer()



			    menu:Open()



        end

				function menu:CloseSubMenu(menu)

					menu:Hide()

         	self:SetOpenSubMenu( nil )

				end

				Avatarprofile.Paint = function(self, w, h)

					draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255,0) )

					--print("lol")

					if v:IsSuperAdmin() or v:GetUserGroup() == "Developer" then

						surface.SetDrawColor(255, 255, 255, 180);

			      surface.SetMaterial(Material("icon16/wrench.png"));

			      surface.DrawTexturedRect(0,0, 12, 12);

						surface.SetDrawColor( Color( 255, 0, 0, Pulsate(2)*180 ) )

						surface.DrawOutlinedRect( 0, 0, w, h )

					end

				end

				--[[local flag = vgui.Create("DImage", scroll_panel)



				flag:SetSize( 16, 12 )



				flag:SetPos(ScrW() / 1.575, 12)



				flag:SetImage("flags16/ru.png")

				flag:SetVisible(true)

				flag.Think = function(self, w, h)

					if !IsValid(v) then return end

          if v:SteamID() == "STEAM_0:1:13462260" then

						flag:SetVisible(true)

						flag:SetImage("flags16/de.png")

					end

					if v:SteamID() == "STEAM_0:0:29588295" then

						flag:SetVisible(true)

						flag:SetImage("flags16/cz.png")

					end

					if (v:GetNWString("blogs_country")) then

            if v:SteamID() == "STEAM_0:0:29588295" or v:SteamID() == "STEAM_0:1:13462260" then return end

						if (file.Exists("materials/flags16/" .. v:GetNWString("blogs_country"):lower() .. ".png","GAME")) then

							flag:SetVisible(true)

							flag:SetImage("flags16/" .. v:GetNWString("blogs_country"):lower() .. ".png")

						end

					end



				end]]

			end



		end

	end

end



function GM:ScoreboardShow()

	ShowScoreBoard()

end



function GM:ScoreboardHide()



	if IsValid(DermaMenu()) then

		DermaMenu():Hide()

	end



	if IsValid(Frame) then

		Frame:Close()

	end

end



