--by uracosvereches
--[[
function ulx.screengrab( calling_ply, target_ply)
	target_ply.being_screngrabbed = true
	ulx.fancyLogAdmin( calling_ply, true, "#A has screngrabbed #T", target_ply)
	if CLIENT then
		net.Start( "ScreengrabRequest" )
			net.WriteEntity( target_ply )
			net.WriteUInt( 50, 32 )
		net.SendToServer()
	end
	target_ply.being_screngrabbed = false
end
local screengrab = ulx.command( "Ksaikok Anticheat(WIP)", "ulx screengrab", ulx.screengrab, "!screengrab" )
screengrab:defaultAccess( ULib.ACCESS_ADMIN )
screengrab:addParam{ type=ULib.cmds.PlayerArg }
screengrab:help( "Получить скриншот у игрока" )


function ulx.screengrab_menu( calling_ply, target_ply)
	target_ply.being_screngrabbed_menu = true
	ulx.fancyLogAdmin( calling_ply, true, "#A has screngrabbed #T's menu", target_ply)
		target_ply:SendLua('LocalPlayer():ConCommand("showconsole")')
		if CLIENT then
		net.Start( "ScreengrabRequest" )
			net.WriteEntity( target_ply )
			net.WriteUInt( 50, 32 )
		net.SendToServer()
		end
	target_ply.being_screngrabbed_menu = false
end
local screengrab_menu = ulx.command( "Ksaikok Anticheat(WIP)", "ulx screengrab_menu", ulx.screengrab_menu, "!screengrabmenu" )
screengrab_menu:defaultAccess( ULib.ACCESS_ADMIN )
screengrab_menu:addParam{ type=ULib.cmds.PlayerArg }
screengrab_menu:help( "Получить скриншот меню у игрока(в некоторых читах антискринграб может не сработать на меню)" )

function ulx.screengrab_norecoil_check( calling_ply, target_ply)
	target_ply.being_screngrabbed_norecoil_check = true
	ulx.fancyLogAdmin( calling_ply, true, "#A has screngrabbed #T with No Recoil check", target_ply)
		--target_ply:SendLua("util.ScreenShake(Vector(0, 0, 0), 5000, 100, 5, 5000)")
		target_ply:SendLua("being_screngrabbed_norecoil_check = true")
		print(target_ply)
		if CLIENT then
		net.Start( "ScreengrabRequest" )
			net.WriteEntity( target_ply )
			net.WriteUInt( 50, 32 )
		net.SendToServer()
		LocalPlayer().InProgress = true
		end
	target_ply.being_screngrabbed_norecoil_check = false
end
local screengrab_norecoil_check = ulx.command( "Ksaikok Anticheat(WIP)", "ulx screengrab_norecoil_check", ulx.screengrab_norecoil_check, "!screengrabnorecoil" )
screengrab_norecoil_check:defaultAccess( ULib.ACCESS_ADMIN )
screengrab_norecoil_check:addParam{ type=ULib.cmds.PlayerArg }
screengrab_norecoil_check:help( "Получить скриншот игрока с проверкой на отсутствие отдачи" )

	hook.Add("CalcView", "calcview_norecoil_check", function(ply, pos, angles, fov)
		if being_screngrabbed_norecoil_check == true then
			local view = {
				pos = Vector(0,0,0),
				angles = Angle(0, 0, 0),
				fov = 10,
				drawviewer = true
			}
			return view
		end
	end)
--]]