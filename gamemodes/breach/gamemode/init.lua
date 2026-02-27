// Initialization file
AddCSLuaFile( "fonts.lua" )
AddCSLuaFile( "cl_font.lua" )
AddCSLuaFile( "class_breach.lua" )
AddCSLuaFile( "cl_hud_new.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "gteams.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_mtfmenu.lua" )
AddCSLuaFile( "sh_player.lua" )
AddCSLuaFile( "sh_playersetups.lua" )
AddCSLuaFile( "sh_precache.lua" )
AddCSLuaFile( "github_outline.lua" )
mapfile = "mapconfigs/" .. game.GetMap() .. ".lua"
--AddCSLuaFile(mapfile)
ALLLANGUAGES = {}
WEPLANG = {}
clang = nil
cwlang = nil

local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA" )
for k,v in pairs(files) do
	local path = "languages/"..v
	if string.Right(v, 3) == "lua" and string.Left(v, 3) != "wep" then
		AddCSLuaFile( path )
		include( path )
		print("Language found: " .. path)
	end
end
local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/wep_*.lua", "LUA" )
for k,v in pairs(files) do
	local path = "languages/"..v
	if string.Right(v, 3) == "lua" then
		AddCSLuaFile( path )
		include( path )
		print("Weapon lang found: " .. path)
	end
end
AddCSLuaFile( "rounds.lua" )
AddCSLuaFile( "cl_sounds.lua" )
AddCSLuaFile( "cl_targetid.lua" )
AddCSLuaFile( "classes.lua" )
AddCSLuaFile( "cl_classmenu.lua" )
AddCSLuaFile( "cl_headbob.lua" )
AddCSLuaFile( "cl_splash.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_eq.lua" )
AddCSLuaFile( "cl_tips.lua" )

AddCSLuaFile( "ulx.lua" )
AddCSLuaFile( "cl_minigames.lua" )
include( "server.lua" )
include( "rounds.lua" )
include( "class_breach.lua" )
include( "shared.lua" )
include( "classes.lua" )
include( mapfile )
include( "sh_player.lua" )
include( "sv_player.lua" )
include( "player.lua" )
include( "sv_round.lua" )
include( "gteams.lua" )
include( "sv_func.lua" )

include( "ulx.lua" )

include( "sh_precache.lua" )

// Variables
gamestarted = gamestarted or false
preparing = false
postround = false
roundcount = 0
rounds = -1
firstround = true
MAPBUTTONS = table.Copy(BUTTONS)

function GM:AllowPlayerPickup(ply, ent)
	return false
end

--------------------------------------------------
AFK_TIME = 300

AFK_WARN_TIME = 180
--------------------------------------------------

hook.Add("PlayerInitialSpawn", "MakeAFKVar", function(ply)
	ply.NextAFK = CurTime() + AFK_TIME
end)

timer.Create("CheckAFK", 1, 0, function()
	for _, ply in pairs (player.GetAll()) do
		if ply:GTeam() != TEAM_SPEC then
			if ( ply:IsConnected() and ply:IsFullyAuthenticated() ) then
				if (!ply.NextAFK) then
					ply.NextAFK = CurTime() + AFK_TIME
				end
			
				local afktime = ply.NextAFK
				if (CurTime() >= afktime - AFK_WARN_TIME) and (!ply.Warning) then
					ply:RXSENDWarning("Через две минуты вы будете отключены от сервера за неактивность.")
					ply:SendLua("system.FlashWindow()")
					ply.Warning = true
				elseif (CurTime() >= afktime) and (ply.Warning) then
					ply.Warning = nil
					ply.NextAFK = nil
					ply:Kick("Неактивность более 5 минут.\n")
				end
			end
		elseif ply:GTeam() == TEAM_SPEC then
			if ( ply:IsConnected() and ply:IsFullyAuthenticated() ) then
				ply.NextAFK = CurTime() + AFK_TIME
				ply.Warning = false
			end
		end
	end
end)


hook.Add("KeyPress", "PlayerMoved", function(ply, key)
	ply.NextAFK = CurTime() + AFK_TIME
	ply.Warning = false
end)

function PlayAnimationBase( ent, anim, speed )
	if ( !IsValid( ent ) ) then return end

	-- HACK: This is not perfect, but it will have to do
	if ( ent:GetClass() == "prop_dynamic" ) then
		ent:Fire( "SetAnimation", anim )
		ent:Fire( "SetPlaybackRate", math.Clamp( tonumber( speed ), 0.05, 3.05 ) )
		return
	end

	ent:ResetSequence( ent:LookupSequence( anim ) )
	ent:ResetSequenceInfo()
	ent:SetCycle( 0 )
	ent:SetPlaybackRate( math.Clamp( tonumber( speed ), 0.05, 3.05 ) )

end

function GM:SetupPlayerVisibility(ply, viewentity)
if ply:GTeam() != TEAM_SPEC then
	if IsValid(ply:GetActiveWeapon()) then
		if ply:GetActiveWeapon():GetClass() == "item_cameraview" then
			for k, v in ipairs(CAMERAS) do
				AddOriginToPVS(v.pos)
			end
		end
	end
end

--if ply:GTeam() == TEAM_SCP then
	--for k, v in ipairs(player.GetAll()) do
		--if v:GTeam() == TEAM_SCP then
			--AddOriginToPVS(v:GetPos())
		--end
	--end
--end
end

--Предзагрузка всей системы раундов

--[[
function GM:InitPostEntity()
for i=1, 9 do
	RunConsoleCommand("bot")
end

timer.Simple(15, function()
	for k, v in ipairs(player.GetBots()) do
		v:Kick("Round precaching")
	end
	--timer.Stop("RoundTime")
	rounds = 1
	--roundcount = 0
end)

end
--]]

hook.Add("PlayerButtonDown", "SpecialsAbilities", function(ply, key)
	if key == KEY_H then

		--Способность Матильды
		if ply:GetNClass() == ROLES.ROLE_SPECIALRES then
			if IsFirstTimePredicted() and !ply.MatildaHealUsed then
	
				ply.MatildaHealUsed = true
				ply:RXSENDNotify("Способность перезаряжается, ожидайте 2 минуты.")
				ply:EmitSound("special_sci/medic/medic_"..math.random(1, 11)..".mp3")

				if !timer.Exists("PlayerAbilityResetMatilda_"..ply:SteamID64()) then
					timer.Create("PlayerAbilityResetMatilda_"..ply:SteamID64(), 120, 1, function()
						if ply:GetNClass() == ROLES.ROLE_SPECIALRES then
							ply.MatildaHealUsed = false
							ply:RXSENDNotify("Способность готова к использованию!")
						end
					end)
				end
	
				for k, v in ipairs(ents.FindInSphere(ply:GetPos(), 150)) do
					if v:IsPlayer() then
						if v:GTeam() != TEAM_SCP then
							v:SetHealth(v:GetMaxHealth())
							timer.Simple(2, function()
								v:EmitSound("items/medshot4.wav")
							end)
						end
					end
				end
	
			elseif IsFirstTimePredicted() and ply.MatildaHealUsed then
				ply:RXSENDWarning("Способность перезаряжается!")
			end
		end

		--Способность Спедвауна
		if ply:GetNClass() == ROLES.ROLE_SPECIALRESSSS then
			if IsFirstTimePredicted() and !ply.SpedwaunUsed then
	
				ply.SpedwaunUsed = true
				ply:RXSENDNotify("Способность перезаряжается, ожидайте 2 минуты.")
				ply:EmitSound("special_sci/scp_slower/scp_slower_"..math.random(1, 14)..".mp3")
				if !timer.Exists("PlayerAbilityResetSpedwaun_"..ply:SteamID64()) then
					timer.Create("PlayerAbilityResetSpedwaun_"..ply:SteamID64(), 120, 1, function()
						if ply:GetNClass() == ROLES.ROLE_SPECIALRESSSS then
							ply.SpedwaunUsed = false
							ply:RXSENDNotify("Способность готова к использованию!")
						end
					end)
				end
	
				for k, v in ipairs(ents.FindInSphere(ply:GetPos(), 150)) do
					if v:IsPlayer() then
						if v:GTeam() == TEAM_SCP then
							v:SetMaxSpeed(v:GetMaxSpeed() / 3)
							v:SetWalkSpeed(v:GetWalkSpeed() / 3)
							v:SetRunSpeed(v:GetRunSpeed() / 3)
							v:SetJumpPower(v:GetJumpPower() / 3)
							timer.Simple(15, function()
								if v:GTeam() == TEAM_SCP then
									v:SetMaxSpeed(v:GetMaxSpeed() * 3)
									v:SetWalkSpeed(v:GetWalkSpeed() * 3)
									v:SetRunSpeed(v:GetRunSpeed() * 3)
									v:SetJumpPower(v:GetJumpPower() * 3)
								end
							end)
						end
					end
				end
	
			elseif IsFirstTimePredicted() and ply.SpedwaunUsed then
				ply:RXSENDWarning("Способность перезаряжается!")
			end
		end

		--Способность Ломао
		if ply:GetNClass() == ROLES.ROLE_SPEEED then
			if IsFirstTimePredicted() and !ply.LomaoUsed then
				if ply.exhausted then
					ply:RXSENDWarning("Вам стоит отдохнуть.")
					return
				end

				ply.LomaoUsed = true
				ply:RXSENDNotify("Способность перезаряжается, ожидайте 2 минуты.")
				ply:EmitSound("special_sci/speed_booster/speed_booster_"..math.random(1, 12)..".mp3")
				if !timer.Exists("PlayerAbilityResetLomao_"..ply:SteamID64()) then
					timer.Create("PlayerAbilityResetLomao_"..ply:SteamID64(), 120, 1, function()
						if ply:GetNClass() == ROLES.ROLE_SPEEED then
							ply.LomaoUsed = false
							ply:RXSENDNotify("Способность готова к использованию!")
						end
					end)
				end
	
				for k, v in ipairs(ents.FindInSphere(ply:GetPos(), 150)) do
					if v:IsPlayer() then
						if v:GTeam() != TEAM_SPEC then
							if v:GTeam() != TEAM_SCP then
								v:SetMaxSpeed(v:GetMaxSpeed() * 1.5)
								v:SetWalkSpeed(v:GetWalkSpeed() * 1.5)
								v:SetRunSpeed(v:GetRunSpeed() * 1.5)
								v:SetJumpPower(v:GetJumpPower() * 1.5)
							end
							timer.Simple(15, function()
								if v:GTeam() != TEAM_SPEC or v:GTeam() != TEAM_SCP then
									v:SetMaxSpeed(v:GetMaxSpeed() / 1.5)
									v:SetWalkSpeed(v:GetWalkSpeed() / 1.5)
									v:SetRunSpeed(v:GetRunSpeed() / 1.5)
									v:SetJumpPower(v:GetJumpPower() / 1.5)
								end
							end)
						end
					end
				end
	
			elseif IsFirstTimePredicted() and ply.LomaoUsed then
				ply:RXSENDWarning("Способность перезаряжается!")
			end
		end

		--Способность Келена
		if ply:GetNClass() == ROLES.ROLE_SPECIALRESSS then
			if IsFirstTimePredicted() and !ply.KelenUsed then
	
				ply.KelenUsed = true
				ply:RXSENDNotify("Способность перезаряжается, ожидайте 2 минуты.")
				ply:EmitSound("special_sci/buffer_damage/buffer_"..math.random(1, 14)..".mp3")
				if !timer.Exists("PlayerAbilityResetKelen_"..ply:SteamID64()) then
					timer.Create("PlayerAbilityResetKelen_"..ply:SteamID64(), 120, 1, function()
						if ply:GetNClass() == ROLES.ROLE_SPECIALRESSS then
							ply.KelenUsed = false
							ply:RXSENDNotify("Способность готова к использованию!")
						end
					end)
				end
	
				for k, v in ipairs(ents.FindInSphere(ply:GetPos(), 150)) do
					if v:IsPlayer() then
						if v:GTeam() == TEAM_SCP then
							v:SetNWBool("debuff", true)
						end
						timer.Simple(15, function()
							if v:GTeam() == TEAM_SCP then
								v:SetNWBool("debuff", false)
							end
						end)
					end
				end

			elseif IsFirstTimePredicted() and ply.KelenUsed then
				ply:RXSENDWarning("Способность перезаряжается!")
			end
		end

		--Способность Филона
		if ply:GetNClass() == ROLES.ROLE_LESSION then

			if ply.FeelonMaxMines == 0 then
				ply:RXSENDWarning("У вас закончились мины!")
				return
			end

			if IsFirstTimePredicted() and !ply.FeelonUsed then
				if !ply:IsOnGround() then
					ply:RXSENDWarning("Вы не можете поставить мину в воздухе!")
					return
				end

				ply.FeelonUsed = true
				ply:RXSENDNotify("Способность перезаряжается, ожидайте 3 секунды.")
				ply:EmitSound("special_sci/trapper/trapper_"..math.random(1, 10)..".mp3")
				if !timer.Exists("PlayerAbilityResetFeelon_"..ply:SteamID64()) then
					timer.Create("PlayerAbilityResetFeelon_"..ply:SteamID64(), 3, 1, function()
						if ply:GetNClass() == ROLES.ROLE_LESSION then
							ply.FeelonUsed = false
							ply:RXSENDNotify("Способность готова к использованию!")
						end
					end)
				end

				local tr = util.TraceLine( {
					start = ply:GetPos(),
					endpos = ply:GetPos() + ply:GetAngles():Up(),
					mask = MASK_ALL,
					filter = function(ent)
						if ent:IsPlayer() then
							return false
						end
						if !ent:IsWorld() then
							return false
						end
					end
				} )
				
				local mine = ents.Create("ent_special_trap")
				mine:SetPos(tr.HitPos)
				mine:Spawn()
				mine:SetSolid(SOLID_NONE)

				ply.FeelonMaxMines = ply.FeelonMaxMines - 1
	
			elseif IsFirstTimePredicted() and ply.FeelonUsed then
				ply:RXSENDWarning("Способность перезаряжается!")
			end
		end

	end
end)

function GM:PlayerShouldTaunt(ply, act)
	return false
end

--Мои функции линейного движения. shit of bull
local something = FindMetaTable("Entity")

function something:LinearMotion(speed, endpos)
if !IsValid(self) then return end
	timer.Remove(self:GetClass().."_linear_motion")

	local ratio = 0
	local time = 0
	local startpos = self:GetPos()

	timer.Create(self:GetClass().."_linear_motion", FrameTime(), 9999999999999, function()
		if !IsValid(self) then return end
	    ratio = speed + ratio
	    time = time + FrameTime()
	    self:SetPos(LerpVector(ratio, startpos, endpos))

	    if self:GetPos():DistToSqr(endpos) < 1 then
	    	self:SetPos(endpos)
	    end

	    if self:GetPos() == endpos then
	    	print("Linear Motion finished, seconds passed: "..time)
	    	timer.Remove(self:GetClass().."_linear_motion")
	    end
	end)
end

function something:LinearAngle(speed, endangle)
if !IsValid(self) then return end
	timer.Remove(self:GetClass().."_linear_angle")

    local ratio = 0
    local startangle = self:GetAngles()
    local startangle_table = startangle:Unpack()
    local endangle_table = endangle:Unpack()
    local startangle_tovector = Vector(startangle[1], startangle[2], startangle[3])
    local endangle_tovector = Vector(endangle[1], endangle[2], endangle[3])

    timer.Create(self:GetClass().."_linear_angle", FrameTime(), 9999999999999, function()
        if !IsValid(self) then return end
        ratio = math.min(ratio + speed, 1)
        self:SetAngles(LerpAngle(ratio, startangle, endangle))

        if startangle_tovector:DistToSqr(endangle_tovector) < 1 then
            self:SetAngles(endangle)
        end

        if self:GetAngles() == endangle then
            timer.Remove(self:GetClass().."_linear_angle")
            return true
        end
    end)
end

timer.Create("CheckONPEscape", 0.5, 0, function()
--Побег ОНП
for k, v in ipairs(ents.FindInBox(Vector(-7018, -1024, 1729), Vector(-7055, -903, 1848))) do
	if v:IsPlayer() then

	if v:GTeam() == TEAM_USA then
		v:StripWeapons()
		v:SetSpectator()
		local exptogive = v:Frags() * 5
		if v:GetNWInt("fbidocuments", 0) > 0 then
			v:RXSENDNotify("Вы успешно эвакуировались из комплекса с документами! Хорошая работа, теперь мир узнает о всех тайнах фонда. Ваша команда отлично сработала, и вы получили достойную награду.")
			v:StripWeapons()
			v:AddExp(60 * math.max(1, v:GetNLevel()) + exptogive)
		elseif v:GetNWInt("fbidocuments", 0) < 3 then
			v:RXSENDNotify("Миссия провалена! К сожалению, мы не смогли достать всю информацию из фонда. Это конец.")
			v:AddExp(15 * math.max(1, v:GetNLevel()) + exptogive)
		end

		v:RXSENDNotify("Секретных документов собрано: "..v:GetNWInt("fbidocuments"))
		v:RXSENDNotify("Ваш счёт: "..v:Frags())

		v:SetNWInt("fbidocuments", 0)
		v:SetFrags(0)

	elseif v:GTeam() != TEAM_USA and v:GTeam() != TEAM_SPEC then
		if v:GTeam() == TEAM_CLASSD then
			roundstats.descaped = roundstats.descaped + 1
		end
		if v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_SPECIAL then
			roundstats.rescaped = roundstats.rescaped + 1
		end
		v:StripWeapons()
		v:SetSpectator()
		local exptogive = v:Frags() * 4
		v:SetSpectator()
		v:RXSENDNotify("Вы сбежали совершенно не тем способом, но по крайней мере остались в живых.")
		local exptogive = v:Frags() * 5
		v:AddExp(12 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(25,30)))

		v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
		v:RXSENDNotify("Ваш счёт: "..v:Frags())

		v:SetNWInt("documents", 0)
		v:SetFrags(0)
	end
	end

end
end)

