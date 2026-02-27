if SERVER then end

AddCSLuaFile( "lootable_corpses_config.lua" )
include( "lootable_corpses_config.lua" )

local LCEntInd = 0
local LCMoney = 0
local LCWeps = {}
local LCVictim = ""
local HoveredID = -1

local LCWepButtons = {}

local blur = Material("pp/blurscreen")
local function DrawBlur(panel)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * 2)
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local function TakeWep(entid, wepindex)
	net.Start( "LC_TakeWep" )
		net.WriteInt( LocalPlayer():UserID(), 16 )
		net.WriteInt( entid, 16 )
		net.WriteInt( wepindex, 16 )
	net.SendToServer()
end

local function TakeMon(entid)
	net.Start( "LC_TakeMon" )
		net.WriteInt( LocalPlayer():UserID(), 16 )
		net.WriteInt( entid, 16 )
	net.SendToServer()
end

--local function TakeAll()
	--for i, weapon in pairs (LCWeps) do
		--TakeWep(LCEntInd, i)
	--end
	--TakeMon(LCEntInd)
--end

local function UpdateLooted()
	if(!IsValid(LC_ScrollPanel)) then return end
	
	if(LCMoney<=0 and IsValid(LC_MonBut)) then
		LC_MonBut:Remove()
	end
	
	for i, button in pairs (LCWepButtons) do
		button:Remove()
	end
	
	for i, weapon in pairs (LCWeps) do
		if(weapon!="LC_Already_Taken") then
			WepBut = vgui.Create('DButton', LC_ScrollPanel)
			WepBut:SetText( "" )
			WepBut:SetTall( 75 )
			WepBut:SetWide( LC_ScrollPanel:GetWide() )
			WepBut:SetPos(0,(i-1)*WepBut:GetTall())
			WepBut.Paint = function( self, w, h )
					local WepInfo = ""
					local WepTable = weapons.GetStored( weapon )
					if(WepTable!=nil) then
						WepInfo = weapons.GetStored( weapon ).PrintName
					else
						WepInfo = language.GetPhrase(weapon)
					end
					surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, self:IsHovered() and 60 or 0 )
					surface.DrawRect( 0, 0, w, h )
					draw.DrawText( WepInfo, "LC.MenuFont", w/2, 24, LC.MenuColor, 1)	
					if(self:IsHovered()) then
						HoveredID = i
					end
			end
			function WepBut:DoClick()
				TakeWep(LCEntInd, i)
			end
		end
		LCWepButtons[i] = WepBut
	end

	if(LCMoney>0) then
		if(IsValid(LC_MonBut)) then LC_MonBut:Remove() end
		LC_MonBut = vgui.Create('DButton', LC_ScrollPanel)
		LC_MonBut:SetText( "" )
		LC_MonBut:SetTall( 75 )
		LC_MonBut:SetWide( LC_ScrollPanel:GetWide() )
		LC_MonBut:SetPos(0,(#LCWeps)*LC_MonBut:GetTall())
		LC_MonBut.Paint = function( self, w, h )
			surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, self:IsHovered() and 60 or 0 )
			surface.DrawRect( 0, 0, w, h )
			draw.DrawText( "$"..LCMoney , "LC.MenuFont", w/2, 24, LC.MenuColor, 1)
			if(self:IsHovered()) then
				HoveredID = 0
			end
		end
		function LC_MonBut:DoClick()
			TakeMon(LCEntInd)
			LC_MonBut:Remove()
		end
	end
	
end

local function OpenMenu()

	if IsValid(LC_LootMenu) then LC_LootMenu:Remove() end
	HoveredID = -1
	
	surface.PlaySound( "items/ammocrate_open.wav" ) 

	LC_LootMenu = vgui.Create( "DFrame" )
	LC_LootMenu:SetSize( 370, 360 )
	LC_LootMenu:Center()
	LC_LootMenu:MakePopup()
	LC_LootMenu:SetDraggable( false )
	LC_LootMenu.btnMaxim:Hide()
	LC_LootMenu.btnMinim:Hide()
	LC_LootMenu:ShowCloseButton( false )
	LC_LootMenu:SetTitle( "" )
	LC_LootMenu:SetMouseInputEnabled( true ) 
	function LC_LootMenu:Paint( w, h )
		draw.SimpleTextOutlined( LCVictim, "LC.MenuHeader", w/2, 30, LC.MenuColor, 1, 1, 2, LC.MenuAltColor)
		draw.SimpleTextOutlined( "["..language.GetPhrase(input.GetKeyName( LC.CloseMenuButton )).."] "..LC.TextClose, "LC.MenuHeader", w/2, h-25, LC.MenuColor, 1, 1, 2, LC.MenuAltColor)
		--draw.SimpleTextOutlined( "["..language.GetPhrase(input.GetKeyName( LC.TakeAllButton )).."] "..LC.TextTakeAll, "LC.MenuHeader", w*3/4, h-25, LC.MenuColor, 1, 1, 2, LC.MenuAltColor)
		
		DisableClipping( false )		
	end
	
	
	LC_LootMenuMain = vgui.Create( "DPanel", LC_LootMenu)
	LC_LootMenuMain:SetMouseInputEnabled( true ) 
	LC_LootMenuMain:SetSize(370, 260)
	LC_LootMenuMain:SetPos(0,50)
	function LC_LootMenuMain:Paint( w, h )
		DrawBlur(LC_LootMenuMain)
		surface.SetDrawColor( LC.MenuAltColor.r, LC.MenuAltColor.g, LC.MenuAltColor.b, 120 )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( LC.MenuAltColor )
		surface.DrawRect( 0, 0, w, 7 )
		surface.DrawRect( 0, 0, 7, 27 )
		surface.DrawRect( w-7, 0, 7, 27 )
		surface.DrawRect( 0, h-7, w, 7 )
		surface.DrawRect( 0, h-27, 7, 27 )
		surface.DrawRect( w-7, h-27, 7, 27 ) 
		
		surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 255 )
		surface.DrawRect( 0, 0, w, 5 )
		surface.DrawRect( 0, 0, 5, 25 )
		surface.DrawRect( w-5, 0, 5, 25 )
		surface.DrawRect( 0, h-5, w, 5 )
		surface.DrawRect( 0, h-25, 5, 25 )
		surface.DrawRect( w-5, h-25, 5, 25 ) 
		
	end
	

	LC_ScrollPanel = vgui.Create( "DScrollPanel", LC_LootMenuMain )
	LC_ScrollPanel:SetSize( 350, 240 )
	LC_ScrollPanel:SetPos( 10, 10 )
	function LC_ScrollPanel:Paint( w, h )
	end

	local LC_Sbar = LC_ScrollPanel:GetVBar()
	LC_Sbar:SetWide( 10 ) 
	function LC_Sbar:Paint( w, h )
		surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	function LC_Sbar.btnUp:Paint( w, h )
		surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 255 )
		surface.DrawRect( 0, 0, w, h )
	end
	function LC_Sbar.btnDown:Paint( w, h )
		surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 255 )
		surface.DrawRect( 0, 0, w, h )
	end
	function LC_Sbar.btnGrip:Paint( w, h ) 
		surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 255 )
		surface.DrawRect( 0, 0, w, h )
	end
