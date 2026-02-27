util.AddNetworkString("PlayerBlink")
util.AddNetworkString("DropWeapon")
--util.AddNetworkString("RequestGateA")
util.AddNetworkString("RequestEscorting")
util.AddNetworkString("PrepStart")
util.AddNetworkString("RoundStart")
util.AddNetworkString("PostStart")
util.AddNetworkString("RolesSelected")
util.AddNetworkString("SendRoundInfo")
util.AddNetworkString("Sound_Random")
util.AddNetworkString("Sound_Searching")
util.AddNetworkString("Sound_Classd")
util.AddNetworkString("Sound_Stop")
util.AddNetworkString("Sound_Lost")
util.AddNetworkString("UpdateRoundType")
util.AddNetworkString("ForcePlaySound")
util.AddNetworkString("OnEscaped")
util.AddNetworkString("SlowPlayerBlink")
util.AddNetworkString("DropCurrentVest")
util.AddNetworkString("RoundRestart")
util.AddNetworkString("SpectateMode")
util.AddNetworkString("UpdateTime")
util.AddNetworkString("Update914B")
util.AddNetworkString("Effect")
util.AddNetworkString("NTFRequest")
util.AddNetworkString("ExplodeRequest")
util.AddNetworkString("ForcePlayerSpeed")
util.AddNetworkString("ClearData")
util.AddNetworkString("Restart")
util.AddNetworkString("AdminMode")
util.AddNetworkString("ShowText")
util.AddNetworkString("PlayerReady")
util.AddNetworkString("RecheckPremium")
util.AddNetworkString("CancelPunish")
util.AddNetworkString("689")

net.Receive( "CancelPunish", function( len, ply )
	if ply:IsSuperAdmin() then
		CancelVote()
	end
end )

net.Receive( "PlayerReady", function( len, ply )
	ply:SetActive( true )
	net.Start( "PlayerReady" )
		net.WriteTable( { sR, sL } )
	net.Send( ply )
end )

net.Receive( "RecheckPremium", function( len, ply )
	if ply:IsSuperAdmin() then
		for k, v in pairs( player.GetAll() ) do
			IsPremium( v, true )
		end
	end
end )

net.Receive( "SpectateMode", function( len, ply )
	/*
	if ply.ActivePlayer == true then
		if ply:Alive() and ply:Team() != TEAM_SPEC then
			ply:SetSpectator()
		end
		ply.SetActive( false )
		ply:RXSENDNotify( "Changed mode to spectator")
	elseif ply.ActivePlayer == false then
		ply.SetActive( true )
		ply:RXSENDNotify( "Changed mode to player")
	end
	CheckStart()
	*/
end)

net.Receive( "AdminMode", function( len, ply )
	if ply:IsSuperAdmin() then
		ply:ToggleAdminModePref()
	end
end)

net.Receive( "RoundRestart", function( len, ply )
	if ply:IsSuperAdmin() then
		RoundRestart()
	end
end)

net.Receive( "Restart", function( len, ply )
	if ply:IsSuperAdmin() then
		RestartGame()
	end
end)

net.Receive( "Sound_Random", function( len, ply )
	PlayerNTFSound("Random"..math.random(1,4)..".ogg", ply)
end)

net.Receive( "Sound_Searching", function( len, ply )
	PlayerNTFSound("Searching"..math.random(1,6)..".ogg", ply)
end)

net.Receive( "Sound_Classd", function( len, ply )
	PlayerNTFSound("ClassD"..math.random(1,4)..".ogg", ply)
end)

net.Receive( "Sound_Stop", function( len, ply )
	PlayerNTFSound("Stop"..math.random(2,6)..".ogg", ply)
end)

net.Receive( "Sound_Lost", function( len, ply )
	PlayerNTFSound("TargetLost"..math.random(1,3)..".ogg", ply)
end)

