local serverStats = {}
local feedback = ""

function AWarn2_Statistics_Post()

	serverStats.hostname = GetHostName()
	serverStats.ipport = game.GetIPAddress()
	serverStats.map = game.GetMap()
	serverStats.gamemode = gmod.GetGamemode().Name or "UNKNOWN"
	serverStats.addon = "AWarn2"
	serverStats.addonversion = AWarn.Version
	serverStats.addoninfo = "76561198214351588"

	http.Post( "http://g4p.org/addonstats/post.php", serverStats, statSuccess, function(errorCode) print("FAIL") end )
	timer.Simple( 1800, AWarn2_Statistics_Post )
end

function AWarn2_Stats_TimerStart()
	timer.Simple( 5, AWarn2_Statistics_Post )
end
hook.Add( "InitPostEntity", "awarn2_stats_post", AWarn2_Stats_TimerStart )

function statSuccess( body )
	feedback = body
	
	ServerLog("AWarn: Your server info has been updated to the online statistics tracking\n")
end