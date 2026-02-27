--[[
lua/entities/buzzer_scpnuke/cl_init.lua
--]]
include('shared.lua')

function ENT:Draw()

//Actually draw the model
self.Entity:DrawModel()

//Draw tooltip with networked information if close to view
local squad = self:GetNetworkedString( 12 )
if ( LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 120 ) then

end
end

language.Add( 'Buzzer_SCPNuke', 'Alpha Warheads Activator' )

sound.Add( {
	name = "ScpNuke",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = { 100, 100 },
	sound = "scp_sounds_new/goc_warhead.mp3"
} )

sound.Add( {
	name = "ScpNukeCancel",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = { 100, 100 },
	sound = "scp_sounds_new/goc_nuke_cancel.mp3"
} )
if CLIENT then
    --net.Receive("ClientMsgs", function()
        --chat.AddText(Color(200, 50, 50), "[ВНИМАНИЕ!] ", Color(255, 255, 255), "ВСЕЙ ОХРАНЕ! НЕМЕДЛЕННО ОТКЛЮЧИТЬ БОЕГОЛОВКУ!")
    --end)
	net.Receive('GOCNukeTimer', function()
		RXSENDWarning("ВНИМАНИЕ! ВСЕЙ ОХРАНЕ! НЕМЕДЛЕННО ОТКЛЮЧИТЬ БОЕГОЛОВКУ!")
	    timer.Create('ThisIsTheTimer',107.5,1,function()end)

	    hook.Add('HUDPaint','Nuketimer',function()
		--local eyepos = LocalPlayer():GetEyeTrace()


                --local glow = math.abs(math.sin(CurTime() * 2) * 255);
	            if GetGlobalBool("GOCNuke") == true then
	            if !timer.Exists("ThisIsTheTimer") then return end
		        local timeiconnuke = Material("nukeadd.png")
	            local timecolor = Color(255,255,255,230)
                local NukeTimeLeft = tostring( math.ceil(timer.TimeLeft( "ThisIsTheTimer" )) )
				if tonumber( math.ceil(timer.TimeLeft( "ThisIsTheTimer" )) ) <= 20 then
				    Color(255, 0, 0, 230)
				end
	            draw.RoundedBox(0, ScrW()-50, ScrH()-100, 40, 40, Color(0, 0, 0));
                draw.RoundedBox(0, ScrW()-150, ScrH()-100, 95, 40, Color(0, 0, 0, 215))
	            surface.SetDrawColor(255, 255, 255);
	            surface.SetMaterial(timeiconnuke);
                surface.DrawTexturedRect(ScrW()-46, ScrH()-96, 32, 32);
	            surface.SetDrawColor(255, 255, 255, 75);
                surface.DrawOutlinedRect(ScrW()-50, ScrH()-100, 40, 40);
                surface.DrawOutlinedRect(ScrW()-150, ScrH()-100, 95, 40);
	            --local endtime = CurTime() + 50
	            --local displaytime = math.ceil(CurTime() + 50 - CurTime())
	            draw.SimpleText(NukeTimeLeft, "Trebuchet24", ScrW()-57-91/2, ScrH()-80, timecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

				end


	    end)
        print("wow")
    end)
	net.Receive('GOCNukeTimerstop', function()
	    hook.Remove('HUDPaint', 'Nuketimer')
	    timer.Remove('ThisIsTheTimer')
	    LocalPlayer():StopSound("ScpNuke")
	    LocalPlayer():StopSound("scp_sounds_new/goc_warhead.mp3")

	    print("disable")

    end)

end


