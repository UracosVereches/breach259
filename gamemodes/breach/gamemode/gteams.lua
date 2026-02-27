--[[
gamemodes/breach/gamemode/gteams.lua
--]]


gteams = {}

gteams.Teams = {}



function gteams.SetUp(index, name, color)

	if isnumber(index) and isstring(name) and IsColor(color) then

		table.ForceInsert(gteams.Teams, {

			index = index,

			name = name,

			color = color,

			points

		})

	else

		ErrorNoHalt( "GTEAMS [ERROR] tried to setup invalid team!" )

		print(debug.traceback())

	end

end



function gteams.GetColor(input)

	if isnumber(input) then

		for k,v in pairs(gteams.Teams) do

			if v.index == input then

				return v.color

			end

		end

	elseif isstring(input) then

		for k,v in pairs(gteams.Teams) do

			if v.name == input then

				return v.color

			end

		end

	elseif IsColor(input) then

		for k,v in pairs(gteams.Teams) do

			if v.color == input then

				return v.color

			end

		end

	end

end



function gteams.GetScore(input)

	if isnumber(input) then

		for k,v in pairs(gteams.Teams) do

			if v.index == input then

				return v.points

			end

		end

	elseif isstring(input) then

		for k,v in pairs(gteams.Teams) do

			if v.name == input then

				return v.points

			end

		end

	elseif IsColor(input) then

		for k,v in pairs(gteams.Teams) do

			if v.color == input then

				return v.points

			end

		end

	end

end



function gteams.SetScore(input, amount)

	if isnumber(input) then

		for k,v in pairs(gteams.Teams) do

			if v.index == input then

				v.points = amount

				return

			end

		end

	elseif isstring(input) then

		for k,v in pairs(gteams.Teams) do

			if v.name == input then

				v.points = amount

				return

			end

		end

	elseif IsColor(input) then

		for k,v in pairs(gteams.Teams) do

			if v.color == input then

				v.points = amount

				return

			end

		end

	end

end



function gteams.AddScore(input, amount)

	if isnumber(input) then

		for k,v in pairs(gteams.Teams) do

			if v.index == input then

				v.points = v.points + amount

				return

			end

		end

	elseif isstring(input) then

		for k,v in pairs(gteams.Teams) do

			if v.name == input then

				v.points = v.points + amount

				return

			end

		end

	elseif IsColor(input) then

		for k,v in pairs(gteams.Teams) do

			if v.color == input then

				v.points = v.points + amount

				return

			end

		end

	end

end



function gteams.Valid(input)

	if isnumber(input) then

		for k,v in pairs(gteams.Teams) do

			if v.index == input then

				return true

			end

		end

	elseif isstring(input) then

		for k,v in pairs(gteams.Teams) do

			if v.name == input then

				return true

			end

		end

	elseif IsColor(input) then

		for k,v in pairs(gteams.Teams) do

			if v.color == input then

				return true

			end

		end

	end

	return false

end



local mply = FindMetaTable( "Player" )



function mply:GTeam()

    if !IsValid(self) then return TEAM_SPEC end

    if not self.GetNGTeam then

        player_manager.RunClass( self, "SetupDataTables" )

    end

    if not self.GetNGTeam then return TEAM_SPEC end

    return self:GetNGTeam()

end



function mply:GetGTeam()

    return self:GTeam()

end



function mply:SetGTeam(input)

local GTeam_before = self:GTeam()

local NClass_before = self:GetNClass()

	if not self.SetNGTeam then

		player_manager.RunClass( self, "SetupDataTables" )

	end

	if isnumber(input) then

		for k,v in pairs(gteams.Teams) do

			if v.index == input then

				//if self.SetNGTeam

				self:SetNGTeam(v.index)

				hook.Call("PlayerChangedTeam", nil, self, GTeam_before, self:GTeam(), self.BeforeRole, self:GetNClass())

				return

			end

		end

	elseif isstring(input) then

		for k,v in pairs(gteams.Teams) do

			if v.name == input then

				self:SetNGTeam(v.index)

				hook.Call("PlayerChangedTeam", nil, self, GTeam_before, self:GTeam(), self.BeforeRole, self:GetNClass())

				return

			end

		end

	elseif IsColor(input) then

		for k,v in pairs(gteams.Teams) do

			if v.color == input then

				self:SetNGTeam(v.index)

				hook.Call("PlayerChangedTeam", nil, self, GTeam_before, self:GTeam(), self.BeforeRole, self:GetNClass())

				return

			end

		end

	end

	ErrorNoHalt( "GTEAMS [ERROR] Tried to set an invalid team!" )

	print(debug.traceback())

end



function gteams.CheckTeams()

	print("GTEAMS: List")

	for k,v in pairs(gteams.Teams) do

		print(k .. " - " .. v.name .. "  index: " .. v.index .. "  color: rgb(" .. v.color.r .. "," .. v.color.g .. "," .. v.color.b .. ")")

	end

end



function gteams.CheckPlayers()

	print("GTEAMS: Players")

	for k,v in pairs(player.GetAll()) do

		local tname = v:GTeam()

		print(v:Nick() .. " - " .. tostring(tname))

	end

end



function gteams.GetPlayers( input )

	local tab = {}

	if isnumber(input) then

		for k,v in pairs(player.GetAll()) do

			if v:GTeam() == input then

				table.ForceInsert(tab, v)

			end

		end

	else

		ErrorNoHalt( "GTEAMS [ERROR] Tried to get list of players not using an index!" )

		print(debug.traceback())

	end

	return tab

end



function gteams.NumPlayers( input )

	local tab = {}

	if isnumber(input) then

		for k,v in pairs(player.GetAll()) do

			if v:GTeam() == input then

				table.ForceInsert(tab, v)

			end

		end

	else

		ErrorNoHalt( "GTEAMS [ERROR] Tried to get number of players not using an index!" )

		print(debug.traceback())

	end

	return #tab

end



gteams.SetUp( 0, "Not Set", Color(255,255,255) )

gteams.SetUp( TEAM_SCP, "SCPs", Color(237, 28, 63) )

gteams.SetUp( TEAM_SPECIAL, "Specials", Color(238, 130, 238) )

gteams.SetUp( TEAM_GUARD, "MTF Guards", Color(0, 100, 255) )

gteams.SetUp( TEAM_CLASSD, "Class Ds", Color(255, 130, 0) )

gteams.SetUp( TEAM_SPEC, "Spectators", Color(141, 186, 160) )

gteams.SetUp( TEAM_SCI, "Scientists", Color(66, 188, 244) )

gteams.SetUp( TEAM_CHAOS, "Chaos Insurgency", Color(29, 81, 56) )

gteams.SetUp( TEAM_GOC, "Global Ocult Coalition", Color(178, 34, 34) )

gteams.SetUp( TEAM_USA, "USA", Color(0, 0, 0) )

gteams.SetUp( TEAM_DZ, "Dlan Zmei", Color(46, 139, 87) )

gteams.SetUp( TEAM_NTF, "Nine Tailed Foxes", Color(0, 0, 255) )

gteams.SetUp( TEAM_USSR, "Red Army", Color(255, 0, 0))

gteams.SetUp( TEAM_NAZI, "Nazi", Color(90, 90, 90))