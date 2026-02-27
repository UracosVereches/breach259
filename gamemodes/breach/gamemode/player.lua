// Serverside file for all player related functions

function IsPremium( ply, silent )
	ply:SetNPremium( false )
	ply.Premium = false
	if ply:IsUserGroup("premium") then
		ply.Premium = true
		ply:SetNPremium( true )
	end
	if CheckULXPremium( ply, silent ) == true then return end
	if GetConVar("br_premium_url"):GetString() == "" or GetConVar("br_premium_url"):GetString() == "none" then return end
	http.Fetch( GetConVar("br_premium_url"):GetString(), function( body, size, headers, code )
		if ( body == nil ) then return end
		local ID = string.find( tostring(body), "<ID64>"..ply:SteamID64().."</ID64>" )
			if ID != nil then
				ply.Premium = true
				ply:SetNPremium( true )
				if GetConVar("br_premium_display"):GetString() != "" and GetConVar("br_premium_display"):GetString() != "none" and !silent then
					print("Premium member "..ply:GetName().." has joined")
					PrintMessage(HUD_PRINTCENTER, string.format(GetConVar("br_premium_display"):GetString(), ply:GetName()))
				end
			end
	end,
	function( error )
		print("HTTP ERROR")
		print(error)
	end )
end

function CheckULXPremium( ply, silent )
	if GetConVar("br_ulx_premiumgroup_name"):GetString() == "" or GetConVar("br_ulx_premiumgroup_name"):GetString() == "none" then return end
	if !ply.CheckGroup then
		print( "To use br_ulx_premiumgroup_name you have to install ULX!" )
		return
	end
	local pgroups = string.Split( GetConVar("br_ulx_premiumgroup_name"):GetString(), "," )
	local ispremium
	for k,v in pairs( pgroups ) do
		if ply:CheckGroup( v ) then
			ispremium = true
			break
		end
	end
	if ispremium then
		ply.Premium = true
		ply:SetNPremium( true )
		if GetConVar("br_premium_display"):GetString() != "" and GetConVar("br_premium_display"):GetString() != "none" and !silent then
			print("Premium member "..ply:GetName().." has joined")
			PrintMessage(HUD_PRINTCENTER, string.format(GetConVar("br_premium_display"):GetString(), ply:GetName()))
		end
		return true
	end
end

function CheckStart()
	--print(debug.traceback())
	MINPLAYERS = GetConVar("br_min_players"):GetInt()
	if gamestarted == false and #GetActivePlayers() >= MINPLAYERS then
	
		if !players_warned then
			for k, v in ipairs(player.GetAll()) do
				v:RXSENDNotify("Игра начнётся через 3 минуты!")
			end
		end

		players_warned = true

		if !waitingplayers then
			waitingplayers = true
			timer.Simple(180, function()
				if gamestarted == false and #GetActivePlayers() >= MINPLAYERS then
					waitingplayers = false
					players_warned = false
					RoundRestart()
				elseif #GetActivePlayers() <= MINPLAYERS then
					waitingplayers = false
					players_warned = false
					for k, v in ipairs(player.GetAll()) do
						v:RXSENDNotify("Недостаточно игроков для начала раунда, ожидаем ещё...")
					end
				end
			end)
		end

	end
	if gamestarted then
		BroadcastLua( 'gamestarted = true' )
	end
end

function GM:PlayerInitialSpawn( ply )
	ply:SetCanZoom( false )
	ply:SetNoDraw(true)
	ply.Active = false
	ply.freshspawn = true
	ply.isblinking = false
	ply.Premium = false
	ply.Karma = StartingKarma() or 1000
	if timer.Exists( "RoundTime" ) == true then
		net.Start("UpdateTime")
			if timer.TimeLeft( "RoundTime" ) == nil then
				net.WriteString(tostring(0))
			else
				net.WriteString(tostring(timer.TimeLeft( "RoundTime" )))
			end
		net.Send(ply)
	end
	player_manager.SetPlayerClass( ply, "class_breach" )
	player_manager.RunClass( ply, "SetupDataTables" )
	IsPremium(ply)
	ply:SetActive( false )
	if ply:IsBot() then
		ply:SetActive( true )
	end
	--print( ply.ActivePlayer, ply:GetNActive() )
	CheckStart()

	if gamestarted then
		ply:SendLua( 'gamestarted = true' )
	end
	
end

