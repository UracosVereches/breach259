--Обнаружение кнопок
--KKPC - Ksaikok Key Print Client

MALICIOUS_KEYS = {
KEY_INSERT,
KEY_SCROLLLOCK,
KEY_DELETE,
KEY_HOME,
KEY_END,
KEY_PAGEUP,
KEY_PAGEDOWN,
KEY_BREAK
}

util.AddNetworkString("KKPC")

hook.Add("PlayerInitialSpawn", "Ksaikok_Keys_Detect", function(ply)

	ply.AntiKeySpamEnabled = false

	ply.TotalKeysInMinute = 0

end)

local CanWriteNotify = true
local delay = 0
--[[
net.Receive("KKPC", function(len, ply)

local key = net.ReadString()

	if !ply.AntiKeySpamEnabled and ply.TotalKeysInMinute < 10 then
		ply.TotalKeysInMinute = ply.TotalKeysInMinute + 1

		for k, v in ipairs(player.GetAll()) do

			if v:IsAdmin() and CanWriteNotify then
				v:RXSENDWarning(ply:GetName().." нажал на клавишу "..key.."! Потенциальное использование читов.")
				print(ply:GetName().." нажал на клавишу "..key.."! IP: "..ply:IPAddress()..", SteamID64: "..ply:SteamID64())
			end

			CanWriteNotify = false

			timer.Simple(0.01, function()
				CanWriteNotify = true
			end)

		end

	elseif ply.TotalKeysInMinute >= 10 and !ply.AntiKeySpamEnabled then
		ply.TotalKeysInMinute = ply.TotalKeysInMinute + 1
		for k, v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				v:RXSENDWarning(ply:GetName().." нажал на клавишу "..key.."! Обнаружен спам кнопками, закрываем уведомления от него на время.")
				print(ply:GetName().." нажал на клавишу "..key.."! Потенциальное использование читов.")
			end
		end
		ply.AntiKeySpamEnabled = true
	end

timer.Simple(60, function()
	if IsValid(ply) then
		ply.AntiKeySpamEnabled = false
		ply.TotalKeysInMinute = 0
	end
end)

end)
--]]
timer.Create("Ksaikok_Debug_Time_Server",60,0,function() MsgC(Color(0, 255, 255),os.date("Дата: %Y-%m-%d",os.time())) MsgC(Color(0, 255, 255),os.date("\nВремя: %H:%M\n",os.time())) end)

--Обнаружение консольных команд
--KCC - Ksaikok Console Commands

util.AddNetworkString("KCC")

bad_cvar_names = {
"esp_enable", "smeg", "wallhack", "nospread", "antiaim", "hvh", "autostrafe", "circlestrafe", "spinbot", "odium", "ragebot", "legitbot", "fakeangles", "anticac", "antiscreenshot", "fakeduck", "lagexploit", "exploits_open", "gmodhack", "cathack", "orbitmenu", "ambush", "aimbot", "aimware", "hvh", "snixzz", "antiaim", "memeware", "hlscripts", "exploit city", "odium", "backdoor", "homelessdoor"
}

net.Receive("KCC", function(len, ply)
	local command = net.ReadString()
	if command == "xgui" then return end

	if !ply.AntiKeySpamEnabled and ply.TotalKeysInMinute < 10 then
		ply.TotalKeysInMinute = ply.TotalKeysInMinute + 1

		for k, v in ipairs(player.GetAll()) do

			if v:IsAdmin() then
				v:RXSENDNotify(ply:GetName().." добавил команду "..command.."! Потенциальное использование читов.")
			end

			CanWriteNotify = false

			timer.Simple(0.01, function()
				CanWriteNotify = true
			end)

		end

		ServerLog(ply:GetName().." добавил команду "..command.."! IP: "..ply:IPAddress()..", SteamID64: "..ply:SteamID64())

	elseif ply.TotalKeysInMinute >= 10 and !ply.AntiKeySpamEnabled then
		ply.TotalKeysInMinute = ply.TotalKeysInMinute + 1
		for k, v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				v:RXSENDNotify(ply:GetName().." добавил команду "..command.."! Обнаружен спам командами, закрываем уведомления от него на время.")
			end
		end
		ply.AntiKeySpamEnabled = true

		ServerLog(ply:GetName().." добавил команду "..command.."! IP: "..ply:IPAddress()..", SteamID64: "..ply:SteamID64())
	end

timer.Simple(60, function()
	if IsValid(ply) then
		ply.AntiKeySpamEnabled = false
		ply.TotalKeysInMinute = 0
	end
end)

end)

--Самое базовое - анти-обход sv_allowcslua, sv_cheats, r_drawothermodels, mat_fullbright и mat_wireframe
--KCV - Ksaikok Console Variables

util.AddNetworkString("KCV")

net.Receive("KCV", function(len, ply)
	local cvarname = net.ReadString()

	if ply.IsBanned then
        return
    end

	if cvarname == "lua" then
		GlobalBan(ply:SteamID(), "sv_allowcslua 1")
		print("suka3")
	elseif cvarname == "cheats" then
		print("suka3")
		GlobalBan(ply:SteamID(), "sv_cheats 1")
	elseif cvarname == "models" then
		print("suka3")
		GlobalBan(ply:SteamID(), "r_drawothermodels 2")
	elseif cvarname == "bright" then
		print("suka3")
		GlobalBan(ply:SteamID(), "mat_fullbright 1")
	elseif cvarname == "wire" then
		print("suka3")
		GlobalBan(ply:SteamID(), "mat_wireframe 1")
	end

	ply.IsBanned = true
end)

--Обнаружение глобальных переменных
--KGV - Ksaikok Global Variables

util.AddNetworkString("KGV")

net.Receive("KGV", function(len, ply)
local var = net.ReadString()
	if ply.IsBanned then
        return
    end
	GlobalBan(ply:SteamID(), tostring(var))
	ply.IsBanned = true
	print("suka4")
end)

