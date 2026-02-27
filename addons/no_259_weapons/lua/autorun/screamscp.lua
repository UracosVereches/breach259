--[[
lua/autorun/screamscp.lua
--]]
local jumpscarecooldown = 15


local sound =  "sfx/horror/horror"..math.random(1,16)..".ogg"


local function dock()

    --[[for k,v in pairs(player.GetAll()) do
      if v:GTeam() == TEAM_SCP then
        scpkilla = v
      end
    end]]
    --print(scpkilla)
    local scpkilla = gteams.GetPlayers(TEAM_SCP)[1]
    if !scpkilla then return end
    if !LocalPlayer():Alive() then return end
    if !IsValid(scpkilla) then  return end
    if scpkilla:GetColor().a == 0 then  return end
    --print(killer)
    local shootPos = LocalPlayer():GetShootPos()
    local hisPos = scpkilla:GetShootPos()
    local aimVec = LocalPlayer():GetAimVector()
    local distance = hisPos:DistToSqr(shootPos)

    if distance < 3000000 then

        local pos = hisPos - shootPos
        local unitPos = pos:GetNormalized()
        if unitPos:Dot(aimVec) > 0.80 then

            local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
            if trace.Hit and trace.Entity ~= scpkilla then return end
            if LocalPlayer().lastJumpscare && LocalPlayer().lastJumpscare + 35 > CurTime() then return end
            if LocalPlayer():GTeam() == TEAM_SCP or LocalPlayer():GTeam() == TEAM_SPEC then return end
            if distance <= 100000 then
                -- High
				LocalPlayer():ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 0.1, 0.3 )
                surface.PlaySound("sfx/horror/horror"..math.random(1,16)..".ogg")
				--[[if killer:GetNClass() == ROLES.ROLE_SCP049 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/049/Spotted"..math.random(1,4)..".ogg")
				end
				if killer:GetNClass() == ROLES.ROLE_SCP106 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/106/Spotted"..math.random(1,4)..".ogg")
				end
				if killer:GetNClass() == ROLES.ROLE_SCP173 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/173/Spotted"..math.random(1,3)..".ogg")
				end]]
            elseif distance <= 1000000 then
                -- Mid
				LocalPlayer():ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 0.1, 0.3 )
                surface.PlaySound("sfx/horror/horror"..math.random(1,16)..".ogg")
				--[[if killer:GetNClass() == ROLES.ROLE_SCP049 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/049/Spotted"..math.random(1,4)..".ogg")
				end
				if killer:GetNClass() == ROLES.ROLE_SCP106 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/106/Spotted"..math.random(1,4)..".ogg")
				end
				if killer:GetNClass() == ROLES.ROLE_SCP173 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/173/Spotted"..math.random(1,3)..".ogg")
				end]]
            else
                -- Low
				LocalPlayer():ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 0.1, 0.3 )
                surface.PlaySound("sfx/horror/horror"..math.random(1,16)..".ogg")
				--[[if killer:GetNClass() == ROLES.ROLE_SCP049 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/049/Spotted"..math.random(1,4)..".ogg")
				end
				if killer:GetNClass() == ROLES.ROLE_SCP106 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/106/Spotted"..math.random(1,4)..".ogg")
				end
				if killer:GetNClass() == ROLES.ROLE_SCP173 and LocalPlayer():GTeam() == TEAM_GUARD then
				    LocalPlayer():EmitSound("sfx/character/MTF/173/Spotted"..math.random(1,3)..".ogg")
				end]]
            end

            LocalPlayer().lastJumpscare = CurTime()
        end
    end
end
--hook.Add("Think", "cock", dock)


