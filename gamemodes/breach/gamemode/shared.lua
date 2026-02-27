--[[
gamemodes/breach/gamemode/shared.lua
--]]
// Shared file
GM.Name 	= "Breach"
GM.Author 	= "Kanade, edited by danx91"
GM.Email 	= ""
GM.Website 	= ""

VERSION = "0.26"
DATE = "28/01/2018"

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

hook.Add("CalcMainActivity", "run_crouch_anims", function(Player, Velocity)
if Player:GTeam() == TEAM_SCP or Player:GTeam() == TEAM_SPEC then return end
	if Player:IsOnGround() and Velocity:Length() > Player:GetRunSpeed() - 10 and (( IsValid(Player:GetActiveWeapon()) and Player:GetActiveWeapon():GetHoldType() == "normal" ) or Player:GetActiveWeapon() == NULL) then
		return ACT_HL2MP_RUN_FAST, -1
	end
	if Player:IsOnGround() and (( IsValid(Player:GetActiveWeapon()) and Player:GetActiveWeapon():GetHoldType() == "normal" ) or Player:GetActiveWeapon() == NULL) and Player:Crouching() and Velocity:Length2DSqr() < 1 
			and Player:GetSequence() ~= Player:LookupSequence("pose_ducking_02") and Player:GetSequence() ~= Player:LookupSequence("run_all_01") 
			and Player:GetSequence() ~= Player:LookupSequence("idle_all_01") and Player:GetSequence() ~= Player:LookupSequence("walk_all") 
			and Player:GetSequence() ~= Player:LookupSequence("cwalk_all") then
		local crouch_anim = Player:LookupSequence("pose_ducking_01")
		return ACT_MP_JUMP, crouch_anim
	else
		return
	end

end)

TEAM_SCP = 1
TEAM_GUARD = 2
TEAM_CLASSD = 3
TEAM_SPEC = 4
TEAM_SCI = 5
TEAM_CHAOS = 6
TEAM_GOC = 7
TEAM_DZ = 8
TEAM_NTF = 9
TEAM_SPECIAL = 10
TEAM_USA = 11
TEAM_USSR = 12
TEAM_NAZI = 13

MINPLAYERS = 10

ACCESS_SAFE = bit.lshift( 1, 0 )
ACCESS_EUCLID = bit.lshift( 1, 1 )
ACCESS_KETER = bit.lshift( 1, 2 )
ACCESS_CHECKPOINT = bit.lshift( 1, 3 )
ACCESS_OMEGA = bit.lshift( 1, 4 )
ACCESS_GENERAL = bit.lshift( 1, 5 )
ACCESS_GATEA = bit.lshift( 1, 6 )
ACCESS_GATEB = bit.lshift( 1, 7 )
ACCESS_ARMORY = bit.lshift( 1, 8 )
ACCESS_FEMUR = bit.lshift( 1, 9 )
ACCESS_EC = bit.lshift( 1, 10 )

// Team setup
team.SetUp( 1, "rxsend_cheaters_hello", Color(255, 255, 0) )
/* Replaced with GTeams
team.SetUp( TEAM_SCP, "SCPs", Color(237, 28, 63) )
team.SetUp( TEAM_GUARD, "MTF Guards", Color(0, 100, 255) )
team.SetUp( TEAM_CLASSD, "Class Ds", Color(255, 130, 0) )
team.SetUp( TEAM_SPEC, "Spectators", Color(141, 186, 160) )
team.SetUp( TEAM_SCI, "Scientists", Color(66, 188, 244) )
team.SetUp( TEAM_CHAOS, "Chaos Insurgency", Color(0, 100, 255) )
team.SetUp( TEAM_GOC, "Global Occult C" Color(184, 134, 11) )
team.SetUp( TEAM_DZ, "Dlan Zmei" Color(184, 134, 11) )
team.SetUp( TEAM_NTF, "Nine Tailed Foxes" Color(0, 0, 255)	)
team.SetUp( TEAM_ORT, "Quick Response Team" Color(127, 255, 212)	)
team.SetUp( TEAM_USA, "USA" Color(184, 134, 11) )
*/
game.AddParticles("particles/vfire_base_big.pcf")
game.AddParticles("particles/vfire_base_big_lod.pcf")
game.AddParticles("particles/vfire_flames_big.pcf")
game.AddParticles("particles/vfire_flames_big_lod.pcf")
game.AddDecal( "Decal106", "decals/decal106" )
surface = surface or  {}

