--[[
gamemodes/breach/entities/weapons/weapon_katana/shared.lua
--]]
if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
--resource.AddFile("models/weapons/w_katana.mdl"); 
--resource.AddFile("models/weapons/v_katana.mdl"); 
--resource.AddFile("materials/models/weapons/v_katana/katana_normal.vtf"); 
--resource.AddFile("materials/models/weapons/v_katana/katana.vtf"); 
--resource.AddFile("materials/models/weapons/v_katana/katana.vmt");
end

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end

--SWEP.Author			= "SCP-076"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.Thinkdelay           = 0
SWEP.Primary.Delay				= 0.4
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage		= math.random(100,101)
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone				= 0
SWEP.Primary.ClipSize			= -1
SWEP.ISSCP = true
SWEP.Primary.DefaultClip		= -1
SWEP.droppable				= false
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"
SWEP.Cloaked                    = false
SWEP.Secondary.Delay			= 3
SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 100
SWEP.Secondary.NumShots			= 1
SWEP.Secondary.Cone				= 0
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  	 	= false

SWEP.ShurikenDelay                 = 0
SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_katana.mdl"
SWEP.WorldModel = "models/weapons/w_katana.mdl"
SWEP.ThrowTimer            = false
SWEP.MeleeRevert             = false

function SWEP:Initialize()
    self:SetWeaponHoldType("melee2")

end

function SWEP:StatIncrease()
timer.Simple(0.5, function()

  if !IsValid(self) or !IsValid(self.Owner) then return end 
	if self.Owner:Health() <= 100 then
	 self.Owner:SetHealth(self.Owner:Health() + 200)
	 end
	 
  end)
end

function SWEP:Holster()
if self:IsValid() and self.Owner:IsValid() then

		self.Owner:SetJumpPower(200)
		 self:SetNWBool( "Katana_View_Cloak", false )
		  
		  
	if self:GetNWBool("Katana_Cloak") == true then
		if !self.Owner:Alive() then
			self.Owner:SetMaterial("")
		 if SERVER then
			self.Owner:DrawWorldModel( true ) 
		  end
	else
		timer.Destroy("CloakTime")
			self:SetNWBool( "Katana_Cloak", false )
			 self:EmitSound("npc/dog/dog_idle1.wav")
			  self.Owner:DrawShadow( true ) 
			   self.Owner:SetMaterial("")
			   
			if SERVER then
				self.Owner:DrawWorldModel( true ) 
					self.Owner:SetNoTarget(false)
					end
	end
end
   end
	return true
end

function SWEP:OnRemove()

end

function SWEP:Deploy()
if !IsValid(self) or !IsValid(self.Owner) then return end 

	if SERVER then
	self.Owner:DrawWorldModel( true )
	end 
	self.Owner:SetJumpPower(400)
	
 return true
end

if SERVER then
function SWEP:Equip( NewOwner )
  self:StatIncrease()
  self:SetNWBool( "KatanaJump", false )
  self:SetNWBool( "Katana_View_Cloak", false )
  self:SetNWBool( "Katana_Cloak", false )
end
	end

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()

if !IsValid(self) or !IsValid(self.Owner) then return end 
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound("weapons/npc_katana/qubodup_sword_swing2.wav")--slash in the wind sound here
timer.Simple(0.1, function()
if IsValid(self) then
	self:Slash()
	end
end)
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end

function SWEP:Slash()
 	local trace = self.Owner:GetEyeTrace();
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 70 then
if !IsValid(self) or !IsValid(self.Owner) then return end 
	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()
	damagedice = math.Rand(0.9,1.50)
	pain = self.Primary.Damage * damagedice
				if SERVER and IsValid(self.Owner) then
						local slash = {}
						slash.start = pos
						slash.endpos = pos + (self.Owner:GetAimVector() * 75)
						slash.filter = self.Owner
						slash.mask = MASK_SHOT
						slash.mins = Vector(-10, -10, 0)
						slash.maxs = Vector(10, 10, 10)
						local slashtrace = util.TraceHull(slash)
						if slashtrace.Hit then
							targ = slashtrace.Entity
						if targ:IsPlayer() or targ:IsNPC() then
							if targ:GTeam() == TEAM_SCP then
							     return
							end
							
									self.Owner:EmitSound("weapons/npc_katana/SQUIB_KNIFE_IMPACT_FLESH_02.wav")								
								paininfo = DamageInfo()
								paininfo:SetDamage(pain)
								paininfo:SetDamageType(DMG_SLASH)
								paininfo:SetAttacker(self.Owner)
								paininfo:SetInflictor(self.Weapon)
						  local RandomForce = math.random(1000,20000)
								paininfo:SetDamageForce(slashtrace.Normal * RandomForce)
								if targ:IsPlayer() then
								targ:ViewPunch( Angle( -10, -20, 0 ) )
								end
								
						 if SERVER then
							local blood = targ:GetBloodColor()	
						   local fleshimpact		= EffectData()
								fleshimpact:SetEntity(self.Weapon)
								fleshimpact:SetOrigin(slashtrace.HitPos)
								fleshimpact:SetNormal(slashtrace.HitPos)
								if blood >= 0 then
								fleshimpact:SetColor(blood)
								util.Effect("BloodImpact", fleshimpact)	
                                 end	
							end	 
								if SERVER then targ:TakeDamageInfo(paininfo) end
							else						
								look = self.Owner:GetEyeTrace()
								util.Decal("ManhackCut", look.HitPos + look.HitNormal, look.HitPos - look.HitNormal )
							end
						end
					end
				if( trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass()=="prop_ragdoll" ) then
			
		if trace.Entity:IsPlayer() then
				if trace.Entity:GTeam() == TEAM_SCP and trace.Entity:GTeam() == TEAM_DZ then
					--Don't Shoot them!
					return -- We cannot slash them, they're our friend
                end
			end
        end
		end
		
		

	end