EvacuationSettedUp = false
timer.Create("RoundTimeCheck", 1, 0, function()
if !timer.Exists("RoundTime") then return end
if timer.TimeLeft("RoundTime") == nil then return end
if disableEvac then return end

if timer.TimeLeft("RoundTime") <= 900 and !first_announcement then
	first_announcement = true
	for k, v in ipairs(player.GetAll()) do
		v:TipSendNotify("Внимание! До взрыва комплекса осталось: 15 минут")
		v:SendLua('surface.PlaySound("scp_sounds_new/decont_15_b.mp3")')
	end
end

if timer.TimeLeft("RoundTime") <= 600 and !second_announcement then
	second_announcement = true
	for k, v in ipairs(player.GetAll()) do
		v:TipSendNotify("Внимание! До взрыва комплекса осталось: 10 минут")
		v:SendLua('surface.PlaySound("scp_sounds_new/decont_10_b.mp3")')
	end
end

if timer.TimeLeft("RoundTime") <= 300 and !third_announcement then
	third_announcement = true
	for k, v in ipairs(player.GetAll()) do
		v:TipSendNotify("Внимание! До взрыва комплекса осталось: 5 минут")
		v:SendLua('surface.PlaySound("scp_sounds_new/decont_5_b.mp3")')
	end
end

	if timer.Exists("RoundTime") and timer.TimeLeft("RoundTime") <= 133 then
		if !timer.Exists("CheckCustomEscape") then
		timer.Create("CheckCustomEscape", 0.1, 1300, function()
			--Вертолёт
			if HeliIsLanded then
				for k, v in ipairs(ents.FindInBox(Vector(-3078, 6821, 2059), Vector(-3238, 6504, 2165))) do
					if v:IsPlayer() then

					if v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_GUARD or v:GTeam() == TEAM_NTF or v:GTeam() == TEAM_SPECIAL then
						v:StripWeapons()
						v:SetSpectator()
						v:RXSENDNotify("Вы были успешно эвакуированы фондом!")
						local exptogive = v:Frags() * 10
						v:AddExp(40 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))						

						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:RXSENDNotify("Ваш счёт: "..v:Frags())

						v:SetNWInt("documents", 0)
						v:SetFrags(0)
						
						if v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_SPECIAL then
							roundstats.rescorted = roundstats.rescorted + 1
							for k, v in ipairs(ents.FindInSphere(ksaikok:GetPos(), 750)) do
								if v:IsPlayer() then
									if v:GTeam() == TEAM_GUARD or v:GTeam() == TEAM_NTF then
										v:RXSENDNotify("Вы получили награду за эвакуацию персонала!")
										v:AddExp(5 * math.max(1, v:GetNLevel()))
									end
								end
							end
						end

					elseif v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_USA then
						if v:GTeam() == TEAM_CLASSD then
							roundstats.descaped = roundstats.descaped + 1
						end
						
						v:StripWeapons()
						v:SetSpectator()
						v:RXSENDNotify("Вы получили опыта в 2 раза меньше, т.к. вы были эвакуированы фондом.")
						local exptogive = v:Frags() * 5
						v:AddExp(20 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(50,60)))

						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:RXSENDNotify("Ваш счёт: "..v:Frags())

						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
					
					end

				end
			end
			--БТР
			if IsAPCReady then
				for k, v in ipairs(ents.FindInBox(Vector(-1322, 6938, 1667), Vector(-1002, 6786, 1789))) do
					if v:IsPlayer() then

					if v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_CHAOS then
						if v:GTeam() == TEAM_CLASSD then
							roundstats.dcaptured = roundstats.dcaptured + 1
							for k, v in ipairs(ents.FindInSphere(apc:GetPos(), 750)) do
								if v:IsPlayer() then
									if v:GTeam() == TEAM_CHAOS then
										v:RXSENDNotify("Вы получили награду за эвакуацию заключённого Класса-Д!")
										v:AddExp(6 * math.max(1, v:GetNLevel()))
									end
								end
							end
						end
						v:StripWeapons()
						v:SetSpectator()
						v:RXSENDNotify("Вы были успешно эвакуированы Повстанцами Хаоса!")
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))

						v:SetNWInt("documents", 0)
						v:SetFrags(0)

					end
					
					end
				end
			end
			--Портал
			if PortalIsReady then
				for k, v in ipairs(ents.FindInBox(Vector(-3180, 5272, 1670), Vector(-3200, 5220, 1756))) do
					if v:IsPlayer() then

					if v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_DZ then
						if v:GTeam() == TEAM_SCP then
							roundstats.sescaped = roundstats.sescaped + 1
							for k, v in ipairs(ents.FindInSphere(portal:GetPos(), 750)) do
								if v:IsPlayer() then
									if v:GTeam() == TEAM_DZ then
										v:RXSENDNotify("Вы получили награду за эвакуацию СЦП объекта!")
										v:AddExp(10 * math.max(1, v:GetNLevel()))
									end
								end
							end
						end
						local exptogive = v:Frags() * 10
						v:RXSENDNotify("Вы успешно сбежали из комплекса через портал Длань Змеи!")
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:StripWeapons()
						v:SetSpectator()
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive)
	
						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:SetFrags(0)
						
					end
					
					end
				end
			end
		end)
		end

		if !EvacuationSettedUp then

		EvacuationSettedUp = true
		SetGlobalBool("Nuke", true)
		for k, v in ipairs(player.GetAll()) do
				v:TipSendWarning("Боеголовка была активирована! Проследуйте на точку эвакуации!")
				v:SendLua('surface.PlaySound("scp_sounds_new/final_nuke.mp3")')
			if v:GTeam() == TEAM_GOC then
				v:RXSENDNotify("Комплекс всё равно будет взорван, мы победили...")
				v:SendLua('surface.PlaySound("scp_sounds_new/final_nuke.mp3")')
			end
		end

		--Вертолёт
		ksaikok = ents.Create("br_heli")
		--ksaikok:SetModel("models/scp_helicopter/resque_helicopter.mdl")
		ksaikok:SetPos(Vector(635, 5421, 2922))
		ksaikok:SetAngles(Angle(0, 90, -5))
		ksaikok:Spawn()
		ksaikok:SetMoveType(MOVETYPE_NONE)
		ksaikok:SetBodygroup(2, 3)
		ksaikok:SetBodygroup(3, 1)
		--ksaikok:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

		timer.Simple(1, function()
			--ksaikok:CollisionRulesChanged()
		end)

		ksaikok:LinearMotion(0.001, Vector(-2754, 5440, 2805))
		ksaikok:AddGestureSequence(1, false)
		ksaikok:EmitSound("vehicles/chopper_rotor2.wav", 100, 100, 5, CHAN_STATIC)
		--ksaikok:EnableMotion(false)

		timer.Simple(15, function()
			--ksaikok:SetAngles(Angle(0, 90, -5))
			ksaikok:LinearMotion(0.003, Vector(-3279, 5833, 2636))
			ksaikok:LinearAngle(0.003, Angle(-4, 0, -14))
			timer.Simple(4.85, function()
				--ksaikok:SetAngles(Angle(-4, 0, -14))
				ksaikok:LinearMotion(0.003, Vector(-3572, 6241, 2603))
				ksaikok:LinearAngle(0.003, Angle(12, -39, 7))
				timer.Simple(4.85, function()
					--ksaikok:SetAngles(Angle(12, -39, 7))
					ksaikok:LinearMotion(0.003, Vector(-3581, 6635, 2575))
					ksaikok:LinearAngle(0.003, Angle(10, -82, 16))
					timer.Simple(4.85, function()
						--ksaikok:SetAngles(Angle(10, -82, 16))
						ksaikok:LinearMotion(0.003, Vector(-3437, 6811, 2490))
						ksaikok:LinearAngle(0.003, Angle(2, -128, 4))
						timer.Simple(4.85, function()
							--ksaikok:SetAngles(Angle(2, -128, 4))
							ksaikok:LinearMotion(0.003, Vector(-3161, 6859, 2426))
							ksaikok:LinearAngle(0.003, Angle(4, -174, 0))
							timer.Simple(4.85, function()
								--ksaikok:SetAngles(Angle(4, -174, 0))
								ksaikok:LinearMotion(0.003, Vector(-3172, 6696, 2052))
								ksaikok:LinearAngle(0.003, Angle(0, -179, 0))
								timer.Simple(4.85, function()
									--ksaikok:SetAngles(Angle(0, -179, 0))
									ksaikok:LinearAngle(0.003, Angle(0, -179, 0))
									ksaikok:RemoveAllGestures()
									ksaikok:AddGestureSequence(4, false)
									ksaikok:AddGestureSequence(6, false)
									HeliIsLanded = true
									timer.Simple(50, function()
										--ksaikok:SetAngles(Angle(0, -179, 0))
										ksaikok:RemoveAllGestures()
										ksaikok:AddGestureSequence(2, false)
										ksaikok:AddGestureSequence(1, false)
										HeliIsLanded = false
										ksaikok:LinearMotion(0.003, Vector(-3164, 6718, 2429))
										ksaikok:LinearAngle(0.003, Angle(0, -90, 0))
										timer.Simple(4.85, function()
											--ksaikok:SetAngles(Angle(0, -90, 0))
											ksaikok:LinearMotion(0.003, Vector(-2077, 6830, 2717))
											ksaikok:LinearAngle(0.003, Angle(-1, -84, -11))
											timer.Simple(4.85, function()
												--ksaikok:SetAngles(Angle(-1, -84, -11))
												ksaikok:LinearMotion(0.003, Vector(912, 7319, 2718))
												ksaikok:LinearAngle(0.003, Angle(0, -76, -13))
												timer.Simple(4.85, function()
													ksaikok:StopSound("vehicles/chopper_rotor2.wav")
													ksaikok:Remove()
												end)
											end)
										end)
									end)
								end)
							end)
						end)
					end)
				end)
			end)
		end)
		--БТР
		apc = ents.Create("br_apc")
		--apc:SetModel("models/scp_chaos_jeep/chaos_jeep.mdl")
		apc:SetPos(Vector(-2879, 1753, 1782))
		apc:SetAngles(Angle(0, 90, 0))
		apc:Spawn()
		apc:SetMoveType(MOVETYPE_NONE)
		apc:StartLoopingSound("car_driving_2.mp3")
		--apc:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

		timer.Simple(1, function()
			--apc:CollisionRulesChanged()
		end)

		apc:LinearMotion(0.002, Vector(-2880, 2984, 1783))
		apc:AddGestureSequence(2, false)
		--apc:EnableMotion(false)

		timer.Simple(7.1, function()
			apc:LinearMotion(0.007, Vector(-2883, 3133, 1776))
			apc:LinearAngle(0.007, Angle(7, 90, 0))
			timer.Simple(2.1, function()
				--apc:SetAngles(Angle(7, 90, 0))
				apc:LinearMotion(0.004, Vector(-2877, 4019, 1665))
				apc:LinearAngle(0.004, Angle(7, 90, 0))
				timer.Simple(3.8, function()
					apc:LinearMotion(0.007, Vector(-2878, 4172, 1655))
					apc:LinearAngle(0.007, Angle(0, 90, 0))
					timer.Simple(2.1, function()
						--apc:SetAngles(Angle(0, 90, 0))
						apc:LinearMotion(0.002, Vector(-2881, 6559, 1656))
						apc:LinearAngle(0.002, Angle(0, 90, 0))
						timer.Simple(7.5, function()
							--apc:SetAngles(Angle(0, 90, 0))
							apc:LinearMotion(0.007, Vector(-2739, 6892, 1655))
							apc:LinearAngle(0.007, Angle(0, 45, 0))
							timer.Simple(2.1, function()
								--apc:SetAngles(Angle(0, 45, 0))
								apc:LinearMotion(0.007, Vector(-2449, 6977, 1656))
								apc:LinearAngle(0.007, Angle(0, 0, 0))
								timer.Simple(2.1, function()
									apc:LinearMotion(0.007, Vector(-2047, 6959, 1655))
									apc:LinearAngle(0.007, Angle(0, -3, 0))
									timer.Simple(2.1, function()
										apc:LinearMotion(0.007, Vector(-1593, 6908, 1655))
										apc:LinearAngle(0.007, Angle(0, -5, 0))
										timer.Simple(2.1, function()
											--apc:SetAngles(Angle(0, -5, 0))
											apc:LinearMotion(0.003, Vector(-1168, 6857, 1655))
											apc:LinearAngle(0.003, Angle(0, 0, 0))
											timer.Simple(5, function()
												--apc:SetAngles(Angle(0, 0, 0))
												apc:RemoveAllGestures()
												apc:LinearAngle(0.003, Angle(0, 0, 0))
												apc:SetBodygroup(1, 1)
												IsAPCReady = true
												apc:AddGestureSequence(1, false)
												timer.Simple(70, function()
													apc:RemoveAllGestures()
													apc:SetBodygroup(1, 0)
													IsAPCReady = false
													apc:AddGestureSequence(2, false)
													apc:LinearMotion(0.007, Vector(-790, 6891, 1655))
													apc:LinearAngle(0.007, Angle(0, 3, 0))
													timer.Simple(2.1, function()
														--apc:SetAngles(Angle(0, 3, 0))
														apc:LinearMotion(0.007, Vector(-420, 6965, 1655))
														apc:LinearAngle(0.007, Angle(0, 6, 0))
														timer.Simple(2.1, function()
															--apc:SetAngles(Angle(0, 6, 0))
															apc:LinearMotion(0.007, Vector(-94, 6975, 1654))
															apc:LinearAngle(0.007, Angle(0, 0, 0))
															timer.Simple(2.1, function()
																--apc:SetAngles(Angle(0, 0, 0))
																apc:LinearMotion(0.007, Vector(49, 6976, 1640))
																apc:LinearAngle(0.007, Angle(14, 0, 0))
																timer.Simple(2.1, function()
																	--apc:SetAngles(Angle(14, 0, 0))
																	apc:LinearMotion(0.007, Vector(445, 6976, 1533))
																	apc:LinearAngle(0.007, Angle(16, 0, 0))
																	timer.Simple(2.1, function()
																		--apc:SetAngles(Angle(16, 0, 0))
																		apc:LinearMotion(0.007, Vector(600, 6976, 1518))
																		apc:LinearAngle(0.007, Angle(0, 0, 0))
																		timer.Simple(2.1, function()
																			apc:LinearMotion(0.007, Vector(900, 6976, 1518))
																			apc:LinearAngle(0.007, Angle(0, 0, 0))
																			timer.Simple(2.1, function()
																				apc:StopSound("car_driving_2.mp3")
																				apc:Remove()
																			end)
																		end)
																	end)
																end)
															end)
														end)
													end)
												end)
											end)
										end)
									end)
								end)
							end)
						end)
					end)
				end)
			end)
		end)
		--Портал
		portal = ents.Create("br_portal")
		portal:SetModel("models/scp_dlan_portal/dlan_portal.mdl")
		portal:SetPos(Vector(-3202, 5221, 1667))
		portal:SetAngles(Angle(0, 0, 0))
		portal:Spawn()
		portal:SetMoveType(MOVETYPE_NONE)
		--portal:EmitSound("ambient/levels/citadel/portal_beam_loop1.wav", 75, 100, 1, CHAN_STATIC)
		PortalIsReady = true
		--portal:EnableMotion(false)
		timer.Simple(113, function()
			portal:Remove()
			PortalIsReady = false
		end)

		--KILL EVERYONE
		timer.Simple(133, function()
			for k, v in ipairs(player.GetAll()) do
				if v:GTeam() != TEAM_SPEC then
					v:TakeDamage(10000)
					v:Freeze(false)
				end
				v:SendLua('RunConsoleCommand("pp_mat_overlay", "overlays/scp/no_signal")')
			end

			rounds = rounds + 1

	if rounds == 10 then
		for k, v in ipairs(player.GetAll()) do
			v:RXSENDNotify("Перезагрузка сервера через полминуты!")
		end
	elseif rounds < 10 then
		for k, v in ipairs(player.GetAll()) do
			v:RXSENDNotify("Раундов до перезагрузки сервера: "..10 - rounds)
		end
	end

	timer.Simple(30, function()
		if rounds < 10 then
			--RoundRestart()
		elseif rounds == 10 then
			for k, v in ipairs(player.GetAll()) do
				v:RXSENDNotify("Перезагружаем сервер...")
			end
			RestartGame()
		end
	end)

		end)

		timer.Simple(163, function()
			for k, v in ipairs(player.GetAll()) do
				v:SendLua('RunConsoleCommand("pp_mat_overlay", "xyecoc")')
			end
			WinCheck()
			--RoundRestart()
		end)

		end

	else
		if timer.Exists("CheckCustomEscape") then
			timer.Remove("CheckCustomEscape")
		end
		SetGlobalBool("Nuke", false)
		EvacuationSettedUp = false
	end
