--[[
gamemodes/breach/entities/weapons/weapon_ttt_evolveknife/shared.lua
--]]
if SERVER then
   AddCSLuaFile( "shared.lua" )

end

CreateConVar( "ttt_evolve_maxenergy", 25, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Energy required for evolve ( def:4 )." )
CreateConVar( "ttt_evolve_st2health", 200, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Stage 2 player health ( def:200 )." )
CreateConVar( "ttt_evolve_st2walkspeed", 1.4, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Stage 2 walk spead ( def:1.4 )." )
CreateConVar( "ttt_evolve_st2swimspeed", 5, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Stage 2 swim spead ( def:5 )." )
CreateConVar( "ttt_evolve_st2leappower", 300, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Stage 2 leap power ( def:300 )." )
CreateConVar( "ttt_evolve_st2leapcooldown", 0.2, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Stage 2 leap cool down speed ( def:0.2 )." )
CreateConVar( "ttt_evolve_st2damage", 999, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Stage 2 primary damage ( def:999 )." )

if CLIENT then
	SWEP.PrintName 			= "SCP-062-FR"
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false

	SWEP.EquipMenuData 		= { type = "Weapon",
								desc = "Eat ".. GetConVar( "ttt_evolve_maxenergy" ):GetInt().." corpes.\nYou can evolve to stage 2." };

	SWEP.Slot      			= 7 -- add 1 to get the slot number key
	SWEP.ViewModelFOV  		= 54
	SWEP.ViewModelFlip 		= false
	SWEP.UseHands			= true
end

SWEP.Base					= "weapon_tttbase"

SWEP.HoldType				= "melee"

SWEP.Primary.Automatic   	= false
SWEP.Primary.Delay        = 1
SWEP.ISSCP = true
SWEP.Secondary.Automatic 	= false

SWEP.ViewModel 			 	= Model( "models/weapons/scp/scp_hunter_hands.mdl" )
SWEP.WorldModel 		 	= Model( "" )

SWEP.Kind 					= WEAPON_EQUIP2

SWEP.LimitedStock 			= false
SWEP.AllowDrop 				= true

SWEP.St2PlayerModel 		= Model( "models/player/stenli/lycan_werewolf.mdl" ) -- Stage 2 player world model
SWEP.SoundName 				= ""

sound.Add( { name = "evolve_eat1", level = 75, sound = Sound( "scp_sounds/scp_hunter/eating.mp3" ) } )
sound.Add( { name = "evolve_eat2", level = 150, sound = "scp_sounds/scp_hunter/eating.mp3" } )
sound.Add( { name = "evolve_eat3", level = 0, sound = "scp_sounds/scp_hunter/eating.mp3" } )
sound.Add( { name = "evolve_evolve", level = 0, sound = Sound( "evolve_evolve.wav") } )

local STATE_NONE, STATE_EAT, STATE_EVOLVING, maxEne, st2Health = 0, 1, 2, 0, 0
local CLAW_NOHIT, CLAW_HIT, CLAW_JUMP_0, CLAW_JUMP_1, RecastTime, JumpPower, ClawDamage = 0, 1, 0, 1, 0, 0, 0
function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "Energy" )
	self:NetworkVar( "Int", 1, "EvolveState" )
	self:NetworkVar( "Float", 1, "EvolveStartTime" )

	if SERVER then
		self:SetEnergy( 0 )
		self:SetEvolveState( STATE_NONE )
		self:SetEvolveStartTime( 0 )
	end
end
local Biomaska = false
function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self.Owner:SetNWInt("Eating", 0)
	self.Owner.Biomaska = true
	self.Owner.ThermalOn = false
	self.Owner:SetNWInt("trap", 0)
end

function SWEP:Equip()
	self.Owner.Biomaska = true
    self.Owner:SetNWInt("trap", 0)
end



function SWEP:OnDrop()
	self:Remove()
	self.Owner.Biomask = false
	ThermalReSetg()
	shitty = false
	LocalPlayer().ThermalOn = false
end
SWEP.NextPrimary = 0

function SWEP:OnRemove()
  self.Owner.Biomask = false

  --ThermalReSetg()
  shitty = false
  if CLIENT then
  	LocalPlayer().ThermalOn = false
	end
end
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end

	if self.NextPrimary > CurTime() then return end
	self.Owner:DoAnimationEvent(ACT_MELEE_ATTACK_SWING)

	timer.Create("turnoffinvisible", 0.01, 1, function()
		self.Owner:SetNoDraw(false)
        self.Owner:SetNWBool("hit",true)
		timer.Simple(3, function() self.Owner:SetNWBool("hit",false) end)
	end)
	self.Owner:SetNoDraw(false)

	self.NextPrimary = CurTime() + self.Primary.Delay
  self.Owner:EmitSound("scp_sounds/scp_hunter/attack_"..math.random(1,7)..".mp3")
  if SERVER then
  local ent = nil
  local tr = util.TraceHull({
  start = self.Owner:GetShootPos(),
  endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 75),
  mins = Vector(-10, -10, -10),
  maxs = Vector(10, 10, 10),
  filter = self.Owner,
  mask = MASK_SHOT,
  })
  ent = tr.Entity
  if IsValid(ent) then
    --print("kok")
		if ent:GTeam() == TEAM_SPEC then return end
		if ent:GTeam() == TEAM_SCP then return end
		if self:GetEnergy() >= 0 and self:GetEnergy() < 5 then
		    ent:TakeDamage( math.random( 30, 32 ), self.Owner, self.Owner )
        end
        if self:GetEnergy() >= 5 and self:GetEnergy() < 10 then
		    ent:TakeDamage( math.random( 45, 47 ), self.Owner, self.Owner )
        end
        if self:GetEnergy() >= 10 and self:GetEnergy() < 15 then
		    ent:TakeDamage( math.random( 55, 57 ), self.Owner, self.Owner )
        end
        if self:GetEnergy() >= 15 and self:GetEnergy() < 20 then
		    ent:TakeDamage( math.random( 60, 62 ), self.Owner, self.Owner )
        end
        if self:GetEnergy() >= 20 and self:GetEnergy() < 25 then
		    ent:TakeDamage( math.random( 80, 82 ), self.Owner, self.Owner )
        end
        if self:GetEnergy() == 25 then
		    ent:TakeDamage( math.random( 100, 102 ), self.Owner, self.Owner )
        end
		--self.Owner:EmitSound( "npc/antlion/shell_impact3.wav" )
		self.Owner:ViewPunch( table.Random( self.Angles ) )
	else
		if IsValid(ent) then
		if ent:GetClass() == "func_breakable" then
			ent:TakeDamage( 100, self.Owner, self.Owner )
			self.Owner:ViewPunch( table.Random( self.Angles ) )
		end
	end
	end
  end
  --
end

SWEP.Angles = { Angle( -10, -5, 0 ), Angle( 10, 5, 0 ), Angle( -10, 5, 0 ), Angle( 10, -5, 0 ) }

--[[function SWEP:NormalAttack( trace )
	local ent = tr.Entity

	if !IsValid( ent ) then return end

	self:SetNextSecondaryFire( CurTime() + 0.5 )


end]]

function SWEP:SecondaryAttack()


	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
		filter = self.Owner
	} )

	if IsValid( tr.Entity ) && tr.Entity:GetClass() == "prop_ragdoll" then


		local ply = player.GetByUniqueID( tr.Entity.uqid )

		if IsValid( ply ) && ply:Alive() then
			self.Owner:ChatPrint( "Это не тело." )
		elseif self:GetEnergy() < maxEne then
			self:Eat( tr.Entity )
			self.Owner:SetNoDraw(false)

			self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)

		else
			self.Owner:ChatPrint( "У вас полная энергия." )

		end
	end
end

function SWEP:Eat( ragdoll )
	if self:GetEnergy() == 0 then
		self.SoundName = "evolve_eat1"
	elseif self:GetEnergy() == 1 then
		self.SoundName = "evolve_eat2"
	elseif self:GetEnergy() >= 2 then
		self.SoundName = "evolve_eat3"
	end

	self.Owner:EmitSound( self.SoundName )

	self:SetEvolveState( STATE_EAT )
	self:SetEvolveStartTime( CurTime() )

	self.TargetRagdoll = ragdoll

	self:SetNextPrimaryFire( CurTime() + 5 )
end

function SWEP:FireError()
	self:SetEvolveState( STATE_NONE )

	self.Owner:StopSound( self.SoundName )

	timer.Remove( self.Owner:SteamID().. "EvolveAct" )

	self:SetNextPrimaryFire( CurTime() + 0.1 )
	self:SetNextSecondaryFire( CurTime() + 0.5 )
end



function SWEP:Stage2( ply )
	self:Remove()

	ply:SetModel( self.St2PlayerModel )
	ply:SetHealth( st2Health )

	ply:Give( "weapon_ttt_evolvest2" )
	ply:SelectWeapon( "weapon_ttt_evolvest2" )
end
local woops = false
local roff = false
function SWEP:Think()

	self.Owner:SetNoDraw(true)
	woops = true
	maxEne, st2Health = GetConVar( "ttt_evolve_maxenergy" ):GetInt(), GetConVar( "ttt_evolve_st2health" ):GetInt()
	if self.Owner:GetNWBool("hit",true) then
		self.Owner:SetNoDraw(false)
	end
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVERIGHT ) or
			self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_JUMP ) or self.Owner:KeyDown( IN_DUCK ) or not self.Owner:OnGround() or self.Owner:GetNWBool("hit",false)  then
			roff = false
            woops = false
			self.Owner:SetNoDraw(false)




			return
	end

	if self:GetEvolveState() == STATE_EAT then
		roff = true
		self.Owner:SetNoDraw(false)

		if not IsValid( self.Owner ) then
			self:FireError()
			roff = false
			return
		end

		if not IsValid( self.TargetRagdoll ) then
			self:FireError()
			roff = false
			return
		end

		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
			filter = self.Owner
		} )

		if tr.Entity ~= self.TargetRagdoll then
			self:FireError()
			roff = false
			return
		end

		if CurTime() >= self:GetEvolveStartTime() + 5 then
			self:SetEnergy( self:GetEnergy() + 1 )
			self:SetEvolveState( STATE_NONE )
			roff = false


			if SERVER then
			self.TargetRagdoll:Remove()
		end


			if self:GetEnergy() == 15 then
				for k, ply in pairs( player.GetAll() ) do
					ply:ChatPrint( "Вы услышали очень громкий вопль, что же это может быть?" )
					if SERVER then
					    ply:SendLua('surface.PlaySound("scp/evolve.mp3")')
					end
				end
			end
			if self:GetEnergy() == 25 then
				for k, ply in pairs( player.GetAll() ) do
					if ply:GTeam() != TEAM_SCP then
					    ply:ChatPrint( "Оно идет за вами!" )
					end
				end
			end

			if self:GetEnergy() == 5 then
		        self.Owner:SetWalkSpeed(180)
		        if SERVER then
		            self.Owner:SetMaxHealth(1500)
		            self.Owner:SetHealth(1500)
		        end
		        self.Owner:SetRunSpeed(190)
		        self.Owner:SetMaxSpeed(190)
		        self.Owner:SetJumpPower(150)
		        self.Owner:EmitSound("scp/evolve.mp3")
		        self.Owner:ChatPrint("Поздравляем, Вы достигли 1 стадии развития, продолжайте показывать людям свою ненависть!")
	        end
			if self:GetEnergy() == 10 then
		        self.Owner:SetWalkSpeed(195)
		        if SERVER then
		            self.Owner:SetMaxHealth(3500)
		            self.Owner:SetHealth(3500)
		        end
		        self.Owner:SetRunSpeed(210)
		        self.Owner:SetMaxSpeed(210)
		        self.Owner:SetJumpPower(300)
		        self.Owner:EmitSound("scp/evolve.mp3")
		        self.Owner:ChatPrint("Поздравляем, Вы достигли 2 стадии развития.")
	        end
	        if self:GetEnergy() == 15 then
		        self.Owner:SetWalkSpeed(210)
		        if SERVER then
		            self.Owner:SetMaxHealth(4500)
		            self.Owner:SetHealth(4500)
		        end
		        self:SetHoldType("melee2")
		        self.Owner:SetRunSpeed(230)
		        self.Owner:SetMaxSpeed(230)
		        self.Owner:SetJumpPower(300)
		        self.Owner:EmitSound("scp/evolve.mp3")
		        self.Owner:ChatPrint("Поздравляем, Вы достигли 3 стадии развития.")
	        end
	        if self:GetEnergy() == 20 then
		        self.Owner:SetWalkSpeed(230)
		        if SERVER then
		            self.Owner:SetMaxHealth(5500)
		            self.Owner:SetHealth(5500)
		        end
		        self.Owner:SetRunSpeed(260)
		        self:SetHoldType("melee2")
		        self.Owner:SetMaxSpeed(260)
		        self.Owner:SetJumpPower(300)
		        self.Owner:EmitSound("scp/evolve.mp3")
		        self.Owner:ChatPrint("Поздравляем, Вы достигли 4 стадии развития, теперь у Вас высокая скорость и большое кол-во хп.")
	        end
	        if self:GetEnergy() == 25 then
		        self.Owner:SetWalkSpeed(270)
		        if SERVER then
		            self.Owner:SetMaxHealth(6500)
		            self.Owner:SetHealth(6500)
		        end
		        self.Owner:SetRunSpeed(290)
		        self:SetHoldType("melee2")
		        self.Owner:SetMaxSpeed(290)
		        self.Owner:SetJumpPower(300)
		        self.Owner:EmitSound("scp/evolve.mp3")
		        self.Owner:ChatPrint("УБЕЙ ИХ ВСЕХ")
	        end
		end
	end


	if self:GetEvolveState() == STATE_EVOLVING then
		local owner = self.Owner
		if not IsValid( owner ) then
			self:FireError()
			return
		end

		if owner:KeyDown( IN_FORWARD ) or owner:KeyDown( IN_BACK ) or owner:KeyDown( IN_MOVERIGHT ) or
			owner:KeyDown( IN_MOVELEFT ) or owner:KeyDown( IN_JUMP ) or owner:KeyDown( IN_DUCK ) or not owner:OnGround() then
			self.Owner:SetNoDraw(true)
			self:FireError()



			return
		end

		if CurTime() >= self:GetEvolveStartTime() + 6 then
			local pos = owner:GetPos()
			timer.Simple( 0.1, function() owner:SetPos( pos ) end )

			self:Stage2( owner )
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		local x, y = ScrW() / 2, ScrH() / 2

		surface.SetDrawColor( 200, 200, 200, 255 )
		surface.DrawLine( x + 7, y, x + 22, y )
		surface.DrawLine( x - 7, y, x - 22, y )
		surface.DrawLine( x, y + 7, x, y + 22 )
		surface.DrawLine( x, y - 7, x, y - 22 )

		local w, h = ScrW(), ScrH()


		draw.SimpleText("Current Stage", "shriftah2", x - 435, h - 300, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("Current Stage", "shriftah2", x - 435, h - 300, Color(255, 255, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("TOTAL KILLS", "shriftah2", x - 445, h - 120, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("TOTAL KILLS", "shriftah2", x - 445, h - 120, Color(255, 255, 255), TEXT_ALIGN_CENTER)

		if LocalPlayer() != self.Owner then return end

		local energyg = LocalPlayer():GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy()
        if energyg >= 0 and energyg < 5 then
		    draw.SimpleText("0", "shriftah2", x - 433, h - 265, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	    end
		if energyg >= 5 and energyg < 10 then
		    draw.SimpleText("1", "shriftah2", x - 433, h - 265, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	    end
	    if energyg >= 10 and energyg < 15 then
		    draw.SimpleText("2", "shriftah2", x - 433, h - 265, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	    end
	    if energyg >= 15 and energyg < 20 then
		    draw.SimpleText("3", "shriftah2", x - 433, h - 265, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	    end
	    if energyg >= 20 and energyg < 25 then
		    draw.SimpleText("4", "shriftah2", x - 433, h - 265, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	    end
	    if energyg == 25 then
		    draw.SimpleText("5", "shriftah2", x - 433, h - 265, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	    end

		if self:GetEvolveState() == STATE_EAT then
			local progress = math.TimeFraction( self:GetEvolveStartTime(), self:GetEvolveStartTime() + 5, CurTime() )

			if progress <= 0 then
				return
			end

			if progress >= 0.985 and energyg == 4 then
				vgui.Create( "EvolvePanel" )

			end
			if progress >= 0.985 and energyg == 9 then
				vgui.Create( "EvolvePanel3" )

			end
			if progress >= 0.985 and energyg == 14 then
				vgui.Create( "EvolvePanel4" )

			end
			if progress >= 0.985 and energyg == 19 then
				vgui.Create( "EvolvePanel7" )

			end
			if progress >= 0.985 and energyg == 24 then
				vgui.Create( "EvolvePanel5" )

			end



			progress = math.Clamp( progress, 0, 1 )

			surface.SetDrawColor( 0, 150, 255, 200 )
			surface.DrawOutlinedRect( x - 101, y + 150, 202, 20 )
			surface.DrawRect( x - 100, y + 150, 200 * progress, 20 )
		end

		if self:GetEvolveState() == STATE_EVOLVING then
			local progress = math.TimeFraction( self:GetEvolveStartTime(), self:GetEvolveStartTime() + 6, CurTime() )

			if progress <= 0 then
				return
			end

			progress = math.Clamp( progress, 0, 1 )
			surface.SetDrawColor( 0, 0, 0, 222 )
			surface.DrawRect( x - 125, y + 200, 250, 40 )

			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( x - 126, y + 199, 252, 42 )

			surface.SetDrawColor( 200, 30, 30, 200 )
			surface.DrawRect( x - 125, y + 200, 250 * progress, 40 )
		end
	end

	surface.CreateFont("EvolveEnergy", {font = "Trebuchet24", size = 24, weight = 750})
	local p = {}

	function p:Init()
		self.StartTime = CurTime()
		self.FadeoutStart = CurTime() + 4

		self:SetSize( 300, 60 )
		self.size = self:GetSize()
		self:SetPos( ScrW() / 2 - self.size / 2, ScrH() / 6 )



		self.name = ""

		timer.Simple( 6, function() self:Remove() end )
	end

	function p:Paint( w, h )
		local start, endtime = self.StartTime, self.StartTime + 0.2

		if CurTime() >= self.FadeoutStart then
			start, endtime = self.FadeoutStart, self.FadeoutStart + 0.5
		end

		local progress = math.TimeFraction( start, endtime, CurTime() )

		if progress <= 0 then return end

		progress = math.Clamp( progress, 0, 1 )

		if CurTime() >= self.FadeoutStart then
			progress = 1 - progress
		end

		draw.RoundedBox( 0, 0, 0, self.size - 50, h, Color( 0, 0, 0, 230 * progress ) )
		draw.RoundedBox( 0, self.size - 50, 0, 50, h, Color( 0, 255, 0, 230 * progress ) )

		--[[
		draw.RoundedBox( 0, 2, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, 2, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		]]

		draw.DrawText( "Поздравляем", "TargetID", self.size - 57, 10, Color( 178, 34, 34, 255 * progress ), TEXT_ALIGN_RIGHT )
		draw.DrawText( "Открыта новая спобность!", "TargetID", self.size - 57, 35, Color( 0, 100, 0, 255 * progress ), TEXT_ALIGN_RIGHT )

		surface.SetDrawColor(Color(255,255,255,255 * progress))
	    surface.SetMaterial(Material("eyespell2.png"))
	    surface.DrawTexturedRect(self.size - 50, 0, 51, 60)

	end

	vgui.Register( "EvolvePanel", p, "Panel" )
	local p1 = {}

	function p1:Init()
		self.StartTime = CurTime()
		self.FadeoutStart = CurTime() + 4

		self:SetSize( 300, 60 )
		self.size = self:GetSize()
		self:SetPos( ScrW() / 2 - self.size / 2, ScrH() / 6 )



		self.name = ""

		timer.Simple( 6, function() self:Remove() end )
	end

	function p1:Paint( w, h )
		local start, endtime = self.StartTime, self.StartTime + 0.2

		if CurTime() >= self.FadeoutStart then
			start, endtime = self.FadeoutStart, self.FadeoutStart + 0.5
		end

		local progress = math.TimeFraction( start, endtime, CurTime() )

		if progress <= 0 then return end

		progress = math.Clamp( progress, 0, 1 )

		if CurTime() >= self.FadeoutStart then
			progress = 1 - progress
		end

		draw.RoundedBox( 0, 0, 0, self.size - 50, h, Color( 0, 0, 0, 230 * progress ) )
		draw.RoundedBox( 0, self.size - 50, 0, 50, h, Color( 0, 255, 0, 230 * progress ) )

		--[[
		draw.RoundedBox( 0, 2, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, 2, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		]]

		draw.DrawText( "Поздравляем", "TargetID", self.size - 57, 10, Color( 178, 34, 34, 255 * progress ), TEXT_ALIGN_RIGHT )
		draw.DrawText( "Открыта новая спобность!", "TargetID", self.size - 57, 35, Color( 0, 100, 0, 255 * progress ), TEXT_ALIGN_RIGHT )

		surface.SetDrawColor(Color(255,255,255,255 * progress))
	    surface.SetMaterial(Material("trapg.png"))
	    surface.DrawTexturedRect(self.size - 50, 0, 51, 60)

	end

	vgui.Register( "EvolvePanel3", p1, "Panel" )
	local p2 = {}

	function p2:Init()
		self.StartTime = CurTime()
		self.FadeoutStart = CurTime() + 4

		self:SetSize( 300, 60 )
		self.size = self:GetSize()
		self:SetPos( ScrW() / 2 - self.size / 2, ScrH() / 6 )



		self.name = ""

		timer.Simple( 6, function() self:Remove() end )
	end

	function p2:Paint( w, h )
		local start, endtime = self.StartTime, self.StartTime + 0.2

		if CurTime() >= self.FadeoutStart then
			start, endtime = self.FadeoutStart, self.FadeoutStart + 0.5
		end

		local progress = math.TimeFraction( start, endtime, CurTime() )

		if progress <= 0 then return end

		progress = math.Clamp( progress, 0, 1 )

		if CurTime() >= self.FadeoutStart then
			progress = 1 - progress
		end

		draw.RoundedBox( 0, 0, 0, self.size - 50, h, Color( 0, 0, 0, 230 * progress ) )
		draw.RoundedBox( 0, self.size - 50, 0, 50, h, Color( 0, 255, 0, 230 * progress ) )

		--[[
		draw.RoundedBox( 0, 2, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, 2, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		]]

		draw.DrawText( "Поздравляем", "TargetID", self.size - 57, 10, Color( 178, 34, 34, 255 * progress ), TEXT_ALIGN_RIGHT )
		draw.DrawText( "Открыта новая спобность!", "TargetID", self.size - 57, 35, Color( 0, 100, 0, 255 * progress ), TEXT_ALIGN_RIGHT )

		surface.SetDrawColor(Color(255,255,255,255 * progress))
	    surface.SetMaterial(Material("soundwaves.png"))
	    surface.DrawTexturedRect(self.size - 50, 0, 51, 60)

	end

	vgui.Register( "EvolvePanel4", p2, "Panel" )
	local p3 = {}

	function p3:Init()
		self.StartTime = CurTime()
		self.FadeoutStart = CurTime() + 4

		self:SetSize( 300, 60 )
		self.size = self:GetSize()
		self:SetPos( ScrW() / 2 - self.size / 2, ScrH() / 6 )



		self.name = ""

		timer.Simple( 6, function() self:Remove() end )
	end

	function p3:Paint( w, h )
		local start, endtime = self.StartTime, self.StartTime + 0.2

		if CurTime() >= self.FadeoutStart then
			start, endtime = self.FadeoutStart, self.FadeoutStart + 0.5
		end

		local progress = math.TimeFraction( start, endtime, CurTime() )

		if progress <= 0 then return end

		progress = math.Clamp( progress, 0, 1 )

		if CurTime() >= self.FadeoutStart then
			progress = 1 - progress
		end

		draw.RoundedBox( 0, 0, 0, self.size - 50, h, Color( 0, 0, 0, 230 * progress ) )
		draw.RoundedBox( 0, self.size - 50, 0, 50, h, Color( 0, 255, 0, 230 * progress ) )

		--[[
		draw.RoundedBox( 0, 2, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, 2, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		]]

		draw.DrawText( "Поздравляем", "TargetID", self.size - 57, 10, Color( 178, 34, 34, 255 * progress ), TEXT_ALIGN_RIGHT )
		draw.DrawText( "Открыта новая спобность!", "TargetID", self.size - 57, 35, Color( 0, 100, 0, 255 * progress ), TEXT_ALIGN_RIGHT )

		surface.SetDrawColor(Color(255,255,255,255 * progress))
	    surface.SetMaterial(Material("healingspell2.png"))
	    surface.DrawTexturedRect(self.size - 50, 0, 51, 60)

	end

	vgui.Register( "EvolvePanel5", p3, "Panel" )
	local p4 = {}

	function p4:Init()
		self.StartTime = CurTime()
		self.FadeoutStart = CurTime() + 4

		self:SetSize( 300, 60 )
		self.size = self:GetSize()
		self:SetPos( ScrW() / 2 - self.size / 2, ScrH() / 6 )



		self.name = ""

		timer.Simple( 6, function() self:Remove() end )
	end

	function p4:Paint( w, h )
		local start, endtime = self.StartTime, self.StartTime + 0.2

		if CurTime() >= self.FadeoutStart then
			start, endtime = self.FadeoutStart, self.FadeoutStart + 0.5
		end

		local progress = math.TimeFraction( start, endtime, CurTime() )

		if progress <= 0 then return end

		progress = math.Clamp( progress, 0, 1 )

		if CurTime() >= self.FadeoutStart then
			progress = 1 - progress
		end

		draw.RoundedBox( 0, 0, 0, self.size - 50, h, Color( 0, 0, 0, 230 * progress ) )
		draw.RoundedBox( 0, self.size - 50, 0, 50, h, Color( 0, 255, 0, 230 * progress ) )

		--[[
		draw.RoundedBox( 0, 2, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, 2, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, 2, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		draw.RoundedBox( 0, w - 4, h - 4, 2, 2, Color( 200, 200, 200, 150 * progress ) )
		]]

		draw.DrawText( "Поздравляем", "TargetID", self.size - 57, 10, Color( 178, 34, 34, 255 * progress ), TEXT_ALIGN_RIGHT )
		draw.DrawText( "Открыта новая спобность!", "TargetID", self.size - 57, 35, Color( 0, 100, 0, 255 * progress ), TEXT_ALIGN_RIGHT )

		surface.SetDrawColor(Color(255,255,255,255 * progress))
	    surface.SetMaterial(Material("slashs.png"))
	    surface.DrawTexturedRect(self.size - 50, 0, 51, 60)

	end

	vgui.Register( "EvolvePanel7", p4, "Panel" )
end

local NextTrap = 0
local configTrapDelay = 10
local obvodkkka = false


hook.Add("PlayerButtonDown", "kekk", function(ply, but)
	if but != KEY_T then return end
	timer.Simple(0, function() obvodkkka = true end)
    timer.Simple(0.3, function() obvodkkka = false end)
    if ply:GetNClass() != ROLES.ROLE_SCP062 then return end
    if ply:GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy() < 10 then return end
	local tr = util.TraceLine({start = ply:GetShootPos(), endpos = ply:GetShootPos() + ply:GetAimVector() * 100, filter = ply})
	if !tr.HitWorld then return end
	if ply:GTeam() != TEAM_SCP then return end
	if NextTrap > CurTime() then return end
	if ply:GetNWInt("trap") >= 3 then ply:ChatPrint("Вы не можете ставить больше трех капканов") return end
	NextTrap = CurTime() + configTrapDelay

    if ply:GetActiveWeapon():GetClass() == "weapon_ttt_evolveknife" and but == KEY_T then


        if ply:GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy() >= 0 then


		if tr.HitWorld then
			local dot = vector_up:Dot(tr.HitNormal)

			if dot > 0.55 and dot <= 1 then
				ply:EmitSound("scp_sounds/scp_hunter/trap.mp3")
				ply:SetNWInt("trap", ply:GetNWInt("trap") + 1)
				if SERVER then
				local ent = ents.Create("ttt_bear_trap")
				ent:SetPos(tr.HitPos + tr.HitNormal)
				local ang = tr.HitNormal:Angle()
				ang:RotateAroundAxis(ang:Right(), -90)
				ent:SetAngles(ang)
				ent:Spawn()
				ent.Owner = ply
				end

			end
		end
	end
    end

end)

local shitty = false

hook.Add( "HUDPaint", "playerthroughwalls", function()
	if LocalPlayer():HasWeapon( "weapon_ttt_evolveknife" ) and shitty then
	cam.Start3D()
		for id, ply in pairs( player.GetAll() ) do
      if ply:GTeam() != TEAM_SPEC then
			  ply:DrawModel()
      end
		end
	cam.End3D()
    end
end )

if CLIENT then
LocalPlayer().ThermalOn = false
local ThermalToggleg = false
local ThermalMats = {}
local ThermalClrs = {}

-- A most likely futile attempt to make things faster
local pairs = pairs
local string = string
local render = render

local ThermalColorTab =
{
	[ "$pp_colour_addr" ] 		= -.4,
	[ "$pp_colour_addg" ] 		= -.5,
	[ "$pp_colour_addb" ] 		= -.5,
	[ "$pp_colour_brightness" ] 	= .18,
	[ "$pp_colour_contrast" ] 	= 0.6,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0,
}

function ThermalMatsk()


for k,v in pairs( ents.GetAll() ) do
if string.sub( (v:GetModel() or "" ), -3) == "mdl" then -- only affect models

			-- Inefficient, but not TOO laggy I hope
			local r = v:GetColor().r
			local g = v:GetColor().g
			local b = v:GetColor().b
			local a = v:GetColor().a
			if (a > 0) then

		local entmat = v:GetMaterial()

		if ( v:GetClass() == "prop_physics") then -- It's alive!

	--		if not (r == 255 and g == 255 and b == 255 and a == 255) then -- Has our color been changed?
	--		ThermalClrs[ v ] = Color( r, g, b, a )  -- Store it so we can change it back later
	--		v:SetColor( 255, 255, 255, 255 ) -- Set it back to what it should be now
	--		end
			if entmat ~= "thermal/prop" then -- Has our material been changed?
			ThermalMats[ v ] = entmat -- Store it so we can change it back later
			v:SetMaterial( "thermal/prop" ) -- The xray matierals are designed to show through walls
			end

		else -- It's a prop or something

	--		if not (r == 255 and g == 255 and b == 255 and a == 255) then
	--		ThermalClrs[ v ] = Color( r, g, b, a )
	--		v:SetColor( 255, 255, 255, 255 )
	--		end

			if entmat ~= "thermal/thermal" then
			ThermalMats[ v ] = entmat
			v:SetMaterial( "thermal/thermal" )
			end

		end


		end

end
end
end
function ThermalFXs()

	DrawColorModify( ThermalColorTab )

	-- Bloom
	DrawBloom(	0,  					-- Darken
 				0.5,				-- Multiply
 				1, 				-- Horizontal Blur
 				1, 				-- Vertical Blur
 				0, 				-- Passes
 				0, 				-- Color Multiplier
 				10, 				-- Red
 				10, 				-- Green
 				10 ) 			-- Blue

	DrawTexturize( 0, Material( "thermal/thermaltexture.png" ) )

end
local function ThermalSetg()

		surface.PlaySound("scp_sounds/scp_hunter/vision.mp3",100, math.random(95,105))
		hook.Add( "RenderScreenspaceEffects", "ThermalC", ThermalFXs )
		hook.Add( "RenderScene", "ThermalM", ThermalMatsk )


end
local function ThermalReSetg()

		--surface.PlaySound("scp_sounds/scp_hunter/vision.mp3",20, math.random(15,25))
		hook.Remove( "RenderScreenspaceEffects", "ThermalC" )
		hook.Remove( "RenderScene", "ThermalM" )


		for ent,mat in pairs( ThermalMats ) do
		if ent:IsValid() then
		ent:SetMaterial( mat )
		end
		end

	--	for ent,clr in pairs( ThermalClrs ) do
	--	if ent:IsValid() then
	--	ent:SetColor( clr.r, clr.g, clr.b, clr.a )
	--	end
	--	end

		-- Clean up our tables- we don't need them anymore.
		ThermalMats = {}
		ThermalClrs = {}

end
hook.Add( "Think", "thermalkeyOnk", function( ply, key )
if !LocalPlayer():Alive() and shitty then
    ThermalReSetg()
	shitty = false
	LocalPlayer().ThermalOn = false
	--print("Kok")
end
if !LocalPlayer():Alive() then return end
if LocalPlayer():GTeam() != TEAM_SCP then return end
--if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_ttt_evolveknife" then return end
if LocalPlayer():GetNClass() != ROLES.ROLE_SCP062 then return end
if LocalPlayer():GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy() < 5 then return end

if input.IsKeyDown( KEY_F ) then

if ThermalToggleg == false then
	ThermalToggleg = true

	if LocalPlayer().ThermalOn == false then
	ThermalSetg()
	shitty = true
	LocalPlayer().ThermalOn = true
	elseif LocalPlayer().ThermalOn == true then
	ThermalReSetg()
	shitty = false
	LocalPlayer().ThermalOn = false
	end

end
else

ThermalToggleg = false

end
end)
function SWEP:Holster()
	self:FireError()
	self.Owner.Biomask = true
	ThermalReSetg()
	shitty = false
	LocalPlayer().ThermalOn = false
	return true
end
end


local NextHeal = 0
local configHealDelay = 20
local obvodka = false
hook.Add("PlayerButtonDown", "kekk3", function(ply, but)
	if but != KEY_H then return end
	if ply:GTeam() != TEAM_SCP then return end
	if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_ttt_evolveknife" then return end
	timer.Simple(0, function() obvodka = true end)
    timer.Simple(0.3, function() obvodka = false end)
    if ply:GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy() < 24 then return end
	if ply:Health() >= ply:GetMaxHealth() then return end
	if NextHeal > CurTime() then return end
	NextHeal = CurTime() + configHealDelay
    if ply:GetActiveWeapon():GetClass() == "weapon_ttt_evolveknife" and but == KEY_H then

        ply:SetHealth(ply:Health() + 500)

	end


end)
local NextRevok = 0
local configRevokDelay = 10
local obvodoa = false
hook.Add("PlayerButtonDown", "kekk9", function(ply, but)
	if but != KEY_R then return end
	if ply:GTeam() != TEAM_SCP then return end
	if ply:GetActiveWeapon():GetClass() != "weapon_ttt_evolveknife" then return end
	timer.Simple(0, function() obvodoa = true end)
    timer.Simple(0.3, function() obvodoa = false end)
    if ply:GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy() < 20 then return end

	if NextRevok > CurTime() then return end
	NextRevok = CurTime() + configRevokDelay
    if ply:GetActiveWeapon():GetClass() == "weapon_ttt_evolveknife" and but == KEY_R then







    local owner = ply
    if !owner:IsValid() then return end
    if !owner:Alive() then return end
    if !owner:OnGround() then return end


   if SERVER then
        owner:SetVelocity(Vector(0,0,300))
        timer.Simple(0.15, function()
        	owner:EmitSound("scp_sounds/scp_hunter/jump_attack.mp3")
            owner:SetVelocity(owner:GetAimVector() * 550)
        end)
    end
	end


end)
local NextAction = 0
local configActionDelay = 10
local obvodkka = false
hook.Add("PlayerButtonDown", "kekk4", function(ply, but)
	if but != KEY_G then return end
	if ply:GTeam() != TEAM_SCP then return end
	if ply:GetActiveWeapon():GetClass() != "weapon_ttt_evolveknife" then return end
    timer.Simple(0, function() obvodkka = true end)
    timer.Simple(0.3, function() obvodkka = false end)



	local configConfuseRayDelay = 8
    local configConfuseRayDamageLow = 0
    local configConfuseRayDamageHigh = 0
    local configConfuseRaySize = 16   -- How big is the ray itself?
    local configConfuseRayRadius = 96 -- Radius of ray impfalse
    local configConfuseRayRange = 512 -- How far the ray will travel.
    local configConfuseRayInterval = 0.1 -- Time in between rings.
    local configConfuseRayNumber = 10 -- How many rings? ( these deal damage )

    local configConfusionExpire = 7 -- How long until confusion expires?
    local configConfusionRandomAim = true -- Will this fling their aim around?
    local configConfusionHurtDamageLow = 3
    local configConfusionHurtDamageHigh = 5
    local configConfusionHurtChance = 50 -- Out of 100, if it is greater than this.

    local configConfuseRayFX = "fx_poke_confuseray"
    local configConfuseRaySound = "npc/manhack/bat_away.wav"
    if ply:GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy() < 15 then return end
    if NextAction > CurTime() then return end
	NextAction = CurTime() + configActionDelay
    if ply:GetActiveWeapon():GetClass() == "weapon_ttt_evolveknife" and but == KEY_G then


	if PokeBase then PokeBase_SendAction(self:GetOwner(),configActionDelay) end
	local owner = ply


	local timerid = "GHOSTPOKECONFUSERAY"..owner:SteamID()

	timer.Remove(timerid)


	timer.Create(timerid,configConfuseRayInterval,configConfuseRayNumber,function()
		if IsValid(owner) then
			if SERVER then
			    GHOSTPOKE_Effect(owner:GetShootPos()+(owner:GetAimVector()*64),configConfuseRayFX,configConfuseRayRange,owner:GetAimVector(),owner)
		    end
			local tr = util.TraceHull({
				start = owner:GetShootPos(),
				endpos = owner:GetShootPos()+owner:GetAimVector()*configConfuseRayRange,
				mins = Vector( -configConfuseRaySize, -configConfuseRaySize, -configConfuseRaySize ),
				maxs = Vector( configConfuseRaySize, configConfuseRaySize, configConfuseRaySize ),
				filter = owner
			})

			if tr.Hit then
				if SERVER then
				for _, v in ipairs(ents.FindInSphere(tr.HitPos,configConfuseRayRadius)) do
					--print(v)
					if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC then

						if v:IsPlayer() && v:Alive() then
						    v:TakeDamage(5)
						end


						if v:IsPlayer() && v:Alive() then
							if configConfusionRandomAim then
								local ang = AngleRand()
								v:SetEyeAngles(Angle(ang.p,ang.y,0))
							end
							net.Start("GHOSTPOKECONFUSE")
								net.WriteEntity(v)
								net.WriteInt(configConfusionExpire,32)
							net.Send(v)
						end

					end
				end

			end
			end
		end

	end)

	--sound.Play(configConfuseRaySound,owner:GetPos(),65,75,1)

	NextAction = CurTime() + configConfuseRayDelay

	if PokeBase then PokeBase_SendAction(ply:GetOwner(),configConfuseRayDelay) end

	end




end)

hook.Add( "HUDPaint", "EvolveGauge", function()
	if LocalPlayer():HasWeapon( "weapon_ttt_evolveknife" ) then
		local x, y = ScrW(), ScrH()
		local bledH = 25
	    local lvlH = 70
	    local bledMarg = 25
	    local scale = hudScale
	    local vledOffsetH = ScrH() - bledH - bledMarg
	    local scale_role_time = 0
	    local widthz = ScrW() * scale
	    local heightz = ScrH() * scale
	    local offset = ScrH() - heightz


		if woops then

		    surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("invisible.png"))
	        surface.DrawTexturedRect(150 - bledH - -30, vledOffsetH - 190 + scale_role_time, lvlH, lvlH)
        end

            surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("healingspell2.png"))
	        surface.DrawTexturedRect(744 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	        surface.SetDrawColor(Color(255,255,255,255))
            surface.SetMaterial(Material("eatingg.png"))
	        surface.DrawTexturedRect(814 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("eyespell2.png"))
	        surface.DrawTexturedRect(884 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("soundwaves.png"))
	        surface.DrawTexturedRect(954 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("trapg.png"))
	        surface.DrawTexturedRect(1024 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("slashs.png"))
	        surface.DrawTexturedRect(1094 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)

	    local energygs = LocalPlayer():GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy()

	    if NextHeal > CurTime() or energygs < 24 then
	        surface.SetDrawColor(Color(255,255,255,150))
	        surface.SetMaterial(Material("redspell.png"))
	        surface.DrawTexturedRect(744 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if NextAction > CurTime() or energygs < 15 then
	        surface.SetDrawColor(Color(255,255,255,150))
	        surface.SetMaterial(Material("redspell.png"))
	        surface.DrawTexturedRect(954 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if energygs < 5 then
	        surface.SetDrawColor(Color(255,255,255,150))
	        surface.SetMaterial(Material("redspell.png"))
	        surface.DrawTexturedRect(884 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if NextRevok > CurTime() or energygs < 20 then
	        surface.SetDrawColor(Color(255,255,255,150))
	        surface.SetMaterial(Material("redspell.png"))
	        surface.DrawTexturedRect(1094 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if NextTrap > CurTime() or energygs < 10 then
	        surface.SetDrawColor(Color(255,255,255,150))
	        surface.SetMaterial(Material("redspell.png"))
	        surface.DrawTexturedRect(1024 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if LocalPlayer().ThermalOn == true then
	        surface.SetDrawColor(Color(255,255,255,150))
	        surface.SetMaterial(Material("greeana.png"))
	        surface.DrawTexturedRect(884 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if roff then
	    	surface.SetDrawColor(Color(255,255,255,150))
	        surface.SetMaterial(Material("greeana.png"))
	        surface.DrawTexturedRect(814 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if obvodka then
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("obvedka.png"))
	        surface.DrawTexturedRect(744 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if obvodke then
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("obvedka.png"))
	        surface.DrawTexturedRect(884 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if obvodoa then
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("obvedka.png"))
	        surface.DrawTexturedRect(1094 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if obvodkka then
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("obvedka.png"))
	        surface.DrawTexturedRect(954 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    if obvodkkka then
	        surface.SetDrawColor(Color(255,255,255,255))
	        surface.SetMaterial(Material("obvedka.png"))
	        surface.DrawTexturedRect(1024 - bledH - -30, vledOffsetH - 130 + scale_role_time, lvlH, lvlH)
	    end
	    local showtext = ""
	if NextHeal > CurTime() then
        showtext = " " .. math.Round(NextHeal - CurTime())
        showcolor = Color(255, 69, 0)
    end
    draw.Text( {
		text = showtext,
		pos = { ScrW() / 2.45, ScrH() - 145 },
		font = "HUDFontTitle",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	local kektext = ""
	if NextAction > CurTime() then
        kektext = " " .. math.Round(NextAction - CurTime())
        kekcolor = Color(255, 0, 0)
    end
    draw.Text( {
		text = kektext,
		pos = { ScrW() / 1.94, ScrH() - 145 },
		font = "HUDFontTitle",
		color = kekcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	local koktext = ""
	if NextTrap > CurTime() then
        koktext = " " .. math.Round(NextTrap - CurTime())
        kokcolor = Color(255, 0, 0)
    end
    draw.Text( {
		text = koktext,
		pos = { ScrW() / 1.807, ScrH() - 145 },
		font = "HUDFontTitle",
		color = kokcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	local rivoktext = ""
	if NextRevok > CurTime() then
        rivoktext = " " .. math.Round(NextRevok - CurTime())
        rivokcolor = Color(255, 0, 0)
    end
    draw.Text( {
		text = rivoktext,
		pos = { ScrW() / 1.694, ScrH() - 145 },
		font = "HUDFontTitle",
		color = rivokcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})


	local rivoktext = "R"


    draw.Text( {
		text = rivoktext,
		pos = { ScrW() / 1.728, ScrH() - 170 },
		font = "HUDFontTitle",
		color = Color(255, 0, 0),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
		local energy = LocalPlayer():GetWeapon( "weapon_ttt_evolveknife" ):GetEnergy()
		local eMax = GetConVar( "ttt_evolve_maxenergy" ):GetInt()




		local mes = ( energy.. " / ".. eMax )
		if energy == eMax then
			mes = "MAX"
		end
		draw.SimpleText(mes, "shriftah2", 420 + 120, y - 79, Color(0, 0, 0),TEXT_ALIGN_RIGHT)
		draw.SimpleText(mes, "shriftah2", 420 + 120, y - 79, Color(255, 255, 255),TEXT_ALIGN_RIGHT)
	end
end )


