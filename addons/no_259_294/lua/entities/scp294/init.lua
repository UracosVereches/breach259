AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

util.AddNetworkString("OpenSCP294Panel")
util.AddNetworkString("GiveSCP294Cup")

function ENT:Initialize()
	self:SetModel( "models/vinrax/scp294/scp294_lg.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	phys:Wake()
	end
end

function ENT:Use( ply, caller )
if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then return end
	net.Start("OpenSCP294Panel")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:Think()
end

function ENT:OnRemove()
end

function SpawnCup()
	local content 	= net.ReadString()
	local ent		= net.ReadEntity()
	local entA 		= ent:GetAngles()
	local pos 		= ent:GetPos() + entA:Right()*9 + entA:Up()*32 + entA:Forward()*13
	
	for k , v in pairs (ents.FindInSphere( pos, 2 )) do
		if v:GetClass() == "scp294cup" then
				ent:EmitSound("scp294/outofrange.ogg") 
				return 
		end
	end
	
	local cup = ents.Create( "SCP294cup" )
	cup:SetPos( pos )
	cup:Spawn()
	cup:SetNWString("Drink", content)
	if (DrinkList[content]) then
		if (DrinkList[content].dispense) then
			DrinkList[content].dispense(ent)
		end
	else
		ent:EmitSound("scp294/dispense1.wav") 
	end
end

net.Receive("GiveSCP294Cup", SpawnCup)



