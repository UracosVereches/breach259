--[[
gamemodes/breach/entities/weapons/weapon_acidpuke.lua
--]]
SWEP.Author   = "Hds46"

SWEP.PrintName 		= "SCP-811"

SWEP.Contact        = "Steam Workshop"

SWEP.Purpose        = "Acid"

SWEP.Instructions   = "Vomit acid at a near distance."

SWEP.Category       = "Other"

SWEP.Spawnable      = true

SWEP.AdminOnly  = false

SWEP.ISSCP				= true





SWEP.ViewModelFOV = 64

SWEP.AutoSwitchTo 	= true

SWEP.AutoSwitchFrom = false

SWEP.Slot 			= 0

SWEP.SlotPos = 4

SWEP.Weight = 5 

SWEP.DrawCrosshair = true 

SWEP.DrawAmmo = false

SWEP.droppable				= false

SWEP.ViewModel      = "models/weapons/c_pistol.mdl"

SWEP.WorldModel   = "models/weapons/w_pistol.mdl"



SWEP.Primary.Delay = 5

SWEP.Primary.ClipSize	 = 1

SWEP.Primary.DefaultClip = 1

SWEP.Primary.Automatic   = false

SWEP.Primary.Ammo        = "None"

SWEP.HoldType		 = "normal"



SWEP.UseHands = true





SWEP.Secondary.ClipSize		= 0

SWEP.Secondary.DefaultClip	= 0

SWEP.Secondary.Automatic   	= true

SWEP.Secondary.Ammo         = "None"



game.AddParticles( "particles/antlion_gib_01.pcf" )

game.AddParticles( "particles/antlion_gib_02.pcf" )

game.AddParticles( "particles/antlion_worker.pcf" )



function SWEP:Initialize()

    util.PrecacheSound("acid/vomit.wav")

	util.PrecacheSound("npc/antlion/antlion_burst1.wav")

    util.PrecacheSound("npc/antlion/antlion_burst2.wav")

	util.PrecacheModel("models/spitball_large.mdl")

	util.PrecacheModel("models/spitball_medium.mdl")

	util.PrecacheModel("models/spitball_small.mdl")

	PrecacheParticleSystem( "antlion_gib_02" )

	PrecacheParticleSystem( "antlion_spit" )

	self:SetWeaponHoldType( self.HoldType )

end 



function SWEP:Reload()

end





function SWEP:PrimaryAttack()

    if ( !self:CanPrimaryAttack() ) then return end

	if !( self:GetOwner():GetNetworkedFloat("vomit_time") < CurTime() ) then return end

	if SERVER then

    self:GetOwner():EmitSound("acid_puke.ogg")

	self:GetOwner():SetWalkSpeed( self:GetOwner():GetWalkSpeed() - self:GetOwner():GetWalkSpeed()/1.5 )

	self:GetOwner():SetRunSpeed( self:GetOwner():GetRunSpeed() - self:GetOwner():GetRunSpeed()/1.5 )

	timer.Create("vomittimer" .. self.Weapon:EntIndex(),0.05,10,function()

	if IsValid(self) and IsValid(self:GetOwner()) then

	self:GetOwner():SetNetworkedFloat("vomit_time", 6.0 + CurTime())

	if SERVER then

    self:GetOwner():SendLua("util.ScreenShake( LocalPlayer():GetPos() ,1.4,4,1,2)")

	end

	local SpitTypes = {

            "models/spitball_large.mdl",

            "models/spitball_medium.mdl",

            "models/spitball_small.mdl"

    }

	for i=1,4 do

	local acid = ents.Create("grenade_spit")

	acid:SetPos(self:GetOwner():GetShootPos() + Vector(math.Rand(5,-5),math.Rand(5,-5),0))

	acid:SetAngles(self:GetOwner():GetAngles())

	acid:Spawn()

	acid:SetOwner(self:GetOwner())

	acid:SetNWBool("ScriptedAcid",true)

	acid:SetVelocity(self:GetOwner():GetAimVector()*500 + VectorRand()*50)

	acid:SetModel(table.Random(SpitTypes))

	end

	end

	end)

	timer.Create("speedreturn"  .. self.Weapon:EntIndex(),3,1,function()

	if IsValid(self) and IsValid(self:GetOwner()) then

	self:GetOwner():SetWalkSpeed(140)

	self:GetOwner():SetRunSpeed(160)

	end

	end)

    end

end



function SWEP:SecondaryAttack()

end



function SWEP:Deploy()

   self:GetOwner():SetNetworkedFloat("vomit_time", 0.5 + CurTime())

   self:GetOwner():DrawViewModel(false)

