local ThirdPersonDistance = 155

net.Receive("GHOSTPOKESHADOWCLAW",function(len,pl)
	local toggle = net.ReadBool()
	local ply = net.ReadEntity()

	if IsValid(ply) then
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) then
			if toggle then
				wep.ShadowClawEnabled = true
				wep.ShowViewModel = true
				wep.UseHands = true
				wep.UsingMelee = true
				local speed = GetConVarNumber("sv_defaultdeployspeed")
				local vm = wep.Owner:GetViewModel()
				vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
				vm:SetPlaybackRate(speed)
				wep:UpdateNextIdle()
			else
				timer.Remove("GHOSTPOKESHADOWCLAW"..ply:SteamID())
				wep.ShowViewModel = false
				wep.UseHands = false
				wep.UsingMelee = false
				wep.ShadowClawEnabled = false
			end
		end
	end
end)

LocalPlayer().POKE_Confused = false
local function RemoveConfusion(ply)
	ply.POKE_Confused = false
end
local function ConfusionTimer(ply,time)
	local timerid = "GHOSTPOKECONFUSION"..ply:SteamID()
	if timer.Exists(timerid) then
		timer.Remove(timerid)
	end
	timer.Create(timerid,time,1,function()
		if IsValid(ply) then
			RemoveConfusion(ply)
		end
	end)
end
local function Confusion(ply,time)
	ConfusionTimer(ply,time)
	ply.POKE_Confused = true
end
net.Receive("GHOSTPOKECONFUSESTOP",function(len,pl)
	local ply = net.ReadEntity()
	if IsValid(ply) then
		RemoveConfusion(ply)
	end		
end)
net.Receive("GHOSTPOKECONFUSE",function(len,pl)
	local ply = net.ReadEntity()
	local time = net.ReadInt(32)
	if IsValid(ply) && !ply.POKE_Confused then
		Confusion(ply,time)
	end
end)
local function GHOSTPOKEScreenFX()
	if LocalPlayer().POKE_Confused == true then
		DrawMotionBlur( 0.2, 0.8, 0.01 )
	end
end
hook.Add("RenderScreenspaceEffects","GHOSTPOKESCREENFX",GHOSTPOKEScreenFX)

local function PhantomForceTP(ply,pos,angles,fov)
	if LocalPlayer().GhostPokeThirdPerson == true then
		local tr = util.TraceLine({
			start = pos,
			endpos = pos + angles:Forward() * -ThirdPersonDistance,
		})
		local dist = pos:Distance(tr.HitPos)
		local view = {}
		view.origin = pos-(angles:Forward()*dist)
		view.angles = angles
		view.fov = fov
		view.drawviewer = true
		return view
	end
end
hook.Add("CalcView","PHANTOMFORCETPHOOK",PhantomForceTP)

local function POKE_RemovePlayerDecals(ply)
	if IsValid(ply) then ply:RemoveAllDecals() end
end

net.Receive("GHOSTPOKEMIRRORCOAT",function(len,ply)
	local player = net.ReadEntity()
	local tog = net.ReadBool()
	if IsValid(player) then
		POKE_RemovePlayerDecals(player)
		if tog == true then
			player:SetColor(Color(255,155,225,255))
		else
			player:SetColor(Color(255,255,255,255))
		end
	end
end)

net.Receive("GHOSTPOKESENDTP",function(len,ply)
	local player = net.ReadEntity()
	local tp = net.ReadBool()
	if IsValid(player) then
		player.GhostPokeThirdPerson = tp
		if IsValid(player:GetActiveWeapon()) then
			player:GetActiveWeapon().PhantomForceEnabled = tp
		end
		POKE_RemovePlayerDecals(player)
		if tp == true then
			player:SetColor(Color(0,0,0,0))
			player:DrawShadow(false)
		else
			player:SetColor(Color(255,255,255,255))
			player:DrawShadow(true)
		end
	end
end)

net.Receive("GHOSTPOKEEFFECT",function(len,ply)
	local pos = net.ReadVector()
	local effect = net.ReadString()
	local scale = net.ReadInt(32)
	local normal = net.ReadVector()
	local player = net.ReadEntity()
	local fx = EffectData()
	fx:SetOrigin(pos)
	fx:SetScale(scale)
	fx:SetNormal(normal)
	if IsValid(player) then
		fx:SetEntity(player)
	end
	util.Effect(effect,fx)
end)

net.Receive("GHOSTPOKELASER",function(len,ply)
	local startpos = net.ReadVector()
	local endpos = net.ReadVector()
	local effect = net.ReadString()
	local fx = EffectData()
	fx:SetStart(startpos)
	fx:SetOrigin(endpos)
	util.Effect(effect,fx)
end)

hook.Add("PlayerFootstep","GHOSTPOKEFOOTSTEP",function(ply)
	if IsValid(ply:GetActiveWeapon()) then
		if ply:GetActiveWeapon().PhantomForceEnabled then
			return true
		end
	end
end)