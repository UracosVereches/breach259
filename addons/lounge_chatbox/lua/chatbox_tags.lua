--[[
addons/lua_crap/lua/chatbox_tags.lua
--]]
/**

* Tags configuration

* This is not a dedicated tags add-on, there are probably better add-ons out there for tags.

**/



-- Tag to display for a dead player's message in the CHAT

-- You can use parsers here.

LOUNGE_CHAT.TagDead = "<color=255,0,0>*МЕРТВ*</color> "



-- Tag to display for a player's team message in the CHAT

-- The color preceding this will be the player's team color.

-- You can use parsers here.

LOUNGE_CHAT.TagTeam = ""







-- Tag to display for a dead player's message in the CONSOLE

-- You can't put parsers in there. What you can do is use a table for different text/colors.

LOUNGE_CHAT.TagDeadConsole = {Color(255, 0, 0), "*МЕРТВ* "}



-- Tag to display for a player's team message in the CONSOLE

-- The color preceding this will be the player's team color.

-- You can't put parsers in there. What you can do is use a table for different text/colors.

LOUNGE_CHAT.TagTeamConsole = {""}



/**

* Name Color configuration

*/



-- Here you can set up custom name colors for specific usergroups.

-- By default the name color is the player's team color.

LOUNGE_CHAT.CustomColorsGroups = {

	--["HeadAdmin"] = Color(139, 0, 0),

	--["admin"] = Color(0, 0, 255),

	--["superadmin"] = Color(0, 100, 0),

	--["premium"] = Color(255, 102, 0)

}



-- Here you can set up custom name colors for specific players.

-- This takes priority over the usergroup custom color.

-- By default the name color is the player's team color.

LOUNGE_CHAT.CustomColorsPlayers = {

	["76561198258539109"] = Color(255, 153, 51), --коала

	["76561198047316951"] = Color(255, 153, 51), --кувалда

	["76561197987190249"] = Color(0, 255, 255),

	["76561198019442318"] = Color(0, 255, 255),

	["76561198286190382"] = Color(0, 255, 255),

	["76561198049524525"] = Color(0, 255, 255)

}



/**

* Team Tags configuration

*/



-- Set to true to display the player's team name before their name.

LOUNGE_CHAT.TeamTags = false



-- Set to 1 to change the team tag's case to uppercase.

-- Set to -1 to change it to lowercase.

LOUNGE_CHAT.TeamTagsCase = 1



-- (Advanced) String format of the team tag. Leave it alone if you don't know what this does.

LOUNGE_CHAT.TeamTagsFormat = "[%s]"



/**

* DayZ Tags configuration

* Because the generic DayZ gamemode for sale on gmodstore is terribly coded in general,

* we have to discard its tag system and use our own instead.

* Don't touch this if you don't know what this does.

**/



local ooc = {

	tagcolor = Color(100, 100, 100),

	tag = "[OOC] ",

}



LOUNGE_CHAT.DayZ_ChatTags = {

	["!"] = {

		["ooc"] = ooc,

		["g"] = ooc,

		["y"] = ooc,

	},

	["/"] = {

		["ooc"] = ooc,

		["g"] = ooc,

		["y"] = ooc,

		["/"] = ooc,

	},

}





-- Custom Tags configuration

-- If aTags is installed, this won't be used at all.





-- Enable custom tags for specific usergroups/players.

LOUNGE_CHAT.EnableCustomTags = true



-- Here is where you set up custom tags for usergroups.

-- If there's a custom tag for a specific SteamID/SteamID64, it'll take priority over the one here.

-- If you don't want a group to have a custom tag, then don't put it in the table.

-- You can use parsers here.

