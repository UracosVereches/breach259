
local mply = FindMetaTable( "Player" )

// just for finding a bad spawns :p
function mply:FindClosest(tab, num)
	local allradiuses = {}
	for k,v in pairs(tab) do
		table.ForceInsert(allradiuses, {v:Distance(self:GetPos()), v})
	end
	table.sort( allradiuses, function( a, b ) return a[1] < b[1] end )
	local rtab = {}
	for i=1, num do
		if i <= #allradiuses then
			table.ForceInsert(rtab, allradiuses[i])
		end
	end
	return rtab
end

function mply:GiveRandomWep(tab)
	local mainwep = table.Random(tab)
	self:Give(mainwep)
	local getwep = self:GetWeapon(mainwep)
	if getwep.Primary == nil then
		print("ERROR: weapon: " .. mainwep)
		print(getwep)
		return
	end
	getwep:SetClip1(getwep.Primary.ClipSize)
	self:SelectWeapon(mainwep)
	self:GiveAmmo((getwep.Primary.ClipSize * 4), getwep.Primary.Ammo, false)
end

function mply:ReduceKarma(amount)
	if KarmaEnabled() == false then return end
	self.Karma = math.Clamp((self.Karma - amount), 1, MaxKarma())
end

function mply:AddKarma(amount)
	if KarmaEnabled() == false then return end
	self.Karma = math.Clamp((self.Karma + amount), 1, MaxKarma())
end

function mply:SetKarma(amount)
	if KarmaEnabled() == false then return end
	self.Karma = math.Clamp(amount, 1, MaxKarma())
end

function mply:UpdateNKarma()
	if KarmaEnabled() == false then return end
	if self.SetNKarma != nil then
		self:SetNKarma(self.Karma)
	end
end

function mply:SaveKarma()
	if KarmaEnabled() == false then return end
	if SaveKarma() == false then return end
	self:SetPData( "breach_karma", self.Karma )
end

function mply:GiveNTFwep()
	self:GiveRandomWep({"cw_ump45", "cw_mp5"})
end

function mply:GiveMTFwep()
	self:GiveRandomWep({"cw_ar15", "cw_ump45", "cw_mp5"})
end

function mply:GiveCIwep()
	self:GiveRandomWep({"cw_ak74", "cw_scarh", "cw_g36c"})
end

function mply:DeleteItems()
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 150 )) do
		if v:IsWeapon() then
			if !IsValid(v.Owner) then
				v:Remove()
			end
		end
	end
end

function mply:ApplyArmor(name)
	self.BaseStats = {
		wspeed = self:GetWalkSpeed(),
		rspeed = self:GetRunSpeed(),
		jpower = self:GetJumpPower(),
		 model = self:GetModel()
	}
	local stats = 0.9
	if name == "armor_ntf" then
		--self:SetModel("models/scp/ntf_new.mdl")
		stats = 0.8
	elseif name == "armor_mtfguard" then
		self:SetModel("models/scp/mog_regular_new.mdl")
		stats = 0.85
		--self:SetArmor(100)
	elseif name == "armor_mtfcom" then
		--self:SetModel("models/scp/captain.mdl")
		stats = 0.9
	elseif name == "armor_mtfl" then
		--self:SetModel("models/scp/mog_regular_new.mdl")
		stats = 0.85
	elseif name == "armor_mtfmedic" then
		--self:SetModel("models/scp/mog_regular_new.mdl")
		stats = 0.9
	elseif name == "armor_security" then
		--self:SetModel("models/scp/mog_regular_new.mdl")
		stats = 0.92
	elseif name == "armor_fireproof" then
		self:SetModel("models/scp/hazmat_new.mdl")
		stats = 0.9
		--self:SetArmor(20)
	elseif name == "armor_chaosins" then
		--self:SetModel("models/scp/chaos_new.mdl")
		stats = 0.85
	elseif name == "armor_hazmat" then
		--self:SetModel("models/scp/mog_regular_new.mdl")
		stats = 0.93
	elseif name == "armor_electroproof" then
		--self:SetModel("models/scp/mog_regular_new.mdl")
		stats = 0.8
	elseif name == "armor_csecurity" then
		--self:SetModel("models/scp/mog_regular_new.mdl")
		stats = 0.91
	end
	--self:SetWalkSpeed(self.BaseStats.wspeed * stats)
	--self:SetRunSpeed(self.BaseStats.rspeed * stats)
	--self:SetJumpPower(self.BaseStats.jpower * stats)
	self.UsingArmor = name
end

function mply:UnUseArmor()
	if self.UsingArmor == nil then return end
	self:SetWalkSpeed(self.BaseStats.wspeed)
	self:SetRunSpeed(self.BaseStats.rspeed)
	self:SetJumpPower(self.BaseStats.jpower)
	self:SetModel(self.BaseStats.model)
	local item = ents.Create( self.UsingArmor )
	if IsValid( item ) then
		item:Spawn()
		item:SetPos( self:GetPos() )
		self:EmitSound( Sound("npc/combine_soldier/gear".. math.random(1, 6).. ".wav") )
	end
	self.UsingArmor = nil
end

--custom nextoren scp spawns

