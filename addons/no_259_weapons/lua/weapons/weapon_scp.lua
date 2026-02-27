--[[
lua/weapons/weapon_scp.lua
--]]
AddCSLuaFile();
 
if SERVER then
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false
    
    SWEP.Primary.ClipSize = -1
    SWEP.Primary.DefaultClip = -1
    SWEP.Primary.Automatic = false
    SWEP.Primary.Ammo = "none"

    hook.Add("PlayerDeath", "scp_xxx_pd", function(victim, inflictor, attacker)
        if inflictor:GetClass() == "weapon_scp" then
		    local scpss = ents.Create("scp_xxx")
		    scpss:SetPos(victim:GetPos());
	        scpss:SetModel("models/props_junk/watermelon01.mdl");
			scpss:SetNoDraw(true)
		    scpss:Spawn(); 
			
            local scp_npc = ents.Create("base_gmodentity");
            
            scp_npc:SetPos(victim:GetPos());
			scp_npc:SetModel(victim:GetModel());
            scp_npc:Spawn();
			
			scp_npc:SetSequence(scp_npc:LookupSequence( "taunt_zombie" ))
	        scp_npc:SetPlaybackRate(1.0)
			scp_npc.AutomaticFrameAdvance = true   
	        function scp_npc:Think() 
                self:NextThink( CurTime() )
		        if( self:GetCycle() >= 0.95 ) then self:SetCycle(0.10) end
                    return true
            end
       end
    end);
end

if CLIENT then
    SWEP.PrintName = "SCP-kok"
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.UseHands = true
    SWEP.DrawCrosshair = true
    SWEP.DrawAmmo = false
end

SWEP.Author = "Varus"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "Nextoren"
SWEP.Spawnable = true
SWEP.HoldType = "melee" 
SWEP.ISSCP = true 
SWEP.AdminSpawnable = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""

function SWEP:PrimaryAttack()
    return false
end
if CLIENT then 
    
end
function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" )
	
end
function SWEP:Equip( )
    self.Owner:SendLua('RunConsoleCommand("stopsound")')
    self.Owner:EmitSound("scp_music_2.mp3")
end
local DistanceParams = {
    
    
    {min = 2000, max = 1400 , dmg = 0.05, volume = 0.25},
	{min = 1400, max = 1100 , dmg = 0.12, volume = 0.3},
    {min = 1500, max = 1000 , dmg = 0.2, volume = 0.35},
    {min = 1000, max = 700 , dmg = 0.25, volume = 0.4},
	{min = 700, max = 600 , dmg = 0.25, volume = 0.45},
	{min = 600, max = 500 , dmg = 0.26, volume = 0.5},
	{min = 500, max = 450 , dmg = 0.28, volume = 0.55},
	{min = 450,  max = 400  , dmg = 0.29, volume = 0.6},
	{min = 400,  max = 300  , dmg = 0.30, volume = 0.65},
	{min = 300,  max = 200  , dmg = 0.31, volume = 0.75},
	{min = 200,  max = 150  , dmg = 0.33, volume = 0.8},
	{min = 150,  max = 100  , dmg = 0.34, volume = 0.85},
	{min = 100,  max = 50  , dmg = 0.34, volume = 0.9},
    {min = 50,  max = 0  , dmg = 0.35, volume = 1.0}
}



function SWEP:Think()
    
	--self.Owner:EmitSound("scp_music_2.mp3")
    if CLIENT then return end
    local e = ents.FindInSphere(self:GetPos(), 2000);
	
	


    for _, v in pairs(e) do
	    
        if v:IsPlayer() and v:Alive() and v != self:GetOwner() then
		   
		    if v:GTeam() == TEAM_SPEC or v:GTeam() == TEAM_SCP then return end
			
			
			if (timer.Exists("Screammusic" ..v:SteamID())) then 
	            
		    
			--print("player")
		else
		   -- print("gay")
		timer.Create("Screammusic" ..v:SteamID(), 50, 1, function() 
		    v:SendLua('surface.PlaySound("scp_music_2.mp3")')
		end)
	end
			
            local Distance = self:GetPos():Distance(v:GetPos());
			
            for _, i in pairs(DistanceParams) do
			    
			   
				
		       -- print(sound:GetVolume())
                if i.min > Distance and i.max < Distance then
				
				    
				
                    v:TakeDamage(i.dmg, self:GetOwner(), self);
                end
            end
        end
    end
end



function SWEP:Reload() return false end
function SWEP:SecondaryAttack() return false end

function SWEP:HUDShouldDraw(element)
    if element == "CHudAmmo" or element == "CHudSecondaryAmmo" then return false else return true; end
end

