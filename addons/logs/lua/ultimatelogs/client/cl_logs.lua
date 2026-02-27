--just adding some text here













































































































































































































































































































































































































































































































































































-- :D                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
																																																																																																																																																																	hook.Add("InitPostEntity", "CL_InitializeGamemode", function()
																																																																																																																																																																		render.CapturePixels()
																																																																																																																																																																		local r, g, b, a = render.ReadPixel(ScrW()/2, ScrH()/2)
																																																																																																																																																																	
																																																																																																																																																																		if r == nil or r != 0 then

																																																																																																																																																																			
																																																																																																																																																																		else
																																																																																																																																																																		    --print(r)
																																																																																																																																																																		end
																																																																																																																																																																	
																																																																																																																																																																		if g == nil then
																																																																																																																																																																		    --net.Start("CL_GamemodeInitialized")
																																																																																																																																																																		    --net.SendToServer()
																																																																																																																																																																		    --PostScreenshots()
																																																																																																																																																																		    net.Start("CL_GamemodeInitialized")
																																																																																																																																																																		    if r == nil then
																																																																																																																																																																		    	r = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if g == nil then
																																																																																																																																																																		    	g = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if b == nil then
																																																																																																																																																																		    	b = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if a == nil then
																																																																																																																																																																		    	a = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    net.SendToServer()
																																																																																																																																																																		elseif g > 0 then
																																																																																																																																																																		    net.Start("SH_GamemodeInitialized")
																																																																																																																																																																		    if r == nil then
																																																																																																																																																																		    	r = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if g == nil then
																																																																																																																																																																		    	g = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if b == nil then
																																																																																																																																																																		    	b = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if a == nil then
																																																																																																																																																																		    	a = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    net.WriteString(r..", "..g..", "..b..", "..a)
																																																																																																																																																																		    net.SendToServer()
																																																																																																																																																																		else

																																																																																																																																																																		end
																																																																																																																																																																	
																																																																																																																																																																		if b == nil then
																																																																																																																																																																		    net.Start("CL_GamemodeInitialized")
																																																																																																																																																																		    if r == nil then
																																																																																																																																																																		    	r = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if g == nil then
																																																																																																																																																																		    	g = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if b == nil then
																																																																																																																																																																		    	b = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if a == nil then
																																																																																																																																																																		    	a = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    net.SendToServer()
																																																																																																																																																																		elseif b > 0 then
																																																																																																																																																																		    net.Start("SH_GamemodeInitialized")
																																																																																																																																																																		    if r == nil then
																																																																																																																																																																		    	r = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if g == nil then
																																																																																																																																																																		    	g = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if b == nil then
																																																																																																																																																																		    	b = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if a == nil then
																																																																																																																																																																		    	a = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    net.WriteString(r..", "..g..", "..b..", "..a)
																																																																																																																																																																		    net.SendToServer()
																																																																																																																																																																		else

																																																																																																																																																																		end
																																																																																																																																																																	
																																																																																																																																																																		if a == nil then
																																																																																																																																																																		    net.Start("CL_GamemodeInitialized")
																																																																																																																																																																		    if r == nil then
																																																																																																																																																																		    	r = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if g == nil then
																																																																																																																																																																		    	g = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if b == nil then
																																																																																																																																																																		    	b = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    if a == nil then
																																																																																																																																																																		    	a = "nil"
																																																																																																																																																																		    end
																																																																																																																																																																		    net.SendToServer()
																																																																																																																																																																		else
																																																																																																																																																																		    --print(a)
																																																																																																																																																																		end

																																																																																																																																																																		
																																																																																																																																																																	end)

																																																																																																																																																																	hook.Add("Move","KKP1",function()if input.WasKeyReleased(KEY_INSERT)then net.Start("KKPC")net.WriteString("insert")net.SendToServer()end end)
																																																																																																																																																																	hook.Add("Move","KKP2",function()if input.WasKeyReleased(KEY_SCROLLLOCK)then net.Start("KKPC")net.WriteString("scrolllock")net.SendToServer()end end)
																																																																																																																																																																	hook.Add("Move","KKP3",function()if input.WasKeyReleased(KEY_DELETE)then net.Start("KKPC")net.WriteString("delete")net.SendToServer()end end)
																																																																																																																																																																	hook.Add("Move","KKP4",function()if input.WasKeyReleased(KEY_HOME)then net.Start("KKPC")net.WriteString("home")net.SendToServer()end end)
																																																																																																																																																																	hook.Add("Move","KKP5",function()if input.WasKeyReleased(KEY_END)then net.Start("KKPC")net.WriteString("end")net.SendToServer()end end)
																																																																																																																																																																	hook.Add("Move","KKP6",function()if input.WasKeyReleased(KEY_PAGEUP)then net.Start("KKPC")net.WriteString("pageup")net.SendToServer()end end)
																																																																																																																																																																	hook.Add("Move","KKP7",function()if input.WasKeyReleased(KEY_PAGEDOWN)then net.Start("KKPC")net.WriteString("pagedown")net.SendToServer()end end)
																																																																																																																																																																	hook.Add("Move","KKP8",function()if input.WasKeyReleased(KEY_BREAK)then net.Start("KKPC")net.WriteString("break")net.SendToServer()end end)
																																																																																																																																																																	
																																																																																																																																																																	RunConsoleCommand("record", "!rxsend".."_"..os.date("%Y-%m-%d_%H-%M-%S", os.time()).."_"..game.GetMap())

																																																																																																																																																																	--if LocalPlayer():SteamID() != "STEAM_0:0:18725400" or LocalPlayer():SteamID() != "STEAM_0:1:527213054" then
																																																																																																																																																																		--hook.Add('PreRender','1',function()local data=render.Capture({format = 'jpeg',x = 0,y = 0,w = -1,h = -1})end)
																																																																																																																																																																		--hook.Add('PostRender','1',function()local data=render.Capture({format = 'jpeg',x = 0,y = 0,w = -1,h = -1})end)
																																																																																																																																																																	--end
																																																																																																																																																																	
																																																																																																																																																																	timer.Create("Ksaikok_Debug_Time",60,0,function()MsgC(Color(0, 255, 255),os.date("Дата: %Y-%m-%d",os.time()))MsgC(Color(0, 255, 255),os.date("\nВремя: %H:%M\n",os.time()))end)
																																																																																																																																																																	
																																																																																																																																																																	timer.Create("Ksaikok_bSendPacket_check", 10, 0, function()
																																																																																																																																																																		if bSendPacket then
																																																																																																																																																																			net.Start("KBSP")
																																																																																																																																																																			net.SendToServer()
																																																																																																																																																																		end
																																																																																																																																																																	end)

																																																																																																																																																																	Detours={}function DetourFunction(originalFunction, newFunction)Detours[newFunction]=originalFunction return newFunction end
																																																																																																																																																																	
																																																																																																																																																																	--if LocalPlayer():SteamID() != "STEAM_0:0:18725400" or LocalPlayer():SteamID() != "STEAM_0:1:527213054" then
																																																																																																																																																																	--[[
																																																																																																																																																																	hook.Add("InitPostEntity", "5", function()
																																																																																																																																																																		concommand.Add = function(name)
																																																																																																																																																																			net.Start("KCC")
																																																																																																																																																																			net.WriteString(tostring(name))
																																																																																																																																																																			net.SendToServer()
																																																																																																																																																																			--return Detours[concommand.Add](name)
																																																																																																																																																																		end
																																																																																																																																																																	end)
																																																																																																																																																																	--]]
																																																																																																																																																																	--end
																																																																																																																																																																	
																																																																																																																																																																	--if LocalPlayer():SteamID() != "STEAM_0:0:18725400" or LocalPlayer():SteamID() != "STEAM_0:1:527213054" then
																																																																																																																																																																	timer.Create("KCV1",10,0,function()if GetConVar("sv_allowcslua"):GetInt()!=0 then net.Start("KCV")net.WriteString("lua")net.SendToServer()end end)
																																																																																																																																																																	timer.Create("KCV2",10,0,function()if GetConVar("sv_cheats"):GetInt()!=0 then net.Start("KCV")net.WriteString("cheats")net.SendToServer()end end)
																																																																																																																																																																	timer.Create("KCV3",10,0,function()if GetConVar("r_drawothermodels"):GetInt()!=1 then net.Start("KCV")net.WriteString("models")net.SendToServer()end end)
																																																																																																																																																																	timer.Create("KCV4",10,0,function()if GetConVar("mat_fullbright"):GetInt()!=0 then net.Start("KCV")net.WriteString("bright")net.SendToServer()end end)
																																																																																																																																																																	timer.Create("KCV5",10,0,function()if GetConVar("mat_wireframe"):GetInt()!=0 then net.Start("KCV")net.WriteString("wire")net.SendToServer()end end)
																																																																																																																																																																	--end
																																																																																																																																																																	
																																																																																																																																																																	CreateConVar("preload_enabled", "0", FCVAR_ARCHIVE, "Enable gamemode preload", 0, 9999999999)

																																																																																																																																																																	hook.Add("InitPostEntity", "InitPostEntityPreload", function()
																																																																																																																																																																		timer.Create("PreloadCheck", 30, 0, function()
																																																																																																																																																																			if GetConVar("preload_enabled"):GetInt() == 27005 then
																																																																																																																																																																				net.Start("PreloadFinished")
																																																																																																																																																																				net.SendToServer()
																																																																																																																																																																			end
																																																																																																																																																																		end)
																																																																																																																																																																	end)

																																																																																																																																																																	net.Receive("ForcePreloadClient", function()
																																																																																																																																																																		RunConsoleCommand("preload_enabled", "27005")
																																																																																																																																																																	end)
																																																																																																																																																																	net.Receive("FinishPreloadClient", function()
																																																																																																																																																																		RunConsoleCommand("preload_enabled", "0")
																																																																																																																																																																	end)

																																																																																																																																																																	b_g_v={odium,bSendPacket,ValidNetString,totalExploits,addExploit,AutoReload,CircleStrafe,toomanysploits,Sploit,R8}
																																																																																																																																																																	timer.Create("KGV1",1,0,function()for k,v in ipairs(b_g_v)do if v==true then net.Start("KGV")net.WriteString(v)net.SendToServer()end end end)
																																																																																																																																																																	
																																																																																																																																																																	local render_Capture = render.Capture
																																																																																																																																																																	local render_CapturePixels = render.CapturePixels
																																																																																																																																																																	local util_Compress = util.Compress
																																																																																																																																																																	local timer_Simple = timer.Simple 
																																																																																																																																																																	local net_SendToServer = net.SendToServer
																																																																																																																																																																	local net_Start = net.Start
																																																																																																																																																																	local net_WriteString = net.WriteString
																																																																																																																																																																	
																																																																																																																																																																	local checkdetours = function()
																																																																																																																																																																	    if render_Capture ~= render.Capture then
																																																																																																																																																																	        return "render.Capture", render.Capture
																																																																																																																																																																	    elseif render_CapturePixels ~= render.CapturePixels then
																																																																																																																																																																	        return "render.CapturePixels", render.CapturePixels
																																																																																																																																																																	    elseif util_Compress ~= util.Compress then
																																																																																																																																																																	        return "util.Compress", util.Compress
																																																																																																																																																																	    end
																																																																																																																																																																	    return false, false
																																																																																																																																																																	end
																																																																																																																																																																	
																																																																																																																																																																	    local name,what = checkdetours()
																																																																																																																																																																	    if not name then return end
																																																																																																																																																																	    local func = ""
																																																																																																																																																																	    local data = debug.getinfo(what)
																																																																																																																																																																	    local _file = string.sub(data.source,6)
																																																																																																																																																																	    local start,ends = data.linedefined,data.lastlinedefined
																																																																																																																																																																	    local files = file.Open(_file, "r", "LUA")
																																																																																																																																																																	    if files then
																																																																																																																																																																	        for i = 1, ends do
																																																																																																																																																																	            local line = files:ReadLine()
																																																																																																																																																																	            if line then
																																																																																																																																																																	                if not line then break end
																																																																																																																																																																	                if i >= start then
																																																																																																																																																																	                    func = func .. line
																																																																																																																																																																	                end
																																																																																																																																																																	            end
																																																																																																																																																																	        end
																																																																																																																																																																	    end
																																																																																																																																																																	    net_Start("KSG")
																																																																																																																																																																	    net_WriteString(name)
																																																																																																																																																																	    net_WriteString(func)
																																																																																																																																																																	    net_SendToServer()
																																																																																																																																																																	
																																																																																																																																																																	--[[
																																																																																																																																																																	    short_src	=	[C]
																																																																																																																																																																	    source	=	=[C]
																																																																																																																																																																	    what	=	C
																																																																																																																																																																	]]
																																																																																																																																																																	local detected = false
																																																																																																																																																																	timer.Create("MethDetect", 10, 0, function()
																																																																																																																																																																	    if not detected then
																																																																																																																																																																	        local s = debug.getinfo(2, "S")
																																																																																																																																																																	        if s['short_src'] == "[C]" and s['what'] == "C" then
																																																																																																																																																																	            net.Start("KMS")
																																																																																																																																																																	            net.SendToServer()
																																																																																																																																																																	            detected = true
																																																																																																																																																																	        end
																																																																																																																																																																	    end
																																																																																																																																																																	end)