function mply:SetSCP062DE()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_062DE)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP062DE)
	self:SetModel("models/scp_fritz.mdl")
	self:SetHealth(1000)
	self:SetMaxHealth(1000)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(150)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("cw_kk_ins2_mp40de")
	self:SelectWeapon("cw_kk_ins2_mp40de")
	--self:GiveAmmo(9999, "Pistol", false)
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSpectator()
	self:SetNWString("role", "Spectator")
	self:Flashlight( false )
	self:AllowFlashlight( false )
	self.handsmodel = nil
	self:Spectate( OBS_MODE_ROAMING )
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SPEC)
	self:SetNoDraw(true)
	self:SetNWEntity("RagdollEntityNO", NULL)
	self:SetMoveType(MOVETYPE_OBSERVER)
	self:SetModel("models/props_junk/watermelon01.mdl")
	if self.SetNClass then
		self:SetNClass(ROLES.ROLE_SPEC)
	end
	self.Active = true
	print("[RXSEND] Adding " .. self:Nick() .. " to spectators")
	self.canblink = false
	self:SetNoTarget( true )
	self.BaseStats = nil
	self.UsingArmor = nil
	self:PhysicsInit(SOLID_NONE)
	//self:Spectate(OBS_MODE_IN_EYE)
end

function mply:SetSCPSantaJ()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos( SPAWN_SANTA )
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam( TEAM_SCP )
	self:SetNClass( ROLES.ROLE_SCPSantaJ )
	self:SetModel( "models/player/christmas/santa.mdl" )
	self:SetHealth( 2250 )
	self:SetMaxHealth( 2250 )
	self:SetArmor( 0 )
	self:SetWalkSpeed( 160 )
	self:SetRunSpeed( 160 )
	self:SetMaxSpeed( 160 )
	self:SetJumpPower( 200 )
	self:SetNoDraw( false )
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = true
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give( "weapon_scp_santaJ" )
	self:SelectWeapon("weapon_scp_santaJ")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP173()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_173)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP173)
	self:SetModel("models/breach173.mdl")
	self:SetHealth(5000)
	self:SetMaxHealth(5000)
	self:SetArmor(0)
	self:SetWalkSpeed(350)
	self:SetRunSpeed(350)
	self:SetMaxSpeed(350)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = true
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_173")
	self:SelectWeapon("weapon_scp_173")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP106()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_106)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP106)
	self:SetModel("models/scp/106/unity/unity_scp_106_player.mdl")
	self:SetHealth(2250)
	self:SetMaxHealth(2250)
	self:SetArmor(0)
	self:SetWalkSpeed(160)
	self:SetRunSpeed(160)
	self:SetMaxSpeed(160)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_106")
	self:SelectWeapon("weapon_scp_106")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetCustomCollisionCheck( true )
end

function mply:SetSCP066()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_066)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP066)
	self:SetModel("models/player/mrsilver/scp_066pm/scp_066_pm.mdl")
	self:SetHealth(2000)
	self:SetMaxHealth(2000)
	self:SetArmor(0)
	self:SetWalkSpeed(160)
	self:SetRunSpeed(160)
	self:SetMaxSpeed(160)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = true
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_066")
	self:SelectWeapon("weapon_scp_066")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP049()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_049)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP049)
	self:SetModel("models/scp/049_v2.mdl")
	self:SetHealth(3100)
	self:SetMaxHealth(3100)
	self:SetArmor(0)
	self:SetWalkSpeed(135)
	self:SetRunSpeed(135)
	self:SetMaxSpeed(135)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_0497")
	self:SelectWeapon("weapon_scp_0497")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP457()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_457)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP457)
	self:SetModel("models/scp/burning_fag.mdl")
	//self:SetMaterial( "models/flesh", false )
	self:SetHealth(2500)
	self:SetMaxHealth(2500)
	self:SetArmor(0)
	self:SetWalkSpeed(135)
	self:SetRunSpeed(135)
	self:SetMaxSpeed(135)
	self:SetJumpPower(190)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_4578")
	self:SelectWeapon("weapon_scp_4578")
	self.BaseStats = nil
	self.UsingArmor = nil
end
--[[
function mply:SetSCP076()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_076)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP076)
	self:SetModel("models/abel/abel.mdl")
	//self:SetMaterial( "models/flesh", false )
	self:SetHealth(2000)
	self:SetMaxHealth(2000)
	self:SetArmor(0)
	self:SetWalkSpeed(240)
	self:SetRunSpeed(300)
	self:SetMaxSpeed(300)
	self:SetJumpPower(240)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_076")
	self:SelectWeapon("weapon_scp_076")
	self.BaseStats = nil
	self.UsingArmor = nil
end
--]]