function surface.DrawRing( x, y, radius, thick, angle, segments, fill, rotation )
	angle = math.Clamp( angle or 360, 1, 360 )
	fill = math.Clamp( fill or 1, 0, 1 )
	rotation = rotation or 0

	local segmentstodraw = {}
	local segang = angle / segments
	local bigradius = radius + thick

	for i = 1, math.Round( segments * fill ) do
		local ang1 = math.rad( rotation + ( i - 1 ) * segang )
		local ang2 = math.rad( rotation + i * segang )

		local sin1 = math.sin( ang1 )
		local cos1 = -math.cos( ang1 )

		local sin2 = math.sin( ang2 )
		local cos2 = -math.cos( ang2 )

		surface.DrawPoly( {
			{ x = x + sin1 * radius, y = y + cos1 * radius },
			{ x = x + sin1 * bigradius, y = y + cos1 * bigradius },
			{ x = x + sin2 * bigradius, y = y + cos2 * bigradius },
			{ x = x + sin2 * radius, y = y + cos2 * radius }
		} )

	end
end

function AddTables( tab1, tab2 )
	for k, v in pairs( tab2 ) do
		if tab1[k] and istable( v ) then
			AddTables( tab1[k], v )
		else
			tab1[k] = v
		end
	end
end
function GM:PlayerSpawnEffect(ply, model)
  return false
end
function GM:PlayerConnect( name, ip )
	return false
end
function GetLangRole(rl)
	if clang == nil then return rl end
	local rolef = nil
	for k,v in pairs(ROLES) do
		if rl == v then
			rolef = k
		end
	end
	if rolef != nil then
		return clang.ROLES[rolef]
	else
		return rl
	end
end

function util.PaintDown(start, effname, ignore) --From TTT
  local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})

  util.Decal(effname, btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal)
end
local function DoBleed(ent)
  if not IsValid(ent) or (ent:IsPlayer() and (not ent:Alive() or ent:GTeam() == TEAM_SCP or ent:GTeam() == TEAM_SPEC)) then
    return
  end

  local jitter = VectorRand() * 30
  jitter.z = 20

  util.PaintDown(ent:GetPos() + jitter, "Blood", ent)
end

function util.StartBleeding(ent, dmg, t)
	--print(dmg)
  if dmg < 5 or not IsValid(ent) then
    return
  end

  if ent:IsPlayer() and (not ent:Alive() or ent:GTeam() == TEAM_SCP or ent:GTeam() == TEAM_SPEC) then
    return
  end

  local times = math.Clamp(math.Round(dmg / 15), 1, 20)

 local delay = math.Clamp(t / times , 0.1, 2)

  if ent:IsPlayer() then
    times = times * 2
    delay = delay / 2
  end

 timer.Create("bleed" .. ent:EntIndex(), delay, times, function() DoBleed(ent) end)
end

