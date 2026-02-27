--[[
lua/weapons/poke_ghosttype.lua
--]]
AddCSLuaFile("poke_ghosttype.lua")
--if SERVER then resource.AddWorkshop("1266206331") end
--[[------------------------------
Configuration
--------------------------------]]
local config = {}
config.SWEPName = "Ghost Type Primary"
config.ActionDelay = 1 -- Time in between each action.
--[[-------------------------------------------------------------------------
Phantom Force
---------------------------------------------------------------------------]]
config.PhantomForceDelay = 3 -- How long until you can use it again after attack?
config.PhantomForceDuration = 7 -- How long can you use this for?
config.PhantomForceRadius = 100 -- Radius around the player shadow to deal damage?
config.PhantomForceDamageLow = 50
config.PhantomForceDamageHigh = 100
config.PhantomForceDamageForce = 50000 -- Force applied on damage.

config.PhantomForceSound = "scp_sounds/scp_smoke/becoming_smoke.mp3"
config.PhantomForceStartSound = "scp_sounds/scp_smoke/hit_from_smoke.mp3"
config.PhantomForceSoundPitch = 75
--[[-------------------------------------------------------------------------
Confuse Ray
---------------------------------------------------------------------------]]
config.ConfuseRayDelay = 2
config.ConfuseRayDamageLow = 0
config.ConfuseRayDamageHigh = 0
config.ConfuseRaySize = 16   -- How big is the ray itself?
config.ConfuseRayRadius = 96 -- Radius of ray impact.
config.ConfuseRayRange = 512 -- How far the ray will travel.
config.ConfuseRayInterval = 0.1 -- Time in between rings.
config.ConfuseRayNumber = 10 -- How many rings? ( these deal damage )

config.ConfusionExpire = 7 -- How long until confusion expires?
config.ConfusionRandomAim = true -- Will this fling their aim around?
config.ConfusionHurtDamageLow = 3
config.ConfusionHurtDamageHigh = 5
config.ConfusionHurtChance = 50 -- Out of 100, if it is greater than this.

config.ConfuseRayFX = "fx_poke_confuseray"
config.ConfuseRaySound = "npc/manhack/bat_away.wav"
--[[-------------------------------------------------------------------------
Mirror Coat
---------------------------------------------------------------------------]]
config.MirrorCoatDelay = 2
config.MirrorCoatDuration = 5 -- Time until the beam shoots.
config.MirrorCoatDamageMulti = 2 -- Multiply the damage by how much?
config.MirrorCoatDamageCap = 1000 -- Max damage cap? Set to 0 for no cap.

config.MirrorCoatSound = "weapons/physcannon/physcannon_claws_close.wav"
config.MirrorCoatShootSound = "npc/strider/fire.wav"

config.MirrorCoatBeamSize = 16 -- Size of physical beam. ( not visual )
config.MirrorCoatBeamRange = 4567
config.MirrorCoatBeamFX = "fx_poke_mirrorcoatbeam"
--[[-------------------------------------------------------------------------
Night Shade
---------------------------------------------------------------------------]]
config.NightShadeDelay = 0.7
config.NightShadeClawLife = 3 -- How long does each claw last?
config.NightShadeClawSpeed = 512

config.NightShadeSound = "weapons/underwater_explode4.wav"
--[[-------------------------------------------------------------------------
Shadow Claw
---------------------------------------------------------------------------]]
config.ShadowClawDelay = 2
config.ShadowClawDuration = 10
config.MeleeAttackDelay 		= 1   -- Time in between punches.
config.MeleePunchRange 			= 135  -- Distance between you and the target.
config.MeleeDamageLow 			= 15
config.MeleeDamageHigh 			= 25
config.MeleePunchForce 			= 20 -- How much force to apply to targets?

config.MeleeSwingSound = Sound( "WeaponFrag.Throw" )
config.MeleePunchSound = Sound( "Flesh.ImpactHard" )
config.MeleeEffect = "fx_poke_shadowmelee"
--[[-------------------------------------------------------------------------
Messages ( debug )
---------------------------------------------------------------------------]]
config.PrintMessages = false
config.PhantomForceMessage = "Phantom Force!"
config.ConfuseRayMessage = "Confuse Ray!"
config.MirrorCoatMessage = "Mirror Coat!"
config.NightShadeMessage = "Night Shade!"
config.ShadowClawMessage = "Shadow Claw!"
config.MeleeAttackMessage 	= "Shadow Claw Attack!"
--[[----------------------
SWEP
------------------------]]
SWEP.PrintName = config.SWEPName
SWEP.Author = "Project Stadium"
SWEP.Purpose = "discord.me/projectstadium"
SWEP.Category = "Project Stadium"
SWEP.HoldType = "fist"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false
SWEP.UseHands = false
SWEP.ViewModelFOV = 54

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

