--[[
addons/lootable_corpses/lua/lootable_corpses_config.lua
--]]
LC = {}

-- READ THIS DARKRP USERS

-- Please change the following settings in your DarkRP config to false in order to prevent issues with the script:

-- GM.Config.dropweapondeath

-- GM.Config.dropmoneyondeath

-- If you don't want your players to be able to pick up the loot boxes using pockets you should add "loot_box" to the GM.Config.PocketBlacklist in the darkrp config file.



-- WORKSHOP CONTENT: https://steamcommunity.com/sharedfiles/filedetails/?id=1404582844



-- Main config:



-- Model used for the loot box -- Download: https://steamcommunity.com/sharedfiles/filedetails/?id=1404582844

--LC.BoxModel = "models/items/item_item_crate.mdl"
LC.BoxModel = "models/player/skeleton.mdl"


-- Should players drop money on death? False to disable. If you're not using Darkrp set it to false, otherwise you might get errors.

LC.MoneyEnabled = false



-- Percentage of money players will drop on death.

LC.MoneyDropPercent = 2



-- Class names of undroppable weapons.

LC.UndroppableWeapons = { "keys", "big_black_hands", "weapon_physcannon", "lods", "weapon_hexshield_local", "gmod_tool", "pocket", "weapon_physgun", "weapon_fists", "weapon_keypadchecker", "door_ram", "arrest_stick", "unarrest_stick", "weaponchecker", "v92_eq_unarmed", "gm_pickpocket_scp", "hacking_doors", "scp_cannibal", "paincake_knife1" }



-- Primary color - Default is white - Color(235,235,235). RGB color model

LC.MenuColor = Color(235,235,235)



-- Secondary color - Default is almost black - Color(20,20,20). RGB color model

LC.MenuAltColor = Color(0, 0, 0)



-- ID of the button used for closing the menu. See https://wiki.garrysmod.com/page/Enums/BUTTON_CODE for more info.

LC.CloseMenuButton = 67



-- ID of the "take all" button.

LC.TakeAllButton = 28



-- Should loot boxes despawn after certain amount of time? (Might increase performance).

LC.ShouldDespawn = false



-- Amount of time it takes to despawn inactive loot box (In seconds). Default is 600.

LC.TimeToDespawn = 600



-- Set to false if you want the loot boxes to spawn exactly where the player is, instead of the nearest ground underneath him.

LC.PUBGlike = false



-- Should dropped weapons not contain ammo in them? ( May not work with some weapons )

LC.GunsNoAmmo = false



-- Should additional menu with weapon model be displayed?

LC.ShowSideMenu = true



-- Sounds used when box is being removed.

LC.DespawnSounds = {

}



-- Sounds used when player takes an item from the box.

LC.PickupSounds = {

      "npc/combine_soldier/gear1.wav",

      "npc/combine_soldier/gear2.wav",

      "npc/combine_soldier/gear3.wav",

      "npc/combine_soldier/gear4.wav",

      "npc/combine_soldier/gear5.wav",

      "npc/combine_soldier/gear6.wav"

}



-- Text used in the script.

LC.TextLoot = "Обыскать"

LC.TextBox = ""

LC.TextClose = "Закрыть"

LC.TextTakeAll = "Take all"



-- Font config. See https://wiki.garrysmod.com/page/surface/CreateFont for more info.

if CLIENT then

	surface.CreateFont( "LC.MenuHeader", {

		font = "BebasNeue",

		size = 44

	})

	surface.CreateFont( "LC.MenuFont", {

		font = "BebasNeue",

		size = 30

	})

	surface.CreateFont( "LC.MenuWeaponFont", {

		font = "BebasNeue",

		size = 22

	})

end