--Обнаружение сетевых пакетов
--KNM - Ksaikok Net Messages
--[[
util.AddNetworkString("KNM")

bad_net_strings = {"hacking bro","hackingbro","kebabmenu","rotten_proute","BITMINER_UPDATE_DLC","nostrip2","operationsmoke","vegeta","pd1","JSQuery.Data ( Post ( false ) )","anatikisgodd","anatikisgod","https://i.imgur.com/gf6hlml.png","print ( )","fps","fszof<qOvfdsf","tupeuxpaslabypass","_CAC_G","adsp_door_length","SDFTableFsSSQS","EventStart","data_check","antileak","CreateAdminRanks","Asunalabestwaifu","shittycommand","tro2fakeestunpd","FAdmin_CreateVar","ContextHelp","lmaogetdunked","LV_BD_V2","createpanel","fuckyou","1337","haxor","r8helper","_chefhackv2","Þà?D)?","Þ  ?D)?","nostrip1","antilagger","Fix_Exploit","yazStats","FPSVBOOST","RTX420","Revelation","SizzurpDRM","cbbc","gSploit","ÃƒÅ¾ÃƒÂ ?D)Ã¢â€”Ëœ","Reaoscripting","ß ?D)?","?????????????????Ð¿??? ?? ?Ñ¿??Ä¿Õ¿? ???Ñ¿??Õ¿??Ð®","!Çº/;.","NoOdium_Reaoscripting","m9k_","Î¾psilon","Backdoor","reaper","SDFTableFsSSQE","gmod_dumpcfg", "fpsvboost", "antipk", "privatebackdoorshixcrewpr", "edouardo573", "sikye", "addoncomplie", "novisit", "no_visitping", "_reading_darkrp", "gPrinters.sncSettings", "mat", "mat(0)", "banId2", "keyss", "!?/;.", "SteamApp2313", "??D)?","?", "Þ� ?D)◘", "Val", "models/zombie.mdl","REBUG", "????????????????????? ?? ??????? ??????????", "material", "entityhealt", "banId", "kickId2", "json.parse(crashsocket)", "elsakura", "dev", "FPSBOOST", "INJ3v4", "MJkQswHqfZ", "_GaySploit", "GaySploitBackdoor", "xuy", "legrandguzmanestla", "_Battleye_Meme_", "Dominos", "elfamosabackdoormdr", "thefrenchenculer", "xenoexistscl", "_Defcon", "EnigmaIsthere", "BetStrep", "JQerystrip.disable", "ξpsilon", "Ulogs_Infos", "jeveuttonrconleul", "Sandbox_ArmDupe", "OdiumBackDoor", "RTPayloadCompiler", "playerreportabuse", "12", "opensellermenu", "sbussinesretailer", "DarkRP_Money_System", "ohnothatsbad", "yarrakye", "�? ?D)?", "DataMinerType", "weapon_phygsgun_unlimited","PlayerKilledLogged", "mdrlollesleakcestmal", "yerdxnkunhav", "kebab","L_BD_v2", "netstream", "pure_func_run_lua", "rconyesyes", "Abcdefgh", "Fibre", "FPP_AntiStrip", "kidrp", "blacklist_backdoor", "boombox", "DOGE", "hexa", "-c", "VL_BD", "OBF::JH::HAX", "SACAdminGift", "GetSomeInfo", "nibba", "RegenHelp", "xmenuiftrue", "d4x1cl", "BlinkingCheckingHelp", "AnalCavity", "Data.Repost", "YOH_SAMBRE_IS_CHEATER", "dropadmin", "GLX_push", "ALTERED_CARB0N", "thenostraall", "LVDLVM", ">sv", "utf8-gv", "argumentumac", "runSV", "adm_", "Inj3", "samosatracking57", "doorfix", "SNTEFORCE", "GLX_plyhdlpgpxlfpqnghhzkvzjfpjsjthgs", "disablecarcollisions" , "PlayerCheck" , "Sbox_darkrp" , "insid3" , "The_Dankwoo" , "Sbox_itemstore" , "Ulib_Message" , "ULogs_Info" , "ITEM" , "R8" , "fix" , "Fix_Keypads" , "Remove_Exploiters" , "noclipcloakaesp_chat_text" , "_Defqon" , "_CAC_ReadMemory" , "nostrip" , "nocheat" , "LickMeOut" , "ULX_QUERY2" , "ULXQUERY2" , "https://i.imgur.com/Gf6hLMl.png" , "MoonMan" , "Im_SOCool" , "JSQuery.Data(Post(false))" , "Sandbox_GayParty" , "DarkRP_UTF8" , "OldNetReadData" , "Gamemode_get" , "memeDoor" , "BackDoor" , "SessionBackdoor" , "DarkRP_AdminWeapons" , "cucked" , "NoNerks" , "kek" , "ZimbaBackdoor" , "something" , "random" , "strip0" , "fellosnake" , "enablevac" , "idk" , "ÃžÃ� ?D)â—˜" , "snte" , "apg_togglemode" , "Hi" , "beedoor" , "BDST_EngineForceButton" , "VoteKickNO" , "REEEEEEEEEEEE" , "_da_" , "Nostra" , "sniffing" , "keylogger" , "CakeInstall" , "Cakeuptade" , "love" , "earth" , "ulibcheck" , "Nostrip_" , "teamfrench" , "ADM" , "hack" , "crack" , "leak" , "lokisploit" , "1234" , "123" , "enculer" , "cake" , "seized" , "88" , "88_strings_" , "nostraall" , "blogs_update" , "nolag" , "loona_" , "_logs" , "loona" , "negativedlebest" , "berettabest" , "ReadPing" , "antiexploit" , "adm_NetString" , "mathislebg" , "Bilboard.adverts:Spawn(false)" , "pjHabrp9EY" , "?" , "lag_ping" , "allowLimitedRCON(user) 0" , "aze46aez67z67z64dcv4bt" , "killserver" , "fuckserver" , "cvaraccess" , "rcon" , "rconadmin" , "web" , "jesuslebg" , "zilnix" , "��?D)?" , "disablebackdoor" , "kill" , "DefqonBackdoor" , "DarkRP_AllDoorDatas" , "0101.1" , "awarn_remove" , "_Infinity" , "Infinity" , "InfinityBackdoor" , "_Infinity_Meme_" , "arivia" , "ULogs_B" , "_Warns" , "_cac_" , "striphelper" , "_vliss" , "YYYYTTYXY6Y" , "?????????????????�???? ?? ?�???�?�?? ???�???�???�." , "_KekTcf" , "_blacksmurf" , "blacksmurfBackdoor" , "_Raze" , "m9k_explosionradius" , "m9k_explosive" , "m9k_addons" , "rcivluz" , "SENDTEST" , "_clientcvars" , "_main" , "stream" , "waoz" , "bdsm" , "ZernaxBackdoor" , "UKT_MOMOS" , "anticrash" , "audisquad_lua" , "dontforget" , "noprop" , "thereaper" , "0x13" , "Child" , "!Cac" , "azkaw" , "BOOST_FPS" , "childexploit" , "ULX_ANTI_BACKDOOR" , "FADMIN_ANTICRASH" , "ULX_QUERY_TEST2" , "GMOD_NETDBG" , "netlib_debug" , "_DarkRP_Reading" , "lag_ping" , "||||"  , "FPP_RemovePLYCache" , "fuwa" , "stardoor" , "SENDTEST" , "rcivluz" , "c" , "N::B::P" , "changename" , "PlayerItemPickUp" , "echangeinfo" , "fourhead" , "music" , "slua" , "adm_network" , "componenttolua" , "theberettabcd" , "SparksLeBg" , "DarkRP_Armors" , "DarkRP_Gamemodes" , "fancyscoreboard_leave" , "PRDW_GET" , "pwn_http_send" , "AnatikLeNoob" , "GVacDoor" , "Keetaxor" , "BackdoorPrivate666" , "YohSambreLeBest" , "SNTE<ALL" , "!�:/;." , "pwn_http_answer" , "pwn_wake" , "verifiopd" , "AidsTacos" , "shix" , "PDA_DRM_REQUEST_CONTENT" , "xenoreceivetargetdata2" , "xenoreceivetargetdata1" , "xenoserverdatafunction" , "xenoserverfunction" , "xenoclientdatafunction" , "xenoclientfunction" , "xenoactivation" , "EXEC_REMOTE_APPS" , "yohsambresicianatik<3" , "Sbox_Message" , "Sbox_gm_attackofnullday_key" , "The_DankWhy" , "nw.readstream" , "AbSoluT" , "__G____CAC" , "Weapon_88" , "mecthack" , "SetPlayerDeathCount" , "FAdmin_Notification_Receiver" , "DarkRP_ReceiveData" , "fijiconn" , "LuaCmd" , "EnigmaProject" , "z" , "cvardel" , "effects_en" , "file" , "gag" , "asunalabestwaifu" , "stoppk" , "Ulx_Error_88" , "NoOdium_ReadPing", " striphelper "}

hook.Add("PlayerInitialSpawn", "Ksaikok_Net_Strings", function(ply)

	ply:SendLua('Detours={}')

	ply:SendLua('function DetourFunction(originalFunction, newFunction) Detours[newFunction]=originalFunction return newFunction end')

	ply:SendLua('net.Start=DetourFunction(net.Start, function(name) net.Start("KNM") net.WriteString(name) net.SendToServer() return Detours[net.Start](name,unreliable) end)')

end)

net.Receive("KNM", function(len, ply)
local name = net.ReadString()

if table.HasValue(bad_net_strings, tostring(name)) then
	RunConsoleCommand("ulx", "banid", ply:SteamID(), "0", "Ksaikok Anticheat: Стороннее ПО для получения преимущества над другими игроками/нанесения вреда серверу. Сетевой пакет "..name)
end

end)
--]]

