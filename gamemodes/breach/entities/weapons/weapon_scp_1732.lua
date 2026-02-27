--[[
gamemodes/breach/entities/weapons/weapon_scp_1732.lua
--]]
AddCSLuaFile()
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = "SCP-682"
SWEP.Author = "Varus"
--SWEP.Instructions = "Primary to attack, Secondary for an adrenaline rush."
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.UseHands = false
--SWEP.Contact = "uhh"
--SWEP.Purpose = "Murder"
SWEP.NextAttackH = 2
SWEP.NextAttackW = 30
SWEP.NextLunge = 30
SWEP.AttackDelay1 = 0.5
SWEP.AttackDelay2 = 65
SWEP.ISSCP = true
SWEP.teams					= {1}
SWEP.IsFaster = false
SWEP.BoostEnd = 0
SWEP.droppable	= false


SWEP.DrawRed = 0



scp_toggleLight_cooldown = 0
function SWEP:Reload()
	if scp_toggleLight_cooldown >= CurTime() then return end
	if self.toggleLight then
		self.toggleLight = false
	else
		self.toggleLight = true
	end
	scp_toggleLight_cooldown = CurTime() + 2
end


function SWEP:Deploy()
	self.Owner:SetNWBool("Rage682", false)
	self.Owner:SetNWBool("Ending", false)
	self.Owner:DrawViewModel( false )
	self.Owner:SetWalkSpeed(60)
	self.Owner:SetRunSpeed(60)
	self.Owner:SetMaxSpeed(60)
	self.Owner:SetJumpPower(0)
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("knife")
end
function SWEP:Think()
  if self.Owner:Health() <= 17000 and self.Owner:Health() > 14000 and self.Owner:GetNWBool("Rage682") == false and self.Owner:GetNWBool("Ending") == false then
		self.Owner:SetRunSpeed(60)
	end
	if self.Owner:Health() <= 14000 and self.Owner:Health() > 12000 and self.Owner:GetNWBool("Rage682") == false and self.Owner:GetNWBool("Ending") == false then
		self.Owner:SetRunSpeed(80)
		self.Owner:SetWalkSpeed(70)
	end
	if self.Owner:Health() <= 12000 and self.Owner:Health() > 10000 and self.Owner:GetNWBool("Rage682") == false and self.Owner:GetNWBool("Ending") == false then
		self.Owner:SetRunSpeed(100)
		self.Owner:SetWalkSpeed(90)
	end
	if self.Owner:Health() <= 10000 and self.Owner:Health() > 8000 and self.Owner:GetNWBool("Rage682") == false and self.Owner:GetNWBool("Ending") == false then
		self.Owner:SetRunSpeed(120)
		self.Owner:SetWalkSpeed(110)
	end
	if self.Owner:Health() <= 7000 and self.Owner:Health() > 4000 and self.Owner:GetNWBool("Rage682") == false and self.Owner:GetNWBool("Ending") == false then
		self.Owner:SetRunSpeed(140)
		--self.Owner:SetJumpPower( 200 )
		self.Owner:SetWalkSpeed(130)
	end
	if self.Owner:Health() <= 4000 and self.Owner:Health() > 2000 and self.Owner:GetNWBool("Rage682") == false and self.Owner:GetNWBool("Ending") == false then
		self.Owner:SetRunSpeed(150)
		self.Owner:SetWalkSpeed(140)
	end
	if self.Owner:Health() <= 2000 and self.Owner:Health() > 0 and self.Owner:GetNWBool("Rage682") == false then
		self.Owner:SetRunSpeed(185)
    self.Owner:SetWalkSpeed(185)
		for i=1, 1 do
			--BroadcastLua([[surface.PlaySound("sfx/Ending/GateB/682Battle.mp3")]])
			--self.Owner:SetModelScale(self.Owner:GetModelScale() * 1.2, 5);
			timer.Simple(0.2, function()
			for k,v in pairs(player.GetAll()) do
			  --v:SetNWBool("Ragefrom",false)
			end
		  end)
			timer.Simple(0.5, function()
			for k,v in pairs(player.GetAll()) do
			  --v:SetNWBool("Ragefrom",true)
				v:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 158 ), 0.3, 8 )
				--BroadcastLua([[surface.PlaySound("sfx/Radio/static.mp3")]])
			end
		  end)
			timer.Simple(10, function()
			for k,v in pairs(player.GetAll()) do
			  --v:SetNWBool("Ragefrom",false)
				v:SetDSP(0)
			end
		  end)
			for k,v in pairs(player.GetAll()) do
				if SERVER then
				  --v:SendLua('util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 8, 5000 )')
				end
				if CLIENT then
					local blur = Material("pp/blurscreen")
				  hook.Add( "RenderScreenspaceEffects", "DeathEffectFromRO2", function()
				    if LocalPlayer():GetNWBool("Ragefrom") == true then
				      DrawMotionBlur( 0.27, 0.5, 0.01 )
				      DrawSharpen( 1,2 )
				      DrawToyTown( 3, ScrH() / 1.8 )
				      ply:SetDSP(47)

				      local W = ScrW()
				      local H = ScrH()

				      surface.SetMaterial(blur)
				      surface.SetDrawColor(255, 255, 255, 255)

				      for i = 0.33, 2, 0.33 do
				        blur:SetFloat("$blur", 2 * i)
				        blur:Recompute()
				        render.UpdateScreenEffectTexture()
				        surface.DrawTexturedRect(0, 0, W, H)
				      end
				    end
				  end)
				end
				local function draw_fog()
			       local ply = LocalPlayer()
			                  if ply:GetNWBool("Ragefrom") == false then return end
			                  --if not ply:IsFlying() or ply ~= me then return end

			                  render.SetFogZ(5)
			                  render.FogMode(1)
			                  render.FogStart(0)
			                  render.FogEnd(256)
			                  render.FogMaxDensity(0.999)

			                  local c = render.GetLightColor(ply:EyePos())

			                  c.r = c.r * 0
			                  c.g = c.g * 0
			                  c.b = c.b * 0

			                  c = c * 255

			                  render.FogColor(c.r, c.g, c.b)

			                  return true
			          end

			          hook.Add("SetupSkyboxFog", "water", function()
			                  return draw_fog()
			          end)

			          hook.Add("SetupWorldFog", "water", function()
			                  return draw_fog()
			          end)
			end
		end
    self.Owner:SetNWBool("Rage682", true)
		self.Owner:SetNWBool("Ending", true)
	end