end)

function CheckRDM(victim, inflictor, attacker)
if !attacker:IsPlayer() then return false end
if victim == attacker then return false end
if postround then return false end

local vteam = victim:GTeam()
local ateam = attacker:GTeam()

local scp = TEAM_SCP
local guard = TEAM_GUARD
local d = TEAM_CLASSD
local spec = TEAM_SPEC
local sci = TEAM_SCI
local chaos = TEAM_CHAOS
local goc = TEAM_GOC
local sh = TEAM_DZ
local ntf = TEAM_NTF
local ssci = TEAM_SPECIAL
local onp = TEAM_USA

	if ateam == scp then

		if vteam == scp or vteam == sh then
			return true
		else
			return false
		end

	elseif ateam == guard then

		if vteam == sci or vteam == guard or vteam == ntf or vteam == ssci then
			return true
		else
			return false
		end

	elseif ateam == d then

		if vteam == d or vteam == chaos then
			return true
		else
			return false
		end

	elseif ateam == sci then

		if vteam == sci or vteam == guard or vteam == ntf or vteam == ssci then
			return true
		else
			return false
		end

	elseif ateam == chaos then

		if vteam == chaos or vteam == d then
			return true
		else
			return false
		end

	elseif ateam == goc then

		if vteam == goc then
			return true
		else
			return false
		end

	elseif ateam == sh then

		if vteam == sh or vteam == scp then
			return true
		else
			return false
		end

	elseif ateam == ntf then

		if vteam == sci or vteam == guard or vteam == ntf or vteam == ssci then
			return true
		else
			return false
		end

	elseif ateam == ssci then

		if vteam == sci or vteam == guard or vteam == ntf or vteam == ssci then
			return true
		else
			return false
		end

	elseif ateam == onp then

		if vteam == onp then
			return true
		else
			return false
		end

	end