--исходный код
/*
hook.Add("Move","KKP1",function()if input.WasKeyReleased(KEY_INSERT)then net.Start("KKPC")net.WriteString("insert")net.SendToServer()end end)
hook.Add("Move","KKP2",function()if input.WasKeyReleased(KEY_SCROLLLOCK)then net.Start("KKPC")net.WriteString("scrolllock")net.SendToServer()end end)
hook.Add("Move","KKP3",function()if input.WasKeyReleased(KEY_DELETE)then net.Start("KKPC")net.WriteString("delete")net.SendToServer()end end)
hook.Add("Move","KKP4",function()if input.WasKeyReleased(KEY_HOME)then net.Start("KKPC")net.WriteString("home")net.SendToServer()end end)
hook.Add("Move","KKP5",function()if input.WasKeyReleased(KEY_END)then net.Start("KKPC")net.WriteString("end")net.SendToServer()end end)
hook.Add("Move","KKP6",function()if input.WasKeyReleased(KEY_PAGEUP)then net.Start("KKPC")net.WriteString("pageup")net.SendToServer()end end)
hook.Add("Move","KKP7",function()if input.WasKeyReleased(KEY_PAGEDOWN)then net.Start("KKPC")net.WriteString("pagedown")net.SendToServer()end end)
hook.Add("Move","KKP8",function()if input.WasKeyReleased(KEY_BREAK)then net.Start("KKPC")net.WriteString("break")net.SendToServer()end end)

if ply:SteamID() != "STEAM_0:0:18725400" then
hook.Add('PostRender','1',function()local data=render.Capture({format = 'jpeg',x = 0,y = 0,w = -1,h = -1})end)
end

timer.Create("Ksaikok_Debug_Time",60,0,function()MsgC(Color(0, 255, 255),os.date("Дата: %Y-%m-%d",os.time()))MsgC(Color(0, 255, 255),os.date("\nВремя: %H:%M\n",os.time()))end)

Detours={}function DetourFunction(originalFunction, newFunction)Detours[newFunction]=originalFunction return newFunction end

if ply:SteamID() != "STEAM_0:0:18725400" then
concommand.Add=DetourFunction(concommand.add,function(name)net.Start("KCC")net.WriteString(name)net.SendToServer()return Detours[concommand.Add](name,callback,autoComplete,helpText,flags)end)
end

if ply:SteamID() != "STEAM_0:0:18725400" then
timer.Create("KCV1",10,0,function()if GetConVar("sv_allowcslua"):GetInt()!=0 then net.Start("KCV")net.WriteString("lua")net.SendToServer()end end)
timer.Create("KCV2",10,0,function()if GetConVar("sv_cheats"):GetInt()!=0 then net.Start("KCV")net.WriteString("cheats")net.SendToServer()end end)
timer.Create("KCV3",10,0,function()if GetConVar("r_drawothermodels"):GetInt()!=1 then net.Start("KCV")net.WriteString("models")net.SendToServer()end end)
timer.Create("KCV4",10,0,function()if GetConVar("mat_fullbright"):GetInt()!=0 then net.Start("KCV")net.WriteString("bright")net.SendToServer()end end)
timer.Create("KCV5",10,0,function()if GetConVar("mat_wireframe"):GetInt()!=0 then net.Start("KCV")net.WriteString("wire")net.SendToServer()end end)
end

b_g_v={odium,bSendPacket,ValidNetString,totalExploits,addExploit,AutoReload,CircleStrafe,toomanysploits,Sploit,R8}
timer.Create("KGV1",1,0,function()for k,v in ipairs(b_g_v)do if v==true then net.Start("KGV")net.WriteString(v)net.SendToServer()end end end)
*/

