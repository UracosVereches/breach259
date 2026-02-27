--[[
gamemodes/breach/gamemode/cl_init.lua
--]]

--LOX

include("shared.lua")
include("gteams.lua")
include("fonts.lua")
include("class_breach.lua")
include("classes.lua")
include("cl_classmenu.lua")
include("sh_player.lua")
--include("cl_mtfmenu.lua")
include("cl_scoreboard.lua")
include( "cl_sounds.lua" )
include( "cl_targetid.lua" )
include( "cl_headbob.lua" )
include( "cl_font.lua" )
include( "ulx.lua" )
include( "cl_minigames.lua" )
include( "cl_eq.lua" )
include( "cl_tips.lua" )
include( "github_outline.lua" )

surface.CreateFont( "173font", {
	font = "TargetID",
	extended = false,
	size = 22,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

local tab = {
  "scp_music/music_1.mp3",
  "scp_music/music_2.mp3",
  "scp_music/music_3.mp3",
  "scp_music/music_4.mp3",
  "song_5.mp3"
}

function OUTSIDE_BUFF( pos )
	if pos.z > 1600 then
		return true
	end
end

CAMERAS = {
	{
	 name = "OUTSIDE",
	 pos = Vector(-175.584122, 6703.034180, 1725.708130),
	 ang = Angle(0.000, 146.079, 0.000)
	},
	{
	 name = "GATE_A",
	 pos = Vector(-697.264893, 5349.814941, 226.462402),
	 ang = Angle(0.000, -12.395, 0.000)
	},
	{
	 name = "GATE_B",
	 pos = Vector(-3950.994873, 2414.622559, 190.495819),
	 ang = Angle(0.000, -48.519, 0.000)
  },
	{
	 name = "CAFETERIA",
	 pos = Vector(53.675919, 3155.835693, 140.282364),
	 ang = Angle(0.000, 88.400, 0.000)
	},
	{
	 name = "HCZ_TESLA",
	 pos = Vector(4210.521484, 2002.322388, 149.438217),
	 ang = Angle(0.000, -101.296, 0.000)
	},
	{
	 name = "HCZ_1",
	 pos = Vector(3171.853516, 2657.589111, 50.352276),
	 ang = Angle(0.000, -153.835, 0.000)
	},
	{
	 name = "SCP_173",
	 pos = Vector(816.530701, 1170.705566, 337.440979),
	 ang = Angle(0.000, 134.616, 0.000)
	},
	{
	 name = "SCP_106",
	 pos = Vector(2868.708252, 4928.124023, 166.737183),
	 ang = Angle(0.000, -134.537, 0.000)
	},
	{
	 name = "LCZ_MAIN",
	 pos = Vector(718.819336, -58.217102, 181.064407),
	 ang = Angle(0.000, -56.380, 0.000)
	},
	{
	 name = "LCZ_DCELLS",
	 pos = Vector(-659.140808, 1138.599976, 350.122894),
	 ang = Angle(0.000, -173.823, 0.000)
	},
}

timer.Create("Ksaikok_Debug_Time",60,0,function() MsgC(Color(0, 255, 255),os.date("Дата: %Y-%m-%d",os.time())) MsgC(Color(0, 255, 255),os.date("\nВремя: %H:%M\n",os.time())) end)

--Прекэш текстур карты, оптимизация, спреи и т.д.

RunConsoleCommand("cl_forcepreload", "1")
RunConsoleCommand("gmod_mcore_test", "1")
RunConsoleCommand("cl_playerspraydisable", "0")
RunConsoleCommand("r_decals", "150")
RunConsoleCommand("r_spray_lifetime", "9999999")
RunConsoleCommand("mat_queue_mode", "2")
RunConsoleCommand("dsp_enhance_stereo", "1")
RunConsoleCommand("jpeg_quality", "100")
RunConsoleCommand("r_dynamic", "1")
RunConsoleCommand("r_dynamiclighting", "1")
RunConsoleCommand("r_queued_post_processing", "1")
RunConsoleCommand("r_queued_ropes", "1")
RunConsoleCommand("cl_threaded_client_leaf_system", "1")
RunConsoleCommand("r_threaded_renderables", "1")
RunConsoleCommand("r_queued_decals", "0")
RunConsoleCommand("r_norefresh", "1")
RunConsoleCommand("r_occludermincount", "1")
RunConsoleCommand("r_fastzreject", "1")

timer.Simple(30, function()
RunConsoleCommand("cw_kk_ins2_rig", "1") -- css hands fix
	if jit.arch == "x86" then
		RXSENDWarning("Крайне рекомендуется установить 64-битную версию Garry's Mod, это значительно повысит вашу производительность!")
	end
end)

function GM:InitPostEntity()
	hook.Remove("PlayerTick", "TickWidgets")
	RunConsoleCommand("gm_demo_icon", "0")
	RunConsoleCommand("snd_restart") -- prevent some bugs with sounds
	--LocalPlayer():EmitSound("music/HL2_song8.mp3", 75, 100, 0.5)

local size = 0
for k, v in ipairs(file.Find("!rxsend*.dem", "MOD")) do
    --print(v)
    --print(string.NiceSize(file.Size(v, "MOD")))
    size = size + file.Size(v, "MOD")
    --print(size)
end
    --print("Total demos size: "..string.NiceSize(size))
    
end
	
timer.Simple(30, function()
RunConsoleCommand("snd_restart") -- prevent some bugs with sounds
local size = 0
	for k, v in ipairs(file.Find("!rxsend*.dem", "MOD")) do
		--print(v)
		--print(string.NiceSize(file.Size(v, "MOD")))
		size = size + file.Size(v, "MOD")
		--print(size)
	end
	if size > 1000000000 then
		RXSENDWarning("Общий вес ваших демок в корневой папке Garry's Mod(steamapps/common/GarrysMod/garrysmod/!rxsend*.dem) - "..string.NiceSize(size)..", советуем удалить их для освобождения места на диске.")
	end
end)

function PlayNaziMusic()
	local g_station = nil
	sound.PlayURL("https://media1.vocaroo.com/mp3/1dSXFcF2UHOz", "mono", function(snus)
		snus:SetPos(LocalPlayer():GetPos())
		snus:Play()
		g_station = station
	end)
end

function PlayRedArmyMusic()
	local g_station = nil
	sound.PlayURL("https://media1.vocaroo.com/mp3/17racrM5mo40", "mono", function(snus)
		snus:SetPos(LocalPlayer():GetPos())
		snus:Play()
		g_station = station
	end)
end

--timer.Simple(30, function()
	
--[[
function GM:CalcView(player, origin, angles, fov)

if !IsDied then 
	IsDeafened = 0
	LocalPlayer():SetDSP(1, false)
	LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0,0,0), 0, 0) --чётко по нолям
	return
end

if IsDied then
rxsend_playerragdoll = player:GetNWEntity("RagdollEntityNO")

  if (!IsValid(rxsend_playerragdoll)) then return end

    local rxsend_firstperson = rxsend_playerragdoll:GetAttachment(rxsend_playerragdoll:LookupAttachment("eyes"))
    
    if (!rxsend_firstperson) then return end
	
    if IsDeafened != 1 then
        LocalPlayer():SetDSP(31, false)
        IsDeafened = 1
    end
	
    LocalPlayer():ScreenFade(SCREENFADE.IN, Color(255,255,255), 2, 3)
	
    local vid = {
      origin = rxsend_firstperson.Pos, 
      angles = rxsend_firstperson.Ang, 
      fov = LocalPlayer():GetFOV(), 
      znear = 1
    }
    
    return vid
	
  end

end
--]]
local blur = Material("pp/blurscreen")
hook.Add( "RenderScreenspaceEffects", "DeathEffectFromRO2", function()
	if LocalPlayer():Health() > 0 then return end
	if LocalPlayer():Health() <= 0 then
		DrawMotionBlur( 0.27, 0.5, 0.01 )
		DrawSharpen( 1,2 )
		DrawToyTown( 3, ScrH() / 1.8 )
		--ply:SetDSP(47)

		local W = ScrW()
		local H = ScrH()

		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255, 255)

		for i = 0.33, 2, 0.33 do
			blur:SetFloat("$blur", 2 * i)
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0, 0, W, H)
		end
	end