end

function GetZombieModel(ply)
local pm = ply:GetModel()
local zm = "idk man"

	if string.StartWith(pm, "models/scp_sci_new/sci_new_") then
		zm = "models/scp_zombie/sci_new_1.mdl"

	elseif string.StartWith(pm, "models/scp_sci_new/female/s_female_") then
		zm = "models/scp_zombie/female/s_female_01.mdl"

	elseif string.StartWith(pm, "models/scp_sci_new/med_new_") then
		zm = "models/scp_zombie/med_new_1.mdl"

	elseif string.StartWith(pm, "models/scp_sci_new/female/m_female_") then
		zm = "models/scp_zombie/female/m_female_01.mdl"

	elseif string.StartWith(pm, "models/scp_sci_new/guard_new_") then
		zm = "models/scp_zombie/guard_new_1.mdl"

	elseif string.StartWith(pm, "models/scp_sci_new/sci_headpersonal_new") then
		zm = "models/scp_zombie/sci_new_1.mdl"

	elseif string.StartWith(pm, "models/scp_sci_new/sci_director") then
		zm = "models/scp_zombie/sci_director_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_regular_new") then
		zm = "models/scp_zombie/mog_regular_new.mdl"

	elseif string.StartWith(pm, "models/scp/hazmat_new") then
		zm = "models/scp_zombie/hazmat_zombie_1.mdl"

	elseif string.StartWith(pm, "models/scp_class_d/class_d_bor_new") then
		zm = "models/scp_zombie/class_d_bor_new.mdl"

	elseif string.StartWith(pm, "models/scp_class_d/class_d_fat_new") then
		zm = "models/scp_zombie/class_d_fat_new.mdl"

	elseif string.StartWith(pm, "models/scp_class_d/class_d_new") then
		zm = "models/scp_zombie/class_d_new_1.mdl"

	elseif string.StartWith(pm, "models/scp_class_d/female/d_female_") then
		zm = "models/scp_zombie/female/d_female_01.mdl"

	elseif string.StartWith(pm, "models/scp_class_d/class_d_hacker_new") then
		zm = "models/scp_zombie/class_d_new_1.mdl"

	elseif string.StartWith(pm, "models/scp/mog_noob_new") then
		zm = "models/scp_zombie/mog_noob_new_mog_zombie.mdl"

	elseif string.StartWith(pm, "models/scp/mog_commander_new") then
		zm = "models/scp_zombie/mog_commander_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_eng_new") then
		zm = "models/scp_zombie/mog_no_helmet_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_left_new") then
		zm = "models/scp_zombie/mog_no_helmet_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_medic_new") then
		zm = "models/scp_zombie/mog_medic_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_shock_new") then
		zm = "models/scp_zombie/mog_no_helmet_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_special_new") then
		zm = "models/scp_zombie/mog_regular_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_zombie_round_new") then
		zm = "models/scp_zombie/mog_regular_new.mdl"

	elseif string.StartWith(pm, "models/scp/chaos_new") then
		zm = "models/scp_zombie/chaos_new.mdl"

	elseif string.StartWith(pm, "models/scp/dlan_new") then
		zm = "models/scp_zombie/dlan_new.mdl"

	elseif string.StartWith(pm, "models/scp/fbi_new") then
		zm = "models/scp_zombie/fbi_new.mdl"

	elseif string.StartWith(pm, "models/scp/goc_new") then
		zm = "models/scp_zombie/goc_new.mdl"

	elseif string.StartWith(pm, "models/scp/ntf_new") then
		zm = "models/scp_zombie/ntf_new.mdl"

	elseif string.StartWith(pm, "models/scp/mog_zombie_round_new") then
		zm = "models/scp_zombie/mog_no_helmet_new.mdl"
	end

return zm

end

function GetLangRole(rl)
	if clang == nil then return rl end
	local rolef = nil
	for k,v in pairs(ROLES) do
		if rl == v then
			rolef = k
		end
	end
	if rolef != nil then
		return clang.ROLES[rolef]
	else
		return rl
	end
end

util.AddNetworkString("BreachNotifyFromServer")

local mply = FindMetaTable("Player")

function mply:RXSENDNotify(message)
--print(debug.traceback())
	net.Start("BreachNotifyFromServer")
	net.WriteString(tostring(message))
	net.Send(self)
end

util.AddNetworkString("BreachWarningFromServer")

function mply:RXSENDWarning(message)
	net.Start("BreachWarningFromServer")
	net.WriteString(tostring(message))
	net.Send(self)
end

util.AddNetworkString("TipSend")

function mply:TipSendCustom(icontype, str1, col1, str2, col2, convar)
str2 = "1"
	net.Start("TipSend")
		net.WriteUInt(icontype, 3)
		net.WriteString(str1)
		net.WriteTable(col1)
		net.WriteString(str2)
		net.WriteTable(col2)
		--net.WriteString(convar)
	net.Send(self)
end

function mply:TipSendDefault(str1)
	self:TipSendCustom(1, str1, Color(255, 255, 255), "1", Color(255, 255, 255))
end

function mply:TipSendNotify(str1)
	self:TipSendCustom(1, str1, Color(255, 0, 0), "1", Color(255, 255, 255))
end

function mply:TipSendWarning(str1)
	self:TipSendCustom(1, str1, Color(255, 255, 255), "1", Color(255, 0, 0))
end

function mply:TipSendGood(str1)
	self:TipSendCustom(1, str1, Color(255, 255, 255), "1", Color(10, 245, 10))
end

util.AddNetworkString("UnderhellLocation")

function mply:LocationNotify(str)
	net.Start("UnderhellLocation")
	net.WriteString(str)
	net.Send(self)
end

function SetupMapLua()
	MapLua = ents.Create("lua_run")
	MapLua:SetName("triggerhook")
	MapLua:Spawn()

	for k, v in pairs(ents.FindByClass("func_door")) do

		if string.find(string.lower(v:GetName()), "gate") or string.find(string.lower(v:GetName()), "containment") then
			v:SetKeyValue("wait", "-1")
		elseif !string.find(string.lower(v:GetName()), "elev") then
			v:SetKeyValue("wait", "0.5")
		end

		if !string.find(string.lower(v:GetName()), "gate") and !string.find(string.lower(v:GetName()), "containment") then
			v:Fire("AddOutput", "OnOpen triggerhook:RunPassedCode:CloseDoor("..v:EntIndex()..")")
		end

	end

	for k, v in pairs(ents.FindByClass("func_button")) do

		if string.find(string.lower(v:GetName()), "gate") or string.find(string.lower(v:GetName()), "containment") then
			v:SetKeyValue("wait", "-1")
		elseif !string.find(string.lower(v:GetName()), "elev") then
			v:SetKeyValue("wait", "0.5")
		end

	end

	for k, v in ipairs(ents.FindByName("008_containment_door")) do
		v:Remove()
	end

	for k, v in ipairs(ents.FindByName("console_173")) do
		v:Remove()
	end

	for k, v in ipairs(ents.FindByClass("logic_timer")) do
		if string.find(string.lower(v:GetName()), "tesla") then
			v:SetKeyValue("RefireTime", 3)
		end
	end

	for k, v in ipairs(ents.FindByName("914_heal")) do
		v:Remove()
	end

	for k, v in ipairs(ents.FindByName("914_buff")) do
		v:Remove()
	end

	for k, v in ipairs(ents.FindByName("914_veryfine")) do
		v:Remove()
	end

	for k, v in ipairs(ents.FindByName("bt_914_4")) do
		v:SetKeyValue("spawnpos", "1")
		v:SetKeyValue("forceclosed", "true")
	end

	for k, v in ipairs(ents.FindByName("femur_button")) do
		v:Remove()
	end

end

hook.Add("InitPostEntity", "SetupMapLua", SetupMapLua)
hook.Add("PostCleanupMap", "SetupMapLua", SetupMapLua)
function CloseDoor(index)
	if string.find(string.lower(Entity(index):GetName()), "elev") then return end
	if string.find(string.lower(Entity(index):GetName()), "gate") then return end
	if string.find(string.lower(Entity(index):GetName()), "containment") then return end
	if string.find(string.lower(Entity(index):GetName()), "914") then return end
	timer.Remove("close_door_"..index)
	timer.Create("close_door_"..index, 17, 1, function()
		Entity(index):Fire('Close')
	end)
end