SWEP.NextPhantomForce = 0
SWEP.PhantomForcePos = nil
SWEP.PhantomForceAng = nil
SWEP.PhantomForceEnabled = false
SWEP.NextConfuseRay = 0
SWEP.NextMirrorCoat = 0
SWEP.MirrorCoatAbsorbed = 0
SWEP.MirrorCoatEnabled = false
SWEP.NextNightShade = 0
SWEP.NextShadowClaw = 0
SWEP.ShadowClawEnabled = false
SWEP.NextMeleeToggle = 0
SWEP.NextMeleeAttack = 0
SWEP.MeleeAttacked = 0
SWEP.NextAction = 0
SWEP.UsingMelee = false

SWEP.NextFX = 0
SWEP.FXDelay = 0.1

-- POKE VARIABLES
SWEP.PokeSWEP = true
SWEP.POKE_MoveType = "ghost"

--[[-------------------------------------------------------------------------
Phantom Force
---------------------------------------------------------------------------]]
function SWEP:PhantomForceStart()
	if self.NextAction > CurTime() then return end
	
	self.NextAction = CurTime() + config.ActionDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ActionDelay) end
	local owner = self:GetOwner()
	-- ATTACK
	if config.PrintMessages then print(config.PhantomForceMessage) end
	if self.PhantomForceEnabled == true then
		self:PhantomForceAttack(true)
		self.NextAction = CurTime() + config.PhantomForceDelay
		if PokeBase then PokeBase_SendAction(self:GetOwner(),config.PhantomForceDelay) end
		return
	end

	-- START
	if !owner:IsOnGround() then return end
	sound.Play(config.PhantomForceStartSound,owner:GetPos(),75,config.PhantomForceSoundPitch,1)

	owner:SetMaterial("poke/props/invis")
	owner:SetColor(Color(0,0,0,0))

	self.PhantomForcePos = owner:GetPos()
	self.PhantomForceAng = owner:EyeAngles()
	self.PhantomForceEnabled = true
	net.Start("GHOSTPOKESENDTP")
		net.WriteEntity(owner)
		net.WriteBool(true)
	net.Broadcast()

	local timerid = "GHOSTPOKEPHANTOMFORCE"..owner:SteamID()
	timer.Create(timerid,config.PhantomForceDuration,1,function()
		if IsValid(self) then
			self:PhantomForceAttack(false)
		end
	end)
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ActionDelay) end
end
function SWEP:PhantomForceAttack(hand)
	local owner = self:GetOwner()
	if hand then 
		GHOSTPOKE_Effect(owner:GetPos(),"fx_poke_shadow",100,Vector(owner:GetAimVector().x,owner:GetAimVector().y,0)) 
	else
		GHOSTPOKE_Effect(owner:GetPos(),"fx_poke_shadow",100,Vector(owner:GetAimVector().x,owner:GetAimVector().y,0)) 
	end
	sound.Play(config.PhantomForceSound,owner:GetPos(),75,config.PhantomForceSoundPitch,1)

	for _, ents in ipairs(ents.FindInSphere(owner:GetPos(),config.PhantomForceRadius)) do
		if ents != owner then
			local damage = math.random(config.PhantomForceDamageLow,config.PhantomForceDamageHigh)
			if !hand then damage = (ents:Health()/10) end
			local dmg = DamageInfo()
			dmg:SetAttacker(owner)
			dmg:SetInflictor(self)
			dmg:SetDamageForce(owner:GetAimVector()*config.PhantomForceDamageForce)
			dmg:SetDamage(damage)
			ents:TakeDamageInfo(dmg)
		end
	end

	owner:SetVelocity(-owner:GetVelocity())
	if self.PhantomForcePos != nil then
		owner:SetPos(self.PhantomForcePos+Vector(0,0,1))
	end
	if self.PhantomForceAng != nil then
		owner:SetEyeAngles(self.PhantomForceAng)
	end
	owner:ViewPunch(Angle(0,0,1))

	self:PhantomForceReset()
