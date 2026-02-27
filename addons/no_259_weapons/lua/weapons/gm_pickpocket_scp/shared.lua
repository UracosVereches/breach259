--[[
lua/weapons/gm_pickpocket_scp/shared.lua
--]]
SWEP.PrintName = "Кража"

--SWEP.Purpose = "Stealing money or weapons from other players"
----SWEP.Instructions = "Primary attack: steal active weapon\nSecondary attack: steal money\nMash mouse1 while pickpocketing: speed up pickpocket"
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/pickpocket")
	SWEP.BounceWeaponIcon = false
end


SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.droppable = false
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Slot               = 1
SWEP.SlotPos 			= 10
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = false

SWEP.Cooldown = 0

-- Configuration
SWEP.PickpocketDuration = 3 -- Time it takes to successfully pickpocket a player
SWEP.PickpocketDistance = 64 -- How close the player has to stand to the other player to successfully pickpocket
SWEP.PickpocketFailureChance = 0 -- How often should a pickpocket "fail" at random?
SWEP.PickpocketCooldown = 1 -- Amount of time in seconds that a player has to wait before they can pickpocket again
SWEP.AllowPickpocketSpeedup = false -- Should the pickpocket speed up if the player mashes mouse1?
SWEP.SpeedUpIncrement = 0.2 -- How much time to take away from the timer if the player is mashing.
SWEP.AllowWeaponPickpocket = true -- Should we let the player pickpocket weapons?
SWEP.BannedWeapons = { "weapon_scp_0497", "weapon_scp_1068", "scp_cannibal", "weapon_scp_1737", "weapon_scp_4578", "weapon_scp_682", "weapon_scp_9668", "weapon_scp_1049a", "weapon_katana", "doctor", "weapon_kleyto", "weapon_scp_1732", "br_holster", "br_id", "weapon_scp_939", "v92_eq_unarmed", "gm_pickpocket_scp", "big_black_hands", "hacking_doors"} -- Weapons that should not be pickpocketed
SWEP.BannedJobs = { } -- Jobs that should not be pickpocketed
SWEP.AllowMoneyPickpocket = false -- Should we let the player pickpocket money?
SWEP.PickpocketReward = 0.1 -- % of money stolen on successful pickpocket.
SWEP.PickpocketMax = 2000 -- Maximum amount of money that can be stolen
SWEP.AllowInventoryPickpocket = false -- Should we let the player pickpocket from inventories if ItemStore is installed?
SWEP.SoundFrequency = 1 -- How often the "rummmaging" sounds play, in seconds.
SWEP.DarkRP25 = false -- Set this to true if you are running DarkRP 2.5.0
-- End of configuration

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Pickpocketing" )
	self:NetworkVar( "String", 0, "PickpocketMode" )
	self:NetworkVar( "Float", 0, "PickpocketTime" )
	self:NetworkVar( "Entity", 0, "PickpocketTarget" )
end

function SWEP:Initialize()
	self:SetWeaponHoldType( "normal" )
end

function SWEP:CanPickpocket( target )
	return IsValid( target ) and target:IsPlayer() and not table.HasValue( self.BannedJobs, target:Team() ) and target:GetPos():Distance( self.Owner:GetPos() ) < self.PickpocketDistance
end

function SWEP:StartCooldown()
	self.Cooldown = CurTime() + self.PickpocketCooldown
end

function SWEP:Pickpocket( target, mode )
	self:SetPickpocketing( true )
	self:SetPickpocketTime( CurTime() + self.PickpocketDuration )
	self:SetPickpocketTarget( target )
	self:SetPickpocketMode( mode )

	self:StartCooldown()
end
local ProcessStartTime = 0
function SWEP:PrimaryAttack()
	local target = self.Owner:GetEyeTrace().Entity

	if target:IsPlayer() then
		if target:GTeam() == TEAM_SCP then
			if SERVER then
				self.Owner:RXSENDWarning("Вы не можете украсть у этого игрока")
			end
			return
		end

		if IsValid(target:GetActiveWeapon()) then
			if table.HasValue(self.BannedWeapons, target:GetActiveWeapon():GetClass()) then
				if SERVER then
					self.Owner:RXSENDWarning("Вы не можете украсть у этого игрока")
				end
				return
			end
		else
			if SERVER then
				self.Owner:RXSENDWarning("Игрок в данный момент ничего с собой не имеет!")
			end
			return
		end
	
		if target:GTeam() == TEAM_SPEC then
			return
		end
	end

	if ( self.Owner:GetPos():Distance( target:GetPos() ) < self.PickpocketDistance ) then
		if ( self:GetPickpocketing() ) then
			if ( self.AllowPickpocketSpeedup ) then
				self:SetPickpocketTime( self:GetPickpocketTime() - self.SpeedUpIncrement )
			end
		else
			if ( self.AllowWeaponPickpocket and self:CanPickpocket( target ) and self.Cooldown < CurTime() ) then
				ProcessStartTime = RealTime()
				self:Pickpocket( target, "weapon" )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	if ( itemstore ) then
		local target = self.Owner:GetEyeTrace().Entity

		if ( self.Owner:GetPos():Distance( target:GetPos() ) < self.PickpocketDistance ) then
			if ( self.AllowInventoryPickpocket and not self:GetPickpocketing() and self:CanPickpocket( target ) and self.Cooldown < CurTime()  ) then
				self:Pickpocket( target, "inventory" )
			end
		end
	end