function mply:SetSCP035()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_035)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP035)
	self:SetModel("models/scp_035/035_new.mdl")
	self:SetHealth(3000)
	self:SetMaxHealth(3000)
	self:SetArmor(0)
	self:SetWalkSpeed(135)
	self:SetRunSpeed(135)
	self:SetMaxSpeed(135)
	self:SetJumpPower(190)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_0350")
	self:SelectWeapon("weapon_scp_0350")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP966()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:DrawShadow(false)
	self:SetPos(SPAWN_966)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP966)
	self:SetModel("models/scp/966.mdl")
	//self:SetMaterial("966black/966black", false)
	self:SetColor(Color(255, 255, 255, 0))
	self:SetHealth(750)
	self:SetMaxHealth(750)
	self:SetArmor(0)
	self:SetWalkSpeed(140)
	self:SetRunSpeed(140)
	self:SetMaxSpeed(140)
	self:SetJumpPower(200)
	self:SetNoDraw(true)
	self:SetColor(Color(255, 255, 255, 0)) 
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_966")
	self:SelectWeapon("weapon_scp_966")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP096()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_096)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP096)
	self:SetModel("models/cult/scp/096/scp_096.mdl")
	self:SetHealth(1400)
	self:SetMaxHealth(1400)
	self:SetArmor(0)
	self:SetWalkSpeed(80)
	self:SetRunSpeed(80)
	self:SetMaxSpeed(500)
	self:SetJumpPower(80)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp096")
	self:SelectWeapon("weapon_scp096")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP999()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(193, -1793, -100))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP9992)
	self:SetModel("models/scp/scp_999_new.mdl")
	self:SetHealth(1500)
	self:SetMaxHealth(1500)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_999")
	self:SelectWeapon("weapon_scp_999")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP939()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_939)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP939)
	self:SetModel("models/scp/scp_939_new.mdl")
	self:SetHealth(2100)
	self:SetMaxHealth(2100)
	self:SetArmor(0)
	self:SetWalkSpeed(200)
	self:SetRunSpeed(200)
	self:SetMaxSpeed(200)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = true
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_939")
	self:SelectWeapon("weapon_scp_939")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP050FR()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(5222.075684, 497.558197, 54.031647))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP050)
	self:SetModel("models/scp/scp_japan_fr.mdl")
	self:SetHealth(2100)
	self:SetMaxHealth(2100)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(0)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = true
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("poke_ghost_phantomforce")
	self:SelectWeapon("poke_ghost_phantomforce")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP689()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_689)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP689)
	self:SetModel("models/dwdarksouls/models/darkwraith.mdl")
	self:SetHealth(2000)
	self:SetMaxHealth(2000)
	self:SetArmor(0)
	self:SetWalkSpeed(75)
	self:SetRunSpeed(75)
	self:SetMaxSpeed(75)
	self:SetJumpPower(125)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_689")
	self:SelectWeapon("weapon_scp_689")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP682()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_682)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP682)
	self:SetModel("models/scp/scp_crock_v3.mdl")
	self:SetHealth(6000)
	self:SetMaxHealth(6000)
	self:SetArmor(0)
	self:SetWalkSpeed(115)
	self:SetRunSpeed(115)
	self:SetMaxSpeed(115)
	self:SetJumpPower(0)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = true
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_1732")
	self:SelectWeapon("weapon_scp_1732")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP082()
	self:Flashlight( false )
	self.handsmodel = nil--"models/weapons/arms/v_arms_savini.mdl"
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(5245, -190, 52))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP082)
	self:SetModel("models/cultist_kun/scp_082.mdl")
	self:SetBodygroup(self:FindBodygroupByName( "Mask" ), 1)
	self:SetHealth(1700)
	self:SetMaxHealth(2500)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(400)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_0822")
	self:SelectWeapon("weapon_scp_0822")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP542()
	self:Flashlight( false )
	self.handsmodel = nil--"models/weapons/arms/v_arms_savini.mdl"
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_542)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP542)
	self:SetModel("models/cultist_kun/herr_doc.mdl")
	self:SetBodygroup(self:FindBodygroupByName( "Mask" ), 1)
	self:SetHealth(1700)
	self:SetMaxHealth(2500)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(400)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("doctor")
	self:SelectWeapon("doctor")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP023()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(table.Random(SPAWN_023))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP023)
	self:SetModel("models/player/stenli/lycan_werewolf.mdl")
	self:SetHealth(2000)
	self:SetMaxHealth(2000)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(230)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_023")
	self:SelectWeapon("weapon_scp_023")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP1471()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_1471)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP1471)
	self:SetModel("models/burd/scp1471/scp1471.mdl")
	self:SetHealth(1250)
	self:SetMaxHealth(1250)
	self:SetArmor(0)
	self:SetWalkSpeed(165)
	self:SetRunSpeed(165)
	self:SetMaxSpeed(165)
	self:SetJumpPower(200)
	--self:SetColor(Color(255, 255, 255, 0)) 
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_1471")
	self:SelectWeapon("weapon_scp_1471")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP1903()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(5342, -583, 10))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP1903)
	self:SetModel("models/cultist/scp/scp_1903.mdl")
	self:SetHealth(3000)
	self:SetMaxHealth(3000)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(170)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_1980")
	self:SelectWeapon("weapon_scp_1980")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP638()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(4905.85546875, -189.87673950195, 0.03125))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP638)
	self:SetModel("models/player/valley/outlast/patient_8/patient_8.mdl")
	self:SetHealth(6000)
	self:SetMaxHealth(6000)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_kleyto")
	self:SelectWeapon("weapon_kleyto")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP811()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(5518.212890625, 206.85461425781, 1.03125))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP811)
	self:SetModel("models/scp/scp_811.mdl")
	self:SetHealth(3000)
	self:SetMaxHealth(3000)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(170)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_acidpuke")
	self:SelectWeapon("weapon_acidpuke")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP1048()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(5295, 2289, 23))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP1048)
	self:SetModel("models/scp/1048-a.mdl")
	self:SetHealth(1500)
	self:SetMaxHealth(1500)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(0)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_1048a")
	self:SelectWeapon("weapon_scp_1048a")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP062()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(4172, -780, 41))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP062)
	self:SetModel("models/scp/scp_hunter_fr.mdl")
	self:SetHealth(1500)
	self:SetMaxHealth(1500)
	self:SetArmor(0)
	self:SetWalkSpeed(130)
	self:SetRunSpeed(130)
	self:SetMaxSpeed(130)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_ttt_evolveknife")
	self:SelectWeapon("weapon_ttt_evolveknife")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP1048B()
	self:Flashlight( false )
	self.handsmodel = nil--"models/player/teddy_bear/c_arms/teddy_bear.mdl"
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(5295, 2289, 23))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP1048B)
	self:SetModel("models/player/teddy_bear/teddy_bear.mdl")
	self:SetHealth(1900)
	self:SetMaxHealth(1900)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(0)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_1048B")
	self:SelectWeapon("weapon_scp_1048B")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP8602()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_8602)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP8602)
	self:SetModel("models/scp/scp_860_v3.mdl")
	self:SetHealth(2400)
	self:SetMaxHealth(2400)
	self:SetArmor(0)
	self:SetWalkSpeed(190)
	self:SetRunSpeed(190)
	self:SetMaxSpeed(190)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_8602")
	self:SelectWeapon("weapon_scp_8602")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP076()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(Vector(5434.7749023438, 1145.0329589844, -480.61874389648))
	--SetupSCP0761( self )
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP076)
	self:SetModel("models/abel/abel.mdl")
	self:SetHealth(1500)
	self:SetMaxHealth(1500)
	self:SetArmor(0)
	self:SetWalkSpeed(250)
	self:SetRunSpeed(250)
	self:SetMaxSpeed(250)
	self:SetJumpPower(210)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("scp_076")
	self:SelectWeapon("scp_076")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function SetupSCP0761( ply )
	if !IsValid( SCP0761 ) then
		cspawn076 = table.Random( SPAWN_076 )
		SCP0761 = ents.Create( "item_scp_0761" )
		SCP0761:Spawn()
		SCP0761:SetPos( cspawn076 )
	end
	ply:SetPos( cspawn076 )
