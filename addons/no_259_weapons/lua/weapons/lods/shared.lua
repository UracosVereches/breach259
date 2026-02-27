--[[
lua/weapons/lods/shared.lua
--]]
/* This addon was created by Kat Bug. Feel free to mess around with the code. 
If you decided to upload please give credit to me for being the original author. */
AddCSLuaFile("shared.lua")
game.AddParticles("particles/taunt_fx.pcf")
game.AddParticles("particles/item_fx.pcf")
PrecacheParticleSystem( "taunt_spy_cash" )
PrecacheParticleSystem( "utaunt_cash_confetti" )
PrecacheParticleSystem( "utaunt_disco_party" )
PrecacheParticleSystem( "utaunt_firework_teamcolor_red" )
PrecacheParticleSystem( "superrare_burning2" )
PrecacheParticleSystem( "unusual_orbit_cash" )
--SWEP.Category  		= "Other" 
if CLIENT then
	----SWEP.Author			= "KatBug"
	----SWEP.Contact		= ""
	--SWEP.Purpose		= "Beat the poor into submission with your wealth."
	----SWEP.Instructions	= "Primary: Wack da emone.\nSecondary: Da Dosh Dance.\nUse + Secondary: Dosh Inferno."
	SWEP.WepSelectIcon		= surface.GetTextureID( "VGUI/entities/lods" )
	--killicon.Add( "lods", "vgui/icons/dosh_--killicon", Color(255,255,255) )
end
SWEP.PrintName = "loadsamoney"
SWEP.Slot				= 0						
SWEP.SlotPos			= 5
SWEP.droppable				= false				
SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel		= "models/weapons/w_knife_t.mdl"
SWEP.ShowWorldModel = false
SWEP.AutoSwitchTo 			= true
SWEP.HoldType 		= "melee"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1 
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "cod4_7_62_39mm"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"