end

function SWEP:Reload()
end
function SWEP:PrimaryAttack()
	if self.NextAttackH > CurTime() then return end
	self.NextAttackH = CurTime() + self.AttackDelay1
	if SERVER then
		local ent = nil
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 ),
			filter = self.Owner,
			mins = Vector( -20, -20, -20 ),
			maxs = Vector( 20, 20, 20 ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				if ent:GTeam() == TEAM_DZ then return end
				ent:TakeDamage( 1200, self.Owner, self.Owner )
				if self.Owner:GetNWBool("Ending") == true then
				  self.Owner:SetHealth(math.Clamp( self.Owner:Health() + ent:GetMaxHealth(), 0, 17000 ))
					self.Owner:SetNWInt("EXP", self.Owner:GetNWInt("EXP") + 2)
				end
				--self.Owner:AddExp(50, true)
				ent:EmitSound("scp_sounds/096_kill.mp3", 500, 100)
        self.Owner:SetNWInt("EXP", self.Owner:GetNWInt("EXP") + 1)
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				elseif ent:IsNPC() then
					ent:TakeDamage( 20000, self.Owner, self.Owner )

				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then

						ent:TakeDamage( math.Round(math.random(20,25)), self.Owner, self.Owner )


						ent:EmitSound("door_break.wav")
					end
				end

			end
		end
	end
end
local NextChat = 2
local NextChatvalue = 0
function SWEP:SecondaryAttack()
  if self.Owner:GetNWBool("Ending") == false then
	if self.NextAttackW > CurTime() then
		if NextChatvalue > CurTime() then return end
		NextChatvalue = CurTime() + NextChat
		if CLIENT then
			chat.AddText(Color(255,255,255), "Перезарядка, осталось ", Color(255, 35, 35), math.Round(self.NextAttackW - CurTime()), Color(255,255,255), " секунд")
    end
		return
	end

	self.NextAttackW = CurTime() + self.AttackDelay2
	local ply = self.Owner

  BroadcastLua([[surface.PlaySound("roar.ogg")]])
	ply:SetWalkSpeed(350)
	ply:SetNWBool("Rage682",true)
	--ply:SetModelScale(4, 6);
	ply:SetRunSpeed(350)
	ply:SetMaxSpeed(350)

	ply:SetJumpPower(0)

	local function RemoveBuff()
		ply:SetNWBool("Rage682",false)
		ply:SetWalkSpeed(60)
		ply:SetRunSpeed(60)
		ply:SetMaxSpeed(60)
		--ply:SetJumpPower(0)
	end
	timer.Create("SCP_PLAYER_WILL_LOSE_BUFF" ..self.Owner:SteamID(), 10, 1, RemoveBuff)
  end

end
function SWEP:DrawHUD()
	local showtext = "SPECIAL ATTACK READY!"
	local showcolor = Color(50, 205, 50)
	if self.NextAttackW > CurTime()  then
		showtext = "RELOADING " ..math.Round(self.NextAttackW - CurTime())
		showcolor = Color(255, 0, 0)
	end
	if self.Owner:GetNWBool("Ending") == true then
		showtext = "KILL EM ALL"
		showcolor = Color(255, 0, 0)
	end
	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 50 },
		font = "char_titleescape",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end

local NextBreachded = 0
local cdNextBreachded = 5
function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end


	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end


    local ent = self.Owner:GetEyeTrace().Entity
	if NextBreachded > CurTime() then return end
	NextBreachded = CurTime() + cdNextBreachded
    if ent:GetClass() == 'prop_dynamic' then
		if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then
			if SERVER then
			  ent:TakeDamage( math.Round(math.random(50,80)), self.Owner, self.Owner )
			end

			ent:EmitSound("door_break.wav")

		elseif string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
		  if SERVER then
		    ent:TakeDamage( math.Round(math.random(60,90)), self.Owner, self.Owner )
		 end

		 ent:EmitSound("door_break.wav")
		end
	end


end


