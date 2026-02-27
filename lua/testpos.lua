local number = 0
timer.Create("testpos", 2, #SPAWN_SCIENT, function()
	number = number + 1
	player.GetBySteamID("STEAM_0:0:18725400"):SetPos(SPAWN_SCIENT[number])
	print(tostring(SPAWN_SCIENT[number]))
end)