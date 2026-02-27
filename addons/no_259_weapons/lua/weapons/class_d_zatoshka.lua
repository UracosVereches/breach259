--[[
lua/weapons/class_d_zatoshka.lua
--]]
if not file.Exists( 'weapons/csgo_baseknife.lua', 'LUA' ) then
  SWEP.Spawnable = false 
  print( 'csgo_m9 failed to initialize: csgo_baseknife.lua not found. Did you install the main part?' )
  return 
end

local TTT = ( GAMEMODE_NAME == "terrortown" or cvars.Bool("csgo_knives_force_ttt", false) )

local BaseClass = baseclass.Get( 'csgo_baseknife' )
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/zatochka")
	SWEP.BounceWeaponIcon = false
end
if ( SERVER ) then
  SWEP.Weight         = 5
  SWEP.AutoSwitchTo   = false
  SWEP.AutoSwitchFrom = false

  if TTT then
    SWEP.EquipMenuData = nil
  end
end

if ( CLIENT ) then
  SWEP.SlotPos      = 0
end

SWEP.PrintName      = 'Заточка'
SWEP.droppable      = false

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

SWEP.ViewModel      = "models/weapons/scp/class_d_killer_knife.mdl"
SWEP.WorldModel     = "models/weapons/scp/w_class_d_killer_knife.mdl"

SWEP.SkinIndex      = 0
SWEP.PaintMaterial  = nil
SWEP.AreDaggers     = false

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Kind = WEAPON_EQUIP

SWEP.AutoSpawnable = false

SWEP.Icon = "vgui/entities/csgo_m9.vmt"

