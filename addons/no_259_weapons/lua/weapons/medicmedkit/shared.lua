--[[
lua/weapons/medicmedkit/shared.lua
--]]
AddCSLuaFile()
--Breach Update 2.5.9-C #2 (Balance Patch-Note)
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/first_aid")
	SWEP.BounceWeaponIcon = false
end

if SERVER then
	util.AddNetworkString("CloseProgressBar")
	util.AddNetworkString("ReloadingprogressMedkit")
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.WorldModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.PrintName		= "Аптечка спец.помощи"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.Uses					= 3
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
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
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
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVERIGHT ) or
			self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_JUMP ) or self.Owner:IsOnFire() or self.Owner:KeyDown( IN_DUCK ) or not self.Owner:OnGround() then
			if timer.Exists("Healingyourself" ..self.Owner:SteamID()) then
				if SERVER then
					self.Owner:TipSendWarning("Вы прервали свое лечение")
					net.Start("CloseProgressBar")
					net.Send(self.Owner)
				end
				timer.Remove("Checkplayerpositionh" ..self.Owner:SteamID())
				timer.Remove("Healingyourself" ..self.Owner:SteamID())
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
	if self.Owner:IsOnFire() then
		if SERVER then
			self.Owner:TipSendWarning("Вы в огне!")
		end
		return
	end
	--self:SetHealStartTime( CurTime() )
	if self.Owner:Health() / self.Owner:GetMaxHealth() <= 0.8 then
		--self.Uses = self.Uses - 1
		if timer.Exists("Healingyourself" ..self.Owner:SteamID()) then
			if SERVER then
				self.Owner:TipSendWarning("Вы и так уже лечитесь")
			end
			return
		end
		if SERVER then
			--self.Owner:SetHealth(self.Owner:GetMaxHealth())

			self.Owner:TipSendNotify("Вы начали процесс лечения")
			net.Start("ReloadingprogressMedkit")
			net.Send(self.Owner)
		end

		timer.Create("CheckMedkitinhands" ..self.Owner:SteamID(), 0.2, 30, function()
			--print("Working")
			if self.Owner:GetActiveWeapon():GetClass() != "medicmedkit" then
				if SERVER then
					self.Owner:TipSendWarning("Вы прервали свое лечение")
					net.Start("CloseProgressBar")
					net.Send(self.Owner)
					timer.Remove("CheckMedkitinhands" ..self.Owner:SteamID())
					timer.Remove("Healingyourself" ..self.Owner:SteamID())
				end
			end
		end)
		timer.Create("Healingyourself" ..self.Owner:SteamID(), 6.4, 1, function()
			self.Owner:SetHealth(self.Owner:GetMaxHealth())
			self.Uses = self.Uses - 1
			if SERVER then

				self.Owner:TipSendGood("Лечение завершено, ваше здоровье: "..self.Owner:Health())
				self.Owner:ScreenFade(SCREENFADE.IN,Color(255, 255, 255, 120),2,1)
				if self.Uses < 1 then
					self.Owner:StripWeapon("medicmedkit")

				end
			end
			--net.Start("CloseProgressBar")
			--net.Send(self.Owner)
		end)
	else
		if SERVER then

			self.Owner:TipSendWarning("Вы не нуждаетесь в лечении")
		end
	end
end
function SWEP:SecondaryAttack()
	if delay > CurTime() then return end

	delay = CurTime() + delayforuse
	--if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if ent:IsPlayer() then
			if ent:GTeam() == TEAM_SCP then return end
			if ent:GTeam() == TEAM_SPEC then return end
			if ent:IsOnFire() then
				if SERVER then
					self.Owner:TipSendWarning("Игрок в огне!")
				end
				return
			end
			if ent:Health() / ent:GetMaxHealth() > 0.8 then
				if SERVER then
					self.Owner:TipSendWarning("В данный момент этот игрок не нуждается в лечении")
				end
			end
			if(ent:GetPos():Distance(self.Owner:GetPos()) < 95) and ent:Health() / ent:GetMaxHealth() <= 0.8 then
				if SERVER then
					net.Start("ReloadingprogressMedkit")
					net.Send(self.Owner)
					ent:TipSendNotify("Подождите, вас лечит игрок " ..self.Owner:Nick())
				end
				timer.Create("Checkplayerpositionh" ..self.Owner:SteamID(), 0.2, 40, function()
					--print("kok")
					if (ent:GetPos():Distance(self.Owner:GetPos()) > 90) then
						print("Closed")
						if SERVER then
							net.Start("CloseProgressBar")
							net.Send(self.Owner)
						end
						timer.Remove("Healingyourself" ..self.Owner:SteamID())
						timer.Remove("Checkplayerpositionh" ..self.Owner:SteamID())
					end
				end)

				timer.Create("Healingyourself" ..self.Owner:SteamID(), 6.4, 1, function()
					ent:SetHealth(ent:GetMaxHealth())
					self.Uses = self.Uses - 1
					timer.Remove("Checkplayerpositionh" ..self.Owner:SteamID())
					if SERVER then
						--self.Uses = self.Uses - 1
						self.Owner:TipSendGood("Лечение союзника завершено!")
						ent:TipSend("Вы чувствуете себя лучше")
						ent:ScreenFade(SCREENFADE.IN,Color(255, 255, 255, 120),2,1)
						ent:EmitSound("vo/npc/male01/uhoh.wav")
						if self.Uses < 1 then
							self.Owner:StripWeapon("medicmedkit")

						end
					end
					--timer.Remove("Checkplayerposition" ..self.Owner:SteamID())
					--net.Start("CloseProgressBar")
					--net.Send(self.Owner)
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


			if !timer.Exists("Reloadingprogress" ..self.Owner:SteamID()) then
				timer.Create("Reloadingprogress" ..self.Owner:SteamID(), 0.001, 0, function()
					progress = progress + 2.55
					if progress > 102 then
						progress = 0
						timer.Remove("Reloadingprogress" ..self.Owner:SteamID())
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
			if timer.Exists("Reloadingprogress" ..self.Owner:SteamID()) then
				progress = 0
				timer.Remove("Reloadingprogress" ..self.Owner:SteamID())
				--print(progress)
			end
		end

end


