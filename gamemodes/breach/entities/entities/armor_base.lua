--[[
gamemodes/breach/entities/entities/armor_base.lua
--]]
AddCSLuaFile()



ENT.PrintName		= "Base Armor"

ENT.Author		    = "Kanade"

ENT.Type			= "anim"

ENT.Spawnable		= true

ENT.AdminSpawnable	= true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.ArmorType = "armor_mtfguard"



function ENT:Initialize()

	self.Entity:SetModel("models/cultist/items/mog.mdl")

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
	if ply:GTeam() == TEAM_SCP then return end

        --ply:RXSENDNotify("Вы не можете носить броню")

	--return end

	if ply.exhausted then

		ply:RXSENDNotify("Вам стоит отдохнуть...")

	return end

	if ply.UsingArmor != nil then

		ply:RXSENDNotify('На вас уже есть костюм, напишите "br_dropvest" чтобы снять его')

		return

	end

	ply:SetNWString("MyModel", ply:GetModel())

	if SERVER then

		ply:ApplyArmor(self.ArmorType)

		self:EmitSound( Sound("npc/combine_soldier/zipline_clothing".. math.random(1, 2).. ".wav") )

		self:Remove()

	end

	if CLIENT then

		RXSENDNotify('Теперь вы носите броню, напишите "br_dropvest" в консоль, чтобы снять её')

	end

	ply.UsingArmor = self.ArmorType

	ply:SetupHands()

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