end

function mply:DropWep(class, clip)
	local wep = ents.Create( class )
	if IsValid( wep ) then
		wep:SetPos( self:GetPos() )
		wep:Spawn()
		if isnumber(clip) then
			wep:SetClip1(clip)
		end
	end
end

infected_models = {
"models/scp_zombie/guard_new_1.mdl",
"models/scp_zombie/hazmat_zombie_1.mdl",
"models/scp_zombie/sci_new_1.mdl",
"models/scp_zombie/med_new_1.mdl",
"models/scp_zombie/female/s_female_01.mdl",
"models/scp_zombie/female/m_female_01.mdl",
}

function mply:SetSCP0082( hp, speed, spawn )
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	if spawn then
		self:Spawn()
	end
	self:SetGTeam(TEAM_SCP)
	self:SetModel(infected_models[ math.random(1, #infected_models) ])
	self:SetHealth(hp)
	self:SetMaxHealth(hp)
	self:SetArmor(0)
	self:SetWalkSpeed(speed)
	self:SetRunSpeed(speed)
	self:SetMaxSpeed(speed)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLES.ROLE_SCP0082)
	self.Active = true
	print("adding " .. self:Nick() .. " to zombies")
	self:SetupHands()
	if !spawn then
		WinCheck()
	end
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	net.Start("RolesSelected")
	net.Send(self)
	if #self:GetWeapons() > 0 then
		local pos = self:GetPos()
		for k,v in pairs(self:GetWeapons()) do
			local wep = ents.Create( v:GetClass() )
			if IsValid( wep ) then
				wep:SetPos( pos )
				wep:Spawn()
				wep:SetClip1(v:Clip1())
			end
			self:StripWeapon(v:GetClass())
		end
	end
	self.JustSpawned = true
	self:Give("weapon_br_zombie_infect")
	self:Give("hacking_doors_scp")
	self:SelectWeapon("weapon_br_zombie_infect")
	self.JustSpawned = false
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetupHands()
end

function mply:SetInfected( hp, speed, spawn )
	self:StripWeapons()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	if spawn then
		self:Spawn()
	end
	self:SetGTeam(TEAM_SCP)
	self:SetModel(GetZombieModel(self))
	self:SetHealth(hp)
	self:SetMaxHealth(hp)
	self:SetArmor(0)
	self:SetWalkSpeed(speed)
	self:SetRunSpeed(speed)
	self:SetMaxSpeed(speed)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLES.ROLE_SCP0082)
	self.Active = true
	print("adding " .. self:Nick() .. " to zombies")
	self:SetupHands()
	if !spawn then
		WinCheck()
	end
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	net.Start("RolesSelected")
	net.Send(self)
	if #self:GetWeapons() > 0 then
		local pos = self:GetPos()
		for k,v in pairs(self:GetWeapons()) do
			local wep = ents.Create( v:GetClass() )
			if IsValid( wep ) then
				wep:SetPos( pos )
				wep:Spawn()
				wep:SetClip1(v:Clip1())
			end
			self:StripWeapon(v:GetClass())
		end
	end
	self.JustSpawned = true
	self:Give("weapon_br_zombie_infect")
	self:Give("hacking_doors_scp")
	self:SelectWeapon("weapon_br_zombie_infect")
	self.JustSpawned = false
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetupHands()
end

function mply:SetSCP0492()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:StripWeapons()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:SetModel(GetZombieModel(self))
	self:SetGTeam(TEAM_SCP)
	local hzom = math.Clamp(1000 - (#player.GetAll() * 14), 300, 800)
	self:SetHealth(hzom)
	self:SetMaxHealth(hzom)
	self:SetArmor(0)
	self:SetWalkSpeed(160)
	self:SetRunSpeed(160)
	self:SetMaxSpeed(160)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLES.ROLE_SCP0492)
	self.Active = true
	print("[RXSEND] Adding " .. self:Nick() .. " to zombies")
	self:SetupHands()
	WinCheck()
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	net.Start("RolesSelected")
	net.Send(self)
	--[[
	if #self:GetWeapons() > 0 then
		local pos = self:GetPos()
		for k,v in pairs(self:GetWeapons()) do
			local wep = ents.Create( v:GetClass() )
			if IsValid( wep ) then
				wep:SetPos( pos )
				wep:Spawn()
				wep:SetClip1(v:Clip1())
			end
			self:StripWeapon(v:GetClass())
		end
	end
	--]]
	self.JustSpawned = true
	self:Give("weapon_br_zombie")
	self:Give("hacking_doors_scp")
	self:SelectWeapon("weapon_br_zombie")
	self.JustSpawned = false
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetupHands()
end

function mply:SetInfectD()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_GUARD)
	self:SetNClass(ROLES.ROLE_INFECTD)
	self:SetModel( CLASSDMODELS[math.random(1, #CLASSDMODELS)] )
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetArmor(0)
	self:SetWalkSpeed(130)
	self:SetRunSpeed(250)
	self:SetMaxSpeed(250)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetupHands()
	self.canblink = true
	self.noragdoll = false
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_CLASSD
	self:SetNoTarget( false )
	self.JustSpawned = true
	self:Give("v92_eq_unarmed")
	--self:Give("br_keycard_3")
	self:SelectWeapon("v92_eq_unarmed")
	self.JustSpawned = false
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetInfectMTF()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_GUARD)
	self:SetNClass(ROLES.ROLE_INFECTMTF)
	self:SetModel("models/scp/mog_zombie_round_new.mdl")
	self:SetHealth(150)
	self:SetMaxHealth(150)
	self:SetArmor(0)
	self:SetWalkSpeed(140)
	self:SetRunSpeed(260)
	self:SetMaxSpeed(260)
	self:SetJumpPower(215)
	self:SetNoDraw(false)
	self:SetupHands()
	self.canblink = true
	self.noragdoll = false
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_GUARD
	self:SetNoTarget( false )
	self.JustSpawned = true
	self:Give("v92_eq_unarmed")
	self:Give("weapon_pass_guard")
	self:Give("br_keycard_5")
	self:Give("cw_kk_ins2_ump45")
	self:GiveAmmo( 180, "SMG1" )
	self:SelectWeapon("v92_eq_unarmed")
	self.JustSpawned = false
	self.BaseStats = nil
	self.UsingArmor = nil
	self:ApplyArmor("armor_mtfcom")
	if ( self:GetWeapons() != nil ) then
		for k, v in pairs( self:GetWeapons() ) do
			if ( v:GetClass() == "cw_deagle" ) then v.Damage_Orig = WEP_DMG.deagle v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_fiveseven" ) then v.Damage_Orig = WEP_DMG.fiveseven v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_ak74 " ) then v.Damage_Orig = WEP_DMG.ak74 v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_ar15" ) then v.Damage_Orig = WEP_DMG.ar15 v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_g36c" ) then v.Damage_Orig = WEP_DMG.g36c v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_ump45" ) then v.Damage_Orig = WEP_DMG.ump45 v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_mp5" ) then v.Damage_Orig = WEP_DMG.mp5 v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_m14" ) then v.Damage_Orig = WEP_DMG.m14 v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_scarh" ) then v.Damage_Orig = WEP_DMG.scarh v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_l115" ) then v.Damage_Orig = WEP_DMG.l115 v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_shorty" ) then v.Damage_Orig = WEP_DMG.shorty v.DamageMult = 1 v:recalculateDamage() end
			if ( v:GetClass() == "cw_m3super90" ) then v.Damage_Orig = WEP_DMG.super90 v.DamageMult = 1 v:recalculateDamage() end	
		end
	end
