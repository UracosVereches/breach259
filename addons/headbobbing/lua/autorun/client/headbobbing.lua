local FT, CT, vel, cos1, cos2, intensity
local curviewbob = Angle(0, 0, 0)

local function CanOverrideView(client)
	if !IsValid(client:GetVehicle())
		and IsValid(client)
		and LocalPlayer():Alive()
		and LocalPlayer():GetActiveWeapon() != "item_cameraview" then
		--and weapons.IsBasedOn(LocalPlayer():GetActiveWeapon(), "cw_kk_ins2_base") == false then
		return true
	end
end

hook.Add("CalcView", "FAS_HeadBobbing", function(client, pos, angles, fov)
	if (CanOverrideView(client) and LocalPlayer():GetViewEntity() == LocalPlayer()) then
		local view = {}

		FT, CT = FrameTime(), CurTime()
		intensity = 1
		
		if (intensity > 0) then
			vel = client:GetVelocity():Length()

			if (client:OnGround() and vel > client:GetWalkSpeed() * 0.3) then
				if (vel < client:GetWalkSpeed() * 1.2) then
					cos1 = math.cos(CT * 15)
					cos2 = math.cos(CT * 12)
					curviewbob.p = cos1 * 0.15 * intensity
					curviewbob.y = cos2 * 0.1 * intensity
				else
					cos1 = math.cos(CT * 20)
					cos2 = math.cos(CT * 15)
					curviewbob.p = cos1 * 0.25 * intensity
					curviewbob.y = cos2 * 0.15 * intensity
				end
			else
				curviewbob = LerpAngle(FT * 10, curviewbob, Angle(0, 0, 0))
			end
		end

		view.angles = angles + curviewbob
		
		return GAMEMODE:CalcView(client, pos, view.angles, fov)
	end
end)