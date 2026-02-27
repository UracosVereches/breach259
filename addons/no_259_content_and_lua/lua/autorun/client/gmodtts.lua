--[[
lua/autorun/client/gmodtts.lua
--]]
local accents = {
	"http://translate.google.co.uk/translate_tts?tl=en&q=",
	"http://translate.google.com/translate_tts?tl=en&q=",
	"http://translate.google.com/translate_tts?tl=fr&q=",
	"http://translate.google.com/translate_tts?tl=ru&q=",
	"http://tts.peniscorp.com/speak.lua?"
}

local wait = false
local channels = {}
	
local function playvoice(ply,text,accent,speed)
	if wait then
		accent = "http://tts.peniscorp.com/speak.lua?"
	end
	sound.PlayURL(accent..text,"3d noplay",function(channel,errorid,errorname)
		if channel == nil || errorid != nil || errorname != nil then --peniscorp backup; google is upset
			if wait == false then
				wait = true
				timer.Simple(125,function() wait = false end)
				playvoice(ply,text,accent,speed)
			end
			return
		end
		channel:SetPos(ply:GetPos(),Vector(0,0,0))
		channel:Set3DFadeDistance(300,9999999999)
		channel:SetPlaybackRate(math.Clamp(.5+speed,.5,2))
		channel:Play()
		table.insert(channels,{channel,ply})
	end)
end

hook.Add("Think","TTSThink",function()
	for k, v in pairs(channels) do
		if !v[1]:IsValid() then table.remove(channels,k) return end
		if v[2] == nil ||
		v[1]:GetState() != GMOD_CHANNEL_PLAYING ||
		v[1]:GetTime() >= v[1]:GetLength() then
			v[1]:Stop()
			table.remove(channels,k)
			return
		end
		v[1]:SetPos(v[2]:GetPos(),Vector(0,0,0))
	end
end)

hook.Add("OnPlayerChat","TTSPlayerChat",function(ply,text,team,dead)
	--firstly, checking for popular gamemode limitations
	local dotts = true
	if engine.ActiveGamemode() == "terrortown" then
		if dead then dotts = false end
		if ply.IsSpec != nil && ply:IsSpec() then dotts = false end
	end
	if engine.ActiveGamemode() == "darkrp" then
		if text[1] == "/" then dotts = false end
		if ply:GetPos():Distance(LocalPlayer():GetPos()) > 500 then dotts = false end --250 = default chat range
	end
	if dotts then
		local speed,accent,nick = 1, accents[1], ply:Nick()
		local nlen = #nick
		local vowels, vow, notvow, vrat = {"a","e","i","o","u","y"}, 0, 0, 1
		for i = 1, nlen do
			if table.HasValue(vowels,nick[i]) then vow = vow+1 else notvow = notvow+1 end
		end
		if vow == 0 then notvow = nlen end
		vrat = vow/notvow
		accent = accents[math.Clamp(vow,1,#accents)]
		speed = vrat
		playvoice(ply,text,accent,speed)
	end
end)