end

function mply:SetChaosSpy()
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:Flashlight( false )
	self.handsmodel = nil
	self:SetNClass(ROLES.ROLE_CHAOSSPY)
	self:SetGTeam(TEAM_CHAOS)
	self.JustSpawned = true
	self:Give("v92_eq_unarmed")
	self:Give("weapon_pass_guard")
	self:Give("wep_jack_job_drpradio")
	self:Give("cw_kk_ins2_cstm_mp7")
	self:Give("weapon_flashlight")
	self:Give("item_nvg")
	self:Give("br_keycard_5")
	self:Give("cw_kk_ins2_nade_c4")
	self.JustSpawned = false
	self:SetModel("models/scp/mog_regular_new.mdl")
	self:SetHealth(120)
	self:SetMaxHealth(120)
	self:SetArmor(30)
	self:SetWalkSpeed(100 * 1)
	self:SetRunSpeed(210 * 1.2)
	self:SetMaxSpeed(210 * 1.2)
	self:SetJumpPower(190 * 0.87)
	self:SetNoDraw(false)
	self:SetupHands()
	self.canblink = true
	self.noragdoll = false
	self:AllowFlashlight( true )
	self:SetNoTarget( false )
	self:GiveAmmo( 400, "SMG1" )
	self:SelectWeapon("v92_eq_unarmed")
	self.JustSpawned = false
	self.BaseStats = nil
	self.UsingArmor = nil
	self:ApplyArmor("armor_mtfguard")
end

function mply:SetChaosSpecial()
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:Flashlight( false )
	self.handsmodel = nil
	self:SetNClass(ROLES.ROLE_CHAOSSPY)
	self:SetGTeam(TEAM_CHAOS)
	self.JustSpawned = true
	self:Give("v92_eq_unarmed")
	self:Give("weapon_pass_guard")
	self:Give("wep_jack_job_drpradio")
	self:Give("cw_kk_ins2_cstm_g36c")
	self:Give("item_cameraview")
	self:Give("weapon_flashlight")
	self:Give("item_nvg")
	self:Give("br_keycard_5")
	self.JustSpawned = false
	self:SetModel("models/scp/mog_special_new.mdl")
	self:SetHealth(170)
	self:SetMaxHealth(170)
	self:SetArmor(50)
	self:SetWalkSpeed(100 * 1)
	self:SetRunSpeed(210 * 1.1)
	self:SetMaxSpeed(210 * 1.1)
	self:SetJumpPower(190 * 0.92)
	self:SetNoDraw(false)
	self:SetupHands()
	self.canblink = true
	self.noragdoll = false
	self:AllowFlashlight( true )
	self:SetNoTarget( false )
	self:GiveAmmo( 400, "AR2" )
	self:SelectWeapon("v92_eq_unarmed")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:ApplyArmor("armor_hazmat")
end