end)

--Replaced with Ksaikok Anticheat by RXSEND

--[[
local function CheckCheats()

	if ( GetConVar( "sv_cheats" ):GetBool() == true || GetConVar( "sv_allowcslua" ):GetInt() == 1 ) then

		net.Start( "BanCheater" )

			net.WriteEntity( LocalPlayer() )

		net.SendToServer()

	end

end
--]]

--hook.Add( "Think", "CheckCheats", CheckCheats )

local function ScarySounds()
	if preparing then return end
	if GetGlobalBool("Nuke", false) then return end
	
    local sound, plytab = table.Random(tab), player.GetAll()
    for k = 1, #plytab do
        surface.PlaySound("".. sound .."")
    end
end

timer.Create("ScarySoundsEmit", 180, 0, ScarySounds)
RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)

SAVEDIDS = {}
lastidcheck = 0
function AddToIDS(ply)
	if lastidcheck > CurTime() then return end
	local sid = nil
	local wep = ply:GetActiveWeapon()
	if not ply.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	end
	if ply:GTeam() == TEAM_SCP then
		sid = ply:GetNClass()
	else
		if IsValid(wep) then
			if wep:GetClass() == "br_id" then
				sid = ply:GetNClass()
			end
		end
	end
	if sid == ROLES.ROLE_CHAOSSPY then
		if (LocalPlayer():GTeam() == TEAM_SCI) or (LocalPlayer():GTeam() == TEAM_GUARD) then
			sid = ROLES.ROLE_MTFGUARD
		end
	end
	for k,v in pairs(SAVEDIDS) do
		if v.pl == ply then
			if v.id == sid then
				lastidcheck = CurTime() + 0.5
				return
			end
		end
	end
	table.ForceInsert(SAVEDIDS, {pl = ply, id = sid})

	// messaging
	if sid == nil then
		sid = "unknown id"
	else
		sid = "id: " .. sid
	end
	local sname = "Added new id: " .. ply:Nick() .. " with " .. sid
	print(sname)
	lastidcheck = CurTime() + 0.7
end

--buttonstatus = "rough"

clang = nil
cwlang = nil
ALLLANGUAGES = {}
WEPLANG = {}

local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA" )
for k,v in pairs(files) do
	local path = "languages/"..v
	if string.Right(v, 3) == "lua" and string.Left(v, 3) != "wep" then
		include( path )
		print("Loading language: " .. path)
	end
end

local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/wep_*.lua", "LUA" )
for k,v in pairs(files) do
	local path = "languages/"..v
	if string.Right(v, 3) == "lua" then
		include( path )
		print("Loading weapon lang file: " .. path)
	end
end

langtouse = CreateClientConVar( "br_language", "english", true, false ):GetString()

cvars.AddChangeCallback( "br_language", function( convar_name, value_old, value_new )
	langtouse = value_new
	LoadLang( langtouse )
end )

hudScale = CreateClientConVar( "br_hud_scale", 1, true, false ):GetFloat()

cvars.AddChangeCallback( "br_hud_scale", function( convar_name, value_old, value_new )
	local newScale = tonumber(value_new)
	if newScale > 1 then newScale = 1 end
	if newScale < 0.1 then newScale = 0.1 end
	hudScale = newScale
end )

print("langtouse:")
print(langtouse)

//print("Alllangs:")
//PrintTable(ALLLANGUAGES)

