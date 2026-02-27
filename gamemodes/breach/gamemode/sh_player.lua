--[[
gamemodes/breach/gamemode/sh_player.lua
--]]


local mply = FindMetaTable( "Player" )

function mply:CLevelGlobal()

	local biggest = 1

	for k,wep in pairs(self:GetWeapons()) do

		if IsValid(wep) then

			if wep.clevel then

				if wep.clevel > biggest then

					biggest =  wep.clevel

				end

			end

		end

	end

	return biggest

end



function mply:CLevel()

	local wep = self:GetActiveWeapon()

	if IsValid(wep) then

		if wep.Level then

			return wep.Level
			
		end

	end

	return 0

end



function mply:GetKarma()

	if not self.GetNKarma then

		player_manager.RunClass( self, "SetupDataTables" )

	end

	if not self.GetNKarma then

		return 999

	else

		return self:GetNKarma()

	end

end



function mply:GetExp()

	if not self.GetNEXP then

		player_manager.RunClass( self, "SetupDataTables" )

	end

	if self.GetNEXP and self.SetNEXP then

		return self:GetNEXP()

	else

		ErrorNoHalt( "Cannot get the exp, GetNEXP invalid" )

		return 0

	end

end



function mply:GetLevel()

	if not self.GetNLevel then

		player_manager.RunClass( self, "SetupDataTables" )

	end

	if self.GetNLevel and self.SetNLevel then

		return self:GetNLevel()

	else

		ErrorNoHalt( "Cannot get the exp, GetNLevel invalid" )

		return 0

	end

end

function newstamina( ply )

	if not ply.RunSpeed then ply.RunSpeed = 0 end

	if not ply.lTime then ply.lTime = 0 end

	if !ply.GetRunSpeed then return end

	if ply:GetRunSpeed() == ply:GetWalkSpeed() or GetConVar("br_stamina_enable"):GetInt() == 0 then

		ply.Stamina = 100

	else

		if !ply.Stamina then ply.Stamina = 100 end

		if ply.exhausted then

			if ply.Stamina >= 30 then

				ply.exhausted = false

				ply:SetRunSpeed( ply.RunSpeed )

				ply:SetJumpPower( ply.jumppower )

			end

			if ply.lTime < CurTime() then

				ply.lTime = CurTime() + 0.1

				ply.Stamina = ply.Stamina + sR

			end

		else

			if ply.Stamina <= 0 then

				ply.Stamina = 0

				ply.exhausted = true

				ply.RunSpeed = ply:GetRunSpeed()

				ply.jumppower = ply:GetJumpPower()

				ply:SetRunSpeed( ply:GetWalkSpeed() + 1 )

				ply:SetJumpPower(20)

			end

			if math.abs(data:GetForwardSpeed()) > 0 || math.abs(data:GetSideSpeed()) > 0 then

			if ply.lTime < CurTime() then

				ply.lTime = CurTime() + 0.1

				if ply.sprintEnabled and !( ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_LADDER or ply:GetMoveType() == MOVETYPE_OBSERVER  or ply:InVehicle() ) then

					ply.Stamina = ply.Stamina - 1

				else

				ply.lTime = CurTime() + 0.1

					ply.Stamina = ply.Stamina + sR

				end

				if ply.jumped and !( ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_LADDER or ply:GetMoveType() == MOVETYPE_OBSERVER  or ply:InVehicle() or ply:OnGround() ) then

					ply.Stamina = ply.Stamina - 10



				end

			end

		  end

		end

		if ply.Stamina > 100 then ply.Stamina = 100 end

		if ply.Using714 and ply.Stamina > 30 then ply.Stamina = 30 end

	end

end