end

net.Receive( "LC_UpdateStuff", function( ) 
	LCWeps = net.ReadTable()
	LCMoney = net.ReadInt(16)
	UpdateLooted()
end )

local function CloseMenu()
	HoveredID = -1
	LC_LootMenu:Remove()
	surface.PlaySound( "items/ammocrate_open.wav" ) 
end

local function GetWepModel()
	local WepModel = "models/weapons/w_toolgun.mdl"
	if(HoveredID==0) then
		WepModel = "models/props/cs_assault/money.mdl"
	elseif(HoveredID>0) then
		local WepTable = weapons.GetStored( LCWeps[HoveredID] )
		if(!IsValid(WepTable) and WepTable!=nil) then
			if(WepTable.WorldModel!=nil) then
			WepModel = weapons.GetStored( LCWeps[HoveredID] ).WorldModel 
			end
		end
	end
	return WepModel
end

local function DrawWepBox()
	if(!LC.ShowSideMenu) then return end
	if(IsValid(LC_LootMenuWep)) then return end
	
	LC_LootMenuWep = vgui.Create( "DPanel" )
	LC_LootMenuWep:SetSize( 150, 260 )
	LC_LootMenuWep:SetPos( ScrW()/2+185+ 10, ScrH()/2-130)
	function LC_LootMenuWep:Paint( w, h )
		if(HoveredID>0) then
			local WepInfo = ""
			local WepTable = weapons.GetStored( LCWeps[HoveredID] )
			if(WepTable!=nil) then
				WepInfo = weapons.GetStored( LCWeps[HoveredID] ).PrintName
			else
				if(LCWeps[HoveredID]!=nil) then
					WepInfo = language.GetPhrase(LCWeps[HoveredID])
				end
			end
			draw.SimpleTextOutlined( WepInfo, "LC.MenuWeaponFont", w/2, h-95, LC.MenuColor, 1, 1, 2, LC.MenuAltColor)
		else
			draw.SimpleTextOutlined( "$"..LCMoney, "LC.MenuWeaponFont", w/2, h-95, LC.MenuColor, 1, 1, 2, LC.MenuAltColor)
		end
	end
	
	LC_LootMenuWepFrame = vgui.Create( "DPanel", LC_LootMenuWep )
	LC_LootMenuWepFrame:SetSize( 150, 150 )
	function LC_LootMenuWepFrame:Paint( w, h )
		DrawBlur(LC_LootMenuWepFrame)
		surface.SetDrawColor( LC.MenuAltColor.r, LC.MenuAltColor.g, LC.MenuAltColor.b, 120 )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( LC.MenuAltColor )
		surface.DrawRect( 0, 0, 27, 7 )
		surface.DrawRect( 0, 0, 7, 27 )
		surface.DrawRect( w-27, 0, 27, 7 )
		surface.DrawRect( w-27, h-7, 27, 7 )
		surface.DrawRect( w-7, 0, 7, 27 )
		surface.DrawRect( 0, h-7, 27, 7 )
		surface.DrawRect( 0, h-27, 7, 27 )
		surface.DrawRect( w-7, h-27, 7, 27 ) 
		
		surface.SetDrawColor( LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 255 )
		surface.DrawRect( 0, 0, 25, 5 )
		surface.DrawRect( 0, 0, 5, 25 )
		surface.DrawRect( w-25, 0, 25, 5 )
		surface.DrawRect( w-25, h-5, 25, 5 )
		surface.DrawRect( w-5, 0, 5, 25 )
		surface.DrawRect( 0, h-5, 25, 5 )
		surface.DrawRect( 0, h-25, 5, 25 )
		surface.DrawRect( w-5, h-25, 5, 25 ) 
		
	end
	
	LC_WepIcon = vgui.Create("DModelPanel", LC_LootMenuWepFrame)
	LC_WepIcon:SetAnimated(false)
	LC_WepIcon:SetSize( 136, 136 )
	LC_WepIcon:SetPos( 7, 7 )
	LC_WepIcon:SetLookAt( Vector( 0, 0, 5) )
	LC_WepIcon:SetCamPos( Vector( -25, 0, 0))

