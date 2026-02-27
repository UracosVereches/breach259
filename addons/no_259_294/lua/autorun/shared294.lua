--[[
addons/294/lua/autorun/shared294.lua
--]]

if ( SERVER ) then
	
	util.AddNetworkString("ReceiveDrinkInfo")
	util.AddNetworkString("RefreshDrinkListStep1")
	util.AddNetworkString("RefreshDrinkListStep2")
	util.AddNetworkString("DeleteDrinkData")
	
	hook.Add("PlayerSpawn", "SCP294Spawn", function(ply)
		ply:SetNWBool("294Drunk", false)
		ply:SetNWBool("294Love", false)
		ply:SetNWBool("294Blur", false)
		ply:SetNWBool("294Rage", false)
		ply:SetNWBool("294Happy", false)
		ply:SetNWBool("294Crazy", false)
		ply:SetNWBool("294Boost", false)
		
		if timer.Exists( ply:SteamID() .. "294" ) then
			timer.Remove( ply:SteamID() .. "294"  )
		end
	end)
	
	
	
	-- CREATE THE DATA FILE
	function SetDataFile()
		if  not file.Exists( "drinklist.txt", "DATA" ) then
			MsgC(Color(255,0,0), "DATA Drink List donnot exist , creating ...\n")
			DrinkListData = 	{}
			DrinkListData["default"] = { color = Color(200,0,0,255), text = "This is the default drink", kill = false }
			local tab = util.TableToJSON( DrinkListData )
			file.Write( "drinklist.txt", tab )
			MsgC(Color(0,255,0), "DATA Drink List created !\n")
		end
	end
	
	-- UPDATE TABLE TO SERVER
	function UpdateDrinkList()
		local file = file.Read( "drinklist.txt" , "DATA" )
		local tab = util.JSONToTable( file )
		for k , v in pairs (tab) do
			DrinkList[k] =  {			
			color 		= v["color"],
			effect 		= function(meta)
				PrintTable(v)
				meta:EmitSound("scp294/slurp.ogg")
				meta:Say(v["text"])
				-- DID IT KILL ?
				if v["kill"] then 
					meta:Kill() 
				end
				-- DID IT HEAL ?
				if v["heal"] then 
					if meta:Health() < 100 then
						meta:SetHealth(meta:Health() + 10)
					end
				end
				-- DID IT BURN ?
				if v["burn"] then 
					meta:Ignite(20) 
				end
				-- DID IT EXPLODE ?
				if v["explode"] then 
					print("BOUM")
					local explode = ents.Create( "env_explosion" )
					explode:SetPos( meta:GetPos() )
					explode:SetOwner( meta )
					explode:Spawn()
					explode:SetKeyValue( "iMagnitude", "800" )
					explode:Fire( "Explode", 0, 0 )
					explode:EmitSound( "weapon_AWP.Single", 400, 400 )
				end
				
			end,
			dispense 	= function(ent)	
				ent:EmitSound("scp294/dispense1.ogg")
			end }
		end
		
		MsgC(Color(0,255,255), "SCP-294 : ох заебал (server) !!!\n")
	end
	
	-- SEND TABLE TO CLIENT
	function SendDrinkData( ply )
		local file = file.Read( "drinklist.txt" , "DATA" )
		local tab = util.JSONToTable( file )
		net.Start("RefreshDrinkListStep2")
			net.WriteTable(tab)
		net.Send(ply)
		MsgC(Color(0,255,0), "Sending table to " .. tostring(ply) .. " \n")
	end

	-- ADD DRINK
	function AddDrink()
		local NTab = net.ReadTable()
		
			if  not file.Exists( "drinklist.txt", "DATA" ) then
				MsgC(Color(255,0,0), "DATA Drink List donnot exist , creating ...\n")
				DrinkListData = 	{}
				DrinkListData["default"] = { color = Color(200,0,0,255), text = "This is the default drink", kill = false }
				local tab = util.TableToJSON( DrinkListData )
				file.Write( "drinklist.txt", tab )
				MsgC(Color(0,255,0), "DATA Drink List created !\n")
			end
			
			local FData = file.Read( "drinklist.txt" , "DATA" )
			local DL = util.JSONToTable( FData )
			DL[NTab["name"]] = { color = NTab["color"] , text = NTab["text"], kill = NTab["kill"], heal = NTab["heal"], burn = NTab["burn"], explode = NTab["explode"] }			
			local result = util.TableToJSON( DL )
			file.Write( "drinklist.txt", result )
			
			for _, v in pairs (player.GetAll()) do
				SendDrinkData(v)
			end
			UpdateDrinkList()
	end
	
	-- REMOVE A DRINK
	function RemoveDrink()
		local Key = net.ReadString()		
		local FData = file.Read( "drinklist.txt" , "DATA" )
		local DL = util.JSONToTable( FData )
		DL[Key] = nil
		
		local result = util.TableToJSON( DL )
		file.Write( "drinklist.txt", result )
			
		for _, v in pairs (player.GetAll()) do
			SendDrinkData(v)
		end
		UpdateDrinkList()
	end
	
	net.Receive("RefreshDrinkListStep1", function(len, ply) SendDrinkData( ply ) end )
	net.Receive("ReceiveDrinkInfo", AddDrink)
	net.Receive("DeleteDrinkData", RemoveDrink)
	
	SetDataFile()
	UpdateDrinkList()