function Sprint( ply, mv )

	--if ( IsValid( ply ) && ply:IsSuperAdmin() ) then return end

	if not ply.RunSpeed then ply.RunSpeed = 0 end

	if not ply.lTime then ply.lTime = 0 end

	if !ply.GetRunSpeed then return end

	if ply:GetRunSpeed() == ply:GetWalkSpeed() or GetConVar("br_stamina_enable"):GetInt() == 0 then

		ply.Stamina = 100

	else

		if !ply.Stamina then ply.Stamina = 100 end

		if ply.exhausted then

			if ply.Stamina >= 30 then

				ply.exhausted = false

				ply:SetRunSpeed( ply.RunSpeed )

				ply:SetJumpPower( ply.jumppower )

			end

			if ply.lTime < CurTime() then

				ply.lTime = CurTime() + 0.1

				ply.Stamina = ply.Stamina + 0.3

			end

		else

			if ply.Stamina <= 0 then

				ply.Stamina = 0

				ply.exhausted = true

				ply.RunSpeed = ply:GetRunSpeed()

				ply.jumppower = ply:GetJumpPower()

				ply:SetRunSpeed( ply:GetWalkSpeed() + 1 )

				ply:SetJumpPower(20)

			end

			if ply.lTime < CurTime() then

				ply.lTime = CurTime() + 0.1

				if mv:KeyDown(IN_SPEED) and !( ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_LADDER or ply:GetMoveType() == MOVETYPE_OBSERVER  or ply:InVehicle() ) and ply:GTeam() != TEAM_SCP then

					ply.Stamina = ply.Stamina - 0.4

				else

				ply.lTime = CurTime() + 0.1
					if ply.Stamina != 100 then
						ply.Stamina = ply.Stamina + 0.3
					end

				end

			end

		end

		if mv:KeyPressed(IN_JUMP) and IsFirstTimePredicted() and ply:IsOnGround() and !( ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_LADDER or ply:GetMoveType() == MOVETYPE_OBSERVER  or ply:InVehicle() ) and ply:GTeam() != TEAM_SCP then
			if ply.Stamina < 7 then
				ply.Stamina = 0
			else
				ply.Stamina = ply.Stamina - 7
			end
		end

		if ply.Stamina > 100 then ply.Stamina = 100 end

		if ply.Using714 and ply.Stamina > 30 then ply.Stamina = 30 end

	end

end

hook.Add("SetupMove", "stamina_new", function(ply, mv)
	Sprint(ply, mv)
end)

if CLIENT then

	function mply:DropWeapon( class )

		net.Start( "DropWeapon" )

			net.WriteEntity( class )

		net.SendToServer()

	end



	function mply:SelectWeapon( class )

		if ( !self:HasWeapon( class ) ) then return end

		self.DoWeaponSwitch = self:GetWeapon( class )

	end



	hook.Add( "CreateMove", "WeaponSwitch", function( cmd )

		if !IsValid( LocalPlayer().DoWeaponSwitch ) then return end



		cmd:SelectWeapon( LocalPlayer().DoWeaponSwitch )



		if LocalPlayer():GetActiveWeapon() == LocalPlayer().DoWeaponSwitch then

			LocalPlayer().DoWeaponSwitch = nil

		end

	end )

end

local n = GetConVar("br_stamina_scale"):GetString()

sR = tonumber( string.sub( n, 1, string.find( n, "," ) - 1 ) )

sL = tonumber( string.sub( n, string.find( n, "," ), string.len( n ) ) ) or tonumber( string.sub( n, string.find( n, "," ) + 1, string.len( n ) ) )

--local shietcheck = 1

--local delay = 0

--НАХУЯ ИСПОЛЬЗОВАТЬ СТОРОННИЕ ХУКИ НА НАЖАТИЕ КНОПОК, ЕСЛИ ЭТО МОЖНО ЛЕГКО ПРОВЕРЯТЬ В MOVEDATA???
--[[
hook.Add("KeyPress", "stm_on", function( ply, button )

	if button == IN_SPEED then ply.sprintEnabled = true end

end )



hook.Add("KeyPress", "stmj_on", function( ply, button )

	if button == IN_JUMP then ply.jumped = true end

end )



hook.Add("KeyRelease", "stmj_off", function( ply, button )

	if button == IN_JUMP then ply.jumped = false end

end )



hook.Add("KeyRelease", "stm_off", function( ply, button )

	if button == IN_SPEED then ply.sprintEnabled = false end

end )
--]]

function GM:OnPlayerHitGround( ply, inWater, onFloater, speed )

	local vel = ply:GetVelocity()

	ply:SetVelocity( Vector( -( vel.x / 2 ), -( vel.y / 2 ), 0 ) )

	//return Old_OnPlayerHitGround( self, ply, inWater, onFloater, speed )

end