function mply:SetUSSR()
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:Flashlight( false )
	self.handsmodel = nil
	self:SetNClass(ROLES.ROLE_USSR)
	self:SetGTeam(TEAM_USSR)
	self.JustSpawned = true
	self:Give("v92_eq_unarmed")
	self:Give("wep_jack_job_drpradio")
	self:Give("cw_kk_ins2_mosin")
	self.JustSpawned = false
	self:SetModel("models/player/dod_american.mdl")
	self:SetHealth(120)
	self:SetMaxHealth(120)
	self:SetArmor(50)
	self:SetWalkSpeed(100 * 1)
	self:SetRunSpeed(210 * 1.1)
	self:SetMaxSpeed(210 * 1.1)
	self:SetJumpPower(190 * 0.92)
	self:SetNoDraw(false)
	self:SetupHands()
	self.canblink = true
	self.noragdoll = false
	self:AllowFlashlight( true )
	self:SetNoTarget( false )
	self:GiveAmmo( 400, "AR2" )
	self:SelectWeapon("v92_eq_unarmed")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetNazi()
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:Flashlight( false )
	self.handsmodel = nil
	self:SetNClass(ROLES.ROLE_NAZI)
	self:SetGTeam(TEAM_NAZI)
	self.JustSpawned = true
	self:Give("v92_eq_unarmed")
	self:Give("wep_jack_job_drpradio")
	self:Give("cw_kk_ins2_kar62de")
	self.JustSpawned = false
	self:SetModel("models/player/dod_german.mdl")
	self:SetHealth(120)
	self:SetMaxHealth(120)
	self:SetArmor(50)
	self:SetWalkSpeed(100 * 1)
	self:SetRunSpeed(210 * 1.1)
	self:SetMaxSpeed(210 * 1.1)
	self:SetJumpPower(190 * 0.92)
	self:SetNoDraw(false)
	self:SetupHands()
	self.canblink = true
	self.noragdoll = false
	self:AllowFlashlight( true )
	self:SetNoTarget( false )
	self:GiveAmmo( 400, "AR2" )
	self:SelectWeapon("v92_eq_unarmed")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetupNormal()
	self.BaseStats = nil
	self.UsingArmor = nil
	self.handsmodel = nil
	self:UnSpectate()
	self:Spawn()
	self:GodDisable()
	self:SetNoDraw(false)
	self:SetNoTarget(false)
	self:SetupHands()
	self:RemoveAllAmmo()
	self:StripWeapons()
	self.canblink = true
	self.noragdoll = false
end

function mply:SetupAdmin()
	self:Flashlight( false )
	self:AllowFlashlight( true )
	self.handsmodel = nil
	self:UnSpectate()
	//self:Spectate(6)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SPEC)
	self:SetNoDraw(true)
	if self.SetNClass then
		self:SetNClass(ROLES.ADMIN)
	end
	self.canblink = false
	self:SetNoTarget( false )
	self.BaseStats = nil
	self.UsingArmor = nil
	self:GodEnable()
	self:SetupHands()
	self:SetWalkSpeed(400)
	self:SetRunSpeed(400)
	self:SetMaxSpeed(300)
	self:ConCommand( "noclip" )
	self:Give( "br_holster" )
	self:Give( "br_entity_remover" )
	self:Give( "weapon_physgun" )
end

