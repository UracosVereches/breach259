AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/hunter/blocks/cube1x1x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NOCLIP)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
		phys:EnableMotion(false)
	end

	local defaultpos = Vector(1777.695068, 881.130493, 43.745945)
	local defaultang = Angle(-90, 0, 180)
	phys:SetAngles(defaultang)
	self:SetAngles(defaultang)
	phys:SetPos(defaultpos)
	self:SetPos(defaultpos)

	self:SetUseType(SIMPLE_USE)

	self:SetNoDraw(true)
end

// Add anything else in the Use function
function ENT:Use(c, a)
	if IsValid( c ) and c:IsPlayer() and c:Alive() and c:Team() != TEAM_SPEC and c:Team() ~= TEAM_SCP then --Ripper's check to skip if they are a spectator or SCP
		local chance = math.random(1,100)
		local choose = math.random(1,4)
		local weapon = "none"
		if tostring(c:GetActiveWeapon()) != "[NULL Entity]"  then
			weapon = c:GetActiveWeapon():GetClass()
			active_weapon = c:GetActiveWeapon():GetClass()
		end
		//c:PrintMessage(HUD_PRINTTALK, weapon)
		// Incorrect: tostring(c:GetActiveWeapon())
		c.IsLooting = true
		if weapon == "br_keycard_2" or weapon == "br_keycard_3" then
			if chance < 30 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_4")
			elseif chance < 60 then
				c:StripWeapon(active_weapon)
				c:Give("item_snav_300")
			else
				c:StripWeapon(active_weapon)
				c:Give("weapon_flashlight")
			end
		elseif weapon == "br_keycard_4" then
			if chance < 10 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_5")
			elseif chance < 60  then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_2")
			else
				c:StripWeapon(active_weapon)
				if choose == 1 then c:Give("item_snav_ultimate")
				elseif choose == 2 then c:Give("wep_jack_job_drpradio")
				else c:Give("medicmedkitfirst")
				end
			end
		elseif weapon == "br_keycard_5" then
			if chance < 10 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_6")
			elseif chance < 40 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_4")
			else
				c:StripWeapon(active_weapon)
				if choose == 1 then c:Give("medicmedkit")
				elseif choose == 2 then c:Give("item_nvg")
				else c:Give("item_snav_ultimate")
				end
			end
		elseif weapon == "br_keycard_6" then
			if chance < 30 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_7")
			elseif chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_5")
			else
				c:StripWeapon(active_weapon)
				if choose == 1 then c:Give("medicmedkit")
				elseif choose == 2 then c:Give("item_nvg")
				else c:Give("item_snav_ultimate")
				end
			end
		elseif weapon == "br_keycard_7" then
			if chance < 30 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_6")
			elseif chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_5")
			else
				c:StripWeapon(active_weapon)
				if choose == 1 then c:Give("medicmedkit")
				elseif choose == 2 then c:Give("item_nvg")
				else c:Give("item_snav_ultimate")
				end
			end
		//elseif tostring(c:GetActiveWeapon()) == "[NULL Entity]" then
		elseif weapon == "none" or weapon == "v92_eq_unarmed" or weapon == "big_black_hands" then
			c:TakeDamage(50)
			c:TipSendWarning("Вы суёте руку внутрь. Самочувствие ухудшилось...")
			if chance < 30 then
				c:Give("br_keycard_3")
			elseif chance < 45 then
				c:Give("br_keycard_4")
			else
				if choose == 1 then c:Give("item_snav_300")
				elseif choose == 2 then c:Give("weapon_flashlight")
				else c:Give("wep_jack_job_drpradio")
				end
			end
		elseif weapon == "wep_jack_job_drpradio" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("item_snav_300")
			else
				c:StripWeapon(active_weapon)
				c:Give("item_nvg")
			end
		elseif weapon == "item_snav_300" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("item_nvg")
			else
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_3")
			end
		elseif weapon == "item_snav_ultimate" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_4")
			else
				c:StripWeapon(active_weapon)
				c:Give("medicmedkit")
			end
		elseif weapon == "weapon_flashlight" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("wep_jack_job_drpradio")
			else
				c:StripWeapon(active_weapon)
				c:Give("item_nvg")
			end
		elseif weapon == "item_nvg" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("item_snav_300")
			else
				c:StripWeapon(active_weapon)
				c:Give("wep_jack_job_drpradio")
			end
		elseif weapon == "wep_jack_job_drpradio" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("item_snav_300")
			else
				c:StripWeapon(active_weapon)
				c:Give("item_nvg")
			end
		elseif weapon == "medicmedkit" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_4")
			else
				c:StripWeapon(active_weapon)
				c:Give("cwc_cbar")
			end
		elseif weapon == "medicmedkitfirst" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_3")
			else
				c:StripWeapon(active_weapon)
				c:Give("item_snav_300")
			end
		elseif weapon == "wep_jack_job_drpradio" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("item_snav_300")
			else
				c:StripWeapon(active_weapon)
				c:Give("item_nvg")
			end
		elseif weapon == "cwc_cbar" then
			if chance < 50 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_4")
			else
				c:StripWeapon(active_weapon)
				c:Give("medicmedkit")
			end
		--Dickheads
		--[[
		elseif weapon == "item_scp_714" then
			if chance < 20 then
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_8")
			else
				c:StripWeapon(active_weapon)
				c:Give("br_keycard_6")
			end
		--]]
		else
			c:TipSendWarning("Не помещается.")
		end
		c.IsLooting = false
	end
end