/*
function GM:PlayerAuthed( ply, steamid, uniqueid )
	ply.Active = false
	ply.Leaver = "none"
	if prepring then
		ply:SetClassD()
	else
		ply:SetSpectator()
	end
end
*/
function GM:PlayerSpawn( ply )
	//ply:SetupHands()
	ply:SetTeam(2)
	ply:SetNoCollideWithTeammates(false)
	--if ply:GTeam() == TEAM_SCP then
		--ply:SetNoCollideWithTeammates(true)
	--end
	//ply:SetCustomCollisionCheck( true )
	if ply.freshspawn then
		ply:SetSpectator()
		ply.freshspawn = false
	end
	//ply:SetupHands()
end

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		if ply.handsmodel != nil then
			info.model = ply.handsmodel
		end
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if (ply.noragdoll != true) then
		CreateRagdollPL(ply, attacker, dmginfo:GetDamageType())
	end
	ply:AddDeaths(1)
end


function GM:PlayerDeathThink( ply )
	if ply:GetNClass() == ROLES.ROLE_SCP076 and IsValid( SCP0761 ) then
		if ply.n076nextspawn and ply.n076nextspawn < CurTime() then
			ply:SetSCP076()
		end
		return
	end
	if !ply:IsBot() and ply:GTeam() != TEAM_SPEC then
		ply:SetGTeam(TEAM_SPEC)
	end
	if ( ply:IsBot() || ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) || postround ) then
		ply:Spawn()
		ply:SetSpectator()
	end
end

function GM:PlayerNoClip( ply, desiredState )
	if ply:GTeam() == TEAM_SPEC and desiredState == true then return true end
end

function GM:PlayerDeath( victim, inflictor, attacker )

	if CheckRDM(victim, inflictor, attacker) then
		attacker:RXSENDWarning("Вы убили союзника!")
		victim:RXSENDWarning("Вас убил союзник, его ник и роль: "..attacker:GetNClass().." "..attacker:GetName().."("..attacker:SteamID().."), ваша роль: "..victim:GetNClass()..". Сообщите администрации, если вас убили просто так.")

		for k, v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				if v:GTeam() != TEAM_SPEC and activeRound == ROUNDS.ttt then return end
				v:RXSENDWarning(attacker:GetNClass().." "..attacker:GetName().."("..attacker:SteamID()..") убил союзника "..victim:GetNClass().." "..victim:GetName().."("..victim:SteamID()..")")
				v:SendLua('surface.PlaySound("UI/buttonclick.wav")')
			end
		end

	end

	victim:SetModelScale( 1 )
	if attacker:IsPlayer() then
		print("[KILL] " .. attacker:Nick() .. " [" .. attacker:GetNClass() .. "] killed " .. victim:Nick() .. " [" .. victim:GetNClass() .. "]")
	end
	if victim:GetNClass() == ROLES.ROLE_SCP076 and IsValid( SCP0761 ) then
		victim.n076nextspawn = CurTime() + 10
		return
	end
	victim:SetNClass(ROLES.ROLE_SPEC)
	if attacker != victim and postround == false and attacker:IsPlayer() then
		if attacker:IsPlayer() then
			if !CheckRDM(victim, inflictor, attacker) then
				
				if attacker:GTeam() == TEAM_SCP then
					--if WEPS_Primary[victim:GetActiveWeapon():GetClass()] or WEPS_Secondary[victim:GetActiveWeapon():GetClass()] then
						attacker:AddFrags(3)
						attacker:RXSENDNotify("Вы были награждены 3 поинтами за убийство "..victim:GetName())
					--[[
					else
						attacker:AddFrags(2)
						attacker:RXSENDNotify("Вы были награждены 2 поинтами за убийство "..victim:GetName())
					--]]
					--end
					victim:RXSENDWarning("Вы были убиты СЦП объектом "..attacker:GetName()..". Его роль: "..attacker:GetNClass())

				elseif attacker:GTeam() != TEAM_SCP then

					if victim:GTeam() != TEAM_SCP then
						attacker:AddFrags(5)
						attacker:RXSENDNotify("Вы были награждены 5 поинтами за убийство "..victim:GetName())
						victim:RXSENDWarning("Вы были убиты выжившим "..attacker:GetName()..". Его роль: "..attacker:GetNClass())
					--[[
					elseif !victim:GetActiveWeapon().CW20Weapon and victim:GTeam() != TEAM_SCP then 
						attacker:AddFrags(1)
						attacker:RXSENDNotify("Вы были награждены 1 поинтом за убийство "..victim:GetName())
						victim:RXSENDWarning("Вы были убиты выжившим "..attacker:GetName()..". Его роль: "..attacker:GetNClass())
					--]]
					elseif victim:GTeam() == TEAM_SCP then
						attacker:AddFrags(15)
						attacker:RXSENDNotify("Вы были награждены 15 поинтами за убийство СЦП объекта "..victim:GetName())
						victim:RXSENDWarning("Вы были убиты выжившим "..attacker:GetName()..". Его роль: "..attacker:GetNClass())
					end

				end

			end

		end
	end
	roundstats.deaths = roundstats.deaths + 1
	local wasteam = victim:GTeam()
	victim:SetTeam(TEAM_SPEC)
	victim:SetGTeam(TEAM_SPEC)
	if GetConVar( "br_dropvestondeath" ):GetInt() != 0 then
		victim:UnUseArmor()
	end
	--[[
	if #victim:GetWeapons() > 0 then
		local pos = victim:GetPos()
		for k,v in pairs(victim:GetWeapons()) do
			local candrop = true
			if v.droppable != nil then
				if v.droppable == false then
					candrop = false
				end
			end
			if candrop then
				local wep = ents.Create( v:GetClass() )
				if IsValid( wep ) then
					wep:SetPos( pos )
					wep:Spawn()
					local atype = v:GetPrimaryAmmoType()
					if atype > 0 then
						wep.SavedAmmo = v:Clip1()
					end
				end
			end
		end
	end
	--]]
	WinCheck()
	if !postround then
		if !IsValid( attacker ) or !attacker.GTeam then return end
		if attacker:GTeam() == wasteam then
			PunishVote( attacker, victim )
		elseif attacker:GTeam() == TEAM_GUARD then
			if wasteam == TEAM_SCI then
				PunishVote( attacker, victim )
			end
		elseif attacker:GTeam() == TEAM_SCI then
			if wasteam == TEAM_GUARD then
				PunishVote( attacker, victim )
			end
		elseif attacker:GTeam() == TEAM_CLASSD then
			if wasteam == TEAM_CHAOS then
				PunishVote( attacker, victim )
			end
		elseif attacker:GTeam() == TEAM_CHAOS then
			if wasteam == TEAM_CLASSD then
				PunishVote( attacker, victim )
			end
		end
	end
