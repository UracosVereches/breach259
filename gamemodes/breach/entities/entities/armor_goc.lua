--[[
gamemodes/breach/entities/entities/armor_goc.lua
--]]
AddCSLuaFile()



ENT.Base		= "armor_base"

ENT.PrintName	= "Неизвестное снаряжение"

ENT.ArmorType	= "armor_goc"

ENT.teams					= {3}



function ENT:Initialize()

	self.Entity:SetModel("models/cultist/items/sci_cloth.mdl")

    self.Entity:PhysicsInit(SOLID_VPHYSICS)

	//self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

	self.Entity:SetMoveType(MOVETYPE_NONE)

	self.Entity:SetSolid(SOLID_BBOX)

	if SERVER then

		self:SetUseType(SIMPLE_USE)

		self.breachsearchable = true

	end



	//local phys = self.Entity:GetPhysicsObject()



	//if phys and phys:IsValid() then phys:Wake() end

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

end



function ENT:Use(ply)

	local tr = ply:GetEyeTrace()



	if ply:GTeam() != TEAM_GOC or tr.Entity:GetPos():Distance(ply:GetPos()) > 75 then

	    ply:PrintMessage(HUD_PRINTTALK, "Access Denied")

	    return

	end

	if ply.exhausted then

		ply:RXSENDNotify("Вам стоит отдохнуть...")

	return end

	if ply.UsingArmor != nil then

		ply:RXSENDNotify('Вы уже имеете костюм, напишите "br_dropvest", чтобы снять его')

		return

	end

	ply:SetNWString("MyModel", ply:GetModel())

	if SERVER then

		ply:ApplyArmor(self.ArmorType)

		ply:SetModel("models/scp/goc_new.mdl")

		ply:SetMaxHealth(300)

		ply.IsLooting = true

		ply:Give("br_keycard_9")

	  ply:Give("medicmedkitfirst")

		ply:Give("cw_kk_ins2_nade_f1")

		ply:Give("cw_kk_ins2_cstm_kriss")

		ply.IsLooting = false

		ply:GiveAmmo( 350, "Pistol", true)

		ply:SendLua('surface.PlaySound("goc_theme.wav")')

		ply:PrintMessage(HUD_PRINTTALK, 'Поздравляю, вы нашли снаряжение, теперь ваша задача уничтожить комплекс, как можно быстрее. Найдите боеголовку и взорвите ее!')

		self:EmitSound( Sound("npc/combine_soldier/zipline_clothing".. math.random(1, 2).. ".wav") )

		self:Remove()

	end

	if CLIENT then

		ply:PrintMessage(HUD_PRINTTALK, 'Поздравляю, вы нашли снаряжение, теперь ваша задача уничтожить комплекс, как можно быстрее. Найдите боеголовку и взорвите ее!')

	end



	ply:SetHealth(ply:Health() + 100)

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



