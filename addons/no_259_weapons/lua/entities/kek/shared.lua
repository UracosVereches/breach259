--[[
lua/entities/kek/shared.lua
--]]
if (SERVER) then
    AddCSLuaFile();
end;

local material = Material("effects/com_shield003a");
local material2 = Material("effects/com_shield004a");

ENT.Type            = "anim";
ENT.Base            = "base_anim";
ENT.PrintName       = "Forcefield";
ENT.Category        = "Forcefields";
ENT.Spawnable       = true;
ENT.AdminOnly       = true;
ENT.RenderGroup     = RENDERGROUP_BOTH;
ENT.PhysgunDisabled = true;

if (SERVER) then

    function ENT:SpawnFunction(player, trace)
        if !(trace.Hit) then return; end;
        local entity = ents.Create("z_forcefield");

        entity:SetPos(trace.HitPos + Vector(0, 0, 40));
        entity:SetAngles(Angle(0, trace.HitNormal:Angle().y - 90, 0));
        entity:Spawn();
        entity.Owner = player;

        return entity;
    end;

    function ENT:SetupDataTables()
        self:DTVar("Bool", 0, "Enabled");
        self:DTVar("Bool", 1, "Alt");
        self:DTVar("Entity", 0, "Dummy");
    end;

    function ENT:Initialize()
        self:SetModel("models/props_combine/combine_fence01b.mdl");
        self:SetSolid(SOLID_VPHYSICS);
        self:SetUseType(SIMPLE_USE);
        self:PhysicsInit(SOLID_VPHYSICS);
        self:DrawShadow(false);
        self:SetDTBool(0, true);

        if (!self.noCorrect) then
            local data = {};
            data.start = self:GetPos();
            data.endpos = self:GetPos() - Vector(0, 0, 300);
            data.filter = self;
            local trace = util.TraceLine(data);

            if trace.Hit and util.IsInWorld(trace.HitPos) and self:IsInWorld() then
                self:SetPos(trace.HitPos + Vector(0, 0, 39.9));
            end;

            data = {};
            data.start = self:GetPos();
            data.endpos = self:GetPos() + Vector(0, 0, 150);
            data.filter = self;
            trace = util.TraceLine(data);

            if (trace.Hit) then
                self:SetPos(self:GetPos() - Vector(0, 0, trace.HitPos:Distance(self:GetPos() + Vector(0, 0, 151))));
            end;
        end;

        data = {};
        data.start = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -16;
        data.endpos = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -600;
        data.filter = self;
        trace = util.TraceLine(data);

        self.post = ents.Create("prop_physics")
        self.post:SetModel("models/props_combine/combine_fence01a.mdl")
        self.post:SetPos(self.forcePos or trace.HitPos - Vector(0, 0, 50))
        self.post:SetAngles(Angle(0, self:GetAngles().y, 0));
        self.post:Spawn();
        self.post:PhysicsDestroy()
        self.post:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
        self.post:DrawShadow(false);
        self.post:DeleteOnRemove(self);
        self:DeleteOnRemove(self.post);

        local verts = {
            {pos = Vector(0, 0, -35)},
            {pos = Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.post:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.post:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.post:GetPos()) - Vector(0, 0, 35)},
            {pos = Vector(0, 0, -35)},
        }

        self:PhysicsFromMesh(verts);

        local physObj = self:GetPhysicsObject();

        if (IsValid(physObj)) then
            physObj:SetMaterial("default_silent");
            physObj:EnableMotion(false);
        end;

        self:SetCustomCollisionCheck(true);
        self:EnableCustomCollisions(true);

        physObj = self.post:GetPhysicsObject();

        if (IsValid(physObj)) then
            physObj:EnableMotion(false);
        end;

        self:SetDTEntity(0, self.post);

        self.AllowedTeams = {};
        self.AllowedPlayers = {};
        self.Contributors = {};
    end;

    function ENT:StartTouch(ent)
        if (!self:GetDTBool(0)) then return; end;

        if (ent:IsPlayer()) then
            if (self:ShouldCollide(ent)) then
            end;
        end;
    end;

    function ENT:Touch(ent)
        if (!self:GetDTBool(0)) then return; end;

        if (ent:IsPlayer()) then
            if (self:ShouldCollide(ent)) then
            end;
        end;
    end;

    function ENT:EndTouch(ent)
        if (!self:GetDTBool(0)) then return; end;

        if (ent:IsPlayer()) then
            if (self:ShouldCollide(ent)) then
            end;
        end;
    end;

    function ENT:Think()

        if (IsValid(self:GetPhysicsObject())) then
            self:GetPhysicsObject():EnableMotion(false);
        end;
    end;

    function ENT:Use(act, call, type, val)
        if ((self.nextUse or 0) < CurTime()) then
            self.nextUse = CurTime() + 1;
        else
            return;
        end;
    end;


    function ENT:AddPlayer(player)
        self.AllowedPlayers[player] = true;
        netstream.Start(nil, "forcefieldUpdate", "addPlayer", {self, player});
    end;

    function ENT:RemovePlayer(player)
        self.AllowedPlayers[player] = nil;
        netstream.Start(nil, "forcefieldUpdate", "removePlayer", {self, player});
    end;

    function ENT:AddTeam(team)
        self.AllowedTeams[team] = true;
        netstream.Start(nil, "forcefieldUpdate", "addTeam", {self, team});
    end;

    function ENT:RemoveTeam(team)
        self.AllowedTeams[team] = nil;
        netstream.Start(nil, "forcefieldUpdate", "removeTeam", {self, team});
    end;

    function ENT:AddContributor(player)
        self.Contributors[player] = true;
        netstream.Start(nil, "forcefieldUpdate", "addContributor", {self, player});
    end;

    function ENT:RemoveContributor(player)
        self.Contributors[player] = nil;
        netstream.Start(nil, "forcefieldUpdate", "removeContributor", {self, player});
    end;

    function ENT:SendFullUpdate(player)
        if (IsValid(player)) then
            netstream.Start(player, "forcefieldUpdate", "fullUpdate", {self, self.AllowedPlayers, self.AllowedTeams, self.Contributors});
        elseif (player == false) then
            netstream.Start(nil, "forcefieldUpdate", "fullUpdate", {self, self.AllowedPlayers, self.AllowedTeams, self.Contributors});
        end;
    end;
