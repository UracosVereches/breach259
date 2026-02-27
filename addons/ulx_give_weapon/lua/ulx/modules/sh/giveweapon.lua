--[[
addons/ulx_give_weapon/lua/ulx/modules/sh/giveweapon.lua
--]]
local CATEGORY_NAME = "Vixokii"





function ulx.giveweapon( calling_ply, target_plys, weapon )

	

	

	local affected_plys = {}

	for i=1, #target_plys do

		local v = target_plys[ i ]

		

		if not v:Alive() then

		ULib.tsayError( calling_ply, v:Nick() .. " ты дебил он мертв", true )

		

		else

		v.JustSpawned = true
		v:Give(weapon)
		v.JustSpawned = false
		
		table.insert( affected_plys, v )

		end

	end

	ulx.fancyLogAdmin( calling_ply, "#A gave #T weapon #s", affected_plys, weapon )

end

	

	

local giveweapon = ulx.command( CATEGORY_NAME, "ulx giveweapon", ulx.giveweapon, "!giveweapon" )

giveweapon:addParam{ type=ULib.cmds.PlayersArg }

giveweapon:addParam{ type=ULib.cmds.StringArg, hint="weapon name" }

giveweapon:defaultAccess( ULib.ACCESS_ADMIN )

giveweapon:help( "Ага абузер ебанный используй - !giveweapon" )







function ulx.sgiveweapon( calling_ply, target_plys, weapon )

	

	

	local affected_plys = {}

	for i=1, #target_plys do

		local v = target_plys[ i ]

		

		if not v:Alive() then

		ULib.tsayError( calling_ply, v:Nick() .. " ты дебил он мертв", true )

		

		else

		v.JustSpawned = true
		v:Give(weapon)
		v.JustSpawned = false

		table.insert( affected_plys, v )

		end

	end

end

	

	

local sgiveweapon = ulx.command( CATEGORY_NAME, "ulx sgiveweapon", ulx.sgiveweapon )

sgiveweapon:addParam{ type=ULib.cmds.PlayersArg }

sgiveweapon:addParam{ type=ULib.cmds.StringArg, hint="weapon name" }

sgiveweapon:defaultAccess( ULib.ACCESS_ADMIN )

sgiveweapon:help( "Ага абузер ебанный так и знал" )