end

if ( CLIENT ) then
	
	
	
	
	-- REFRESH THE TABLE
	function RefreshDL()
		MsgC(Color(0,255,0), "Update the drink list (client)\n")
		local NTab = net.ReadTable()
		for k , v in pairs (NTab) do
			DrinkList[k] = {  
				color 		= v["color"],
				effect 		= function(meta) meta:EmitSound("scp294/slurp.ogg")	end,
				dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
		end
	end
	net.Receive("RefreshDrinkListStep2", function() RefreshDL( ) end )
	 
	net.Start("RefreshDrinkListStep1")
	net.SendToServer()

	
	
	-- VISUAL EFFECT
	
	local love = 
	{
	[ "$pp_colour_addr" ] = 1,
	[ "$pp_colour_addg" ] = 0.75,
	[ "$pp_colour_addb" ] = 0.9,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 0.5,
	[ "$pp_colour_colour" ] = 5,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0.02,
	[ "$pp_colour_mulb" ] = 0
	}

	local rage = 
	{
	[ "$pp_colour_addr" ] = 0.05,
	[ "$pp_colour_addg" ] = 0.0,
	[ "$pp_colour_addb" ] = 0.0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 5,
	[ "$pp_colour_mulr" ] = 0.5,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
	}
	
	hook.Add("RenderScreenspaceEffects", "SCP294RSE", function()
		if LocalPlayer():GetNWBool("294Blur") then
			DrawMotionBlur( 0.2, 0.8, 0.05 )
			DrawToyTown( 20, ScrH()/2 )
		end
		if LocalPlayer():GetNWBool("294Crazy") then
			DrawMotionBlur( 0.2, 0.5, 0.1 )
			DrawSobel( 0.21 )
			DrawBloom( 0.4, 80, 9, 9, 6, 1, 1, 1, 1 )
			DrawToyTown( 40, ScrH()*0.8 )
		end
		if LocalPlayer():GetNWBool("294Rage") then
			DrawMotionBlur( 0.2, 0.8, 0.05 )
			DrawColorModify( rage )
		end	
		if LocalPlayer():GetNWBool("294Happy") then
			DrawMotionBlur( 0.2, 0.8, 0.05 )
			DrawBloom( 0.5, 1, 9, 9, 6, 10, 1, 1, 1 )
		end
		if LocalPlayer():GetNWBool("294Drunk") then
			DrawMotionBlur( 0.2, 0.8, 0.01 )
		end
		if LocalPlayer():GetNWBool("294Love") then
			DrawMotionBlur( 0.1, 1, 0.01 )
			DrawColorModify( love )
		end
	end)
end

