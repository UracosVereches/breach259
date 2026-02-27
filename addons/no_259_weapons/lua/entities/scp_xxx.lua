--[[
lua/entities/scp_xxx.lua
--]]
AddCSLuaFile();

if SERVER then
    function ENT:Initialize()
        self:SetModel("");
    
        self:SetHullType(HULL_HUMAN);
        self:SetHullSizeNormal();

        self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD));
        
	    self:SetNPCState(NPC_STATE_SCRIPT);
	    self:SetSolid(SOLID_BBOX);
	    self:SetUseType( SIMPLE_USE );
	    self:DropToFloor();
	
        self:SetMaxYawSpeed(90);
        self:SetHealth(150);
    end 

    local DistanceParams = {
    {min = 2000, max = 1400 , dmg = 0.04, volume = 0.25},
	{min = 1400, max = 1200 , dmg = 0.10, volume = 0.3},
    {min = 1200, max = 1000 , dmg = 0.14, volume = 0.35},
    {min = 1000, max = 700 , dmg = 0.17, volume = 0.4},
	{min = 700, max = 600 , dmg = 0.19, volume = 0.45},
	{min = 600, max = 500 , dmg = 0.20, volume = 0.5},
	{min = 500, max = 450 , dmg = 0.23, volume = 0.55},
	{min = 450,  max = 400  , dmg = 0.24, volume = 0.6},
	{min = 400,  max = 300  , dmg = 0.26, volume = 0.65},
	{min = 300,  max = 200  , dmg = 0.27, volume = 0.75},
	{min = 200,  max = 150  , dmg = 0.29, volume = 0.8},
	{min = 150,  max = 100  , dmg = 0.30, volume = 0.85},
	{min = 100,  max = 50  , dmg = 0.31, volume = 0.9},
    {min = 50,  max = 0  , dmg = 0.32, volume = 1.0}
    }

    function ENT:Think()
        local e = ents.FindInSphere(self:GetPos(), 2000);
        for _, v in pairs(e) do
		    if CLIENT then
		        if v:GTeam() == TEAM_SPEC or v:GTeam() == TEAM_SCP then return end
			end
		    local sound = CreateSound( v, "scp_music.ogg" )
			
            if v:IsPlayer() and v:Alive() and v:GetActiveWeapon():GetClass() != "weapon_scp" then
                local Distance = self:GetPos():Distance(v:GetPos());
                for _, i in pairs(DistanceParams) do
                    if i.min > Distance and i.max < Distance then
					    sound:PlayEx( i.volume, 110)
                        v:TakeDamage(i.dmg, self, self:GetClass());
                    end
                end
            end
			
        end
        
    end

    function ENT:OnTakeDamage(dmg)
        self:SetHealth(self:Health() - dmg:GetDamage());
        if self:Health() <= 0 then
            self:Remove();
        end
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel();
        
    end

    
end


ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
ENT.PrintName = "SCP-XXX"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nextoren"

sound.Add({
    name = "scp_xxx_sound",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 55,
    pitch = { 95, 110 },
    sound = "scpcb_horror12.wav"});

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