end



function SWEP:DrawWorldModel()

return false

end





function SWEP:Holster()

   timer.Remove("vomittimer" .. self.Weapon:EntIndex())

   timer.Remove("speedreturn" .. self.Weapon:EntIndex())

   

   return true

end



function SWEP:OnRemove()

   timer.Remove("vomittimer" .. self.Weapon:EntIndex())

   timer.Remove("speedreturn" .. self.Weapon:EntIndex())

   if IsValid(self:GetOwner()) then

   

   self:GetOwner().LastSwep = true

   local ply = self:GetOwner()

   timer.Simple(0.02,function() if IsValid(ply) then ply.LastSwep = false end end)

   end

end





function SWEP:OnDrop()

   timer.Remove("vomittimer" .. self.Weapon:EntIndex())

   timer.Remove("speedreturn" .. self.Weapon:EntIndex())

   

end





hook.Add("PlayerDeath","AcidExplode",function( victim, inflictor, attacker )

    

	if IsValid(victim) and victim.LastSwep == true and SERVER then

	if CLIENT then return end

	for k,v in pairs(ents.FindInSphere(victim:GetShootPos(),350)) do 

	if IsValid(v) and (v ~= victim) then

	if (v:IsRagdoll() or v:IsNPC() or v:IsPlayer()) then

	

	local dmginfo = DamageInfo()

    dmginfo:SetDamage((50 - (victim:GetShootPos() - v:GetPos()):Length()/2))

    dmginfo:SetDamageType( DMG_BLAST )

    dmginfo:SetAttacker( victim )

    dmginfo:SetDamageForce((victim:GetShootPos() - v:GetPos())*-20000) 

	v:TakeDamageInfo( dmginfo )

	else

	local dmginfo = DamageInfo()

    dmginfo:SetDamage((50 - (victim:GetShootPos() - v:GetPos()):Length()/2))

    dmginfo:SetDamageType( DMG_BLAST )

    dmginfo:SetAttacker( victim )

    dmginfo:SetDamageForce((victim:GetShootPos() - v:GetPos())*-200) 

	v:TakeDamageInfo( dmginfo )

	end

	end

	end

	ParticleEffect( "antlion_gib_02", victim:GetShootPos(), Angle(0,0,0), nil )

	victim:EmitSound("npc/antlion/antlion_burst" .. math.random(1,2) .. ".wav")

	for i=1,50 do

	local ent = ents.Create("grenade_spit")

    local vec = Vector(math.random()*25-15, math.random()*25-15, math.random()*25-15):GetNormal()

	ent:SetPos(victim:GetShootPos() + vec )

    ent:SetAngles(vec:Angle())

	ent:Spawn()

	ent:SetOwner(victim)

	ent:SetNWBool("ScriptedAcid",false)

    ent:SetVelocity(vec * 450)

	end

	if IsValid(victim:GetRagdollEntity()) then

	victim:GetRagdollEntity():Remove()

	end

	end

	if IsValid(victim) and (IsValid(inflictor) and inflictor:GetClass()=="grenade_spit" and inflictor:GetNWBool("ScriptedAcid")==true and !victim.LastSwep == true) or (IsValid(attacker) and attacker:IsPlayer() and attacker.LastSwep == true) then

	if IsValid(victim:GetRagdollEntity()) then

	for i=1,6 do

    local ent = ents.Create("prop_physics")

    local vec = Vector(math.random()*25-15, math.random()*25-15, math.random()*25-15):GetNormal()

    ent:SetPos(victim:GetRagdollEntity():GetPos() + vec )

    ent:SetAngles(vec:Angle())

    local stmodel = math.random(1,15)

    if stmodel == 1 then

    ent:SetModel("models/Gibs/HGIBS.mdl")

    elseif stmodel == 2 then

    ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

    elseif stmodel == 3 then

    ent:SetModel("models/Gibs/HGIBS_rib.mdl")

    elseif stmodel == 4 then

    ent:SetModel("models/Gibs/HGIBS_spine.mdl")

    elseif stmodel == 5 then

    ent:SetModel("models/Gibs/HGIBS_spine.mdl")

    elseif stmodel == 6 then

    ent:SetModel("models/Gibs/HGIBS_rib.mdl")

    elseif stmodel == 7 then

    ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

    elseif stmodel == 8 then

    ent:SetModel("models/Gibs/HGIBS_rib.mdl")

    elseif stmodel == 9 then

    ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

    elseif stmodel == 10 then

    ent:SetModel("models/Gibs/HGIBS.mdl")

    elseif stmodel == 11 then

    ent:SetModel("models/Gibs/HGIBS_rib.mdl")

    elseif stmodel == 12 then

    ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

    elseif stmodel == 13 then

    ent:SetModel("models/Gibs/HGIBS_spine.mdl")

    elseif stmodel == 14 then

    ent:SetModel("models/Gibs/HGIBS_rib.mdl")

    elseif stmodel == 15 then

    ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

    end

    ent:Fire("kill", "", 15)

    ent:Spawn()

    ent:SetVelocity(vec * 50)

    local phys = ent:GetPhysicsObject( )

    

    if phys:IsValid( ) then

        phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )

        phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )

    end

    end

	victim:GetRagdollEntity():Remove()

	end

	end