end

function GM:PlayerDisconnected( ply )
	ply:TakeDamage(10000)
	 ply:SetTeam(TEAM_SPEC)
	 if #player.GetAll() < MINPLAYERS then
		BroadcastLua('gamestarted = false')
		gamestarted = false
	 end
	 ply:SaveKarma()
	 WinCheck()
end

function HaveRadio(pl1, pl2)
	if pl1:HasWeapon("wep_jack_job_drpradio") then
		if pl2:HasWeapon("wep_jack_job_drpradio") then
			local r1 = pl1:GetWeapon("wep_jack_job_drpradio")
			local r2 = pl2:GetWeapon("wep_jack_job_drpradio")
			if !IsValid(r1) or !IsValid(r2) then return false end
			/*
			print(pl1:Nick() .. " - " .. pl2:Nick())
			print(r1.Enabled)
			print(r1.Channel)
			print(r2.Enabled)
			print(r2.Channel)
			*/
			if r1.Enabled == true then
				if r2.Enabled == true then
					if r1.Channel == r2.Channel then
						if r1.Channel > 4 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if talker:Alive() == false then return false end
	--if listener:Alive() == false then return false end

	if talker:GetNClass() == ROLES.ROLE_SCP939 then
		local wep = talker:GetWeapon("weapon_scp_939")
		//print("Channel "..wep.Channel)
		if wep.Channel == "ALL" and listener:GTeam() == TEAM_SPEC then return false end
		if wep.Channel == "MTF" and listener:GTeam() != TEAM_GUARD then return false end
		if wep.Channel == "SCIENT" and listener:GTeam() != TEAM_SCI then return false end
		if wep.Channel == "D" and listener:GTeam() != TEAM_CLASSD then return false end
		if wep.Channel == "CI" and listener:GTeam() != TEAM_CHAOS then return false end
	end

	if talker:GTeam() == TEAM_SCP then

		if listener:GTeam() == TEAM_SCP then
			return true

		elseif listener:GTeam() == TEAM_SPEC or listener:GTeam() == TEAM_DZ then
			if talker:GetPos():DistToSqr(listener:GetPos()) < 562500 then
				return true, true
			else
				return false
			end

		else
			return false
		end

	end

	if talker:GTeam() == TEAM_SPEC then
		if listener:GTeam() == TEAM_SPEC then
			return true
		else
			return false
		end
	end
	if HaveRadio(listener, talker) == true then
		return true
	end
	if talker:GetPos():DistToSqr(listener:GetPos()) < 562500 then
		return true, true
	else
		return false
	end
