--[[
lua/weapons/weapon_flashlight.lua
--]]
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.AdminSpawnable = true

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/flash_light")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = "Фонарик"

SWEP.ViewModel			= "models/weapons/tfa_nmrih/v_item_maglite.mdl" --Viewmodel path
SWEP.ViewModelFOV = 50
//SWEP.RenderGroup = RENDERGROUP_BOTH

SWEP.WorldModel			= "models/weapons/w_flashlight_new12.mdl" --Viewmodel path
SWEP.HoldType = "slam"
SWEP.DefaultHoldType = "slam"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -0.5,
        Right = 2,
        Forward = 5.5,
        },
        Ang = {
        Up = -1,
        Right = 5,
        Forward = 178
        },
		Scale = 1.2
}

SWEP.Primary.Sound = Sound("Weapon_Melee.CrowbarLight")
SWEP.Secondary.Sound = Sound("Weapon_Melee.CrowbarHeavy")

SWEP.MoveSpeed = 1.0
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed

SWEP.InspectPos = Vector(8.418, 0, 15.241)
SWEP.InspectAng = Vector(-9.146, 9.145, 17.709)

SWEP.Primary.Blunt = true
SWEP.Primary.Damage = 25
SWEP.droppable				= true
SWEP.Primary.Reach = 40
SWEP.Primary.RPM = 90
SWEP.Primary.SoundDelay = 0
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.ClipSize	= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.ClipSize	= 0
SWEP.Primary.Delay = 0.3
SWEP.Primary.Window = 0.2
SWEP.Primary.Automatic = false

SWEP.MoveSpeed = 1
SWEP.AllowViewAttachment = false

local matLight = Material( "sprites/light_ignorez" )
function SWEP:Initialize()
    self:SetHoldType( "slam" )
end
function SWEP:PrimaryAttack()
	if CLIENT then return end
	if !IsValid(self) || !IsValid(self.Owner) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:EmitSound("slashers/effects/flashlight_toggle.wav", 75, 100, 0.6)

	if !IsValid(self.projectedLight) then
		self:BuildLight()
		return
	end

	self.Active = !self.Active
	if self.Active then
		self.projectedLight:Fire("TurnOn")
	else
		self.projectedLight:Fire("TurnOff")
	end
end

function SWEP:Reload()

end

function SWEP:PrimarySlash()

end

function SWEP:Holster()
	SafeRemoveEntity(self.projectedLight)
	self.Owner:SetNWEntity("FL_Flashlight", nil)
	self.Active = false

	return true
end

function SWEP:BuildLight()
	if CLIENT then return end
	if !IsValid(self) || !IsValid(self.Owner) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self then return end

	self.projectedLight = ents.Create( "env_projectedtexture" )
	self.projectedLight:SetLagCompensated(true)
	self.projectedLight:SetPos( self.Owner:EyePos() )
	self.projectedLight:SetAngles( self.Owner:EyeAngles() )
	self.projectedLight:SetKeyValue( "enableshadows", 0 )
	self.projectedLight:SetKeyValue( "farz", 300 )
	self.projectedLight:SetKeyValue( "lightworld", 1 )
	self.projectedLight:SetKeyValue( "nearz", 1 )
	self.projectedLight:SetKeyValue( "lightfov", 100 )
	self.projectedLight:SetKeyValue( "lightcolor", "255 255 255 255" )
	self.projectedLight:Spawn()
    self.projectedLight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )

	self.Owner:SetNWEntity("FL_Flashlight", self.projectedLight)

	self.Active = true
end

function SWEP:Think()
	if SERVER && IsValid(self.projectedLight) then
		self.projectedLight:SetPos( self.Owner:EyePos() + self.Owner:GetAimVector() * 20 );
		self.projectedLight:SetAngles( self.Owner:EyeAngles() );
		--print("wow")
	end
	if self.Owner:GetNWBool("IsInsideLocker") == true then  -- Фикс шкафчика
	    SafeRemoveEntity(self.projectedLight)
	    self.Owner:SetNWEntity("FL_Flashlight", nil)
		--print("Deactivated")
	    self.Active = false
		
	end
end

--[[
hook.Add("PlayerDeath", "TurnOffFlashlight", function() 
    if victim:GetActiveWeapon():GetClass() == "weapon_flashlight" then 
    victim:SetNWEntity("FL_Flashlight", false)
	
	end
end)]]
function SWEP:OnDrop() 
    self.Owner:SetNWEntity("FL_Flashlight", false)
	self.Active = false
    SafeRemoveEntity(self.projectedLight)
	return true
end

local function UpdateFlashlight()
	local pjs = LocalPlayer():GetNWEntity("FL_Flashlight")
	if IsValid( pjs ) then
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_flashlight" then
			local bid = LocalPlayer():GetViewModel():LookupAttachment( "Light" )
			local bp, ba = LocalPlayer():GetViewModel():GetBonePosition( bid )
			ba:RotateAroundAxis(ba:Up(), -90)
			pjs:SetPos( bp +ba:Forward() * -3.5 );
			pjs:SetAngles( ba );
			pjs:SetParent(LocalPlayer():GetViewModel(), LocalPlayer():GetViewModel():LookupAttachment("light"))
		end
	end
end

function SWEP:CalcViewModelView( ent, oldPos, oldAng, pos, ang )
	if LocalPlayer():GTeam() == TEAM_GUARD then
		local pjs = LocalPlayer():GetNWEntity( 'FL_Flashlight' )
		if IsValid( pjs ) then
			local bid = LocalPlayer():GetViewModel():LookupAttachment("light")
			local bp = LocalPlayer():GetViewModel():GetAttachment(bid)
			local ang = bp.Ang
			local pos = bp.Pos
			--ba:RotateAroundAxis(ba:Up(), -90)
			pjs:SetPos( pos +ang:Forward() * -5 );
			pjs:SetAngles( ang );
		end
	end
end