local function CheckIfEmpty(entid)
	if(Entity(entid).Money==0 and #Entity(entid).Weapons==0) then
		Entity(entid).IsLooted = true
		--BoxRemove(entid)
	end
end

local function IsWep(wep, weptab) 
	if(table.HasValue(weptab, wep)) then
		return true
	end
	return false
end

util.AddNetworkString("ForceAttack")

function CreateRagdollPL(victim, attacker, dmgtype)
	if victim:GetGTeam() == TEAM_SPEC then return end
	if not IsValid(victim) then return end

	victim:SetNWInt("documents", 0)

	victim:SetNWInt("fbidocuments", 0)

	if victim:GetNClass() == ROLES.ROLE_SCP8602 or victim:GetNClass() == ROLES.ROLE_SCP939 or victim:GetNClass() == ROLES.ROLE_SCP082 or victim:GetNClass() == ROLES.ROLE_SCP9992 or victim:GetNClass() == ROLES.ROLE_SCP682 or victim:GetNClass() == ROLES.ROLE_SCP096 then

    local FakePly = ents.Create( "base_gmodentity" )

    FakePly:SetModel( victim:GetModel() )

    FakePly:SetPos( victim:GetPos() )

    FakePly:SetAngles( victim:GetAngles() )

    FakePly:Spawn()

	if FakePly:GetModel() == "models/scp/scp_999_new.mdl" then

        FakePly:SetSequence( FakePly:LookupSequence( "die" ) )

	end

	if FakePly:GetModel() == "models/scp/scp_crock_v3.mdl" then

        FakePly:SetSequence( FakePly:LookupSequence( "die" ) )

	end

	if FakePly:GetModel() == "models/scp/scp_939_new.mdl" then

        FakePly:SetSequence( FakePly:LookupSequence( "die" ) )

	end

	if FakePly:GetModel() == "models/scp/scp_860_v3.mdl" then

        FakePly:SetSequence( FakePly:LookupSequence( "z_death_cock" ) )

	end

	if FakePly:GetModel() == "models/cultist_kun/scp_082.mdl" then

        FakePly:SetSequence( FakePly:LookupSequence( "death_loot" ) )

	end

	if FakePly:GetModel() == "models/cult/scp/096/scp_096.mdl" then

        FakePly:SetSequence( FakePly:LookupSequence( "cower" ) )

	end

    FakePly:SetPlaybackRate( 1 )

    FakePly.AutomaticFrameAdvance = true

	function FakePly:Think()

        self:NextThink( CurTime() )

		local kok = self:LookupSequence("z_death_cock")

		if self:GetSequence() != kok then

		    if( self:GetCycle() >= 0.99 ) then self:SetCycle(0.99) end



		end

		if self:GetSequence() == kok then

		    if( self:GetCycle() >= 0.90 ) then self:SetCycle(0.90) end



		end



        return true

    end

	end

	if victim:GetNClass() == ROLES.ROLE_SCP8602 or victim:GetNClass() == ROLES.ROLE_SCP939 or victim:GetNClass() == ROLES.ROLE_SCP082 or victim:GetNClass() == ROLES.ROLE_SCP9992 or victim:GetNClass() == ROLES.ROLE_SCP682 or victim:GetNClass() == ROLES.ROLE_SCP096 then return end

	local rag = ents.Create("prop_ragdoll")
	if not IsValid(rag) then return nil end

	rag:SetPos(victim:GetPos())
	rag:SetModel(victim:GetModel())
	rag:SetAngles(victim:GetAngles())
	rag:SetColor(victim:GetColor())

	rag:Spawn()
	rag:Activate()
	rag:SetCollisionGroup(COLLISION_GROUP_WORLD)
	--rag:CollisionRulesChanged()

	suka_rabotay_zaebal = rag:EntIndex()
	print("Ragdoll Index: "..suka_rabotay_zaebal)

	if IsValid(victim) then

		victim:Freeze(true)
		victim:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 5, 5)

		timer.Simple(4, function()
			if IsValid(victim) then
				victim:SetDSP(31)
			end
		end)

		timer.Simple(10, function()
			if IsValid(victim) then
				victim:Freeze(false)
				if !victim:Alive() then
					victim:SetHealth(100)
					victim:Spawn()
					victim:SetSpectator()
				end
					victim:SetDSP(1)
			end
		end)
	
		victim:SendLua('IsDied = true')
		victim:SetNWEntity("RagdollEntityNO", rag)

		timer.Simple(10, function()
			if IsValid(victim) then
				victim:SendLua('IsDied = false')
			end
		end)

	end

	if victim:GTeam() == TEAM_GUARD and victim:LastHitGroup() == HITGROUP_HEAD then
		rag:EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(1,3)..".wav", 75, 100, 2)
	end

	if victim:LastHitGroup() == HITGROUP_HEAD then
		print("Чётко в жбан!")
		rag:EmitSound("player/headshot11.wav", 75, 100, 0.5)
		if !CheckRDM(victim, ksaikok, attacker) then
			if attacker:IsPlayer() then
				attacker:RXSENDNotify("Убийство в голову! Получены дополнительные 2 поинта")
				attacker:AddFrags(2)
			end
		end
	end

	util.StartBleeding(rag, dmgtype:GetDamage(), 3)

	rag.Info = {}
	rag.Info.CorpseID = rag:GetCreationID()
	rag:SetNWInt( "CorpseID", rag.Info.CorpseID )
	rag.Info.Victim = victim:Nick()
	rag.Info.DamageType = dmgtype
	rag.Info.Time = CurTime()

	--print(attacker:GetActiveWeapon():GetPrimaryAmmoType())
		if dmgtype:IsBulletDamage() then
			if attacker:GetActiveWeapon():GetPrimaryAmmoType() == 3 then
				rag:SetNWBool("DiedFromPistolBullets", true)

			elseif attacker:GetActiveWeapon():GetPrimaryAmmoType() == 4 then
				rag:SetNWBool("DiedFromSMG1Bullets", true)

			elseif attacker:GetActiveWeapon():GetPrimaryAmmoType() == 1 then
				rag:SetNWBool("DiedFromAR2Bullets", true)
			end

			if victim:LastHitGroup() == HITGROUP_HEAD then
				rag:SetNWBool("DiedFromHeadshot", true)
			end
			
		elseif dmgtype:GetDamageType() == DMG_SLASH then
			rag:SetNWBool("DiedFromSlash", true)
		elseif attacker:IsPlayer() then
			if attacker:GetActiveWeapon():GetClass() == "cwc_cbar" or attacker:GetActiveWeapon():GetClass() == "class_d_zatoshka" then
				rag:SetNWBool("DiedFromSlash", true)
			end
		elseif dmgtype:GetDamageType() == DMG_CRUSH or dmgtype:GetDamageType() == DMG_FALL then
			rag:SetNWBool("DiedFromCrush", true)
		elseif dmgtype:GetDamageType() == DMG_BLAST then
			ent:SetNWBool("DiedFromBlast", true)
		elseif dmgtype:GetDamageType() == DMG_BURN then
			ent:SetNWBool("DiedFromBurn", true)
		else
			rag:SetNWBool("DiedFromUnknown", true)
		end

	if victim:GTeam() == TEAM_SCP then
		rag.IsSearchable = false
	else
		rag.IsSearchable = true
	end
	rag.Weapons = rag.Weapons or {}
	
	rag.Money = rag.Money or 0
	rag.VictimName = rag.VictimName or ""
	
	rag.VictimName = victim:Nick()
	rag.IsLooted = false
	
	rag.Weapons = {}

	ent = victim
	
--[[
	local lVel = ent:GetVelocity()
	for k,v in pairs(ent:GetBodyGroups()) do
				rag:SetBodygroup(v.id,ent:GetBodygroup(v.id))
			end
for i = 0, rag:GetPhysicsObjectCount()-1 do
				local physBoneT = rag:GetPhysicsObjectNum( i );
				if ( physBoneT:IsValid() ) then
					local lPos, lAng = ent:GetBonePosition( rag:TranslatePhysBoneToBone( i ) );
					physBoneT:SetPos( lPos );
					physBoneT:SetAngles( lAng );
					physBoneT:AddVelocity( lVel );
				end
			end
local timerCount = 1;
			if ( rag:GetPhysicsObjectCount()>0 ) then
				--print(normal)
				derganiya_times = 0
				forceAmount = 25;
				for j=0, 500, 1 do
					timer.Simple(timerCount, function ()
						if(IsValid(rag)) then
							local numBones = rag:GetPhysicsObjectCount();
							for i = 1, numBones - 1 do
								if(IsValid(rag)) then
									local bone = rag:GetBoneName( i );
									if(IsValid(rag)) then
										local physBone = rag:GetPhysicsObjectNum( i );
										if IsValid( physBone ) then
											if( string.find(bone:lower(),"pelvis") == nil && string.find(bone:lower(),"spine") == nil && string.find(bone:lower(),"forward") == nil && string.find(bone:lower(),"neck") == nil  && string.find(bone:lower(),"head") == nil && string.find(bone:lower(),"attach") == nil && string.find(bone:lower(),"anim") == nil) then
												local physBonePos, physBoneAng = rag:GetBonePosition( rag:TranslatePhysBoneToBone( i ));
												physBone:SetVelocity(Vector(math.random(-forceAmount,forceAmount),math.random(-forceAmount,forceAmount),math.random(-forceAmount,forceAmount)));
												physBone:SetVelocity(physBone:GetVelocity() + Vector(math.random(-forceAmount,forceAmount),math.random(-forceAmount,forceAmount),math.random(-forceAmount,forceAmount)));
											end
										end
									end
								end
							end
						end
					end )
					timerCount = timerCount + 0.016;
					derganiya_times = derganiya_times + 1
				end
			end
--]]

	local wep = victim:GetActiveWeapon()
	if victim:GTeam() == TEAM_SPEC then return end
	if IsValid(wep) and wep != nil and IsValid(ply) then
		local atype = wep:GetPrimaryAmmoType()
		if atype > 0 then
			wep.SavedAmmo = wep:Clip1()
		end
		
		if wep:GetClass() != nil and wep.droppable != nil then
			if wep.droppable == true then
				ply:DropWeapon( wep )
			end
		end
		
	end
	
	for i, weapon in pairs (victim:GetWeapons()) do
		if(!IsWep(weapon:GetClass(), LC.UndroppableWeapons)) then
			table.insert(rag.Weapons, weapon:GetClass())	
		end
	end

	CheckIfEmpty(rag:EntIndex())
	
	local group = COLLISION_GROUP_WORLD
	rag:SetCollisionGroup(group)
	timer.Simple( 1, function() if IsValid( rag ) then rag:CollisionRulesChanged() end end )
	--timer.Simple( 5, function() if IsValid( rag ) then rag:EnableMotion(false) end end )
	
	local num = rag:GetPhysicsObjectCount()-1
	local v = victim:GetVelocity() * 0.35
	
	for i=0, num do
		local bone = rag:GetPhysicsObjectNum(i)
		if IsValid(bone) then
		local bp, ba = victim:GetBonePosition(rag:TranslatePhysBoneToBone(i))
		if bp and ba then
			bone:SetPos(bp)
			bone:SetAngles(ba)
		end
		bone:SetVelocity(v * 1.2)
		end
	end

end

function GM:DoPlayerDeath(victim, attacker, dmgtype)
if IsValid(victim:GetActiveWeapon()) then
	if !table.HasValue(LC.UndroppableWeapons, victim:GetActiveWeapon():GetClass()) and victim:GTeam() != TEAM_SCP then
		victim:GetActiveWeapon().ActiveAttachments = {
		didasa = true
		}
		for k, v in ipairs(victim:GetActiveWeapon().ActiveAttachments) do
			v = nil
		end
		victim:DropWeapon(victim:GetActiveWeapon())
	end
end
	CreateRagdollPL(victim, attacker, dmgtype)

	local exptogive = victim:Frags() * 3
	victim:SetFrags( 0 )

	if !timer.Exists("RoundTime") then
		survive_time = 0
	else
		survive_time = (1000 - timer.TimeLeft("RoundTime")) * 0.07
	end
	local total_exp = exptogive + survive_time
	if exptogive > 0 then
		victim:AddExp( total_exp , true )
		victim:RXSENDNotify("Ваш счёт: "..(exptogive / 3))
	elseif exptogive <= 0 then
		victim:AddExp( total_exp , true )
		victim:RXSENDNotify("Ваш счёт: "..(exptogive / 3))
	end