-----------------------------------Credit for this part goes to RobotBoy655, Just rewritten so I can learn it for myself and altered to my liking-----------------------------------	
hook.Add( "ShouldDrawLocalPlayer", "stealth_katana_draw", function()
	if (  LocalPlayer():IsValid() and  LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass() == "stealth_katana_swep" and !LocalPlayer():InVehicle() and LocalPlayer():Alive() and LocalPlayer():GetViewEntity() == LocalPlayer() and GetConVar( "RSK_1st_Person" ):GetInt() == 0 ) then return true end
end )

function SWEP:CalcView( ply, pos, angle, fov )
	if ( !ply:IsValid() or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply or GetConVar( "RSK_1st_Person" ):GetInt() == 1 ) then return end

	local trace = util.TraceLine( {
		start = pos,
		endpos = pos - angle:Forward() * 124,
		filter = { ply:GetActiveWeapon(), ply }
	} )

	if ( trace.Hit ) then pos = trace.HitPos + angle:Forward() * 24 elseif 
	!self.Owner:Crouching() then pos = pos - angle:Forward() * 110 + angle:Up()*8
	elseif self.Owner:Crouching() then pos = pos - angle:Forward() * 110 + angle:Up()*25
	end

	return pos, angle, fov
end
-----------------------------------------------------------------------------------------------------------------------------------------------	
function SWEP:Think()
if !IsValid(self) or !IsValid(self.Owner) then return end 

	if self:GetNWBool("GrenadeHoldType") == true then
		self:SetWeaponHoldType("grenade")
	end
	
	if self:GetNWBool("GrenadeHoldType") == false then
		self:SetWeaponHoldType("melee2")
	end
	
	if self:GetNWBool("KatanaJump") == true then
		self:SetWeaponHoldType("melee")
	end
	
	if self:GetNWBool("Katana_View_Cloak") == true then
		self.Owner:GetViewModel():SetMaterial("sprites/heatwave")
		 else
		self.Owner:GetViewModel():SetMaterial("")	
	end
	
	self.Owner:RemoveAllDecals()
		

	
	if ( CurTime() >= self.ShurikenDelay ) and self.ThrowTimer == false then
		if self.Owner:KeyPressed( IN_USE ) then
			self.ThrowTimer = true
			 self:ThrowShuriken()
			  self.ShurikenDelay = CurTime() + GetConVar( "RSK_Shuriken_Cooldown" ):GetInt()
		end
	end

	if !self.Owner:OnGround() then
	 self:SetNWBool( "KatanaJump", true )
	else
	 self:SetNWBool( "KatanaJump", false )
	end

end



function SWEP:ThrowShuriken()
if !IsValid(self) or !IsValid(self.Owner) then return end 
self:SetNWBool( "GrenadeHoldType", true )
timer.Simple(0.2, function()
if !IsValid(self) or !IsValid(self.Owner) then return end 
self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:EmitSound("weapons/shuriken/throw4.wav")	
	aim = self.Owner:GetAimVector()
	side = aim:Cross(Vector(0,0,1))
	up = side:Cross(aim)
	pos = self.Owner:GetShootPos() + side * 5 + up * -1
	if SERVER then
	local rocket = ents.Create("npc_shuriken")
	if !rocket:IsValid() then return false end
	rocket:SetAngles(aim:Angle()+Angle(90,90,0))
	rocket:SetPos(pos)
	rocket:SetOwner(self.Owner)
	rocket:Spawn()
	local phys = rocket:GetPhysicsObject()
    
	phys:ApplyForceCenter(self.Owner:GetAimVector() * 10000)
		self.ThrowTimer = false
	timer.Simple(0.5, function()
	if !IsValid(self) or !IsValid(self.Owner) then return end 
	self:SetNWBool( "GrenadeHoldType", false )
		end)
	end
	end)
end

function SWEP:Cloak()
    self:SetNWBool( "Katana_Cloak", true )
	 self:SetNWBool( "Katana_View_Cloak", true )
	  self:EmitSound("npc/dog/dog_idle2.wav")
	   self.Owner:DrawShadow( false ) 
	    self.Owner:SetMaterial("sprites/heatwave")
		
	if SERVER then
	self.Owner:DrawWorldModel( false ) 
	 self.Owner:SetNoTarget(true)
	 end
	 
	 self.StealthTimer = true
	 
	timer.Create("CloakTime",GetConVar( "RSK_Cloak_Duration" ):GetInt(), 1, function()
if !IsValid(self) or !IsValid(self.Owner) then return end 
	self.Weapon:SetNextSecondaryFire( CurTime() + GetConVar( "RSK_Cloak_Cooldown" ):GetInt() )
		self:EmitSound("npc/dog/dog_idle1.wav")
		 self.Owner:DrawShadow( true ) 
			self.Owner:SetMaterial("")
			    if SERVER then
					self.Owner:SetNoTarget(false)
						self.Owner:DrawWorldModel( true ) 
							end
				self:SetNWBool( "Katana_View_Cloak", false )		
				 self:SetNWBool( "Katana_Cloak", false )
	end)

end


