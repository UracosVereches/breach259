--[[
lua/ulx/xgui/gamemodes/breach.lua
--]]
--Terrortown settings module for ULX GUI
--Defines ttt cvar limits and ttt specific settings for the ttt gamemode.

local breach_settings = xlib.makepanel{ parent=xgui.null }

xlib.makelabel{ x=5, y=5, w=600, wordwrap=true, label="Breach ULX Commands XGUI module Created by: Ruscondil", parent=breach_settings }
xlib.makelabel{ x=2, y=345, w=600, wordwrap=true, label="The settings above DO NOT SAVE when the server changes maps, is restarted or crashes. They are for easy access only", parent=breach_settings }

xlib.makelabel{ x=5, y=190, w=160, wordwrap=true, label="Note to sever owners: to restrict this panel allow or deny permission to xgui_gmsettings.", parent=breach_settings }
xlib.makelabel{ x=5, y=250, w=160, wordwrap=true, label="Addon based on TTT ULX", parent=breach_settings }
xlib.makelabel{ x=5, y=325, w=160, wordwrap=true, label="Not all settings echo to chat.", parent=breach_settings }


breach_settings.panel = xlib.makepanel{ x=160, y=25, w=420, h=318, parent=breach_settings }
breach_settings.catList = xlib.makelistview{ x=5, y=25, w=150, h=157, parent=breach_settings }
breach_settings.catList:AddColumn( "Breach Settings" )
breach_settings.catList.Columns[1].DoClick = function() end

breach_settings.catList.OnRowSelected = function( self, LineID, Line )
	local nPanel = xgui.modules.submodule[Line:GetValue(2)].panel
	if nPanel ~= breach_settings.curPanel then
		nPanel:SetZPos( 0 )
		xlib.addToAnimQueue( "pnlSlide", { panel=nPanel, startx=-435, starty=0, endx=0, endy=0, setvisible=true } )
		if breach_settings.curPanel then
			breach_settings.curPanel:SetZPos( -1 )
			xlib.addToAnimQueue( breach_settings.curPanel.SetVisible, breach_settings.curPanel, false )
		end
		xlib.animQueue_start()
		breach_settings.curPanel = nPanel
	else
		xlib.addToAnimQueue( "pnlSlide", { panel=nPanel, startx=0, starty=0, endx=-435, endy=0, setvisible=false } )
		self:ClearSelection()
		breach_settings.curPanel = nil
		xlib.animQueue_start()
	end
	if nPanel.onOpen then nPanel.onOpen() end --If the panel has it, call a function when it's opened
end

--Process modular settings
function breach_settings.processModules()
	breach_settings.catList:Clear()
	for i, module in ipairs( xgui.modules.submodule ) do
		if module.mtype == "breach_settings" and ( not module.access or LocalPlayer():query( module.access ) ) then
			local w,h = module.panel:GetSize()
			if w == h and h == 0 then module.panel:SetSize( 275, 322 ) end
			
			if module.panel.scroll then --For DListLayouts
				module.panel.scroll.panel = module.panel
				module.panel = module.panel.scroll
			end
			module.panel:SetParent( breach_settings.panel )
			
			local line = breach_settings.catList:AddLine( module.name, i )
			if ( module.panel == breach_settings.curPanel ) then
				breach_settings.curPanel = nil
				breach_settings.catList:SelectItem( line )
			else
				module.panel:SetVisible( false )
			end
		end
	end
	breach_settings.catList:SortByColumn( 1, false )
end
breach_settings.processModules()

xgui.hookEvent( "onProcessModules", nil, breach_settings.processModules )
xgui.addModule( "Breach", breach_settings, "icon16/icon16.png", "xgui_gmsettings" )

--------------------Round structure Module--------------------
local rspnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

--Preparation and post-round
local rspapclp = vgui.Create( "DCollapsibleCategory", rspnl ) 
rspapclp:SetSize( 390, 70 )
rspapclp:SetExpanded( 1 )
rspapclp:SetLabel( "Preparing and postround" )

local rspaplst = vgui.Create( "DPanelList", rspapclp )
rspaplst:SetPos( 5, 25 )
rspaplst:SetSize( 390, 50 )
rspaplst:SetSpacing( 5 )
   
local prept = xlib.makeslider{ label="br_time_preparing (def. 60)", min=1, max=120, repconvar="rep_br_time_preparing", parent=rspaplst }
rspaplst:AddItem( prept )

local pstt = xlib.makeslider{ label="br_time_postround (def. 30)", min=1, max=120, repconvar="rep_br_time_postround", parent=rspaplst }
rspaplst:AddItem( pstt )

--Round length
local rsrlclp = vgui.Create( "DCollapsibleCategory", rspnl ) 
rsrlclp:SetSize( 390, 90)
rsrlclp:SetExpanded( 1 )
rsrlclp:SetLabel( "Round length" )

local rsrllst = vgui.Create( "DPanelList", rsrlclp )
rsrllst:SetPos( 5, 25 )
rsrllst:SetSize( 390, 30 )
rsrllst:SetSpacing( 5 )

local rtm = xlib.makeslider{label="br_time_round (def. 780)", min=1, max=2500, repconvar="rep_br_time_round", parent=rsrllst}
rsrllst:AddItem( rtm )

--NTF enter
local ntfclp = vgui.Create( "DCollapsibleCategory", rspnl ) 
ntfclp:SetSize( 390, 90 )
ntfclp:SetExpanded( 1 )
ntfclp:SetLabel( "NTF" )

local ntflst = vgui.Create( "DPanelList", ntfclp )
ntflst:SetPos( 5, 25 )
ntflst:SetSize( 390, 30 )
ntflst:SetSpacing( 5 )