end

function GM:PlayerCanSeePlayersChat( text, teamOnly, listener, talker )
if !IsValid(talker) then
	return true
end

if !IsValid(talker) then return end

	if talker:GTeam() == TEAM_SCP then
		if listener:GTeam() == TEAM_SCP then
			return true
		elseif listener:GTeam() == TEAM_SPEC or listener:GTeam() == TEAM_DZ then
			if talker:GetPos():DistToSqr(listener:GetPos()) < 562500 then
				return true
			end
		else
			return false
		end
	end
	
	if talker:GetNWBool("Allo", false) then
		return true
	end
	
	if activevote then
		local votemsg = false
		if talker.voted == true or talker:SteamID64() == activesuspect then
			if !talker.timeout then talker.timeout = 0 end
			if talker.timeout < CurTime() then
				talker.timeout = CurTime() + 0.5
				net.Start( "ShowText" )
					net.WriteString( "vote_fail" )
				net.Send( talker )
			end
			return
		end
		if text == "!forgive" then
			if talker:SteamID64() == activevictim then
				voteforgive = voteforgive + 5
			elseif talker:GTeam() == TEAM_SPEC then
				specforgive = specforgive + 1
			else
				voteforgive = voteforgive + 1
			end
			talker.voted = true
			votemsg = true
			talker.timeout = CurTime() + 0.5
		elseif text == "!punish" then
			if talker:SteamID64() == activevictim then
				votepunish = votepunish + 5
			elseif talker:GTeam() == TEAM_SPEC then
				specpunish = specpunish + 1
			else
				votepunish = votepunish + 1
			end
			talker.voted = true
			votemsg = true
			talker.timeout = CurTime() + 0.5
		end
		if votemsg then
			if listener:IsSuperAdmin() then
				return true
			else
				return false
			end
		end
	end
	if talker:GetNClass() == ROLES.ADMIN or listener:GetNClass() == ROLES.ADMIN then return true end
	if talker:Alive() == false then return false end
	if listener:Alive() == false then return false end
	if teamOnly then
		if talker:GetPos():DistToSqr(listener:GetPos()) < 562500 and talker:GTeam() != TEAM_SCP and listener:GTeam() != TEAM_SCP then
			return (listener:GTeam() == talker:GTeam())
		else
			return false
		end
	end
	if talker:GTeam() == TEAM_SPEC then
		if listener:GTeam() == TEAM_SPEC then
			return true
		else
			return false
		end
	end
	if HaveRadio(listener, talker) == true then
		return true
	end
	return (talker:GetPos():DistToSqr(listener:GetPos()) < 562500)
end

function GM:PlayerDeathSound(ply)
	return true
end