function mply:ApplyRoleStats(role)
	self:SetLastHitGroup(0)
	self.BeforeRole = self:GetNClass()
	self.MatildaHealUsed = false
	self.SpedwaunUsed = false
	self.LomaoUsed = false
	self.KelenUsed = false
	self.FeelonUsed = false
	self.FeelonMaxMines = 3
	--print(debug.traceback())
	self:SetColor(Color(255, 255, 255, 255))
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:DrawShadow(true)
	self:SendLua('system.FlashWindow()')
	self:SetNClass(role.name)
	self:SetGTeam(role.team)
	self:SetNWString("role", role.name)
	self:StripWeapons()
	self:SendLua('RunConsoleCommand("stopsound")')
	
	self:SendLua('IsDied = false')
	self:SetNWEntity("RagdollEntityNO", NULL)
	
	for k, v in pairs(role.weapons) do
		timer.Simple(0.001, function()
			self.JustSpawned = true
			if v != "v92_eq_unarmed" then
				self:Give(v)
				--v:SetPos(self)
			elseif v == "v92_eq_unarmed" then
				if self:SteamID() == "STEAM_0:0:18725400" or self:SteamID() == "STEAM_0:0:454531613" or self:SteamID() == "STEAM_0:1:233420776" then
					self:Give("big_black_hands")
				else
					self:Give("v92_eq_unarmed")
				end
			end
			self.JustSpawned = false
			self.IsLooting = false
		end)
	end
	
	self.DiedFromPistolBullets = false
	self.DiedFromSMG1Bullets = false
	self.DiedFromAR2Bullets = false
	self.DiedFromHeadshot = false
	self.DiedFromSlash = false
	self.DeathReasonUnknown = false

	for k, v in pairs( role.ammo ) do
		--for _, wep in pairs( self:GetWeapons() ) do
			--if v[1] == wep:GetClass() then
				self:GiveAmmo(v[2], v[1], false)
			--end
		--end
	end
	self:SetHealth(role.health)
	self:SetMaxHealth(role.health)
	self:SetArmor(role.armor)
	if role.armor > 0 then
		self.UsingHL2Armor = true
	else
		self.UsingHL2Armor = false
	end
	self:SetWalkSpeed(100 * role.walkspeed)
	self:SetRunSpeed(210 * role.runspeed)
	self:SetJumpPower(190 * role.jumppower)
	player_role_model = role.models[math.random(1, #role.models)]
	self:SetModel(player_role_model)
	self.BeforeVestModel = player_role_model
	self:Flashlight( false )
	self:AllowFlashlight( role.flashlight )
	if role.vest != nil then
		self:ApplyArmor(role.vest)
	end
	if role.pmcolor != nil then
		self:SetPlayerColor(Vector(role.pmcolor.r / 255, role.pmcolor.g / 255, role.pmcolor.b / 255))
	end
	net.Start("RolesSelected")
	net.Send(self)
	self:SetupHands()
end

function mply:SetSecurityI1()
	local thebestone = nil
	local usechaos = false
	if math.random(1,6) == 6 then usechaos = true end
	for k,v in pairs(ALLCLASSES["security"]["roles"]) do
		if v.importancelevel == 1 then
			local skip = false
			if usechaos == true then
				if v.team == TEAM_GUARD then
					skip = true
				end
			else
				if v.team == TEAM_CHAOS then
					skip = true
				end
			end
			if skip == false then
				local can = true
				if v.customcheck != nil then
					if v.customcheck(self) == false then
						can = false
					end
				end
				local using = 0
				for _,pl in pairs(player.GetAll()) do
					if pl:GetNClass() == v.name then
						using = using + 1
					end
				end
				if using >= v.max then can = false end
				if can == true then
					if self:GetLevel() >= v.level then
						if thebestone != nil then
							if thebestone.sorting < v.sorting then
								thebestone = v
							end
						else
							thebestone = v
						end
					end
				end
			end
		end
	end
	if thebestone == nil then
		thebestone = ALLCLASSES["security"]["roles"][1]
	end
	self:SetupNormal()
	self:ApplyRoleStats(thebestone)
end

function mply:SetClassD()
--print(debug.traceback())
	self:SetRoleBestFrom("classds")
end

function mply:SetResearcher()
	self:SetRoleBestFrom("researchers")
end

function mply:SetSpecial()
	self:SetRoleBestFrom("special")
end

function mply:SetRoleBestFrom(role)
	local suitable_roles_table = {}

	for k,v in pairs(ALLCLASSES_2[role]["roles"]) do 
		if self:GetLevel() >= v.level then
			if v.max > 0 then
				table.insert(suitable_roles_table, v)
			end
		end
	end

	local random_role = suitable_roles_table[math.random(1, #suitable_roles_table)]

	for k,v in pairs(ALLCLASSES_2[role]["roles"]) do
		if v == random_role then
			v.max = v.max - 1
		end
	end

	if random_role == nil and role != "special" then
		random_role = ALLCLASSES_2[role]["roles"][1]

	elseif random_role == nil and role == "special" then
		suitable_roles_table_new = {}

		for k,v in pairs(ALLCLASSES_2["researchers"]["roles"]) do 
			if self:GetLevel() >= v.level then
				if v.max > 0 then
					table.insert(suitable_roles_table, v)
				end
			end
		end

		--random_role = suitable_roles_table_new[math.random(1, #suitable_roles_table_new)]
		random_role = ALLCLASSES_2["researchers"]["roles"][1]
	end


	self:SetupNormal()
	self:ApplyRoleStats(random_role)
end

--[[
function mply:SetRoleBestFrom(role)
	local thebestone = nil
	for k,v in pairs(ALLCLASSES[role]["roles"]) do
		local can = true
		if v.customcheck != nil then
			if v.customcheck(self) == false then
				can = false
			end
		end
		local using = 0
		for _,pl in pairs(player.GetAll()) do
			if pl:GetNClass() == v.name then
				using = using + 1
			end
		end
		if using >= v.max then can = false end
		if can == true then
			if self:GetLevel() >= v.level then
				if thebestone != nil then
					if thebestone.level < v.level then
						thebestone = v
					end
				else
					thebestone = v
				end
			end
		end
	end
	if thebestone == nil then
		thebestone = ALLCLASSES[role]["roles"][1]
	end
	if thebestone == ALLCLASSES["classds"]["roles"][4] and #player.GetAll() < 4 then
		thebestone = ALLCLASSES["classds"]["roles"][3]
	end
	if ( GetConVar("br_dclass_keycards"):GetInt() != 0 ) then
		if thebestone == ALLCLASSES["classds"]["roles"][1] then thebestone = ALLCLASSES["classds"]["roles"][2] end
	else
		if thebestone == ALLCLASSES["classds"]["roles"][2] then thebestone = ALLCLASSES["classds"]["roles"][1] end
	end
	self:SetupNormal()
	self:ApplyRoleStats(thebestone)
end
--]]

function mply:IsActivePlayer()
	return self.Active
end

hook.Add( "KeyPress", "keypress_spectating", function( ply, key )
	if ply:GTeam() != TEAM_SPEC or ply:GetNClass() == ROLES.ADMIN then return end
	if ( key == IN_ATTACK ) then
		ply:SpectatePlayerLeft()
	elseif ( key == IN_ATTACK2 ) then
		ply:SpectatePlayerRight()
	elseif ( key == IN_RELOAD ) then
		ply:ChangeSpecMode()
	end
end )

function mply:SpectatePlayerRight()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly - 1
	if self.SpecPly < 1 then
		self.SpecPly = #allply 
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
			--self:SetHands(v:GetHands())
		end
	end
end

function mply:SpectatePlayerLeft()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly + 1
	if self.SpecPly > #allply then
		self.SpecPly = 1
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
			--self:SetHands(v:GetHands())
		end
	end
end

function mply:ChangeSpecMode()
	if !self:Alive() then return end
	if !(self:GTeam() == TEAM_SPEC) then return end
	self:SetNoDraw(true)
	local m = self:GetObserverMode()
	local allply = #GetAlivePlayers()
	if allply < 2 then
		self:Spectate(OBS_MODE_ROAMING)
		return
	end
	/*
	if m == OBS_MODE_CHASE then
		self:Spectate(OBS_MODE_IN_EYE)
	else
		self:Spectate(OBS_MODE_CHASE)
	end
	*/
	
	if m == OBS_MODE_IN_EYE then
		self:Spectate(OBS_MODE_CHASE)	
	elseif m == OBS_MODE_CHASE then
		if GetConVar( "br_allow_roaming_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_ROAMING)
		elseif GetConVar( "br_allow_ineye_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_IN_EYE)
			self:SpectatePlayerLeft()
		else
			self:SpectatePlayerLeft()
		end	
	elseif m == OBS_MODE_ROAMING then
		if GetConVar( "br_allow_ineye_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_IN_EYE)
			self:SpectatePlayerLeft()
		else
			self:Spectate(OBS_MODE_CHASE)
			self:SpectatePlayerLeft()
		end
	else
		self:Spectate(OBS_MODE_ROAMING)
	end
end

function mply:SaveExp()
	self:SetPData( "breach_exp", self:GetExp() )
end

function mply:SaveLevel()
	self:SetPData( "breach_level", self:GetLevel() )
end

util.AddNetworkString("xpAwardnextoren")
util.AddNetworkString("lvlAwardnextoren")
util.AddNetworkString("lvldescnextoren")
function mply:AddExp(amount, msg)
	amount = amount * GetConVar("br_expscale"):GetInt()
	if self:IsUserGroup("premium") then
		amount = amount * 2
		self:RXSENDNotify("Полученный опыт удвоен")
	end
	amount = math.Round(amount)
	if not self.GetNEXP then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNEXP and self.SetNEXP then
		self:SetNEXP( self:GetNEXP() + amount )
		if msg != nil then
			self:RXSENDNotify("Опыта получено: " .. amount .. ", ваш опыт сейчас: " .. self:GetNEXP())
			net.Start("xpAwardnextoren")
				net.WriteFloat(amount)
			net.Send(self)
		else
			self:RXSENDNotify("Опыта получено: " .. amount .. ", ваш опыт сейчас: " .. self:GetNEXP())
			net.Start("xpAwardnextoren")
				net.WriteFloat(amount)
			net.Send(self)
		end
		local xp = self:GetNEXP()
		local lvl = self:GetNLevel()
		if lvl == 0 then
			if xp >= 750 then
				self:AddLevel(1)
				self:SetNEXP(0)
				self:SaveLevel()
				self:TipSendGood("Вы получили свой первый уровень! Ознакомьтесь с новыми ролями.")
				--[[
				net.Start("lvlAwardnextoren")
				net.Send(self)
				local new_roles = {}
				
				for k, v in ipairs(ALLCLASSES) do
					if ALLCLASSES[v]["roles"].level == self:GetLevel() then
						table.ForceInsert(new_roles, ALLCLASSES[v][name])
					end
				end

				if !table.IsEmpty(new_roles) then
					net.Start("lvldescnextoren")
						net.WriteString(table.ToString(new_roles))
					net.Send(self)
					table.remove(new_roles)
				end
				--]]
			end
		elseif lvl >= 1 then
			if xp >= lvl * 750 then
				self:AddLevel(1)
				self:SetNEXP(xp - lvl * 750)
				self:SaveLevel()
				self:TipSendGood("Вы получили новый уровень! Ознакомьтесь с новыми ролями.")
				--[[
				net.Start("lvlAwardnextoren")
				net.Send(self)
				local new_roles = {}

				for k, v in ipairs(ALLCLASSES) do
					for k, rl in ipairs(ALLCLASSES[v][roles]) do
						if rl.level == self:GetLevel() then
							table.ForceInsert(new_roles, rl.name)
							print(rl.name)
						end
					end
				end

				if !table.IsEmpty(new_roles) then
					net.Start("lvldescnextoren")
						PrintTable(new_roles)
						net.WriteString(table.ToString(new_roles))
					net.Send(self)
					table.remove(new_roles)
				end
				--]]

			end
		end
		self:SetPData( "breach_exp", self:GetExp() )
	else
		if self.SetNEXP then
			self:SetNEXP( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNEXP invalid" )
		end
	end
end

function mply:AddLevel(amount)
	if not self.GetNLevel then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNLevel and self.SetNLevel then
		self:SetNLevel( self:GetNLevel() + amount )
		self:SetPData( "breach_level", self:GetNLevel() )
	else
		if self.SetNLevel then
			self:SetNLevel( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNLevel invalid" )
		end
	end
end

function mply:SetRoleName(name)
	local rl = nil
	for k,v in pairs(ALLCLASSES) do
		for _,role in pairs(v.roles) do
			if role.name == name then
				rl = role
			end
		end
	end
	if rl != nil then
		self:ApplyRoleStats(rl)
	end
end

function mply:SetActive( active )
	self.ActivePlayer = active
	self:SetNActive( active )
	if !gamestarted then
		CheckStart()
	end
end

function mply:ToggleAdminModePref()
	if self.admpref == nil then self.admpref = false end
	if self.admpref then
		self.admpref = false
		if self.AdminMode then
			self:ToggleAdminMode()
			self:SetSpectator()
		end
	else
		self.admpref = true
		if self:GetNClass() == ROLES.ROLE_SPEC then
			self:ToggleAdminMode()
			self:SetupAdmin()
		end
	end
end

function mply:ToggleAdminMode()
	if self.AdminMode == nil then self.AdminMode = false end
	if self.AdminMode == true then
		self.AdminMode = false
		self:SetActive( true )
		self:DrawWorldModel( true ) 
	else
		self.AdminMode = true
		self:SetActive( false )
		self:DrawWorldModel( false ) 
	end
end