--[[
addons/super_huita/lua/autorun/client/scp_hud.lua
--]]
sound.Add( {
	name = "1123ambient",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "scp/1123/1123ambient.mp3"
} )

sound.Add( {
	name = "1123dialog",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = 90,
	sound = "scp/1123/1123dialog.mp3"
} )

sound.Add( {
	name = "35_helpme",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = {80,105},
	sound = "scp/35/helpme.mp3"
} )

sound.Add( {
	name = "35_whisper_1",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 100,
	pitch = {90,100,110}, 
	sound = "scp/35/whispers1.mp3"
} )

sound.Add( {
	name = "35_whisper_2",
	channel = CHAN_STATIC,
	volume = 0.4,
	level = 100,
	pitch = {90,100,110}, 
	sound = "scp/35/whispers2.mp3"
} )

surface.CreateFont( "SCP_font", {
	font = "cour", 
	size = ScrW()*0.011,
	weight = 500,
	antialias = true
} )


net.Receive("openScpInventory", function(len, ply)
local SCPinventory = net.ReadTable(); actionType = "drop";
PrintTable(SCPinventory)
item1_ColorString = Color(0,0,0,0); item2_ColorString = Color(0,0,0,0)
item3_ColorString = Color(0,0,0,0); item4_ColorString = Color(0,0,0,0)
item5_ColorString = Color(0,0,0,0); item6_ColorString = Color(0,0,0,0)
item7_ColorString = Color(0,0,0,0); item8_ColorString = Color(0,0,0,0)
item9_ColorString = Color(0,0,0,0); item10_ColorString = Color(0,0,0,0)

backFrame = vgui.Create( "DFrame" )
backFrame:SetPos( 0, 0 )
backFrame:SetSize( ScrW(), ScrH() )
backFrame:SetTitle( "" )
backFrame:SetDraggable( false )
backFrame:ShowCloseButton( false )
backFrame:MakePopup()
backFrame.Paint = function()
draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 128 ) ) 
	if SCPinventory[1] then
	draw.DrawText( SCPinventory[1].ID, "SCP_font", ScrW() * 0.375, ScrH() * 0.5, item1_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[2] then
	draw.DrawText( SCPinventory[2].ID, "SCP_font", ScrW() * 0.445, ScrH() * 0.5,  item2_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[3] then
	draw.DrawText( SCPinventory[3].ID, "SCP_font", ScrW() * 0.515, ScrH() * 0.5, item3_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[4] then
	draw.DrawText( SCPinventory[4].ID, "SCP_font", ScrW() * 0.585, ScrH() * 0.5, item4_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[5] then
	draw.DrawText( SCPinventory[5].ID, "SCP_font", ScrW() * 0.655, ScrH() * 0.5, item5_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[6] then
	draw.DrawText( SCPinventory[6].ID, "SCP_font", ScrW() * 0.375, ScrH() * 0.655, item6_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[7] then
	draw.DrawText( SCPinventory[7].ID, "SCP_font", ScrW() * 0.445, ScrH() * 0.655, item7_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[8] then
	draw.DrawText( SCPinventory[8].ID, "SCP_font", ScrW() * 0.515, ScrH() * 0.655, item8_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[9] then
	draw.DrawText( SCPinventory[9].ID, "SCP_font", ScrW() * 0.585, ScrH() * 0.655, item9_ColorString, TEXT_ALIGN_CENTER )
	end
	if SCPinventory[10] then
	draw.DrawText( SCPinventory[10].ID, "SCP_font", ScrW() * 0.655, ScrH() * 0.655, item10_ColorString, TEXT_ALIGN_CENTER )
	end
end

	useButtonColor = Color( 50, 50, 50, 255 )
	useButton = vgui.Create( "DButton" , backFrame)
	useButton:SetPos( ScrW()*0.24, ScrH()*0.4 )
	useButton:SetText( "" )
	useButton:SetSize( ScrW()*0.08, ScrH()*0.05 )
	useButton.DoClick = function()
		actionType = "use"
		dropButtonColor = Color (50,50,50,255)
		useButtonColor = Color( 50, 100, 50, 255 )
		surface.PlaySound("scp/button.mp3")
	end
	useButton.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.1, ScrH()*0.05, useButtonColor )  		
		draw.DrawText( "Use", "SCP_font", ScrW() * 0.04, ScrH() * 0.015, Color(210,210,210,240), TEXT_ALIGN_CENTER )
		
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0,  ScrW()*0.08, ScrH()*0.05  )
		
	end
	
	dropButtonColor = Color( 50, 100, 50, 255 )
	dropButton = vgui.Create( "DButton" , backFrame)
	dropButton:SetPos( ScrW()*0.24, ScrH()*0.475 )
	dropButton:SetText( "" )
	dropButton:SetSize( ScrW()*0.08, ScrH()*0.05 )
	dropButton.DoClick = function()
		actionType = "drop"
		useButtonColor = Color (50,50,50,255)
		dropButtonColor = Color (50,100,50,255)
		surface.PlaySound("scp/button.mp3")
	end
 	dropButton.Paint = function()
		draw.RoundedBox( 0, 0, 0,  ScrW()*0.1, ScrH()*0.05 , dropButtonColor ) 
		draw.DrawText( "Drop", "SCP_font", ScrW() * 0.04, ScrH() * 0.015, Color(210,210,210,240), TEXT_ALIGN_CENTER )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0,  ScrW()*0.08, ScrH()*0.05  )
	end
	
	exitButtonColor = Color( 50, 50, 50, 255 )
	exitButton = vgui.Create( "DButton" , backFrame)
	exitButton:SetPos( ScrW()*0.24, ScrH()*0.550 )
	exitButton:SetText( "" )
	exitButton:SetSize( ScrW()*0.08, ScrH()*0.05 )
	exitButton.DoClick = function()
		exitButtonColor = Color(120,0,0)
		surface.PlaySound("scp/button.mp3")
		timer.Simple(0.1,function()
		backFrame:Remove()
		end)
	end
 	exitButton.Paint = function()
		draw.RoundedBox( 0, 0, 0,  ScrW()*0.1, ScrH()*0.05 , exitButtonColor ) 
		draw.DrawText( "Exit", "SCP_font", ScrW() * 0.04, ScrH() * 0.015, Color(210,210,210,240), TEXT_ALIGN_CENTER )
		
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0,  ScrW()*0.08, ScrH()*0.05  )
	end

	// ITEM 1 //
	item1_Color = Color(255,255,255)
	local item1 = vgui.Create( "DButton" , backFrame)
	item1:SetPos( ScrW()*0.35, ScrH()*0.4 )
	item1:SetText( "" )
	item1:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item1.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  

		if SCPinventory[1] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[1].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item1_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item1.DoClick = function()  
		if actionType == "drop" then
			if SCPinventory[1] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 1, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 1, 32 )
			net.SendToServer()
		end
	end
	
	item1.OnCursorEntered = function()  
		if SCPinventory[1] != nil then
		item1_Color = Color(250,90,90)
		item1_ColorString = Color(255,255,255,255)
		end
	end
	
	item1.OnCursorExited = function()  
		item1_Color = Color(255,255,255)
		item1_ColorString = Color(0,0,0,0)
	end

	

	// ITEM 2 //
	item2_Color = Color(255,255,255)
	local item2 = vgui.Create( "DButton" , backFrame)
	item2:SetPos( ScrW()*0.42, ScrH()*0.4 )
	item2:SetText( "" )
	item2:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item2.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  

		if SCPinventory[2] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[2].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item2_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item2.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[2] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 2, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 2, 32 )
			net.SendToServer()
		end
	end
	
	item2.OnCursorEntered = function()  
		if SCPinventory[2] != nil then
		item2_Color = Color(250,90,90)
		item2_ColorString = Color(255,255,255,255)
		end
	end
	
	item2.OnCursorExited = function()  
		item2_Color = Color(255,255,255)
		item2_ColorString = Color(0,0,0,0)
	end
	
	// ITEM 3 //
	item3_Color = Color(255,255,255)
	local item3 = vgui.Create( "DButton" , backFrame)
	item3:SetPos( ScrW()*0.49, ScrH()*0.4 )
	item3:SetText( "" )
	item3:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item3.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  
		
		if SCPinventory[3] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[3].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item3_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
	end
	
	item3.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[3] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 3, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 3, 32 )
			net.SendToServer()
		end
	end
	
	item3.OnCursorEntered = function()  
		if SCPinventory[3] != nil then
		item3_Color = Color(250,90,90)
		item3_ColorString = Color(255,255,255,255)
		end
	end
	
	item3.OnCursorExited = function()  
		item3_Color = Color(255,255,255)
		item3_ColorString = Color(0,0,0,0)
	end

	
	// ITEM 4 //
	item4_Color = Color(255,255,255)
	local item4 = vgui.Create( "DButton" , backFrame)
	item4:SetPos( ScrW()*0.56, ScrH()*0.4 )
	item4:SetText( "" )
	item4:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item4.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  

		if SCPinventory[4] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[4].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item4_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item4.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[4] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 4, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 4, 32 )
			net.SendToServer()
		end
	end 
	
	item4.OnCursorEntered = function()  
		if SCPinventory[4] != nil then
		item4_Color = Color(250,90,90)
		item4_ColorString = Color(255,255,255,255)
		end
	end
	
	item4.OnCursorExited = function()  
		item4_Color = Color(255,255,255)
		item4_ColorString = Color(0,0,0,0)
	end
	  
	// ITEM 5 //
	item5_Color = Color (255,255,255)
	local item5 = vgui.Create( "DButton" , backFrame)
	item5:SetPos( ScrW()*0.63, ScrH()*0.4 )
	item5:SetText( "" ) 
	item5:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item5.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  

		if SCPinventory[5] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[5].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item5_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item5.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[5] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 5, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 5, 32 )
			net.SendToServer()
		end
	end
	
	item5.OnCursorEntered = function()  
		if SCPinventory[5] != nil then
		item5_Color = Color(250,90,90)
		item5_ColorString = Color(255,255,255,255)
		end
	end
	
	item5.OnCursorExited = function()  
		item5_Color = Color(255,255,255)
		item5_ColorString = Color(0,0,0,0)
	end


