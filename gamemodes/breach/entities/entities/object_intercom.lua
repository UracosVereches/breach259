--[[
lua/entities/object_intercom.lua
--]]
AddCSLuaFile();



ENT.Type = "anim"

ENT.Base = "base_gmodentity"

ENT.PrintName 	= "Intercom"

ENT.Author 		= "MR.REX"

ENT.Category 	= "Nextoren"



ENT.Spawnable 	= true

ENT.AdminOnly 	= false



-------------------------------------------

---------------|PARAMS SIDE|---------------

-------------------------------------------



ENT.Lang = {["Ready"] = "ГОТОВ", ["Transmitting"] = "ПЕРЕДАЧА...", ["Cooldown"] = "ПЕРЕЗАПУСК"};

ENT.ALang = "Осталось #T сек";

ENT.MainTimer = "IntercomTMR";

ENT.SecondTimer = "IntercomKMP";



-------------------------------------------

---------------|FUNCS  SIDE|---------------

-------------------------------------------



function ENT:StartTransmitting()

	self:PlaySoundStart();

	self:SetStatus("Transmitting");

	self:SetWTFTimer(20);

	if timer.Exists(self.MainTimer) then timer.Stop(self.MainTimer); timer.Remove(self.MainTimer); end

	timer.Create(self.MainTimer, 1, 21, function()



		if self:GetWTFTimer() == 0 then print("0") self:EndTransmitting(); else self:SetWTFTimer(self:GetWTFTimer() - 1); end

	end);

	timer.Create("CheckDistationFromIntercom" ..self:GetTalker():SteamID(), 1, 20, function()



		if ( self:GetTalker():Health() <= 0 || !self:GetTalker():Alive() || self:GetTalker():GTeam() == TEAM_SPEC ) then



			self:EndTransmitting()



		end



		if self:GetPos():Distance(self:GetTalker():GetPos()) > 100 then



			if timer.Exists("CheckDistationFromIntercom" ..self:GetTalker():SteamID()) then self:EndTransmitting(); timer.Remove("CheckDistationFromIntercom" ..self:GetTalker():SteamID()); end

		end

	end)

end



function ENT:EndTransmitting()

	self:PlaySoundEnd();

	self:SetWTFTimer(0);

	self:StartCooldown();

end



function ENT:StartCooldown()

	self:SetStatus("Cooldown");

	self:SetWTFTimer(120);

	if timer.Exists(self.MainTimer) then timer.Stop(self.MainTimer); timer.Remove(self.MainTimer); end

	timer.Create(self.MainTimer, 1, self:GetWTFTimer() + 1, function()

		if self:GetWTFTimer() == 0 then self:EndCooldown(); else self:SetWTFTimer(self:GetWTFTimer() - 1); end

	end);

end



function ENT:EndCooldown()

	self:SetWTFTimer(0);

	self:SetStatus("Ready");

end



-------------------------------------------

---------------|SOUND EFFEC|---------------

-------------------------------------------



function ENT:PlaySoundStart() for k,v in pairs(player.GetAll()) do v:SendLua('surface.PlaySound("intercom/ic_start.mp3")') end end

function ENT:PlaySoundEnd() for k,v in pairs(player.GetAll()) do timer.Remove("CheckDistationFromIntercom" ..self:GetTalker():SteamID()); v:SendLua('surface.PlaySound("intercom/ic_stop.mp3")') v:SetNWBool("Allo", false)  end  end







-------------------------------------------

---------------|SERVER SIDE|---------------

-------------------------------------------



function ENT:SetupDataTables()

	self:NetworkVar("String", 0, "Status");

	self:NetworkVar("Int", 0, "WTFTimer");

	self:NetworkVar("Entity", 0, "Talker");

end



function ENT:Initialize()

	if ( SERVER ) then

		self:SetModel("models/xqm/panel180.mdl");

		self:SetColor(Color(0, 0, 0));

		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetMoveType(MOVETYPE_VPHYSICS)

		self:SetSolid(SOLID_VPHYSICS)

		self:SetUseType(SIMPLE_USE)

		local Physics = self:GetPhysicsObject();

		if Physics:IsValid() then

			Physics:Wake();

		end

	end

	--end

	self:SetStatus("Ready");

	self:SetWTFTimer(0);

	--self:SetTalker("");

end



function ENT:OnTakeDamage( dmginfo )

	return false