end
function SWEP:PhantomForceReset()
	local owner = self:GetOwner()
	timer.Remove("GHOSTPOKEPHANTOMFORCE"..owner:SteamID())
	self.PhantomForcePos = nil
	self.PhantomForceAng = nil
	self.PhantomForceEnabled = false
	owner:SetMaterial()
	owner:SetViewOffset(Vector(0,0,60))
	owner:SetColor(Color(255,255,255,255))
	if IsValid(owner) then
		if SERVER then
			net.Start("GHOSTPOKESENDTP")
				net.WriteEntity(owner)
				net.WriteBool(false)
			net.Broadcast()
		end
	end
end
--[[-------------------------------------------------------------------------
Confuse Ray
---------------------------------------------------------------------------]]
function SWEP:ConfuseDamageDebuff(ply)
	if !ply:IsPlayer() then return end
	local owner = self:GetOwner()
	local timerid = "GHOSTPOKECONFUSERAYDMG"..ply:SteamID()
	local chance = math.random(1,100)
	if chance > config.ConfusionHurtChance then
		if !ply.POKE_Confused then
			ply:PrintMessage(HUD_PRINTTALK,"You are confused, and hurting yourself!")
			ply.POKE_Confused = true
			timer.Create(timerid,math.Round(config.ConfusionExpire/10),config.ConfusionExpire,function()
				if IsValid(self) then
					if !IsValid(owner) then owner = self end
					local dmginfo = DamageInfo()
					dmginfo:SetAttacker(owner)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamage(math.random(config.ConfusionHurtDamageLow,config.ConfusionHurtDamageHigh))
					ply:TakeDamageInfo(dmginfo)

					ply.POKE_Confused = false
				end
			end)
		end
	end
end
function SWEP:ConfuseRay()
	if self.NextAction > CurTime() then return end
	self.NextAction = CurTime() + config.ActionDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ActionDelay) end
	local owner = self:GetOwner()

	if config.PrintMessages then print(config.ConfuseRayMessage) end
	local timerid = "GHOSTPOKECONFUSERAY"..owner:SteamID()
	timer.Remove(timerid)
	timer.Create(timerid,config.ConfuseRayInterval,config.ConfuseRayNumber,function()
		if IsValid(owner) then
			GHOSTPOKE_Effect(owner:GetShootPos()+(owner:GetAimVector()*64),config.ConfuseRayFX,config.ConfuseRayRange,owner:GetAimVector(),owner)
			local tr = util.TraceHull({
				start = owner:GetShootPos(),
				endpos = owner:GetShootPos()+owner:GetAimVector()*config.ConfuseRayRange,
				mins = Vector( -config.ConfuseRaySize, -config.ConfuseRaySize, -config.ConfuseRaySize ),
				maxs = Vector( config.ConfuseRaySize, config.ConfuseRaySize, config.ConfuseRaySize ),
				filter = owner
			})

			if tr.Hit then
				for _, v in ipairs(ents.FindInSphere(tr.HitPos,config.ConfuseRayRadius)) do
					if v != self:GetOwner() then
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker(owner)
						dmginfo:SetInflictor(self)
						dmginfo:SetDamageForce(owner:GetAimVector()*15000)
						dmginfo:SetDamage(math.random(config.ConfuseRayDamageLow,config.ConfuseRayDamageHigh))
						v:TakeDamageInfo(dmginfo)
						self:ConfuseDamageDebuff(v)
						if v:IsPlayer() && v:Alive() then
							if config.ConfusionRandomAim then
								local ang = AngleRand()
								v:SetEyeAngles(Angle(ang.p,ang.y,0))
							end
							net.Start("GHOSTPOKECONFUSE")
								net.WriteEntity(v)
								net.WriteInt(config.ConfusionExpire,32)
							net.Send(v)
						end
					end
				end
			end
		end
	end)
	sound.Play(config.ConfuseRaySound,owner:GetPos(),65,75,1)

	self.NextAction = CurTime() + config.ConfuseRayDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ConfuseRayDelay) end