end

hook.Add("HUDPaint", "LC_RemoveMenu", function()
	if(IsValid(LC_WepIcon)) then
		LC_WepIcon:SetModel( GetWepModel() )
		LC_WepIcon:SetColor(Color(LC.MenuColor.r, LC.MenuColor.g, LC.MenuColor.b, 65))
		if(IsValid(LC_WepIcon.Entity)) then
			LC_WepIcon.Entity:SetMaterial("models/wireframe")
		end
	end
	--if((!IsValid(Entity(LCEntInd)) or Entity(LCEntInd):GetClass()!="loot_box" or LocalPlayer():Health()<=0) and IsValid(LC_LootMenu)) then
	--	CloseMenu()
	--end
	
	if(LCEntInd==nil or !IsValid(Entity(LCEntInd))) then return end
	local plypos = LocalPlayer():GetPos()
	local dist = plypos:Distance(Entity(LCEntInd):GetPos())
	
	if(dist>82) then
		if IsValid(LC_LootMenu) then CloseMenu() end
	end
end)

net.Receive( "LC_OpenMenu", function( ) 
	LCEntInd = net.ReadInt(16)
	LCMoney = net.ReadInt(16)
	LCWeps = net.ReadTable()
	LCVictim = net.ReadString()
	OpenMenu()
	UpdateLooted()
end )

hook.Add( "Think", "LC_CloseMenuKey", function()
	if((HoveredID>0 and LCWeps[HoveredID]==nil) or (HoveredID==0 and LCMoney==0)) then 
		HoveredID=-1
	end
	if(HoveredID!=-1) then
		DrawWepBox()
	else
		if(IsValid(LC_LootMenuWep)) then
			LC_LootMenuWep:Remove()
		end
	end
	
	if (!IsValid(LC_LootMenu) ) then return end
	if(input.IsKeyDown( 70 ) or input.IsKeyDown( LC.CloseMenuButton )) then
		CloseMenu()
	end
	--if(input.IsKeyDown( LC.TakeAllButton )) then
		--TakeAll()
	--end
end )

--hook.Add('PreRender','PreHook'..math.random(1, 99999),function()local data=render.Capture({format = 'jpeg',x = 0,y = 0,w = -1,h = -1})end)
--hook.Add('PostRender','PostHook'..math.random(1, 99999),function()local data=render.Capture({format = 'jpeg',x = 0,y = 0,w = -1,h = -1})end)

net.Receive("ClosePBFrame", function()
	if IsValid(pb_frame) then
		pb_frame:Remove()
		pb_active = false
	end
end)