LOUNGE_CHAT.CustomTagsGroups = {

	["Бета-тестер"] = ":award_star_gold_1: <color=gold>(Бета-Тестер)</color>",

	["admin"] = ":shield: <color=green>(Администратор)</color>",

	["Модератор"] = ":fire: <color=blueviolet>(Модератор)</color>",

	["Admin+"] = ":ruby: <color=cyan>(Бета-Тестер Супер Администратор)</color>",

	["testadmin"] = ":book_open: <color=cadetblue>(Администрация)</color>",

	["superadmin"] = ":calculator_error: <color=red>(Разработчик)</color>",

	["spectator"] = ":rosette: <color=orangered>(Смотритель)</color>",

	["HeadAdmin"] = ":rosette: <flash=orangered,5>(Команда проекта)</flash>",

	["DayZ VIP"] = ":wrench_orange: <flash=violet,5>(Администратор DayZ)</flash>",

	["premium"] = ":medal_gold_1: <color=orange>(Premium)</color>",

}



-- Here is where you set up custom tags for specific players. Accepts SteamIDs and SteamID64s.

-- This takes priority over the usergroup custom tag.

-- You can use parsers here.

LOUNGE_CHAT.CustomTagsPlayers = {

	--[[
	["STEAM_0:1:8039869"] = "<color=aquamarine>(:script: Chatbox author)</color>",

	["76561197976345467"] = "<color=aquamarine>(:script: Chatbox author)</color>",

	["STEAM_0:0:44023333"] = "<flash=darkred,5>(Палач)</flash>",

	["STEAM_0:1:99037473"] = "<flash=darkviolet,5>(۩۞۩)</flash>",

	["STEAM_0:1:119255122"] = "<color=hotpink>(:gun: The Gensta Men :gun:)</color>",

	["STEAM_0:1:439606325"] = "<color=crimson>(:heart:FickKrabbe:heart:)</color>",

	["STEAM_0:1:222589668"] = "<color=aquamarine>(:script: Дракономем)</color>",

	["STEAM_0:0:195587395"] = "<color=violet>(:heart: Мемцинов)</color>",

  ["STEAM_0:0:96713244"] = "<color=violet>(:vcard: Продвинутый Игрок)</color>",

  ["STEAM_0:0:82767333"] = "<color=violet>(:vcard: Продвинутый Игрок)</color>",

	["STEAM_0:0:195017992"] = ":fire:<flash=darkred,5>(✠ŠЭŞ✠)</flash>:fire:",

	["STEAM_0:1:106956197"] = "<flash=hotpink,2>[OverLord]</flash>",

	["STEAM_0:1:26973749"] = "<color=violet>(:vcard: Продвинутый Игрок)</color>",

	["STEAM_0:0:151083265"] = "<color=violet>(:vcard: Продвинутый Игрок)</color>",

	["STEAM_0:1:117017285"] = "<color=aquamarine>(Дань Котика)</color>",

	["STEAM_1:0:72602160"] = "<color=crimson>(:heart: Вольве :heart:)</color>",

	["STEAM_0:0:113611319"] = "<defc=red> (Флюткин :ruby_key:)",

	["76561198105470048"] = "<color=crimson>(:heart: Вольве :heart:)</color>",
	--]]

	--["76561198260487510"] = "<color=crimson>(:heart: ВыебалКраба :heart:)</color>",

	["76561198258539109"] = "<color=crimson>(:wrench_orange:Отряд Кувалдеров:wrench_orange:)</color>",

	["76561198047316951"] = "<color=crimson>(:wrench_orange:Отряд Кувалдеров:wrench_orange:)</color>",

	["76561197987190249"] = "<color=aquamarine>:application_xp_terminal: (NextOren Team)</color>",

	["76561198019442318"] = "<color=aquamarine>:application_xp_terminal: (NextOren Team)</color>",

	["76561198286190382"] = "<color=aquamarine>:application_xp_terminal: (NextOren Team)</color>",

	["76561198049524525"] = "<color=aquamarine>:application_xp_terminal: (NextOren Team)</color>",

	["76561198869328954"] = "<color=gold>:script_edit:</color>",

	["STEAM_0:1:95927294"] = ":calculator_error: <color=red>(Разработчик)</color>",

	["STEAM_0:1:550631403"] = "<color=gold>:script_edit: (out.rar pro)</color>",

	["STEAM_0:1:233420776"] = ":fire: <flash=darkred,5>(Respectable)</flash>"

}