function GM:PlayerCanPickupWeapon( ply, wep )
	//if ply.lastwcheck == nil then ply.lastwcheck = 0 end
	//if ply.lastwcheck > CurTime() then return end
	//ply.lastwcheck = CurTime() + 0.5
	if wep.IDK != nil then
		for k,v in pairs(ply:GetWeapons()) do
			if wep.Slot == v.Slot then return false end
		end
	end
	if wep.clevel != nil then
		for k,v in pairs(ply:GetWeapons()) do
			if v.clevel then return false end
		end
	end
	/*
	if ply:GTeam() == TEAM_SCP then
		if ply:GetNClass() == ROLES.ROLE_SCP173 then
			return wep:GetClass() == "weapon_scp_173"
		elseif ply:GetNClass() == ROLES.ROLE_SCP106 then
			return wep:GetClass() == "weapon_scp_106"
		elseif ply:GetNClass() == ROLES.ROLE_SCP049 then
			return wep:GetClass() == "weapon_scp_049"
		elseif ply:GetNClass() == ROLES.ROLE_SCP096 then
			return wep:GetClass() == "weapon_scp_096"
		elseif ply:GetNClass() == ROLES.ROLE_SCP0492 then
			return wep:GetClass() == "weapon_br_zombie"
		elseif ply:GetNClass() == ROLES.ROLE_SCP457 then
			return wep:GetClass() == "weapon_scp_457"
		elseif ply:GetNClass() == ROLES.ROLE_SCP0082 then
			return wep:GetClass() == "weapon_br_zombie_infect"
		elseif ply:GetNClass() == ROLES.ROLE_SCP0966 then
			return wep:GetClass() == "weapon_scp_966"
		else
			return false
		end
	end
	*/
	if ply:GTeam() == TEAM_SCP then
		if not wep.ISSCP then
			return false
		else
			if wep.ISSCP == true then
				return true
			else
				return false
			end
		end
	end
	/*
	if ply:GetNClass() != ROLES.ROLE_SCP173 then
		if wep:GetClass() == "weapon_scp_173" then
			return false
		end
	end
	if ply:GetNClass() != ROLES.ROLE_SCP106 then
		if wep:GetClass() == "weapon_scp_106" then
			return false
		end
	end
	if ply:GetNClass() != ROLES.ROLE_SCP049 then
		if wep:GetClass() == "weapon_scp_049" then
			return false
		end
	end
	if ply:GetNClass() != ROLES.ROLE_SCP096 then
		if wep:GetClass() == "weapon_scp_096" then
			return false
		end
	end
	if ply:GetNClass() != ROLES.ROLE_SCP0966 then
		if wep:GetClass() == "weapon_scp_966" then
			return false
		end
	end
	if ply:GetNClass() != ROLES.ROLE_SCP0492 then
		if wep:GetClass() == "weapon_br_zombie" then
			return false
		end
	end
	*/
	if ply:GTeam() != TEAM_SPEC then
		if wep.teams then
			local canuse = false
			for k,v in pairs(wep.teams) do
				if v == ply:GTeam() then
					canuse = true
				end
			end
			if canuse == false then
				return false
			end
		end
		for k,v in pairs(ply:GetWeapons()) do
			if v:GetClass() == wep:GetClass() then
				return false
			end
		end
		for k,v in pairs( ply:GetWeapons() ) do
			if ( string.starts( v:GetClass(), "cw_" ) and string.starts( wep:GetClass(), "cw_" )) then return false end
		end
		ply.gettingammo = wep.SavedAmmo
		return true
	else
		if ply:GetNClass() == ROLES.ADMIN then
			if wep:GetClass() == "br_holster" then return true end
			if wep:GetClass() == "weapon_physgun" then return true end
			if wep:GetClass() == "gmod_tool" then return true end
			if wep:GetClass() == "br_entity_remover" then return true end
		end
		return false
	end
end

function GM:PlayerCanPickupItem( ply, item )
	return ply:GTeam() != TEAM_SPEC or ply:GetNClass() == ROLES.ADMIN
end

function GM:AllowPlayerPickup( ply, ent )
	return ply:GTeam() != TEAM_SPEC or ply:GetNClass() == ROLES.ADMIN
end
// usesounds = true,

--bit.lshift( 1, 0 ) = 0   --ACCESS_SAFE
--bit.lshift( 1, 1 ) = 1   --ACCESS_EUCLID
--bit.lshift( 1, 2 ) = 2   --ACCESS_KETER
--bit.lshift( 1, 3 ) = 3   --ACCESS_CHECKPOINT
--bit.lshift( 1, 4 ) = 4   --ACCESS_OMEGA
--bit.lshift( 1, 5 ) = 5   --ACCESS_GENERAL
--bit.lshift( 1, 6 ) = 6   --ACCESS_GATEA
--bit.lshift( 1, 7 ) = 7   --ACCESS_GATEB
--bit.lshift( 1, 8 ) = 8   --ACCESS_ARMORY
--bit.lshift( 1, 9 ) = 9   --ACCESS_FEMUR
--bit.lshift( 1, 10 ) = 10 --ACCESS_EC