end

function GM:PostPlayerDeath(victim, attacker, dmgtype)
	--victim:DropWeapon(GetActiveWeapon())
end

    WEPS_Primary = {

    cw_akm = true,

    cw_p90csgo = true,

		cw_cz805bren = true,

    cw_tr09_auga3 = true,

    cw_kk_ins2_cstm_famas = true,

		cw_kk_ins2_cstm_mp5a4 = true,

		cw_kk_ins2_cstm_m14 = true,

		cw_kk_ins2_aks74u = true,

    cw_kk_ins2_m14 = true,

    cw_kk_ins2_mp5k = true,

    cw_kk_ins2_cstm_mp7 = true,

    cw_kk_ins2_cstm_scar = true,

		cw_kk_ins2_cstm_ksg = true,

		cw_kk_ins2_p90 = true,

		cw_kk_ins2_cstm_spas12 = true,

		cw_kk_ins2_mk18 = true,

    cw_kk_ins2_m16a4 = true,

		cw_kk_ins2_cstm_g36c = true,

		cw_kk_ins2_m40a1 = true,

		cw_kk_ins2_akm = true,

		cw_kk_ins2_cstm_mp5a4 = true,

		cw_kk_ins2_m14 = true,

		cw_kk_ins2_m16a4 = true,

		cw_kk_ins2_toz = true,

		cw_kk_ins2_cstm_famas = true,

		cw_kk_ins2_ump45 = true,

		cw_kk_ins2_ak74 = true,

		cw_kk_ins2_m4a1 = true,

		cw_kk_ins2_fnfal = true,

		cw_kk_ins2_rpk = true,

		cw_kk_ins2_cstm_kriss = true,

		cw_kk_ins2_cstm_l85 = true,

		cw_kk_ins2_cstm_uzi = true,

		cw_kk_ins2_mini14 = true,

		cw_kk_ins2_cstm_m500 = true,

		cw_kk_ins2_l1a1 = true,

		cw_kk_ins2_m1a1_para = true,

		cw_kk_ins2_sterling = true,

		cw_kk_ins2_mosin = true,

		cw_kk_ins2_sks = true,

		cw_kk_ins2_aks74u = true,

		cw_kk_ins2_m249 = true

    }



    WEPS_Secondary = {

    cw_kk_ins2_cstm_colt = true,

		cw_kk_ins2_cstm_cobra = true,

    cw_kk_ins2_arse_usp = true,

		cw_kk_ins2_arse_g17 = true,

		cw_kk_ins2_arse_g18 = true,

		cw_kk_ins2_ao5_revolver = true,

		cw_kk_ins2_p2a1 = true,

		cw_kk_ins2_m9 = true,

		cw_kk_ins2_m1911 = true,

		cw_kk_ins2_m45 = true,

    cw_kk_ins2_makarov = true

    }

function GM:PlayerCanPickupWeapon(ply, wep)
ply.OnTheGround = true

    if #ply:GetWeapons() >= 8 then
        return false

    elseif ply.JustSpawned == true or ply.IsLooting == true then
        return true

    elseif ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then
        return false
    
    elseif ply:GTeam() == TEAM_SCP and ply.JustSpawned then
        return true

    elseif ply:HasWeapon(wep:GetClass()) then
        return false

    elseif #ply:GetWeapons() < 8 and ply:KeyReleased(IN_USE) and ply:GetEyeTrace().Entity == wep then

            local wepClass = wep:GetClass()
    
            local plyWeps = ply:GetWeapons()
    
            local isPrimary, isSecondary = WEPS_Primary[wepClass], WEPS_Secondary[wepClass]

            for k,v in ipairs(ply:GetWeapons()) do
            --print("sadida")
                local vClass = v:GetClass()
                
                local plyHasPrimary, plyHasSecondary = WEPS_Primary[vClass], WEPS_Secondary[vClass]
    
                if isPrimary and plyHasPrimary then
                    return false
    
                elseif isSecondary and plyHasSecondary then
                    return false
                end
    
            end
            ply:EmitSound("pickitem2.ogg")
            wep:SetPos(ply:EyePos())
            return true
    else
        return false
    end
    
end

function GM:PlayerSpray(ply)
	if ply:GTeam() == TEAM_SPEC then
		return true
	end
	if ply:GetPos():WithinAABox( POCKETD_MINS, POCKETD_MAXS ) then
		ply:RXSENDNotify("Я вам запрещаю ставить тут спрей" )
		return true
	end
end

function GetActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.ActivePlayer == nil then v.ActivePlayer = true v:SetNActive( true ) end
		if v.ActivePlayer == true then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GetNotActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.ActivePlayer == nil then v.ActivePlayer = true v:SetNActive( true ) end
		if v.ActivePlayer == false then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GM:ShutDown()
	for k,v in pairs(player.GetAll()) do
		v:SaveKarma()
	end
end

function WakeEntity(ent)
	local phys = ent:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:Wake()
		phys:SetVelocity(Vector(0,0,25))
	end
end

function PlayerNTFSound(sound, ply)
	if (ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) and ply:Alive() then
		if ply.lastsound == nil then ply.lastsound = 0 end
		if ply.lastsound > CurTime() then
			ply:RXSENDNotify( "Вам нужно подождать " .. math.Round(ply.lastsound - CurTime()) .. " сек., чтобы сделать это.")
			return
		end
		//ply:EmitSound( "Beep.ogg", 500, 100, 1 )
		ply.lastsound = CurTime() + 3
		//timer.Create("SoundDelay"..ply:SteamID64() .. "s", 1, 1, function()
			ply:EmitSound( sound, 450, 100, 1 )
		//end)
	end
end

function OnUseEyedrops(ply)
	if ply.usedeyedrops == true then
		ply:RXSENDNotify( "Не используйте их так быстро!")
		return
	end
	ply.usedeyedrops = true
	ply:StripWeapon("item_eyedrops")
	ply:RXSENDNotify( "Вы использовали глазные капли, моргание остановлено на 10 секунд")
	timer.Create("Unuseeyedrops" .. ply:SteamID64(), 10, 1, function()
		ply.usedeyedrops = false
		ply:RXSENDNotify( "Вы снова моргаете")
	end)
end

/*timer.Create( "CheckStart", 10, 0, function() 
	if !gamestarted then
		CheckStart()
	end
end )*/
--[[
timer.Create("BlinkTimer", GetConVar("br_time_blinkdelay"):GetInt(), 0, function()
	local time = GetConVar("br_time_blink"):GetFloat()
	if time >= 5 then return end
	for k,v in pairs(player.GetAll()) do
		if v.canblink and v.blinkedby173 == false and v.usedeyedrops == false then
			--net.Start("PlayerBlink")
				--net.WriteFloat(time)
			--net.Send(v)
			v.isblinking = true
		end
	end
	timer.Create("UnBlinkTimer", time + 0.2, 1, function()
		for k,v in pairs(player.GetAll()) do
			if v.blinkedby173 == false then
				v.isblinking = false
			end
		end
	end)
end)
--]]
util.AddNetworkString("Effect")
timer.Create("EffectTimer", 0.3, 0, function()
	for k, v in pairs( player.GetAll() ) do
		if v.mblur == nil then v.mblur = false end
		net.Start("Effect")
			net.WriteBool( v.mblur )
		net.Send(v)
	end
end )

nextgateaopen = 60
function RequestOpenGateA(ply)
	if preparing or postround then return end
	if ply:CLevelGlobal() < 4 then return end
	if !(ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) then return end
	if nextgateaopen > CurTime() then
		ply:RXSENDNotify( "Вы не можете открыть ворота А сейчас, вам нужно подождать " .. math.Round(nextgateaopen - CurTime()) .. " сек.")
		return
	end
	local gatea
	local rdc
	for id,ent in pairs(ents.FindByClass("func_rot_button")) do
		for k,v in pairs(MAPBUTTONS) do
			if v["pos"] == ent:GetPos() then
				if v["name"] == "Remote Door Control" then
					rdc = ent
					rdc:Use(ply, ply, USE_ON, 1)
				end
			end
		end
	end
	for id,ent in pairs(ents.FindByClass("func_button")) do
		for k,v in pairs(MAPBUTTONS) do
			if v["pos"] == ent:GetPos() then
				if v["name"] == "Gate A" then
					gatea = ent
				end
			end
		end
	end
	if IsValid(gatea) then
		nextgateaopen = CurTime() + 20
		timer.Simple(2, function()
			if IsValid(gatea) then
				gatea:Use(ply, ply, USE_ON, 1)
			end
		end)
	end
end

local lastpocketd = 0
function GetPocketPos()
	if lastpocketd > #POS_POCKETD then
		lastpocketd = 0
	end
	lastpocketd = lastpocketd + 1
	return POS_POCKETD[lastpocketd]
end

function Kanade()
	for k,v in pairs(player.GetAll()) do
		if v:SteamID64() == "76561198156389563" then
			return v
		end
	end
end

function UseAll()
	for k, v in pairs( FORCE_USE ) do
		local enttab = ents.FindInSphere( v, 3 )
		for _, ent in pairs( enttab ) do
			if ent:GetPos() == v then
				ent:Fire( "Use" )
				break
			end
		end
	end
end

function DestroyAll()
	for k, v in pairs( FORCE_DESTROY ) do
		if isvector( v ) then
			local enttab = ents.FindInSphere( v, 1 )
			for _, ent in pairs( enttab ) do
				if ent:GetPos() == v then
					ent:Remove()
					break
				end
			end
		elseif isnumber( v ) then
			local ent = ents.GetByIndex( v )
			if IsValid( ent ) then
				ent:Remove()
			end
		end
	end
end

--Удаление лагучего и бесполезного хука

function GM:PostGamemodeLoaded()
	hook.Remove("PlayerTick", "TickWidgets")
end

local random = 0
function SpawnAllItems()
print("Round has started, spawning loot")
round_total_entities = 0

--Спавны ЛЗ
print("Spawning LZ loot")
for k, v in ipairs(NEW_SPAWN_LZ) do
	if SpawnSuccess(35) then
		ent_class = nil
		ent_class = RandomLoot_LZ()

		if ent_class != nil then
			local ent = ents.Create(ent_class)
			ent:Spawn()
			ent:SetPos(v)
			round_total_entities = round_total_entities + 1
		end
	end
end

--Спавны в подвале
print("Spawning basement loot")
for k, v in ipairs(NEW_SPAWN_BASEMENT) do
	if SpawnSuccess(70) then
		ent_class = nil
		ent_class = RandomLoot_Basement()

		if ent_class != nil then
			local ent = ents.Create(ent_class)
			ent:Spawn()
			ent:SetPos(v)
			round_total_entities = round_total_entities + 1
		end
	end
end

--Спавны ТЗ
print("Spawning HZ loot")
for k, v in ipairs(NEW_SPAWN_HZ) do
	if SpawnSuccess(45) then
		ent_class = nil
		ent_class = RandomLoot_HZ()

		if ent_class != nil then
			local ent = ents.Create(ent_class)
			ent:Spawn()
			ent:SetPos(v)
			round_total_entities = round_total_entities + 1
		end
	end
end

--Спавны ОЗ
print("Spawning EZ loot")
for k, v in ipairs(NEW_SPAWN_EZ) do
	if SpawnSuccess(15) then
		ent_class = nil
		ent_class = RandomLoot_EZ()

		if ent_class != nil then
			local ent = ents.Create(ent_class)
			ent:Spawn()
			ent:SetPos(v)
			round_total_entities = round_total_entities + 1
		end
	end
