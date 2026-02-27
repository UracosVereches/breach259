AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	HeliSoundPlayed = false

	HeliIsExploded = false

	self:SetUseType(SIMPLE_USE)

	self:PhysicsInit(SOLID_NONE)

	self:SetMoveType(MOVETYPE_NONE)

	self:SetSolid(SOLID_NONE)

	self:SetModel("models/scp_helicopter/resque_helicopter.mdl")

	--self:EmitSound("vehicles/chopper_rotor2.wav", 100, 100, 5, CHAN_STATIC))
	--local rotors = CreateSound(self.Entity, "vehicles/chopper_rotor2.wav", filter:AddAllPlayers())

	--rotors:PlayEx(5, 100)

end

function ENT:Use(activator, caller)
	return false
end

function ENT:OnTakeDamage(dmg)

if dmg:GetAttacker():GTeam() == TEAM_CHAOS then

	self.Damage = ( self.Damage or 2500 ) - dmg:GetDamage()
	if self.Damage <= 0 then
		self:Boom()
	elseif self.Damage <= 500 and !HeliSoundPlayed then
		HeliSoundPlayed = true
		self:EmitSound("npc/attack_helicopter/aheli_damaged_alarm1.wav", 100, 100, 5)
	elseif dmg:GetDamageType() == DMG_BLAST and !HeliIsExploded then
		self:Boom()
		for k, v in ipairs(player.GetAll()) do
			if v:GTeam() == TEAM_CHAOS then
				v:AddExp(300)
				v:TipSendGood("Ваша команда успешно уничтожила вертолёт фонда!")
			end
		end
	end

end

end

function ENT:OnRemove()
	return false
end

function TakeDamageFromHeli(ent)
	local dmg = 0
	for k, v in pairs(ents.FindInSphere(ent:GetPos(), 350)) do
		if v:IsPlayer() then
			if v:Alive() then
				if v:GTeam() != TEAM_SPEC then
					dmg = (1001 - v:GetPos():Distance(ent:GetPos())) * 10
					if dmg > 0 then
						for k, v in pairs(ents.FindInSphere(ent:GetPos(), 350)) do
							v:TakeDamage(dmg, ent, ent)
						end
					end
				end
			end
		end
	end
end

heli_gibs_table = {
"models/Gibs/helicopter_brokenpiece_01.mdl",
"models/Gibs/helicopter_brokenpiece_02.mdl",
"models/Gibs/helicopter_brokenpiece_03.mdl",
"models/Gibs/helicopter_brokenpiece_04_cockpit.mdl",
"models/Gibs/helicopter_brokenpiece_05_tailfan.mdl",
"models/Gibs/helicopter_brokenpiece_06_body.mdl"
}

function ENT:Boom()
if HeliIsExploded then return end

HeliIsExploded = true

	HeliIsLanded = false

	local explosion = ents.Create("env_explosion")
	explosion:SetKeyValue("spawnflags", 210)
	explosion:SetPos(self:GetPos())
	explosion:Spawn()
	explosion:Fire("explode", "", 0)
	TakeDamageFromHeli(explosion)
	self:EmitSound("weapons/explode"..math.random(3, 5)..".wav", 100, 100, 5)

	timer.Simple(1, function()
		local explosion = ents.Create("env_explosion")
		explosion:SetKeyValue("spawnflags", 210)
		explosion:SetPos(self:GetPos())
		explosion:Spawn()
		explosion:Fire("explode", "", 0)
		TakeDamageFromHeli(explosion)
		self:EmitSound("weapons/explode"..math.random(3, 5)..".wav", 100, 100, 5)
	end)

	timer.Simple(2, function()
		local explosion = ents.Create("env_explosion")
		explosion:SetKeyValue("spawnflags", 210)
		explosion:SetPos(self:GetPos())
		explosion:Spawn()
		explosion:Fire("explode", "", 0)
		TakeDamageFromHeli(explosion)
		self:EmitSound("weapons/explode"..math.random(3, 5)..".wav", 100, 100, 5)
	end)

	timer.Simple(3, function()
		local explosion = ents.Create("env_explosion")
		explosion:SetKeyValue("spawnflags", 210)
		explosion:SetPos(self:GetPos())
		explosion:Spawn()
		explosion:Fire("explode", "", 0)
		TakeDamageFromHeli(explosion)
		self:EmitSound("weapons/explode"..math.random(3, 5)..".wav", 100, 100, 5)
	end)

	timer.Simple(4, function()
		local explosion = ents.Create("env_explosion")
		explosion:SetKeyValue("spawnflags", 210)
		explosion:SetPos(self:GetPos())
		explosion:Spawn()
		explosion:Fire("explode", "", 0)
		TakeDamageFromHeli(explosion)
		self:EmitSound("weapons/explode"..math.random(3, 5)..".wav", 100, 100, 5)
	end)

	timer.Simple(5, function()
		local explosion = ents.Create("env_explosion")
		explosion:SetKeyValue("spawnflags", 210)
		explosion:SetPos(self:GetPos())
		explosion:Spawn()
		explosion:Fire("explode", "", 0)
		TakeDamageFromHeli(explosion)
		self:EmitSound("weapons/explode"..math.random(3, 5)..".wav", 100, 100, 5)
	end)

	timer.Simple(6, function()
		local explosion = ents.Create("env_explosion")
		explosion:SetKeyValue("spawnflags", 210)
		explosion:SetPos(self:GetPos())
		explosion:Spawn()
		explosion:Fire("explode", "", 0)
		TakeDamageFromHeli(explosion)
		self:EmitSound("npc/combine_gunship/gunship_explode2.wav", 100, 100, 5)

		for k, v in ipairs(heli_gibs_table) do
			local gib = ents.Create("prop_physics")
			gib:SetPos(self:GetPos())
			gib:SetModel(v)
			gib:Spawn()
			gib:SetColor(Color(72, 72, 72))
			gib:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
			gib:Ignite(math.random(30,40), 400)
		end
		self:StopSound("vehicles/chopper_rotor2.wav")
		self:Remove()
	end)

end