local ntfnrt = xlib.makeslider{ label="br_time_ntfenter (def. 360)", min=1, max=1000, repconvar="rep_br_time_ntfenter", parent=ntflst}
ntflst:AddItem( ntfnrt )

xgui.hookEvent( "onProcessModules", nil, rspnl.processModules )
xgui.addSubModule( "Round structure", rspnl, nil, "breach_settings" )

--------------------Level Module--------------------
local exppnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

--EXP
local expzak = vgui.Create( "DCollapsibleCategory", exppnl ) 
expzak:SetSize( 390, 70 )
expzak:SetExpanded( 1 )
expzak:SetLabel( "Experience" )

local explst = vgui.Create( "DPanelList", expzak )
explst:SetPos( 5, 25 )
explst:SetSize( 390, 30 )
explst:SetSpacing( 5 )
   
local expscl = xlib.makeslider{ label="br_expscale (def. 1)", min=-10, max=10, repconvar="rep_br_expscale", parent=explst }
explst:AddItem( expscl )


xgui.hookEvent( "onProcessModules", nil, exppnl.processModules )
xgui.addSubModule( "Level", exppnl, nil, "breach_settings" )

--------------------Gameplay Module--------------------
local gppnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }


--Blink
local mrgclp = vgui.Create( "DCollapsibleCategory", gppnl ) 
mrgclp :SetSize( 390, 45 )
mrgclp :SetExpanded( 1 )
mrgclp :SetLabel( "Blink" )

local mrglst = vgui.Create( "DPanelList", mrgclp  )
mrglst:SetPos( 5, 25 )
mrglst:SetSize( 390, 45 )
mrglst:SetSpacing( 5 )

local mrgblnk = xlib.makeslider{ label="br_time_blink (def. 0.25)", min=0.01, max=1, decimal=2, repconvar="rep_br_time_blink", parent=mrglst }
mrglst:AddItem( mrgblnk )

local mrgdly = xlib.makeslider{ label="br_time_blinkdelay (def. 5)", min=1, max=10, repconvar="rep_br_time_blinkdelay", parent=mrglst }
mrglst:AddItem( mrgdly )


--Other gameplay settings
local gpogsclp = vgui.Create( "DCollapsibleCategory", gppnl ) 
gpogsclp:SetSize( 390, 200)
gpogsclp:SetExpanded( 1 )
gpogsclp:SetLabel( "Other gameplay settings" )

local gpogslst = vgui.Create( "DPanelList", gpogsclp )
gpogslst:SetPos( 5, 25 )
gpogslst:SetSize( 390, 200 )
gpogslst:SetSpacing( 5 )

local lvl4crd = xlib.makeslider{label="br_spawn_level4 (def. 2)", min=1, max=5, repconvar="rep_br_spawn_level4", parent=gpogslst }
gpogslst:AddItem( lvl4crd )

local zmbie = xlib.makecheckbox{ label="br_spawnzombies", repconvar="rep_br_spawnzombies", parent=gpogslst }
gpogslst:AddItem( zmbie )


xgui.hookEvent( "onProcessModules", nil, gppnl.processModules )
xgui.addSubModule( "Gameplay", gppnl, nil, "breach_settings" )

--------------------Karma Module--------------------
local krmpnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

local krmclp = vgui.Create( "DCollapsibleCategory", krmpnl ) 
krmclp:SetSize( 390, 400)
krmclp:SetExpanded( 1 )
krmclp:SetLabel( "Karma" )

local krmlst = vgui.Create( "DPanelList", krmclp )
krmlst:SetPos( 5, 25 )
krmlst:SetSize( 390, 135 )
krmlst:SetSpacing( 5 )

local krmekrm = xlib.makecheckbox{label="br_karma", repconvar="rep_br_karma", parent=krmlst }
krmlst:AddItem( krmekrm )

local krmsave = xlib.makecheckbox{label="br_karma_save", repconvar="rep_br_karma_save", parent=krmlst }
krmlst:AddItem( krmsave )

local krmmx = xlib.makeslider{ label="br_karma_max (def. 1200)", min=500, max=2000, repconvar="rep_br_karma_max", parent=krmlst }
krmlst:AddItem( krmmx )

local krmstrting = xlib.makeslider{ label="br_karma_starting (def. 1000)", min=500, max=2000, repconvar="rep_br_karma_starting", parent=krmlst }
krmlst:AddItem( krmstrting )

local krmrdc = xlib.makeslider{ label="br_karma_reduce (def. 30)", min=0, max=200, repconvar="rep_br_karma_reduce", parent=krmlst }
krmlst:AddItem( krmrdc )

local krmrnd = xlib.makeslider{ label="br_karma_round (def. 120)", min=0, max=500, repconvar="rep_br_karma_reduce", parent=krmlst }
krmlst:AddItem( krmrnd )

xgui.hookEvent( "onProcessModules", nil, krmpnl.processModules )
xgui.addSubModule( "Karma", krmpnl, nil, "breach_settings" )

--------------------Inne--------------------
local innenl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

local inneclp = vgui.Create( "DCollapsibleCategory", innenl ) 
inneclp:SetSize( 390, 70 )
inneclp:SetExpanded( 1 )
inneclp:SetLabel( "Groups on scoreboard" )

local innelst = vgui.Create( "DPanelList", inneclp )
innelst:SetPos( 5, 25 )
innelst:SetSize( 390, 30 )
innelst:SetSpacing( 5 )

local scrbrd = xlib.makecheckbox{ label="br_scoreboardranks ", repconvar="rep_br_scoreboardranks", parent=innelst }
innelst:AddItem( scrbrd )

xgui.hookEvent( "onProcessModules", nil, innenl.processModules )
xgui.addSubModule( "Others", innenl, nil, "breach_settings" )


