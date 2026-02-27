--[[
lua/weapons/medicmedkitfirst/shared.lua
--]]
AddCSLuaFile()
--Breach Update 2.5.9-C #2 (Balance Patch-Note)
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/first_aid2")
	SWEP.BounceWeaponIcon = false
end

if SERVER then
	util.AddNetworkString("CloseProgressBarfirst")
	util.AddNetworkString("ReloadingprogressMedkitfirst")
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.WorldModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.PrintName		= "Аптечка первой помощи"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.Uses					= 1
SWEP.droppable				= true
SWEP.teams					= {2,3,5,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self:GetOwner():DrawViewModel( false )
end
function SWEP:DrawWorldModel()
	if !IsValid(self:GetOwner()) then
		self:DrawModel()
	end
end

SWEP.Lang = nil
function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 1, "HealStartTime" )
	if SERVER then
  	self:SetHealStartTime( 0 )
	end
end
function SWEP:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	if CLIENT then
		self.Lang = GetWeaponLang().MEDKIT
	end
	self:SetHoldType(self.HoldType)
	self:SetSkin( 1 )
end
function SWEP:Think()
	if self:GetOwner():KeyDown( IN_FORWARD ) or self:GetOwner():KeyDown( IN_BACK ) or self:GetOwner():KeyDown( IN_MOVERIGHT ) or
			self:GetOwner():KeyDown( IN_MOVELEFT ) or self:GetOwner():KeyDown( IN_JUMP ) or self:GetOwner():IsOnFire() or self:GetOwner():KeyDown( IN_DUCK ) or not self:GetOwner():OnGround() then
			if timer.Exists("Healingyourself" ..self:GetOwner():SteamID()) then
				if SERVER then
					self:GetOwner():TipSendWarning("Вы прервали своё лечение.")
					net.Start("CloseProgressBarfirst")
					net.Send(self:GetOwner())
				end
				timer.Remove("Checkplayerpositionh" ..self:GetOwner():SteamID())
				timer.Remove("Healingyourself" ..self:GetOwner():SteamID())
			end




			return
	end
end
function SWEP:Reload()
end
local delay = 0
local delayforuse = 2
function SWEP:PrimaryAttack()
	if delay > CurTime() then return end

	delay = CurTime() + delayforuse
	if self:GetOwner():IsOnFire() then
		if SERVER then
			self:GetOwner():TipSendWarning("Вы в огне!")
		end
		return
	end
	--self:SetHealStartTime( CurTime() )
	if self:GetOwner():Health() / self:GetOwner():GetMaxHealth() <= 0.8 then
		--self.Uses = self.Uses - 1
		if timer.Exists("Healingyourself" ..self:GetOwner():SteamID()) then
			if SERVER then
				self:GetOwner():TipSendWarning("Вы и так уже лечитесь.")
			end
			return
		end
		if SERVER then
			--self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth())

			self:GetOwner():TipSendNotify("Вы начали процесс лечения")
			net.Start("ReloadingprogressMedkitfirst")
			net.Send(self:GetOwner())
		end
		timer.Create("CheckMedkitinhands" ..self:GetOwner():SteamID(), 0.2, 22, function()
			--print("Working")
			if IsValid(self:GetOwner():GetActiveWeapon()) then
				if self:GetOwner():GetActiveWeapon():GetClass() != "medicmedkitfirst" then
					if SERVER then
						self:GetOwner():TipSendWarning("Вы прервали свое лечение")
						net.Start("CloseProgressBarfirst")
						net.Send(self:GetOwner())
						timer.Remove("CheckMedkitinhands" ..self:GetOwner():SteamID())
						timer.Remove("Healingyourself" ..self:GetOwner():SteamID())
					end
				end
			end
		end)

		timer.Create("Healingyourself" ..self:GetOwner():SteamID(), 5.4, 1, function()
			self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth())
			self.Uses = self.Uses - 1
			if SERVER then

				net.Start("CloseProgressBar")
				net.Send(self:GetOwner())

				self:GetOwner():TipSendGood("Лечение завершено, ваше здоровье: " ..self:GetOwner():Health())
				self:GetOwner():ScreenFade(SCREENFADE.IN,Color(255, 255, 255, 120),2,1)
				if self.Uses < 1 then
					self:GetOwner():StripWeapon("medicmedkitfirst")

				end
			end
		end)
	else
		if SERVER then

			self:GetOwner():TipSendWarning("Вы не нуждаетесь в лечении")
		end
	end
