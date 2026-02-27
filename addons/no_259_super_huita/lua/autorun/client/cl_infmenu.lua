--[[
addons/super_huita/lua/autorun/client/cl_infmenu.lua
--]]
concommand.Add( "scp_008_config", function(ply,cmd,args)


	if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then

		local scp_infect_range=100
		local scp_infect_time=15
		local scp_zombie_limit=10



		net.Start("scp_008_whitelistRequest")
			net.WriteEntity(ply)
		net.SendToServer()

		net.Receive("scp_008_whitelistRequest",function(len)
			

			scp_008_teamWhit = net.ReadTable(scp_008_teamWhit)

		end)

		if scp_008_teamWhit == nil then return end
		
		net.Start("scp_008_requestConVar")

			net.WriteEntity(ply)
		net.SendToServer()

		net.Receive("scp_008_requestConVar",function(len)

			
			scp_infect_range=net.ReadString()
			scp_infect_time=net.ReadString()
			scp_zombie_limit=net.ReadString()			

			scp_infect_range=tonumber(scp_infect_range)
		
			local scpMenu = vgui.Create( "DPanel" )
			scpMenu:SetPos(ScrW()*0.4,ScrH()*0.4)
			scpMenu:SetSize(400,300)
			scpMenu:MakePopup()
					
			local scpText1 = vgui.Create( "DLabel", scpMenu )

			scpText1:SetPos(50,0) 
			scpText1:SetText("SCP-008 Configuration Menu") 
			scpText1:SetTextColor( Color(255, 0, 0, 255) )
			scpText1:SizeToContents() 

			local scpText2 = vgui.Create( "DLabel", scpMenu )

			scpText2:SetPos(10,30) 
			scpText2:SetSize(300,100)
			scpText2:SetText("Infection Range") 
			scpText2:SetTextColor( Color(255, 0, 0, 255) )
			scpText2:SizeToContents() 

			local scpText3 = vgui.Create( "DLabel", scpMenu )

			scpText3:SetPos(10,50) 
			scpText3:SetSize(300,100)
			scpText3:SetText("Infection time (Seconds)") 
			scpText3:SetTextColor( Color(255, 0, 0, 255) )
			scpText3:SizeToContents() 

			local scpText4 = vgui.Create( "DLabel", scpMenu )

			scpText4:SetPos(10,80) 
			scpText4:SetSize(300,100)
			scpText4:SetText("Team immunity\nDouble Click to\nremove a team,\nthey will no\nlonger be \ninfectable") 
			scpText4:SetTextColor( Color(255, 0, 0, 255) )
			scpText4:SizeToContents() 

			
			local closeB = vgui.Create("DButton",scpMenu)
			closeB:SetText("Close")
			closeB:SizeToContents()

			local scpText5 = vgui.Create( "DLabel", scpMenu )

			scpText5:SetPos(10,225) 
			scpText5:SetSize(300,100)
			scpText5:SetText("Zombie Limit") 
			scpText5:SetTextColor( Color(255, 0, 0, 255) )
			scpText5:SizeToContents() 
			

			function closeB.DoClick()
				scpMenu:Remove()
			end
			
			local iRF = vgui.Create("DNumSlider",scpMenu)

				iRF:SetPos(10,30)
				iRF:SetSize(400,10)
				iRF:SetMin(0)
				iRF:SetMax(1000)
				iRF:SetDecimals(0)
				iRF:SetValue(scp_infect_range)
				--iRF:SetVar("scp_infect_range",iRF.GetValue())

				iRF.OnValueChanged = function( panel, val )
					if( LocalPlayer():IsSuperAdmin()) then
						net.Start( "scp_008_conVarEdit" )
							net.WriteString("scp_infect_range")
							net.WriteString( math.Round(val))
						net.SendToServer()
					end
				end



				local iT = vgui.Create("DNumSlider",scpMenu)

				iT:SetPos(10,50)
				iT:SetSize(400,10)

				iT:SetMin(0)
				iT:SetMax(480)
				iT:SetDecimals(0)
				iT:SetValue(scp_infect_time)

				iT.OnValueChanged = function( panel, val )
					if( LocalPlayer():IsSuperAdmin()) then
						net.Start( "scp_008_conVarEdit" )
							net.WriteString("scp_infect_time")
							net.WriteString( math.Round(val))
						net.SendToServer()
					end
				end

				local rButt = vgui.Create("DButton",scpMenu)

				rButt:SetPos(85,175)
				rButt:SetText("Restart Whitelist")
				rButt:SizeToContents()

				function rButt.DoClick()

					net.Start("scp_008_whitelistReset")
					net.SendToServer()

					print("Updating list, menu will reload shortly")

					timer.Simple(0.5,function()
						
						scpMenu:Remove()
						
						RunConsoleCommand("scp_008_config")



					end)

				end
				

			local iList = vgui.Create("DListView", scpMenu)

				iList:SetPos(85,70)
				iList:SetSize(250,100)

				iList:AddColumn("ID")
				iList:AddColumn("Team Name")
				
				
				for k,v in pairs (scp_008_teamWhit) do

					iList:AddLine(k,v)

				end

				local iZL = vgui.Create("DNumSlider",scpMenu)

				iZL:SetPos(5,225)
				iZL:SetSize(400,10)

				iZL:SetMin(0)
				iZL:SetMax(10)
				iZL:SetDecimals(0)
				iZL:SetValue(scp_zombie_limit)

				iZL.OnValueChanged = function( panel, val )
					if( LocalPlayer():IsSuperAdmin()) then
						net.Start( "scp_008_conVarEdit" )
							net.WriteString("scp_zombie_limit")
							net.WriteString( math.Round(val))
						net.SendToServer()
					end
				end



				function iList:DoDoubleClick(line,lineinf)
					
					table.RemoveByValue(scp_008_teamWhit,lineinf:GetColumnText(2))
					
					print(lineinf:GetColumnText(2),"now immune, menu will reload shortly")

					net.Start("scp_whitelistSave")
						net.WriteTable(scp_008_teamWhit)
					net.SendToServer()

					timer.Simple(0.5,function()

						scpMenu:Remove()
						RunConsoleCommand("scp_008_config")

					end)
				
				end
			end)

	else
		print("You must be an administrator to open this menu!") 
	end
end)

