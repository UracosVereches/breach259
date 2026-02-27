--[[
gamemodes/breach/gamemode/cl_tips.lua
--]]
local XpAddInc = false
local XPPos = 0
local TipPos = 0
local XP_Amount = 0
local MoneyAddInc = false
local MoneyPos = 0
local Money_Amount = 0
local LevelDesc = ""
local LevelUpInc = false
local LevelUpAlpha = 0
local LevelUpAlpha2 = 0

function HINTPaint()

  if ( !LevelUpInc || !LevelUpInc2 ) then return end 
    if LocalPlayer():IsValid() then

        draw.RoundedBox(0, ScrW() - XPPos, ScrH() / 4, 100, 35, Color(0, 0, 0, 155))
        -- XP Award BG
        draw.DrawText("+" .. XP_Amount .. " XP", "char_title24", ScrW() - (XPPos - 10), (ScrH() / 4) + 6, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        --[[if LocalPlayer():IsVIP() then
            draw.DrawText("x2", "char_title16", ScrW() - (XPPos - 80), (ScrH() / 4)+2, Color(255, 255, 0, 255), TEXT_ALIGN_LEFT)
        end]]

        draw.RoundedBox(0, 0, ScrH() / 1.5, 200, 35, Color(0, 0, 0, MoneyPos - 100))
        -- XP Award BG
        draw.DrawText("$" .. Money_Amount .. " Picked up", "char_title24", 25, (ScrH() / 1.5) + 6, Color(255, 255, 255, MoneyPos), TEXT_ALIGN_LEFT)

        -- Levelling up.
        if LevelUpInc == true then
            -- Level up
            --UpdateLevels()

            if LevelUpAlpha < 255 then
                LevelUpAlpha = LevelUpAlpha + 1
            end
        else
            if LevelUpAlpha > 0 then
                LevelUpAlpha = LevelUpAlpha - 1
            end
        end

        draw.RoundedBox(0, 0, (ScrH() / 2) - 25, ScrW(), 50, Color(0, 0, 0, LevelUpAlpha - 100))
        draw.SimpleTextOutlined("Level Up!", "char_title36", ScrW() / 2, ScrH() / 2, Color(77, 67, 57, LevelUpAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(255, 255, 255, LevelUpAlpha))

        if LevelUpInc2 == true then
            -- Level up
            if LevelUpAlpha2 < 255 then
                LevelUpAlpha2 = LevelUpAlpha2 + 1
            end
        else
            if LevelUpAlpha2 > 0 then
                LevelUpAlpha2 = LevelUpAlpha2 - 1
            end
        end

        draw.RoundedBox(0, 0, (ScrH() / 2) + 25, ScrW(), 50, Color(0, 0, 0, LevelUpAlpha2 - 100))
        draw.SimpleTextOutlined("UNLOCKED: " .. LevelDesc, "char_title36", ScrW() / 2, ScrH() / 2 + 50, Color(77, 67, 57, LevelUpAlpha2), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(255, 255, 255, LevelUpAlpha2))
    end
end

hook.Add("HUDPaint", "PaintOurHint", HINTPaint)

net.Receive("net_LevelUp", function(len)
    LevelUpInc = true

    timer.Simple(6, function()
        LevelUpInc = false
    end)
end)

local TipPanels = {}

-- Stacker table.
net.Receive("TipSendParams", function(len)
    local tab = net.ReadTable()
    local icontype = tab[1]
    local str = ""
    local color = Color(255, 255, 255)

    for k, v in pairs(tab) do
        if not isnumber(v) then
            str = str .. " " .. (LANG.TryTranslation(v) or v)
        elseif isnumber(v) then
            icontype = v
        else
            color = v
        end
    end

    surface.SetFont("Cyb_HudTEXT")
    local s1 = surface.GetTextSize(str)
    local tippanel = vgui.Create("DPanel")
    tippanel:SetSize(s1 + 100, 64)
    table.insert(TipPanels, tippanel)
    local pos = table.Count(TipPanels) * 70
    tippanel:SetPos(ScrW() - (s1 + 120), ScrH())
    tippanel:MoveTo(ScrW() - (s1 + 120), ScrH() - 150 - pos, 0.5, 0, -10, nil)

    tippanel:MoveTo(ScrW(), ScrH() - 150 - pos, 0.5, 5, -1, function(data, self)
        if IsValid(self) then
            table.RemoveByValue(TipPanels, self)
            self:Remove()
        end
    end)

    tippanel.Paint = function(self)
        col1 = col1 or Color(255, 255, 255, 255)
        col2 = col2 or Color(255, 255, 255, 255)
        draw.RoundedBox(8, 0, 7, self:GetWide(), 50, Color(48, 49, 54, 155))
        draw.SimpleText(str, "Cyb_HudTEXT", 80, 32, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local tipicon = vgui.Create("DImage", tippanel)
    tipicon:SetMaterial(Material("breachiconfortips.png"))
    tipicon:SetSize(64, 64)
end)

net.Receive("TipSend", function(len)
    local icontype = net.ReadUInt(3)
    local str1 = net.ReadString()
    local col1 = net.ReadTable()
    local str2 = net.ReadString()
    local lang1 = "[NO Breach]"
    --print(lang1)
    local lang2 = str1


    local col2 = net.ReadTable()
    local convar = net.ReadString() or ""
    surface.SetFont("Cyb_HudTEXT")
    local s1 = surface.GetTextSize(lang1)
    local s2 = surface.GetTextSize(lang2)

    if lang2 == "" then
        s2 = 0
    end

    local tippanel = vgui.Create("DPanel")
    tippanel:SetSize(s1 + s2 + 100, 64)
    table.insert(TipPanels, tippanel)
    local pos = table.Count(TipPanels) * 70
    tippanel:SetPos(ScrW() - (s1 + s2 + 120), ScrH())
    tippanel:MoveTo(ScrW() - (s1 + s2 + 120), ScrH() - 150 - pos, 0.5, 0, -10, nil)

    tippanel:MoveTo(ScrW(), ScrH() - 150 - pos, 0.5, 5, -1, function(data, self)
        if IsValid(self) then
            table.RemoveByValue(TipPanels, self)
            self:Remove()
        end
    end)

    tippanel.Paint = function(self)
        col1 = col1 or Color(255, 255, 255, 255)
        col2 = col2 or Color(255, 255, 255, 255)
        draw.RoundedBox(8, 0, 7, self:GetWide(), 50, Color(48, 49, 54, 155))


        if convar and convar ~= "" then
            --wtf is this shit?

            --if GetConVar(convar):GetInt() ~= nil then
                --lang1 = string.Replace(lang1, "CONVAR", string.upper(input.GetKeyName(GetConVar(convar):GetInt())))
            --end

            draw.SimpleText(lang1, "Cyb_HudTEXT", 80, 32, col1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            if lang2 ~= "" then
                --and this?
                
                --if input.GetKeyName(GetConVar(convar):GetInt()) then
                    --lang2 = string.Replace(lang2, "CONVAR", string.upper(input.GetKeyName(GetConVar(convar):GetInt())))
                --end

                draw.SimpleText(" " .. lang2, "Cyb_HudTEXT", 80 + s1, 32, col2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            return
        end

        draw.SimpleText(lang1, "Cyb_HudTEXT", 80, 32, col1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        if lang2 ~= "" then
            draw.SimpleText(" " .. lang2, "Cyb_HudTEXT", 80 + s1, 32, col2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    local tipicon = vgui.Create("DImage", tippanel)
    tipicon:SetMaterial(Material("lvl6.png"))
    tipicon:SetSize(64, 64)
end)