net.Receive( "DropCurrentVest", function( len, ply )
	if !ply:Alive() then return end
	if ply:GTeam() == TEAM_SPEC then return end
	if ply:GetNClass() == ROLES.ROLE_GoP then return end
	if ply.UsingArmor == "armor_goc" then return end
	if ply:GetNClass() == ROLES.ROLE_DZ then return end
	if ply:GTeam() == TEAM_GUARD then return end
	if ply:GTeam() == TEAM_CHAOS then return end
	if ply:GTeam() == TEAM_USA then return end
	if ply:GTeam() == TEAM_SPECIAL then return end
	if ply:GetNClass() == ROLES.ROLE_TOPKEK then return end
	if ply:GetNClass() == ROLES.ROLE_FAT then return end
	if ply:GetNClass() == ROLES.ROLE_CSECURITY then return end
	if ply:GetNClass() == ROLES.ROLE_LEL then return end
	if ply:GetNClass() == ROLES.ROLE_GuardSci then return end
		if ply.UsingArmor != nil then
				ply:UnUseArmor()
				ply:SetModel(ply.BeforeVestModel)
				ply:SetupHands()
		end
end)
--[[
net.Receive( "RequestEscorting", function( len, ply )
	if ply:GTeam() == TEAM_GUARD then
		CheckEscortMTF(ply)
	elseif ply:GTeam() == TEAM_CHAOS then
		CheckEscortChaos(ply)
	end
end)
--]]
net.Receive( "ClearData", function( len, ply )
	if not(ply:IsSuperAdmin()) then return end
	local com = net.ReadString()
	if com == "&ALL" then
		for k, v in pairs( player:GetAll() ) do
			clearData( v )
		end
	else
		for k, v in pairs( player:GetAll() ) do
			if v:GetName() == com then
				clearData( v )
				return
			end
		end
		if IsValidSteamID( com ) then
			clearDataID( com )
		end
	end
end)

function clearData( ply )
	ply:SetPData( "breach_karma", GetConVar("br_karma_starting"):GetInt() or 0 )
	ply.Karma = GetConVar("br_karma_starting"):GetInt() or 0
	ply:SetNKarma( GetConVar("br_karma_starting"):GetInt() or 0 )
	ply:SetPData( "breach_exp", 0 )
	ply:SetNEXP( 0 )
	ply:SetPData( "breach_level", 0 )
	ply:SetNLevel( 0 )
end

function clearDataID( id64 )
	util.RemovePData( id64, "breach_karma" )
	util.RemovePData( id64, "breach_exp" )
	util.RemovePData( id64, "breach_level" )
end

function IsValidSteamID( id )
	if string.len( id ) == 17 then
		if tonumber( id ) then
			return true
		end
	end
	return false
end

--net.Receive( "RequestGateA", function( len, ply )
--	RequestOpenGateA(ply)
--end)

net.Receive( "NTFRequest" , function( len, ply )
	if ply:IsSuperAdmin() then
		SpawnNTFS()
	end
end )

net.Receive( "ExplodeRequest", function( len, ply )
	if ply:GetNClass() == ROLES.ROLE_MTFNTF or ply:GetNClass() == ROLES.ROLE_CHAOS then
		explodeGateA( ply )
	end
end )

net.Receive( "DropWeapon", function( len, ply )
	local wep = net.ReadEntity()
	print(tostring(ply).." requested to drop "..tostring(wep))
	if ply:GTeam() == TEAM_SPEC then return end
	if IsValid(wep) and wep != nil and IsValid(ply) then
		local atype = wep:GetPrimaryAmmoType()
		if atype > 0 then
			wep.SavedAmmo = wep:Clip1()
		end
		
		if wep:GetClass() == nil then return end
		if wep.droppable != nil then
			if wep.droppable == false then return end
		end
		ply:DropWeapon( wep )
		print("Weapon dropped successfuly.")
		ply:ConCommand( "lastinv" )
	end
end )

function dofloor(num, yes)
	if yes then
		return math.floor(num)
	end
	return num
end

function GetRoleTable(all)
	local classds = 0
	local mtfs = 0
	local researchers = 0
	local scps = 0
	if all < 8 then
		scps = 2
		all = all - 1
	elseif all > 7 and all < 16 then
		scps = 3
		all = all - 2
	elseif all > 15 then
		scps = 4
		all = all - 3
	end
	//mtfs = math.Round(all * 0.299)
	local mtfmul = 0.33
	if all > 12 then
		mtfmul = 0.3
	elseif all > 22 then
		mtfmul = 0.28
	end
	mtfs = math.Round(all * mtfmul)
	all = all - mtfs
	researchers = math.floor(all * 0.42)
	all = all - researchers
	classds = all
	//print(scps .. "," .. mtfs .. "," .. classds .. "," .. researchers .. "," .. chaosinsurgency)
	/*
	print("scps: " .. scps)
	print("mtfs: " .. mtfs)
	print("classds: " .. classds)
	print("researchers: " .. researchers)
	print("chaosinsurgency: " .. chaosinsurgency)
	*/
	return {scps, mtfs, classds, researchers}
end

function GetRoleTableCustom(all, scps, p_mtf, p_res)
	local classds = 0
	local mtfs = 0
	local researchers = 0
	all = all - scps
	mtfs = math.Round(all * p_mtf)
	all = all - mtfs
	researchers = math.floor(all * p_res)
	all = all - researchers
	classds = all
	return {scps, mtfs, classds, researchers}
end