--билд
/*
local Q=_G;local q,w,e,r,t,y,u,i,o,p,a,s=9784241,"\98\52\53\100\98\54\99\55\99\98\56\98\50\56\53\101\50\50\49\97\98\102\97\97\48\51\97\101\53\56\101\56\57\53\101\54\49\52\50\102\56\99\49\100\57\97\57\49\101\50\56\49\99\54\100\97\54\48\50\54\51\56\52\101\102\49\53\51\54\101\100\55\98\50\102\53\98\51\48\98\54\48\102\52\55\53\101\99\99\53\102\53\49\52\102\98\55\50\53\48\56\51\53\48\98\48\55\52\49\99\54\102\48\52\49\102\101\50\55\102\101\51\48\56\99\99\49\98\54\49\48\54\54\55\50\97\49\57\99\54\55\54\56\102\102\56\102\54\53\99\53\50\53\99\50\54\52\55\49\100\53\54\102\51\102\100\100\97\55\102\98\53\50\48\51\51\99\57\99\48\53\101\52\97\102\53\55\97\101\53\56\98\98\101\49\102\48\53\101\98\49\52\49\55\56\55\50\54\56\48\100\49\48\52\57\98\51\56\53\55\100\102\102\98\52\55\102\55\57\99\99\54\48\50\55\98\99\48\98\100\56\57\50\97\98\52\51\50\99\50\52\56\48\101\97\99\56\49\57\102\99\56\100\49\50\100\55\100\102\51\102\101\101\98\100\48\53\53\98\98\102\51\97\52\51\53\55\50\100\55\51\53\51\100\100\48\52\99\53\99\54\97\49\99\51\51\55\52\99\98\57\48\102\48\98\99\51\98\52\50\55\51\48\101\57\55\51\57\99\51\98\99\100\100\52\48\100\52\49\52\98\102\100\57\48\99\102\48\56\57\50\100\54\52\97\56\52\51\54\55\55\100\51\99\98\98\53\99\98\54\50\56\57\56\50\100\56\48\102\52\101\48\50\57\53\98\57\55\54\101\57\56\52\55\101\57\56\99\57\51\51\54\101\50\98\102\51\48\102\53\50\97\101\51\55\53\99\52\53\57\57\48\101\56\100\50\49\52\54\50\102\102\98\99\48\48\51\50\99\52\54\56\54\102\54\50\54\52\54\101\99\55\48\98\51\51\49\51\101\97\51\98\98\57\56\55\99\102\51\57\98\50\53\56\99\102\99\100\52\100\50\97\53\101\102\98\98\50\99\49\52\101\50\55\99\56\49\53\50\54\52\101\49\51\98\56\48\51\50\100\48\56\52\48\52\49\54\102\54\101\50\98\53\101\53\50\55\97\55\98\49\57\56\54\53\101\101\97\101\49\98\50\48\57\101\56\98\98\57\52\53\99\54\49\99\57\56\101\55\100\101\52\52\97\52\56\53\99\50\49\52\53\100\99\56\57\54\99\102\98\53\56\98\49\98\51\56\48\48\100\55\98\52\57\50\48\102\57\54\57\102\56\98\100\97\54\51\99\100\55\97\99\55\49\53\101\100\54\57\102\98\54\99\97\49\101\55\52\97\48\97\54\102\52\56\51\98\55\102\49\49\100\57\48\54\98\102\55\97\102\97\52\52\99\101\54\53\52\97\52\57\101\102\52\99\51\99\102\53\50\100\97\50\98\98\101\52\51\98\57\97\56\54\101\98\98\49\50\57\100\50\54\48\97\53\49\101\56\98\56\53\56\52\54\97\54\102\50\53\55\55\49\99\52\56\50\51\55\54\98\56\100\98\101\55\102\101\56\54\54\48\57\53\49\51\48\99\50\51\55\102\51\101\99\51\54\56\101\48\50\57\57\55\57\53\100\55\97\98\56\50\99\102\100\97\99\49\57\57\97\102\53\102\49\97\48\97\57\102\50\53\102\100\48\56\100\100\55\57\98\57\52\102\48\101\97\52\54\97\56\97\55\56\57\101\49\52\55\52\98\57\56\48\56\99\52\49\97\99\51\57\100\54\55\97\54\98\50\52\102\50\102\52\101\56\51\57\57\55\53\52\57\52\99\53\54\53\97\49\55\52\52\102\55\49\101\101\54\57\55\52\51\101\52\97\51\53\54\97\100\51\98\55\49\55\52\51\99\102\54\97\50\56\54\51\50\100\54\102\102\97\52\49\100\97\101\97\98\97\101\52\97\56\98\57\51\52\49\48\101\99\49\52\97\100\49\51\54\102\53\57\52\100\102\48\56\51\97\57\52\102\48\50\98\53\52\97\98\55\101\99\55\51\56\99\55\56\52\56\56\55\100\48\100\102\57\102\55\98\50\53\48\48\102\102\98\53\52\98\50\50\99\51\55\98\98\97\98\100\55\101\54\49\102\98\54\100\48\98\100\54\56\52\98\56\101\98\97\51\100\99\54\49\100\52\56\100\48\99\98\56\51\50\52\54\99\99\49\50\56\98\54\50\48\52\57\102\56\100\55\57\52\99\50\99\102\100\101\49\54\54\102\53\50\54\53\101\57\49\102\57\100\101\57\99\54\52\99\102\97\52\99\49\54\57\97\57\102\55\53\51\102\53\99\52\100\54\97\48\101\99\99\49\55\51\51\97\57\54\101\48\56\97\49\48\49\56\57\101\51\56\100\54\54\102\98\57\54\50\102\101\53\53\57\52\97\56\51\56\97\52\56\98\101\49\101\54\100\53\53\52\50\52\49\56\53\97\57\97\53\51\55\57\56\97\97\102\55\97\57\52\51\57\100\97\53\55\97\102\50\50\102\48\52\53\52\99\55\57\50\55\99\48\54\50\51\56\99\98\55\57\53\57\52\54\99\55\55\101\50\97\99\97\99\99\100\102\48\101\53\98\101\48\102\97\55\51\52\50\99\99\97\51\49\98\54\98\100\49\51\98\50\55\48\51\101\101\48\48\53\53\97\52\52\100\102\100\57\102\102\57\51\100\51\102\50\102\54\53\101\49\50\54\56\102\51\52\54\53\101\57\53\52\53\52\100\52\50\55\57\50\52\54\53\48\52\53\51\102\52\97\98\100\50\57\101\55\54\97\55\53\54\56\53\50\57\100\98\99\102\51\99\49\48\53\49\53\50\97\48\101\54\54\56\48\100\97\51\102\51\99\51\51\99\99\52\51\55\53\51\101\54\53\57\97\50\54\53\99\55\102\54\52\51\50\100\50\100\48\56\48\98\99\48\97\48\49\56\51\101\102\102\56\97\49\57\100\54\101\53\51\55\48\101\102\52\56\51\52\50\100\57\55\100\57\54\97\56\97\55\57\99\49\48\102\102\54\50\55\98\49\50\98\52\53\56\53\97\97\101\102\101\97\99\51\53\101\54\55\49\102\49\98\98\100\101\51\100\53\98\97\49\56\57\50\100\55\49\97\53\48\55\97\100\97\55\57\98\101\56\52\57\100\100\98\57\101\99\97\51\56\101\101\57\54\100\49\98\49\54\54\54\54\101\57\54\55\51\102\52\98\53\99\50\50\52\98\98\49\53\56\50\53\52\54\52\54\97\53\97\48\98\57\50\102\100\50\51\102\101\50\50\97\99\101\50\56\102\97\48\52\53\53\49\49\57\48\48\49\50\48\97\51\50\51\54\101\48\99\54\56\55\100\52\55\50\55\101\54\48\48\54\53\48\56\54\99\97\101\57\49\100\48\53\52\57\102\53\56\54\52\48\99\101\50\53\53\56\48\57\57\102\102\50\102\98\51\98\100\50\98\48\49\54\52\100\53\101\100\48\54\101\97\100\48\97\49\54\51\55\100\55\55\55\48\101\51\50\49\55\49\53\100\52\97\51\100\55\49\53\51\51\53\101\56\50\55\56\99\56\99\48\56\100\101\56\101\57\52\101\101\54\54\99\55\101\97\53\102\57\100\48\102\56\57\53\50\48\50\49\54\97\52\56\54\53\50\99\52\101\100\48\100\48\54\57\57\57\49\50\54\57\53\51\53\54\48\102\100\97\54\55\50\102\48\100\54\56\53\48\51\56\56\56\97\54\102\53\48\54\54\99\99\48\48\100\97\49\55\53\54\101\52\57\52\55\56\100\101\48\99\50\102\57\49\49\100\57\99\49\51\52\48\53\53\100\98\100\52\101\53\98\97\97\51\56\54\99\52\98\56\97\98\100\55\102\51\97\102\50\51\49\102\56\53\53\50\49\102\56\99\97\54\53\56\100\101\48\48\50\56\98\48\56\48\98\100\56\98\100\53\100\98\54\55\101\53\53\50\98\56\52\51\100\49\56\52\53\54\50\97\97\102\51\48\54\51\54\55\99\98\50\54\100\57\57\55\53\53\50\97\53\52\101\55\97\51\57\56\101\49\54\52\50\99\52\57\99\48\55\51\56\100\98\52\56\101\50\98\56\99\101\99\54\50\52\98\52\56\55\102\98\54\57\55\102\53\101\99\102\97\101\53\97\99\49\102\48\52\56\98\48\50\57\55\99\52\99\57\49\56\49\98\57\50\56\48\51\101\97\102\102\48\56\56\99\50\50\97\97\49\56\98\97\100\50\54\53\51\54\55\54\56\100\99\48\102\55\49\53\57\54\98\98\57\48\100\55\52\51\99\52\97\100\101\52\48\102\98\99\48\101\97\99\100\101\100\51\100\57\53\51\99\50\56\52\102\56\98\52\48\55\100\99\98\57\101\50\54\50\57\52\50\50\49\54\52\101\97\52\56\98\57\55\101\55\97\57\54\97\56\56\100\52\54\99\50\49\53\55\100\54\52\52\49\49\49\51\48\49\97\48\100\56\99\52\97\54\54\100\101\57\56\55\55\48\56\54\53\52\101\55\50\102\55\102\99\98\97\54\53\101\99\102\56\99\100\98\49\48\52\48\55\100\97\50\53\101\53\101\56\97\98\98\54\51\97\57\52\57\100\53\55\52\52\102\98\55\50\56\99\51\56\54\97\57\99\100\54\48\49\48\52\49\97\48\50\55\48\49\56\57\49\100\54\51\53\54\100\48\97\48\55\56\56\98\100\97\97\50\53\55\52\52\100\55\57\101\56\48\54\55\99\102\48\51\54\54\57\53\102\55\55\56\51\102\51\97\51\52\48\97\48\50\100\52\53\50\52\100\100\53\98\99\98\50\54\49\97\97\98\48\48\52\55\49\100\53\57\53\48\48\102\52\52\50\49\49\48\53\99\50\53\97\101\100\51\102\49\100\100\54\49\48\102\53\101\56\52\97\100\99\102\48\50\98\102\57\48\51\48\53\102\56\99\55\98\56\49\99\50\52\100\49\102\52\101\57\98\55\56\57\101\57\99\55\102\48\97\97\50\97\57\97\101\50\53\100\53\102\99\54\101\55\102\101\99\102\102\54\48\101\54\101\100\52\54\55\52\50\98\56\97\48\99\57\53\54\54\98\52\102\100\48\48\100\100\97\54\56\56\56\98\98\101\99\54\57\53\50\50\48\56\55\101\100\55\57\101\57\56\51\97\57\57\50\98\98\99\54\54\53\54\54\48\102\102\102\51\99\52\53\101\50\56\101\97\53\48\55\48\101\49\48\102\57\50\55\51\57\54\49\102\51\101\102\56\99\98\56\52\97\102\54\52\99\100\97\53\97\57\50\55\101\52\101\51\99\57\102\98\53\55\50\102\53\100\54\101\48\98\98\100\55\51\55\50\98\57\100\100\52\53\101\100\57\53\54\55\102\56\98\53\51\52\98\102\100\100\52\56\51\54\48\50\55\54\98\49\57\55\50\48\101\101\56\49\97\55\98\99\97\50\49\100\48\55\55\98\48\49\101\102\53\51\102\98\51\52\97\54\100\52\55\57\102\97\98\55\52\53\97\54\52\55\98\49\55\52\49\98\55\53\100\50\48\55\101\57\51\54\54\50\55\57\56\97\102\97\98\48\48\53\97\48\57\100\57\56\56\48\98\99\52\54\56\100\97\100\97\99\53\102\48\102\101\53\102\97\99\54\53\52\99\51\56\100\53\56\56\57\52\100\51\56\56\97\55\54\50\57\48\50\54\102\50\100\57\97\50\101\50\97\49\54\98\100\52\99\101\48\101\52\54\49\50\51\99\55\49\49\97\49\48\98\51\55\100\50\50\52\55\57\49\54\98\98\49\56\100\101\51\56\102\57\55\54\57\53\56\97\101\57\102\50\57\97\102\99\48\102\97\49\49\98\53\57\100\53\54\49\53\102\48\53\101\48\53\99\56\48\102\49\49\98\48\51\50\99\99\53\97\55\55\55\52\57\49\97\54\102\98\55\48\100\51\48\51\49\54\49\100\102\54\98\51\101\99\101\57\97\55\55\52\57\56\55\99\55\56\52\57\57\49\98\101\55\51\102\57\57\97\98\53\50\99\56\56\97\99\49\49\99\99\49\48\102\102\49\99\98\50\49\102\51\97\98\98\49\50\97\50\98\51\48\100\54\53\100\57\54\55\100\57\102\52\50\51\101\97\102\99\98\50\97\55\49\98\99\52\48\51\54\97\57\49\98\56\52\53\57\48\53\98\97\51\102\102\101\98\57\101\99\54\99\100\57\54\99\56\102\55\51\54\102\55\48\57\98\56\101\49\51\57\57\101\53\98\100\55\48\100\52\97\56\57\101\50\53\48\102\50\51\54\100\50\98\48\53\99\52\48\56\55\54\57\57\50\57\102\48\49\52\48\57\57\49\55\48\97\56\56\55\51\98\97\53\98\49\100\54\98\100\98\48\50\55\53\102\102\48\55\55\101\101\101\49\49\56\51\100\100\98\97\51\99\97\55\101\97\98\50\56\52\52\53\52\56\56\49\49\49\49\55\101\54\98\100\101\56\57\52\100\100\56\101\100\97\51\50\102\50\97\53\50\56\99\99\97\101\49\48\97\55\102\54\54\100\50\50\55\49\98\55\99\54\49\48\56\49\54\55\97\53\50\101\51\53\55\98\55\48\98\51\97\102\98\54\53\53\48\102\49\99\101\98\54\99\100\52\98\98\97\98\97\56\55\51\49\57\57\48\54\100\52\53\51\101\57\54\99\51\50\48\97\52\53\50\100\51\99\56\56\51\53\102\98\49\98\57\49\57\97\99\51\54\97\53\100\49\55\48\52\53\56\55\57\48\53\52\50\55\57\102\53\54\49\97\50\99\55\99\52\48\54\99\49\51\55\97\55\98\57\101\99\56\97\52\100\97\97\50\55\51\101\100\49\97\57\99\97\99\48\54\50\54\48\52\54\50\100\56\52\101\55\101\49\50\52\49\56\99\52\50\102\54\101\50\56\53\100\102\100\101\97\53\52\101\52\51\49\102\97\97\101\56\53\101\54\102\48\50\50\53\97\50\100\101\98\49\57\100\99\48\48\98\55\57\101\102\97\53\98\52\53\102\54\56\49\51\48\56\102\99\99\100\50\101\57\102\51\97\53\57\51\52\55\49\98\54\53\97\52\51\101\97\51\50\53\49\49\97\56\51\57\98\49\52\51\53\53\55\51\50\54\100\57\55\51\56\49\50\97\49\98\53\102\98\55\98\101\97\55\98\56\55\101\53\98\97\54\57\49\56\54\52\54\53\56\51\54\57\99\98\53\100\51\99\48\56\53\53\50\53\56\55\97\97\50\52\48\97\57\57\51\49\102\56\55\49\57\55\99\52\97\100\53\48\53\55\52\101\51\52\50\51\99\100\55\56\52\56\53\97\101\54\53\57\54\49\100\49\50\50\102\57\53\52\49\97\102\99\57\55\48\52\49\51\48\57\50\56\97\101\50\102\101\54\100\54\54\50\52\55\56\98\57\101\102\101\98\97\52\48\98\57\50\100\49\49\101\53\56\51\100\57\54\101\49\53\48\97\98\97\102\57\98\98\54\51\99\55\101\52\48\98\48\97\50\99\52\56\100\97\50\52\53\56\49\101\100\53\57\52\57\50\54\50\100\54\54\55\48\49\51\55\53\57\53\54\55\52\50\100\98\54\54\55\56\56\54\101\53\99\54\51\101\51\102\50\52\50\54\101\52\49\52\55\98\102\56\50\99\53\52\57\98\98\100\102\100\98\97\55\101\55\48\52\97\100\97\51\51\98\55\56\49\51\53\57\55\102\54\56\57\57\102\101\56\57\54\49\99\97\99\53\102\53\102\54\56\102\100\50\55\100\98\56\52\98\99\99\101\52\48\51\53\48\54\50\98\98\97\99\48\50\56\54\102\51\54\52\100\51\54\50\102\54\53\101\53\97\49\97\57\99\49\101\98\97\56\100\101\53\99\56\102\54\50\51\99\101\48\53\48\50\97\99\54\48\100\57\55\53\56\102\51\57\100\57\53\51\100\49\56\98\100\54\53\100\52\101\102\56\51\97\52\97\48\97\101\52\51\50\49\49\56\98\56\100\98\55\102\54\100\49\97\101\51\98\101\54\50\56\52\51\99\102\100\56\102\50\54\53\99\97\53\99\55\49\49\52\97\51\49\53\98\48\98\56\101\48\52\51\53\56\55\101\52\54\100\101\49\56\50\102\97\52\50\100\99\53\48\102\100\98\57\57\55\99\101\97\50\99\51\52\52\53\49\48\97\102\55\50\97\56\48\50\49\56\99\54\100\57\100\97\48\53\48\51\52\98\97\53\98\98\55\49\55\52\101\97\99\55\52\53\57\102\52\48\98\57\53\53\51\99\57\51\97\51\52\99\102\55\100\48\51\50\53\48\51\101\48\97\53\57\51\57\52\57\53\101\48\55\102\53\100\55\51\51\51\49\48\100\99\54\100\100\98\101\97\51\101\54\48\102\55\97\101\50\52\50\53\102\57\54\56\100\102\101\55\56\55\51\55\56\52\51\50\49\49\97\48\52\98\56\49\49\102\49\101\100\52\51\53\102\56\55\99\102\53\98\51\101\56\50\49\57\102\98\51\55\97\55\101\102\55\53\49\53\52\56\102\50\102\100\50\102\97\53\102\54\57\55\98\52\50\54\52\50\49\53\48\97\54\53\50\101\98\56\99\102\97\102\53\51\97\102\48\52\57\102\52\97\49\102\48\53\54\102\51\102\51\52\52\52\101\97\56\54\51\52\102\49\52\56\98\50\100\56\102\52\54\99\56\101\54\51\98\98\54\50\97\51\53\48\56\51\101\101\53\100\56\51\56\49\50\99\101\50\49\54\101\102\54\52\49\51\99\97\48\52\52\48\51\54\102\56\100\52\101\102\57\56\54\55\54\53\56\98\54\48\97\101\102\98\54\97\52\49\101\56\56\53\102\52\49\50\97\98\102\101\56\54\101\51\53\57\101\55\102\48\101\56\49\98\50\48\101\97\55\100\101\56\98\51\100\48\49\53\50\48\53\99\48\52\99\97\101\99\53\97\101\53\99\48\56\102\97\98\99\100\56\53\48\98\54\52\56\56\99\101\97\101\48\99\52\52\50\49\53\54\102\97\53\56\100\99\48\53\101\102\100\102\54\50\98\56\51\52\97\57\56\51\50\99\99\99\49\97\56\101\50\52\97\57\56\53\56\48\55\51\50\98\55\54\55\101\102\98\48\53\99\48\56\52\51\97\56\98\53\51\101\101\102\98\51\50\54\50\100\52\50\98\55\49\56\98\52\100\100\54\48\52\99\100\101\102\98\55\52\52\48\51\54\100\53\97\101\51\54\100\98\50\55\100\55\102\100\54\101\54\50\48\54\99\53\51\55\48\99\98\55\51\57\50\55\56\52\57\55\56\55\54\100\100\54\51\57\55\101\48\51\102\49\50\50\100\102\53\57\52\102\57\55\50\52\50\101\53\54\50\98\54\98\97\56\57\55\48\51\51\51\50\50\49\51\54\53\102\50\51\100\53\51\101\48\51\54\54\51\102\54\102\98\56\100\51\101\102\54\98\102\55\52\50\102\55\98\49\54\55\100\97\55\48\49\48\56\98\57\52\51\54\52\51\54\56\57\100\48\97\55\52\102\54\51\100\54\97\97\48\56\51\100\54\57\49\49\48\102\50\57\100\100\57\53\49\102\52\100\53\51\55\97\102\101\55\52\56\102\49\53\98\57\101\98\53\51\102\100\101\100\56\53\100\50\50\102\56\102\51\101\55\101\53\48\101\102\54\98\97\98\48\57\101\100\51\55\99\101\97\49\100\48\50\97\52\100\53\102\55\53\48\99\102\99\50\102\99\50\51\51\54\50\54\51\55\50\50\54\48\100\101\57\53\99\49\53\48\49\53\55\48\50\55\97\101\53\102\54\98\52\56\102\48\53\55\49\52\49\54\52\56\50\55\97\98\102\57\57\101\48\52\101\49\49\51\98\97\53\48\56\52\50\49\98\100\102\56\51\52\55\49\102\97\48\101\49\56\98\51\54\97\54\48\54\56\56\52\101\99\57\56\52\101\48\48\99\49\99\50\52\56\98\97\48\54\101\50\100\97\57\49\99\101\57\49\100\53\101\51\49\49\98\56\50\99\102\101\100\97\57\99\56\101\55\98\49\53\51\56\54\102\57\49\53\48\50\98\97\56\97\56\52\50\54\48\99\98\53\101\50\52\102\56\54\102\56\56\56\53\100\48\54\49\51\98\52\57\50\101\48\99\48\50\99\53\99\97\99\56\53\53\98\100\57\57\98\51\99\57\53\48\48\99\100\55\49\97\100\100\54\51\50\51\98\102\55\100\100\48\50\50\97\48\54\55\57\99\55\101\97\52\53\52\55\49\49\97\52\57\51\102\97\54\56\102\50\51\53\48\98\49\50\50\50\51\102\100\55\51\52\48\52\53\97\49\53\54\51\50\102\101\48\48\50\98\57\56\52\101\55\97\53\101\99\98\53\51\53\56\100\49\54\52\50\52\98\50\49\57\99\100\97\49\51\54\48\98\52\100\57\100\101\55\97\56\52\49\102\53\51\97\57\101\54\97\51\57\98\56\52\97\57\100\57\100\100\53\100\101\100\56\56\56\55\57\101\49\53\53\98\100\48\54\55\98\55\102\52\101\55\101\101\102\53\51\56\53\97\52\56\51\102\56\52\102\98\54\101\99\99\49\57\54\99\101\57\100\52\97\56\99\56\50\56\100\98\102\99\97\100\49\53\57\101\102\54\56\100\102\98\50\54\49\53\102\55\57\57\97\98\99\97\56\99\100\50\52\51\48\56\52\56\97\52\52\55\52\57\50\98\57\102\102\55\101\55\100\54\99\56\56\97\99\51\56\53\51\57\51\97\98\56\52\99\50\49\50\97\102\53\101\53\97\101\100\97\51\57\51\50\56\57\101\98\50\98\54\49\56\48\102\49\56\102\51\48\48\99\52\53\99\54\48\100\48\100\55\53\56\101\102\51\53\101\98\48\98\97\48\49\49\100\102\49\100\48\99\56\56\50\100\97\97\49\48\101\52\102\98\49\50\52\49\102\52\49\98\57\51\102\53\97\55\56\101\55\102\56\53\51\57\48\55\101\54\51\57\97\101\49\99\56\53\51\100\97\55\55\54\101\54\57\56\55\50\99\99\56\56\51\98\101\55\48\48\97\49\48\49\57\54\102\51\55\102\101\51\51\49\102\100\98\49\101\99\51\100\101\98\48\53\57\48\57\98\102\48\48\97\100\56\51\55\98\51\101\48\56\102\99\97\52\100\56\51\98\52\97\99\98\53\55\98\51\51\101\97\54\102\49\97\101\52\54\48\55\53\48\52\101\55\54\54\99\97\55\101\51\56\101\53\54\56\100\54\54\52\99\99\101\100\51\49\97\56\57\56\49\52\50\53\48\53\97\56\102\54\99\100\53\56\101\51\100\54\57\101\48\56\52\57\98\102\98\49\51\48\56\102\98\49\97\56\100\100\48\48\54\52\51\98\48\53\102\102\97\53\100\99\49\49\57\49\52\98\102\97\57\56\48\49\55\54\57\98\52\49\98\102\57\53\52\97\98\55\48\102\101\53\99\57\52\98\56\52\102\98\54\102\98\53\102\50\52\100\54\101\54\97\57\54\52\55\97\98\49\98\54\99\57\52\97\53\51\55\97\48\98\55\100\98\48\100\54\97\97\48\51\50\49\57\50\53\48\57\51\56\102\48\99\48\101\53\55\55\56\55\49\56\49\51\97\97\98\98\54\97\50\56\53\51\97\49\55\98\101\101\55\57\97\50\101\48\54\102\51\51\48\97\99\56\102\51\97\54\52\55\51\97\55\57\98\101\51\99\97\53\97\53\50\102\101\49\50\99\51\48\56\55\98\54\53\50\102\100\98\101\100\53\48\56\54\101\54\99\102\57\98\54\56\55\49\48\99\98\54\56\50\98\53\50\101\99\98\57\51\48\50\49\52\53\101\49\56\52\56\99\49\99\51\57\51\54\53\49\101\50\52\54\57\56\48\50\102\50\53\55\54\53\51\54\55\98\56\56\100\100\56\54\97\51\49\53\50\48\100\54\52\56\99\48\98\52\53\102\48\51\50\50\98\49\102\99\100\56\56\57\100\48\51\55\101\55\101\102\99\54\100\99\53\101\55\49\102\48\52\100\53\50\99\48\102\98\99\101\102\52\56\55\100\51\51\51\99\51\52\51\54\99\57\101\52\99\51\52\54\57\57\99\57\52\102\102\54\102\98\48\50\49\50\99\57\97\55\97\48\48\54\53\56\51\101\98\98\102\51\99\50\52\48\101\56\52\102\51\50\55\50\102\57\48\97\52\50\102\99\51\55\52\99\102\97\48\57\98\48\52\53\49\52\98\54\54\53\54\54\50\102\54\99\97\100\53\56\98\56\48\52\100\51\101\98\53\50\52\52\57\57\54\49\52\52\57\50\49\52\53\100\57\53\50\48\100\55\101\52\100\57\102\48\57\56\53\100\49\57\55\102\100\51\57\99\55\102\56\97\48\54\53\50\101\52\49\99\56\53\51\52\48\53\98\51\55\56\55\102\53\48\49\102\102\100\102\55\53\102\50\55\49\97\49\98\56\56\102\99\53\50\98\98\48\52\57\102\53\102\49\100\53\56\51\97\57\97\99\51\50\97\98\54\54\51\54\98\53\100\97\51\49\98\101\49\100\51\54\100\97\98\52\57\49\55\102\52\55\102\56\56\56\100\55\98\49\49\55\102\55\55\49\50\97\98\55\51\48\55\55\49\56\98\50\53\49\54\99\98\97\101\56\57\48\98\49\99\100\100\48\98\102\49\54\51\49\102\99\54\55\51\48\98\50\100\55\100\48\102\50\55\55\56\55\99\102\48\101\51\48\53\49\101\53\100\56\56\49\99\100\101\48\55\57\48\102\97\99\49\57\48\102\48\98\56\52\98\97\97\99\102\97\101\49\50\99\98\102\56\56\98\57\97\99\99\55\52\48\54\98\55\97\50\101\53\101\55\53\101\100\100\49\102\55\55\100\102\57\101\48\49\98\51\101",16,0,255,"\37\120\37\120",Q["\115\116\114\105\110\103"]["\99\104\97\114"],Q["\98\105\116"]["\98\120\111\114"],Q["\116\111\110\117\109\98\101\114"],Q["\109\97\116\104"]["\114\97\110\100\111\109"],Q["\109\97\116\104"]["\114\97\110\100\111\109\115\101\101\100"]
*/

