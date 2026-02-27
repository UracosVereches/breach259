--[[
lua/autorun/xenomorph_killscene.lua
--]]
list.Set( 'NPC', 'npc_isolation_xeno', {
	Name = 'Xenomorph',
	Class = 'npc_isolation_xeno',
	Category = 'Alien: Isolation'
} )

if SERVER then
	util.AddNetworkString( 'XENOMORPH_START_KILLSCENE' )


	return
end

local XenoKillScene = false
local XenoKillScene_Length = 0
local XenoKillScene_Xeno = NULL
local WeaponViewAngles = Angle()

language.Add( 'npc_isolation_xeno', 'Xenomorph' )

killicon.Add( 'npc_isolation_xeno', 'hud/xenomorph_killicon', Color( 200, 50, 50 ) )

net.Receive( 'XENOMORPH_START_KILLSCENE', function()
	local ent, duration, state = net.ReadEntity(), net.ReadFloat()
	XenoKillScene = true
	XenoKillScene_Xeno = ent
	XenoKillScene_Length = CurTime() + duration
end )

local function CreateLight( pos, color )
	local dlight = DynamicLight( LocalPlayer():EntIndex() )
	if ( dlight ) then
		dlight.pos = pos
		dlight.r = color.r
		dlight.g = color.g
		dlight.b = color.b
		dlight.brightness = color.a
		dlight.Decay = 1000
		dlight.Size = 82
		dlight.DieTime = CurTime() + 0.5
	end
end

hook.Add( 'StartCommand', 'LockPlayerControlInKillscenes', function( ply, cmd )
	if XenoKillScene then
		cmd:RemoveKey( IN_ATTACK )
		cmd:RemoveKey( IN_ATTACK2 )
		cmd:RemoveKey( IN_RELOAD )
	end
end )

hook.Add( 'CalcView', 'XenoKillScene', function( ply, pos, ang, fov, nearZ, farZ )
	if ( ply ) then return end
	if !IsValid( ply ) || !ply:Alive() then
		XenoKillScene = false
		return nil
	end

	local xeno = XenoKillScene_Xeno

	local view = {}

	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.znear = nearZ
	view.zfar = farZ

	if IsValid( xeno ) and XenoKillScene and ply:Alive() and ply == ply:GetViewEntity() then
		if XenoKillScene_Length < CurTime() then
		   -- print("nah, nah")
			XenoKillScene = false
			return
		end

		local eye = xeno:GetAttachment( 1 )
		if eye then
			local transformedAng = Angle( math.Clamp( ang.p / 2, -5, 5 ), math.Clamp( ang.y / 2, -5, 5 ), math.Clamp( ang.r / 2, -5, 5 ) )

			view.origin = eye.Pos

			view.angles = eye.Ang

			WeaponViewAngles = view.angles

			view.fov = 65
			CreateLight( eye.Pos, Color( 255, 255, 255, 0.1 ) )

			return view
		else
			return nil
		end
	elseif !IsValid( xeno ) then
		XenoKillScene = false
	else
		return nil
	end

	return nil
end )


hook.Add( 'CalcViewModelView', 'XenoKillSceneWeapon', function( wep, vm, oldPos, oldAng, pos, ang )
	if XenoKillScene and LocalPlayer():GetNWBool( 'IsInsideLocker' ) and IsValid( wep ) and wep:GetClass() == 'weapon_ai_scanner' then
		pos = oldPos + WeaponViewAngles:Forward() * 8
		ang = WeaponViewAngles
	elseif XenoKillScene and ( !LocalPlayer():GetNWBool( 'IsInsideLocker' ) or IsValid( wep ) and wep:GetClass() != 'weapon_ai_scanner' ) then
		pos = oldPos - WeaponViewAngles:Forward() * 100
	else
		return nil
	end

	return pos, ang
end )