concommand.Add("br_restart", function(ply, cmd, args)
	if (SERVER) == false and ply:IsSuperAdmin() then
		RoundRestart()
	elseif (SERVER) then
		RoundRestart()
	end
end)

SPCS_SUITABLE_FOR_MULTI = {
	--[[
	{name = "SCP 173",
	func = function(pl)
		pl:SetSCP173()
	end},
	--]]
	{name = "SCP 049",
	func = function(pl)
		pl:SetSCP049()
	end},

	{name = "SCP 106",
	func = function(pl)
		pl:SetSCP106()
	end},
	--[[
	{name = "SCP 457",
	func = function(pl)
		pl:SetSCP457()
	end},
	--]]
	--[[
	{name = "SCP 035",
	func = function(pl)
		pl:SetSCP035()
	end},
	--]]
	--[[
	{name = "SCP 076",
	func = function(pl)
		pl:SetSCP076()
	end},
	--]]
	{name = "SCP 682",
	func = function(pl)
		pl:SetSCP682()
	end},
	--[[
	{name = "SCP 1027-RU",
	func = function(pl)
		pl:SetSCP1027RU()
	end},
	--]]
	{name = "SCP 966",
	func = function(pl)
		pl:SetSCP966()
	end},
	
	
	{name = "SCP-082",
	func = function(pl)
		pl:SetSCP082()
	end},

	{name = "SCP 811",
	func = function(pl)
		pl:SetSCP811()
	end},

	{name = "SCP 1903",
	func = function(pl)
		pl:SetSCP1903()
	end},

	{name = "SCP 1048",
	func = function(pl)
		pl:SetSCP1048()
	end},

	{name = "SCP 939",
	func = function(pl)
		pl:SetSCP939()
	end},
	--[[
	{name = "SCP 079-2",
	func = function(pl)
		pl:SetSCP0792()
	end},
	--]]
	{name = "SCP 1471",
	func = function(pl)
	    pl:SetSCP1471()
	end},
	--крикло
	{name = "SCP 638",
	func = function(pl)
		pl:SetSCP638()
	end},
	{name = "SCP 860-2",
	func = function(pl)
		pl:SetSCP8602()
	end},

	{name = "SCP-542",
	func = function(pl)
		pl:SetSCP542()
	end},
	--фашик
	
	{name = "SCP 062DE",
	func = function(pl)
		pl:SetSCP062DE()
	end},
	

	{name = "SCP 062-FR",
	func = function(pl)
		pl:SetSCP062()
	end},

	{name = "SCP-050",
	func = function(pl)
		pl:SetSCP050FR()
	end},
	--[[
	{name = "SCP 096",
	func = function(pl)
		pl:SetSCP096()
	end},
	--]]
	--[[
	{name = "SCP-999-2",
	func = function(pl)
		pl:SetSCP999()
	end}
	--]]
}

function SetupPlayers(pltab)

for k, v in ipairs(player.GetAll()) do
	v:SetLastHitGroup(0)
	v:SendLua("ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 3)")
	v.MatildaHealUsed = false
	v.SpedwaunUsed = false
	v.LomaoUsed = false
	v.KelenUsed = false
	v.FeelonUsed = false
	v.FeelonMaxMines = 3