DOOR_ACCESS_LEVEL = 0
--[[
function GM:KeyPress( ply, key )
	if key == IN_USE then
		if ply:GTeam() == TEAM_SCP and ply:KeyDown(IN_USE) then
				ply.lastuse = CurTime() + 1
		
			if !ply.IsHacking and ply:KeyReleased(IN_USE) then
			timer.Create("SCPDoorHackTimer_"..ply:SteamID64(), 1, 20, function()
				if ply:GetEyeTrace().Entity:GetClass() != "func_door" or ply:GetEyeTrace().Entity:GetClass() != "func_button" then
					timer.Remove("SCPDoorHackTimer_"..ply:SteamID64())
					ply.IsHacking = false
					return
				end
			
				if !ply:KeyDown(IN_USE) then
					timer.Remove("SCPDoorHackTimer_"..ply:SteamID64())
					ply.IsHacking = false
					return
				end
		
				ply.IsHacking = true
				if timer.RepsLeft("SCPDoorHackTimer_"..ply:SteamID64()) == 2 then
					ply:RXSENDNotify("Вы начали процесс взлома двери.")
				elseif timer.RepsLeft("SCPDoorHackTimer_"..ply:SteamID64()) == 5 then
					ply:GetEyeTrace().Entity:EmitSound("door_break.wav")
				elseif timer.RepsLeft("SCPDoorHackTimer_"..ply:SteamID64()) == 10 then
					ply:GetEyeTrace().Entity:EmitSound("door_break.wav")
				elseif timer.RepsLeft("SCPDoorHackTimer_"..ply:SteamID64()) == 15 then
					ply:GetEyeTrace().Entity:EmitSound("door_break.wav")
				elseif timer.RepsLeft("SCPDoorHackTimer_"..ply:SteamID64()) == 20 then
					ply:GetEyeTrace().Entity:EmitSound("door_break.wav")
					ply:GetEyeTrace().Entity:EmitSound("ambient/energy/spark"..math.random(1, 6)..".wav")
					ply:GetEyeTrace().Entity:Fire("Open")
					local DamagedPlayerSpark    =    ents.Create( "env_spark" )
			
				    DamagedPlayerSpark:SetPos(ply:GetEyeTrace().Entity:GetPos())
			
				    DamagedPlayerSpark:SetKeyValue( "Magnitude" , "5" )
				    DamagedPlayerSpark:SetKeyValue( "spawnflags" , "256" )
					DamagedPlayerSpark:SetKeyValue( "TrailLength" , "5" )
				    DamagedPlayerSpark:Spawn()
			
				    if IsValid( DamagedPlayerSpark ) then
			
				        DamagedPlayerSpark:Fire( "SparkOnce" , 0 , 0 )
				        DamagedPlayerSpark:Fire( "SparkOnce" , 0 , 0 )
			
			
			
				    end
			
				    timer.Simple( 0.02 , function()
			
				        if IsValid( DamagedPlayerSpark ) then
			
				            DamagedPlayerSpark:Remove()
			
				        end
			
				    end)
					timer.Remove("SCPDoorHackTimer_"..ply:SteamID64())
				end
		
			end)
			end
		end
	end
end
--]]

ttt_restricted_doors = {
Vector(1536.000000, 3648.000000, 53.000000),
Vector(1289.000000, 2216.000000, 53.000000),
Vector(1673.000000, 2216.000000, 53.000000),
Vector(2176.000000, 2368.000000, 53.000000)
}