end

function ENT:Use(activator, caller)

	--if ( activator:IsPlayer() ) then return end

	if (activator:IsPlayer() and self:GetStatus() == "Ready" and activator:GTeam() != TEAM_SCP and activator:GTeam() != TEAM_SPEC) and gteams.NumPlayers(TEAM_USA) < 1 then

	  activator:SetNWBool("Allo", true)

	  activator:RXSENDNotify("Примечание: голос в интеркоме отключён, пишите в текстовый чат!")

		self:SetTalker(activator)

		self:StartTransmitting();

		self:EmitSound("UI/buttonclick.wav");
--[[
	elseif gteams.NumPlayers(TEAM_USA) >= 1 and activator:GTeam() == TEAM_USA then

		activator:SetNWBool("Allo", true)

		self:SetTalker(activator)

		self:StartTransmitting();

		self:EmitSound("UI/buttonclick.wav");
--]]
	elseif ( activator:IsPlayer() && self:GetStatus() == "Transmitting" && activator:GTeam() != TEAM_SCP ) then



		self:EndTransmitting()



	end



end



function ENT:OnRemove()

	if timer.Exists(self.MainTimer) then timer.Remove("CheckDistationFromIntercom" ..self:GetTalker():SteamID()); timer.Stop(self.MainTimer); timer.Remove(self.MainTimer); self:PlaySoundEnd(); end

end



-------------------------------------------

---------------|CLIENT SIDE|---------------

-------------------------------------------





local blockedbyonp = Material("overlays/fbi_openup")

function ENT:Draw()

	self:DrawModel();



	local Y = {-75, -30, -22};

	if self:GetStatus() == "Transmitting" or self:GetStatus() == "Cooldown" then Y[1], Y[2], Y[3] = -90, -45, -37; end

	local Distancetointercom = LocalPlayer():GetPos():Distance( self:GetPos() )

	if (Distancetointercom < 500) then

		cam.Start3D2D(self:LocalToWorld(Vector(6, 0, 10)), self:LocalToWorldAngles(Angle(0, 90, 90)), 0.25);

			draw.RoundedBox(0, -120, -102, 240, 140, Color(0, 0, 0, 250))

			if gteams.NumPlayers(TEAM_USA) >= 1 and self:GetStatus() == "Ready" then

				surface.SetDrawColor(255, 255, 255, 255)

				surface.SetMaterial(blockedbyonp)

				surface.DrawTexturedRect(-118, -102, 240, 140)

			elseif gteams.NumPlayers(TEAM_USA) >= 1 and self:GetStatus() == "Cooldown" then

				surface.SetDrawColor(255, 0, 0, 180)

				surface.SetMaterial(blockedbyonp)

				surface.DrawTexturedRect(-118, -102, 240, 140)

			end

			if gteams.NumPlayers(TEAM_USA) == 0 then

	    	draw.DrawText("ИНТЕРКОМ", "DermaLarge", 0, Y[1], Color(170, 255, 170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			else

				draw.DrawText("ИНТЕР???", "DermaLarge", 0, Y[1], Color(170, 255, 170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			end

			if gteams.NumPlayers(TEAM_USA) > 0 and self:GetStatus() == "Transmitting" then

				draw.DrawText("Связь восстановлена", "HudHintTextLarge", 0, 10, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			end

			surface.SetDrawColor(150, 255, 150);

			surface.DrawOutlinedRect(-75, Y[2], 150, 30);



			if ( self:GetStatus() == "Transmitting"  ) then

				surface.SetDrawColor(150, 255, 150, 100);

				surface.DrawOutlinedRect(-65, -10, 130, 20);

				draw.DrawText(string.Replace(self.ALang, "#T", tostring(self:GetWTFTimer())), "HudHintTextLarge", 0, -8, Color(200, 200, 200, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);



			elseif ( self:GetStatus() == "Cooldown" ) then



				surface.SetDrawColor(255, 80, 0, 180)

				surface.DrawOutlinedRect(-65, -10, 130, 20);

				draw.DrawText(string.Replace(self.ALang, "#T", tostring(self:GetWTFTimer())), "HudHintTextLarge", 0, -8, Color(200, 200, 200, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);



			end



			draw.DrawText(self.Lang[self:GetStatus()], "HudHintTextLarge", 0, Y[3], Color(10, 200, 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

	  cam.End3D2D();

	end

end



