--[[
gamemodes/breach/entities/weapons/doctor/shared.lua
--]]
if SERVER then 
	AddCSLuaFile()
	--resource.AddFile( "materials/effects/vampiresplatter.vtf" )
	--resource.AddFile( "materials/effects/vampiresplatter.vmt" )
end

-- Todo: Add a convar to this and TTT to enable/disable sucking health while at the cap
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end


SWEP.PrintName 			= "SCP-542."

SWEP.Slot				 = 3
SWEP.SlotPos			 = 1
SWEP.DrawAmmo 		   	 = false
SWEP.ViewModel= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel= "models/vinrax/props/keycard.mdl"
SWEP.DrawCrosshair 		 = true
SWEP.HoldType			 = "normal"
SWEP.Spawnable			 = true
SWEP.AdminSpawnable		 = true

function SWEP:Think()	
self.Owner:DrawViewModel(false)
end

SWEP.UseHands			= true
SWEP.ISSCP = true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel          = ""


SWEP.DrawCrosshair     	    = false
SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.droppable				= false
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.DeploySpeed            = 2


-- These are used for the delay times in between healing and giving
SWEP.Primary.Delay = 0.4
SWEP.Secondary.Delay = 0.4
SWEP.Draining = false -- Dont touch this


-- * Config * --
SWEP.VampRange = 125 -- How many units from the player's eyes that you can do the vampirism thingy
SWEP.MaxHealth = 12500 -- Limit on health
SWEP.HealthRate = 35 -- How much health is taken per cycle

local function CanVamp( ent )
	if not IsValid(ent) then return false end
	if ent:IsPlayer() or ent:IsNPC() then
		return true
	else
		return false end
end

function SWEP:Deploy()
self.Owner:DrawViewModel( false )
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()
self:SetHoldType("normal")
end



function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	-- Traces a line from the players shoot position to 100 units
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+( ang * self.VampRange)
	tracedata.filter = self.Owner
	local trace = util.TraceLine(tracedata)
if trace.Entity:IsPlayer() then
				if trace.Entity:GTeam() == TEAM_SCP and trace.Entity:GTeam() == TEAM_DZ then
					--СУКА НЕ ТРОГАЙ ЕГО
					return -- чтобы короче он мог других убивать блят
                end
			end
        
	local target = trace.Entity
	if target:IsPlayer() or target:IsNPC() then
							if target:GTeam() == TEAM_SCP then
							     return
							end
							end
	if (not trace.HitWorld and CanVamp(target)) then
		self.Draining = true
		local selfH = self.Owner:Health()
		local targetH = target:Health()
		
		if selfH ~= self.MaxHealth then
			local rate = self.HealthRate
			local amount = math.random(rate - 2, rate + 2) -- A random value just cause
			
			-- In order to show up in dmg logs, this actually hurts the player
			if SERVER then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage( amount )
				dmginfo:SetDamageType( DMG_SLASH ) 
				dmginfo:SetAttacker(self.Owner ) 
				dmginfo:SetInflictor(self)
				dmginfo:SetDamagePosition(self:GetPos())
		
				target:TakeDamageInfo(dmginfo)
			end
		
		-- Gives health to the player who held the Vampire up to the max limit
			self.Owner:SetHealth(math.Clamp(self.Owner:Health() + amount, 0,self.MaxHealth ) )
		else
			self.Owner:ChatPrint("У вас максимум здоровья!")
		end
	
	else
		self.Draining = false
	end
end

-- Does the same thing as the Primary attack except this time it allows you to give health
function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()
	if self.Draining == true then
		-- Yet another trace because the health needs to be accurate and up to date
		-- Its probably inefficient to trace this much, oh well
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+( ang * self.VampRange)
		tracedata.filter = self.Owner
		local trace = util.TraceLine(tracedata)
		local target = trace.Entity
	
		if (not trace.HitWorld and CanVamp(target)) then
			local selfH = self.Owner:Health()
			local targetH = target:Health()
			-- Making sure the health box doesn't go out of the bounds of the regular box
			if targetH > 100 then
				targetH = 100
			end

			-- Health bar
			local w = ScrW()
			local h = ScrH()
			local x_axis, y_axis, width, height = w/2-w/21, h/2.8, w/11, h/20
			draw.RoundedBox(2, x_axis, y_axis, width, height, Color(10,10,10,200))
			draw.RoundedBox(2, x_axis, y_axis, width * (targetH / 100), height, Color(192,57,43,200))
			draw.SimpleText(target:Health(), "Trebuchet24", w/2, h/2.8 + height/2, Color(255,255,255,255), 1, 1)

		end
	end
end



function SWEP:Equip()
   self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )   
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end


SWEP.Secondary.Damage         = 20
SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = true
SWEP.Secondary.Delay          = 10
SWEP.Secondary.Ammo           = "none"

