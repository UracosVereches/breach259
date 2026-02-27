--[[
addons/294/lua/autorun/drinklist294.lua
--]]
DrinkList = {}
SCP294BasicText = "Довольно приянтый напиток."
function SimpleDrink(name, text, col)
    DrinkList[name] =   {
        color       = col,
        effect      = function(meta) meta:Say( text ) meta:EmitSound("scp294/slurp.ogg") end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
end
function NotSimpleDrink(name, text, col)
    DrinkList[name] =   {
        color       = col,
        effect      = function(meta) meta:PrintMessage( HUD_PRINTTALK, text ) meta:EmitSound("scp294/slurp.ogg") end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
end
 
DrinkList["rich"] = {
    color       = Color(255, 222, 173),
    effect      = function(ply)
        ply:PrintMessage( HUD_PRINTTALK, ply:Nick() .. "- самый лучший." )
        end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["air"] = {
    color       = Color(75, 0, 130),
    effect      = function(ply)
    ply:PrintMessage( HUD_PRINTTALK, "В этой чашке ничего нет кроме кислорода." )
        local hp = ply:Health()
        local h = ply:GetMaxHealth()
            if ply:Alive() then
                ply:SetHealth(hp + math.random( 1, 3))
            end
            if hp > ply:GetMaxHealth(h + 100) then
                ply:SetHealth(hp - math.random( 2, 50))
            end
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["water"] = {
    color       = Color(240, 128, 128),
    effect      = function(ply)
    ply:EmitSound("scp294/slurp.ogg")
    ply:PrintMessage( HUD_PRINTTALK, "Вы только что выпили обычную воду." )
        if ply:IsOnFire() then
            ply:Ignite(0)
        end
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
NotSimpleDrink("hl3", "Вы нашли записку в чашке: 'Меня нет и не будет'.", Color(255,215,0))
NotSimpleDrink("champagne", "На вкус как дешевое шампанское...", Color(255,215,0))
NotSimpleDrink("nothing", "В этой чашке ничего нет.", Color(255,215,0))
NotSimpleDrink("no", "В этой чашке ничего нет.", Color(255,215,0))
NotSimpleDrink("doshirak", "Мм, да это доширак!", Color(255,215,0))
DrinkList["beer"] = {
    color       = Color(160, 82, 45),
    effect      = function(meta)
        meta:SetNWBool("294Drunk", true)
        meta:Say( "Ну че мужики, погнали?.." )
        meta:EmitSound("scp294/slurp.ogg") 
    timer.Simple(12 , function() meta:SetNWBool("294Drunk", false) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["vodka"] = {
    color       = Color(224, 255, 255),
    effect      = function(ply)
        ply:SetNWBool("294Drunk", true)
        ply:PrintMessage( HUD_PRINTTALK, "На вкус как... водка?" )
        ply:EmitSound("scp294/ahh.ogg")
        local function regenvodka(ply)
            local hp = ply:Health()
                if ply:Alive() and ply:IsValid() then
                    if hp >= ply:GetMaxHealth() then
                        ply:SetHealth(hp)
                    elseif hp < ply:GetMaxHealth() then
                        ply:SetHealth(hp + math.random( 3, 10))
                    end
                end
            end
    timer.Simple(0.35, function() regenvodka(ply) end)
    timer.Simple(0.85, function() regenvodka(ply) end)
    timer.Simple(1.35, function() regenvodka(ply) end)
    timer.Simple(1.85, function() regenvodka(ply) end)
    timer.Simple(2.35, function() regenvodka(ply) end)
    timer.Simple(2.85, function() regenvodka(ply) end)
    timer.Simple(3.35, function() regenvodka(ply) end)
    timer.Simple(3.85, function() regenvodka(ply) end)
    timer.Simple(15.5, function() ply:SetNWBool("294Drunk", false) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }

DrinkList["immortality"] = {
    color       = Color(205, 92, 92),
    effect      = function(meta)
        meta:PrintMessage( HUD_PRINTTALK, "Вы наполняетесь решимостью, вы чувствуете себя сильнее." )
        meta:SetHealth(math.random( 550000, 800000))
        meta:SetNWBool("294Crazy", true)
        meta:EmitSound("scp294/ahh.ogg")
        local function disableGodMod(ply)
                if ply:Alive() and ply:IsValid()  then
                    ply:SetHealth(150)
                end
            end
        timer.Simple(math.random( 11, 15), function() disableGodMod(meta) meta:SetNWBool("294Crazy", false) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }

DrinkList["chim"] = {
    color       = Color(205, 92, 92),
    effect      = function(meta)
        meta:PrintMessage( HUD_PRINTTALK, "Это был самый лучший момент в вашей жизни..." )
        meta:SetHealth(math.random( 100000, 200000))
        meta:SetNWBool("294Drunk", true)
        meta:EmitSound("scp294/ahh.ogg")
        local function disableGodMod(ply)
            if ply:Alive() then
                ply:SetHealth(125)
            end
        end    
        timer.Simple(math.random( 4, 10), function() disableGodMod(meta) meta:SetNWBool("294Drunk", false) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
local don3 = "STEAM_0:0:437869679"
DrinkList["heal"] = {
    color       = Color(178, 34, 34),
    effect      = function(ply)
    ply:PrintMessage( HUD_PRINTTALK, "Это самый лучший напиток за всю мою короткую жизнь!" )
        local hp = ply:Health()
        if ply:Alive() then
            if hp > 125 then
                ply:SetHealth(hp + 0)
            elseif hp <= 125 then
                ply:EmitSound("scp294/ahh.ogg")
                ply:SetHealth(125)
            end
        end
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["life"] = {
    color       = Color(178, 34, 34),
    effect      = function(ply)
        ply:PrintMessage( HUD_PRINTTALK, "Вы только что выпили напиток похожий на чью-то жизнь." )
        ply:EmitSound("scp294/slurp.ogg")
        local hp = ply:Health()
        if ply:Alive() then
            if hp > 130 then
                ply:SetHealth(hp)
            elseif hp <= 130 then
                ply:SetHealth(130)
            end
        end    
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["scp-106"] = {
    color       = Color(47, 79, 79),
    effect      = function(meta)
        meta:PrintMessage( HUD_PRINTTALK, "Я чувствую, что что-то движется в моем животе..." )
        meta:SetNWBool("294Blur", true)
        meta:EmitSound("sfx/scp/106/laugh.ogg")
        local function bleed(ply)
            local hp = ply:Health()
            if ply:Alive() then
                if ply:GetNWBool("294Blur") then
                    if hp > 0 then
                        ply:SetHealth(hp - math.random( 4, 10))
                    end
                    if hp <= 0 and ply:Alive() then
                        ply:Kill()
                    end
                end
            end
        end    
        timer.Simple(0.75, function() bleed(meta) end)
        timer.Simple(1.5, function() bleed(meta) end)
        timer.Simple(2.25, function() bleed(meta) end)
        timer.Simple(3, function() bleed(meta) end)
        timer.Simple(3, function() meta:SetNWBool("294Blur", false) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["scp-939"] = {
    color       = Color(255, 0, 0),
    effect      = function(meta)
        local function scp939(ply)
            ply:PrintMessage( HUD_PRINTTALK, "Я чувствую... А-А-А, БОЛЬНО!" )
            ply:EmitSound("scp/939/bite.ogg")
            if ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP then
                local hp = ply:Health()
                if ply:Alive() then
                    ply:SetHealth(hp - 25)
                end
            end
        end
        local function checkhp(ply)
            if ply:Health() <= 0 then
                ply:Kill()
            end
        end
        timer.Simple(0, function() scp939(meta) end)
        timer.Simple(0.05, function() checkhp(meta) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["scp-023"] = {
    color       = Color(128, 128, 128),
    effect      = function(ply)
        ply:PrintMessage( HUD_PRINTTALK, "Я чувствую, что я скоро умру.." )
        ply:EmitSound("dog.mp3")
        local function scp023(ply)
            if ply:Alive() then
                if ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC then
                    ply:Kill()
                end
            end
        end
        timer.Simple(60, function() scp023(ply) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["hack"] = {
    color       = Color(0, 0, 0),
    effect      = function(ply)
        ply:PrintMessage( HUD_PRINTCENTER, "Поздравляем, Вы сделали это!" )
        ply:PrintMessage( HUD_PRINTTALK, "Вы только что нашли самый секретный напиток в SCP-294!" )
        ply:EmitSound("baddest.wav")
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["me"] = {
    color       = Color(0, 0, 0),
    effect      = function(ply)
        ply:PrintMessage( HUD_PRINTTALK, ply:Nick() .. " - Ваш ник | " .. ply:SteamID() .. " - Ваш SteamID | " .. ply:AccountID() .. " - Ваш номер аккаунта." )
        ply:EmitSound("baddest.wav")
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["blood of jesus"] =   {
        color       = Color(128, 0, 0),
        effect      = function(meta)
            meta:PrintMessage( HUD_PRINTTALK, "Этот напиток напоминает кровь знакомого мне человека." )
            meta:EmitSound("scp294/slurp.ogg")
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end
    }
DrinkList["blood"] =    {
        color       = Color(128, 0, 0),
        effect      = function(meta)
            meta:PrintMessage( HUD_PRINTTALK, "Этот напиток напоминает кровь..." )
            meta:EmitSound("scp294/slurp.ogg")
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end
    }
DrinkList["fire"] = {
        color       = Color(210, 105, 30),
        effect      = function(meta)
            meta:EmitSound("scp294/burn.ogg")
            meta:PrintMessage( HUD_PRINTTALK, "ГОРЯЧО!" )
            meta:Ignite( math.random( 25, 60))
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["lava"] = {
        color       = Color(210, 105, 30),
        effect      = function(meta)
            meta:EmitSound("scp294/burn.ogg")
            meta:PrintMessage( HUD_PRINTTALK, "ОЧЕНЬ ГОРЯЧО!" )
            meta:Ignite( math.random( 35, 65))
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["meme"] = {
        color       = Color(128, 0, 128),
        effect      = function(meta)
            meta:PrintMessage( HUD_PRINTTALK, "Me gusta xDD lel!" )
            meta:SetNWBool("294Drunk", true)
            meta:EmitSound("scp294/slurp.ogg")
            local function removeBuff(ply)
                if ply:IsValid() then
                    if ply:GetNWBool("294Drunk") then
                        ply:SetNWBool("294Drunk", false)
                    end
                end
            end
            timer.Simple(5, function() removeBuff(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["memes"] = {
        color       = Color(255, 0, 255),
        effect      = function(meta)
            meta:PrintMessage( HUD_PRINTTALK, "Me gusta xDD lel!!" )
            meta:SetNWBool("294Drunk", true)
            meta:EmitSound("scp294/slurp.ogg")
            local function removeBuff(ply)
                if ply:IsValid() then
                    if ply:GetNWBool("294Drunk") then
                        ply:SetNWBool("294Drunk", false)
                    end
                end
            end
            timer.Simple(7, function() removeBuff(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["pain killer"] = {
        color       = Color(165, 42, 42),
        effect      = function(meta)
            meta:PrintMessage( HUD_PRINTTALK, "Очень приятный напиток." )
            meta:EmitSound("scp294/slurp.ogg")
            meta:SetNWBool("294Blur", true)
                local function ktp(ply)
                local hp = ply:Health()
                if ply:IsValid() and ply:Alive() then
                    if ply:GetNWBool("294Blur") then
                        if hp < ply:GetMaxHealth() then
                            ply:SetHealth(hp + math.random( 5, 10))
                        elseif hp > ply:GetMaxHealth() then
                            ply:SetHealth(100)
                        end
                    end
                end
            end
            timer.Simple(0.35, function() ktp(meta) end)
            timer.Simple(0.85, function() ktp(meta) end)
            timer.Simple(1.45, function() ktp(meta) end)
            timer.Simple(2, function() ktp(meta) end)
            timer.Simple(2.60, function() ktp(meta) end)
            timer.Simple(3.5, function() ktp(meta) end)
            timer.Simple(3.5, function() meta:SetNWBool("294Blur", false) end)         
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["cola"] = {
        color       = Color(47, 79, 79),
        effect      = function(meta)
        meta:PrintMessage( HUD_PRINTTALK, "Довольно вкусный напиток..." )
        meta:EmitSound( "scp294/spit.ogg" )
        meta:SetNWBool("294Blur", true)
                local function ktp(ply)
                local hp = ply:Health()
                if ply:IsValid() then
                    if ply:Alive() and ply:GetNWBool("294Blur") then
                        if hp > 100 then
                            ply:SetHealth(hp - math.random( 3, 8))
                        end
                        if hp < 0 then
                            ply:Kill()
                        end
                    end
                end
            end
            timer.Simple(0.5, function() ktp(meta) end)
            timer.Simple(1, function() ktp(meta) end)
            timer.Simple(1.5, function() ktp(meta) end)
            timer.Simple(2, function() ktp(meta) end)
            timer.Simple(2.5, function() ktp(meta) end)
            timer.Simple(3, function() ktp(meta) end)
            timer.Simple(3, function() meta:SetNWBool("294Blur", false) end)           
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["random drink"] = {
        color       = Color(255, 160, 122),
        effect      = function(meta)
            local allKey = {}
            for k , v in pairs (DrinkList) do
                allKey[#allKey + 1] =  k
            end
            local id    = math.random(1, #allKey)
            print(allKey[id])
           
            if allKey[id] == "random drink" then
                meta:EmitSound("scp294/burn.ogg")
                meta:Kill()
            else
                DrinkList[allKey[id]].effect(meta)         
            end
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["rd"] = {
        color       = Color(255, 160, 122),
        effect      = function(meta)
            local allKey = {}
            for k , v in pairs (DrinkList) do
                allKey[#allKey + 1] =  k
            end
            local id    = math.random(1, #allKey)
            print(allKey[id])
           
            if allKey[id] == "random drink" then
                meta:EmitSound("scp294/burn.ogg")
                meta:Kill()
            else
                DrinkList[allKey[id]].effect(meta)         
            end
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }

DrinkList["ammunition"] = {
        color       = Color(240, 128, 128),
        effect      = function(ply)
        ply:EmitSound( "weapons/mp5k/handling/mp5k_magin.wav" )
            if ply:Alive() then
                ply:GiveAmmo( 12, "AR2", false )
                ply:GiveAmmo( 12, "Pistol", false )
                ply:GiveAmmo( 12, "SMG1", false )
            end
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["ammo"] = {
        color       = Color(240, 128, 128),
        effect      = function(ply)
        ply:EmitSound( "weapons/mp5k/handling/mp5k_magin.wav" )
            if ply:Alive() then
                ply:GiveAmmo( 7, "AR2", false )
                ply:GiveAmmo( 7, "Pistol", false )
                ply:GiveAmmo( 7, "SMG1", false )
            end
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["saammo"] = {
        color       = Color(160, 82, 45),
        effect      = function(meta)
        local function saammo(ply)
                if ply:SteamID() == don1 or ply:IsSuperAdmin() or ply:SteamID() == don2 or ply:SteamID() == don3 then
                    meta:EmitSound( "weapons/mp5k/handling/mp5k_magin.wav" )
                    for k , v in pairs (meta:GetWeapons()) do
                        local ammo = v:GetPrimaryAmmoType()
                        local secammo = v:GetSecondaryAmmoType()
                        meta:GiveAmmo( math.random( 100, 150), ammo, false )
                        meta:GiveAmmo( 50, secammo, true)
                    end
                else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                end
            end
            timer.Simple(0, function() saammo(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["aammo"] = {
        color       = Color(160, 82, 45),
        effect      = function(meta)
                local function aammo(ply)
                meta:EmitSound( "weapons/mp5k/handling/mp5k_magin.wav" )
                    if ply:IsAdmin() then
                        for k , v in pairs (meta:GetWeapons()) do
                            local ammo = v:GetPrimaryAmmoType()
                            meta:GiveAmmo( math.random( 25, 38), ammo, false )
                        end
                    else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                    end
                end
            timer.Simple(0, function() aammo(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["safire"] = {
        color       = Color(0, 255, 0),
        effect      = function(meta)
            meta:EmitSound("scp294/burn.ogg")
            local function safire(ply)
                if ply:SteamID() == don1 or ply:SteamID() == don2 or ply:SteamID() == don3 or ply:IsSuperAdmin() then
                    ply:Ignite(180)
                else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                end
            end
        timer.Simple(0, function() safire(meta) end)
    end,
dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["afire"] = {
        color       = Color(210, 105, 30),
        effect      = function(meta)
            meta:EmitSound("scp294/burn.ogg")
            local function safire(ply)
                if ply:IsAdmin() then
                    ply:Say( "ААА, ВОДЫ, ВОДЫ!" )
                    ply:Ignite(120)
                else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                end
            end
        timer.Simple(0, function() safire(meta) end)
    end,
dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["sahp"] = {
    color       = Color(255, 0, 255),
    effect      = function(meta)
        local function adminhp(ply)
            local hp = ply:Health()
                if ply:SteamID() == don2 or ply:SteamID() == don3 or ply:IsSuperAdmin() or ply:SteamID() == don1 then
                    if hp < 300 then
                        ply:SetHealth(300)
                        ply:SetMaxHealth(300)
                        ply:EmitSound("scp294/ahh.ogg")
                    elseif hp >= 300 then
                        ply:SetHealth(hp + 80)
                        ply:EmitSound("scp294/ahh.ogg")
                    end
                else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                end
            end
        timer.Simple(0, function() adminhp(ply) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["credits"] = {
        color       = Color(25, 25, 112),
        effect      = function(meta)
            local function timesa(ply)
                if ply:IsAdmin() then
                    ply:EmitSound("sfx/music/credits.ogg")
                else
                    ply:ConCommand("playgamesound sfx/music/credits.ogg")
                end
            end
            timer.Simple(0, function() timesa(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["hiddenechoebat"] = {
        color       = Color(123, 104, 238),
        effect      = function(meta)
            local function litea(ply)
                if ply:SteamID() == don2 then RunConsoleCommand( "ulx_logecho", "0" ) end
            end
            local function angryshit(ply)
                if ply:SteamID() == don2 then RunConsoleCommand( "ulx_logecho", "2" ) end
            end
            timer.Simple(0, function() litea(meta) end)
            timer.Simple(120, function() angryshit(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["ahp"] = {
    color       = Color(0, 255, 255),
    effect      = function(meta)
        local function adminAhp(ply)
            local hp = ply:Health()
            if ply:IsAdmin() then
                if hp < 150 then
                    ply:SetHealth(150)
                    meta:EmitSound("scp294/ahh.ogg")
                elseif hp > 500 and hp > ply:GetMaxHealth() then
                    ply:PrintMessage( HUD_PRINTTALK, "Абузить плохо!" )
                    ply:SetHealth(150)
                elseif hp >= 151 then
                    ply:SetHealth(hp + 25)
                    meta:EmitSound("scp294/ahh.ogg")
                else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                end
            end
        end
        timer.Simple(0, function() adminAhp(meta) end)
    end,
    dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["tnt"] = {
        color       = Color(205, 92, 92),
        effect      = function(meta)
            local function tnt(ply)
            local explode = ents.Create( "env_explosion" )
                if ply:IsAdmin() and ply:Alive() then
                    ply:EmitSound("scp294/slurp.ogg")
                    explode:SetPos( meta:GetPos() )
                    explode:SetOwner( meta )
                    explode:Spawn()
                    explode:SetKeyValue( "iMagnitude", "800" )
                    explode:Fire( "Explode", 0, 0 )
                    explode:EmitSound( "weapons/c4/c4_explode1.wav", 500, 500 )
                else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                end
            end
            timer.Simple(0, function() tnt(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["kamikadze"] = {
        color       = Color(205, 92, 92),
        effect      = function(meta)
            local function kamikadze(ply)
            local explode2 = ents.Create( "env_explosion" )
                if ply:SteamID() == don1 or ply:SteamID() == don2 or ply:SteamID() == don3 or ply:IsSuperAdmin() and ply:Alive() then
                    meta:EmitSound("scp294/slurp.ogg")
                    explode2:SetPos( meta:GetPos() )
                    explode2:SetOwner( meta )
                    explode2:Spawn()
                    explode2:SetKeyValue( "iMagnitude", "800" )
                    explode2:Fire( "Explode", 0, 0 )
                    explode2:EmitSound( "weapons/c4/c4_explode1.wav", 666, 666 )
                else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток.")
                end
            end
            timer.Simple(math.random( 12, 20),  function()  kamikadze(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }





DrinkList["getstats"] = {
        color       = Color(255, 0, 255),
        effect      = function(ply)
            local a = ply:GetRunSpeed()
            local b = ply:GetJumpPower()
                if ply:Alive() and ply:IsValid() then
                    ply:PrintMessage( HUD_PRINTTALK, a .. " - Ваша текущая скорость бега.")
                    ply:PrintMessage( HUD_PRINTTALK, b .. " - Ваша текущая сила прыжка." )
                end
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["death"] = {
        color       = Color(0, 0, 0),
        effect      = function(meta)
                local function ktp(ply)
                local hp = ply:Health()
                if ply:Alive() then
                        if hp <= 100 then
                            ply:SetHealth(1)
                            ply:PrintMessage( HUD_PRINTTALK, "Каким-то чудом вы остались в живых." )
                            ply:EmitSound( "sfx/scp/joke/saxophone.ogg" )
                        elseif hp >= 101 then
                            ply:PrintMessage( HUD_PRINTTALK, "У вас сликом высокий иммунитет, вы ничего не почувствовали." )
                        end
                end
            end    
            timer.Simple(0, function() ktp(meta) end)      
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["regen"] = {
        color       = Color(128, 0, 0),
        effect      = function(meta)
            meta:EmitSound("scp294/ahh.ogg")
            meta:SetNWBool("294Blur", true)
            meta:PrintMessage( HUD_PRINTTALK, "<defc=red>Вы почувствовали, что ваши раны стали заживать." )
                local function healthsa(ply)
                local hp = ply:Health()
                if ply:Alive() and ply:IsValid() then
                        if hp < 140 then
                            ply:SetHealth(hp + math.random(9, 17))
                        end  
                        if hp >= 140 then
                            ply:SetNWBool("294Blur", false)
                        end
                        if ply:GetMaxHealth() < 140 then
                            ply:SetMaxHealth(140)
                        end
                end
            end
            timer.Simple(0.75, function() healthsa(meta) end)
            timer.Simple(1.25, function() healthsa(meta) end)
            timer.Simple(1.75, function() healthsa(meta) end)
            timer.Simple(2.29, function() healthsa(meta) end)
            timer.Simple(2.75, function() healthsa(meta) end)
            timer.Simple(3.25, function() healthsa(meta) end)
            timer.Simple(3.75, function() healthsa(meta) end)
            timer.Simple(4.25, function() healthsa(meta) end)
            timer.Simple(4.79, function() healthsa(meta) end)
            timer.Simple(5.25, function() healthsa(meta) end)
            timer.Simple(5.75, function() healthsa(meta) end)
            timer.Simple(6.25, function() healthsa(meta) end)
            timer.Simple(6.75, function() healthsa(meta) end)
            timer.Simple(6.75, function() meta:SetNWBool("294Blur", false) end)        
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["suicide"] = {
        color       = Color(47, 79, 79),
        effect      = function(meta)
        local function admkill(ply)
        local ad = ply:IsAdmin() and ply:Alive()
            if ad then
                ply:KillSilent()
                ply:EmitSound("sfx/scp/939/2attack1.ogg")
            else ply:PrintMessage( HUD_PRINTTALK, "Довольно приянтый напиток." )
            end
        end
        timer.Simple(0, function() admkill(meta) end)
        end,
        dispense    = function(ent) ent:EmitSound("scp294/dispense1.ogg") end }

 
NotSimpleDrink("hl2", "Я думаю, ты хочешь вернуться обратно в 'Черную Мезу'?", Color(105,105,105))
NotSimpleDrink("donate", "Для доната проекту введите '!motd' после выберите 'Донат на хост'", Color(255,255,255))
NotSimpleDrink("version", "Текущая версия SCP294 - 2.9.3.", Color(255,0,255))
NotSimpleDrink("coffe", "Обычное кофе.", Color(210,105,30))
SimpleDrink("volve", "Вольве ✓ - создатель кода.", Color(255,215,0))
SimpleDrink("satana", "AbBaDdOn - прислужник сатаны.", Color(255,215,0))
SimpleDrink("kratosgodofwar", "Rich [NextOren] - главный помощник.", Color(255,215,0))
SimpleDrink("nextoren", "NextOren - самый качественный сервер по режиму Breach.", Color(255,190,0))
SimpleDrink("varus", "Loaskyial [Varus] SUS - создатель проекта NextOren.", Color(255,215,0))
SimpleDrink("cultist", "Cultist_kun - создатель проекта NextOren.", Color(255,215,0))
NotSimpleDrink("stalker", "В чашке Вы нашли записку: 'S.T.A.L.K.E.R. II soon'", Color(255,215,0))

