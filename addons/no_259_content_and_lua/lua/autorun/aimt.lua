--[[
addons/lua_crap/lua/autorun/aimt.lua
--]]
--[[ Apache License --
	Copyright 2015-2017 Wheatley
	 
	Licensed under the Apache License, Version 2.0 (the 'License'); you may not use this file except
	in compliance with the License. You may obtain a copy of the License at
	 
	http://www.apache.org/licenses/LICENSE-2.0
	 
	Unless required by applicable law or agreed to in writing, software distributed under the License
	is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
	or implied. See the License for the specific language governing permissions and limitations under
	the License.
	 
	The right to upload this project to the Steam Workshop (which is operated by Valve Corporation)
	is reserved by the original copyright holder, regardless of any modifications made to the code,
	resources or related content. The original copyright holder is not affiliated with Valve Corporation
	in any way, nor claims to be so.
]]

local sv_aimt_maxrange = CreateConVar( 'sv_aimt_maxrange', '2000', { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

if SERVER then return end
-- MOTION TRACKER SCREEN RENDERER

local rt = GetRenderTargetEx( '___rtaiscannerscreen', 512, 512, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_NONE, 
	16, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_DEFAULT )
	
local view = render.GetRenderTarget()

local b_t_y = 38 / 256
local b_c_x = 0.5
local b_c_y = 199 / 256

local mat_screen_background 	= Material( 'hud/motiontracker_screen.png' )
local mat_screen_dot 			= Material( 'hud/motiontracker_dot' )
local mat_screen_scanlines		= Material( 'hud/motiontracker_scanlines' )
local mat_screen_glitchovr		= Material( 'hud/motiontracker_diag.png' )

local mat_screen_left 			= Material( 'hud/motiontracker_screen_left.png' )
local mat_screen_right			= Material( 'hud/motiontracker_screen_right.png' )
local mat_screen_bottom			= Material( 'hud/motiontracker_screen_bottom.png' )

local nearestTarget	= 0
local faketargets	= {}

local nextglitch	= 0
local glitchamount	= 0

local deployAnim		= 0
local playDeployAnim	= true

local snd_Noise			= nil
local snd_NoiseActive 	= false
local nextblip			= 0

net.Receive( 'GAMEMODE_MOTIONTRACKER_ADDFAKE', function()
	local start, dest, time = net.ReadVector(), net.ReadVector(), net.ReadFloat()
	table.insert( faketargets, { pos = start, vel = Vector( 0, 0, 500 ), mv = { dst = dest, len = time, perc = 0 }, lt = CurTime() + time } )
end )

local function IsOffRadar( x, y )
	if y < 0 and math.abs( x ) <= -y * 0.8 then
		return 0
	elseif x >= y * 0.65 then
		return 1
	elseif x <= -y * 0.65 then
		return -1
	end
	
	return nil
end

local function DrawDots( w, h, inNest )
	local maxDotSizeX, maxDotSizeY = w / 8, h / 8
	local rndx, rndy = ( ( math.random( -10, 10 ) ) / 10 ) * ( maxDotSizeX / 35 ),
		( ( math.random( -10, 10 ) ) / 10 ) * ( maxDotSizeY / 35 )
	local maxRange = math.max( sv_aimt_maxrange:GetFloat(), 200 )
	
	local targets = {}
	
	local p_pos = LocalPlayer():GetPos()
	local offscreenbits = 0
	
	if inNest then
		for i = 0, 1 do
			local rand = VectorRand()
			rand.z = 0
			table.insert( faketargets, {
				pos = LocalPlayer():EyePos() + rand * math.random( 500, maxRange ),
				vel = Vector( 0, 0, math.random( 300, 600 ) ),
				lt = CurTime() + math.random( 1, 5 ) / 10 } )
		end
	end
	
	for i, v in pairs( ents.FindInSphere( p_pos, maxRange ) ) do
		if v:IsPlayer() and v != LocalPlayer() or v:IsNPC() or ( v.BaseClass and v.BaseClass.Type == 'nextbot' ) then
			if v:GetVelocity():Length() == 0 then continue end
			table.insert( targets, v )
		end
	end
	table.Merge( targets, faketargets )

	surface.SetMaterial( mat_screen_dot )
	for i, v in pairs( targets ) do
		if IsEntity( v ) then
			if !IsValid( v ) then continue end
			local dist = v:GetPos():Distance( p_pos )
			
			if nearestTarget > dist then
				nearestTarget = dist
			end
			
			local perc = math.Clamp( v:GetVelocity():Length() / 300, 0, 1 )
			local range = 1 - math.Clamp( ( dist - ( maxRange - 200 ) ) / 200, 0, 1 )
			local sizerange = math.max( range * perc, 0.75 )
			
			local dotSizeX = maxDotSizeX * sizerange
			local dotSizeY = maxDotSizeY * sizerange

			local pos = ( v:GetPos() - p_pos ) / maxRange
			pos:Rotate( Angle( 0, -LocalPlayer():EyeAngles().y + 90, 0 ) )
			pos.x = pos.x
			pos.y = -pos.y

			local isOffRadar = IsOffRadar( pos.x * 0.80, -pos.y )
			if isOffRadar != nil and perc > 0 then
				if isOffRadar == -1 then
					offscreenbits = bit.bor( offscreenbits, 2 )
				elseif isOffRadar == 0 then
					offscreenbits = bit.bor( offscreenbits, 4 )
				elseif isOffRadar == 1 then
					offscreenbits = bit.bor( offscreenbits, 8 )
				end
			end
			
			surface.SetDrawColor( 255, 255, 255, 255 * range * perc )
			surface.DrawTexturedRect( 
				w * b_c_x - dotSizeX / 2 + rndx + pos.x * w * 0.80,
				h * b_c_y - dotSizeY / 2 + rndy + pos.y * ( h * b_c_y ),
				dotSizeX, 
				dotSizeY )
		elseif istable( v ) then
			if v.lt and v.lt < CurTime() then
				table.RemoveByValue( faketargets, v )
				continue
			end
			
			if v.mv then
				v.mv.start = v.mv.start or v.pos
				local step = ( 1 / v.mv.len ) * RealFrameTime()
				v.mv.perc = math.Approach( v.mv.perc, 1, step )
				v.pos = LerpVector( v.mv.perc, v.mv.start, v.mv.dst )
			end
			
			local dist = v.pos:Distance( p_pos )
			
			if nearestTarget > dist then
				nearestTarget = dist
			end
			
			local perc = math.Clamp( v.vel:Length() / 600, 0, 1 )
			local range = 1 - math.Clamp( ( dist - ( maxRange - 200 ) ) / 200, 0, 1 )
			local sizerange = math.max( range * perc, 0.75 )
			
			local dotSizeX = maxDotSizeX * sizerange
			local dotSizeY = maxDotSizeY * sizerange

			local pos = ( v.pos - p_pos ) / maxRange
			pos:Rotate( Angle( 0, -LocalPlayer():EyeAngles().y + 90, 0 ) )
			pos.x = pos.x
			pos.y = -pos.y

			local isOffRadar = IsOffRadar( pos.x * 0.80, -pos.y )
			if isOffRadar != nil and perc > 0 then
				if isOffRadar == -1 then
					offscreenbits = bit.bor( offscreenbits, 2 )
				elseif isOffRadar == 0 then
					offscreenbits = bit.bor( offscreenbits, 4 )
				elseif isOffRadar == 1 then
					offscreenbits = bit.bor( offscreenbits, 8 )
				end
			end
			
			surface.SetDrawColor( 255, 255, 255, 255 * range * perc )
			surface.DrawTexturedRect( 
				w * b_c_x - dotSizeX / 2 + rndx + pos.x * w * 0.80,
				h * b_c_y - dotSizeY / 2 + rndy + pos.y * ( h * b_c_y ),
				dotSizeX, 
				dotSizeY )
		end
	end
	
	return offscreenbits, targets
end

local function StopNoiseSound()
	if snd_NoiseActive then
		playDeployAnim = true
		snd_Noise:Stop()
		snd_NoiseActive = false
	end
end

function DrawMotionTracker()
	local ply = LocalPlayer()
	if !IsValid( ply ) then StopNoiseSound() return end
	local wep = LocalPlayer():GetActiveWeapon()
	if !IsValid( wep ) || wep:GetClass() != 'weapon_ai_scanner' then StopNoiseSound() return end
	
	if playDeployAnim and deployAnim != 1 then
		deployAnim = math.Approach( deployAnim, 1, RealFrameTime() * 5 )
		if deployAnim == 1 then
			playDeployAnim = false
			deployAnim = 0
		end
	end
	
	local w, h = ScrW(), ScrH()
	
	if playDeployAnim then
		cam.Start2D()
		render.SetRenderTarget( rt )
		render.SetViewPort( 0, 0, 512, 512 )
		render.Clear( 0, 0, 0, 0, true, true )

		if deployAnim < 0.8 then
			surface.SetDrawColor( 0, 0, 0, 255 )
		else
			surface.SetDrawColor( 0, 255, 0, 255 )
		end
		
		surface.DrawRect( 0, 0, w, h )
		
		render.SetRenderTarget( view )
		render.SetViewPort( 0, 0, w, h )
		cam.End2D()
		
		return
	end
	
	if !snd_Noise then
		snd_Noise = CreateSound( LocalPlayer(), 'weapons/motiontracker_noise_loop.wav' )
		snd_Noise:Play()
		snd_NoiseActive = true
		
		snd_NoiseRestart = CurTime() + SoundDuration( 'weapons/motiontracker_noise_loop.wav' )
	end
	
	if !snd_NoiseActive then
		snd_NoiseActive = true
		snd_Noise:Play()
	end
	
	if snd_NoiseRestart <= CurTime() then
		snd_Noise:Stop()
		snd_Noise:Play()
		snd_NoiseRestart = CurTime() + SoundDuration( 'weapons/motiontracker_noise_loop.wav' )
	end

	local inNest = LocalPlayer():GetNWInt( 'WithinNestArea' ) > CurTime()
	nearestTarget = 99999
	
	if inNest and nextglitch <= CurTime() then
		nextglitch = CurTime() + math.random( 5, 8 ) / 10
		glitchamount = math.random( 0, 1 )
	end
	
	glitchamount = math.Approach( glitchamount, 0, RealFrameTime() * 8 )
	
	cam.Start3D()
		local light_pos = Vector( 1, 2.25, -1.2 )
		light_pos:Rotate( LocalPlayer():EyeAngles() )

		local dlight = DynamicLight( LocalPlayer():EntIndex() )
		if ( dlight ) then
			dlight.pos = LocalPlayer():EyePos() + light_pos
			dlight.r = 0
			dlight.g = 255
			dlight.b = 0
			dlight.brightness = 3
			dlight.Decay = 100
			dlight.Size = 20
			dlight.DieTime = CurTime() + 1
		end
	cam.End3D()
	
	cam.Start2D()
	render.SetRenderTarget( rt )
	render.SetViewPort( 0, 0, 512, 512 )
	render.Clear( 0, 0, 0, 0, true, true )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat_screen_background )
	surface.DrawTexturedRect( 0, 0, w, h )
	
	local offRadarBits, targets = DrawDots( w, h, inNest )
	
	local blockerPolyLeft = {
		{ x = 0, y = b_t_y * h, u = 0, v = b_t_y },
		{ x = b_c_x * w, y = b_c_y * h, u = b_c_x, v = b_c_y },
		{ x = 0, y = h, u = 0, v = 1 }
	}
	
	local blockerPolyBottom = {
		{ x = 0, y = h, u = 0, v = 1 },
		{ x = b_c_x * w, y = b_c_y * h, u = b_c_x, v = b_c_y },
		{ x = w, y = h, u = 1, v = 1 }
	}
	
	local blockerPolyRight = {
		{ x = b_c_x * w, y = b_c_y * h, u = b_c_x, v = b_c_y },
		{ x = w, y = b_t_y * h, u = 1, v = b_t_y },
		{ x = w, y = h, u = 1, v = 1 }
	}

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat_screen_background )
	surface.DrawPoly( blockerPolyLeft )
	surface.DrawPoly( blockerPolyBottom )
	surface.DrawPoly( blockerPolyRight )
	
	surface.SetDrawColor( 150, 255, 150, 255 - 200 * ( ( math.sin( CurTime() * 25 ) + 1 ) / 2 ) )
	if bit.band( offRadarBits, 2 ) == 2 then
		surface.SetMaterial( mat_screen_left )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
	
	if bit.band( offRadarBits, 4 ) == 4 then
		surface.SetMaterial( mat_screen_bottom )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
	
	if bit.band( offRadarBits, 8 ) == 8 then
		surface.SetMaterial( mat_screen_right )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
	
	local closestTarget = math.Round( math.Clamp( nearestTarget / math.max( sv_aimt_maxrange:GetFloat(), 200 ), 0, 1 ), 2 )
	if string.len( closestTarget ) <= 1 then
		closestTarget = '1.00'
	elseif string.len( closestTarget ) <= 3 then
		closestTarget = closestTarget .. '0'
	end
	surface.SetTextColor( 39, 190, 38, 255 )
	surface.SetFont( 'AlienIsolation_MTFont' )
	surface.SetTextPos( 55, h - 115 )
	surface.DrawText( closestTarget )
	
	surface.SetDrawColor( 255, 255, 255, 60 )
	surface.SetMaterial( mat_screen_scanlines )
	local uvshift = ( ( CurTime() * 0.05 ) % 1 ) * 0.4
	surface.DrawTexturedRectUV( 0, 0, w, h, 0, uvshift, 0.6, 0.6 + uvshift )

	if #targets != 0 and nextblip <= CurTime() then
		nextblip = CurTime() + 0.20 + 0.5 * closestTarget
		//surface.PlaySound( 'weapons/motiontracker_blep02.wav' )
		sound.Play( 'weapons/motiontracker_blep02.wav',
			LocalPlayer():EyePos(),
			75,
			100 + 5 * ( 1 - closestTarget ),
			1 )
	end
	
	if inNest then
		surface.SetDrawColor( 150, 255, 150, math.random( 25, 100 ) )
		for i = 0, 5 do
			surface.DrawRect( math.random( -w, w ), math.random( 0, h ), math.random( w / 4, w / 2 ), 15 )
		end
	end
	
	if glitchamount > 0 then
		surface.SetDrawColor( 150, 255, 150, 255 * glitchamount )
		surface.SetMaterial( mat_screen_glitchovr )
		surface.DrawTexturedRectUV( 0, 0, w, h, math.random( 0, 10 ) / 50, 0, math.random( 0, 10 ) / 10, 1 )
		for i = 0, 5 do
			surface.DrawRect( math.random( -w, w ), math.random( 0, h ), math.random( w / 4, w / 2 ), 15 )
		end
		
		surface.SetDrawColor( 150, 255, 150, 100 * glitchamount )
		surface.SetMaterial( mat_screen_right )
		surface.DrawTexturedRectUV( math.random( -w / 8, w / 8 ), - h / 4, w * 1.35, h * 1.3, 0, 0, 1.2, 1 )
		surface.SetMaterial( mat_screen_left )
		surface.DrawTexturedRectUV( math.random( -w / 8, w / 8 ), - h / 4, w * 1.35, h * 1.3, 0, 0, 1.2, 1 )
	end
	
	render.PopFilterMag()
	render.PopFilterMin()
	render.SetRenderTarget( view )
	render.SetViewPort( 0, 0, w, h )
	cam.End2D()
	
end

surface.CreateFont( 'AlienIsolation_MTFont', {
	font = 'Helvetica Neue LT Std',
	size = 65,
	weight = 1000,
	antialias = true
} )

hook.Add( 'PostDrawHUD', 'RenderMotionTracker', DrawMotionTracker )

