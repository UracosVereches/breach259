--[[
gamemodes/breach/entities/weapons/br_keycard_4.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/card_lvl3")
	SWEP.BounceWeaponIcon = true
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/c_keycard_new.mdl"
SWEP.WorldModel		= "models/breach/keycard_new.mdl"
SWEP.PrintName		= "Ключ-карта 3-его уровня"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "slam"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.UseHands		= true

SWEP.droppable				= true
SWEP.teams					= {2,3,5,6,7,8,9,10,11}
SWEP.Access					= 0
SWEP.Level 					= 3

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  true

local vec_offset = Vector( 3, -3, -4 )
local angle_offset = Angle( -90, 180, 180 )

SWEP.Pos = vec_offset
SWEP.Ang = angle_offset

function SWEP:CreateWorldModel()

  if ( !self.WModel ) then

    self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
    self.WModel:SetNoDraw( true )
		self.WModel:AddEffects( EF_NORECEIVESHADOW )

  end

  return self.WModel

end

function SWEP:GetBetterOne()
	local r = math.random(1,100)
	if buttonstatus == 3 then
		if r < 50 then
			return "br_keycard_5"
		else
			return "br_keycard_4"
		end
	elseif buttonstatus == 4 then
		if r < 20 then
			return "br_keycard_6"
		elseif r < 40 then
			return "br_keycard_5"
		else
			return "br_keycard_4"
		end
	end
	return "br_keycard_4"
end

--[[function SWEP:HandleUpgrade( mode, exit )
	local t = self:GetNWBool( "K_TYPE", nil )
	if !t then
		self:SetPos( exit )
		return
	end
	local dice = math.random( 0, 99 )
	if t == "safe" then
		if mode == 0 or mode == 1 then
			if dice < 25 then
				self:Remove()
				return
			end
		elseif mode == 3 then
			if dice < 60 then self:SetKeycardType( "euclid" ) end
		elseif mode == 4 then
			if dice < 30 then self:SetKeycardType( "euclid" ) end
			if dice >= 30 and dice < 50 then self:SetKeycardType( "keter" ) end
		end
	elseif t == "euclid" then
		if mode == 0 then
			if dice < 25 then
				self:Remove()
				return
			end
		elseif mode == 1 then
			if dice < 50 then self:SetKeycardType( "safe" ) end
		elseif mode == 2 then
			if dice < 50 then self:SetKeycardType( "res" ) end
		elseif mode == 3 then
			if dice < 50 then self:SetKeycardType( "keter" ) end
		elseif mode == 4 then
			if dice < 75 then self:SetKeycardType( "keter" ) end
		end
	elseif t == "keter" then
		if mode == 0 then
			if dice < 25 then
				self:Remove()
				return
			end
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			if dice < 75 then self:SetKeycardType( "euclid" ) end
		elseif mode == 2 then
			self:SetKeycardType( "res" )
		elseif mode == 4 then
			if dice < 10 then self:SetKeycardType( "com" ) end
			if dice >= 10 and dice < 30 then
				self:Remove()
				return
			end
		end
	elseif t == "res" then
		if mode == 0 then
			if dice < 50 then self:SetKeycardType( "safe" ) end
		elseif mode == 1 then
			if dice < 75 then self:SetKeycardType( "euclid" ) end
		elseif mode == 2 then
			self:SetKeycardType( "keter" )
		elseif mode == 3 then
			if dice < 75 then self:SetKeycardType( "csp" ) end
		elseif mode == 4 then
			if dice < 10 then self:SetKeycardType( "com" ) end
			if dice >= 10 and dice < 25 then self:SetKeycardType( "mtf" ) end
		end
	elseif t == "cps" then
		if mode == 0 then
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			self:SetKeycardType( "keter" )
		elseif mode == 2 then
			self:SetKeycardType( "res" )
		elseif mode == 3 then
			if dice < 40 then self:SetKeycardType( "mtf" ) end
		elseif mode == 4 then
			if dice < 20 then self:SetKeycardType( "ci" ) end
			if dice >= 20 and dice < 50 then self:SetKeycardType( "mtf" ) end
		end
	elseif t == "mtf" then
		if mode == 0 then
			self:SetKeycardType( "keter" )
		elseif mode == 1 then
			if dice < 75 then self:SetKeycardType( "euclid" ) end
			if dice >= 75 and dice < 100 then self:SetKeycardType( "res" ) end
		elseif mode == 2 then
			self:SetKeycardType( "res" )
		elseif mode == 3 then
			if dice < 40 then self:SetKeycardType( "com" ) end
		elseif mode == 4 then
			if dice < 20 then self:SetKeycardType( "ci" ) end
			if dice >= 20 and dice < 40 then self:SetKeycardType( "com" ) end
		end	
	elseif t == "com" then
		if mode == 0 then
			self:Remove()
			return
		elseif mode == 1 then
			self:Remove()
			return
		elseif mode == 2 then
			if dice < 50 then self:SetKeycardType( "ci" ) end
		elseif mode == 3 then
			if dice < 15 then self:SetKeycardType( "omni" ) end
			if dice >= 15 and dice < 30 then self:SetKeycardType( "ci" ) end
		elseif mode == 4 then
			if dice < 50 then self:SetKeycardType( "omni" ) end
			if dice >= 50 and dice < 75 then
				self:Remove()
				return
			end
		end	
	elseif t == "omni" then
		if mode == 0 then
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			self:SetKeycardType( "cps" )
		elseif mode == 2 then
			self:SetKeycardType( "ci" )
		elseif mode == 4 then
			self:Remove()
			return
		end	
	elseif t == "ci" then
		if mode == 0 then
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			self:SetKeycardType( "keter" )
		elseif mode == 2 then
			self:SetKeycardType( "mtf" )
		elseif mode == 3 then
			if dice < 50 then self:SetKeycardType( "omni" ) end
		elseif mode == 4 then
			if dice < 75 then self:SetKeycardType( "omni" ) end
			if dice >= 75 and dice < 100 then
				self:Remove()
				return
			end
		end	
	end
	self:SetPos( exit )
end]]

SWEP.Lang = nil

function SWEP:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD) 

	self:SetHoldType( self.HoldType )
	if CLIENT then
		self.Lang = GetWeaponLang().KEYCARD
		----self.Author			= self.Lang.author
		--self.Contact		= self.Lang.contact
		--self.Contact		= self.Lang.purpose

		self.WM = ClientsideModel( self.WorldModel )
		self.WM:SetNoDraw( true )
	else
		self:SetKeycardType( "keter" )
	end
	self:SetHoldType("normal")
	
end

function SWEP:SetKeycardType( t )
	--print( "setting type: "..t )
	if SERVER then 
		self:SetNWString( "K_TYPE", t )
		self.KeycardType = t
	end

	local acc = "00000000000"
	if t == "euclid" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[2]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_lvl2.vmt" )
		else
			self:SetNWInt( "SKIN", 1 )
		end
		self:SetSkin( 1 )
		acc = "00000000011"
	elseif t == "res" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[4]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_res.vmt" )
		else
			self:SetNWInt( "SKIN", 7 )
		end
		self:SetSkin( 7 )
		acc = "00000000111"			
	elseif t == "keter" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[3]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_lvl3.vmt" )
		else
			self:SetNWInt( "SKIN", 2 )
		end
		self:SetSkin( 2 )
		acc = "00000001111"
	elseif t == "mtf" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[5]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_gguard.vmt" )
		else
			self:SetNWInt( "SKIN", 4 )
		end
		self:SetSkin( 4 )
		acc = "00000011111"
	elseif t == "com" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[6]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_com.vmt" )
		else
			self:SetNWInt( "SKIN", 5 )
		end
		self:SetSkin( 5 )
		acc = "11000011111"
	elseif t == "omni" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[7]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_omni.vmt" )
		else
			self:SetNWInt( "SKIN", 3 )
		end
		self:SetSkin( 3 )
		acc = "11111011111"
	elseif t == "cps" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[8]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_cps.vmt" )
		else
			self:SetNWInt( "SKIN", 6 )
		end
		self:SetSkin( 6 )
		acc = "01000011111"
	elseif t == "ci" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[9]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_crached.vmt" )
		else
			self:SetNWInt( "SKIN", 8 )
		end
		self:SetSkin( 8 )
		acc = "11000011111"
	elseif t == "goc" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[10]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_goc.vmt" )
		else
			self:SetNWInt( "SKIN", 9 )
		end
		self:SetSkin( 9 )
		acc = "11000111111"
	else
		if CLIENT then
			self.PrintName = self.Lang.NAMES[1]
			self.WepSelectIcon = surface.GetTextureID( "vgui/entities/card_lvl1.vmt" )
		else
			self:SetNWInt( "SKIN", 0 )
		end
		self:SetSkin( 0 )
		acc = "00000000001"
	end

	if CLIENT then
		local desc = { self.Lang.instructions, {} }
		local len = string.len( acc )
		for i = len, 1, -1 do
			local is = string.sub( acc, i, i ) == "1" and 1 or 2
			local ins = self.Lang.ACC[len - ( i - 1 )]
			desc[2][len - ( i - 1 )] = { ins, is }
		end
		self.AC_Doors = desc
	end

	self.Access = tonumber( acc, 2 )
	
end

function SWEP:Deploy()
	--self.Owner:DrawViewModel( true )
	self:SetHoldType( self.HoldType )
end

function SWEP:Equip( owner )
	self:Deploy()
	
end

function SWEP:Holster()
	return true
end
function SWEP:PreDrawViewModel( vm, wep, ply )
	vm:SetSkin( self:GetNWInt( "SKIN", 0 ) )
end


function SWEP:OnRemove()
	if CLIENT then
		if IsValid( self.WM ) then
			self.WM:Remove()
		end
	end
end

SWEP.C_Init = false
SWEP.CurType = ""
SWEP.LThink = 0
function SWEP:Think()
if self.Owner:KeyPressed(IN_USE) then
		self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
	if self.LThink > CurTime() then return end
	self.LThink = CurTime() + 0.5
	local t = self:GetNWBool( "K_TYPE", nil )
	if CLIENT and ( !self.C_Init or self.CurType != t ) then
		if t then
			self.C_Init = true
			self.CurType = t
			self:SetKeycardType( t )
		end
	end
	
end

function SWEP:Reload()
	if CLIENT then
		self.DHUD = CurTime() + 0.01
	end
	return
end

function SWEP:PrimaryAttack()
	if SERVER then
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 85,
			filter = self.Owner
		} )
		if tr.Hit then
			local ent = tr.Entity
			if IsValid( ent ) then
				if gamemode.Call( "PlayerUse", self.Owner, ent ) then
					ent:Use( self.Owner, self, USE_TOGGLE, 1 )
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then
		self.DHUD = CurTime() + 0.01
	end
	return