function LoadLang( lang )
	local finallang = table.Copy( ALLLANGUAGES.english )
	local ltu = {}
	if ALLLANGUAGES[lang] then
		ltu = ALLLANGUAGES[lang]
	end
	AddTables( finallang, ltu )
	clang = finallang

	local finalweplang = table.Copy( WEPLANG.english )
	local wltu = {}
	if WEPLANG[lang] then
		wltu = WEPLANG[lang]
	else
		wltu = WEPLANG.english
	end
	AddTables( finalweplang, wltu )
	cwlang = finalweplang
end

LoadLang( langtouse )

mapfile = "mapconfigs/" .. game.GetMap() .. ".lua"
--include(mapfile)

include("cl_hud.lua")
include("cl_hud_new.lua")


RADIO4SOUNDSHC = {
	{"chatter1", 39},
	{"chatter2", 72},
	{"chatter4", 12},
	{"franklin1", 8},
	{"franklin2", 13},
	{"franklin3", 12},
	{"franklin4", 19},
	{"ohgod", 25}
}

RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)

disablehud = false
livecolors = false

preparing = false
postround = false
blackout = true

function DropCurrentVest()
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC or LocalPlayer():GTeam() != TEAM_GUARD or LocalPlayer():GTeam() != TEAM_CHAOS or LocalPlayer():GTeam() != TEAM_GOC or LocalPlayer():GTeam() != TEAM_DZ or LocalPlayer():GTeam() != TEAM_USA or LocalPlayer():GTeam() != TEAM_SPECIAL or LocalPlayer():GetNClass() != ROLES.ROLE_TOPKEK and LocalPlayer():GetNClass() != ROLES.ROLE_FAT and LocalPlayer():GetNClass() != ROLES.ROLE_CSECURITY and LocalPlayer().UsingArmor != "armor_goc" then
		net.Start("DropCurrentVest")
		net.SendToServer()
	end
end
hook.Add( "ChatText", "removeJoin", function( playerindex, playername, text, msgtype )
	if msgtype == "joinleave" then
		return true
	end
end )
concommand.Add( "br_spectate", function( ply, cmd, args )
	net.Start("SpectateMode")
	net.SendToServer()
end )

concommand.Add( "br_recheck_premium", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("RecheckPremium")
		net.SendToServer()
	end
end )

concommand.Add( "br_punish_cancel", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("CancelPunish")
		net.SendToServer()
	end
end )

concommand.Add( "br_roundrestart_cl", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("RoundRestart")
		net.SendToServer()
	end
end )

wantClear = false
tUse = 0

concommand.Add( "br_clear_stats", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		if tUse < CurTime() and wantClear then wantClear = false print("Last request timed out") end
		if #args > 0 then
			print( "Sending request to server..." )
			net.Start( "ClearData" )
				net.WriteString( tostring( args[1] ) )
			net.SendToServer()
		else
			if !wantClear then
				print( "Are you sure to clear players all data? Write again to confirm (this operation cannot be undone)" )
				wantClear = true
				tUse = CurTime() + 10
			else
				wantClear = false
				print( "Sending request to server..." )
				net.Start( "ClearData" )
					net.WriteString( "&ALL" )
				net.SendToServer()
			end
		end
	end
end )

concommand.Add( "br_restart_game", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("Restart")
		net.SendToServer()
	end
end )

concommand.Add( "br_admin_mode", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("AdminMode")
		net.SendToServer()
	end
end )

concommand.Add( "br_dropvest", function( ply, cmd, args )
	 -- if LocalPlayer().UsingArmor == "armor_goc" then print("GOVNO") return end
    if LocalPlayer():GTeam() != TEAM_SPEC or LocalPlayer():GTeam() != TEAM_GUARD or LocalPlayer():GTeam() != TEAM_CHAOS or LocalPlayer():GTeam() != TEAM_GOC or LocalPlayer():GTeam() != TEAM_DZ or LocalPlayer():GTeam() != TEAM_USA or LocalPlayer():GTeam() != TEAM_NTF then
	    DropCurrentVest()
	end
end )

concommand.Add( "br_disableallhud", function( ply, cmd, args )
	disablehud = !disablehud
end )

concommand.Add( "br_livecolors", function( ply, cmd, args )
	if livecolors then
		livecolors = false
		chat.AddText("livecolors disabled")
	else
		livecolors = true
		chat.AddText("livecolors enabled")
	end
end )

concommand.Add( "br_weapon_info", function( ply, cmd, args )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) then
		print( "Weapon name: "..wep:GetClass() )
		if wep.Damage_Orig then print( "Weapon original damage: "..wep.Damage_Orig ) end
		if wep.DamageMult then print( "Weapon damage multiplier: "..wep.DamageMult ) end
		if wep.DamageMult then print( "Weapon final damage: "..wep.Damage ) end
	end
end )
gamestarted = false
cltime = 0
drawinfodelete = 0
shoulddrawinfo = false
drawendmsg = nil
timefromround = 0
--------------------------------------------------------------------
--You are NOT allowed to remove, modify or omit parts of code marked as credits!
--Removing/editing any credit code will be recognized as copyright infringement!
-----------------------------CREDITS--------------------------------

--timer.Create( "Credits", 180, 0, function()
--	print("Breach(edited) by danx91 [ZGFueDkx] update "..VERSION.." [patch "..DATE.."]")
--	if GetConVar( "br_new_eq" ):GetInt() == 1 then
--		LocalPlayer():PrintMessage( HUD_PRINTTALK, clang.eq_open )
--	end
--end )
--------------------------------------------------------------------

timer.Create("HeartbeatSound", 2, 0, function()
	if not LocalPlayer().Alive then return end
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		if LocalPlayer():Health() < 30 then
			LocalPlayer():EmitSound("heartbeat.ogg")
		end
	end
end)

function OnUseEyedrops(ply) end

function StartTime()
	timer.Destroy("UpdateTime")
	timer.Create("UpdateTime", 1, 0, function()
		if cltime > 0 then
			cltime = cltime - 1
		end
	end)
end



endinformation = {}