// ITEM 6 //

	item6_Color = Color(255,255,255)
	local item6 = vgui.Create( "DButton" , backFrame)
	item6:SetPos( ScrW()*0.35, ScrH()*0.55 )
	item6:SetText( "" ) 
	item6:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item6.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  

		if SCPinventory[6] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[6].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item6_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item6.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[6] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 6, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 6, 32 )
			net.SendToServer()
		end
	end
	
	item6.OnCursorEntered = function()  
		if SCPinventory[6] != nil then
		item6_Color = Color(250,90,90)
		item6_ColorString = Color(255,255,255,255)
		end
	end
	
	item6.OnCursorExited = function()  
		item6_Color = Color(255,255,255)
		item6_ColorString = Color(0,0,0,0)
	end


// ITEM 7 //
	item7_Color = Color(255,255,255)
	local item7 = vgui.Create( "DButton" , backFrame)
	item7:SetPos( ScrW()*0.42, ScrH()*0.55 )
	item7:SetText( "" ) 
	item7:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item7.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  
		
		if SCPinventory[7] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[7].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item7_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item7.DoClick = function() 
		if actionType == "drop" then	
			if SCPinventory[7] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 7, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 7, 32 )
			net.SendToServer()
		end
	end

	item7.OnCursorEntered = function()  
		if SCPinventory[7] != nil then
		item7_Color = Color(250,90,90)
		item7_ColorString = Color(255,255,255,255)
		end
	end
	
	item7.OnCursorExited = function()  
		item7_Color = Color(255,255,255)
		item7_ColorString = Color(0,0,0,0)
	end
	