SWEP.ViewModelBoneMods = {
	["v_weapon.knife_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["dosh"] = { type = "Model", model = "models/props/cs_assault/Money.mdl", bone = "v_weapon.knife_Parent", rel = "", pos = Vector(0.546, -1.639, 2.438), angle = Angle(180, -88.624, 79.495), size = Vector(0.633, 0.633, 0.633), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["Dosh_Hat"] = { type = "Model", model = "models/player/items/spy/hat_first_nr.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.717, -0.806, 0.007), angle = Angle(-180, 110.527, 90.852), size = Vector(1.054, 1.054, 1.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} },
	["Dosh_Shades"] = { type = "Model", model = "models/player/items/demo/ttg_glasses.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.837, 1.212, -0.007), angle = Angle(0, -70.598, -90), size = Vector(0.736, 0.944, 0.669), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} },
	["w_dosh"] = { type = "Model", model = "models/props/cs_assault/Money.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.21, 1.7, -2.074), angle = Angle(82.833, -81.056, -10.049), size = Vector(0.665, 0.665, 0.665), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

local STable = {} -- The table the holds the sound sequences 
STable[1] = { [1] = "lods/l.wav", [2] = "lods/o.wav", [3] = "lods/d.wav", [4] = "lods/s.wav", [5] = "of.wav", [6] = "emone/e.wav", [7] = "emone/m.wav", [8] = "emone/o.wav", [9] = "emone/n.wav", [10] = "emone/e2.wav", [11] = { S = "whatsthatspell.wav", Time  = 1.25} , [12] = { S = "lodsaemone.wav", Time  = 1.9} }
STable[2] = { [1] = {S = "seq2/1.wav", Time = 1.7}, [2] = {S = "seq2/2.wav", Time = 1.8}, [3] = {S = "seq2/3.wav", Time = 0.6}, [4] = {S = "seq2/4.wav", Time = 1.8}, [5] = {S = "seq2/5.wav", Time = 0.6}}



function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetupDataTables()

	if CLIENT then
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

	
end

function SWEP:ResetVar() 
	self.Weapon:SetSSequence(1)
	self.Weapon:SetSCount(1)
	self.Weapon:SetSoundDelay(CurTime())	
end

function SWEP:SetupDataTables()
	--Set up the Netvars for the sound sequences
	self.Weapon:NetworkVar( "Int", 0, "SSequence" )
	self.Weapon:NetworkVar( "Int", 1, "SCount" )
	self.Weapon:NetworkVar( "Int", 2, "SoundDelay" )
	self.Weapon:SetSSequence(1)
	self.Weapon:SetSCount(1)
	self.Weapon:SetSoundDelay(CurTime())
	
end





--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	if self.Weapon:GetNextPrimaryFire() > CurTime() then return end
	if IsFirstTimePredicted() then self.Weapon:SetNextPrimaryFire(CurTime() + 0.3) end
	self:ShootEffects()
end

function SWEP:ShootEffects()
	if IsFirstTimePredicted() then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:EmitSound("Money.Swing")
		
		local Tar = {} -- Start the tracehull
		Tar.start = self.Owner:GetShootPos()
		Tar.endpos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 100
		Tar.filter = self.Owner
		Tar.mins = Vector( -5,-5,-2 )
		Tar.maxs = Vector( 5,5,2 )
		Tar.mask = MASK_SHOT_HULL
		self.Owner:LagCompensation( true ) -- Do some lag comp before running the trace. It helps keep client prediction fuck ups low.
		local tr = util.TraceHull( Tar )
		self.Owner:LagCompensation( false )
		if tr.Hit then -- Did we hit something?

			if IsValid(tr.Entity) and !tr.Entity:IsWorld() then -- Is the entity valid? Is the entity anything but the World?
				if SERVER then -- We only want to run this server side since dmginfo is a serverside only function
					local Dmg = DamageInfo()
					Dmg:SetAttacker(self.Owner)
					Dmg:SetInflictor(self.Weapon)
					Dmg:SetDamage(5)
					tr.Entity:TakeDamageInfo( Dmg ) -- Give the entity detected by the trace damage.
			
				end
			end
		
			self.Weapon:EmitSound("Money.Hit")
			self:CalcSound()
			-- The cash effect has a bit of an offset. This is fixed here.
			tr.HitPos.x = tr.HitPos.x -20
			tr.HitPos.z = tr.HitPos.z +20
			--tr.HitPos.y = tr.HitPos.y - 5
			ParticleEffect( "taunt_spy_cash", tr.HitPos, Angle(0,0,0) )
		end

	end
end

function SWEP:CalcSound()  --This holds all the calculations for the sound sequences
	if IsFirstTimePredicted() then
		local seq, count = self.Weapon:GetSSequence(), self.Weapon:GetSCount() -- Get the weapons current Sequence number and sound number

		if self.Weapon:GetSoundDelay() <= CurTime() then -- Is the delay over?
			if istable(STable[seq][count]) then -- Does the sequence have a table as a value? This is done because data will be handled differently if no table is present 
				self.Weapon:EmitSound(STable[seq][count].S)
				self.Weapon:SetSoundDelay(CurTime() + STable[seq][count].Time)
			else
				self.Weapon:EmitSound(STable[seq][count])
			end
			self.Weapon:SetSCount(count + 1) -- Up the sound count by one
		end
		
		if self.Weapon:GetSSequence() == 1 and self.Weapon:GetSCount() > 12 then -- Is sequnce one over?
			self.Weapon:SetSSequence(2)
			self.Weapon:SetSCount(1)
		elseif self.Weapon:GetSSequence() == 2 and self.Weapon:GetSCount() > 5 then -- Is sequnce two over?
			self.Weapon:SetSSequence(1)
			self.Weapon:SetSCount(1)
		end

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.35)	

	end
end
--[[---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()
	if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
	if IsFirstTimePredicted() then
		if !self.Owner:KeyDown(IN_USE) then -- if false then do the dosh dance.
			if SERVER then
				self.Owner:SendLua("RunConsoleCommand('act', 'dance')") -- Send the command to the player so they will dance.
				self.Owner.DoshMusic = nil 
				self.Owner.DoshMusic = CreateSound( self.Owner, "dancesec.wav" ) -- Set the song
				self.Owner.DoshMusic:Play()
				timer.Simple(11, function() if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() and self.Owner.DoshDance then self.Owner:StopParticles() self.Owner.DoshDance = false end end ) -- End the dance in 11 seconds if everything checks out

				
			end
			self.Owner.DoshDance = true
			self.Weapon:SetNextSecondaryFire(CurTime() + 30)
			--Start all the particles for the dance
			ParticleEffect( "utaunt_cash_confetti", self.Owner:GetPos(), Angle(0,0,0), self.Owner)
			ParticleEffect( "utaunt_disco_party", self.Owner:GetPos(), Angle(0,0,0), self.Owner)
			ParticleEffect( "utaunt_firework_teamcolor_red", self.Owner:GetPos(), Angle(0,0,0), self.Owner)
			timer.Simple(5, function() if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() and self.Owner.DoshDance then ParticleEffect( "utaunt_firework_teamcolor_red", self.Owner:GetPos(), Angle(0,0,0), self.Owner) end end ) -- Set off another set of fireworks in 5 sec
		else -- This is for the Dosh Inferno
			if self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_RH" )) and self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_LH" )) then -- Does the player's model have thease attachments?
				if SERVER  then 
					self.Owner:SendLua("RunConsoleCommand('act', 'zombie')") -- Run the command for the zombie animation
				
					self.Owner:EmitSound("ldeploy5.wav")
					self.Weapon:SetNextSecondaryFire(CurTime() + 30)
					local eyeang = Angle(self.Owner:EyeAngles():Forward()) -- Get the eye angles at start so it goes the way they faced when starting
					timer.Simple(0.6,function() -- In .6 seconds make the cash summon
						if IsValid(self) and IsValid(self.Owner) then
							local pos1 = self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_RH" ))
							local pos2 = self.Owner:GetAttachment(  self.Owner:LookupAttachment( "anim_attachment_LH" ))	
							
							ParticleEffect( "utaunt_cash_confetti", pos1.Pos, eyeang, self.Owner)
							ParticleEffect( "utaunt_cash_confetti", pos2.Pos, eyeang, self.Owner)
									
						end
					end)

					timer.Simple(2, function() if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then self.Owner:StopParticles() end end ) -- End the particles in 2 seconds  
				end
				local Pos = self.Owner:GetPos() -- Get the player's position 
				local Ents = ents.FindInBox( Pos + Vector( -500, -500, -100 ), Pos + Vector( 500, 500, 500) ) -- Find all the entities in a 500 unit radius around the player.

					for k, v in pairs(Ents) do -- Loop through all the entities found  
						if v:IsPlayer() and v != self.Owner and v:Alive() and !v.DoshBurn then -- Is the entity a player? Is the entity not the weapons owner? Is the entity alive? Is the entity not in dosh burn? 
							if SERVER then -- Set all the varibles for dosh burn
								v.DoshBurn = true 
								v.DoshBurnTime = CurTime() + 7 -- Set the time the player should burn
								v.DoshDamageDelay = CurTime() + 0.5 -- Set the time in between damage
								v.DoshAtt = self.Owner -- Set the attacker
								v.DoshWep = self.Weapon -- Set the attackign weapon
							end
							ParticleEffectAttach("utaunt_cash_confetti", PATTACH_ABSORIGIN_FOLLOW, v, 0) 
						elseif IsValid(v) and v:IsNPC() then
							if SERVER then -- This works pretty much the same as the player one except we keep the burning npc's in a table on the player
								v.DoshBurnTime = CurTime() + 7
								v.DoshDamageDelay = CurTime() + 0.5
								v.DoshAtt = self.Owner
								v.DoshWep = self.Weapon
								self.Owner.DoshBurnNPC[v:EntIndex( )] = v
							end
							ParticleEffectAttach("utaunt_cash_confetti", PATTACH_ABSORIGIN_FOLLOW, v, 0)
						end
					end
				timer.Simple(0.15, function()  ParticleEffectAttach("superrare_burning2", PATTACH_POINT_FOLLOW, self.Owner, 10) ParticleEffectAttach("superrare_burning2", PATTACH_POINT_FOLLOW, self.Owner, 11)end)
				
			end	
		end
	end
end

--[[---------------------------------------------------------
   Name: SWEP:CheckReload( )
   Desc: CheckReload
-----------------------------------------------------------]]


--[[---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
-----------------------------------------------------------]]
function SWEP:Reload()
	


	
end


--[[---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
-----------------------------------------------------------]]
function SWEP:Think()

	
	

end



--[[---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
-----------------------------------------------------------]]
function SWEP:Deploy()
	if IsFirstTimePredicted() then
		Vm = self.Owner:GetViewModel()
		if IsValid(Vm) then
			self.Weapon:SendWeaponAnim(ACT_VM_DEPLOY)
			self.AnimDuration = Vm:SequenceDuration()
			self.Weapon:SetNextPrimaryFire(CurTime() + self.AnimDuration)
			self.Weapon:SetNextSecondaryFire(CurTime() + self.AnimDuration)
			Vm:SetPlaybackRate(1)
			self:ResetVar()
		end
			math.randomseed( os.time() )
			local mon = math.random(1,6)
			self.Weapon:EmitSound(Sound("ldeploy"..mon..".wav"))
	end
	
	return true
end






function DoshDeath(ply,inf,att)
	if SERVER then -- This is just to make sure everything is stopped properly when the player dies.
		ply.DoshDance = false
		ply:StopParticles()
		if ply.DoshMusic and ply.DoshMusic:IsPlaying() then
			ply.DoshMusic:FadeOut( 0.5 )
		end
	end

end
hook.Add("PlayerDeath","DoshDeath",DoshDeath)





if SERVER then -- We only want these functions running server side. 
	function DoshBurnThink()

		for k ,v in pairs(player.GetAll()) do -- Loop through all the players
			if v.DoshBurn then -- Are they in dosh burn?
				if v.DoshBurnTime > CurTime() then -- Is the burn time not up?
					if v.DoshDamageDelay <= CurTime() then -- Is the damage delay up?
						local Dmg = DamageInfo()
						Dmg:SetAttacker(v.DoshAtt)
						Dmg:SetInflictor(v.DoshWep)
						Dmg:SetDamage(5)
						Dmg:SetDamageType( DMG_BURN )
						v:TakeDamageInfo( Dmg )
						v.DoshDamageDelay = CurTime() + 0.5 -- Set the next damage delay.
					end
				else
					v.DoshBurn = false
					v:StopParticles()
				end
			end
			if v.DoshBurnNPC then -- Does the player have the npc table. We don't want to attempt to read data from a table that does not exist.  
				for y , u in pairs(v.DoshBurnNPC) do --Loop through the table
					if IsValid(u)  then -- Is the entity valid?
						if u.DoshBurnTime > CurTime() then-- Is the burn time not up?
							if u.DoshDamageDelay <= CurTime() then -- Is the damage delay up?
								local Dmg = DamageInfo()
								Dmg:SetAttacker(u.DoshAtt)
								Dmg:SetInflictor(u.DoshWep)
								Dmg:SetDamage(5)
								Dmg:SetDamageType( DMG_BURN )
								u:TakeDamageInfo( Dmg )
								u.DoshDamageDelay = CurTime() + 0.5
							end
						else
							v.DoshBurnNPC[u:EntIndex()] = nil -- remove the entity from the table.
							u:StopParticles()
						end
					else
						v.DoshBurnNPC[u:EntIndex()] = nil -- remove the entity from the table.
					end
				end
			end 		
		end

		
	end
	hook.Add("Think","DoshBurnThink",DoshBurnThink)


	function DoshNPCTab(ply)


		ply.DoshBurnNPC = {} -- Create the npc table on the player when they first spawn.

	end
	hook.Add("PlayerInitialSpawn","DoshNPCTab",DoshNPCTab)
end



/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/



function SWEP:Holster()
	if self.Owner.DoshDance then return end
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end