net.Receive( "Update914B", function( len )
	local sstatus = net.ReadInt(6)
	if sstatus == 0 then
		buttonstatus = 1
	elseif sstatus == 1 then
		buttonstatus = 2
	elseif sstatus == 2 then
		buttonstatus = 3
	elseif sstatus == 3 then
		buttonstatus = 4
	elseif sstatus == 4 then
		buttonstatus = 5
	elseif sstatus == 5 then
		buttonstatus = 6
	end
end)

net.Receive( "UpdateTime", function( len )
	cltime = tonumber(net.ReadString())
	StartTime()
end)

net.Receive( "UpdateKeycard", function( len )
	local keycard = LocalPlayer():GetWeapon( "br_keycard" )
	if IsValid( keycard ) and keycard.Think then
		keycard:Think()
	end
end )

local soundind = 0 local playlist = {
	'sfx/ending/gatea/bell1.ogg',
	'sfx/ending/gatea/bell2.ogg'
}

local function PlayStuff()
	soundind = soundind + 1 if soundind > #playlist then soundind = 1 end
	surface.PlaySound( playlist[ soundind ] )

end
local blur = Material("pp/blurscreen")
local function DrawBlur(panel)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * 2)
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)

	end
end

net.Receive( "ForcePlaySound", function( len )
	local sound = net.ReadString()
	surface.PlaySound(sound)
end)

net.Receive( "UpdateRoundType", function( len )
	roundtype = net.ReadString()
	print("Тип раунда: " .. roundtype)

	for k, v in ipairs(player.GetAll()) do
		v.DiedFromPistolBullets = false
		v.DiedFromSMG1Bullets = false
		v.DiedFromAR2Bullets = false
		v.DiedFromHeadshot = false
		v.DiedFromSlash = false
		v.DeathReasonUnknown = false
	end
	
end)

net.Receive( "SendRoundInfo", function( len )
	local infos = net.ReadTable()
	endinformation = {
		string.Replace( clang.lang_pldied, "{num}", infos.deaths ),
		string.Replace( clang.lang_descaped, "{num}", infos.descaped ),
		string.Replace( clang.lang_sescaped, "{num}", infos.sescaped ),
		string.Replace( clang.lang_rescaped, "{num}", infos.rescaped ),
		string.Replace( clang.lang_dcaptured, "{num}", infos.dcaptured ),
		string.Replace( clang.lang_rescorted, "{num}", infos.rescorted ),
		string.Replace( clang.lang_teleported, "{num}", infos.teleported ),
		string.Replace( clang.lang_snapped, "{num}", infos.snapped ),
		string.Replace( clang.lang_zombies, "{num}", infos.zombies )
	}
	if infos.secretf == true then
		table.ForceInsert(endinformation, clang.lang_secret_found)
	else
		table.ForceInsert(endinformation, clang.lang_secret_nfound)
	end

end)

net.Receive( "RolesSelected", function( len )
	GAMEMODE:ScoreboardHide()
	drawinfodelete = CurTime() + 25
	shoulddrawinfo = true
end)
net.Receive( "PrepStart", function( len )
	GAMEMODE:ScoreboardHide() --Dickheads
	--LocalPlayer():Tip(3, "Приготовьтесь, раунд начнется через 10 секунд!", Color(255, 0, 0))
	
	for k, v in ipairs(player.GetAll()) do
		v:SetMuted(false)
	end
	
	cltime = net.ReadInt(8)
	postround = false
	preparing = true
	blackout = false

	--chat.AddText(string.Replace( clang.preparing,  "{num}", cltime ))
	StartTime()
	drawendmsg = nil
	hook457delete = CurTime() + 0.5
	hook.Add("Tick", "Stop457Sounds", function()
		if hook457delete != nil then
			if hook457delete < CurTime() then
				hook457delete = nil
				hook.Remove("Tick", "Stop457Sounds")
			end
			if LocalPlayer():GetNClass() == ROLES.ROLE_SCP457 then
				RunConsoleCommand("stopsound")
			end
		end
	end)
	timer.Destroy("SoundsOnRoundStart")
	timer.Create("SoundsOnRoundStart", 1, 1, SoundsOnRoundStart)
	timefromround = CurTime() + 10
	RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
	SAVEDIDS = {}
end)

net.Receive( "RoundStart", function( len )
	preparing = false
	blackout = true
	--RunConsoleCommand("stopsound")
	--LocalPlayer():Tip(3, "Игра началась, удачи!", Color(255, 0, 0))
	cltime = net.ReadInt(12)
	--chat.AddText(clang.round)
	RXSENDNotify("Игра началась, желаем успеха!")
	if LocalPlayer():GTeam() == TEAM_SCP then
		LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0, 50)
	end
	StartTime()
	drawendmsg = nil
end)

net.Receive( "PostStart", function( len )
	postround = true
	cltime = net.ReadInt(6)
	win = net.ReadInt(4)
	drawendmsg = win
	StartTime()
end)

hook.Add( "OnPlayerChat", "CheckChatFunctions", function( ply, strText, bTeam, bDead )
	strText = string.lower( strText )

	if ( strText == "dropvest" ) then
		if ply == LocalPlayer() then
			DropCurrentVest()
		end
		return true
	end
end)

// Blinking system

local brightness = 0
local f_fadein = 0.25
local f_fadeout = 0.000075


local f_end = 0
local f_started = false
function tick_flash()
	if LocalPlayer().GTeam == nil then return end
	/*
	if LocalPlayer():GTeam() != TEAM_SPEC then
		for k,v in pairs(ents.FindInSphere(OUTSIDESOUNDS, 300)) do
			if v == LocalPlayer() then
				StartOutisdeSounds()
			end
		end
	end
	*/
	if shoulddrawinfo then
		if CurTime() > drawinfodelete then
			shoulddrawinfo = false
			drawinfodelete = 0
		end
	end
	if f_started then
		if CurTime() > f_end then
			--brightness = brightness + f_fadeout
			if brightness < 0 then
				f_end = 0
				brightness = 0
				f_started = false
				//print("blink end")
			end
		else
			if brightness < 1 then
				brightness = brightness - f_fadein
			end
		end
	end