end

--Спавны оружейной МОГ
print("Spawning EZ Armory weapons")
	for k,v in pairs(SPAWN_MTFARMORY) do
		armory_loot = {		
			"cw_kk_ins2_cstm_m500",
			"cw_kk_ins2_cstm_spas12",
			"cw_kk_ins2_toz",
			"cw_kk_ins2_m14",
			"cw_kk_ins2_l1a1",
			"cw_kk_ins2_fnfal",
			"cw_kk_ins2_makarov",
			"cw_kk_ins2_revolver",
			"cw_kk_ins2_ak74",
			"cw_kk_ins2_aks74u",
			"cw_kk_ins2_mini14",
			"cw_kk_ins2_cstm_uzi",
			"cw_kk_ins2_m4a1",
			"cw_kk_ins2_m16a4",
		}
		local wep = ents.Create(armory_loot[ math.random(1, #armory_loot ) ])
		--if IsValid( wep ) then
			--wep:recalculateDamage()
			wep:Spawn()
			wep:SetPos(v)
			--WakeEntity(wep)
			round_total_entities = round_total_entities + 1
		--end
	end

print("Spawning EZ Armory ammo")
	for k,v in pairs(SPAWN_MTFAMMO) do
		ammo_loot = {
			"item_rifleammo",
			"item_smgammo",
			"item_pistolammo",
		}
		local wep = ents.Create(ammo_loot[ math.random(1, #ammo_loot ) ])
		--if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos(v)
			--WakeEntity(wep)
			round_total_entities = round_total_entities + 1
		--end
	end

--Спавны оружейной Класса-Д
print("Spawning LZ Armory weapons")
	for k,v in pairs(SPAWN_DARMORY) do
		--[[
		armory_loot = {		
			"cw_kk_ins2_cstm_m500",
			"cw_kk_ins2_cstm_spas12",
			"cw_kk_ins2_toz",
			"cw_kk_ins2_m14",
			"cw_kk_ins2_l1a1",
			"cw_kk_ins2_fnfal",
			"cw_kk_ins2_makarov",
			"cw_kk_ins2_revolver",
			"cw_kk_ins2_ak74",
			"cw_kk_ins2_aks74u",
			"cw_kk_ins2_mini14",
			"cw_kk_ins2_cstm_uzi",
			"cw_kk_ins2_m4a1",
			"cw_kk_ins2_m16a4",
		}
		--]]
		local wep = ents.Create(armory_loot[ math.random(1, #armory_loot ) ])
		--if IsValid( wep ) then
			--wep:recalculateDamage()
			wep:Spawn()
			wep:SetPos(v)
			--WakeEntity(wep)
			round_total_entities = round_total_entities + 1
		--end
	end

print("Spawning LZ Armory ammo")
	for k,v in pairs(SPAWN_DAMMO) do
		ammo_loot = {
			"item_rifleammo",
			"item_smgammo",
			"item_pistolammo",
		}
		local wep = ents.Create(ammo_loot[ math.random(1, #ammo_loot ) ])
		--if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos(v)
			--WakeEntity(wep)
			round_total_entities = round_total_entities + 1
		--end
	end

--Спавны в камерах Класса-Д
print("Spawning items in Class-D cages")
local d_cages_items_total = 0

	for k,v in pairs(SPAWN_RANDOMDCLASSCAGES) do
		class_d_cages_loot = {
			"wep_jack_job_drpradio",
			"weapon_flashlight",
			"item_snav_300",
			"weapon_pepperspray",
			"weapon_pass_medic",
			"weapon_pass_guard",
			"weapon_pass_sci",
			"cwc_cbar",
		}
		local wep = ents.Create(class_d_cages_loot[ math.random(1, #class_d_cages_loot ) ])
		if d_cages_items_total <= 3 then
			wep:Spawn()
			wep:SetPos(v)
			--WakeEntity(wep)
			d_cages_items_total = d_cages_items_total + 1
			round_total_entities = round_total_entities + 1
		end
	end

--SCP-714
print("Spawning non-playable SCPs")
local scp_714 = ents.Create("item_scp_714")
	scp_714:Spawn()
	scp_714:SetPos(Vector(2403, 880, 42))
	--WakeEntity(scp_714)
	round_total_entities = round_total_entities + 1

local scp_1162 = ents.Create("scp_1162")
scp_1162:Spawn()

--Лови аптечку
print("Spawning EZ Medbay medkits")
	for k,v in pairs(SPAWN_MEDKITS) do
		local items = {
			"medicmedkit",
			"medicmedkitfirst",
		}
		local item = ents.Create(table.Random(items))
		--if IsValid( item ) then
			random = math.random(0, 100)
			if random > 40 then
			item:Spawn()
			item:SetPos(v)
			round_total_entities = round_total_entities + 1
			end
		--end
	end

--Броня ГОК для ШГОК
print("Spawning GOC armor")
local goc_armor_total = 0

	for k,v in pairs(SPAWN_GOCARMOR) do
		local item = ents.Create( "armor_goc" )
		if goc_armor_total <= 3 then
			item:Spawn()
			item:SetPos(v)
			goc_armor_total = goc_armor_total + 1
			round_total_entities = round_total_entities + 1
		end
	end

print("Loot spawn successful, total items: "..round_total_entities)
end

function SpawnNTFS()
if postround then return end
	if disableNTF then return end
	if is_spawned_support_dz and is_spawned_support_onp and is_spawned_support_ntf then return end
	if is_spawned_support_goc == true and is_spawned_support_dz == true and is_spawned_support_onp == true and is_spawned_support_chaos == true and is_spawned_support_ntf == true then print("Каждая фракция поддержки уже появлялась в этом раунде, не даём появляться ещё одной(избежание stack overflow)") return end
	if total_supports == 2 then print("2 поддержки уже появлялись в этом раунде, не спавним ещё одну(баг с таймерами, хз как фиксить)") return end
	local usablesupport = {}
	local activeplayers = {}

	for k,v in pairs(gteams.GetPlayers(TEAM_SPEC)) do
		if v.ActivePlayer == true then
			table.ForceInsert(activeplayers, v)
		end
	end

	for k,v in pairs(ALLCLASSES["support"]["roles"]) do
		table.ForceInsert(usablesupport, {
			role = v,
			list = {}
		})
	end

	for _,rl in pairs(usablesupport) do
		for k,v in pairs(activeplayers) do
			if rl.role.level <= v:GetLevel() then
				table.ForceInsert(rl.list, v)
			end
		end
	end
	--PrintTable(usablesupport)
	for _,rl in pairs(usablesupport) do
		for i = #rl.list, 2, -1 do
			local j = math.random(i)
			rl.list[i], rl.list[j] = rl.list[j], rl.list[i]
		end
	end
	--PrintTable(usablesupport)
	--ЗНАЧЕНИЯ
	total_supports = total_supports + 1
	local support_spawn_ntf = math.random(1,2)
	local what_support_to_use = math.random(1,5)
	local spawn_goc_first_chance = math.random(0, 100)
	ntf_spawn = math.random(1,2)
	--[[
	if usechaos <= GetConVar("br_ci_percentage"):GetInt() then
		usechaos = true
	else
		usechaos = false
	end
	--]]
	--РАНДОМ СПАВНА НТФ У ВОРОТ Б ИЛИ А
	if support_spawn_ntf == 1 then
		support_spawn_ntf = SPAWN_OUTSIDE1
	else
		support_spawn_ntf = SPAWN_OUTSIDE1
	end

	--СПАВН ГОК/ДЗ/ОНП
	support_spawn = SPAWN_OUTSIDE1

	if spawn_goc_first_chance > 70 then
		spawn_goc_first = true
	end

	if spawn_goc_first then

	if is_spawned_support_goc then
		what_support_to_use = math.random(1, 5)
		spawn_goc_first = false
		print("ГОК уже спавнились в этом раунде, пропускаем...")
		goto support_skip
	end

	if is_spawned_support_dz or is_spawned_support_ntf or is_spawned_support_onp or is_spawned_support_chaos then
		what_support_to_use = math.random(1, 5)
		print("ГОК должны быть первой поддержкой, пропускаем...")
		spawn_goc_first = false
		goto support_skip
	end

	is_spawned_support_goc = true

		local used = 0
		BroadcastLua('surface.PlaySound("non_ntf.mp3")')
		for _,rl in pairs(usablesupport) do
			if rl.role.team == TEAM_GOC then
				for k,v in pairs(rl.list) do
					if used > 9 then return end

					used = used + 1
					v:SetupNormal()
					v:ApplyRoleStats(rl.role)
					v:SetPos(support_spawn_ntf[used])
					print("[RXSEND] Assigning " .. v:Nick() .. " to GOCs, role: "..v:GetNClass())
					v:SendLua('LocalPlayer():ConCommand("stopsound")')
					timer.Simple(0.1, function()
						v:SendLua('surface.PlaySound("goc_theme.wav")')
					end)
					v:SendLua('LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 3, 1)')
					v:GodEnable()
					timer.Simple(15, function()
						v:GodDisable()
					end)
				end
			end
		end
		return
	end
	::support_skip::

	if what_support_to_use == 1 then
	if is_spawned_support_chaos == true then
		what_support_to_use = math.random(2,5)
		print("ПХ уже спавнились в этом раунде, пропускаем...")
		goto support_skip
	end

	is_spawned_support_chaos = true

		local chaosnum = 0
		BroadcastLua('surface.PlaySound("announc_ntf_gay_shit.ogg")')
		
		for k, v in ipairs(player.GetAll()) do
			v:TipSendNotify("МОГ-Эпсилон 11 прибыл в комплекс!")
		end

		for _,rl in pairs(usablesupport) do
			if rl.role.team == TEAM_CHAOS then
				chaosnum = chaosnum + #rl.list
			end
		end
		if chaosnum > 1 then
			local cinum = 0
			for _,rl in pairs(usablesupport) do
				if rl.role.team == TEAM_CHAOS then
					chaos_destroyer = rl.list[math.random(1, #rl.list)]
					for k,v in pairs(rl.list) do
						if cinum > 9 then return end

						cinum = cinum + 1
						if v != chaos_destroyer then
							v:SetupNormal()
							v:ApplyRoleStats(ALLCLASSES["support"]["roles"][2])
							v:SetPos(support_spawn_ntf[cinum])
							print("[RXSEND] Assigning " .. v:Nick() .. " to CIs, role: "..v:GetNClass())
							v:SendLua('LocalPlayer():ConCommand("stopsound")')
							timer.Simple(0.1, function()
								v:SendLua('surface.PlaySound("chaos_music.mp3")')
							end)
							v:SendLua('LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 3, 1)')
							v:GodEnable()
							timer.Simple(15, function()
								v:GodDisable()
							end)
							
						elseif v == chaos_destroyer then
							v:SetupNormal()
							v:ApplyRoleStats(ALLCLASSES["support"]["roles"][3])
							v:SetPos(support_spawn_ntf[cinum])
							print("[RXSEND] Assigning " .. v:Nick() .. " to CIs, role: "..v:GetNClass())
							v:SendLua('LocalPlayer():ConCommand("stopsound")')
							timer.Simple(0.1, function()
								v:SendLua('surface.PlaySound("chaos_music.mp3")')
							end)
							v:SendLua('LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 3, 1)')
							v:GodEnable()
							timer.Simple(15, function()
								v:GodDisable()
							end)
						end
					end
				end
			end
			return
		end

	::chaos_skip::

	elseif what_support_to_use == 2 or what_support_to_use == 4 then
	if is_spawned_support_ntf == true then
		what_support_to_use = math.random(3,5)
		print("НТФ уже спавнились в этом раунде, пропускаем...")
		goto support_skip
	end

	is_spawned_support_ntf = true

		local used = 0
		BroadcastLua('surface.PlaySound("announc_ntf_gay_shit.ogg")')

		for k, v in ipairs(player.GetAll()) do
			v:TipSendNotify("МОГ-Эпсилон 11 прибыл в комплекс!")
		end

		for _,rl in pairs(usablesupport) do
			if rl.role.team == TEAM_GUARD then
				for k,v in pairs(rl.list) do
					if used > 9 then return end

					used = used + 1	
					v:SetupNormal()
					v:ApplyRoleStats(rl.role)
					v:SetPos(support_spawn_ntf[used])
					print("[RXSEND] Assigning " .. v:Nick() .. " to NTFs, role: "..v:GetNClass())
					v:SendLua('LocalPlayer():ConCommand("stopsound")')
					timer.Simple(0.1, function()
						v:SendLua('surface.PlaySound("ntfspawntheme2.wav")')
					end)
					v:SendLua('LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 3, 1)')
					v:GodEnable()
					timer.Simple(15, function()
						v:GodDisable()
					end)
				end
			end
		end

	::ntf_skip::

	elseif what_support_to_use == 3 then
	if is_spawned_support_onp == true then
		what_support_to_use = math.random(4,5)
		print("ОНП уже спавнились в этом раунде, пропускаем...")
		goto support_skip
	end

	is_spawned_support_onp = true

	print("Спавним документы для ОНП")
	for k,v in pairs(SPAWN_FBIDOCUMENT) do
		fbi_docs = {
			"item_fbidoc"
		}
		local wep = ents.Create(fbi_docs[ math.random(1, #fbi_docs ) ])
			random = math.random(0, 100)
			if random > 30 then
				wep:Spawn()
				wep:SetPos(v)
			end
	end

		local used = 0
		BroadcastLua('surface.PlaySound("onpzahod.mp3")')
		for _,rl in pairs(usablesupport) do
			if rl.role.team == TEAM_USA then
				for k,v in pairs(rl.list) do
					if used > 9 then return end

					used = used + 1
					v:SetupNormal()
					v:ApplyRoleStats(rl.role)
					v:SetPos(support_spawn_ntf[used])
					print("[RXSEND] Assigning " .. v:Nick() .. " to UIUs, role: "..v:GetNClass())
					v:SendLua('LocalPlayer():ConCommand("stopsound")')
					timer.Simple(0.1, function()
						v:SendLua('surface.PlaySound("fbi_music.mp3")')
					end)
					v:SendLua('LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 3, 1)')
										v:GodEnable()
					timer.Simple(15, function()
						v:GodDisable()
					end)
				end
			end
		end

	::onp_skip::

	--::goc_skip::

	elseif what_support_to_use == 5 then
	if is_spawned_support_dz == true then
		what_support_to_use = math.random(1,4)
		print("ДЗ уже спавнились в этом раунде, пропускаем...")
		goto support_skip
	end

	is_spawned_support_dz = true
	
		local used = 0
		BroadcastLua('surface.PlaySound("non_ntf.mp3")')
		for _,rl in pairs(usablesupport) do
			if rl.role.team == TEAM_DZ then
				for k,v in pairs(rl.list) do
					if used > 9 then return end

					used = used + 1
					v:SetupNormal()
					v:ApplyRoleStats(rl.role)
					v:SetPos(support_spawn_ntf[used])
					print("[RXSEND] Assigning " .. v:Nick() .. " to SHs, role: "..v:GetNClass())
					v:SendLua('LocalPlayer():ConCommand("stopsound")')
					timer.Simple(0.1, function()
						v:SendLua('surface.PlaySound("dz_music.mp3")')
					end)
					v:SendLua('LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 3, 1)')
										v:GodEnable()
					timer.Simple(15, function()
						v:GodDisable()
					end)
				end
			end
		end
	end

end

function ForceUse(ent, on, int)
	for k,v in pairs(player.GetAll()) do
		if v:Alive() then
			ent:Use(v,v,on, int)
		end
	end
end

function OpenGateA()
	for k, v in pairs( ents.FindByClass( "func_rot_button" ) ) do
		if v:GetPos() == POS_GATEABUTTON then
			ForceUse(v, 1, 1)
		end
	end
end


buttonstatus = 0
lasttime914b = 0
function Use914B(activator, ent)
	if CurTime() < lasttime914b then return end
	lasttime914b = CurTime() + 0.1
	ForceUse(ent, 1, 1)
	if buttonstatus == 0 then
		buttonstatus = 1
		activator:RXSENDNotify('Изменено на "Грубо"')
	elseif buttonstatus == 1 then
		buttonstatus = 2
		activator:RXSENDNotify('Изменено на "1:1"')
	elseif buttonstatus == 2 then
		buttonstatus = 3
		activator:RXSENDNotify('Изменено на "Тонко"')
	elseif buttonstatus == 3 then
		buttonstatus = 4
		activator:RXSENDNotify('Изменено на "Очень тонко"')
	elseif buttonstatus == 4 then
		buttonstatus = 0
		activator:RXSENDNotify('Изменено на "Очень грубо"')
	end
	net.Start("Update914B")
		net.WriteInt(buttonstatus, 6)
	net.Broadcast()
end

lasttime914 = 0
function Use914(ent)
	if CurTime() < lasttime914 then return end
	lasttime914 = CurTime() + 20
	ForceUse(ent, 0, 1)
	local pos = ENTER914
	local pos2 = EXIR914
	timer.Create("914Use", 4, 1, function()
		for k,v in pairs(ents.FindInSphere( pos, 80 )) do
			if v.betterone != nil or v.GetBetterOne != nil then
				local useb
				if v.betterone then useb = v.betterone end
				if v.GetBetterOne then useb = v:GetBetterOne() end
				local betteritem = ents.Create( useb )
				if IsValid( betteritem ) then
					betteritem:SetPos( pos2 )
					betteritem:Spawn()
					WakeEntity(betteritem)
					v:Remove()
				end
			end
		end
	end)
	//for k,v in pairs( ents.FindByClass( "func_button" ) ) do
	//	if v:GetPos() == Vector(1567.000000, -832.000000, 46.000000) then
			//print("Found ent!")
			//ForceUse(v, 0, 1)
			//return
	//	end
	//end
end

function OpenSCPDoors()
	// hook needed
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		for k0, v0 in pairs( POS_DOOR ) do
			if ( v:GetPos() == v0 ) then
				ForceUse(v, 1, 1)
			end
		end
	end
	for k, v in pairs( ents.FindByClass( "func_button" ) ) do
		for k0, v0 in pairs( POS_BUTTON ) do
			if ( v:GetPos() == v0 ) then
				ForceUse(v, 1, 1)
			end
		end
	end
	for k, v in pairs( ents.FindByClass( "func_rot_button" ) ) do
		for k0, v0 in pairs( POS_ROT_BUTTON ) do
			if ( v:GetPos() == v0 ) then
				ForceUse(v, 1, 1)
			end
		end
	end
end

function GetAlivePlayers()
	local plys = {}
	for k,v in pairs(player.GetAll()) do
		if v:GTeam() != TEAM_SPEC then
			if v:Alive() or v:GetNClass() == ROLES.ROLE_SCP076 then
				table.ForceInsert(plys, v)
			end
		end
	end
	return plys
end

function GM:GetFallDamage( ply, speed )
	return ( speed / 6 )
end

function PlayerCount()
	return #player.GetAll()
end

function CheckPLAYER_SETUP()
	local si = 1
	for i=3, #PLAYER_SETUP do
		local v = PLAYER_SETUP[si]
		local num = v[1] + v[2] + v[3] + v[4]
		if i != num then
			print(tostring(si) .. " is not good: " .. tostring(num) .. "/" .. tostring(i))
		else
			print(tostring(si) .. " is good: " .. tostring(num) .. "/" .. tostring(i))
		end
		si = si + 1
	end
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
end

function GetPlayer(nick)
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == nick then
			return v
		end
	end
	return nil
end

inUse = false
function explodeGateA( ply )
	if !isInTable( ply, ents.FindInSphere(POS_EXPLODE_A, 250) ) then return end
	if inUse == true then return end
	if isGateAOpen() then return end
	inUse = true
	
	local filter = RecipientFilter()
	filter:AddAllPlayers()
	local sound = CreateSound( game.GetWorld(), "ambient/alarms/alarm_citizen_loop1.wav", filter )
	sound:SetSoundLevel( 0 )
	
	BroadcastLua( 'surface.PlaySound("radio/franklin1.ogg")' )
	sound:Play()
	sound:ChangeVolume( 0.25 )
	local waitTime = GetConVar( "br_time_explode" ):GetInt()
	local ttime = 0
	for k, v in ipairs(player.GetAll()) do
		v:RXSENDNotify("Время до детонации Ворот А: "..waitTime.."s")
	end
	timer.Create( "GateExplode", 1, waitTime, function()
		if ttime > waitTime then return end
		if isGateAOpen() then 
			timer.Destroy( "GateExplode" )
			sound:Stop()
			for k, v in ipairs(player.GetAll()) do
				v:RXSENDNotify("Детонация прервана")
			end
			inUse = false
			return
		end
		
		ttime = ttime + 1
		if ttime % 5 == 0 then
			for k, v in ipairs(player.GetAll()) do
				v:RXSENDNotify("Время до детонации Ворот А: "..waitTime - ttime.."s" )
			end
		end
		if ttime + 1 == waitTime then sound:Stop() end
		if ttime == waitTime then
			BroadcastLua( 'surface.PlaySound("ambient/explosions/exp2.wav")' )
			local explosion = ents.Create( "env_explosion" ) // Creating our explosion
			explosion:SetKeyValue( "spawnflags", 210 ) //Setting the key values of the explosion 
			explosion:SetPos(POS_MIDDLE_GATE_A)
			explosion:Spawn()
			explosion:Fire( "explode", "", 0 )
			destroyGate()
			takeDamage( explosion, ply )
			ply:AddExp(100, true)
		end
	end )
	
end

function takeDamage( ent, ply )
	local dmg = 0
	for k, v in pairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 1000 ) ) do
		if v:IsPlayer() then
			if v:Alive() then
				if v:GTeam() != TEAM_SPEC then
					dmg = ( 1001 - v:GetPos():Distance( POS_MIDDLE_GATE_A ) ) * 10
					if dmg > 0 then 
						v:TakeDamage( dmg, ply, ent )
					end
				end
			end
		end
	end
end

function destroyGate()
	if isGateAOpen() then return end
	local doorsEnts = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doorsEnts ) do
		if v:GetClass() == "prop_dynamic" or v:GetClass() == "func_door" then
			v:Remove()
		end
	end
end

function isGateAOpen()
	local doors = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doors ) do
		if v:GetClass() == "prop_dynamic" then 
			if isInTable( v:GetPos(), POS_GATE_A_DOORS ) then return false end
		end
	end
	return true
end

function isInTable( element, tab )
	for k, v in pairs( tab ) do
		if v == element then return true end
	end
	return false
end

function DARK()
    engine.LightStyle( 0, "a" )
    BroadcastLua('render.RedownloadAllLightmaps(true, true)')
    BroadcastLua('RunConsoleCommand("mat_specular", 0)')
end