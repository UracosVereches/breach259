--[[
lua/autorun/intercom.lua
--]]
-------------------------------------------
---------------|PRECACHE IT|---------------
-------------------------------------------

sound.Add({
	name 		= "SEFF_INTERCOM",
	channel 	= CHAN_STATIC,
	volume		= 1.0,
	level		= 75,
	pitch		= {95, 105},
	sound		= {"nextoren_intercom/ground.wav"}
});

util.PrecacheSound("nextoren_intercom/ground.wav");

if CLIENT then
	hook.Add("PlayerStartVoice", "IntercomPSV", function(Player)
	    if LocalPlayer():GTeam() == TEAM_GUARD then 
            LocalPlayer():EmitSound("sfx/Radio/squelch.ogg");
		end
	end);

	hook.Add("PlayerEndVoice", "IntercomPEV", function(Player)
		LocalPlayer():StopSound("SEFF_INTERCOM");
	end);
end

