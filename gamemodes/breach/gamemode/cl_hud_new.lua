--[[
gamemodes/breach/gamemode/cl_hud_new.lua
--]]

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudDeathNotice = true,
}
function GM:HUDDrawPickupHistory( )
end
--[[
function GM:HUDPaint() --Show magazines on hud, by UracosVereches
if LocalPlayer():GetActiveWeapon().CW20Weapon then

local mags = 0
local ammo = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
local clip_size = LocalPlayer():GetActiveWeapon():GetMaxClip1()
if clip_size == 31 then
	clip_size = clip_size - 1
end
--LocalPlayer():ChatPrint(clip_size)
if mags > 0 and mags < 1 then
	mags = 1
else
	mags = math.ceil(ammo / clip_size)
end

	draw.SimpleTextOutlined("MAGS: "..mags, "CW_HUD20", ScrW() * 0.5, ScrH() * 0.87, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color(0, 0, 0, 255))
	--draw.SimpleTextOutlined("(DEBUG) Патроны: "..ammo, "TargetID", ScrW() * 0.5, ScrH() * 0.87, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color(0, 0, 0, 255))
end
end
--]]

net.Receive("UnderhellLocation", function()
	if UH_Location_Color != nil then
		if UH_Location_Color != 0 and UH_Location_Color > 100 then
			UH_Location = net.ReadString()
			return
		end
	end
	timer.Remove("Remove_UH_Location")
	timer.Remove("uh_location_linear_color")
	timer.Remove("Decrease_UH_Location_Color")
	UH_Location = net.ReadString()
	Current_UH_Location = UH_Location
	timer.Create("Remove_UH_Location", 10, 1, function()
		UH_Location = nil
		Current_UH_Location = nil
	end)
	timer.Create("Decrease_UH_Location_Color", 5, 1, function()
		timer.Remove("uh_location_linear_color")
		local ratio = 0
		local time = 0
		UH_Location_Color = 255

		timer.Create("uh_location_linear_color", FrameTime(), 999999999, function()
		    ratio = 0.007 + ratio
		    time = time + FrameTime()
		    UH_Location_Color = Lerp(ratio, 255, 0)
		end)
	end)

	local ratio = 0
	local time = 0
	UH_Location_Color = 0

	timer.Create("uh_location_linear_color", FrameTime(), 999999999, function()
	    ratio = 0.007 + ratio
	    time = time + FrameTime()
	    UH_Location_Color = Lerp(ratio, 0, 255)
	end)

end)

