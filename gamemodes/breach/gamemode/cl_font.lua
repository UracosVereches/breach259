--[[
gamemodes/breach/gamemode/cl_font.lua
--]]
/*---------------------------------------------------------------------------

	Creator: TheCodingBeast - TheCodingBeast.com
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/

---------------------------------------------------------------------------*/
surface.CreateFont( "AmmoType1",
{
	font = "TargetID",
	size = 60,
	weight = 600,
})

surface.CreateFont( "AmmoType2",
{
	font = "TargetID",
	size = 35,
	weight = 600,
})

surface.CreateFont( "TargetIDWeighted",
{
	font = "Trebuchet24",
	weight = 1000,
	size = 18
})

surface.CreateFont( "TargetIDLarge",
{
	font = "TargetID",
	size = 40,
	weight = 600,
})

surface.CreateFont( "TargetIDMedium",
{
	font = "TargetID",
	size = 20,
	weight = 600,
})

surface.CreateFont( "TargetIDSmall",
{
	font = "TargetID",
	size = 15,
	weight = 400,
})

surface.CreateFont( "ScoreboardHeader",
{
	font = "Trebuchet24",
	weight = 1000,
	size = 35,
	scanlines = 2
})

surface.CreateFont( "ScoreboardHeaderNoLines",
{
	font = "Trebuchet24",
	weight = 1000,
	size = 35,
	scanlines = 0,
})

surface.CreateFont( "SubScoreboardHeader",
{
	font = "Trebuchet24",
	weight = 1000,
	size = 22,
	scanlines = 2
})

surface.CreateFont( "ScoreboardContent",
{
	font = "Trebuchet24",
	weight = 1000,
	size = 16,
})

surface.CreateFont( "Scoreboardtext",
{
	font = "Trebuchet24",
	weight = 1000,
	size = 26,
})

-- Custom Fonts!

surface.CreateFont( "SafeZone_NAME",
{
	font = "Segoe UI Bold",
	size = 40,
	weight = 550,
})

surface.CreateFont( "SafeZone_EXCLAMATION",
{
	font = "Segoe UI Bold",
	size = 143,
	weight = 1000,
})

surface.CreateFont( "SafeZone_INFO",
{
	font = "Segoe UI",
	size = 30,
	weight = 500,
})

surface.CreateFont( "SafeZone_POPUP",
{
	font = "Segoe UI",
	size = 17,
	weight = 600,
})

surface.CreateFont( "SafeZone_POPUPsmall",
{
	font = "Segoe UI",
	size = 17,
	weight = 600,
})


surface.CreateFont( "Cyb_LOGO",
{
	font = "Segoe UI",
	size = 80,
	weight = 1100,
})

surface.CreateFont( "Cyb_HudTEXT",
{
	font = "Segoe UI",
	size = 25,
	weight = 550,
})

surface.CreateFont( "Cyb_HudTEXTSmall",
{
	font = "Segoe UI",
	size = 12,
	weight = 550,
})

surface.CreateFont( "Cyb_Inv_ToolTip",
{
	font = "Segoe UI",
	size = 16,
	weight = 500,
})

surface.CreateFont( "Cyb_Inv_Bar",
{
	font = "Segoe UI",
	size = 18,
	weight = 500,
})
surface.CreateFont( "Cyb_Inv_Label",
{
	font = "Segoe UI",
	size = 14,
	weight = 400,
})

surface.CreateFont( "tab_title", { font = "Segoe UI Bold", size = 32, antialias = true })
surface.CreateFont( "char_title", { font = "Segoe UI Bold", size = 48, antialias = true })
surface.CreateFont( "char_title1", { font = "Segoe UI Bold", size = 40, antialias = true })
surface.CreateFont( "char_options", { font = "Segoe UI Bold", size = 48, antialias = true, shadow = true, outline = true })
surface.CreateFont( "char_options1", { font = "Segoe UI Bold", size = 26, antialias = true, shadow = true, outline = true })
surface.CreateFont( "char_options", { font = "Segoe UI Bold", size = 48, antialias = true, shadow = true, outline = true })
surface.CreateFont( "char_title64", { font = "Segoe UI Bold", size = 64, antialias = true })
surface.CreateFont( "char_title36", { font = "Segoe UI Bold", size = 17, antialias = true })
surface.CreateFont( "char_title24", { font = "Segoe UI Bold", size = 24, antialias = true })
surface.CreateFont( "char_title24a", { font = "Segoe UI Bold", size = 24 })
surface.CreateFont( "shriftah", { font = "Stroke(RUS BY LYAJKA)", size = 25, antialias = true })
surface.CreateFont( "shriftah3", { font = "Stroke(RUS BY LYAJKA)", size = 20, antialias = true })
surface.CreateFont( "shriftah4", { font = "Stroke(RUS BY LYAJKA)", size = 30, antialias = true })
surface.CreateFont( "shriftah2", { font = "Drum", size = 30, antialias = true })
surface.CreateFont( "char_titleescape", { font = "Fast Forward", size = 40, antialias = true })
surface.CreateFont( "char_titleescape2", { font = "Act of Rejection", size = 25, antialias = true })
surface.CreateFont( "char_titleescape4", { font = "Act of Rejection", size = 25, antialias = true })
surface.CreateFont( "char_titleescape3", { font = "Segoe UI", size = 36, weight = 1200, antialias = true })
surface.CreateFont( "char_title20", { font = "Segoe UI Bold", size = 20, antialias = true })
surface.CreateFont( "char_title18", { font = "Segoe UI Bold", size = 18, antialias = true })
surface.CreateFont( "char_title16", { font = "Segoe UI Bold", size = 16, antialias = true })
surface.CreateFont( "char_title14", { font = "Segoe UI Bold", size = 14, antialias = true })
surface.CreateFont( "char_title12", { font = "Segoe UI Bold", size = 12, antialias = true })
surface.CreateFont( "char_title8", { font = "Segoe UI Bold", size = 8, antialias = true })


surface.CreateFont( "HUDFont", {
    font = "Bauhaus",
	size = 18,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont( "HUDFontHead", {
    font = "Bauhaus",
	size = 36,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont( "HUDFonttimer", {
    font = "Bauhaus",
	size = 36,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontLittle", {
    font = "Bauhaus",
	size = 16,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontTitle", {
    font = "Bauhaus",
	size = 25,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = true,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontBig", {
    font = "Bauhaus",
	size = 36,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontMedium", {
    font = "Bauhaus",
	size = 22,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontMediumL", {
    font = "Bauhaus",
	size = 22,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = true,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})


