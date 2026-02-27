--[[
gamemodes/breach/gamemode/cl_targetid.lua
--]]

hook.Add("HUDDrawTargetID", "DrawSCPInfo", function()
	local trace = LocalPlayer():GetEyeTrace()

	if !trace.Hit then return end

	if !trace.HitNonWorld then return end

	if !ply:IsValid() then return end

	if LocalPlayer():GTeam() == TEAM_SPEC then return end

	local text = clang.class_unknown or "Unknown"

	local font = "TargetID"

	local ply =  trace.Entity

	local multiplier = 2 -- Увеличение эффекта ника



	local clr = color_white

	if ply:IsPlayer() then

		local clr2 = Color(255,255,255,255 - ply:GetPos():Distance(LocalPlayer():GetPos()) + multiplier)

	end
if ply:IsPlayer() then

	if ply:GTeam() == TEAM_SCP  then

		  local hide = false

				if (LocalPlayer():GTeam() == TEAM_SCP) or (LocalPlayer():GTeam() == TEAM_DZ) then

			    hide = false



						draw.Text( {

		        text = " Существо: " ..ply:Nick(),

		        pos = { ScrW() / 2, ScrH() / 2 + 25 },

		        font = "SafeZone_INFO",

		        color = Color(255, 0, 0),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	          })

						local clrhp = Color(112, 128, 144)

						local lowhp = math.abs(math.sin(CurTime() * 4) * 255)

						if ply:Health() <= 1000 then

							clrhp = Color(180, 0, 0, lowhp)

							draw.Text( {

			        text = " КРИТИЧЕСКОЕ СОСТОЯНИЕ ",

			        pos = { ScrW() / 2, ScrH() / 2 + 75 },

			        font = "SafeZone_INFO",

			        color = clrhp,

			        xalign = TEXT_ALIGN_CENTER,

			        yalign = TEXT_ALIGN_CENTER,

		          })

							draw.Text( {

							text = " SCP Number: " ..GetLangRole(ply:GetNClass()),

							pos = { ScrW() / 2, ScrH() / 2  },

							font = "SafeZone_INFO",

							color = Color(120, 170, 0),

							xalign = TEXT_ALIGN_CENTER,

							yalign = TEXT_ALIGN_CENTER,

							})

						end

						draw.Text( {

		        text = " Здоровье существа: " ..ply:Health().. "/" ..ply:GetMaxHealth(),

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = clrhp,

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	          })

						if ply:GetNClass() == ROLES.ROLE_SCP082 then

						draw.Text( {

		        text = " SCP-082 агрессия: " .. math.Round(100/900 * ply:GetNWFloat("amountDamage")) .. "%",

		        pos = { ScrW() / 2, ScrH() / 2 + 100 },

		        font = "SafeZone_INFO",

		        color = Color(112, 128, 144),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	          })

					  end



				end

				if hide == true then return end

		end
	end
end)