-- Pull out faster than standard guns
SWEP.DeploySpeed            = 2


------------


local function Seizure(entity)
	local rand = math.random(0,5)
	entity:ViewPunch( Angle(math.random(-20,20), math.random(-25,25), math.random(-30,30)) )
	entity:ConCommand("-right")
	entity:ConCommand("-left")
	
	if rand == 0 then
		entity:ConCommand("+jump")
		entity:ConCommand("-duck")
		timer.Simple(10.5, function() entity:ConCommand("-jump") end )
	elseif rand == 1 then
		entity:ConCommand("slot2")
		entity:ConCommand("slot3")
		entity:ConCommand("+right")
		entity:ConCommand("+moveleft")
		entity:ConCommand("+attack")
		timer.Simple( 10.0, function() entity:ConCommand("-right") entity:ConCommand("-moveleft") entity:ConCommand("-attack") end )
	elseif rand == 2 then
		entity:ConCommand("+left")
		entity:ConCommand("+moveright")
		timer.Simple( 10.0, function() entity:ConCommand("-left") entity:ConCommand("-moveright") end )
	elseif rand == 3 then
		entity:ConCommand("slot2")
		entity:ConCommand("slot3")
		entity:ConCommand("+forward")
		entity:ConCommand("+attack")
		timer.Simple( 10.5, function() entity:ConCommand("-forward") entity:ConCommand("-attack") end )
	elseif rand == 4 then
		entity:ConCommand("+right")
		entity:ConCommand("+attack2")
		entity:ConCommand("+moveleft")
		timer.Simple( 10.5, function() entity:ConCommand("-right") entity:ConCommand("-attack2") entity:ConCommand("-moveleft") entity:ConCommand("-attack") end )
	elseif rand == 5 then
		entity:ConCommand("slot2")
		entity:ConCommand("slot3")
		entity:ConCommand("+attack")
		timer.Simple( 10.5, function() entity:ConCommand("-attack") end )
	end
end

function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   if not IsValid(self.Owner) then return end

   local spos = self.Owner:GetShootPos()
   local sdest = spos + (self.Owner:GetAimVector() * 70)

   local kmins = Vector(1,1,1) * -10
   local kmaxs = Vector(1,1,1) * 10

   local tr = util.TraceHull({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

   -- Hull might hit environment stuff that line does not hit
   if not IsValid(tr.Entity) then
      tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
   end

   local hitEnt = tr.Entity
if hitEnt:IsPlayer() or hitEnt:IsNPC() then
							if hitEnt:GTeam() == TEAM_SCP then
							     return
							end
							end
							
							
	if tr.Entity:IsPlayer() then
				if tr.Entity:GTeam() == TEAM_SCP and tr.Entity:GTeam() == TEAM_DZ then
					--СУКА НЕ ТРОГАЙ ЕГО
					return -- чтобы короче он мог других убивать блят
                end
			end
   -- effects
   if IsValid(hitEnt) then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      local edata = EffectData()
      edata:SetStart(spos)
      edata:SetOrigin(tr.HitPos)
      edata:SetNormal(tr.Normal)
      edata:SetEntity(hitEnt)

      if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
         util.Effect("BloodImpact", edata)
      end
   end

if SERVER then
		if self.Owner:GetEyeTrace().HitNonWorld and self.Owner:GetEyeTrace().Entity:IsPlayer() then			
				if IsValid(hitEnt) then
			local dmg = DamageInfo()
            dmg:SetDamage(self.Secondary.Damage)
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self.Weapon or self)
            dmg:SetDamageForce(self.Owner:GetAimVector() * 5)
            dmg:SetDamagePosition(self.Owner:GetPos())
            dmg:SetDamageType(DMG_SLASH)

            hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
         end
      end
						timer.Create("seizure", 0.75, math.random(10,20), function()
							if IsValid(hitEnt) and hitEnt:Alive() then
								Seizure(hitEnt)
							end
						end)						
					end
				end
		
 

function SWEP:Equip()
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
end
local NextBreachd = 0 
local cdNextBreachd = 5
function SWEP:Reload() 
    local ent = self.Owner:GetEyeTrace().Entity
	if NextBreachd > CurTime() then return end 
	NextBreachd = CurTime() + cdNextBreachd
    if ent:GetClass() == 'prop_dynamic' then
		if string.lower(ent:GetModel()) == 'models/foundation/doors/lcz_door.mdl' or string.lower(ent:GetModel()) == 'models/foundation/doors/hcz_door_01.mdl' then
			if SERVER then		   
			    ent:TakeDamage( math.Round(math.random(2,3)), self.Owner, self.Owner )
			end			
						
			ent:EmitSound("door_break.wav")
		end
	end
end
function SWEP:PreDrop()
   -- for consistency, dropped knife should not have DNA/prints
   self.fingerprints = {}
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end
----------

