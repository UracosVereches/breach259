--[[
gamemodes/breach/entities/entities/armor_sci.lua
--]]
AddCSLuaFile()



ENT.Base		= "armor_base"

ENT.PrintName	= "Одежда ученого"

ENT.ArmorType	= "armor_sci"

ENT.teams					= {3}



function ENT:Initialize()

	self.Entity:SetModel("models/cultist/items/sci_cloth.mdl")

    self.Entity:PhysicsInit(SOLID_VPHYSICS)

	//self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

	self.Entity:SetMoveType(MOVETYPE_NONE)

	self.Entity:SetSolid(SOLID_BBOX)

	if SERVER then

		self:SetUseType(SIMPLE_USE)

	end



	//local phys = self.Entity:GetPhysicsObject()



	//if phys and phys:IsValid() then phys:Wake() end

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

end



function ENT:Use(ply)
print(ply:GTeam())
	print(TEAM_SCI)
	print(ply:GetNClass())
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
	if ply:GTeam() == TEAM_SCI then return end
	if ply:GetNClass() == ROLES.ROLE_RES then return end
	if ply:GetNClass() == ROLES.ROLE_MEDIC then return end
	if ply:GetNClass() == ROLES.ROLE_DZDD then return end
	if ply:GetNClass() == ROLES.ROLE_RESS then return end
	if ply:GTeam() == TEAM_SCP then return end

	if ply.exhausted then

		ply:RXSENDNotify("Вам стоит отдохнуть...")

	return end

	if ply.UsingArmor != nil then

		ply:RXSENDNotify('Вы уже имеете костюм, напишите "br_dropvest", чтобы снять его')

		return

	end

	ply:SetNWString("MyModel", ply:GetModel())

	if ply:GetModel() == "models/scp_class_d/class_d_new_1.mdl" or ply:GetModel() == "models/scp_class_d/class_d_hacker_new.mdl" then -- hackerman fix

		ply:SetModel("models/scp_sci_new/sci_new_1.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_2.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_2.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_3.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_3.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_4.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_4.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_5.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_5.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_6.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_6.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_7.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_7.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_8.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_8.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_9.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_9.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_10.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_10.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_11.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_11.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_12.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_12.mdl")

	elseif ply:GetModel() == "models/scp_class_d/class_d_new_13.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_13.mdl")

	--Д бабы

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_01.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_01.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_02.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_02.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_03.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_03.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_04.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_04.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_05.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_05.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_06.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_06.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_07.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_07.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_08.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_08.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_09.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_09.mdl")

	elseif ply:GetModel() == "models/scp_class_d/female/d_female_10.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_10.mdl")

	-- Бабы медики

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_01.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_01.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_02.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_02.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_03.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_03.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_04.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_04.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_05.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_05.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_06.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_06.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_07.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_07.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_08.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_08.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_09.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_09.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/female/m_female_10.mdl" then

		ply:SetModel("models/scp_sci_new/female/s_female_10.mdl")

  --Мужики Медикик

	elseif ply:GetModel() == "models/scp_sci_new/med_new_1.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_1.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_2.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_2.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_3.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_3.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_4.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_4.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_5.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_5.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_6.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_6.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_7.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_7.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_8.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_8.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_9.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_9.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_10.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_10.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_11.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_11.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_12.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_12.mdl")

	elseif ply:GetModel() == "models/scp_sci_new/med_new_13.mdl" then

		ply:SetModel("models/scp_sci_new/sci_new_13.mdl")

	end

	if SERVER then

		ply:ApplyArmor(self.ArmorType)

		self:EmitSound( Sound("npc/combine_soldier/zipline_clothing".. math.random(1, 2).. ".wav") )

		self:Remove()

	end

	if CLIENT then

		RXSENDNotify('Теперь вы носите броню, напишите "br_dropvest" в консоль, чтобы снять её')

	end

	ply:SetupHands()

	ply.UsingArmor = self.ArmorType

end



function ENT:Draw()

	self:DrawModel()

	local ply = LocalPlayer()

	if ply:GetPos():Distance(self:GetPos()) > 180 then

		return

	end

	if IsValid(self) then

		cam.Start2D()

			if DrawInfo != nil then

				DrawInfo(self:GetPos() + Vector(0,0,15), self.PrintName, Color(255,255,255))

			end

		cam.End2D()

	end

end