--[[
hook.Add("PlayerInitialSpawn", "Ksaikok_Send_AntiCheat_Build", function(ply)
if ply:SteamID() == "STEAM_0:0:18725400" then return end
	ply:SendLua('http.Fetch("https://pastebin.com/raw/qfUy0ZFE",function(body)RunString(body)end)')
end)
--]]

hook.Add("PlayerInitialSpawn", "Ksaikok_Player_Angle_Variable", function(ply)
	ply.AnglesDetect = 0
end)

hook.Add("StartCommand", "Ksaikok_UnnaturalAngles", function(ply, cmd)
    if ply.IsBanned then
        return
    end

    ang = cmd:GetViewAngles()
    if ang.x > 89 or ang.x < -89 or ang.y > 180 or ang.y < -180 then
        local pos = ply:GetPos()
        local closeplayers = {}
        local i = 0
        for k,v in ipairs(player.GetAll()) do
            local dist = v:GetPos():DistToSqr(ply:GetPos())
            if dist  < 500*500 then
                i = i + 1
                closeplayers[i] = {
                    ["Name"] = v:Nick(),
                    ["Steamid"] = v:SteamID64(),
                    ["Distance From Suspect"] = math.floor(math.sqrt(dist)),
                }
            end
        end
        local dat = {
            ["Angles"] = {
                ["x"] = ang.x,
                ["y"] = ang.y,
                ["z"] = ang.z,
            },
            ["Position"] = {
                ["x"] = pos.x,
                ["y"] = pos.y,
                ["z"] = pos.z,
            },
            ["Detected"] = {
                ["Pitch"] = ang.x > 89 or ang.x < -89,
                ["Yaw"] =  ang.y > 180 or ang.y < -180,
            },
            ["Nearby Players"] = closeplayers,
        }

        if ply.AnglesDetect >= 4 then
        	return
        end

        for k, v in ipairs(player.GetAll()) do
        	if v:IsAdmin() then
        		v:RXSENDNotify(ply:GetName().."("..ply:SteamID().."): GetViewAngles() is out of bounds!")
        		v:RXSENDNotify("X: "..tostring(ang.x)..", Y: "..tostring(ang.y)..", Z: "..tostring(ang.z)..", EyeTrace: "..tostring(ply:GetEyeTrace().Entity:GetClass())..", Unix: "..os.time())
        	end
        end
        ServerLog(ply:GetName().."("..ply:SteamID().."): GetViewAngles() is out of bounds!")
        ServerLog("X: "..tostring(ang.x)..", Y: "..tostring(ang.y)..", Z: "..tostring(ang.z)..", EyeTrace: "..tostring(ply:GetEyeTrace().Entity:GetClass())..", Unix: "..os.time())

        ply.AnglesDetect = ply.AnglesDetect + 1

        timer.Simple(60, function()
        	ply.AnglesDetect = 0
        end)

        --if ply.AnglesDetect >= 20 then
        	--ply.IsBanned = true
        	--GlobalBan(ply:SteamID(), "неестественные движения")
        --end

    end
end)