end)



hook.Add("EntityTakeDamage","AcidDamage",function( target, dmginfo )



if IsValid(target) and IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass()=="grenade_spit" and  dmginfo:GetInflictor():GetNWBool("ScriptedAcid")==true and target:IsRagdoll() and ModelForAcid(target) and SERVER then



for i=1,6 do

local ent = ents.Create("prop_physics")

local vec = Vector(math.random()*25-15, math.random()*25-15, math.random()*25-15):GetNormal()

ent:SetPos(target:GetPos() + vec )

ent:SetAngles(vec:Angle())

local stmodel = math.random(1,15)

if stmodel == 1 then

ent:SetModel("models/Gibs/HGIBS.mdl")

elseif stmodel == 2 then

ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

elseif stmodel == 3 then

ent:SetModel("models/Gibs/HGIBS_rib.mdl")

elseif stmodel == 4 then

ent:SetModel("models/Gibs/HGIBS_spine.mdl")

elseif stmodel == 5 then

ent:SetModel("models/Gibs/HGIBS_spine.mdl")

elseif stmodel == 6 then

ent:SetModel("models/Gibs/HGIBS_rib.mdl")

elseif stmodel == 7 then

ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

elseif stmodel == 8 then

ent:SetModel("models/Gibs/HGIBS_rib.mdl")

elseif stmodel == 9 then

ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

elseif stmodel == 10 then

ent:SetModel("models/Gibs/HGIBS.mdl")

elseif stmodel == 11 then

ent:SetModel("models/Gibs/HGIBS_rib.mdl")

elseif stmodel == 12 then

ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

elseif stmodel == 13 then

ent:SetModel("models/Gibs/HGIBS_spine.mdl")

elseif stmodel == 14 then

ent:SetModel("models/Gibs/HGIBS_rib.mdl")

elseif stmodel == 15 then

ent:SetModel("models/Gibs/HGIBS_scapula.mdl")

end

ent:Fire("kill", "", 15)

ent:Spawn()

ent:SetVelocity(vec * 50)

local phys = ent:GetPhysicsObject( )

    

if phys:IsValid( ) then

    phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )

    phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )

end

end

target:Remove()

end

end)



HModels = {



"models/humans/group0[123]/female_0[1234567].mdl",

"models/humans/group0[123]/male_0[123456789].mdl",

"models/humans/group03m/female_0[123456789].mdl",

"models/humans/group03m/male_0[123456789].mdl",

"models/humans/group01/male_cheaple.mdl",

"models/humans/charple0[1234].mdl",

"models/humans/corpse1.mdl",

"models/player/",

"models/zombie",

"[Pp]olice.mdl",

"[Ss]oldier",

"[Aa]lyx.mdl",

"[Bb]arney.mdl",

"[Bb]reen.mdl",

"[Ee]li.mdl",

"[Mm]onk.mdl",

"[Kk]leiner.mdl",

"[Mm]ossman.mdl",

"[Oo]dessa.mdl",

"[Gg]man.mdl",

"[Gg]man_high.mdl",

"[Bb]loody.mdl",

"[Vv]ortigaunt",

"[Ss]talker.mdl",

"[Mm]agnusson.mdl"

}

local NextBreachde = 0 

local cdNextBreachde = 4

function SWEP:Reload()

	if preparing or postround then return end

	if not IsFirstTimePredicted() then return end

	



    local ent = self:GetOwner():GetEyeTrace().Entity

	if NextBreachde > CurTime() then return end 

	NextBreachde = CurTime() + cdNextBreachde

    if ent:GetClass() == 'prop_dynamic' then

		if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then

			if SERVER then		   

			    ent:TakeDamage( math.Round(math.random(1,2)), self:GetOwner(), self:GetOwner() )

			end			

						

			ent:EmitSound("door_break.wav")

		end

	end



end

function ModelForAcid(ent)



    for k,model in pairs(HModels) do

        if string.find(ent:GetModel(),model) ~= nil  then

        return true

		end

    end

    return false

end



