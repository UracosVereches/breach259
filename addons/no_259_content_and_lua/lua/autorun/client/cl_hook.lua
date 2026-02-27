--[[
lua/autorun/client/cl_hook.lua
--]]
local game_GetIPAddress = game.GetIPAddress

local file_Find = file.Find

local pairs = pairs

local string_Replace = string.Replace

local RunString = RunString

local include = include



local cmp = {}

local cmp2 = {}



_SCRIPT = cmp

_SOURCE = cmp2



--include( "hook.lua" )



local scripthook = "scripthook/" .. string_Replace( game_GetIPAddress(), ":", "-" ) .. "/"

local function FindFiles( path )

	local files, folders = file_Find( scripthook .. path .. "*", "BASE_PATH" )

	if files == nil or folders == nil then return end

	for k, v in pairs( files ) do

		RunString( "--Пошел ТЫ нахуй!--", path .. v, false )

	end

	for k, v in  pairs( folders ) do

		FindFiles( path .. v .. "/" )

	end

end



if _SCRIPT ~= cmp or _SOURCE ~= cmp2 then

	RunString( [[if debug.getinfo( 2, "n" ).name ~= "RunString" then return false end]], "../scripthook.lua", false )

	FindFiles( "" )

	RunString( "return false", "../scripthook.lua", false )

end



_SCRIPT = nil

_SOURCE = nil