end
function SWEP:SecondaryAttack()
	if delay > CurTime() then return end

	delay = CurTime() + delayforuse
	--if SERVER then
		local ent = self:GetOwner():GetEyeTrace().Entity
		if ent:IsPlayer() then
			if ent:GTeam() == TEAM_SCP then return end
			if ent:GTeam() == TEAM_SPEC then return end
			if ent:IsOnFire() then
				if SERVER then
					self:GetOwner():TipSendWarning("Игрок в огне!")
				end
				return
			end
			if ent:Health() / ent:GetMaxHealth() > 0.8 then
				if SERVER then
					self:GetOwner():TipSendWarning("В данный момент этот игрок не нуждается в лечении")
				end
			end
			if(ent:GetPos():Distance(self:GetOwner():GetPos()) < 95) and ent:Health() / ent:GetMaxHealth() <= 0.8 then
				if SERVER then
					net.Start("ReloadingprogressMedkitfirst")
					net.Send(self:GetOwner())
					ent:TipSendNotify("Подождите, вас лечит игрок " ..self:GetOwner():Nick())
				end
				timer.Create("CheckMedkitinhands" ..self:GetOwner():SteamID(), 0.2, 30, function()
					--print("Working")
					if self:GetOwner():GetActiveWeapon():GetClass() != "medicmedkitfirst" then
						if SERVER then
							self:GetOwner():TipSendWarning("Вы прервали лечение")
							net.Start("CloseProgressBarfirst")
							net.Send(self:GetOwner())
							timer.Remove("CheckMedkitinhands" ..self:GetOwner():SteamID())
							timer.Remove("Healingyourself" ..self:GetOwner():SteamID())
						end
					end
				end)
				timer.Create("Checkplayerpositionh" ..self:GetOwner():SteamID(), 0.2, 40, function()
					--print("kok")
					if (ent:GetPos():Distance(self:GetOwner():GetPos()) > 95) then
						--print("Closed")
						if SERVER then
							net.Start("CloseProgressBarfirst")
							net.Send(self:GetOwner())
						end
						timer.Remove("Healingyourself" ..self:GetOwner():SteamID())
						timer.Remove("Checkplayerpositionh" ..self:GetOwner():SteamID())
					end
				end)

				timer.Create("Healingyourself" ..self:GetOwner():SteamID(), 6.4, 1, function()
					ent:SetHealth(ent:GetMaxHealth())
					self.Uses = self.Uses - 1
					timer.Remove("Checkplayerpositionh" ..self:GetOwner():SteamID())
					if SERVER then
						--self.Uses = self.Uses - 1
						self:GetOwner():TipSendGood("Лечение союзника завершено!")
						ent:TipSendGood("Вы чувствуете себя лучше")
						ent:ScreenFade(SCREENFADE.IN,Color(255, 255, 255, 120),2,1)
						ent:EmitSound("vo/npc/male01/uhoh.wav")
						if self.Uses < 1 then
							self:GetOwner():StripWeapon("medicmedkitfirst")

						end
					end
					--timer.Remove("Checkplayerposition" ..self:GetOwner():SteamID())
					net.Start("CloseProgressBar")
					net.Send(self:GetOwner())
				end)
			end
		end
	--end
end
function SWEP:CanPrimaryAttack()
end
local progress = 0
function SWEP:DrawHUD()
	local hudWidth,hudHeight = 300,150
	local x,y = 10,ScrH()-hudHeight-10

	--Medic BackGround--
	--surface.SetDrawColor(255,	255,	255,	180) --Background Color
	--surface.SetMaterial(Material("good.png"))
	--surface.DrawTexturedRect(500,	ScrH() - 110,	100+4 , 100 + 4)
	local clr = Color(40,40,40,200) --Box Medic Color
	--Box Medic--
	  draw.RoundedBox(1,500,ScrH() - 110,100+4 , 100 + 4,	clr) --here clr
	--Outlined Box--
		surface.SetDrawColor( 0, 0, 0, 255 )
	 	surface.DrawOutlinedRect( 500,	ScrH() - 110,	100+4 , 100 + 4 )
		surface.SetDrawColor( 0, 0, 0, 255 )
	 	surface.DrawOutlinedRect( 501,	ScrH() - 111,	101+3 , 102 + 4 )
	--Delay--

	--Medic Box inside Box--
		surface.SetDrawColor(0,	0,	0,	255) --Box Color
		surface.SetMaterial(Material("hpi.png"))
		surface.DrawTexturedRect(524,	ScrH() - 91,	51+3 , 52 + 4)

	--Line under Box--
		surface.SetDrawColor(0,	0,	0,	255) --Box Color
		surface.DrawOutlinedRect( 502,	ScrH() - 29,	51+50 , 0 )
	--Value of the medic packs
		local valuetext = math.Round(self.Uses)
		draw.Text( {
			text = valuetext,
			pos = { ScrW() / 3.49, ScrH() - 17 },
			font = "HUDFont",
			color = showcolor,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		})
		--progressbar = Lerp(0.1, 1, pb_status)
		--Reloadingprogress = math.Min(progressbar / 10, 1)

		if delay > CurTime() then


			if !timer.Exists("Reloadingprogress" ..self:GetOwner():SteamID()) then
				timer.Create("Reloadingprogress" ..self:GetOwner():SteamID(), 0.001, 0, function()
					progress = progress + 2.55
					if progress > 102 then
						progress = 0
						timer.Remove("Reloadingprogress" ..self:GetOwner():SteamID())
					end
				end)
			end
			--progress = Lerp(10 * FrameTime(), 0 , 2.06)

			--print(progress)
			surface.SetDrawColor(255,	255,	255,	180) --Box Color
			surface.SetMaterial(Material("redspell.png"))
			surface.DrawTexturedRect(501,	ScrH() - 111,	0 + progress, 102 + 4)

		end
		if delay < CurTime() then
			if timer.Exists("Reloadingprogress" ..self:GetOwner():SteamID()) then
				progress = 0
				timer.Remove("Reloadingprogress" ..self:GetOwner():SteamID())
				--print(progress)
			end
		end

end