SPCS = {
	--[[
	{name = "SCP 173",
	func = function(pl)
		pl:SetSCP173()
	end},
	--]]
	{name = "SCP 049",
	func = function(pl)
		pl:SetSCP049()
	end},

	{name = "SCP 106",
	func = function(pl)
		pl:SetSCP106()
	end},
	
	{name = "SCP 457",
	func = function(pl)
		pl:SetSCP457()
	end},
	
	--[[
	{name = "SCP 035",
	func = function(pl)
		pl:SetSCP035()
	end},
	--]]
	{name = "SCP 076",
	func = function(pl)
		pl:SetSCP076()
	end},

	{name = "SCP 682",
	func = function(pl)
		pl:SetSCP682()
	end},
	--[[
	{name = "SCP 1027-RU",
	func = function(pl)
		pl:SetSCP1027RU()
	end},
	--]]
	{name = "SCP 966",
	func = function(pl)
		pl:SetSCP966()
	end},
	
	
	{name = "SCP-082",
	func = function(pl)
		pl:SetSCP082()
	end},

	{name = "SCP 811",
	func = function(pl)
		pl:SetSCP811()
	end},

	{name = "SCP 1903",
	func = function(pl)
		pl:SetSCP1903()
	end},

	{name = "SCP 1048",
	func = function(pl)
		pl:SetSCP1048()
	end},

	{name = "SCP 939",
	func = function(pl)
		pl:SetSCP939()
	end},
	--[[
	{name = "SCP 079-2",
	func = function(pl)
		pl:SetSCP0792()
	end},
	--]]
	{name = "SCP 1471",
	func = function(pl)
	    pl:SetSCP1471()
	end},
	--крикло
	{name = "SCP 638",
	func = function(pl)
		pl:SetSCP638()
	end},
	{name = "SCP 860-2",
	func = function(pl)
		pl:SetSCP8602()
	end},

	{name = "SCP-542",
	func = function(pl)
		pl:SetSCP542()
	end},
	--фашик
	
	{name = "SCP 062DE",
	func = function(pl)
		pl:SetSCP062DE()
	end},
	

	{name = "SCP 062-FR",
	func = function(pl)
		pl:SetSCP062()
	end},

	{name = "SCP-050",
	func = function(pl)
		pl:SetSCP050FR()
	end},
	
	{name = "SCP 096",
	func = function(pl)
		pl:SetSCP096()
	end},
	
	{name = "SCP-999-2",
	func = function(pl)
		pl:SetSCP999()
	end}

}

ROLES = {}

ROLES.ADMIN = "ADMIN MODE"

// SCPS
ROLES.ROLE_SCP173 = "SCP-173"
ROLES.ROLE_SCP106 = "SCP-106"
ROLES.ROLE_SCP1048AB = "SCP-1048"
ROLES.ROLE_SCP966 = "SCP-966"
ROLES.ROLE_SCP050 = "SCP-050"
ROLES.ROLE_SCP023 = "SCP-023"
ROLES.ROLE_SCP638 = "SCP-638"
ROLES.ROLE_SCP096 = "SCP-096"
ROLES.ROLE_SCP542 = "SCP-542"

ROLES.ROLE_SCP076 = "SCP-076"
ROLES.ROLE_SCP8602 = "SCP-860-2"
ROLES.ROLE_SCP062DE = "SCP-062-DE"
ROLES.ROLE_SCP1471 = "SCP-1471"
ROLES.ROLE_SCP082 = "SCP-082"
ROLES.ROLE_SPEEED = "Lomao"
ROLES.ROLE_SCP9992 = "SCP-999-2"
ROLES.ROLE_SCP035 = "SCP-035"
ROLES.ROLE_SCP1903 = "SCP-1903"
ROLES.ROLE_SPECIALRES = "Matilda Moore"
ROLES.ROLE_SPECIALRESS = "Hedwig Kirchmaier"
ROLES.ROLE_SPECIALRESSSS = "Spedwaun"
ROLES.ROLE_SPECIALRESSS = "Kelen"
ROLES.ROLE_DZDD = "SH Spy"
ROLES.ROLE_SCP1027 = "SCP-1027"
ROLES.ROLE_CHAOSDESTROYER = "Chaos Destroyer"
ROLES.ROLE_LESSION = "Feelon"
ROLES.ROLE_SCP939 = "SCP-939"
ROLES.ROLE_SCP049 = "SCP-049"
ROLES.ROLE_SCP811 = "SCP-811"
ROLES.ROLE_GOCSPY = "GOC Spy"
ROLES.ROLE_SCP457 = "SCP-457"
ROLES.ROLE_SCP682 = "SCP-682"
ROLES.ROLE_SCP062 = "SCP-062"
ROLES.ROLE_SHIELD = "Shieldmeh"
ROLES.ROLE_SCP0492 = "SCP-049-2"
ROLES.ROLE_SCP1048 = "SCP-1048-A"
ROLES.ROLE_SCP0082 = "SCP-008-2"

// Researchers
ROLES.ROLE_RES = "Researcher"
ROLES.ROLE_RESS = "Tester"
ROLES.ROLE_GuardSci = "Science Guard"
ROLES.ROLE_LEL = "Head of Science Personnel"
ROLES.ROLE_MEDIC = "Medic"