function GM:PlayerUse( ply, ent )
	if activeRound == ROUNDS.ww2tdm then
		if ent:GetModel() == "models/foundation/doors/860_door.mdl" then
			if ply:KeyReleased(IN_USE) then
				ply:RXSENDWarning("Игра идёт в пределах ОЗ!")
			end
			return false
		end
	end
	
	if activeRound == ROUNDS.ttt then
		if ent:GetModel() == "models/foundation/doors/860_door.mdl" then
			if ply:KeyReleased(IN_USE) then
				ply:RXSENDWarning("Игра идёт в пределах ОЗ!")
			end
			return false
		end
	end
	
	if ent:GetClass() == "armor_sci" and ply:GTeam() == TEAM_SCI then
		--ply:RXSENDWarning("Вы не можете носить эту броню!")
		return false
	end
	if ent:GetClass() == "armor_sci_med" and ply:GTeam() == TEAM_SCI then
		--ply:RXSENDWarning("Вы не можете носить эту броню!")
		return false
	end
	if ply:GTeam() == TEAM_SPEC and ply:GetNClass() != ROLES.ADMIN then return false end
	if ply:GetNClass() == ROLES.ADMIN then return true end
	if ply.lastuse == nil then ply.lastuse = 0 end
	if ply.lastuse > CurTime() then return false end
	for k,v in pairs(MAPBUTTONS) do
		if v["pos"] == ent:GetPos() then
			//print("Found a button: " .. v["name"])
			if v.access != nil then

				if v.access == bit.lshift( 1, 1 ) then
					DOOR_ACCESS_LEVEL = 1

				elseif v.access == bit.lshift( 1, 2 ) then
					DOOR_ACCESS_LEVEL = 2

				elseif v.access == bit.lshift( 1, 3 ) then
					DOOR_ACCESS_LEVEL = 3

				elseif v.access == bit.lshift( 1, 4 ) then
					DOOR_ACCESS_LEVEL = 4

				elseif v.access == bit.lshift( 1, 5 ) then
					DOOR_ACCESS_LEVEL = 5

				elseif v.access == bit.lshift( 1, 6 ) then
					DOOR_ACCESS_LEVEL = 6

				elseif v.access == bit.lshift( 1, 7 ) then
					DOOR_ACCESS_LEVEL = 7

				elseif v.access == bit.lshift( 1, 8 ) then
					DOOR_ACCESS_LEVEL = 8

				elseif v.access == bit.lshift( 1, 8 ) then
					DOOR_ACCESS_LEVEL = 8

				elseif v.access == bit.lshift( 1, 9 ) then
					DOOR_ACCESS_LEVEL = 9

				elseif v.access == bit.lshift( 1, 10 ) then
					DOOR_ACCESS_LEVEL = 10
				end

				if ply:CLevel() >= DOOR_ACCESS_LEVEL or ( v.levelOverride and v.levelOverride( ply ) ) then
					--if v.usesounds == true then
						ply:EmitSound("KeycardUse1.ogg")
					--end
					ply.lastuse = CurTime() + 1
					--ply:SendLua('print("CLevel = "..ply:CLevel())')
					--ply:SendLua('print("Door level = "..v.access)')
					ply:LocationNotify(v["name"])
					ent:Fire("use")
					return true
				elseif ply:CLevel() <= DOOR_ACCESS_LEVEL and ply:CLevel() > 0 or ( v.levelOverride and v.levelOverride( ply ) ) then
					--if v.usesounds == true then
						ply:EmitSound("KeycardUse2.ogg")
					--end
					ply.lastuse = CurTime() + 1
					--ply:PrintMessage(HUD_PRINTCENTER, "Вам нужен более высокий уровень доступа, чтобы открыть эту дверь.")
					--ply:SendLua('print("CLevel = "..ply:CLevel())')
					--ply:SendLua('print("Door level = "..v.access)')
					return false
				elseif GetGlobalBool("Nuke", false) and string.find(string.lower(ent:GetName()), "gate") then
					ply.lastuse = CurTime() + 1
					return true
				else
					if ply:KeyReleased(IN_USE) then
						ply:TipSendNotify("Вам нужна ключ-карта для открытия этой двери.")
					end
					return false
				end
			end
			if v.canactivate != nil then
				local canactivate = v.canactivate(ply, ent)
				if canactivate then
					--if v.usesounds == true then
						ply:EmitSound("KeycardUse1.ogg")
					--end
					ply.lastuse = CurTime() + 1
					--ply:PrintMessage(HUD_PRINTCENTER, "Доступ получен к " .. v["name"])
					--ply:SendLua('print("CLevel = "..ply:CLevel())')
					--ply:SendLua('print("Door level = "..v.access)')
					ply:LocationNotify(v["name"])
					ent:Fire("use")
					return true
				else
					if v.usesounds == true then
						ply:EmitSound("KeycardUse2.ogg")
					end
					ply.lastuse = CurTime() + 1
					if v.customdenymsg then
						--ply:RXSENDNotify(v.customdenymsg)
					else
						ply:RXSENDNotify("Доступ запрещён")
					end
					return false
				end
			end
		end
	end
	if ( GetConVar("br_scp_cars"):GetInt() == 0 ) then
		if ( ply:GTeam() == TEAM_SCP ) then
			if ( ent:GetClass() == "prop_vehicle_jeep" ) then
				return false
			end
		end
	end
	if ply:GTeam() == TEAM_SCP then
		if ent:GetClass() == "cw_ammo_40mm" then
			return false
		end
	end
	return true
end

function GM:CanPlayerSuicide( ply )
	return false
end

function string.starts(String, Start)
   return string.sub(String,1,string.len( Start )) == Start
end