hook.Add("HUDPaint", "UnderhellLocation_Draw", function()
	if UH_Location != nil then
		draw.SimpleTextOutlined(UH_Location, "ScoreboardDefault", ScrW() * 0.75, ScrH() * 0.6, Color(255, 255, 255, UH_Location_Color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color(0, 0, 0, UH_Location_Color))
	end
end)

net.Receive("BreachNotifyFromServer", function()
	local message = net.ReadString()

	if message == nil then return end
		chat.AddText(Color(0, 230, 0), "[RXSEND] ", Color(255, 255, 255), message)
end)

net.Receive("BreachWarningFromServer", function()
	local message = net.ReadString()

	if message == nil then return end
		chat.AddText(Color(230, 0, 0), "[RXSEND] ", Color(255, 150, 150), message)
end)

function RXSENDNotify(message)
if message == nil then return end
message = tostring(message)
		chat.AddText(Color(0, 230, 0), "[RXSEND] ", Color(255, 255, 255), message)
end

function RXSENDWarning(message)
if message == nil then return end
message = tostring(message)
		chat.AddText(Color(230, 0, 0), "[RXSEND] ", Color(255, 150, 150), message)
end

hook.Add( "HUDShouldDraw", "HideHUDElements", function( name )
	if name == "CHudWeaponSelection" then
		return false
	end
	if hide[ name ] then return false end
end )
-- Hotfix 16.08 (Disable CHudCrosshair)
hook.Add("HUDShouldDraw", "Turnoffthisshittycrosshair", function (name)
	if (name == "CHudCrosshair") then
		return false
	end
end)

function draw.OutlinedBox( x, y, w, h, thickness, clr ) --from garry's mod wiki
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

function Pulsate(c) --Использование флешей
  return (math.abs(math.sin(CurTime()*c)))
end

function Fluctuate(c) --used for flashing colors
	return (math.cos(CurTime()*c)+1)/2
end

local XpAddInc = false
local XPPos = 0
local XPgained = 0
local newClassDescc = ""
local LevelUpIncnext = false
local LevelUpIncnext2 = false
local LevelUpAlpha = 0
local LevelUpAlpha3 = 0
local radiohud = 0

hook.Add( "HUDPaint", "EXPNotification", function()

	if ( !XpAddInc ) then return end

	if XpAddInc == true then
    -- XP Awarded
  	if XPPos < 100 then
    	XPPos = XPPos + 3
  	end
  else
    if XPPos > 0 then
      XPPos = XPPos - 3
    end
  end
	draw.RoundedBox(0, ScrW() - XPPos, ScrH() / 4, 100, 35, Color(0, 0, 0, 155))
	--draw.RoundedBox(0, ScrW() - XPPos, ScrH() / 4, 120, 35, Color(255, 0, 0, 155))
	surface.SetDrawColor( Color( 255, 0, 0, Pulsate(2)*180 ) )
	surface.DrawOutlinedRect( ScrW() - XPPos, ScrH() / 4, 100, 35 )
	if XpAddInc == true then
		draw.RoundedBox(0, ScrW() - XPPos - 31, ScrH() / 4, 30, 35, Color(0, 0, 0, 155))
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawOutlinedRect( ScrW() - XPPos - 31, ScrH() / 4, 30, 35 )
		surface.SetDrawColor( Color(255, 255, 255, 255) )
		surface.SetMaterial(Material("lvl6.png"))
		surface.DrawTexturedRect(ScrW() - XPPos - 51,	ScrH() / 4.25, 64, 64)
	end
	-- XP Award BG
	draw.DrawText("+"..XPgained.." XP", "HUDFontTitle", ScrW() - (XPPos - 24), (ScrH() / 4) + 6, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	if LevelUpIncnext == true then
    if LevelUpAlpha < 255 then
    	LevelUpAlpha = LevelUpAlpha + 1
    end
  else
  	if LevelUpAlpha > 0 then
      LevelUpAlpha = LevelUpAlpha - 1
    end
  end
	draw.RoundedBox(0, 0, (ScrH() / 2) - 25, ScrW(), 50, Color(0, 0, 0, LevelUpAlpha - 100))
	draw.RoundedBox(0, ScrW() / 2.08, (ScrH() / 2.2) - 25, 64, 50, Color(0, 0, 0, LevelUpAlpha - 100))
	----------[SCP Icon]----------
	surface.SetDrawColor( Color(255, 255, 255, 0 + LevelUpAlpha) )
	surface.SetMaterial(Material("breachiconfortipslvlup.png"))
	surface.DrawTexturedRect(ScrW() / 2.08, (ScrH() / 2.23) - 25, 64, 64)
	----------[end]----------
	surface.SetDrawColor( Color( 0, 0, 0, 0 + LevelUpAlpha) )
	surface.DrawOutlinedRect( ScrW() / 2.08, (ScrH() / 2.2) - 25, 64, 50 )
	surface.DrawOutlinedRect( 0, (ScrH() / 2) - 25, ScrW(), 50 )
  draw.SimpleTextOutlined("Новый уровень!", "char_title24", ScrW() / 2, ScrH() / 2, Color(77, 67, 57, LevelUpAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(255, 255, 255, LevelUpAlpha))
	if LevelUpIncnext == true then
		-- Level up
		if LevelUpAlpha3 < 255 then
			LevelUpAlpha3 = LevelUpAlpha3 + 1
		end
	else
		if LevelUpAlpha3 > 0 then
			LevelUpAlpha3 = LevelUpAlpha3 - 1
		end
	end
	draw.RoundedBox(0, 0, (ScrH() / 2) + 25, ScrW(), 50, Color(0, 0, 0, LevelUpAlpha3 - 100))
	draw.SimpleTextOutlined("ОТКРЫТО: " .. newClassDescc, "char_title36", ScrW() / 2, ScrH() / 2 + 50, Color(77, 67, 57, LevelUpAlpha3), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(255, 255, 255, LevelUpAlpha3))

end )

hook.Add( "HUDPaint", "Breach_HUD", function()

	local ply = LocalPlayer()
	if ( !ply:Alive() ) then return end

	local w = 48
	local h = 48
	local y = ScrH() - 35
	local color = Color( 255, 100, 0, 255 )

  local scale = hudScale
	local widthz = ScrW() * scale
	local heightz = ScrH() * scale
	local offset = ScrH() - heightz

	local bd = GetConVar("br_time_blinkdelay"):GetFloat()
	local blink = blinkHUDTime




  if IsValid( ply ) then
		if ply:GTeam() == TEAM_SPEC then
			local ent = ply:GetObserverTarget()
			--local obsstamina = ent.Stamina
			if IsValid(ent) then
				if ent:IsPlayer() then
					local teamclr = gteams.GetColor(ent:GTeam())
					--print(teamclr)
					local sw = 350
					local sh = 35
					local sx =  ScrW() / 2 - (sw / 2)
					local sy = 0
					draw.RoundedBox(8, sx, sy, sw, sh, Color(teamclr.r,teamclr.g,teamclr.b,200))
					--draw.OutlinedBox( 8, 0, 0, sw, sh, Color( 0, 0, 0, 255 ) )
					draw.TextShadow( {
						text = string.sub(ent:Nick(), 1, 17),
						pos = { sx + sw / 2, 15 },
						font = "HealthAmmo",
						color = Color(255,255,255),
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER,
					}, 2, 255 )
				end
			end
		end
	  local role = "none"
		if not ply.GetNClass then
			player_manager.RunClass( ply, "SetupDataTables" )
		elseif LocalPlayer():GTeam() != TEAM_SPEC then
			role = GetLangRole(ply:GetNClass())
		else
			local obs = ply:GetObserverTarget()
			role = GetLangRole(ply:GetNClass())
			if IsValid(obs) then
				if obs.GetNClass != nil then
					role = GetLangRole(obs:GetNClass())
					ply = obs
					--print(obs.stamina)
				end
			end
		end
		local hp = ply:Health()
		local maxhp = ply:GetMaxHealth()
		if !LocalPlayer().Stamina then LocalPlayer().Stamina = 100 end
		local stamina = math.Round(LocalPlayer().Stamina)
		local exhausted = LocalPlayer().exhausted
		local color = gteams.GetColor(ply:GTeam())

		--[[if ply:GetActiveWeapon() != nil then
			local wep = ply:GetActiveWeapon()
			if wep.Clip1 and wep:Clip1() > -1 then
				ammo = wep:Clip1()
				mag = ply:GetAmmoCount( wep:GetPrimaryAmmoType() )
			end
		end]]



		local color = gteams.GetColor( ply:GTeam() )

		if ply:GTeam() == TEAM_CHAOS then

			color = Color(29, 81, 56)

		elseif ply:GTeam() == TEAM_GOC then

			color = Color(178, 34, 34)

		elseif ply:GTeam() == TEAM_USA then

			color = Color(0, 0, 0)

		elseif ply:GTeam() == TEAM_DZ then

			color = Color(46, 139, 87)

		end
 	if ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP then

		----------------------------[BLINKhud]----------------------------
	--[[
		if var == nil then var = 100; end
    draw.RoundedBox(0, 10, ScrH()-50-100, 40, 40, Color(0, 0, 0));
    draw.RoundedBox(0, 60, ScrH()-44-100, 211, 28, Color(0, 0, 0, 200));
    surface.SetDrawColor(255, 255, 255);

    surface.SetMaterial(Material("nextoren_hud/ico_blink.png"));
    surface.DrawTexturedRect(13, ScrH()-47-100, 34, 34);

    surface.SetDrawColor(255, 255, 255, 75);
    surface.DrawOutlinedRect(10, ScrH()-50-100, 40, 40);

    surface.DrawOutlinedRect(60, ScrH()-44-100, 211, 28);

    surface.SetDrawColor(255, 255, 255, 200);
    surface.SetMaterial(Material("nextoren_hud/ico_index2.png"));
		local bbars = 0
		local bbars = blink / bd * 16
		if bbars > 16 then bbars = 16 end
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("nextoren_hud/ico_index2.png"))
		for i=1, bbars do
			surface.DrawTexturedRect(62 + (i-1)*13, ScrH()-42-100, 12, 24);
		end
		blink = string.format("%.1f", blink)
		bd = string.format("%.1f", bd)
	--]]

	----------------------------[STAMINAhud]----------------------------

    draw.RoundedBox(0, 10, ScrH()-50-50, 40, 40, Color(0, 0, 0));
    draw.RoundedBox(0, 60, ScrH()-44-50, 211, 28, Color(0, 0, 0, 200));
    surface.SetDrawColor(255, 255, 255);

    surface.SetMaterial(Material("nextoren_hud/ico_stamina.png"));
    surface.DrawTexturedRect(13, ScrH()-47-50, 34, 34);
    local staminab = math.Round(stamina / 100 * 16)
    if staminab > 16 then staminab = 16 end
		surface.SetDrawColor(245, 255, 250)
    surface.SetDrawColor(255, 255, 255, 75);
    surface.DrawOutlinedRect(10, ScrH()-50-50, 40, 40);
		surface.DrawOutlinedRect(60, ScrH()-44-50, 211, 28);

		surface.SetDrawColor(255, 255, 255, 200);

    surface.SetMaterial(Material("nextoren_hud/ico_index2.png"));
    if exhausted then surface.SetMaterial(Material("nextoren_hud/ico_index.png")) end
    for i = 1, staminab do
        surface.DrawTexturedRect(62 + (i-1)*13, ScrH()-42-50, 12, 24);
    end
	end
		if ply:GTeam() != TEAM_SPEC then
			----------------------------[HPhud]----------------------------

			draw.RoundedBox(0, 10, ScrH()-50, 40, 40, Color(0, 0, 0));
			draw.RoundedBox(0, 60, ScrH()-44, 211, 28, Color(0, 0, 0, 200));
			surface.SetDrawColor(255, 255, 255);
			surface.SetMaterial(Material("nextoren_hud/ico_health.png"));
			surface.DrawTexturedRect(13, ScrH()-47, 34, 34);

			surface.SetDrawColor(255, 255, 255, 75);
			surface.DrawOutlinedRect(10, ScrH()-50, 40, 40);

			surface.DrawOutlinedRect(60, ScrH()-44, 211, 28);

			surface.SetDrawColor(255, 255, 255, 200);
			surface.SetMaterial(Material("nextoren_hud/ico_index2.png"));
			local kok = math.Clamp( math.ceil(hp * 16 / maxhp), 0, 16 )
			for i = 1, kok do
				if i > 16 then i = 16 end --Looping i when ply:Health() == ply:GetMaxHealth()
				surface.DrawTexturedRect(62 + (i-1)*13, ScrH()-42, 12, 24);
			end
			draw.SimpleText(hp .. " / " .. maxhp, "BudgetLabel", 165, ScrH()-29, Color(255,255,255,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end

		----------------------------[ROLEhud]----------------------------
	  if LocalPlayer():GTeam() == TEAM_SCP then
	  
	  if cl == nil then cl = Color(255, 255, 255, 200); end
	  draw.RoundedBox(0, 10, ScrH()-50-50, 40, 40, Color(0, 0, 0));
	  draw.RoundedBox(0, 60, ScrH()-44-50, 175, 28, Color(0, 0, 0, 200));
	  surface.SetDrawColor(255, 255, 255);

	  surface.SetMaterial(Material("nextoren_hud/ico_role.png"));
	  surface.DrawTexturedRect(13, ScrH()-47-50, 34, 34);

	  surface.SetDrawColor(255, 255, 255, 75);
	  surface.DrawOutlinedRect(10, ScrH()-50-50, 40, 40);

	  surface.DrawOutlinedRect(60, ScrH()-44-50, 175, 28);

	  draw.RoundedBox(0, 62, ScrH()-42-50, 171, 24, Color(color.r, color.g, color.b, 200));

	  draw.SimpleText(string.sub(role, 1, 50), "BudgetLabel", 147, ScrH()-79, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	  
	  else
	  
	  if cl == nil then cl = Color(255, 255, 255, 200); end
	  draw.RoundedBox(0, 10, ScrH()-50-100, 40, 40, Color(0, 0, 0));
	  draw.RoundedBox(0, 60, ScrH()-44-100, 175, 28, Color(0, 0, 0, 200));
	  surface.SetDrawColor(255, 255, 255);

	  surface.SetMaterial(Material("nextoren_hud/ico_role.png"));
	  surface.DrawTexturedRect(13, ScrH()-47-100, 34, 34);

	  surface.SetDrawColor(255, 255, 255, 75);
	  surface.DrawOutlinedRect(10, ScrH()-50-100, 40, 40);

	  surface.DrawOutlinedRect(60, ScrH()-44-100, 175, 28);

	  draw.RoundedBox(0, 62, ScrH()-42-100, 171, 24, Color(color.r, color.g, color.b, 200));

	  draw.SimpleText(string.sub(role, 1, 50), "BudgetLabel", 147, ScrH()-129, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	  
	  end
		----------------------------[TIMEhud]----------------------------

		draw.RoundedBox(0, ScrW()-50, ScrH()-50, 40, 40, Color(0, 0, 0));
    draw.RoundedBox(0, ScrW()-150, ScrH()-50, 95, 40, Color(0, 0, 0, 215))
    surface.SetDrawColor(255, 255, 255);
    local timeicon = Material("nextoren_hud/ico_time.png")
		local timecolor = Color(255,255,255,230)
		if GetGlobalBool("Nuke") == true then --NUKE TIME
	    timeicon = Material("nukeadd.png")
			timecolor = Color(255, 0, 0, 230)
		end
    surface.SetMaterial(timeicon);
    surface.DrawTexturedRect(ScrW()-46, ScrH()-46, 32, 32);

    surface.SetDrawColor(255, 255, 255, 75);
    surface.DrawOutlinedRect(ScrW()-50, ScrH()-50, 40, 40);
    surface.DrawOutlinedRect(ScrW()-150, ScrH()-50, 95, 40);

    draw.SimpleText(tostring(string.ToMinutesSeconds( cltime )), "Trebuchet24", ScrW()-57-91/2, ScrH()-30, timecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

	end
	if ( ply:GetNWBool( "HudjhouldDraw" ) && ply:Alive() ) then --Curse
		surface.SetDrawColor(255, 255, 255);
		surface.SetMaterial(Material("veneno.png"));
		surface.DrawTexturedRect(390, ScrH()-47-57, 64, 64);
	end


	-- Обновленный health бар
	--[[
  if ply:IsSpeaking() then
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial(Material("microphone.png"))
		surface.DrawTexturedRect(widthz * 0.2, heightz * 0.945 + offset, heightz * 0.034, heightz * 0.035)
  end
  --]]
 	----------------------------[GAMEMODE Version]----------------------------
	--[[
	draw.Text( {
		text = "Closed Alpha",
		pos = { widthz * 0.61, heightz * 0.992 + offset, heightz * 0.035, heightz * 0.035 },
		font = "HUDFont",
		color = Color(255,10,10),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	--]]
  draw.Text( {
		text = "NextOren BREACH 2.5.9-C (Unofficial from RXSEND)",
		pos = { widthz * 0.5, heightz * 0.992 + offset, heightz * 0.035, heightz * 0.035 },
		font = "HUDFont",
		color = Color(255,255,255),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
  })
end ) --End HUDPaint hook

net.Receive("xpAwardnextoren", function(len) --XP Notification call
  XPgained = net.ReadFloat()
  XpAddInc = true

  timer.Simple(4, function()
    XpAddInc = false
  end)


end)

net.Receive("lvlAwardnextoren", function(len) --LVL UP Notification call
  LevelUpIncnext = true

  timer.Simple(6, function()
    LevelUpIncnext = false
  end)
end)

net.Receive("lvldescnextoren", function(len) --LVL Description
  newClassDescc = net.ReadString() or ""
  LevelUpIncnext2 = true

  timer.Simple(6, function()
    LevelUpIncnext2 = false
  end)
end)

local lvlicon = Material( "lvl1.png" ) --default icon
local lvlclr = Color( 255, 255, 255 )

hook.Add( "HUDPaint", "Breach_DrawLVL", function()

	ply = LocalPlayer()

  if ( !ply:Alive() ) then return end

	local width = 350
	local height = 120
	local x = 10
  local y = ScrH() - height - 10

	local lvlH = 70
	local vledOffsetH = ScrH() - 25 - 25

	local defaultx = 39

	if ply:GetNLevel() >= 5 and ply:GetNLevel() < 10 then
		lvlicon = Material("lvl2.png")
		lvlclr = Color(255, 215, 0)

	elseif ply:GetNLevel() >= 10 and ply:GetNLevel() < 15 then
		lvlicon = Material("lvl3.png")
		lvlclr = Color(240, 230, 140)

	elseif ply:GetNLevel() >= 15 and ply:GetNLevel() < 20 then
		lvlicon = Material("lvl4.png")
		lvlclr = Color(143, 188, 143)

	elseif ply:GetNLevel() >= 20 and ply:GetNLevel() < 25 then
		lvlicon = Material("lvl5.png")
		lvlclr = Color(218, 165, 32)

	elseif ply:GetNLevel() >= 25 then
		lvlicon = Material("100.png")
		lvlclr = Color(255, 69, 0)
	end

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( lvlicon )
	surface.DrawTexturedRect( 284 - 25 - -30, vledOffsetH - 50, lvlH, lvlH )

  surface.SetFont( "TimeLeft" )

  surface.SetTextColor( 0, 0, 0, 255 )
  surface.SetTextPos( width - defaultx + 2, ( y - -49 ) + 2 )
  surface.DrawText( ply:GetNLevel() )

  surface.SetTextColor( lvlclr )
  surface.SetTextPos( width - defaultx, y - -49 )
  surface.DrawText( ply:GetNLevel() )

end)

// Docs
local DrawDistance = 50;
local DrawClass = {"item_doc", "item_fbidoc"};


--[[
local DrawDistanced = 80;
local DrawClassed = {"func_button"};

hook.Add("HUDPaint", "Handiconondoors", function()
    local arounded = ents.FindInSphere(ply:GetPos(), DrawDistanced);
    local ply = LocalPlayer();

    for _, i in pairs(arounded) do
	   -- print(i:GetClass())
        if ply:IsLineOfSightClear(i) then
           -- for j = 1, #DrawClassed do

                if i:GetClass() == "class C_BaseEntity" then

                    surface.SetDrawColor(255, 255, 255, 200);
                    surface.SetMaterial(Material("handsymbol.png"));
                    surface.DrawTexturedRect(i:GetPos():ToScreen().x-35, i:GetPos():ToScreen().y-32, 64, 64);
                end
          --  end
        end
    end
end);
]]

function DrawName( ply )

	if !ply:Alive() then return end
  if LocalPlayer():GTeam() != TEAM_SPEC then return end
	local offset = Vector( 0, 0, 85 )
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
  local color = gteams.GetColor( ply:GTeam() )
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
  local Distance = LocalPlayer():GetPos():Distance( ply:GetPos() )
	local lvlcolor = Color(255, 255, 255, 255)
	if ( Distance < 300 ) and ply:GTeam() != TEAM_SPEC then
	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
	  draw.SimpleTextOutlined("Health " ..ply:Health().. " / " ..ply:GetMaxHealth(), "HUDFontHead", 1, -10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined( ply:GetName(), "HUDFontHead", 1, 20, Color( color.r, color.g, color.b, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
		if ply:GetNLevel() <= 24 then
		  draw.SimpleTextOutlined("LVL  " ..ply:GetNLevel(), "HUDFontHead", 1, 45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
		end
		if ply:GetNLevel() >= 25 then
		  draw.SimpleTextOutlined("LVL  " ..ply:GetNLevel().. " MAX", "HUDFontHead", 1, 45, Color( 220, 20, 60, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
		end
		--if ply:GetNWInt("EXP") > 0 then
		  --draw.SimpleTextOutlined("EXP  " ..ply:GetNWInt("Exp"), "HUDFontHead", 1, 70, Color( 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
		--end
		surface.SetDrawColor(255,255,255,255)
		if ply:GTeam() == TEAM_CHAOS then
			surface.SetMaterial(Material("hudforspectators/chaosiconforhudspec.png"))
			surface.DrawTexturedRect(-28, -90, 64, 64);
		end
		if ply:GTeam() == TEAM_GOC then
			surface.SetMaterial(Material("hudforspectators/gociconforhud.png"))
			surface.DrawTexturedRect(-28, -90, 64, 64);
		end
		if ply:GTeam() == TEAM_DZ then
			surface.SetMaterial(Material("hudforspectators/dziconforhudspec.png"))
			surface.DrawTexturedRect(-28, -90, 64, 64);
		end
	cam.End3D2D()
  end
end
hook.Add( "PostPlayerDraw", "DrawName", DrawName )
function DrawTextInformation(ply)
	if !ply:Alive() then return end
	if ply:IsTyping() or ply:IsSpeaking() then
	  if LocalPlayer():GTeam() == TEAM_SPEC then return end
		local offset = Vector( 0, 0, 85 )
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()
	  --local color = gteams.GetColor( ply:GTeam() )
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
		local Distance = LocalPlayer():GetPos():Distance( ply:GetPos() )
		local lvlcolor = Color(255, 255, 255, 255)
		if ( Distance < 300 ) and ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP then
			cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
				if ply:IsTyping() then
					draw.SimpleTextOutlined( "Говорит...", "char_title24", 1, 44, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
				end
				if ply:IsSpeaking() then
					draw.SimpleTextOutlined( "Разговаривает...", "char_title24", 1, 44, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
				end
			cam.End3D2D()
		end
	end
end
hook.Add( "PostPlayerDraw", "Talkingspeakinginfo", DrawTextInformation )