end
--[[-------------------------------------------------------------------------
Mirror Coat
---------------------------------------------------------------------------]]
function SWEP:MirrorCoatActivate()
	if self.NextAction > CurTime() then return end
	self.NextAction = CurTime() + config.ActionDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ActionDelay) end
	local owner = self:GetOwner()

	if self.MirrorCoatEnabled then
		self:MirrorCoatBeam()
		return
	end

	self.MirrorCoatEnabled = true

	owner:SetMaterial("models/props_combine/com_shield001a")
	self:SetColor(Color(255,215,155,255))

	sound.Play(config.MirrorCoatSound,owner:GetPos(),65,75,1)

	net.Start("GHOSTPOKEMIRRORCOAT")
		net.WriteEntity(owner)
		net.WriteBool(true)
	net.Broadcast()

	local timerid = "GHOSTPOKEMIRRORCOATTIMER"..owner:SteamID()
	timer.Create(timerid,config.MirrorCoatDuration,1,function()
		if IsValid(owner) then
			self:MirrorCoatBeam()
		end
	end)
	if config.PrintMessages then print(config.MirrorCoatMessage) end

	self.NextAction = CurTime() + config.MirrorCoatDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.MirrorCoatDelay) end
end
function SWEP:MirrorCoatBeam()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	if self.MirrorCoatAbsorbed > 0 then
		local tr = util.TraceHull({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos()+owner:GetAimVector()*config.MirrorCoatBeamRange,
			mins = Vector( -config.MirrorCoatBeamSize, -config.MirrorCoatBeamSize, -config.MirrorCoatBeamSize ),
			maxs = Vector( config.MirrorCoatBeamSize, config.MirrorCoatBeamSize, config.MirrorCoatBeamSize ),
			filter = owner
		})

		sound.Play(config.MirrorCoatShootSound,owner:GetPos(),65,135,1)
		GHOSTPOKE_Laser(owner:GetShootPos(),tr.HitPos,config.MirrorCoatBeamFX)
		
		local dmg = self.MirrorCoatAbsorbed*config.MirrorCoatDamageMulti
		if config.MirrorCoatDamageCap > 0 then
			dmg = math.Clamp(self.MirrorCoatAbsorbed*config.MirrorCoatDamageMulti,1,config.MirrorCoatDamageCap)
		end

		if tr.Hit then
			for _, v in ipairs(ents.FindInSphere(tr.HitPos,128)) do
				if v != self:GetOwner() then
					local dmginfo = DamageInfo()
					dmginfo:SetAttacker(owner)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamageForce(owner:GetAimVector()*15000)
					dmginfo:SetDamage(dmg)
					v:TakeDamageInfo(dmginfo)
				end
			end
		end
	end
	self.MirrorCoatAbsorbed = 0

	self:MirrorCoatReset()
end
function SWEP:MirrorCoatReset()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	timer.Remove("GHOSTPOKEMIRRORCOATTIMER"..owner:SteamID())
	owner:SetMaterial()
	owner:SetColor(Color(255,255,255,255))

	net.Start("GHOSTPOKEMIRRORCOAT")
		net.WriteEntity(owner)
		net.WriteBool(false)
	net.Broadcast()

	self.MirrorCoatAbsorbed = 0
	self.MirrorCoatEnabled = false
end
--[[-------------------------------------------------------------------------
Night Shade
---------------------------------------------------------------------------]]
function SWEP:NightShade()
	if self.NextAction > CurTime() then return end
	self.NextAction = CurTime() + config.ActionDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ActionDelay) end
	local owner = self:GetOwner()

	local claw = ents.Create("ent_poke_ghostclaw")
	claw:SetPos(owner:GetPos()+Vector(0,0,16)+(Vector(owner:GetForward().x,owner:GetForward().y,0)*64))
	claw:SetAngles(Angle(0,owner:EyeAngles().y,0))
	claw:SetOwner(self:GetOwner())
	claw.lifetime = config.NightShadeClawLife
	claw:Spawn()

	claw.speed = config.NightShadeClawSpeed

	sound.Play(config.NightShadeSound,owner:GetPos(),75,100,1)

	if config.PrintMessages then print(config.NightShadeMessage) end
	self.NextAction = CurTime() + config.NightShadeDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.NightShadeDelay) end
end
--[[-------------------------------------------------------------------------
Shadow Claw
---------------------------------------------------------------------------]]
function SWEP:ShadowClawState(toggle)
	net.Start("GHOSTPOKESHADOWCLAW")
		net.WriteBool(toggle)
		net.WriteEntity(self:GetOwner())
	net.Send(self:GetOwner())