function GM:HUDDrawTargetID()

	local trace = LocalPlayer():GetEyeTrace()

	if !trace.Hit then return end

	if !trace.HitNonWorld then return end

	if !ply:IsValid() then return end

	if LocalPlayer():GTeam() == TEAM_SPEC then return end

	local text = clang.class_unknown or "Unknown"

	local font = "TargetID"

	local ply =  trace.Entity

	local multiplier = 2 -- Увеличение эффекта ника



	local clr = color_white

	if ply:IsPlayer() then

		local clr2 = Color(255,255,255,255 - ply:GetPos():Distance(LocalPlayer():GetPos()) + multiplier)

	end



	if ply:IsPlayer() then

		if ply:Alive() == false then return end



		if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) > 40000 then return end

		if not ply.GetNClass then

			player_manager.RunClass( ply, "SetupDataTables" )

		end

		if ply:GTeam() == TEAM_SPEC then return end

		--if ply:GTeam() == TEAM_SCP then return end

		if ply:GetNWBool( 'IsInsideLocker', true ) then return end

		if ply:GetNClass() == ROLES.ROLE_SCP966 then

			local hide = true

			if IsValid(LocalPlayer():GetActiveWeapon()) then

				if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then

					hide = false

				end

			end

			if (LocalPlayer():GTeam() == TEAM_SCP) then

				hide = false

			end

			if hide == true then return end

		end

		if ply:GetNClass() == ROLES.ROLE_CHAOSSPY then

			local hide = false



			if (LocalPlayer():GTeam() == TEAM_CHAOS) then

			    hide = false

				draw.Text( {

		        text = " Ваш союзник ",

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = Color(112, 128, 144),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	            })

			end

			if hide == true then return end

		end

		if ply:GTeam() == TEAM_DZ then

			local hide = false



			if (LocalPlayer():GTeam() == TEAM_SCP) then

			    hide = false

				draw.Text( {

		        text = " Ваш союзник ",

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = Color(112, 128, 144),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	            })

			end

			if hide == true then return end

		end

		if ply:GTeam() == TEAM_GUARD or ply:GetNClass() == ROLES.ROLE_CHAOSSPY then

			local hide = false



			if (LocalPlayer():GetNClass()  == ROLES.ROLE_MTFGeneral) then

			    hide = false

				draw.Text( {

		        text = " Сотрудник ",

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = Color(0, 0, 139),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	            })

			end

			if hide == true then return end

		end

		if ply:GetNClass() == ROLES.ROLE_SCP1471 then

			local hide = true

			if IsValid(LocalPlayer():GetActiveWeapon()) then

				if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then

					hide = false

				end

			end

			if (LocalPlayer():GTeam() == TEAM_SCP) then

				hide = false

			end

			if hide == true then return end

		end

		if ply:GTeam() == TEAM_SCP then

			text = GetLangRole(ply:GetNClass())

			clr = gteams.GetColor(ply:GTeam())

		else

			for k,v in pairs(SAVEDIDS) do

				if v.pl == ply then

					if v.id != nil then

						if isstring(v.id) then

							text = v.pl.knownrole

							clr = gteams.GetColor(ply:GTeam())

							text = GetLangRole(v.pl.knownrole)

						end

					end

				end

			end

		end

		AddToIDS(ply)

	else

		return

	end



	local x = ScrW() / 2

	local y = ScrH() / 2 + 30





  --[[if ply:GTeam() != TEAM_SCP then

	draw.Text( {

		text = ply:Nick() .. " ",

		pos = { x, y },

		font = "HUDFontTitle",

		color = clr2,

		xalign = TEXT_ALIGN_CENTER,

		yalign = TEXT_ALIGN_CENTER,

	})

end]]

end

local szmat = Material("icon16/star.png")

local function DrawTargetID()

	if LocalPlayer():GTeam() == TEAM_SPEC then return end



	local tr = LocalPlayer():GetEyeTraceNoCursor()

	local ply = tr.Entity

--if ( ply:SteamID() == "STEAM_0:0:64560624" ) then return true end

	if !IsValid(ply) then return true end

  if !ply:IsPlayer() then return true end

	if !ply:Alive() then return true end

	--if ( ply:Nick() == "Tolya Pechenushkin" ) then return true end

	if ply:GetNWBool('IsInsideLocker') == true then return true end

	if ply:Crouching() then return true end

	if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then return true end

	local offset = Vector( 0, 0, 85 )

  local ang = LocalPlayer():EyeAngles()

  local pos = ply:GetPos() + offset + ang:Up()

	ang:RotateAroundAxis( ang:Forward(), 90 )

  ang:RotateAroundAxis( ang:Right(), 90 )

	local nickp = ply:GetName()

	local spos = pos:ToScreen()

  local center = LocalPlayer():GetPos():ToScreen()



	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )

		if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) < 40000 then



			if ply:IsSuperAdmin() or ply:GetUserGroup() == "Developer" or ply:SteamID() == "STEAM_0:1:95927294" or ply:SteamID() == "STEAM_0:1:233420776" then

				draw.DrawText( "RXSEND Team", "char_title", 2, -24, Color( 255, 0, 0, 220 ), TEXT_ALIGN_CENTER )

				surface.SetDrawColor( Color( 255, 0, 0, 220 ) )

				surface.DrawOutlinedRect( -180, -22, ScrW() / 5.3, 50 )

				surface.DrawOutlinedRect( -180, -23.3, ScrW() / 5.3, 52 )

				draw.RoundedBox(0,-180, -22,ScrW() / 5.3, 50,Color( 0, 0, 0, 120 ))

			end



	    draw.DrawText( nickp, "char_title", 2, 22, Color( 255, 255, 255, 220 ), TEXT_ALIGN_CENTER )

	    surface.SetFont("char_title")

	    local sizex,_ = surface.GetTextSize( nickp )

			if ply:GetNClass() == ROLES.ROLE_MTFCOM or ply:GetNClass() == ROLES.ROLE_MTFL then

		    surface.SetDrawColor( 0, 0, 255, 255 )

		    surface.SetMaterial( szmat ) -- If you use Material, cache it!

		    surface.DrawTexturedRect( -((sizex/2)+32), 30, 32, 32 )

			end

		end

	cam.End3D2D()

end







hook.Add( "PostDrawOpaqueRenderables", "DrawTargetID", DrawTargetID )



