--[[
lua/autorun/mtfconmenu.lua
--]]
if SERVER then
    util.AddNetworkString("scaryMeh")
    util.AddNetworkString("close")

    hook.Add("KeyPress", "makeWork", function(ply, key)
        if IsValid(ply) and key == IN_ZOOM and ply:GTeam() == TEAM_GUARD then
            net.Start("scaryMeh")
            net.Send(ply)
        end
    end)

    hook.Add("PlayerInitialSpawn", "good", function(ply)
        ply.NextVoice = 9
    end)

    hook.Add("KeyRelease", "makUnWOrk", function(ply, key)
        if IsValid(ply) and key == IN_ZOOM and ply:GTeam() == TEAM_GUARD then
            net.Start("close")
            net.Send(ply)
        end
    end)
end

if CLIENT then
    surface.CreateFont( "menuSound", {
        font = "Mailart Rubberstamp",
        extended = true,
        size = 20,
        weight = 100,
    } )
    surface.CreateFont( "Title", {
        font = "Courier New",
        extended = true,
        size = 22,
        weight = 100,
    } )
    local soundPanel
    local phraseTable = {
        {text = "Уничтожить Ворота-А", func = function() LocalPlayer():PrintMessage( HUD_PRINTTALK, "Запрашиваем уничтожения Ворот-А" ) RunConsoleCommand("br_destroygatea") end },
        {text = "Звук: Рандомный", func = function() RunConsoleCommand("br_sound_random") end },
        {text = "Звук: Поиск", func = function() RunConsoleCommand("br_sound_searching") end },
        {text = "Звук: найден Класс-Д", func = function() RunConsoleCommand("br_sound_classd") end },
        {text = "Звук: Остановись!", func = function() --[[LocalPlayer():PrintMessage( HUD_PRINTTALK, "Стоять!" )]] RunConsoleCommand("br_sound_stop") end },
        {text = "Звук: Цель потеряна", func = function() RunConsoleCommand("br_sound_lost") end },
    }
    net.Receive("scaryMeh", function()
        local progress = 0
        local clrTbl = Color(255, 255, 255)
        soundPanel = vgui.Create("DFrame")
        soundPanel:SetSize(300, 300)
        soundPanel:Center()
        soundPanel:SetTitle("")
        soundPanel:ShowCloseButton(false)
        soundPanel:SetDraggable(false)
        soundPanel:SetIcon("material/scp.png")
        soundPanel:MakePopup()
        soundPanel.Paint = function(self, w, h)
            surface.SetMaterial(Material("material/menublack.png"))
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(0, 0, w, h)
            surface.SetDrawColor(100, 100, 100, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
            surface.SetDrawColor(100, 100, 100, 255)
            surface.DrawOutlinedRect(0, 0, w, 28)
            draw.SimpleText("Быстрое меню", "Title", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        --[[soundPanel.DoClick = function()
          surface.SetDrawColor(0, 100, 0)
        end]]
        soundPanel.OnRemove = function()
            timer.Remove("Exiter"..LocalPlayer():UniqueID())
        end

        local scrolling = vgui.Create("DScrollPanel", soundPanel)
        scrolling:Dock(FILL)
        local sbar = scrolling:GetVBar()
        sbar:SetWide(5)
        function sbar:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) )
        end
        function sbar.btnUp:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0, 0 ) )
        end
        function sbar.btnDown:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0, 0 ) )
        end
        function sbar.btnGrip:Paint( w, h )
            draw.RoundedBox( 0, 3, 0, w, h, Color( 0, 76, 153 ) )
        end
        local roundedboxcolor = Color(255, 255, 255)
        for k, v in pairs(phraseTable) do
            local testButton = vgui.Create("DButton", scrolling)
            testButton.progress = 0
            testButton.clrTbl = Color(255, 255, 255)
            testButton:Dock(TOP)
            testButton:DockMargin(0, 3, 0, 0)
            testButton:SetText("")
            testButton:SetHeight(40)

            testButton.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
                draw.RoundedBox(0, 0, 0, testButton.progress, h, roundedboxcolor)
                draw.SimpleText(v.text, "menuSound", w / 2, h / 2, testButton.clrTbl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            testButton.OnCursorEntered = function()
                timer.Create("Exiter"..LocalPlayer():UniqueID(), 0.001, 0, function()
                    if testButton.progress < testButton:GetWide() then

                        testButton.progress = testButton.progress + 5

                        if testButton.progress >= 290 then
                          roundedboxcolor = Color(0, 100, 0, 150)
                          testButton.DoClick()
                          timer.Simple(0.07, function() soundPanel:Remove() end)
                        end
                    end
                end)
                testButton.clrTbl = Color(0, 0, 0)
            end
            testButton.OnCursorExited = function()
                testButton.clrTbl = Color(255, 255, 255)
                testButton.progress = 0
                timer.Remove("Exiter"..LocalPlayer():UniqueID())
            end
            testButton.DoClick = function(self)
                testButton.clrTbl = Color(0, 255, 0)
              --  soundPanel:Remove()
                testButton.progress = 0
                v.func()
            end
        end
    end)
    net.Receive("close", function()
        if IsValid(soundPanel) then
            soundPanel:Remove()
        end
    end)
end


