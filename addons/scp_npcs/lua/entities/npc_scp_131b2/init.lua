AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/scp131b2/scp131b2_animated_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = GetConVarNumber("vj_scp_131b_h")
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = true -- Immune to everything
ENT.RunOnTouch = true -- Runs away when something touches it
ENT.PlayFearSoundOnTouch = true -- Should it play a sound when something touches it?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.IdleSoundChance = 8
ENT.NextSoundTime_Idle1 = 6
ENT.NextSoundTime_Idle2 = 14
ENT.GeneralSoundPitch1 = 100
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_scp066/Rolling.wav"}
ENT.SoundTbl_Idle = {"vj_scp131podb/podB3.wav","vj_scp131podb/podB4.wav","vj_scp131podb/podB6.wav"}

-- Custom
ENT.SCP131A_NextChaseTime = 0
ENT.SCP131A_NextCloseSoundTime = 0
ENT.SCP131A_BeethovenActivated = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(18, 18, 50), Vector(-18, -18, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "event_emit move" then
		self:FootStepSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.SCP131A_BeethovenActivated == true then
		util.ScreenShake(self:GetPos(),100,100,1,850)
	end
	if GetConVarNumber("ai_ignoreplayers") == 1 then return end
	local findents = ents.FindInSphere(self:GetPos(),250)
	if (!findents) then return end
	for k,v in ipairs(findents) do
		if v:IsPlayer() then
			if v:Team() ~= TEAM_SCP and v:Team() ~= TEAM_SPEC then --Link2006's to skip if they are a spectator or SCP
				if self:GetPos():Distance(v:GetPos()) <= 50 && CurTime() > self.SCP131A_NextCloseSoundTime then
					self:StopMoving()
					if math.random(1,15) == 1 then
						self.SCP131A_BeethovenActivated = false
						self:AlertSoundCode({"vj_scp131podb/podB10cry.wav"})
						self.NextIdleTime = CurTime() + math.random(11,12)
						self.SCP131A_NextCloseSoundTime = CurTime() + 26
						self.SCP131A_NextChaseTime = CurTime() + 11
						timer.Simple(20,function() if IsValid(self) then self.SCP131A_BeethovenActivated = false end end)
						//util.ScreenShake(self:GetPos(),10,10,23,100)
					else
						self.SCP131A_BeethovenActivated = false
						self:AlertSoundCode({"vj_scp131podb/podB1.wav","vj_scp131podb/podB2.wav","vj_scp131podb/podB3.wav","vj_scp131podb/podB4.wav","vj_scp131podb/podB5.wav","vj_scp131podb/podB6.wav","vj_scp131podb/podB7.wav","vj_scp131podb/podB8.wav","vj_scp131podb/podB9.wav"})
						self.SCP131A_NextCloseSoundTime = CurTime() + 5
					end
				end
				if CurTime() > self.SCP131A_NextChaseTime then
					self:SetLastPosition(v:GetPos())
					self:SetSchedule(SCHED_FORCED_GO_RUN)
					self.SCP131A_NextChaseTime = CurTime() + 5
				end
			end
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
