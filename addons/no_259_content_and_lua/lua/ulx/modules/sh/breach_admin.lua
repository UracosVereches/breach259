--[[
lua/ulx/modules/sh/breach_admin.lua
--]]
local CATEGORY_NAME  = "Breach Admin"
local gamemode_error = "The current gamemode is not breach!"


---[Request gate a]-------------------------------------------------------------------------
function ulx.requestgatea ( calling_ply )
	if not GetConVarString("gamemode") == "breach" then ULib.tsayError( calling_ply, gamemode_error, true ) else
		ULib.consoleCommand( "br_requestgatea" .. "\n" )
	end
end
local gatea = ulx.command( CATEGORY_NAME, "ulx requestgatea", ulx.requestgatea )
gatea:defaultAccess( ULib.ACCESS_SUPERADMIN )
gatea:help( "Request open Gate A (ONLY MTF and CI)." )
---[End]----------------------------------------------------------------------------------------
---[Round Restart]-------------------------------------------------------------------------
function ulx.roundrestart_cl( calling_ply )
	if not GetConVarString("gamemode") == "breach" then ULib.tsayError( calling_ply, gamemode_error, true ) else
		ULib.consoleCommand( "br_roundrestart_cl" .. "\n" )
		ulx.fancyLogAdmin( calling_ply, "#A has restarted the round." )
	end
end
local restartroundbreach = ulx.command( CATEGORY_NAME, "ulx roundrestart_cl", ulx.roundrestart_cl )
restartroundbreach:defaultAccess( ULib.ACCESS_SUPERADMIN )
restartroundbreach:help( "Restarts the round." )
---[End]----------------------------------------------------------------------------------------
---[Experience]-------------------------------------------------------------------------
function ulx.experience( calling_ply, target_plys, amount, should_silent )
	if not GetConVarString("gamemode") == "breach" then ULib.tsayError( calling_ply, gamemode_error, true ) else
    	for i=1, #target_plys do
    	    target_plys[ i ]:AddExp(amount)
    	end
		ulx.fancyLogAdmin( calling_ply, true, "#A gave #T #i experience", target_plys, amount )
	end
end
local expe = ulx.command( CATEGORY_NAME, "ulx experience", ulx.experience, "!exp")
expe:addParam{ type=ULib.cmds.PlayersArg }
expe:addParam{ type=ULib.cmds.NumArg, hint="Experience", ULib.cmds.round }
expe:defaultAccess( ULib.ACCESS_SUPERADMIN )
expe:setOpposite( "ulx silent exp", {_, _, _, true}, "!sexp", true )
expe:help( "Gives the <target(s)> experience." )
---[End]----------------------------------------------------------------------------------------
---[Level]-------------------------------------------------------------------------
function ulx.level( calling_ply, target_plys, amount, should_silent )
	if not GetConVarString("gamemode") == "breach" then ULib.tsayError( calling_ply, gamemode_error, true ) else
    	for i=1, #target_plys do
    	    target_plys[ i ]:AddLevel(amount)
    	end
		ulx.fancyLogAdmin( calling_ply, true, "#A gave #T #i level", target_plys, amount )
	end
end
local lvl = ulx.command( CATEGORY_NAME, "ulx level", ulx.level, "!lvl")
lvl:addParam{ type=ULib.cmds.PlayersArg }
lvl:addParam{ type=ULib.cmds.NumArg, hint="Level", ULib.cmds.round }
lvl:defaultAccess( ULib.ACCESS_SUPERADMIN )
lvl:setOpposite( "ulx silent level", {_, _, _, true}, "!slvl", true )
lvl:help( "Gives the <target(s)> level." )
---[End]----------------------------------------------------------------------------------------