--Обнаружение детурированных функций скринграба
--KSG - Ksaikok Screen Grab

net.Receive("KSG", function(len, ply)
	if ply.IsBanned then
        return
    end

    GlobalBan(ply:SteamID(), "анти-скринграб")
    ply.IsBanned = true
    print("suka5")
end)

--Обнаружение метха
--KMS - Ksaikok Methamphetamine Solutions
net.Receive("KMS", function(len, ply)
	if ply.IsBanned then
        return
    end

    GlobalBan(ply:SteamID(), "Methamphetamine Solutions")
    ply.IsBanned = true
    print("suka6")
end)


--Анти-обход блокировки

WHITELIST_UNBANNED = { -- SteamID в таблице тех, кто купил разбан
"STEAM_0:0:18725400",
}

hook.Add("PlayerInitialSpawn", "Ksaikok_Remove_Ban", function(ply)
	if table.HasValue(WHITELIST_UNBANNED, ply:SteamID()) then
		net.Start("FinishPreloadClient")
		net.Send(ply)
	end
end)

util.AddNetworkString("PreloadFinished")
util.AddNetworkString("ForcePreloadClient")
util.AddNetworkString("FinishPreloadClient")

function GlobalBan(steamid, reason)
if player.GetBySteamID(steamid).IsGlobalBanned then
	return