end;

if (CLIENT) then

    function ENT:Initialize()
        local data = {};
        data.start = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -16;
        data.endpos = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -600;
        data.filter = self;
        local trace = util.TraceLine(data);

        local verts = {
            {pos = Vector(0, 0, -35)},
            {pos = Vector(0, 0, 150)},
            {pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) - Vector(0, 0, 35)},
            {pos = Vector(0, 0, -35)},
        };

        self:PhysicsFromMesh(verts);
        self:EnableCustomCollisions(true);

        self.AllowedTeams = {};
        self.AllowedPlayers = {};
        self.Contributors = {};
    end;

    function ENT:Draw()
        local post = self:GetDTEntity(0);
        local angles = self:GetAngles();
        local matrix = Matrix();

        self:DrawModel();
        matrix:Translate(self:GetPos() + self:GetUp() * -40 + self:GetForward() * -2);
        matrix:Rotate(angles);

        render.SetMaterial(self:GetDTBool(1) and material2 or material);

        if (IsValid(post)) then
            local vertex = self:WorldToLocal(post:GetPos());
            self:SetRenderBounds(vector_origin - Vector(0, 0, 40), vertex + self:GetUp() * 150);

            cam.PushModelMatrix(matrix);
            self:DrawShield(vertex);
            cam.PopModelMatrix();

            matrix:Translate(vertex);
            matrix:Rotate(Angle(0, 180, 0));

            cam.PushModelMatrix(matrix);
            self:DrawShield(vertex);
            cam.PopModelMatrix();
        end;
    end;

    -- I took a peek at how Chessnut drew his forcefields.
    function ENT:DrawShield(vertex)
        if (self:GetDTBool(0)) then
            local dist = self:GetDTEntity(0):GetPos():Distance(self:GetPos());
            local useAlt = self:GetDTBool(1);
            local matFac = useAlt and 70 or 45;
            local height = useAlt and 3 or 5;
            local frac = dist / matFac;
            mesh.Begin(MATERIAL_QUADS, 1);
            mesh.Position(vector_origin);
            mesh.TexCoord(0, 0, 0);
            mesh.AdvanceVertex();
            mesh.Position(self:GetUp() * 190);
            mesh.TexCoord(0, 0, height);
            mesh.AdvanceVertex();
            mesh.Position(vertex + self:GetUp() * 190);
            mesh.TexCoord(0, frac, height);
            mesh.AdvanceVertex();
            mesh.Position(vertex);
            mesh.TexCoord(0, frac, 0);
            mesh.AdvanceVertex();
            mesh.End();
        end;
    end;
end;

function ENT:ShouldCollide(ent)
    if (!self:GetDTBool(0)) then return false; end;

    if (ent:IsPlayer()) then
        if ent:GTeam() != TEAM_GUARD then
            return false;
        else
            return true;
        end;
    else
        return true;
    end;
end;