// ITEM 8 //
	item8_Color = Color(255,255,255)
	local item8 = vgui.Create( "DButton" , backFrame)
	item8:SetPos( ScrW()*0.49, ScrH()*0.55 )
	item8:SetText( "" ) 
	item8:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item8.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  
		
		if SCPinventory[8] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[8].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor(item8_Color)
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item8.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[8] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 8, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 8, 32 )
			net.SendToServer()
		end
	end
	
	item8.OnCursorEntered = function()  
		if SCPinventory[8] != nil then
		item8_Color = Color(250,90,90)
		item8_ColorString = Color(255,255,255,255)
		end
	end
	
	item8.OnCursorExited = function()  
		item8_Color = Color(255,255,255)
		item8_ColorString = Color(0,0,0,0)
	end


// ITEM 9 //
	item9_Color = Color(255,255,255)
	local item9 = vgui.Create( "DButton" , backFrame)
	item9:SetPos( ScrW()*0.56, ScrH()*0.55 )
	item9:SetText( "" ) 
	item9:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item9.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  
		
		if SCPinventory[9] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[9].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item9_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	item9.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[9] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 9, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 9, 32 )
			net.SendToServer()
		end
	end 
	
		
	item9.OnCursorEntered = function()  
		if SCPinventory[9] != nil then
		item9_Color = Color(250,90,90)
		item9_ColorString = Color(255,255,255,255)
		end
	end
	
	item9.OnCursorExited = function()  
		item9_Color = Color(255,255,255)
		item9_ColorString = Color(0,0,0,0)
	end