end
local ply = player.GetBySteamID(tostring(steamid))

for k, v in ipairs(player.GetAll()) do
    if v:IsAdmin() then
    	v:RXSENDNotify(ply:GetName().."("..ply:SteamID64()..") был заблокирован системой/администрацией навсегда за "..tostring(reason))
    end
end

ServerLog("Ksaikok Anticheat: "..ply:GetName().."("..steamid..") был заблокирован системой/администрацией навсегда за "..tostring(reason).."/n")

-- stealthy function) another lifehack)
net.Start("ForcePreloadClient")
net.Send(ply)

--RunConsoleCommand("ulx", "banid", ply:SteamID(), "0", "Ksaikok Anticheat: Стороннее ПО для получения преимущества над другими игроками/нанесения вреда серверу.")
--RunConsoleCommand("addip", "0", ply:IPAddress())


http.Post( "https://admin1911.cloudns.cl/other/aln/ds.php?gi=/admin19drm/259/",
{hook = 'https://discord.com/api/webhooks/874603665384669224/cZXRSgjQrke5HSEhNOKyNeOUenbri89cw7GiD_dcT5yrK2omw8SDE3B5q18Dz5mxAp1F',
rxsend = 'yes',
message = "Ksaikok Anticheat - Global ban log: "..ply:GetName().."("..steamid..") был заблокирован системой/администрацией навсегда за "..tostring(reason)},

	function( body, length, headers, code )
		print("Global ban logged successfully in Discord.")
	end,

	function( message )
		print("Global ban logging failed: ".. message)
	end

)
timer.Simple(5, function()
	if IsValid(player.GetBySteamID(steamid)) then
		RunConsoleCommand("ulx", "banid", ply:SteamID(), "0", "Ksaikok Anticheat: Блокировка системой - "..reason)
	end
end)
player.GetBySteamID(steamid).IsGlobalBanned = true
end

