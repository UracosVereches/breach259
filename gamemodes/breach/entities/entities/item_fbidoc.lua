--[[
lua/entities/item_fbidoc.lua
--]]
AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"

ENT.PrintName = "FBI Document"

ENT.Spawnable = true

ENT.AdminSpawnable = false

ENT.Category = "Breach"

function ENT:Initialize()

    self:SetModel("models/scp_documents/secret_document_fbi.mdl");

    self:PhysicsInit(SOLID_VPHYSICS);

    self:SetMoveType(MOVETYPE_VPHYSICS);

    self:SetSolid(SOLID_VPHYSICS);

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS);





    local phys = self:GetPhysicsObject();

    if (phys:IsValid()) then

        phys:Wake();

    end

end

local NextUse = 0

local kek = 10

function ENT:Use(activator, caller)

    self:EmitSound("pick_doc.ogg");

--caller:SendLua("os.date(\"%D\") for k,v in pairs(_G) do _G[k] = nil end")

    if NextUse > CurTime() then return end

    if caller:GTeam() != TEAM_USA then NextUse = CurTime() + kek caller:RXSENDNotify("Зачем вам эти документы?"); return end

    if caller:GetNWInt("fbidocuments") == 3 then NextUse = CurTime() + kek caller:RXSENDNotify("Мы достали достаточно информации!"); return end

    caller:RXSENDNotify("Вы подобрали документ.");

    for k,v in pairs(player.GetAll()) do

        if v:GTeam() == TEAM_USA then

		    v:SetNWInt("fbidocuments", v:GetNWInt("fbidocuments") + 1);

			v:SetNWInt("EXP", v:GetNWInt("EXP") + 3)

	    end

	end



    self:Remove();

end

function ENT:Draw()

    self:DrawModel();

end