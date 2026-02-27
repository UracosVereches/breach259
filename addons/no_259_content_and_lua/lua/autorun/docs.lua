--[[
lua/autorun/docs.lua
--]]
local MAX_PLAYER_DOCS = 3;

if CLIENT then
    surface.CreateFont("DocsFont", {font = "Arial", size = 20, weight = 500, shadow = true});
    hook.Add("HUDPaint", "HUDDocs", function()
      if LocalPlayer():GetNWInt("documents", 0) < 1 then return end
        draw.RoundedBox(0, ScrW()-50, 10, 40, 40, Color(0, 0, 0, 200));
        draw.RoundedBox(0, ScrW()-150, 15, 95, 30, Color(0, 0, 0, 200));

        surface.SetDrawColor(255, 255, 255, 200);

        surface.SetMaterial(Material("docs_ico.png"));
        surface.DrawTexturedRect(ScrW()-45, 15, 30, 30);
        local clr = Color(255,255,255,255)
        if LocalPlayer():GetNWInt("documents") >= 3 then
          clr = Color(255, 0, 0, 255)
        end
        draw.SimpleText(LocalPlayer():GetNWInt("documents", 1) .. " / " .. MAX_PLAYER_DOCS, "DocsFont", ScrW()-150 + 95/2, 31, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end);
	hook.Add("HUDPaint", "fbiHUDDocs", function()
       if LocalPlayer():GetNWInt("fbidocuments", 0) < 1 then return end
      if LocalPlayer():GetNWInt("documents", 0) >= 1 then
        draw.RoundedBox(0, ScrW()-50, 55, 40, 40, Color(0, 0, 0, 200));
        draw.RoundedBox(0, ScrW()-150, 60, 95, 30, Color(0, 0, 0, 200));
      end
      if LocalPlayer():GetNWInt("documents", 0) <= 0 then
        draw.RoundedBox(0, ScrW()-50, 10, 40, 40, Color(0, 0, 0, 200));
        draw.RoundedBox(0, ScrW()-150, 15, 95, 30, Color(0, 0, 0, 200));
      end

        surface.SetDrawColor(255, 255, 255, 200);

        surface.SetMaterial(Material("fbidocs_ico.png"));
        surface.DrawTexturedRect(ScrW()-45, 15, 30, 30);
      local pos = 31
      if LocalPlayer():GetNWInt("documents", 0) >= 1 then
        surface.DrawTexturedRect(ScrW()-45, 62, 30, 30);
        pos = 75
      end
        draw.SimpleText(LocalPlayer():GetNWInt("fbidocuments", 1) .. " / " .. MAX_PLAYER_DOCS, "DocsFont", ScrW()-150 + 95/2, pos, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end);
end

if SERVER then
    function CleanupDocuments()
        for _, v in pairs(player.GetAll()) do
            v:SetNWInt("documents", 0);
			v:SetNWBool("HudjhouldDraw",false)
			v:SetNWBool("CD2", false)
			v:SetNWBool("CD3", false)
			v:SetNWBool("CD99", false)
      SetGlobalBool("GuardEscape", false)
			v:SetColor( Color( 255, 255, 255, 255 ) )
			v:SetNWBool("IsInsideLocker", false)
			v:SetNWBool("CD", false)
			v:SetNWBool("CDX",false)
      v:SetNWBool("Victim", false)
			v:SetNWBool("Allo", false)
			v:SetNWInt("SCP", 0)
	        v:SetNWInt("D", 0)
	        v:SetNWInt("RES", 0)
	        v:SetNWInt("VSEGO", 0)
	        v:SetNWInt("CHAOS", 0)
	        v:SetNWInt("MTF", 0)
			v:SetNWInt("XCX", 0)
			v:SetNWInt("fbidocuments", 0)
			v:SetNWBool("debuff", false)
			v:SendLua([[LocalPlayer():ConCommand("pp_mat_overlay \"")]])

        end
    end
    CleanupDocuments();
end