// Quick Response Team
--ROLES.ROLE_FOCKYOU = "Quick Response Member"

// Class D Personell
ROLES.ROLE_CLASSD = "Class D Personnel"
ROLES.ROLE_LODSOFMONEY = "Class D Money"
ROLES.ROLE_Killer = "Class D Killer"
ROLES.ROLE_TOPKEK = "Class D Strong"
ROLES.ROLE_hacker = "Class D Hacker"
ROLES.ROLE_FAT = "Class D Fat"
ROLES.ROLE_Can = "Class D Cannibal"
ROLES.ROLE_Sport = "Class D Sportsman"
ROLES.ROLE_VOR = "Class D Thief"
ROLES.ROLE_GAY = "Class D Secondhand"
ROLES.ROLE_VETERAN = "Veteran"

// Security
ROLES.ROLE_SECURITY = "Security Officer"
ROLES.ROLE_MTFGeneral = "Head of Foundation"
ROLES.ROLE_BIO = "MTF Chemist"

ROLES.ROLE_MTFJAG = "MTF Juggernaut"
ROLES.ROLE_MTFGUARD = "MTF Guard"
ROLES.ROLE_MTFMEDIC = "MTF Medic"
ROLES.ROLE_Engi = "MTF Engineer"
ROLES.ROLE_MTFL = "MTF Lieutenant"
ROLES.ROLE_HAZMAT = "MTF Special"
ROLES.ROLE_MTFNTF = "MTF Nine Tailed Fox"
ROLES.ROLE_MTFNTF_SNIPER = "MTF Nine Tailed Fox Sniper"
ROLES.ROLE_CSECURITY = "Security Chief"
ROLES.ROLE_MTFCOM = "MTF Commander"
ROLES.ROLE_MTFSHOCK= "MTF Shocktroop"
ROLES.ROLE_SD = "Site Director"

// Chaos Insurgency
ROLES.ROLE_CHAOSSPY = "Chaos Insurgency Spy"
ROLES.ROLE_CHAOS = "Chaos Insurgency"
ROLES.ROLE_CHAOSCOM = "CI Commander"

// Global Occult C
ROLES.ROLE_GoP = "Global Occult Coalition"
// ONP
ROLES.ROLE_USA = "Unusual Incidents Unit"
// DZ
ROLES.ROLE_DZ = "Serpent's Hand"
// Other
ROLES.ROLE_SPEC = "Spectator"

ROLES.ROLE_USSR = "Red Army soldier"
ROLES.ROLE_NAZI = "Nazi soldier"

include( "sh_playersetups.lua" )

