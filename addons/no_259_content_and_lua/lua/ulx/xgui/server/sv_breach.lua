--painful file to create will all breach cvars

local function init()
	if GetConVarString("gamemode") == "breach" then --Only execute the following code if it's a breach gamemode
        --Preparation and post-round
        ULib.replicatedWritableCvar( "br_time_preparing", "rep_br_time_preparing", GetConVarNumber( "br_time_preparing" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_time_postround", "rep_br_time_postround", GetConVarNumber( "br_time_postround" ), false, false, "xgui_gmsettings" )        
    
        --Round length
        ULib.replicatedWritableCvar( "br_time_round", "rep_br_time_round", GetConVarNumber( "br_time_round" ), false, false, "xgui_gmsettings" )
              
        --map NTF enter
        ULib.replicatedWritableCvar( "br_time_ntfenter", "rep_br_time_ntfenter", GetConVarNumber( "br_time_ntfenter" ), false, false, "xgui_gmsettings" )

        --EXP
        ULib.replicatedWritableCvar( "br_expscale", "rep_br_expscale", GetConVarNumber( "br_expscale" ), false, false, "xgui_gmsettings" )

        --mruganie
        ULib.replicatedWritableCvar( "br_time_blink", "rep_br_time_blink", GetConVarNumber( "br_time_blink" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_time_blinkdelay", "rep_br_time_blinkdelay", GetConVarNumber( "br_time_blinkdelay" ), false, false, "xgui_gmsettings" )
         
        --other gameplay settings
        ULib.replicatedWritableCvar( "br_spawn_level4", "rep_br_spawn_level4", GetConVarNumber( "br_spawn_level4" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_spawnzombies", "rep_br_spawnzombies", GetConVarNumber( "br_spawnzombies" ), false, false, "xgui_gmsettings" )
        
        --karma
        ULib.replicatedWritableCvar( "br_karma", "rep_br_karma", GetConVarNumber( "br_karma" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_karma_save", "rep_br_karma_save", GetConVarNumber( "br_karma_save" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_karma_max", "rep_br_karma_max", GetConVarNumber( "br_karma_max" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_karma_starting", "rep_br_karma_starting", GetConVarNumber( "br_karma_starting" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_karma_reduce", "rep_br_karma_reduce", GetConVarNumber( "br_karma_reduce" ), false, false, "xgui_gmsettings" )
        ULib.replicatedWritableCvar( "br_karma_round", "rep_br_karma_round", GetConVarNumber( "br_karma_round" ), false, false, "xgui_gmsettings" )
        
        --map related
        ULib.replicatedWritableCvar( "br_scoreboardranks", "rep_br_scoreboardranks", GetConVarNumber( "br_scoreboardranks" ), false, false, "xgui_gmsettings" )
        

    end
end
xgui.addSVModule( "breach", init )