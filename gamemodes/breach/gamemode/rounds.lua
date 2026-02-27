ROUNDS = {
	normal = {
		name = "Нарушение Условий Содержания",
		setup = function()
			MAPBUTTONS = table.Copy(BUTTONS)
			SetupPlayers( GetRoleTable( #GetActivePlayers() ) )
			disableNTF = false
			disableEvac = false
		end,
		init = function()
			SpawnAllItems()

			timer.Create( "SupportEnterTime1", math.random(300, 360), 0, function() -- 5 to 6
				SpawnNTFS()
			end )

			--timer.Create( "SupportEnterTime2", math.random(420, 480), 0, function() --7 to 8
				--SpawnNTFS()
			--end )

			timer.Create( "SupportEnterTime3", math.random(540, 600), 0, function() --9 to 10
				SpawnNTFS()
			end )

			--[[
			timer.Simple(420, function()
				SpawnNTFS()
			end)
			
			timer.Simple(540, function()
				SpawnNTFS()
			end)
			
			timer.Simple(660, function()
				SpawnNTFS()
			end)
			--]]
			--[[
			timer.Create("MTFDebug", 2, 1, function()
				local fent = ents.FindInSphere(MTF_DEBUG, 750)
				for k, v in pairs( player.GetAll() ) do
					if v:GTeam() == TEAM_GUARD or v:GetNClass() == ROLE_CHAOSSPY then
						local found = false
						for k0, v0 in pairs(fent) do
							if v == v0 then
								found = true
								break
							end
						end
						if !found then
							v:SetPos(MTF_DEBUG)
						end
					end
				end
			end )
			--]]
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end
			endround = false
			local ds = gteams.NumPlayers(TEAM_CLASSD)
			local mtfs = gteams.NumPlayers(TEAM_GUARD)
			local res = gteams.NumPlayers(TEAM_SCI)
			local scps = gteams.NumPlayers(TEAM_SCP)
			local dzs = gteams.NumPlayers(TEAM_DZ)
			local chaos = gteams.NumPlayers(TEAM_CHAOS)
			local all = #GetAlivePlayers()
			why = "idk man"
			if (scps + dzs) == all then
				endround = true
				why = "there are only scps/sh"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_DZ and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, отсюда вас вытащит Длань Змея.")
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive)

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:SetFrags(0)
					end
				end
			elseif mtfs == all then
				endround = true
				why = "there are only mtfs"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_MTF and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас без проблем эвакуирует фонд через некоторое время.")
						local exptogive = v:Frags() * 10
						v:AddExp(40 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif res == all then
				endround = true
				why = "there are only researchers"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_SCI and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас без проблем эвакуирует фонд через некоторое время.")
						local exptogive = v:Frags() * 10
						v:AddExp(40 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif ds == all then
				endround = true
				why = "there are only class ds"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_CLASSD and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас спасут Повстанцы Хаоса.")
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif chaos == all then
				endround = true
				why = "there are only chaos insurgency members"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_CHAOS and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас спасут Повстанцы Хаоса.")
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif (mtfs + res) == all then
				endround = true
				why = "there are only mtfs and researchers"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_MTF or v:GTeam() == TEAM_SCI and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас без проблем эвакуирует фонд через некоторое время.")
						local exptogive = v:Frags() * 10
						v:AddExp(40 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif (chaos + ds) == all then
				endround = true
				why = "there are only chaos insurgency members and class ds"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_CHAOS and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас спасут Повстанцы Хаоса.")
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			end
		end,
	},
	--[[
	dm = {
		name = "Deathmatch",
		setup = function()
			MAPBUTTONS = GetTableOverride( table.Copy(BUTTONS) )
			SetupDM( #GetActivePlayers() )

			disableNTF = true
			disableEvac = true
		end,
		init = function()
			SpawnAllItems()
			--DestroyGateA()
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		cleanup = function() end,
	},
	--]]
	ttt = {
		name = "Trouble in SCP Foundation",
		setup = function()
			MAPBUTTONS = GetTableOverride( table.Copy(BUTTONS) )
			SetupTTT( #GetActivePlayers() )
			disableNTF = true
			disableEvac = true
		end,
		init = function()
			SpawnAllItems()
			--DestroyGateA()
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		cleanup = function() end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end
			local mtfs = gteams.NumPlayers(TEAM_GUARD)
			local cis = gteams.NumPlayers(TEAM_CHAOS)
			local all = #GetAlivePlayers()
			endround = false
			why = "idk"
			if cis == all then
				endround = true
				why = "there are only CIs"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_CHAOS then
						v:RXSENDNotify("Шпионы, вы просто лучшие! Теперь вашим товарищам будет намного легче захватить комплекс.")
						v:AddExp(450)
					end
				end
			elseif mtfs == all then
				endround = true
				why = "there are only MTFs"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_GUARD then
						v:RXSENDNotify("Угроза была успешно устранена! Не зря мы сидели в комплексе и охраняли его до 6 утра.")
						v:AddExp(200)
					end
				end
			end
		end,
	},
	ww2tdm = {
		name = "WW2 TDM",
		setup = function()
			MAPBUTTONS = GetTableOverride( table.Copy(BUTTONS) )
			SetupWW2TDM( #GetActivePlayers() )
			disableNTF = true
			disableEvac = true
		end,
		init = function()
			--SpawnAllItems()
			--DestroyGateA()
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		cleanup = function() end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end
			local sovets = gteams.NumPlayers(TEAM_USSR)
			local fashiks = gteams.NumPlayers(TEAM_NAZI)
			local all = #GetAlivePlayers()
			endround = false
			why = "idk"
			if sovets == all then
				endround = true
				why = "there are only sovets"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_USSR then
						v:RXSENDNotify("Мы победили, товарищи!")
						v:AddExp(200)
					end
				end
			elseif fashiks == all then
				endround = true
				why = "there are only fashiks"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_NAZI then
						v:RXSENDNotify("Sieg Heil!")
						v:AddExp(200)
					end
				end
			end
		end,
	},
/*	omega = {
		name = "Omega Problem",
		setup = function()
			MAPBUTTONS = GetTableOverride( table.Copy(BUTTONS) ) + GetTableOverride( table.Copy(BUTTONS_OMEGA) )
			SetupPlayers( GetRoleTable( #GetActivePlayers() ) )
			disableNTF = false
		end,
		init = function()
			SpawnAllItems()
			timer.Create( "NTFEnterTime", GetNTFEnterTime(), 0, function()
				SpawnNTFS()
			end )
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		cleanup = function() end,
	}, */
	--[[
	infect = {
		name = "Infect",
		setup = function()
			MAPBUTTONS = table.Copy(BUTTONS)
			SetupInfect( #GetActivePlayers() )
			disableNTF = true
			disableEvac = true
		end,
		init = function()
			SpawnAllItems()
		end,
		roundstart = function() end,
		postround = function() end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end
			local ds = gteams.NumPlayers(TEAM_CLASSD)
			local mtfs = gteams.NumPlayers(TEAM_GUARD)
			local scps = gteams.NumPlayers(TEAM_SCP)
			local all = #GetAlivePlayers()
			endround = false
			why = "idk"
			if ds == all then
				endround = true
				why = "there are only Class Ds"
			elseif mtfs == all then
				endround = true
				why = "there are only MTFs"
			elseif ds + mtfs == all then
				endround = true
				why = "there are only MTFs and Ds"
			elseif scps == all then
				endround = true
				why = "there are only SCPs"
			end		
		end,
	},
	--]]
	multi = {
		name = "MultiBreach",
		setup = function()
			MAPBUTTONS = table.Copy(BUTTONS)
			SetupPlayers( GetRoleTable( #GetActivePlayers() ) )
			disableNTF = false
			disableEvac = false
		end,
		init = function()
			SpawnAllItems()
			timer.Create( "SupportEnterTime1", math.random(300, 360), 0, function() -- 5 to 6
				SpawnNTFS()
			end )

			--timer.Create( "SupportEnterTime2", math.random(420, 480), 0, function() --7 to 8
				--SpawnNTFS()
			--end )

			timer.Create( "SupportEnterTime3", math.random(540, 600), 0, function() --9 to 10
				SpawnNTFS()
			end )
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end	
			endround = false
			local ds = gteams.NumPlayers(TEAM_CLASSD)
			local mtfs = gteams.NumPlayers(TEAM_GUARD)
			local res = gteams.NumPlayers(TEAM_SCI)
			local scps = gteams.NumPlayers(TEAM_SCP)
			local dzs = gteams.NumPlayers(TEAM_DZ)
			local chaos = gteams.NumPlayers(TEAM_CHAOS)
			local all = #GetAlivePlayers()
			why = "idk man"
			if (scps + dzs) == all then
				endround = true
				why = "there are only scps/sh"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_DZ and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, отсюда вас вытащит Длань Змея.")
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive)

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:SetFrags(0)
					end
				end
			elseif mtfs == all then
				endround = true
				why = "there are only mtfs"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_MTF and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас без проблем эвакуирует фонд через некоторое время.")
						local exptogive = v:Frags() * 10
						v:AddExp(40 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif res == all then
				endround = true
				why = "there are only researchers"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_SCI and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас без проблем эвакуирует фонд через некоторое время.")
						local exptogive = v:Frags() * 10
						v:AddExp(40 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif ds == all then
				endround = true
				why = "there are only class ds"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_CLASSD and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас спасут Повстанцы Хаоса.")
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif chaos == all then
				endround = true
				why = "there are only chaos insurgency members"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_CHAOS and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас спасут Повстанцы Хаоса.")
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif (mtfs + res) == all then
				endround = true
				why = "there are only mtfs and researchers"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_MTF or v:GTeam() == TEAM_SCI and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас без проблем эвакуирует фонд через некоторое время.")
						local exptogive = v:Frags() * 10
						v:AddExp(40 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			elseif (chaos + ds) == all then
				endround = true
				why = "there are only chaos insurgency members and class ds"
				for k, v in ipairs(player.GetAll()) do
					if v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_CHAOS and v:Alive() then
						v:RXSENDNotify("Вам больше ничего не угрожает, вас спасут Повстанцы Хаоса.")
						local exptogive = v:Frags() * 10
						v:AddExp(50 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))

						v:RXSENDNotify("Ваш счёт: "..(v:Frags()))
						v:RXSENDNotify("Документов собрано: "..v:GetNWInt("documents"))
						v:SetNWInt("fbidocuments", 0)
						v:SetNWInt("documents", 0)
						v:SetFrags(0)
					end
				end
			end
		end,
	},
}