end

	local allply = GetActivePlayers()
	scp_multi = SPCS_SUITABLE_FOR_MULTI[math.random(1, #SPCS_SUITABLE_FOR_MULTI)]
	// SCPS
	local spctab = table.Copy(SPCS)
	for i=1, pltab[1] do
		if #spctab < 1 then
			spctab = table.Copy(SPCS)
			//print("not enough scps, copying another table")
		end
		local pl = allply[math.random(1, #allply)]
		if IsValid(pl) == false then continue end
		local scp = spctab[math.random(1, #spctab)]
		
		if activeRound == ROUNDS.multi then
			pl:SetColor(Color(255, 255, 255, 255))
			pl:SetRenderMode(RENDERMODE_NORMAL)
			pl:DrawShadow(true)
			pl.UsingHL2Armor = false
			pl.JustSpawned = true
			scp_multi["func"](pl)
			pl:Give("hacking_doors_scp")
			pl.JustSpawned = false
			pl:SetNoCollideWithTeammates(true)
			timer.Simple(45, function()
				pl:SetNoCollideWithTeammates(false)
			end)
		else
			pl:SetColor(Color(255, 255, 255, 255))
			pl:SetRenderMode(RENDERMODE_NORMAL)
			pl:DrawShadow(true)
			pl.UsingHL2Armor = false
			pl.JustSpawned = true
			scp["func"](pl)
			pl:Give("hacking_doors_scp")
			pl.JustSpawned = false
		end
		--adidas
		print("[RXSEND] Assigning " .. pl:Nick() .. " to SCPs, role: "..pl:GetNClass())
		pl:SendLua("ply:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 0, 60)")
		pl:Freeze(true)
		timer.Simple(6, function()
			pl:SendLua("surface.PlaySound('start_round/start_round_scp.mp3')")
		end)
		timer.Simple(10, function()
			pl:SendLua("ply:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 3)")
			pl:SendLua("util.ScreenShake(Vector(0, 0, 0), 50, 10, 3, 5000)")
		end)

		timer.Simple(30, function()
			pl:Freeze(false)
		end)

		table.RemoveByValue(spctab, scp)
		table.RemoveByValue(allply, pl)
	end
	
	// Class D Personell

	for k, v in ipairs(ents.FindInBox(Vector(-1810, 135, 226), Vector(-638, -67, 365))) do
		if v:GetClass() == "func_door" then
		v:Fire("Lock")
			timer.Simple(10, function()
			for k, v in ipairs(ents.FindInBox(Vector(-1810, 135, 226), Vector(-638, -67, 365))) do
				v:Fire("Unlock")
				v:Fire("Open")
			end
			end)
		end
	end
	
	for k, v in ipairs(ents.FindInBox(Vector(-641, 1534, 140), Vector(-1934, 2059, 142))) do
		if v:GetClass() == "func_door" then
		v:Fire("Lock")
			timer.Simple(10, function()
			for k, v in ipairs(ents.FindInBox(Vector(-641, 1534, 140), Vector(-1934, 2059, 142))) do
				v:Fire("Unlock")
				v:Fire("Open")
			end
			end)
		end
	end

	local dspawns = table.Copy(SPAWN_CLASSD)
	for i=1, pltab[3] do
		if #dspawns < 1 then
			dspawns = table.Copy(SPAWN_CLASSD)
		end
		if #dspawns > 0 then
			local pl = allply[math.random(1, #allply)]
			if IsValid(pl) == false then continue end
			local spawn = dspawns[math.random(1, #dspawns)]
			pl:SetupNormal()
			pl:SetClassD()
			pl:SetPos(spawn)
			pl:SendLua("blackout = false")
			print("[RXSEND] Assigning " .. pl:Nick() .. " to Class-Ds, role: "..pl:GetNClass())
			timer.Simple(4, function()
				pl:SendLua("surface.PlaySound('start_round/start_round_classd.mp3')")
			end)
			timer.Simple(10, function()
				pl:SendLua("ply:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 3)")
				pl:SendLua("util.ScreenShake(Vector(0, 0, 0), 50, 10, 3, 5000)")
				pl:SendLua("blackout = true")
			end)
			table.RemoveByValue(dspawns, spawn)
			table.RemoveByValue(allply, pl)
		end
	end
	
	// Researchers
	local resspawns = table.Copy(SPAWN_SCIENT)
	for i=1, pltab[4] do
		if #resspawns < 1 then
			resspawns = table.Copy(SPAWN_SCIENT)
		end
		if #resspawns > 0 then
			local pl = allply[math.random(1, #allply)]
			if IsValid(pl) == false then continue end
			local spawn = resspawns[math.random(1, #resspawns)]
			pl:SetupNormal()
			pl:SetResearcher()
			pl:SetPos(spawn)
			pl:SendLua("blackout = false")
			print("[RXSEND] Assigning " .. pl:Nick() .. " to Researchers, role: "..pl:GetNClass())
			timer.Simple(5.5, function()
				pl:SendLua("surface.PlaySound('start_round/start_round_sci.mp3')")
			end)
			timer.Simple(10, function()
				pl:SendLua("ply:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 3)")
				pl:SendLua("util.ScreenShake(Vector(0, 0, 0), 50, 10, 3, 5000)")
				pl:SendLua("blackout = true")
			end)
			table.RemoveByValue(resspawns, spawn)
			table.RemoveByValue(allply, pl)
		end
	end
	
	// Specials Researchers

	local specialspawns = table.Copy(SPAWN_SPECIALSCIENT)

	for i=1, 2 do

		if #specialspawns < 1 then

			specialspawns = table.Copy(SPAWN_SPECIALSCIENT)

		end

		if #specialspawns > 0 then

			local pl = allply[math.random(1, #allply)]

			if IsValid(pl) == false then continue end

			local spawn = specialspawns[math.random(1, #specialspawns)]

			pl:SetupNormal()

			pl:SetSpecial()

			pl:SetPos(spawn)
			pl:SendLua("blackout = false")
			print("[RXSEND] Assigning " .. pl:Nick() .. " to Special Researchers, role: "..pl:GetNClass())

			timer.Simple(5.5, function()
				pl:SendLua("surface.PlaySound('start_round/start_round_sci.mp3')")
			end)
			timer.Simple(10, function()
				pl:SendLua("ply:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 3)")
				pl:SendLua("util.ScreenShake(Vector(0, 0, 0), 50, 10, 3, 5000)")
				pl:SendLua("blackout = true")
			end)

			table.RemoveByValue(specialspawns, spawn)

			table.RemoveByValue(allply, pl)

		end

	end
	
	// Security
	local security = ALLCLASSES["security"]["roles"]
	local securityspawns = table.Copy(SPAWN_GUARD)
	
	local i4inuse = false
	for i = 1, pltab[2] do
		if #securityspawns < 1 then
			securityspawns = table.Copy(SPAWN_GUARD)
		end
		if #securityspawns > 0 then
			local pl = table.remove( allply, math.random( #allply ) )
			if !IsValid( pl ) then continue end
			local spawn = table.remove( securityspawns, math.random( #allply ) )
			pl:SetRoleBestFrom("security")
			pl:SetPos( spawn )
			pl:SendLua("blackout = false")
			print("[RXSEND] Assigning " .. pl:Nick() .. " to MTFs, role: "..pl:GetNClass())
			timer.Simple(5.5, function()
				pl:SendLua("surface.PlaySound('start_round/start_round_mtf.mp3')")
			end)
			timer.Simple(10, function()
				pl:SendLua("ply:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 3)")
				pl:SendLua("util.ScreenShake(Vector(0, 0, 0), 50, 10, 3, 5000)")
				pl:SendLua("blackout = true")
			end)
		end
	end
	
	--if firstround then
		--RoundRestart()
		--firstround = false
		--rounds = 0
	--end
	
	net.Start("RolesSelected")
	net.Broadcast()
end

function SetupTTTOld( ply )
local allply = GetActivePlayers()

	local security = ALLCLASSES["security"]["roles"]
	local securityspawns = table.Copy(SPAWN_GUARD)
	
	local ci_count = math.ceil(#allply / 6)
	local mtf_count = #allply - ci_count
	
	for i = 1, mtf_count do
		if #securityspawns < 1 then
			securityspawns = table.Copy(SPAWN_GUARD)
		end
		if #securityspawns > 0 then
			local pl = table.remove( allply, math.random( #allply ) )
			if !IsValid( pl ) then continue end
			local random_spawn = math.random(1, #securityspawns)
			local spawn = securityspawns[random_spawn]
			pl:SetRoleBestFrom("security")
			pl:SetPos(spawn)
			table.remove(securityspawns, random_spawn)
			print("[RXSEND] Assigning " .. pl:Nick() .. " to MTFs, role: "..pl:GetNClass())
		end
	end
	
	for i = 1, ci_count do
		if #securityspawns < 1 then
			securityspawns = table.Copy(SPAWN_GUARD)
		end
		if #securityspawns > 0 then
			local pl = table.remove( allply, math.random( #allply ) )
			if !IsValid( pl ) then continue end
			local random_ci = math.random(1, 2)
			
			if random_ci == 1 then
				pl:SetChaosSpy()
			elseif random_ci == 2 then
				pl:SetChaosSpecial()
			end
			
			local pl = table.remove( allply, math.random( #allply ) )
			if !IsValid( pl ) then continue end
			local random_spawn = math.random(1, #securityspawns)
			local spawn = securityspawns[random_spawn]
			pl:SetPos(Vector(-7059.043945, 1101.717529, 2443.389404))
			table.remove(securityspawns, random_spawn)
			print("[RXSEND] Assigning " .. pl:Nick() .. " to CIs, role: "..pl:GetNClass())
		end
	end

end

ttt_player_spawns = {
Vector(-2364.2468261719, 3653.7719726563, 0.03125),
Vector(-2363.9028320313, 3419.7861328125, 0.03125),
Vector(-2142.5402832031, 3648.4130859375, 0.03125),
Vector(-2369.3120117188, 3191.0373535156, 0.03125),
Vector(-2369.498046875, 3007.2690429688, 0.03125),
Vector(-2176.4255371094, 3000.0158691406, 0.03125),
Vector(-2595.345703125, 3010.5139160156, 0.03125),
Vector(-2366.2392578125, 2798.8059082031, 0.03125),
Vector(-2380.3991699219, 2370.3129882813, 0.03125),
Vector(-1721.0544433594, 2362.818359375, 0.03125),
Vector(-1030.1228027344, 2366.0290527344, 0.03125),
Vector(-400.28845214844, 2361.6071777344, 0.03125),
Vector(-228.93388366699, 2366.5991210938, 0.03125),
Vector(-450.58416748047, 2607.6384277344, 0.03125),
Vector(-651.67083740234, 2366.7944335938, 0.03125),
Vector(114.05132293701, 2364.3325195313, 0.03125),
Vector(363.8708190918, 2262.8395996094, 0.03125),
Vector(421.44427490234, 2555.8012695313, 0.03125),
Vector(833.52484130859, 2363.2033691406, 0.03125),
Vector(827.7138671875, 3007.1147460938, 0.03125),
Vector(838.38873291016, 3656.6015625, 0.03125),
Vector(577.36370849609, 3653.9792480469, 0.03125),
Vector(841.51580810547, 3869.4365234375, 0.03125),
Vector(1053.5888671875, 3634.1953125, 0.03125),
Vector(830.22540283203, 3446.87890625, 0.03125),
Vector(1368.7531738281, 3647.8767089844, 0.03125),
Vector(1386.6024169922, 3833.2836914063, 0.03125),
Vector(1369.4133300781, 3466.3359375, 0.03125),
Vector(159.24795532227, 3659.6350097656, 0.03125),
Vector(38.799415588379, 3590.8898925781, -127.96875),
Vector(67.20938873291, 3401.1704101563, -127.96875),
Vector(373.39852905273, 3257.4624023438, -127.96875),
Vector(358.59625244141, 3424.8505859375, -127.96875),
Vector(90.829071044922, 4062.9069824219, -127.96875),
Vector(-444.25335693359, 3651.2604980469, 0.03125),
Vector(-670.48742675781, 3654.52734375, 0.03125),
Vector(-451.63153076172, 3850.5168457031, 0.03125),
Vector(-455.44799804688, 3450.748046875, 0.03125),
Vector(-223.07705688477, 3644.8171386719, 0.03125),
Vector(-435.46499633789, 4346.4560546875, 0.03125),
Vector(-441.78518676758, 4751.4741210938, 0.03125),
Vector(-1270.7335205078, 4592.3764648438, -63.96875),
Vector(-1035.1940917969, 4214.349609375, -63.96875),
Vector(-836.38311767578, 4220.4931640625, -63.96875),
Vector(-1073.6232910156, 3637.5534667969, 0.03125),
Vector(-1108.3900146484, 3037.3325195313, 0.03125),
Vector(-770.36962890625, 2845.1550292969, 0.03125),
Vector(-431.90676879883, 2975.6762695313, 0.03125),
Vector(-1785.5623779297, 3065.0598144531, 0.03125),
Vector(-2908.5695800781, 3010.2055664063, 0.03125),
Vector(-3240.6098632813, 3011.796875, 0.03125),
Vector(-3655.2080078125, 3015.6838378906, 0.03125),
Vector(-3643.3522949219, 2549.0852050781, 0.03125),
Vector(-1707.2391357422, 4042.4792480469, 0.03125),
}

function SetupTTT( ply )
	for k, v in ipairs(ents.GetAll()) do
		if v:GetModel() == "models/foundation/doors/860_door.mdl" then
			v:Fire("lock")
			v:Fire("Lock")
		end
	end
		--if v:GetPos() == Vector(-2451.968750, 4120.000000, 310.250000) then
	timer.Simple(1, function()
		ents.GetMapCreatedEntity(4332):Use(Entity(1), nil)
		timer.Simple(3, function()
			ents.GetMapCreatedEntity(4332):Fire("lock")
		end)
	end)
	local roles = { }

	roles[1] = math.ceil( ply * 0.15 )
	ply = ply - roles[1]
	roles[2] = ply
	ply = 0

	local players = GetActivePlayers()
	local spawns = table.Copy( ttt_player_spawns )
	local ply, spawn = nil, nil

	for i = 1, roles[1] do
		ply = table.remove( players, math.random( 1, #players ) )
		spawn = table.remove( spawns, math.random( 1, #spawns ) )
		--local random_ci = math.random(1, 2)
		--if random_ci == 1 then
		ply:SetChaosSpy()
		--elseif random_ci == 2 then
			--ply:SetChaosSpecial()
		--end
		ply:SetPos( spawn )
		ply:RXSENDNotify("Все неуязвимы 30 секунд.")
		ply:GodEnable()
		print("[RXSEND] Assigning " .. ply:Nick() .. " to CIs, role: "..ply:GetNClass())
	end

	ply, spawn = nil, nil

	for i = 1, roles[2] do
		if #spawns < 1 then
			spawns = table.Copy( ttt_player_spawns )
		end

		ply = table.remove( players, math.random( 1, #players ) )
		spawn = table.remove( spawns, math.random( 1, #spawns ) )
		ply:SetRoleBestFrom("security")
		ply:SetPos( spawn )
		ply:RXSENDNotify("Все неуязвимы 30 секунд.")
		ply:GodEnable()
		print("[RXSEND] Assigning " .. ply:Nick() .. " to MTFs, role: "..ply:GetNClass())
	end

	ply, spawn = nil, nil

	net.Start("RolesSelected")
	net.Broadcast()

	timer.Simple(30, function()
		for k, v in ipairs(player.GetAll()) do
			v:GodDisable()
			v:RXSENDNotify("Неуязвимость отключена!")
		end
	end)

end

nazi_spawns = {
Vector(-2379.6237792969, 2367.4775390625, 0.03125),
Vector(-2373.2185058594, 2571.0673828125, 0.03125),
Vector(-2175.1242675781, 2359.3154296875, 0.03125),
Vector(-2365.8879394531, 2877.3745117188, 0.03125),
Vector(-2366.4169921875, 2975.2377929688, 0.03125),
Vector(-2223.5991210938, 3010.4460449219, 0.03125),
Vector(-2552.705078125, 3002.8435058594, 0.03125),
Vector(-2823.0349121094, 3008.2536621094, 0.03125),
Vector(-3028.7788085938, 3005.4445800781, 1.03125),
Vector(-3175.9252929688, 3015.5815429688, 0.03125),
Vector(-3472.32421875, 3002.779296875, 0.03125),
Vector(-3659.7277832031, 2961.52734375, 0.03125),
Vector(-3677.1142578125, 2757.6303710938, 0.03125),
Vector(-2357.9663085938, 3136.3354492188, 0.03125),
Vector(-2363.7373046875, 3274.6062011719, 0.03125),
Vector(-2428.2602539063, 3411.830078125, 0.74060297012329),
Vector(-2428.0258789063, 3529.5805664063, 0.03125),
Vector(-2429.5346679688, 3670.1687011719, 0.03125),
Vector(-2279.7951660156, 3654.1276855469, 0.03125),
Vector(-2180.9348144531, 3641.9060058594, 0.03125),
Vector(-2439.4223632813, 2223.5720214844, 0.03125),
Vector(-2277.5964355469, 2357.9262695313, 0.03125),
Vector(-3565.7438964844, 2541.0673828125, 0.03125),
Vector(-3564.4067382813, 2607.2758789063, 0.03125),
Vector(-3738.6770019531, 2618.4865722656, 0.03125),
Vector(-3737.6999511719, 2555.7250976563, 0.03125),
Vector(-3640.6984863281, 2620.7827148438, 0.03125),
}

sovets_spawns = {
Vector(832.61480712891, 4497.40234375, 0.03125),
Vector(831.25317382813, 4388.4389648438, 0.03125),
Vector(830.85437011719, 4277.4389648438, 0.03125),
Vector(836.4853515625, 4166.345703125, 0.03125),
Vector(824.67425537109, 4059.8068847656, 0.03125),
Vector(982.83428955078, 4292.5844726563, 0.03125),
Vector(1115.6435546875, 4290.5922851563, 0.03125),
Vector(1279.0314941406, 4290.2685546875, 0.03125),
Vector(1493.859375, 4290.8095703125, 0.03125),
Vector(1653.2478027344, 4291.236328125, 0.03125),
Vector(1744.0971679688, 4292.3500976563, 0.03125),
Vector(1729.5224609375, 4172.3251953125, 0.03125),
Vector(828.42620849609, 3733.9086914063, 0.03125),
Vector(970.46990966797, 3636.6105957031, 0.03125),
Vector(811.20520019531, 3533.2922363281, 0.03125),
Vector(822.701171875, 3170.3466796875, 0.03125),
Vector(824.15325927734, 2960.0080566406, 0.03125),
Vector(825.71643066406, 2793.6955566406, 0.03125),
Vector(828.45599365234, 2532.3891601563, 0.03125),
Vector(875.93597412109, 2331.708984375, 0.03125),
Vector(1063.9926757813, 2354.0705566406, 0.03125),
Vector(591.95166015625, 2371.12109375, 0.88779973983765),
Vector(1022.5990600586, 3010.9475097656, 0.03125),
Vector(1414.1840820313, 3099.6909179688, 64.03125),
Vector(1357.2681884766, 2864.16796875, 64.03125),
Vector(1381.9290771484, 2973.5480957031, 64.03125),
Vector(1494.2607421875, 3010.1501464844, 64.03125),
}

function SetupWW2TDM( ply )
		--if v:GetPos() == Vector(-2451.968750, 4120.000000, 310.250000) then
	timer.Simple(1, function()
		ents.GetMapCreatedEntity(4332):Use(Entity(1), nil)
		timer.Simple(3, function()
			ents.GetMapCreatedEntity(4332):Fire("lock")
		end)
	end)
	local roles = { }

	roles[1] = math.ceil( ply * 0.5 )
	ply = ply - roles[1]
	roles[2] = ply
	ply = 0

	local players = GetActivePlayers()
	local spawns = table.Copy( nazi_spawns )
	local ply, spawn = nil, nil

	for i = 1, roles[1] do
		ply = table.remove( players, math.random( 1, #players ) )
		spawn = table.remove( spawns, math.random( 1, #spawns ) )
		ply:SetNazi()
		ply:SetPos( spawn )
		ply:SendLua('PlayNaziMusic()')
		print("[RXSEND] Assigning " .. ply:Nick() .. " to fashiks, role: "..ply:GetNClass())
	end

	ply, spawn = nil, nil
	
	local spawns = table.Copy( sovets_spawns )
	
	for i = 1, roles[2] do
		if #spawns < 1 then
			spawns = table.Copy( sovets_spawns )
		end

		ply = table.remove( players, math.random( 1, #players ) )
		spawn = table.remove( spawns, math.random( 1, #spawns ) )
		ply:SetUSSR()
		ply:SetPos( spawn )
		ply:SendLua('PlayRedArmyMusic()')
		print("[RXSEND] Assigning " .. ply:Nick() .. " to sovets, role: "..ply:GetNClass())
	end

	ply, spawn = nil, nil

	net.Start("RolesSelected")
	net.Broadcast()

end

function SetupAdmins( players )
	for k, v in pairs( players ) do
		if v.admpref then
			if !v.AdminMode then
				v:ToggleAdminMode()
			end
			v.PressedUse = true
			v:SetupAdmin()
			v.PressedUse = false
		elseif v.AdminMode then
			v:ToggleAdminMode()
		end
	end
end

function GiveExp()
	for k, v in pairs( player.GetAll() ) do
		local exptogive = v:Frags() * 50
		v:SetFrags( 0 )
		if exptogive > 0 then
			--v:AddExp( exptogive, true )
			--v:RXSENDNotify("Вы получили "..exptogive.." опыта за ваш счёт: "..(exptogive / 50))
		end
	end
end

activevote = false
suspectname = ""
activesuspect = nil
activevictim = nil
votepunish = 0
voteforgive = 0
specpunish = 0
specforgive = 0

function PunishVote( ply, victim )
	if GetConVar( "br_allow_punish" ):GetInt() == 0 then return end
	if ply == victim then return end
	if activevote then
		EndPunishVote()
		timer.Destroy( "PunishEnd" )
	end
	net.Start( "ShowText" )
		net.WriteString( "text_punish" )
		net.WriteString( ply:GetName() )
	net.Broadcast()
	activevote = true
	votepunish = 0
	voteforgive = 0
	specpunish = 0
	specforgive = 0
	suspectname = ply:GetName()
	activesuspect = ply:SteamID64()
	activevictim = victim:SteamID64()
	timer.Create( "PunishEnd", GetConVar( "br_punishvote_time" ):GetInt(), 1, function()
		EndPunishVote()
	end )
end

function EndPunishVote()
	local specvotedforgive = math.Round( 3 * specforgive / ( specpunish + specforgive ) )
	if tostring( specvotedforgive ) != "nan" then
		voteforgive = voteforgive + specvotedforgive
		votepunish = votepunish + ( 3 - specvotedforgive )
	end
	print( "Player: "..suspectname, " Forgive: "..voteforgive, "Punish: "..votepunish )
	activevote = false
	for k,v in pairs( player.GetAll() ) do
		v.voted = false
	end
	local result = {
		punish = votepunish > voteforgive,
		punishvotes = votepunish,
		forgivevotes = voteforgive,
		punished = suspectname
	}
	net.Start( "ShowText" )
		net.WriteString( "text_punish_end" )
		net.WriteTable( result )
	net.Broadcast()
	if votepunish > voteforgive then
		for k,v in pairs( player.GetAll() ) do
			if v:SteamID64() == activesuspect then
				if v.warn then
					v:Kill()
				else
					v.warn = true
				end
				break
			end
		end
	end
	suspectname = ""
	activesuspect = nil
	activevictim = nil
end

function CancelVote()
	timer.Destroy( "PunishEnd" )
	net.Start( "ShowText" )
		net.WriteString( "text_punish_cancel" )
	net.Broadcast()
	activevote = false
	suspectname = ""
	activesuspect = nil
	activevictim = nil
	votepunish = 0
	voteforgive = 0
	specpunish = 0
	specforgive = 0
end