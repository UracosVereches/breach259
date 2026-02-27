--[[
gamemodes/breach/entities/weapons/weapon_scp_1980.lua
--]]
AddCSLuaFile()



SWEP.PrintName			= "SCP-1903"



if CLIENT then

	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")

	SWEP.BounceWeaponIcon = false

end



SWEP.ViewModelFOV 		= 56

SWEP.Spawnable 			= false

SWEP.AdminOnly 			= false

SWEP.Author         = "Varus"



SWEP.Primary.ClipSize		= -1

SWEP.Primary.DefaultClip	= -1

SWEP.Primary.Delay        = 2

SWEP.Primary.Automatic	= true

SWEP.Primary.Ammo		= "None"

SWEP.Sound					= "nice_sound.ogg"

SWEP.Secondary.ClipSize		= -1

SWEP.Secondary.DefaultClip	= -1

SWEP.Secondary.Automatic	= false

SWEP.Secondary.Delay			= 3

SWEP.Secondary.Ammo		= "None"



SWEP.ISSCP 				= true

SWEP.droppable				= false

SWEP.CColor					= Color(0,255,0)

SWEP.teams					= {1}

SWEP.AttackDelay            = 4

SWEP.SAttackDelay            = 100

SWEP.Weight				= 3

SWEP.AutoSwitchTo		= false

SWEP.AutoSwitchFrom		= false

SWEP.Slot					= 0

SWEP.SlotPos				= 4

SWEP.DrawAmmo			= false

SWEP.DrawCrosshair		= true

SWEP.ViewModel			= ""

SWEP.WorldModel			= ""

SWEP.NextAttackW            = 0

SWEP.HoldType 			= "normal"







SWEP.Lang = nil



function SWEP:Initialize()



	self:SetHoldType(self.HoldType)



end



function SWEP:Deploy()



end



function SWEP:Holster()

    self:OnRemove()

	return true

end







function SWEP:Think()

	if !SERVER then return end





end



SWEP.NextPrimary = 0



function SWEP:PrimaryAttack()

	if preparing or postround then return end





    local trace = self.Owner:GetEyeTrace()

	local e = trace.Entity

	if not IsFirstTimePredicted() then return end

	if !e:IsPlayer() then return end

	if self.NextAttackW > CurTime() then return end

    self.NextAttackW = CurTime() + self.AttackDelay

	if !SERVER then return end











	if e:GTeam() == TEAM_SCP then return end

	if e:GTeam() == TEAM_SPEC then return end

	if e:GTeam() == TEAM_DZ then return end

	if e:GetNWBool("scared") == true then return end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) < 100 then

		self:GetOwner():AddExp(11, false)

	    timer.Create( "Scaryplayer", 0.5, 1, function()

		    e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

			e:TakeDamage( 80, self.Owner, self.Owner  )

			e:SetNWBool("scared", true)

		--	e:Freeze( true )

		    timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)



			timer.Simple(10, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) e:Freeze( false ) end end)



	end )

	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 150 and trace.HitPos:Distance(self.Owner:GetShootPos()) < 200 then

		self:GetOwner():AddExp(10, false)

	    timer.Create( "Scaryplayer2", 0.5, 1, function()

		    e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

            e:TakeDamage( 75, self.Owner, self.Owner  )

			e:SetNWBool("scared", true)

			--e:Freeze( true )

			timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) e:Freeze( false ) end end)



	end )



	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 200 and trace.HitPos:Distance(self.Owner:GetShootPos()) < 250 then

		self:GetOwner():AddExp(9, false)

	    timer.Create( "Scaryplayer3", 0.5, 1, function()

		    e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

            e:TakeDamage( 70, self.Owner, self.Owner  )

			e:SetNWBool("scared", true)

			--e:Freeze( true )

			timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) e:Freeze( false ) end end)



	end )

	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 250 and trace.HitPos:Distance(self.Owner:GetShootPos()) < 300 then

		self:GetOwner():AddExp(8, false)

	    timer.Create( "Scaryplayer4", 0.5, 1, function()

		    e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

            e:TakeDamage( 65, self.Owner, self.Owner  )

			e:SetNWBool("scared", true)

			--e:Freeze( true )

			timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) e:Freeze( false ) end end)



	end )

	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 300 and trace.HitPos:Distance(self.Owner:GetShootPos()) < 350 then

		self:GetOwner():AddExp(7, false)

	    timer.Create( "Scaryplayer5", 0.5, 1, function()

		    e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

            e:TakeDamage( 60, self.Owner, self.Owner  )

			e:SetNWBool("scared", true)

			--e:Freeze( true )

			timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) e:Freeze( false ) end end)



	end )

	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 350 and trace.HitPos:Distance(self.Owner:GetShootPos()) < 400 then

		self:GetOwner():AddExp(6, false)

	    timer.Create( "Scaryplayer6", 0.5, 1, function()

		    e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

            e:TakeDamage( 55, self.Owner, self.Owner  )

			e:SetNWBool("scared", true)

			--e:Freeze( true )

			timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) e:Freeze( false ) end end)



	end )

	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 400 and trace.HitPos:Distance(self.Owner:GetShootPos()) < 450 then

		self:GetOwner():AddExp(5, false)

	    timer.Create( "Scaryplayer7", 0.5, 1, function()

		  e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

      e:TakeDamage( 20, self.Owner, self.Owner  )

		  e:SetNWBool("scared", true)

			timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) end end)



	end )

	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 450 and trace.HitPos:Distance(self.Owner:GetShootPos()) < 500 then

	self:GetOwner():AddExp(4, false)

	    timer.Create( "Scaryplayer8", 0.5, 1, function()

		  e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

      e:TakeDamage( 15, self.Owner, self.Owner  )

			e:SetNWBool("scared", true)

			timer.Simple(0.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) e:SetNWBool("scared", false) end end)



	end )

	end

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 500 then

	self:GetOwner():AddExp(3, false)

	    timer.Create( "Scaryplayer9", 0.5, 1, function()

		    e:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

            e:TakeDamage( 10, self.Owner, self.Owner  )



			timer.Simple(1, function() if e:IsValid() then e:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) e:SendLua( 'RunConsoleCommand( "stopsound" )' ) end end)



	end )

	end



