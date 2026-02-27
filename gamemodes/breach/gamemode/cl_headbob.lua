--[[
gamemodes/breach/gamemode/cl_headbob.lua
--]]


local HBAP = 0

local HBAY = 0

local HBAR = 0

local HBPX = 0

local HBPY = 0

local HBPZ = 0

local HBEnabled = true



function HeadBob(pl, pos, ang, fov)

	if HBEnabled == false then return end



	if ( ply:GetNWEntity( "RagdollEntityNO" ) ) then return end



	if not !(ply:GTeam() == TEAM_SPEC or ply:GTeam() == TEAM_SCP) then return end

	local view = {}

	view.pos = pos

	view.ang = ang

	view.fov = fov



	local speedmul = (pl:GetVelocity():Length() / 100) / 3

	//print(speedmul)

	//chat.AddText(tostring(speedmul))



	if pl:IsOnGround() && HBEnabled  then



		if pl:KeyDown(IN_FORWARD) || pl:KeyDown(IN_BACK) || pl:KeyDown(IN_MOVELEFT) || pl:KeyDown(IN_MOVERIGHT) then

			HBPZ = HBPZ + (10 / 1) * FrameTime()

		end



		if pl:KeyDown(IN_FORWARD) then

			if HBAP < 1.5 then

				HBAP = HBAP + 0.05 * speedmul

			end

		else

			if HBAP > 0 then

				HBAP = HBAP - 0.05 * speedmul

			end

		end



		if pl:KeyDown(IN_BACK) then

			if HBAP > -1.5 then

				HBAP = HBAP - 0.05 * speedmul

			end

		else

			if HBAP < 0 then

				HBAP = HBAP + 0.05 * speedmul

			end

		end



		if pl:KeyDown(IN_MOVELEFT) then

			if HBAR > -1.5 then

				HBAR = HBAR - 0.07 * speedmul

			end

		else

			if HBAR < 0 then

				HBAR = HBAR + 0.07 * speedmul

			end

		end



		if pl:KeyDown(IN_MOVERIGHT) then

			if HBAR < 1.5 then

				HBAR = HBAR + 0.07 * speedmul

			end

		else

			if HBAR > 0 then

				HBAR = HBAR - 0.07 * speedmul

			end

		end

	end



	//if !pl:GetActiveWeapon():GetNWBool("Ironsights") then

		pl.OLDANG = view.ang

		pl.OLDPOS = view.pos

		view.ang.pitch = view.ang.pitch + HBAP * speedmul

		view.ang.roll = view.ang.roll + HBAR * 0.8 * speedmul

		view.pos.z = view.pos.z - math.cos(HBPZ * 0.7)

	//end



	return GAMEMODE:CalcView(pl, view.pos, view.ang, view.fov)

end

hook.Add("CalcView", "HeadBobbing", HeadBob)



function ToggleHB(ply)

	if HBEnabled == false then

		print("Head Bobbing enabled")

		HBEnabled = true

	else

		print("Head Bobbing disabled")

		HBEnabled = false

	end

end

concommand.Add("br_headbobbing",ToggleHB)



local view = {

    origin = Vector(0, 0, 0),

    angles = Angle(0, 0, 0),

    fov = 90,

    znear = 1

}

--First Person death hook

hook.Add("CalcView", "firstpersondeathkk", function(ply, origin, angles, fov)

    -- Entity:Alive() is being slow as hell, we might actually see ourselves from third person for frame or two

		--if ply:KillSilent() then return end



	--	print( ply:GetNWEntity("RagdollEntityNO") )
		--if ply:GTeam() == TEAM_SPEC then return end
		
		--if ( ply:Health() > 0 && !ply:GetNWEntity( "RagdollEntityNO" ) ) then return end



	    local ragdoll = ply:GetNWEntity("RagdollEntityNO")



	    if not IsValid(ragdoll) then return end

	    local head = ragdoll:LookupAttachment("eyes")

	    head = ragdoll:GetAttachment(head)

	    if not head or not head.Pos then return end



	    if not ragdoll.BonesRattled then

	        ragdoll.BonesRattled = true

	        ragdoll:InvalidateBoneCache()

	        ragdoll:SetupBones()

	        local matrix



	        for bone = 0, (ragdoll:GetBoneCount() or 1) do

	            if ragdoll:GetBoneName(bone):lower():find("head") then

	                matrix = ragdoll:GetBoneMatrix(bone)

	                break

	            end

	        end



	        if IsValid(matrix) then

	            matrix:SetScale(Vector(0, 0, 0))

	        end

	    end



	    view.origin = head.Pos + head.Ang:Up() * 2 + head.Ang:Forward() * 2

	    view.angles = head.Ang



	    return view

end)



local view = {



  origin = Vector( 0, 0, 0 ),

  angles = Angle( 0, 0, 0 ),

  fov = 90,

  drawviewer = true,

  znear = 1



}



--[[hook.Add( "CalcView", "VisionInsideLocker", function( ply, origin, angles, fov )



	print( ply )

  if ( !ply:GetNWEntity( "FakePlayer" ) || ply:GetNWEntity( "FakePlayer" ) == NULL ) then return end



  local ragdoll = ply:GetNWEntity("FakePlayer")



	if not IsValid(ragdoll) then return end

	local head = ragdoll:LookupAttachment("eyes")

	head = ragdoll:GetAttachment(head)

  if not head or not head.Pos then return end



	if not ragdoll.BonesRattled then

	  ragdoll.BonesRattled = true

	  ragdoll:InvalidateBoneCache()

	  ragdoll:SetupBones()

	  local matrix



	  for bone = 0, (ragdoll:GetBoneCount() or 1) do

	    if ragdoll:GetBoneName(bone):lower():find("head") then

	      matrix = ragdoll:GetBoneMatrix(bone)

	      break

	    end

	  end



	  if IsValid(matrix) then

	    matrix:SetScale(Vector(0, 0, 0))

    end

	end



	view.origin = ( head.Pos + Vector( 0, 0, 0 ) ) + head.Ang:Up() * 10

	view.angles = head.Ang



	return view



end )]]

local view = {

  origin = Vector(0, 0, 0),

  angles = Angle(0, 0, 0),

  fov = 90,

  drawviewer = true,

  znear = 1

}

hook.Add("CalcView", "ViewInLocker", function(ply, origin, angles, fov)



  if ( ply:GetNWEntity("FakePlayer") == NULL ) then return end



	print( ply )

	local ragdoll = ply:GetNWEntity("FakePlayer")



	if not IsValid(ragdoll) then return end

	local head = ragdoll:LookupAttachment("eyes")

	head = ragdoll:GetAttachment(head)

  if not head or not head.Pos then return end



	if not ragdoll.BonesRattled then

	  ragdoll.BonesRattled = true

	  ragdoll:InvalidateBoneCache()

	  ragdoll:SetupBones()

	  local matrix



	  for bone = 0, (ragdoll:GetBoneCount() or 1) do

	    if ragdoll:GetBoneName(bone):lower():find("head") then

	      matrix = ragdoll:GetBoneMatrix(bone)

	      break

	    end

	  end



	  if IsValid(matrix) then

	    matrix:SetScale(Vector(0, 0, 0))

    end

	end



	view.origin = ( head.Pos + Vector( 0, 0, 0 ) ) + head.Ang:Up() * 10

	view.angles = head.Ang



	return view

end)