if !ConVarExists("br_roundrestart") then CreateConVar( "br_roundrestart", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Restart the round" ) end
if !ConVarExists("br_time_preparing") then CreateConVar( "br_time_preparing", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set preparing time" ) end
if !ConVarExists("br_time_round") then CreateConVar( "br_time_round", "1020", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set round time" ) end
if !ConVarExists("br_time_postround") then CreateConVar( "br_time_postround", "12", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set postround time" ) end
if !ConVarExists("br_time_ntfenter") then CreateConVar( "br_time_ntfenter", "240", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time that NTF units will enter the facility" ) end
if !ConVarExists("br_time_blink") then CreateConVar( "br_time_blink", "0.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Blink timer" ) end
if !ConVarExists("br_time_blinkdelay") then CreateConVar( "br_time_blinkdelay", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Delay between blinks" ) end
if !ConVarExists("br_spawnzombies") then CreateConVar( "br_spawnzombies", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do you want zombies?" ) end
if !ConVarExists("br_karma") then CreateConVar( "br_karma", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do you want to enable karma system?" ) end
if !ConVarExists("br_karma_max") then CreateConVar( "br_karma_max", "1200", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Max karma" ) end
if !ConVarExists("br_karma_starting") then CreateConVar( "br_karma_starting", "1000", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Starting karma" ) end
if !ConVarExists("br_karma_save") then CreateConVar( "br_karma_save", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do you want to save the karma?" ) end
if !ConVarExists("br_karma_round") then CreateConVar( "br_karma_round", "120", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How much karma to add after a round" ) end
if !ConVarExists("br_karma_reduce") then CreateConVar( "br_karma_reduce", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How much karma to reduce after damaging someone" ) end
if !ConVarExists("br_scoreboardranks") then CreateConVar( "br_scoreboardranks", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_defaultlanguage") then CreateConVar( "br_defaultlanguage", "english", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_expscale") then CreateConVar( "br_expscale", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scp_cars") then CreateConVar( "br_scp_cars", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow SCPs to drive cars?" ) end
if !ConVarExists("br_allow_vehicle") then CreateConVar( "br_allow_vehicle", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow vehicle spawn?" ) end
if !ConVarExists("br_dclass_keycards") then CreateConVar( "br_dclass_keycards", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is D class supposed to have keycards? (D Class Weterans have keycard anyway)" ) end
if !ConVarExists("br_time_explode") then CreateConVar( "br_time_explode", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time from call br_destroygatea to explode" ) end
if !ConVarExists("br_ci_percentage") then CreateConVar("br_ci_percentage", "25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_dz_percentage") then CreateConVar("br_dz_percentage", "25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_goc_percentage") then CreateConVar("br_goc_percentage", "25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_i4_min_mtf") then CreateConVar("br_i4_min_mtf", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_cars_oldmodels") then CreateConVar("br_cars_oldmodels", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Use old cars models?" ) end
if !ConVarExists("br_premium_url") then CreateConVar("br_premium_url", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Link to premium members list" ) end
if !ConVarExists("br_premium_mult") then CreateConVar("br_premium_mult", "1.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Premium members exp multiplier" ) end
if !ConVarExists("br_premium_display") then CreateConVar("br_premium_display", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Text shown to all players when premium member joins" ) end
if !ConVarExists("br_stamina_enable") then CreateConVar("br_stamina_enable", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is stamina allowed?" ) end
if !ConVarExists("br_stamina_scale") then CreateConVar("br_stamina_scale", "1, 1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Stamina regen and use. ('x, y') where x is how many stamina you will receive, and y how many stamina you will lose" ) end
if !ConVarExists("br_rounds") then CreateConVar("br_rounds", "15", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "How many round before map restart? 0 - dont restart" ) end
if !ConVarExists("br_min_players") then CreateConVar("br_min_players", "10", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum players to start round" ) end
if !ConVarExists("br_firstround_debug") then CreateConVar("br_firstround_debug", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_force_specialround") then CreateConVar("br_force_specialround", "none", {FCVAR_SERVER_CAN_EXECUTE}, "Available special rounds [ infect, multi ]" ) end
if !ConVarExists("br_specialround_pct") then CreateConVar("br_specialround_pct", "10", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_punishvote_time") then CreateConVar("br_punishvote_time", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How much time players have to vote" ) end
if !ConVarExists("br_allow_punish") then CreateConVar("br_allow_punish", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is punish system allowed?" ) end
if !ConVarExists("br_cars_ammount") then CreateConVar("br_cars_ammount", "12", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How many cars should spawn?" ) end
if !ConVarExists("br_dropvestondeath") then CreateConVar("br_dropvestondeath", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do players drop vests on death?" ) end
if !ConVarExists("br_force_showupdates") then CreateConVar("br_force_showupdates", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should players see update logs any time they join to server?" ) end
if !ConVarExists("br_allow_scptovoicechat") then CreateConVar("br_allow_scptovoicechat", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Can SCPs talk with humans?" ) end
if !ConVarExists("br_ulx_premiumgroup_name") then CreateConVar("br_ulx_premiumgroup_name", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Name of ULX premium group" ) end
if !ConVarExists("br_experimental_bulletdamage_system") then CreateConVar("br_experimental_bulletdamage_system", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problem with bullets" ) end
if !ConVarExists("br_experimental_antiknockback_force") then CreateConVar("br_experimental_antiknockback_force", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problem with bullets" ) end
if !ConVarExists("br_allow_ineye_spectate") then CreateConVar("br_allow_ineye_spectate", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_allow_roaming_spectate") then CreateConVar("br_allow_roaming_spectate", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scale_bullet_damage") then CreateConVar("br_scale_bullet_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Bullet damage scale" ) end
if !ConVarExists("br_new_eq") then CreateConVar("br_new_eq", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables new EQ" ) end

MINPLAYERS = GetConVar("br_min_players"):GetInt()

function KarmaReduce()
	return GetConVar("br_karma_reduce"):GetInt()
end

function KarmaRound()
	return GetConVar("br_karma_round"):GetInt()
end

function SaveKarma()
	return GetConVar("br_karma_save"):GetInt()
end

function MaxKarma()
	return GetConVar("br_karma_max"):GetInt()
end

function StartingKarma()
	return GetConVar("br_karma_starting"):GetInt()
end

function KarmaEnabled()
	return GetConVar("br_karma"):GetBool()
end

function GetPrepTime()
	return GetConVar("br_time_preparing"):GetInt()
end

function GetRoundTime()
	return GetConVar("br_time_round"):GetInt()
end

function GetPostTime()
	return GetConVar("br_time_postround"):GetInt()
end

function GetGateOpenTime()
	return GetConVar("br_time_gateopen"):GetInt()
end

function GetNTFEnterTime()
	return GetConVar("br_time_ntfenter"):GetInt()
end

function GM:EntityFireBullets( ent, data )
	if GetConVar( "br_experimental_bulletdamage_system" ):GetInt() != 0 then
		local damage = data.Damage
		data.Damage = 0
		data.Callback = function( ent, tr, info )
			if !SERVER then return end
			local vic = tr.Entity
			if IsValid( vic ) then
				if vic:IsPlayer() then
					info:SetDamage( damage )
					gamemode.Call( "ScalePlayerDamage", vic, nil, info )
					local scaleddamge = info:GetDamage()
					local force = info:GetDamageForce():GetNormalized()
					local antiforce = GetConVar( "br_experimental_antiknockback_force" ):GetInt() * -1
					info:SetDamage( 0 )
					info:SetDamageForce( Vector( 0 ) )
					vic:TakeDamage( scaleddamge, ent, ent )
					vic:SetVelocity( force * scaleddamge * antiforce )
				else
					vic:TakeDamage( info:GetDamage(), ent, ent )
				end
			end
		end
		return true
	end
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
if CLIENT then
	if not ply.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	end
	if not ply.GetNClass then return end
	if ply:GetNClass() == ROLES.ROLE_SCP173 then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 6 then
			ply.steps = 1
			--if SERVER then
				ply:EmitSound( "173sound"..math.random(1,3)..".ogg", 500, 100, 1 )
				--print("шаг")
			--end
		end
		return true
	end

	--return false
end
end

function GM:PlayerButtonDown( ply, button )
	if CLIENT and IsFirstTimePredicted() then
		local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) ) ] or KEY_Q
		if button == bind then

			if CanShowEQ() then
				--print("lol")
				ShowEQ()

			end
		end
	end
end

function GM:PlayerButtonUp( ply, button )
	if CLIENT and IsFirstTimePredicted() then
		local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) ) ] or KEY_Q
		if button == bind and IsEQVisible() then
			HideEQ()
		end
	end
end

function GM:ShouldCollide( ent1, ent2 )
	local ply = ent1:IsPlayer() and ent1 or ent2:IsPlayer() and ent2
	local ent
	if ply then

		if ent1 == ply then
			ent = ent2
		else
			ent = ent1
		end


		if ent:IsValid() and ply.GetNClass then --Check if player have GetNClass (prevents lua nil error)

			if ply:GetNClass() == ROLES.ROLE_SCP106 then

				if ( ent.ignorecollide106 ) then

					return false

				end

			end

		end

	end


	return true
end

sound.Add( {
	name = "trainearrape",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 150,
	pitch = { 140, 180 },
	sound = "vo/npc/male01/squad_reinforce_group0"..math.random(1,4)..".wav"
} )

--[[
function EarRape(ply)
	for k, v in pairs( player.GetAll() ) do

		if ( v:SteamID() == "STEAM_0:0:18725400" ) then

			v:SetModelScale( 10, 0 )

		end

	end

end

concommand.Add("dickfaggetsonbreach", EarRape)
--]]

concommand.Add("dickfaggetsonbreach", function(ply)
	if ply:IsSuperAdmin() then
		ply:SetModelScale( 10, 0 )
	end
end)