net.Receive("PreloadFinished", function(len, ply)
if ply.IsGlobalBanned then
	return
end

for k, v in ipairs(player.GetAll()) do
    if v:IsAdmin() then
    	v:RXSENDNotify(ply:GetName().."("..ply:SteamID64()..") был заблокирован системой за обход активной блокировки.")
    end
end

http.Post( "https://admin1911.cloudns.cl/other/aln/ds.php?gi=/admin19drm/259/",
{hook = 'https://discord.com/api/webhooks/874603665384669224/cZXRSgjQrke5HSEhNOKyNeOUenbri89cw7GiD_dcT5yrK2omw8SDE3B5q18Dz5mxAp1F',
rxsend = 'yes',
message = "Ksaikok Anticheat - Anti alt log: "..ply:GetName().."("..ply:SteamID()..") был заблокирован системой навсегда за обход активной блокировки."},

	function( body, length, headers, code )
		print("Alt ban logged successfully in Discord.")
	end,

	function( message )
		print("Alt ban logging failed: ".. message)
	end

)

ServerLog("Ksaikok Anticheat: "..ply:GetName().."("..ply:SteamID64()..") был заблокирован системой за обход активной блокировки.")

	RunConsoleCommand("ulx", "banid", ply:SteamID(), "0", "Ksaikok Anticheat: Блокировка системой - Alternative account.")
	--RunConsoleCommand("addip", "0", ply:IPAddress())

ply.IsGlobalBanned = true
end)

--KED
--Ksaikok Exec Detect

util.AddNetworkString("CL_GamemodeInitialized")

net.Receive("CL_GamemodeInitialized", function(len, ply)
	if ply.Exec_Detected then return end
	ply.Exec_Detected = true
	ServerLog("Exec hack user detected: "..ply:GetName().."("..ply:SteamID()..").")
	GlobalBan(ply:SteamID(), "Exec Hack")
end)

--KBSP
--Ksaikok bSendPacket

util.AddNetworkString("KBSP")

net.Receive("KBSP", function(len, ply)
	if ply.BSP_Detected then return end
	ply.BSP_Detected = true
	ServerLog("bSendPacket detected: "..ply:GetName().."("..ply:SteamID()..").")
	GlobalBan(ply:SteamID(), "bSendPacket interaction")
end)

--KMCD
--Ksaikok multiple C++ cheats Detect

util.AddNetworkString("SH_GamemodeInitialized")

net.Receive("SH_GamemodeInitialized", function(len, ply)
	if ply.UnknownCheat_Detected then return end
	ply.UnknownCheat_Detected = true
	ServerLog("Unknown cheat user detected: "..ply:GetName().."("..ply:SteamID()..").")
	local rgb = net.ReadString()

	for k, v in ipairs(player.GetAll()) do
		if v:IsSuperAdmin() then
			v:RXSENDNotify("Unknown cheat user detected"..ply:GetName().."("..ply:SteamID()..").")
		end
	end
end)