end
function SWEP:ShadowClawActivate()
	if CLIENT then return end
	if self.NextAction > CurTime() then return end
	self.NextAction = CurTime() + config.ActionDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ActionDelay) end
	local owner = self:GetOwner()

	if self.ShadowClawEnabled == true then
		self:ShadowClawReset()
		return
	end
	if self.NextShadowClaw > CurTime() then return end
	self.ShadowClawEnabled = true
	self.ShowViewModel = true
	self.UseHands = true
	self.UsingMelee = true
	local speed = GetConVarNumber("sv_defaultdeployspeed")
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
	vm:SetPlaybackRate(speed)
	self:UpdateNextIdle()

	self:SetCombo(0) 
	self:ShadowClawState(true)


	if config.PrintMessages then print(config.ShadowClawMessage) end

 
	local timerid = "GHOSTPOKESHADOWCLAW"..owner:SteamID()
	timer.Create(timerid,config.ShadowClawDuration,1,function()
		if IsValid(self) then
			self:ShadowClawReset()
		end
	end)

	self.NextAction = CurTime() + config.ShadowClawDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ShadowClawDelay) end
end
function SWEP:ShadowClawReset()
	if self.ShadowClawEnabled == false then return end
	local owner = self:GetOwner()
	if IsValid(owner) then timer.Remove("GHOSTPOKESHADOWCLAW"..owner:SteamID()) end
	self.ShowViewModel = false
	self.UseHands = false
	self.UsingMelee = false
	self.NextShadowClaw = CurTime() + config.ShadowClawDelay
	self.ShadowClawEnabled = false
	self:ShadowClawState(false)
end
function SWEP:MeleeAttack()
	-- Shadow Claw
	if self.NextAction > CurTime() then return end
	self.NextAction = CurTime() + config.ActionDelay
	if PokeBase then PokeBase_SendAction(self:GetOwner(),config.ActionDelay) end
	if self.NextMeleeAttack < CurTime() then
		if config.PrintMessages then print(config.MeleeAttackMessage) end
		self:EmitSound(config.MeleeSwingSound)

		self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

		local r = math.random(1,2)
		if r == 1 then right = true end
		if r == 2 then right = false end

		local anim = "fists_left"
		if ( right ) then anim = "fists_right" end
		if ( self:GetCombo() >= 2 ) then
			anim = "fists_uppercut"
		end

		local vm = self:GetOwner():GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

		self:UpdateNextIdle()

		self.MeleeAttacked = CurTime() + 1

		self.NextAction = CurTime() + config.MeleeAttackDelay
		if PokeBase then PokeBase_SendAction(self:GetOwner(),config.MeleeAttackDelay) end
	end
end

-- OTHER
function SWEP:DoRemove()
	if CLIENT then return end
	local owner = self:GetOwner()
	if IsValid(owner) then
		self:PhantomForceReset()
		self:MirrorCoatReset()
		self:ShadowClawReset()

		timer.Remove("GHOSTPOKESHADOWCLAW"..owner:SteamID())
		timer.Remove("GHOSTPOKEPHANTOMFORCE"..owner:SteamID())
		timer.Remove("GHOSTPOKEMIRRORCOATTIMER"..owner:SteamID())
		timer.Remove("GHOSTPOKECONFUSERAY"..owner:SteamID())
		timer.Remove("GHOSTPOKECONFUSERAYDMG"..owner:SteamID())
	end
end
--[[-------------------------------------------------------------------------
Default SWEP functions
---------------------------------------------------------------------------]]
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.ShowViewModel = false
	self.UseHands = false
end