end
local red, green = 255, 0
local curtime = RealTime() + 9
if SERVER then
	AddCSLuaFile()

	local NextSound = 0
	function SWEP:Think()
		if ( self:GetPickpocketing() ) then
			local target = self:GetPickpocketTarget()

			if ( not self:CanPickpocket( target ) or self.Owner:GetEyeTrace().Entity ~= target ) then
				self:SetPickpocketing( false )
			else
				if ( NextSound < CurTime() ) then
					--self.Owner:EmitSound( "physics/body/body_medium_impact_soft" .. math.random( 1, 7 ) .. ".wav" )
					NextSound = CurTime() + self.SoundFrequency
				end

				if ( self:GetPickpocketTime() < CurTime() ) then
					self:SetPickpocketing( false )

					if ( math.Rand( 0, 1 ) > self.PickpocketFailureChance ) then
						if ( self:GetPickpocketMode() == "weapon" ) then
							local wep = target:GetActiveWeapon()

							if ( IsValid( wep ) ) then
								local class = wep:GetClass()

								if ( not table.HasValue( self.BannedWeapons, class ) ) and target:GTeam() != TEAM_SCP then
									timer.Simple(0.5, function() self.Owner:SetNWBool("Thief", true) end)
									timer.Simple(0.7, function() self.Owner.JustSpawned = true self.Owner:Give( class ) self.Owner.JustSpawned = false end)
									timer.Simple(0.8, function() self.Owner:SetNWBool("Thief", false) end)
									target:StripWeapon(	class )

									self.Owner:RXSENDNotify("Успешно украдено " .. wep.PrintName .. ".")
								else
									self.Owner:RXSENDWarning("Вы не можете украсть у этого игрока")
								end
							else
								self.Owner:RXSENDWarning("Игрок в данный момент ничего с собой не имеет!")
							end
						end
					else
						self.Owner:RXSENDWarning("Неудача!")
					end
				end
			end
		end
	end

	function SWEP:Holster()
		self:SetPickpocketing( false )
		return true
	end
else
	local gradientup = Material( "gui/gradient_up" )
	local gradientdown = Material( "gui/gradient_down" )

	function SWEP:DrawProgressBar( label, colour, filled )
		filled = math.Clamp( filled, 0, 1 )
		local w, h = 300, 20
		local centerx, centery = ScrW() / 2, ScrH() / 2
		local x, y = centerx - w / 2, centery - h / 2

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawOutlinedRect( x, y, w, h )



		surface.SetDrawColor( Color( 30, 0, 120 ) )
		surface.SetMaterial( gradientup )
		surface.DrawTexturedRect( x + 2, y + 2, w * filled, h - 4 )
		draw.SimpleTextOutlined( label, "DermaDefaultBold", centerx, centery - 1, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
	end

	function SWEP:DrawHUD()

		if ( self:GetPickpocketing() ) then

			local wid = ScrW() / 3
			local hei = ScrH() / 30
			local width = 0
			local timeleft = math.Round( curtime - RealTime() )
			local proccesingtext = "Процесс кражи...."
			width = ( ( RealTime() - ProcessStartTime ) / 5.6 ) * 1200
			surface.SetDrawColor( 30, 30, 30, 150 )
			surface.DrawRect( ScrW() * 0.5 - wid * 0.5, ScrH() / 2, wid, hei )
			if width >= 640 then
				width = 640
				proccesingtext = "Завершено!"
			end
			surface.SetDrawColor( red, green, 0, 255)
			red = 255/(width/150)
			green = (width/3)
			--surface.SetDrawColor( Color( 30, 0, 120 ) )
			surface.SetMaterial( gradientdown )
			surface.DrawTexturedRect( ScrW() * 0.5 - wid * 0.5, ScrH() / 2, width, hei )

			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( ScrW() * 0.5 - wid * 0.5, ScrH() / 2, wid, hei )
			surface.DrawOutlinedRect( ScrW() * 0.5 - wid * 0.5, ScrH() / 2, wid, hei )
			draw.SimpleText( proccesingtext, "Cyb_HudTEXT", ScrW() * 0.5, ScrH() / 1.95, Color( 255, 255, 255, 255 ), 1, 1 )
		end
	end
end