end





SWEP.NextSecondary = 0

SWEP.Camera = nil



function SWEP:SecondaryAttack()

	if preparing or postround then return end

	if not IsFirstTimePredicted() then return end

	if self.NextSecondary > CurTime() then return end

	self.NextSecondary = CurTime() + self.SAttackDelay

	local findents = ents.FindInSphere( self.Owner:GetPos(), 100 )

	local foundplayers = {}

	for k,v in pairs(findents) do

		if v:IsPlayer() then

			if !(v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_SPEC or v:GTeam() == TEAM_DZ) then

				table.ForceInsert(foundplayers, v)

			end

		elseif v:GetClass() == "func_breakable" then

			if v.TakeDamage then

				v:TakeDamage( 100, self.Owner, self.Owner )

			end

		end

	end

	if #foundplayers > 0 then

		local fixednicks = "Под массовое проклятие попало: "

		if CLIENT then return end

		local numi = 0

		for k,v in pairs(foundplayers) do

			numi = numi + 1



			if numi == 1 then

				fixednicks = fixednicks .. v:Nick()

			elseif numi == #foundplayers then

				fixednicks = fixednicks .. " и " .. v:Nick()

			else

				fixednicks = fixednicks .. ", " .. v:Nick()

			end



            timer.Create( "Scaryplayerult", 0.5, 1, function()

		    v:SendLua([[surface.PlaySound('/nice_sound.ogg')]])

			v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]])

			v:SetNWBool("scared", true)

			v:Freeze( true )

            timer.Simple(0.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(0.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(1.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(2.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(3.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(4.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(5.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(6.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(7.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(8.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(9.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(10.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(10.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(10.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(10.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(10.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(11.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(11.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(11.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(11.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(11.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(12.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(12.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(12.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(12.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(12.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(13.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(13.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(13.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(13.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(13.9, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(14.1, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(14.3, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(14.5, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(14.7, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"juice/scary"..math.random(1,18).."\"")]]) end end)

			timer.Simple(15, function() if v:IsValid() then v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"\"");]]) v:SendLua( 'RunConsoleCommand( "stopsound" )' ) v:SetNWBool("scared", false) v:Freeze( false ) end end)

			v:TakeDamage( 95, self.Owner, self.Owner  )

            end)

		end

		self.Owner:PrintMessage(HUD_PRINTTALK, fixednicks)

	end

end



function SWEP:Reload()

	if preparing or postround then return end

	if not IsFirstTimePredicted() then return end

	--

end



function SWEP:OnRemove()



end



function SWEP:DrawHUD()

	if disablehud == true then return end



	local showtext = "Готова наложить проклятие на игрока"

	local showcolor = Color(0,255,0)

	local kok = "Готова использовать массовое проклятие"

	local kek = Color(138, 43, 226)

	if self.NextAttackW > CurTime() then

        showtext = "Проклятие восстановится через " .. math.Round(self.NextAttackW - CurTime())

        showcolor = Color(255,0,0)

    end

	if self.NextSecondary > CurTime() then

		kok = "Массовое проклятие будет готово через ".. math.Round(self.NextSecondary - CurTime())

		kek = Color(255,0,0)

	end



	draw.Text( {

		text = showtext,

		pos = { ScrW() / 2, ScrH() - 50 },

		font = "173font",

		color = showcolor,

		xalign = TEXT_ALIGN_CENTER,

		yalign = TEXT_ALIGN_CENTER,

	})

	draw.Text( {

		text = kok,

		pos = { ScrW() / 2, ScrH() - 30 },

		font = "173font",

		color = kek,

		xalign = TEXT_ALIGN_CENTER,

		yalign = TEXT_ALIGN_CENTER,

	})

end