end




function SWEP:DrawWorldModel()

	if ( ( self.Owner && self.Owner:IsValid() ) ) then

	 	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")

		if ( !bone ) then return end

	 	local pos, ang = self.Owner:GetBonePosition(bone)

		local wm = self:CreateWorldModel()

	  if ( wm && wm:IsValid() ) then

	    ang:RotateAroundAxis(ang:Right(), self.Ang.p)
	    ang:RotateAroundAxis(ang:Forward(), self.Ang.y)
	    ang:RotateAroundAxis(ang:Up(), self.Ang.r)
	    wm:SetRenderOrigin(pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z)
	    wm:SetRenderAngles(ang)
	    wm:SetSkin( self:GetNWInt( "SKIN", 0 ) )
	    wm:DrawModel()

	 	end

	else

		self:DrawModel()

	end

	if !IsValid( self.Owner ) then
		self:DrawModel()
	else
		if !IsValid( self.WM ) then
			self.WM = ClientsideModel( self.WorldModel )
			self.WM:SetNoDraw( true )
		end


		if not boneid then
			return
		end

		local matrix = self.Owner:GetBoneMatrix( boneid )
		if not matrix then
			return
		end

		local newpos, newang = LocalToWorld( self.WorldModelPositionOffset, self.WorldModelAngleOffset, matrix:GetTranslation(), matrix:GetAngles() )

		self.WM:SetPos( newpos )
		self.WM:SetAngles( newang )
		self.WM:SetupBones()
		self.WM:SetSkin( self:GetNWInt( "SKIN", 0 ) )
		self.WM:DrawModel()
	end
end

SWEP.DHUD = 0
--just adding some text here instead of drawhud