function SWEP:Think()
	local owner = self:GetOwner()
	if !self.MirrorCoatEnabled && !self.PhantomForceEnabled && owner:KeyDown(IN_USE) && owner:KeyDown(IN_RELOAD) then
		if self.NextMeleeToggle < CurTime() then
			self:ShadowClawActivate()
			self.NextMeleeToggle = CurTime() + config.ShadowClawDelay
		end
	end
	if self.PhantomForceEnabled then
		if self.NextFX < CurTime() then
			local shadow = EffectData()
			shadow:SetOrigin(owner:GetPos())
			shadow:SetNormal(Vector(0,0,1))
			shadow:SetScale(55)
			util.Effect("fx_poke_shadow",shadow)

			self.NextFX = CurTime() + self.FXDelay
		end
	end
	if !self.MirrorCoatEnabled && !self.PhantomForceEnabled && self.ShadowClawEnabled then
		local vm = owner:GetViewModel()
		local curtime = CurTime()
		local idletime = self:GetNextIdle()
		if (idletime > 0 && CurTime() > idletime) then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0"..math.random(1,2)))
			self:UpdateNextIdle()
		end
		if (self.MeleeAttacked > 0) then
			self:DealDamage()
			self.MeleeAttacked = 0
		end
		if (SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1) then
			self:SetCombo(0)
		end
	end
	if SERVER then
		if !self.PhantomForceEnabled && !self.ShadowClawEnabled then
			if owner:KeyReleased(IN_USE) && !owner:KeyDown(IN_RELOAD) then
				if self.NextMeleeToggle < CurTime() then self:MirrorCoatActivate() end
			elseif !owner:KeyDown(IN_USE) && owner:KeyReleased(IN_RELOAD) then
				if !self.MirrorCoatEnabled then if self.NextMeleeToggle < CurTime() then self:NightShade() end end
			end
		end
		if !self.MirrorCoatEnabled && !self.ShadowClawEnabled then
			if owner:KeyReleased(IN_ATTACK) && !owner:KeyDown(IN_ATTACK2) then
				self:PhantomForceStart()
			elseif !owner:KeyDown(IN_ATTACK) && owner:KeyDown(IN_ATTACK2) then
				if !self.PhantomForceEnabled then self:ConfuseRay() end
			end
		end
	end
end

function SWEP:PrimaryAttack() 
	if self.UsingMelee then self:MeleeAttack() end
end
function SWEP:SecondaryAttack() 
	if self.UsingMelee then self:MeleeAttack() end
end
function SWEP:Reload() end

function SWEP:OnRemove()
	self:DoRemove()
end
function SWEP:Holster() 
	self:DoRemove()
	return true 
end
function SWEP:Deploy() 
	return true 
end
--[[-------------------------------------------------------------------------
Fist SWEP stuff
---------------------------------------------------------------------------]]
function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"NextMeleeAttack")
	self:NetworkVar("Float",1,"NextIdle")
	self:NetworkVar("Int",2,"Combo")
end
function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self:SetNextIdle(CurTime()+vm:SequenceDuration()/vm:GetPlaybackRate())
end
function SWEP:DealDamage()
	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())
	self.Owner:LagCompensation(true)
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos()+self.Owner:GetAimVector()*config.MeleePunchRange,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	})
	if (!IsValid(tr.Entity)) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos()+self.Owner:GetAimVector()*config.MeleePunchRange,
			filter = self.Owner,
			mins = Vector(-10,-10,-8),
			maxs = Vector(10,10,8),
			mask = MASK_SHOT_HULL
		} )
	end
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if (tr.Hit && !(game.SinglePlayer()&& CLIENT)) then
		self:EmitSound(config.MeleePunchSound)
	end
	if tr.Hit then
		local fx = EffectData()
		fx:SetOrigin(tr.HitPos)
		fx:SetNormal(tr.HitNormal)
		fx:SetScale(5)
		util.Effect(config.MeleeEffect,fx)
		if SERVER then
			sound.Play(config.MeleePunchSound,tr.HitPos)
		end
	end
	local hit = false
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( config.MeleeDamageLow, config.MeleeDamageHigh ) )
		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
		end
		local diff = (tr.Entity:GetPos()-attacker:GetPos())/2
		tr.Entity:SetPos(tr.Entity:GetPos()+Vector(0,0,1))
		tr.Entity:SetVelocity((diff*config.MeleePunchForce)+Vector(0,0,50))
		tr.Entity:TakeDamageInfo( dmginfo )
		hit = true
	end
	if ( SERVER && IsValid( tr.Entity ) && !tr.Entity:IsPlayer() ) then
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( config.MeleeDamageLow, config.MeleeDamageHigh ) )
		tr.Entity:TakeDamageInfo( dmginfo )
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * config.MeleePunchForce * phys:GetMass() + Vector(0,0,100), tr.HitPos )
		end
		if tr.Entity:GetClass() == "func_breakable" or tr.Entity:GetClass() == "func_breakable_surf" then
			tr.Entity:Fire("Break","",0)
		end
	end
	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end
	self.Owner:LagCompensation( false )
end

