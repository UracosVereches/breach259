--[[
addons/lua_crap/lua/entities/scp_1025.lua
--]]
AddCSLuaFile()



local BaseClass = baseclass.Get("base_anim")



ENT.PrintName = "SCP-1025"

ENT.Author = "Tsujimoto18"

ENT.Information = "A Encyclopedia of Common Diseases"

ENT.Category = "SCP"



ENT.Editable = false

ENT.Spawnable = true

ENT.AdminOnly = true



function ENT:Initialize()



	if (CLIENT) then return end



	self:SetModel("models/vinrax/scp_cb/book.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)

	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:SetSolid(SOLID_VPHYSICS)



	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then



		phys:Wake()



	end







end



function ENT:Draw()



	if (SERVER) then return end



	self:DrawModel()



end



function ENT:Use(activator, ply)

	--Only Humans are allowed to use the SCP

	if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC or preparing or postround then

		return

	end



	--Only to be ran on Serverside

	if (SERVER) then



		--Easy cleanup timer

		timer.Create("Cleanup", 0.1, 0, function()



			if preparing or postround or not ply:Alive() or ply:Team() == TEAM_SPEC or ply:Team() == TEAM_SCP then



				ply:SetNWBool("MuscularMutation", false)

				ply:SetNWBool("RegenerativeTrait", false)

				ply:SetNWBool("PinkEye", false)

				timer.Remove(ply:SteamID64().."pinkTime")



			end



		end)



		--Informing player they cannot use the book when they have black blood.

		if (ply:GetNWInt("canBeInfected", 0) == 2) then

			ply:PrintMessage(HUD_PRINTCENTER,"Вы не можете больше получать болезней")

			return

		end



		--Enabling all diseases

		local number

		if ((ply:GetNWInt("canBeInfected", 0) == 0) or (ply:GetNWInt("canBeInfectedb", 0) == 0)) then

			 ply:SetNWInt("canBeInfected", 1)

			 ply:SetNWInt("canBeInfectedb", 1)

		end



		--Creating Disease table

		local Diseases = {}



		Diseases[1] = "Аппендеците"

		Diseases[2] = "Астме"

		Diseases[3] = "Мутации крови"

		Diseases[4] = "Остановке сердца"

		Diseases[5] = "Ветрянке"

		Diseases[6] = "Простуде"

		Diseases[7] = "Квадрицептической мутация"

		Diseases[8] = "Гипер-клеточном митозе"

		Diseases[9] = "Палец"

		Diseases[10] = "Раке легких"

		Diseases[11] = "Мускульной мутации"

		Diseases[12] = "Розовом глазе"



		--Randomizing the diseases

		math.randomseed(os.time())

		number = math.random(1, 12)



		--The diseases

		ply:PrintMessage(HUD_PRINTCENTER, "Вы прочитали об " .. Diseases[number])



		if ((number == 1) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then



			if ply:Alive() then

				local newRunSpeed = ply:GetWalkSpeed()

				timer.Simple(2, function() ply:PrintMessage(4, "Боль в вашем желудке стала невыносимой!") end)

				ply:SetRunSpeed(newRunSpeed)

			end



		end



		if ((number == 2) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then



			local asthmaCounter = 0

			local asthmaCounterb = 0

			local oldRunSpeedA = ply:GetRunSpeed()

			local oldWalkSpeedA = ply:GetWalkSpeed()

			local oldCrouchSpeed = ply:GetCrouchedWalkSpeed()

			timer.Create(ply:SteamID64().."Asthma", 1, 0, function()



				--if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then

				if ply:Alive() and (ply:GTeam() ~= TEAM_SPEC) and (ply:GTeam() ~= TEAM_SCP) and not preparing and not postround then



				--	math.randomseed(os.time())

					cough = math.random(1, 100)

					if (ply:KeyDown(IN_SPEED)) then



						asthmaCounter = asthmaCounter + 1

						if asthmaCounter <= 10 then



							if cough <= 20 then



							--	math.randomseed(os.time())

								soundNum = math.random(1, 4)

								ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))



							end



						elseif ((asthmaCounter > 10) and (asthmaCounter <=20)) then



							if cough <= 80 then



								--math.randomseed(os.time())

								soundNum = math.random(1, 4)

								ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))



							end



						elseif ((asthmaCounter > 20) and (asthmaCounter < 30)) then



							if cough < 100 then



								--math.randomseed(os.time())

								soundNum = math.random(1, 4)

								ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))



							end



						else



							ply:PrintMessage(4, "Вам нужно отдышаться")

							ply:SetRunSpeed(0)

							ply:SetWalkSpeed(0)

							ply:SetCrouchedWalkSpeed(0)

							timer.Create(ply:SteamID64().."AsthmaB", 1, 0, function()



								if (not ply:Alive()) or (ply:GTeam() == TEAM_SPEC) or (ply:GTeam() == TEAM_SCP) or preparing or postround then

									timer.Remove(ply:SteamID64().."AsthmaB")

								end



								if asthmaCounterb < 15 then



									asthmaCounterb = asthmaCounterb + 1

									--math.randomseed(os.time())

									soundNum = math.random(1, 4)

									ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))



								else



									ply:SetRunSpeed(oldRunSpeedA)

									ply:SetWalkSpeed(oldWalkSpeedA)

									ply:SetCrouchedWalkSpeed(oldCrouchSpeed)

									timer.Remove(ply:SteamID64().."AsthmaB")



								end



							end)



						end



					else



						asthmaCounter = 0



					end



				else



					timer.Remove(ply:SteamID64().."Asthma")



				end



			end)



		end



		if ((number == 3) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then



			timer.Create(ply:SteamID64().."_blackblood", 1, 0, function()

				if (not ply:Alive()) or (ply:GTeam() == TEAM_SPEC) or (ply:GTeam() == TEAM_SCP) or preparing or postround then

					ply:SetNWInt("canBeInfected", 0)

					ply:SetNWInt("canBeInfectedb", 0)

					timer.Remove(ply:SteamID64().."_blackblood")

				else

					ply:SetNWInt("canBeInfected", 2)

					ply:SetNWInt("canBeInfectedb", 2)



				end

			end)



		end



		if ((number == 4) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then



			timer.Simple(5, function() ply:PrintMessage(4, "Ваше сердце бьется чаще") end)

			timer.Simple(15, function()

				if (not ply:Alive()) or (ply:GTeam() == TEAM_SPEC) or (ply:GTeam() == TEAM_SCP) or preparing or postround then

					return

				end

				if ply:Alive() then

					ply:Kill()

				end

			end)



		end



		if ((number == 5) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then



			timer.Simple(4, function() ply:PrintMessage(4, "Ваша кожа чувствует зуд") end)



		end



		if ((number == 6) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then



			timer.Create(ply:SteamID64().."Cold", 3, 0, function()



				if (not ply:Alive()) or (ply:GTeam() == TEAM_SPEC) or (ply:GTeam() == TEAM_SCP) or preparing or postround then

					timer.Remove(ply:SteamID64().."Cold")

				end



				math.randomseed(os.time())

				soundNum = math.random(1, 4)

				ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))

			end)



		end



		if ((number == 7) and (ply:GetNWInt("canBeInfected", 0) == 1) and not(ply:GetNWBool("MuscularMutation", false))) then



			--local newRunSpeed = ply:GetRunSpeed()

			--ply:SetRunSpeed(newRunSpeed + )

			ply:SetNWBool("MuscularMutation", true)



		end



		if ((number == 8) and (ply:GetNWInt("canBeInfected", 0) == 1) and not (ply:GetNWBool("RegenerativeTrait", false))) then



			ply:SetNWBool("RegenerativeTrait", true)

			timer.Create(ply:SteamID64().."regen", 10, 0, function()



				if (not ply:Alive()) or (ply:GTeam() == TEAM_SPEC) or (ply:GTeam() == TEAM_SCP) or preparing or postround then



					timer.Remove(ply:SteamID64().."regen")



				end



				ply:SetHealth(ply:GetMaxHealth())



			end)



		end



		if ((number == 9) and (ply:GetNWInt("canBeInfected", 0) == 1)) then



			timer.Simple(4, function() ply:PrintMessage(4, "Ваши пальцы образуют мясистую оболочку") end)



		end



		if ((number == 10) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then



			local cancercounter = 0

			timer.Create(ply:SteamID64().."Cancer", 3, 0, function()



				if (not ply:Alive()) or (ply:GTeam() == TEAM_SPEC) or (ply:GTeam() == TEAM_SCP) or preparing or postround then

					timer.Remove(ply:SteamID64().."Cancer")

				end



				if (cancercounter == 5) then



					ply:SetRunSpeed(ply:GetWalkSpeed())



				else



					cancercounter = cancercounter + 1



				end

				math.randomseed(os.time())

				soundNum = math.random(1, 4)

				ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))

			end)



		end



		if ((number == 11) and (ply:GetNWInt("canBeInfected", 0) == 1)) then



			ply:SetMaxHealth(300)

			ply:SetHealth(300)



		end



		if ((number == 12 and (ply:GetNWInt("canBeInfectedb", 0) == 1) and not ply:GetNWBool("PinkEye", false))) then



			ply:SetNWBool("PinkEye", true)

			timer.Create(ply:SteamID64().."pinkTime", 5, 0, function() ply:playerBlink(0.25) end)



		end



	end



end