end
hook.Add( "Tick", "htickflash", tick_flash )

function CLTick()
	if postround == false and isnumber(drawendmsg) then
		drawendmsg = nil
	end
	if clang == nil then
		clang = english
	end
	if cwlang == nil then
		cwlang = english
	end
	if blinkHUDTime >= 0 then
		blinkHUDTime = btime - CurTime()
	end
	if blinkHUDTime < 0 then blinkHUDTime = 0 end
end
hook.Add( "Tick", "client_tick_hook", CLTick )

net.Receive("PlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
end)

net.Receive("SlowPlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
end)

function SlowFadeBlink(time)
	f_fadein = 0.0075
	f_fadeout = 0.0075
	f_started = true
	f_end = CurTime() + time
end

blinkHUDTime = 0.0
btime = 0.0

function Blink(time)
	btime = CurTime() + GetConVar("br_time_blinkdelay"):GetFloat() + time
	f_fadein = 0.25
	f_fadeout = 0.0125
	f_started = true
	f_end = CurTime() + time
end

net.Receive( "PlayerReady", function()
	local tab = net.ReadTable()
	sR = tab[1]
	sL = tab[2]
end )

net.Receive( "689", function( len )
	if LocalPlayer():GetNClass() == ROLES.ROLE_SCP689 then
		local targets = net.ReadTable()
		if targets then
			local swep = LocalPlayer():GetWeapon( "weapon_scp_689" )
			if IsValid( swep ) then
				swep.Targets = targets
			end
		end
	end
end )

net.Receive("Effect", function()
	LocalPlayer().mblur = net.ReadBool()
end )
local ThermalksColorTab =
{
	[ "$pp_colour_addr" ] 		= -.4,
	[ "$pp_colour_addg" ] 		= -.5,
	[ "$pp_colour_addb" ] 		= -.5,
	[ "$pp_colour_brightness" ] 	= .18,
	[ "$pp_colour_contrast" ] 	= 0.6,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0,
}
function ThermalFXsf()

	DrawColorModify( ThermalksColorTab )

	-- Bloom
	DrawBloom(	0,  					-- Darken
 				0.5,				-- Multiply
 				1, 				-- Horizontal Blur
 				1, 				-- Vertical Blur
 				0, 				-- Passes
 				5, 				-- Color Multiplier
 				0, 				-- Red
 				5, 				-- Green
 				5 ) 			-- Blue



end
local shittythingbecomestrue = false
function ResWHs()

	if LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESS then
        KEKES = {}
        for k,v in pairs(player.GetAll()) do
            if v:GTeam() == TEAM_SCP then
                table.insert(KEKES, v)
            end
  end
		Add(KEKES, Color( 0, 0, 255 ), OUTLINE_MODE_BOTH)
    end

end
local Nexteye = 0

