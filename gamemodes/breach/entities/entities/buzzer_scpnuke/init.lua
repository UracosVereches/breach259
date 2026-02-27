AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

sound.Add( {
	name = "ScpNuke",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = { 100, 100 },
	sound = "jscp/nuke.wav"
} )

function ENT:TriggerInput(iname, value)
	 if (iname == "On") then
		if value == 1 then
		if self.Activated == 0 && self.Useable == 1 then
		timer.Simple(0.42, function() if !self:IsValid() then return end
		self:Havok() end)
		self.Entity:EmitSound( "buttons/lever4.wav", 62, 100 )
		timer.Simple(0.32, function() if !self:IsValid() then return end
		self:EnableUse() end)
		self.Activated = 1
		self.Useable = 0
		return end
		end
		if value == 0 then
		if self.Activated == 1 && self.Useable == 1 then
		timer.Simple(0.42, function() if !self:IsValid() then return end
		self:EndHavok() end)
		self.Entity:EmitSound( "buttons/lever5.wav", 72, 100 )
		timer.Simple(106, function() if !self:IsValid() then return end
		self:EnableUse() end)
		self.Activated = 0
		self.Useable = 0
		return end
		end
	 end
end 


function ENT:Initialize()
	for var=1, 15, 1 do
	util.PrecacheSound("ambient/levels/prison/radio_random" .. var .. ".wav")
	end

	util.PrecacheSound("buttons/lever4.wav")
	util.PrecacheSound("buttons/lever5.wav")

	self.Entity:SetModel("models/maxofs2d/button_04.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then	
	phys:Wake()
	end

	self.Useable = 1
	self.Activated = 0
	self.MaxUses = 3
	self.Unstoppable = false
	if !(WireAddon == nil) then self.Inputs   = Wire_CreateInputs(self, { "On" }) end

end

function ENT:SpawnFunction( ply, tr )

if ( !tr.Hit ) then return end

local SpawnPos = tr.HitPos + tr.HitNormal * 16
local ent = ents.Create( "Buzzer_SCPNuke" )
ent:SetPos( SpawnPos )
ent:Spawn()
ent:Activate()
return ent

end

function ENT:EnableUse()
self.Useable = 1
end

util.AddNetworkString('GOCNukeTimerstop')
util.AddNetworkString('GOCNukeTimer')

function ENT:Use( activator, caller )
if self.Activated == 0 && self.Useable == 1 then

if self.MaxUses == 0 then return end

if activator:GetNClass() == ROLES.ROLE_GOCSPY then
	if activator.UsingArmor != "armor_goc" then return end
end

if activator:GetNClass() != ROLES.ROLE_GOCSPY and activator:GTeam() != TEAM_GOC then return end

if GetGlobalBool("Nuke") then
	if activator:GetNClass() == ROLES.ROLE_GOCSPY or activator:GTeam() == TEAM_GOC and IsFirstTimePredicted() then
		activator:RXSENDWarning("Мы опоздали! Это конец.")
	end
	return
end

timer.Adjust("RoundTime", timer.TimeLeft("RoundTime") + 105, nil, nil)

net.Start("UpdateTime")
	if timer.TimeLeft( "RoundTime" ) == nil then
		net.WriteString(tostring(0))
	else
		net.WriteString(tostring(timer.TimeLeft( "RoundTime" )))
	end
net.Broadcast()

for k, v in ipairs(player.GetAll()) do
	if v:GTeam() == TEAM_GOC then
		--v:RXSENDNotify("Вы получили +200 опыта за успешную активацию боеголовки, защищайте её любой ценой!")
		v:AddExp(200)
	end
end

timer.Simple(0.42, function() if !self:IsValid() then return end
self:Havok() end)
self.Entity:EmitSound( "buttons/lever4.wav", 62, 100 )
timer.Simple(0.32, function() self:EnableUse() end)
SetGlobalBool("GOCNuke", true)
self.MaxUses = self.MaxUses - 1
net.Start("GOCNukeTimer")
net.Broadcast()
self.Activated = 1
self.Useable = 0
return end

if self.Activated == 1 && self.Useable == 1 then
if activator:GTeam() != TEAM_GOC or activator:GetNClass() != ROLES.ROLE_GOCSPY then
	if timer.TimeLeft("VisualExplosion") < 6 and IsFirstTimePredicted() then
		--print("Reps: "..timer.RepsLeft("VisualExplosion"))
		--print("Time: "..timer.TimeLeft("VisualExplosion"))
		activator:RXSENDWarning("Процесс детонации не остановить! Это конец...")
		return
	end
end
if activator:GTeam() == TEAM_GOC or activator.UsingArmor == "armor_goc" or activator:GTeam() == TEAM_SPEC or activator:GTeam() == TEAM_SCP then return end
timer.Simple(0.42, function() if !self:IsValid() then return end
self:EndHavok() end)
self.Entity:EmitSound( "buttons/lever5.wav", 72, 100 )
SetGlobalBool("GOCNuke", false)
net.Start("GOCNukeTimerstop")
net.Broadcast()
for k, v in ipairs(player.GetAll()) do
	v:SendLua("LocalPlayer():EmitSound('scp_sounds_new/goc_nuke_cancel.mp3')")
end

timer.Simple(10, function()
	self:EnableUse()
	self.Activated = 0
	self.Useable = 1
end)
--[[
timer.Simple(106, function() if !self:IsValid() then return end
self:EnableUse() end)
--]]
self.Activated = 0
self.Useable = 0
return end

end

function ENT:Think()
if self.Activated == 1 then
end
end

function ENT:Havok()

local squad = self:GetNetworkedString( 12 )



for k,v in pairs(player.GetAll()) do
--\"ScpNuke\"
	--v:SendLua("EmitSound( Sound(\"jscp/nuke.wav\"), LocalPlayer():GetPos() + Vector(0,0,0),LocalPlayer():EntIndex(), CHAN_AUTO, 1, 130, 0, 100)")
	v:SendLua("LocalPlayer():EmitSound( \"ScpNuke\",130 ,100 ,1)")
end


--for k,v in pairs(player.GetAll()) do
--	v:SendLua("surface.PlaySound(\"jscp/nuke.wav\")")
--end

		--Entity( 1 ):EmitSound("ScpNuke")
		
		----[[
		timer.Create( "VisualExplosion", 101, 1, function()
		
		if self.Activated == 1 then
		--[[
		for k,v in pairs(player.GetAll()) do
			if v:GTeam() != TEAM_GOC then

				v:SetFrags( 0 )
				v:StripWeapons()
				v:GodDisable()
				v:TakeDamage( 10000 )
			elseif v:GTeam() == TEAM_GOC or v:GetNCLass() == ROLES.ROLE_GOCSPY then
				v:EmitSound("ambient/machines/teleport3.wav", 75, 100, 3)
				v:StripWeapons()
				v:SetSpectator()
				v:RXSENDNotify("Невероятно! Как мы это выйграли? Комплекс был успешно взорван!")
				local exptogive = v:Frags() * 20
				v:AddExp(70 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))						

				v:RXSENDNotify("Ваш счёт: "..v:Frags())
			end
		end
		--]]
		for k, v in ipairs(player.GetAll()) do
			if v:GTeam() == TEAM_GOC then
				v:EmitSound("ambient/machines/teleport3.wav", 75, 100, 3)
				v:StripWeapons()
				v:SetSpectator()
				v:RXSENDNotify("Невероятно! Как мы это выйграли? Комплекс был успешно взорван!")
				local exptogive = v:Frags() * 20
				v:AddExp(70 * math.max(1, v:GetNLevel()) + exptogive + (v:GetNWInt("documents") * math.random(100,120)))						
	
				v:RXSENDNotify("Ваш счёт: "..v:Frags())
			end
		end
		timer.Simple(5.5, function()
			for k,v in pairs(player.GetAll()) do
			--if v:GTeam() != TEAM_SPEC then
				v:GodDisable()
				v:TakeDamage( 10000 )
				v:SendLua('RunConsoleCommand("pp_mat_overlay", "overlays/scp/no_signal")')
			--end
			end

			timer.Simple(30, function()
				for k, v in ipairs(player.GetAll()) do
					v:SendLua('RunConsoleCommand("pp_mat_overlay", "xyecoc")')
				end
			end)

		end)
		--SetGlobalBool("GOCNuke", false)
		--net.Start("GOCNukeTimerstop")
		--net.Broadcast()
		
		for k,v in pairs(player.GetAll()) do
		--v:SendLua("LocalPlayer():StopSound(\"ScpNuke\")")
		--v:SendLua("surface.PlaySound(\"jscp/nukeexplo.wav\")")
		--v:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 255 ), 0.6, 4 )
		v:SendLua("util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 3, 5000 )")		
		end
		else
		for k,v in pairs(player.GetAll()) do
		--v:SendLua("LocalPlayer():StopSound(\"ScpNuke\")")
		--v:SendLua("surface.PlaySound('scp_sounds_new/goc_nuke_cancel.mp3')")
		--v:ChatPrint( "Alpha Warheads Error")
		end
		end
		timer.Remove( "VisualExplosion" ) 
		end )

	timer.Create( "KillExplosion", 106.5 , 1, function() 
	
	if self.Activated == 1 then

		SetGlobalBool("GOCNuke", false)
		net.Start("GOCNukeTimerstop")
		net.Broadcast()

	end
		timer.Remove( "KillExplosion" )
	end )

	timer.Create( "CleanExplosion", 104 , 1, function() 
	if self.Activated == 1 then
		--game.CleanUpMap()
	end
	timer.Remove( "CleanExplosion" ) 
	end )
----]]
--for k,ply in pairs(player.GetAll()) do
--ply:ChatPrint( "Alpha Warheads Activated")
--end

end

function ENT:EndHavok()

local squad = self:GetNetworkedString( 12 )

self.Entity:StopSound("ScpNuke")

--for k,ply in pairs(player.GetAll()) do
--ply:ChatPrint( "Alpha Warheads deactivated")
--end

end

function ENT:OnRemove()

local squad = self:GetNetworkedString( 12 )
self.Entity:StopSound("ScpNuke")
end