AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/scp/scp_939_new.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = GetConVarNumber("vj_scp_939_h1")
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 100
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 1 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.77 -- How much time until it can use any attack again? | Counted in Seconds
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
ENT.SoundTbl_Idle = {"vj_scp_939/specimen1/lure1.wav","vj_scp_939/specimen1/lure2.wav","vj_scp_939/specimen1/lure3.wav","vj_scp_939/specimen1/lure4.wav","vj_scp_939/specimen1/lure5.wav","vj_scp_939/specimen1/lure6.wav","vj_scp_939/specimen1/lure7.wav","vj_scp_939/specimen1/lure8.wav","vj_scp_939/specimen1/lure9.wav","vj_scp_939/specimen1/lure10.wav"}
ENT.SoundTbl_Alert = {"vj_scp_939/specimen1/alert1.wav","vj_scp_939/specimen1/alert2.wav","vj_scp_939/specimen1/alert3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_scp_939/specimen1/attack1.wav","vj_scp_939/specimen1/attack2.wav","vj_scp_939/specimen1/attack3.wav"}

ENT.GeneralSoundPitch1 = 80 -- Change this to 100 to make it always use the same pitch (So no deep voices)

-- Custom
ENT.SCP939_NextDmgT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth(math.random(GetConVarNumber("vj_scp_939_h1"),GetConVarNumber("vj_scp_939_h2")))
	self:SetCollisionBounds(Vector(25, 25, 40), Vector(-25, -25, 0))
	self:SetNoDraw(false)
	self:SetColor(Color(255,255,255,255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "move" then
		self:FootStepSoundCode()
	end
	if key == "attack" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if CurTime() > self.SCP939_NextDmgT && self.MeleeAttacking == false then
		util.VJ_SphereDamage(self,self,self:GetPos(),150,1,DMG_SLASH,true,false,{},function() end)
		util.ScreenShake(self:GetPos(),100,100,2,200)
		self.SCP939_NextDmgT = CurTime() + 1
	end
	self:SetNoDraw(false)
	self:SetColor(Color(255,255,255,255))
end

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