local configeyeDelay = 10 -- КД на юз спец. способности глаза
local slos = false
local slos2 = false
hook.Add("HUDPaint", "Researcherskills", function()

	if ( !LocalPlayer():Alive() || LocalPlayer():GTeam() != TEAM_SPECIAL ) then return end


	local scale = hudScale
	local widthz = ScrW() * scale
	local heightz = ScrH() * scale
	local offset = ScrH() - heightz
	if LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESS and Nexteye <= CurTime() and !slos then
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("lionn.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.045, heightz * 0.035)

  elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRES then
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("jk.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

	elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPEEED then
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("speedboost.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

	elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPEEED and ply:GetNWBool("CD99", true) then
      surface.SetDrawColor(255, 255, 255, 150)
	    surface.SetMaterial(Material("redspell.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

    elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESSS then
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("raged.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

  elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESSSS then
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("speeddown.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

    elseif LocalPlayer():GetNClass() == ROLES.ROLE_LESSION then
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("lession.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

    elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRES and ply:GetNWBool("CD",true) then
      surface.SetDrawColor(255, 255, 255, 150)
	    surface.SetMaterial(Material("redspell.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

    elseif LocalPlayer():GetNClass() == ROLES.ROLE_LESSION and ply:GetNWBool("CDX",true) then
        surface.SetDrawColor(255, 255, 255, 150)
	    surface.SetMaterial(Material("redspell.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

    elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESSSS and ply:GetNWBool("CD2",true) then
      surface.SetDrawColor(255, 255, 255, 150)
	    surface.SetMaterial(Material("redspell.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)

		elseif LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESSS and ply:GetNWBool("CD3",true) then
      surface.SetDrawColor(255, 255, 255, 150)
	    surface.SetMaterial(Material("redspell.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.049, heightz * 0.049)
    end
    if slos then
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("eyecastt.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.045, heightz * 0.055)
    end
    local showtlxt = ""
    if Nexteye > CurTime() then
      showtlxt = " " .. math.Round(Nexteye - CurTime())
      showcolor = Color(255, 69, 0)
      surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(Material("lionnreload.png"))
	    surface.DrawTexturedRect(  widthz * 0.479, heightz * 0.905 + offset, heightz * 0.045, heightz * 0.035)
    end
    draw.Text( {
		text = showtlxt,
		pos = { ScrW() / 2.04, ScrH() - 145 },
		font = "HUDFontTitle",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

end)

local function ResWH()
	if LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESS then
		hook.Add( "PreDrawHalos", "KokWH", ResWHs )
		hook.Add( "RenderScreenspaceEffects", "ThermalCgk", ThermalFXsf )
    else return end
end
local function ResWHr()
	--if LocalPlayer():GetNClass() == ROLES.ROLE_SPECIALRESS then
		hook.Remove( "PreDrawHalos", "KokWH", ResWHs )
		hook.Remove( "RenderScreenspaceEffects", "ThermalCgk", ThermalFXsf)
    --else return end
end

hook.Add("PlayerButtonDown", "Researcher3", function(ply, but)

	if ( ply:GTeam() != TEAM_SPECIAL || !ply:Alive() ) then return end
	if but != KEY_H then return end

	if slos then return end
	if Nexteye > CurTime() then return end


	if ply:GetNClass() != ROLES.ROLE_SPECIALRESS then print("This is not my darlings!") return end
	--timer.Simple(0, function() obvodka = true end)
    --timer.Simple(0.3, function() obvodka = false end)
    --if ply:GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy() < 24 then print("U don't have power to do thi") return end
	--if ply:Health() >= ply:GetMaxHealth() then return end
	--if NextHeal > CurTime() then return end
	--NextHeal = CurTime() + configHealDelay
    if but == KEY_H then
    	timer.Create("Comeoutcomeot", 0, 1, function() ply:EmitSound("special_sci/pulse/pulse_"..math.random(1,14)..".mp3") end)
    	timer.Simple(0, function() slos = true shittythingbecomestrue = true ResWH() end)
    	timer.Simple(15, function() slos = false Nexteye = CurTime() + configeyeDelay shittythingbecomestrue = false ResWHr() end)


	end



end)

local Zatemn = math.abs(math.sin(CurTime() * 4) * 255)
hook.Add("PreDrawHalos", "BreachOutlines", function()
		if !LocalPlayer():IsValid() then return end
		--if ( LocalPlayer():GetNClass() != ROLES.ROLE_MTFJAG && LocalPlayer():GTeam() != TEAM_SCP && LocalPlayer():GetModel() != "models/scp/mog_special_new.mdl" ) then return end
		if !LocalPlayer():Alive() then return end
		if LocalPlayer():GTeam() == TEAM_SPEC then return end

    
	if LocalPlayer():GetNClass() == ROLES.ROLE_MTFJAG or LocalPlayer():GetModel() == "models/scp/mog_special_new.mdl" and LocalPlayer():Alive() then
	INVISIBLES = {}
		for k,v in pairs(player.GetAll()) do
			if v:GetNClass() == ROLES.ROLE_SCP1471 or v:GetNClass() == ROLES.ROLE_SCP966 then
				table.insert(INVISIBLES, v)
				--break
			end
		end
		Add(INVISIBLES, Color(0, 0, 255), OUTLINE_MODE_VISIBLE)
	end
	
    if LocalPlayer():GetNClass() != ROLES.ROLE_MTFJAG or LocalPlayer():GetModel() != "models/scp/mog_special_new.mdl" and LocalPlayer():Alive() then
		if !IsValid(LocalPlayer():GetActiveWeapon()) then return end
		if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then
			INVISIBLES = {}
				for k,v in pairs(player.GetAll()) do
					if v:GetNClass() == ROLES.ROLE_SCP1471 or v:GetNClass() == ROLES.ROLE_SCP966 then
						table.insert(INVISIBLES, v)
						--break
					end
				end
				Add(INVISIBLES, Color(0, 205, 50), OUTLINE_MODE_VISIBLE)
			end
		end

    if LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GetNClass() == ROLES.ROLE_LESSION then
    	SCPSV = {}
    	for k,v in pairs(player.GetAll()) do
    		if v:GetNWBool("HudjhouldDraw", false) then
    			table.insert(SCPSV, v)
    		end
    	end
      Add(SCPSV, Color(0, 0, 255), OUTLINE_MODE_VISIBLE)
    end
		if LocalPlayer():GetNClass() == ROLES.ROLE_SCP8602 then
			VICTIM = {}
			for k,v in pairs(player.GetAll()) do
				--if v:GTeam() == TEAM_SPEC
				if v:GetNWBool("Victim",false) and v:GTeam() != TEAM_SPEC then
					table.insert(VICTIM, v)
				end
			end
			Add(VICTIM, Color(205, 50, 50), OUTLINE_MODE_BOTH)
		end
		if LocalPlayer():GTeam() == TEAM_SCP then
			DZ = {}
			for k,v in pairs(player.GetAll()) do

				if v:GTeam() == TEAM_DZ then
					table.insert(DZ, v)
					--break
				end
			end
			Add(DZ, Color(50, 205, 50), OUTLINE_MODE_VISIBLE)
		end

		if LocalPlayer():GTeam() == TEAM_SCP then
			SCPS = {}
			for k,v in pairs(player.GetAll()) do

				if v:GTeam() == TEAM_SCP then
					table.insert(SCPS, v)
					--break
				end
			end
			Add(SCPS, Color(255, 0, 0), OUTLINE_MODE_BOTH)
		end
		
		if LocalPlayer():GTeam() == TEAM_DZ then
			SDZ = {}
			for k,v in pairs(player.GetAll()) do

				if v:GetNClass() == ROLES.ROLE_DZDD then
					table.insert(SDZ, v)
					--break
				end
			end
			Add(SDZ, Color(50, 205, 50), OUTLINE_MODE_VISIBLE)
		end

		if LocalPlayer():GTeam() == TEAM_DZ then
			DZ_SCPS = {}
			for k,v in pairs(player.GetAll()) do

				if v:GTeam() == TEAM_SCP then
					table.insert(DZ_SCPS, v)
					--break
				end
			end
			Add(DZ_SCPS, Color(255, 0, 0), OUTLINE_MODE_VISIBLE)
		end

		if LocalPlayer():GTeam() == TEAM_GOC or LocalPlayer():GetNClass() == "GOC Spy" then
			GOCS = {}
			for k,v in pairs(player.GetAll()) do

				if v:GetNClass() == "GOC Spy" then
					table.insert(GOCS, v)
					--break
				end
			end
			Add(GOCS, Color(255, 0, 0), OUTLINE_MODE_VISIBLE)
		end

		if LocalPlayer():GetNClass() == ROLES.ROLE_CHAOSSPY then
			CIS = {}
			for k, v in pairs(player.GetAll()) do

				if v:GetNClass() == ROLES.ROLE_CHAOSSPY then
					table.insert(CIS, v)
				end
			end
			Add(CIS, Color(79, 150, 56), OUTLINE_MODE_BOTH)
		end

		if LocalPlayer():GetNClass() == ROLES.ROLE_LESSION then
			GASSED_SCPS = {}
			for k, v in pairs(player.GetAll()) do

				if v:GetNWBool("IsGassed", false) then
					table.insert(GASSED_SCPS, v)
				end
			end
			Add(GASSED_SCPS, Color(255, 255, 255), OUTLINE_MODE_BOTH)
		end
		--disabled for performance
		--[[
		if LocalPlayer():GTeam() == TEAM_GOC or LocalPlayer():GetNClass() == "GOC Spy" then
			NUKE = {}
			for k, v in ipairs(ents.GetAll()) do
				
				if v:GetClass() == "buzzer_scpnuke" then
					table.insert(NUKE, v)
				end
			end
			Add(NUKE, Color(255, 255, 255), OUTLINE_MODE_BOTH)
		end
		--]]
		--[[
		if LocalPlayer():GTeam() == TEAM_USA then
			FBI_DOCS = {}
			for k, v in ipairs(ents.GetAll()) do
				
				if v:GetClass() == "item_fbidoc" then
					table.insert(FBI_DOCS, v)
				end
			end
			Add(FBI_DOCS, Color(255, 255, 255), OUTLINE_MODE_VISIBLE)
		end
		--]]
		--[[
		if LocalPlayer():GTeam() == TEAM_SCI or LocalPlayer():GTeam() == TEAM_CLASSD then
			DOCS = {}
			for k, v in ipairs(ents.GetAll()) do
				
				if v:GetClass() == "item_doc" then
					table.insert(DOCS, v)
				end
			end
			Add(DOCS, Color(255, 255, 255), OUTLINE_MODE_VISIBLE)
		end
		--]]
end)
local mat_color = Material( "pp/colour" ) -- used outside of the hook for performance
hook.Add( "RenderScreenspaceEffects", "blinkeffects", function()
    //if f_started == false then return end

    if LocalPlayer().mblur == nil then LocalPlayer().mblur = false end
    if ( LocalPlayer().mblur == true ) then
      DrawMotionBlur( 0.3, 0.8, 0.03 )
    end

    if LocalPlayer().n420endtime and LocalPlayer().n420endtime > CurTime() then
      DrawMotionBlur( 1 - ( LocalPlayer().n420endtime - CurTime() ) / 15 , 0.3, 0.025 )
      DrawSharpen( ( LocalPlayer().n420endtime - CurTime() ) / 3, ( LocalPlayer().n420endtime - CurTime() ) / 20 )
      clr_r = ( LocalPlayer().n420endtime - CurTime() ) * 2
      clr_g = ( LocalPlayer().n420endtime - CurTime() ) * 2
      clr_b = ( LocalPlayer().n420endtime - CurTime() ) * 2
    end
    local dark = 0
    local contrast = 1
    local colour = 1
    local nvgbrightness = 0
    local clr_r = 0
    local clr_g = 0
    local clr_b = 0
    local bloommul = 1.2
    local add_r = 0
    local add_b = 0
    local add_g = 0

    if LocalPlayer():GetNClass() == ROLES.ROLE_MTFJAG or LocalPlayer():GetModel() == "models/scp/mog_special_new.mdl" then
	    --nvgbrightness = 0.2
			--add_b = 0.15
		end

    if IsValid(LocalPlayer():GetActiveWeapon()) then
      if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then
        nvgbrightness = 0.2
				add_g = 0.15
      end
    end
    if LocalPlayer():Health() < 30 and LocalPlayer():Alive() then
      colour = math.Clamp((LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 5, 0, 2)
      DrawMotionBlur( 0.27, 0.5, 0.01 )
      DrawSharpen( 1,2 )
      DrawToyTown( 3, ScrH() / 1.8 )
  	end
    if LocalPlayer():GTeam() then
	    if !blackout and LocalPlayer():GTeam() != TEAM_SCP then
	      dark = 0
		    contrast = 1.2
		    colour = 1.1
			elseif !blackout and LocalPlayer():GTeam() == TEAM_SCP then
			  dark = 1
				contrast = 1
				colour = 1

			--elseif ( LocalPlayer():IsSuperAdmin() ) then

				--dark = 0
				--contrast = 1
				--colour = 1

	    elseif OUTSIDE_BUFF( LocalPlayer():GetPos() ) then
		    dark = 0.01
		    contrast = 1
		    colour = 1


			elseif LocalPlayer():GTeam() == TEAM_SPEC and !blackout then
        contrast = 1
        nvgbrightness = 0
				--add_g = 0
      elseif LocalPlayer():GTeam() == TEAM_SCP and blackout then
       	contrast = 1
       	nvgbrightness = 0.1
       	clr_r = 0
        add_r = 0.1
      elseif LocalPlayer():GTeam() != TEAM_SCP or LocalPlayer():GTeam() != TEAM_SPEC and blackout then
        dark = 0
		    contrast = 0.8
		    colour = 1
				nvgbrightness = 0
			end

		end
    render.UpdateScreenEffectTexture()


    mat_color:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

    mat_color:SetFloat( "$pp_colour_brightness", brightness + nvgbrightness - dark)
    mat_color:SetFloat( "$pp_colour_contrast", contrast)
    mat_color:SetFloat( "$pp_colour_colour", colour )
    mat_color:SetFloat( "$pp_colour_mulr", clr_r )
    mat_color:SetFloat( "$pp_colour_mulg", clr_g )
    mat_color:SetFloat( "$pp_colour_mulb", clr_b )
    mat_color:SetFloat( "$pp_colour_addr", add_r )
    mat_color:SetFloat( "$pp_colour_addg", add_g )
    mat_color:SetFloat( "$pp_colour_addb", add_b )



    render.SetMaterial( mat_color )
    render.DrawScreenQuad()
    //DrawBloom( Darken, Multiply, SizeX, SizeY, Passes, ColorMultiply, Red, Green, Blue )
    DrawBloom( 0.65, bloommul, 9, 9, 1, 1, 1, 1, 1 )
    DrawSharpen( 1.2, 0.3 )
    --DrawToyTown( 3, ScrH()/3 )
end )
local dropnext = 0
function GM:PlayerBindPress( ply, bind, pressed )
	if bind == "+menu" then

	elseif bind == "gm_showteam" then
		OpenClassMenu()
	elseif bind == "+menu_context" then
		thirdpersonenabled = !thirdpersonenabled
	end
end

function DropCurrentWeapon()
	if dropnext > CurTime() then return true end
	dropnext = CurTime() + 0.5
	net.Start("DropCurWeapon")
	net.SendToServer()
	if LocalPlayer().channel != nil then
		LocalPlayer().channel:EnableLooping( false )
		LocalPlayer().channel:Stop()
		LocalPlayer().channel = nil
	end
	return true

end


concommand.Add("br_requestescort", function()
	if !((LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_USA) or LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_USA) then return end
	net.Start("RequestEscorting")
	net.SendToServer()
end)

concommand.Add("br_requestNTFspawn", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("NTFRequest")
		net.SendToServer()
	end
end )

concommand.Add("br_destroygatea", function( ply, cmd, args)
	if ( ply:GetNClass() == ROLES.ROLE_MTFNTF or ply:GetNClass() == ROLES.ROLE_CHAOS or ply:GetNClass() == ROLES.ROLE_USA or ply:GetNClass() == ROLES.ROLE_GoP ) then
		net.Start("ExplodeRequest")
		net.SendToServer()
	end
end )

concommand.Add("br_sound_random", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Random")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_searching", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_USA) and LocalPlayer():Alive() then
		net.Start("Sound_Searching")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_classd", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Classd")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_stop", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Stop")
		net.SendToServer()
	end

end)

concommand.Add("br_sound_lost", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Lost")
		net.SendToServer()
	end
end)
/*
function CalcView3DPerson( ply, pos, angles, fov )
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false
	if thirdpersonenabled then
		local eyepos = ply:EyePos()
		local eyeangles = ply:EyeAngles()
		local point = ply:GetEyeTrace().HitPos
		local goup = 2
		if ply:Crouching() then
			goup = 20
		end
		view.drawviewer = true
		view.origin = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 20)
		view.angles = (point - view.origin):Angle()
		local endps = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 15)
		local tr = util.TraceLine( { start = eyepos, endpos = endps} )
		if tr.Hit then
			view.origin = tr.HitPos
		end
	end
	return view
end
hook.Add( "CalcView", "CalcView3DPerson", CalcView3DPerson )
*/

/*function GM:HUDDrawPickupHistory()

end*/

/*function GM:HUDWeaponPickedUp( weapon )
end*/

hook.Add( "HUDWeaponPickedUp", "DonNotShowCards", function( weapon )
	EQHUD.weps = LocalPlayer():GetWeapons()
	if weapon:GetClass() == "br_keycard" then return false end
end )



function GM:CalcView( ply, origin, angles, fov )
	local data = {}
	data.origin = origin
	data.angles = angles
	data.fov = fov
	data.drawviewer = false
	local item = ply:GetActiveWeapon()
	if IsValid( item ) then
		if item.CalcView then
			local vec, ang, ifov = item:CalcView( ply, origin, angles, fov )
			if vec then data.origin = vec end
			if ang then data.angles = ang end
			if ifov then data.fov = ifov end
		end
	end
	if CamEnable then
		--print( "enabled" )
		if !timer.Exists( "CamViewChange" ) then
			timer.Create( "CamViewChange", 1, 1, function()
				CamEnable = false
			end )
		end
		data.drawviewer = true
		dir = dir or Vector( 0, 0, 0 )
		--print( dir )
		data.origin = ply:GetPos() - dir - dir:GetNormalized() * 30 + Vector( 0, 0, 80 )
		data.angles = Angle( 10, dir:Angle().y, 0 )
	end
	return data

end

function GetWeaponLang()
	if cwlang then
		return cwlang
	end
end

local PrecachedSounds = {}
function ClientsideSound( file, ent )
	ent = ent or game.GetWorld()
	local sound
	if !PrecachedSounds[file] then
		sound = CreateSound( ent, file, nil )
		PrecachedSounds[file] = sound
		return sound
	else
		sound = PrecachedSounds[file]
		sound:Stop()
		return sound
	end
end


net.Receive( "SetRagdollToNULL", function( len )

	local pl = net.ReadEntity()
	pl:SetNWEntity( "RagdollEntityNO", NULL )

end)


net.Receive( "SendSound", function( len )
	local com = net.ReadInt( 2 )
	local f = net.ReadString()
	if com == 1 then
		local snd = ClientsideSound( f )
		snd:SetSoundLevel( 0 )
		snd:Play()
	elseif com == 0 then
		ClientsideSound( f )
	end

end )

concommand.Add( "br_dropweapon", function( ply )
		net.Start("DropCurWeapon")
		net.SendToServer()
end )

concommand.Add( "hhhgg", function(ply)
	--ply:ConCommand("stopsound")

	sound.PlayURL( "https://admin1911.cloudns.cl/spray.wav", "", function()end )
	if timer.Exists( "RoundTime" ) == true then
		net.Start("UpdateTime")
			net.WriteString(tostring(timer.TimeLeft( "RoundTime" )))
		net.Send(ply)
	end
end)

print("cl_init loads")

timer.Simple( 0.1, function()
net.Start( "PlayerReady" )
net.SendToServer()
end )