// ITEM 10 //
	item10_Color = Color(255,255,255)
	local item10 = vgui.Create( "DButton" , backFrame)
	item10:SetPos( ScrW()*0.63, ScrH()*0.55 )
	item10:SetText( "" ) 
	item10:SetSize( ScrW()*0.05, ScrH()*0.09 ) 
	item10.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.05, ScrH()*0.09, Color( 0, 0, 0, 255 ) )  
		
		if SCPinventory[10] != nil then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material (SCPinventory[10].img) )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		end
		
		surface.SetDrawColor( item10_Color )
		surface.SetMaterial( Material ("item/whitecount.png") )   
		surface.DrawTexturedRect( 0, 0, ScrW()*0.05, ScrH()*0.09  )
		
	end
	
	item10.DoClick = function() 
		if actionType == "drop" then
			if SCPinventory[10] != nil then
			backFrame:Remove()
			net.Start("dropItemSCP")
			net.WriteInt( 10, 32 )
			net.SendToServer()
			end
			else
			backFrame:Remove()
			net.Start("useItemSCP")
			net.WriteInt( 10, 32 )
			net.SendToServer()
		end
	end
	
	item10.OnCursorEntered = function()  
		if SCPinventory[10] != nil then
		item10_Color = Color(250,90,90)
		item10_ColorString = Color(255,255,255,255)
		end
	end
	
	item10.OnCursorExited = function()  
		item10_Color = Color(255,255,255)
		item10_ColorString = Color(0,0,0,0)
	end

end)


net.Receive("SCP1123flash_lvl1", function(len, ply)
	surface.PlaySound("scp/1123/horror.mp3")
	flashOpacity = 0
	flashColor = Color(255,255,255,flashOpacity)
	timer.Create("SCP1123_flash1", 0.005, 6, function() flashOpacity = flashOpacity + 45  end )
	timer.Simple(0.8, function()
	timer.Create("SCP1123_flash1", 0.05, 25, function() flashOpacity = flashOpacity -45  end )
	end)
	hook.Add( "HUDPaint", "HUDSCP1123_lvl1", function()
	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255,255,255,flashOpacity) ) 
	end )
	timer.Simple(1.5, function()
		hook.Remove( "HUDPaint", "HUDSCP1123_lvl1")
	end)

end)


net.Receive("SCP1123flash", function(len, ply)
	surface.PlaySound("scp/1123/horror.mp3")
	LocalPlayer():EmitSound( "1123ambient" ) 
	LocalPlayer():EmitSound( "1123dialog" ) 
	flashOpacity = 0
	flashColor = Color(255,255,255,flashOpacity)
	timer.Create("SCP1123_flash1", 0.01, 25, function() flashOpacity = flashOpacity + 20  end )
	timer.Simple(4, function()
	timer.Create("SCP1123_flash1", 0.01, 25, function() flashOpacity = flashOpacity -20  end )
	end)
	timer.Simple(37, function()
	timer.Create("SCP1123_flash1", 0.01, 25, function() flashOpacity = flashOpacity +20  end )
	end)

	hook.Add( "HUDPaint", "HUDSCP1123", function()
	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255,255,255,flashOpacity) ) 
		local tab = {
		 [ "$pp_colour_addr" ] = 0.02,
		 [ "$pp_colour_addg" ] = 0.02,
		 [ "$pp_colour_addb" ] = 0,
		 [ "$pp_colour_brightness" ] = -0.65,
		 [ "$pp_colour_contrast" ] = 8.83,
		 [ "$pp_colour_colour" ] = 0.16,
		 [ "$pp_colour_mulr" ] = 0,
		 [ "$pp_colour_mulg" ] = 0,
		 [ "$pp_colour_mulb" ] = 0
		}
		DrawColorModify( tab )
		DrawToyTown( 10, ScrH()/2 )
		DrawBloom( 5, 0.6, 9, 9, 1, 1, 1, 1, 2 )
		DrawSharpen( 5, 1.2 )
		DrawMotionBlur( 0.1, 0.79, 0.05)
	end )

	timer.Simple(40, function()
		hook.Remove( "HUDPaint", "HUDSCP1123")
		LocalPlayer():StopSound( "1123ambient" ) 
		LocalPlayer():StopSound( "1123dialog" ) 
	end)

end)


net.Receive("SCP35manipulation_lvl1", function(len, ply)
local int = net.ReadInt(16)
	if int == 1 then
	LocalPlayer():EmitSound("35_helpme")
	elseif int == 2 then
	LocalPlayer():EmitSound("35_whisper_1")
	elseif int == 3 then 
	LocalPlayer():EmitSound("35_whisper_2")
	end
end)




