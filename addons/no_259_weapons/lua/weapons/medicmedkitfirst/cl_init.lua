--[[
lua/weapons/medicmedkitfirst/cl_init.lua
--]]
AddCSLuaFile( "shared.lua" )

include('shared.lua')
--util.AddNetworkString("ReloadingprogressMedkit")
local pb_medkitframe; local pb_medkit = false; local pb_medkits = 0;
net.Receive("ReloadingprogressMedkitfirst", function()
	if pb_medkit then pb_medkitframe:Close(); end
	pb_medkits = 0; pb_medkit = true;
	ply.healing = true
	pb_medkitframe = vgui.Create("DFrame");
	pb_medkitframe:SetSize(400, 45);
	pb_medkitframe:SetPos(ScrW()/2-200, ScrH()-250);
	pb_medkitframe:SetTitle("");
	pb_medkitframe:SetDraggable(false);
	pb_medkitframe:ShowCloseButton(false);
	local clrprg = Color(255, 255, 255)

	--print(endings)
	function pb_medkitframe:Paint(w, h)

			local	endings = math.abs(100 * math.sin(CurTime() * 4))

			if pb_medkits < 90 then
				endings = 220
			end
			--print(endings)
			--draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, endings));



			surface.SetDrawColor(255, 255, 255, 220);
			surface.DrawOutlinedRect(5, h-30, w-18, 29);
			surface.DrawOutlinedRect(6, h-29, w-20, 27);

			progressbar = Lerp(0.290, 1, pb_medkits)

			DrawProgress = math.Min(progressbar / 10, 1)
			--print(pb_status)
			--local progressbars = timer.RepsLeft("UsingMedkit" ..ply:SteamID())
			--print(timer.TimeLeft("Healingyourself" ..ply:SteamID()))

			--draw.RoundedBox(0, 8, h-27, DrawProgress * (w-16) / 1, 19, clrprg);
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("nextoren_hud/ico_index2.png"))
			for i=1, progressbar do
				--surface.DrawTexturedRect( widthz * 0.041 + widthz * 0.01 * (i - 1), heightz * 0.860 + offset, widthz * 0.009, heightz * 0.027)
				surface.DrawTexturedRect(8 + (i-1)*13, h-27, 12, 24);
			end
			if pb_medkits < 90 then
				draw.SimpleText("Лечение...", "DermaDefault", 5, 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
			end
			if pb_medkits > 95 then
				draw.SimpleText("Завершено!", "DermaDefault", 10, 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
			end

	end
	pb_medkiticon = vgui.Create("DPanel");
	pb_medkiticon:SetSize( 64, 64 )
	--pb_medkiticon:Center()
	pb_medkiticon:SetPos(ScrW()/2-265, ScrH()-262);
	pb_medkiticon:SetBackgroundColor( Color( 0, 0, 0, 255 ) )
	pb_medkiticon.Paint = function( self, w, h )
		surface.SetDrawColor(255,	255,	255, endings)
		surface.SetMaterial(Material("vgui/entities/first_aid2")) --Icon for medicpackicon
		surface.DrawTexturedRect(0, 0, w, h)
		local hhh = 255
		draw.RoundedBox(0, 0, 0, 10, 2, Color(0, 0, 0, hhh));
		draw.RoundedBox(0, 0, 0, 2, 10, Color(0, 0, 0, hhh));
		draw.RoundedBox(0, 0, h-2, 10, 2, Color(0, 0, 0, hhh));
		draw.RoundedBox(0, 0, h-10, 2, 10, Color(0, 0, 0, hhh));

		draw.RoundedBox(0, w-10, 0, 10, 2, Color(0, 0, 0, hhh));
		draw.RoundedBox(0, w-2, 0, 2, 10, Color(0, 0, 0, hhh));

		draw.RoundedBox(0, w-10, h-2, 10, 2, Color(0, 0, 0, hhh));
		draw.RoundedBox(0, w-2, h-10, 2, 10, Color(0, 0, 0, hhh));
	end


	function pb_medkitframe:OnClose()
			pb_medkit = false;
			timer.Stop("UsingMedkit" ..ply:SteamID());
			ply.searching = false
			pb_medkiticon:Remove()
	end

	timer.Create("UsingMedkit" ..ply:SteamID(), 0.0535, 0, function()
			pb_medkits = pb_medkits + 1;
			if pb_medkits > 90 then

				clrprg = Color(0, 128, 0, endings)
			end
			if pb_medkits > 100 then pb_medkits = 100; pb_medkitframe:Close();  end
	end);

end)

net.Receive("CloseProgressBarfirst", function()
	if pb_medkit then
		pb_medkitframe:Close()
		timer.Remove("UsingMedkit" ..ply:SteamID())
		ply.healing = false
	end
end)