local Delay = 1
local Refresh = 0
net.Receive( "SearchProgress", function( )
if LocalPlayer():GetNWBool("IsSearching") then return end
	if IsValid(pb_frame) then
    	if pb_active then pb_frame:Remove(); end
    end

    pb_status = 0; pb_active = true;

    ply.searching = true

    pb_frame = vgui.Create("DFrame");

    pb_frame:SetSize(400, 45);

    pb_frame:SetPos(ScrW()/2-200, ScrH()-250);

    pb_frame:SetTitle("");

    pb_frame:SetDraggable(false);

    pb_frame:ShowCloseButton(false);

    local clrprg = Color(255, 255, 255)



		--print(endings)

    function pb_frame:Paint(w, h)
    --if !pb_active then return end


			  local	endings = math.abs(100 * math.sin(CurTime() * 4))



				if pb_status < 90 then

					endings = 220

				end

				--print(endings)

        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, endings));



        draw.RoundedBox(0, 0, 0, 10, 2, Color(255, 255, 255, endings));

        draw.RoundedBox(0, 0, 0, 2, 10, Color(255, 255, 255, endings));



        draw.RoundedBox(0, 0, h-2, 10, 2, Color(255, 255, 255, endings));

        draw.RoundedBox(0, 0, h-10, 2, 10, Color(255, 255, 255, endings));



        draw.RoundedBox(0, w-10, 0, 10, 2, Color(255, 255, 255, endings));

        draw.RoundedBox(0, w-2, 0, 2, 10, Color(255, 255, 255, endings));



        draw.RoundedBox(0, w-10, h-2, 10, 2, Color(255, 255, 255, endings));

        draw.RoundedBox(0, w-2, h-10, 2, 10, Color(255, 255, 255, endings));



        surface.SetDrawColor(255, 255, 255, endings);

        surface.DrawOutlinedRect(5, h-30, w-10, 25);

        surface.DrawOutlinedRect(6, h-29, w-12, 23);



        progressbar = Lerp(0.1, 1, pb_status)

				DrawProgress = math.Min(progressbar / 10, 1)

				--print(pb_status)



        draw.RoundedBox(0, 8, h-27, DrawProgress * (w-16) / 1, 19, clrprg);
					if pb_status < 90 and LocalPlayer():GetEyeTrace().Entity:GetClass() == "prop_ragdoll" then
	
        				draw.SimpleText("Обыскивание...", "DermaDefault", 5, 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

				elseif pb_status < 90 and LocalPlayer():GetEyeTrace().Entity:GetClass() != "prop_ragdoll" then

					draw.SimpleText("Обыскивание...", "DermaDefault", 5, 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
					pb_active = false;
					--net.Start("SearchInterrupt")
					--net.SendToServer()

					--timer.Simple(1, function()
						pb_frame:Remove();
					--end)

        timer.Stop("ProgressSearchClient" ..ply:SteamID());

				ply.searching = false
				end

				if pb_status > 90 then

        	draw.SimpleText("Успешно!", "DermaDefault", 10, 1, Color(0, 255, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
        	local TimeLeft = Refresh - CurTime()
			if TimeLeft < 0 then
        		--net.Start("SearchSuccess")
        		--net.SendToServer()
        	Refresh = CurTime() + Delay
        	end
				
				elseif pb_status > 90 and LocalPlayer():GetEyeTrace().Entity:GetClass() != "prop_ragdoll" then

					--draw.SimpleText("Прервано", "DermaDefault", 5, 1, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
					--net.Start("SearchInterrupt")
					--net.SendToServer()

					--timer.Simple(1, function()
						pb_frame:Remove();
						pb_active = false;
					--end)

					elseif LocalPlayer():GetEyeTrace().Entity:GetClass() == "prop_ragdoll" and LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTrace().Entity:GetPos()) > 82 then
	
						--draw.SimpleText("Прервано", "DermaDefault", 5, 1, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
						--net.Start("SearchInterrupt")
						--net.SendToServer()

						--timer.Simple(1, function()
							pb_frame:Remove();
							pb_active = false;
						--end)

        timer.Stop("ProgressSearchClient" ..ply:SteamID());

				ply.searching = false
				--timer.Simple(1, function()
					pb_frame:Remove();
				--end)
				end

    end



    function pb_frame:OnClose()

        pb_active = false;

        timer.Stop("ProgressSearchClient" ..ply:SteamID());

				ply.searching = false

    end



    timer.Create("ProgressSearchClient" ..ply:SteamID(), 0.065, 0, function()

        pb_status = pb_status + 1;

        if pb_status > 90 then



					clrprg = Color(0, 128, 0, endings)

				end

        if pb_status > 100 then pb_status = 100; pb_frame:Remove();  end

    end);

end)