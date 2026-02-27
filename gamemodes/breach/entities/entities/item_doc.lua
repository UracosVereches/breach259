--[[
lua/entities/item_doc.lua
--]]
AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"

ENT.PrintName = "Document"

ENT.Spawnable = true

ENT.AdminSpawnable = false

ENT.Category = "Breach"

function ENT:Initialize()

    self:SetModel("models/scp_documents/secret_document.mdl");

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



    if NextUse > CurTime() then return end

    if caller:GTeam() == TEAM_SCP or caller:GTeam() == TEAM_SPEC or caller:GTeam() == TEAM_GUARD then return end

	if caller:GetNWInt("documents") == 3 then NextUse = CurTime() + kek caller:RXSENDNotify("Вы знаете уже достаточно информации..."); return end

    caller:RXSENDNotify("Вы подобрали документ.");
    
    caller:SetNWInt("documents", caller:GetNWInt("documents", 0) + 1);
    
    self:Remove();

end

function ENT:Draw()

    self:DrawModel();

end
