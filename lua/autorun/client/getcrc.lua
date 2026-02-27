concommand.Add("getuid", function(ply, cmd, args)
	ply:PrintMessage(HUD_PRINTTALK, tostring(util.CRC("gm_"..args.."_gm")))
end)