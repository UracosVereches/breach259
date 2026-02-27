function OUTSIDE_BUFF( pos )
	if pos.z > 1600 then
		return true
	end
end

CAMERAS = {
	{
	 name = "OUTSIDE",
	 pos = Vector(-175.584122, 6703.034180, 1725.708130),
	 ang = Angle(0.000, 146.079, 0.000)
	},
	{
	 name = "GATE_A",
	 pos = Vector(-697.264893, 5349.814941, 226.462402),
	 ang = Angle(0.000, -12.395, 0.000)
	},
	{
	 name = "GATE_B",
	 pos = Vector(-3950.994873, 2414.622559, 190.495819),
	 ang = Angle(0.000, -48.519, 0.000)
  },
	{
	 name = "CAFETERIA",
	 pos = Vector(53.675919, 3155.835693, 140.282364),
	 ang = Angle(0.000, 88.400, 0.000)
	},
	{
	 name = "HCZ_TESLA",
	 pos = Vector(4210.521484, 2002.322388, 149.438217),
	 ang = Angle(0.000, -101.296, 0.000)
	},
	{
	 name = "HCZ_1",
	 pos = Vector(3171.853516, 2657.589111, 50.352276),
	 ang = Angle(0.000, -153.835, 0.000)
	},
	{
	 name = "SCP_173",
	 pos = Vector(816.530701, 1170.705566, 337.440979),
	 ang = Angle(0.000, 134.616, 0.000)
	},
	{
	 name = "SCP_106",
	 pos = Vector(2868.708252, 4928.124023, 166.737183),
	 ang = Angle(0.000, -134.537, 0.000)
	},
	{
	 name = "LCZ_MAIN",
	 pos = Vector(718.819336, -58.217102, 181.064407),
	 ang = Angle(0.000, -56.380, 0.000)
	},
	{
	 name = "LCZ_DCELLS",
	 pos = Vector(-659.140808, 1138.599976, 350.122894),
	 ang = Angle(0.000, -173.823, 0.000)
	},
}

hook.Add("EntityTakeDamage", "rxsend_entitytakedamage", function(target, dmginfo)
	if dmginfo:GetDamageType() == DMG_BLAST then
		dmginfo:ScaleDamage(4)
	end

	local dmgtype = dmginfo:GetDamageType()

	if target:IsPlayer() then
		if target:GetNClass() == ROLES.ROLE_SCP457 and dmgtype == DMG_BURN then
			dmginfo:SetDamage( 0 )
			dmginfo:ScaleDamage(0)
		elseif target:GTeam() != TEAM_SCP and target:GTeam() != TEAM_SPEC and target:GTeam() != TEAM_DZ and dmgtype == DMG_BURN then
			dmginfo:SetDamage(4)
		end
	end

	if activeRound == ROUNDS.ttt and target:GetClass() == "func_breakable" then
		dmginfo:ScaleDamage(0)
	end

	if activeRound == ROUNDS.ww2tdm and target:GetClass() == "func_breakable" then
		dmginfo:ScaleDamage(0)
	end

if target:IsPlayer() and dmginfo:GetAttacker():IsPlayer() then
	if target:GTeam() == TEAM_SCP and dmginfo:GetAttacker():GTeam() == TEAM_SCP then
		dmginfo:ScaleDamage(0)
	end
end

    if target:IsPlayer() and target:GTeam() == TEAM_SCP and target:GetNClass() == ROLES.ROLE_SCP082 then
        local damage = dmginfo:GetDamage()
        if target:GetNWBool("Anger") == false then
            target:SetNWFloat("amountDamage", target:GetNWFloat("amountDamage", 0) + (damage * 3))
            if target:GetNWFloat("amountDamage") >= 900 then
                target:SetNWBool("Anger", true)
				target:Freeze(true)
				target:EmitSound("scp_sounds/scp_082/rage.mp3")

                target:SetNWFloat("amountDamage", 0)
                timer.Create("screamingBITCH"..target:UniqueID(), 1, 1, function()


				    target:SetNWBool("Anger", true)
					target:Freeze(false)
					timer.Create("becomeFuckinShit"..target:UniqueID(), 12, 1, function()

                        target:SetNWBool("Anger", false)
                    end)
                end)
            end
        else
            dmginfo:ScaleDamage(0.7)
        end
    end

	if ( IsValid(target) and dmginfo:GetDamage() > 1 and dmginfo:IsBulletDamage() and target:IsPlayer() ) then
            if target:IsEFlagSet(EFL_NO_DAMAGE_FORCES) == false then
            	target.dmgforce = dmginfo:GetDamageForce()
            	target:AddEFlags(EFL_NO_DAMAGE_FORCES)
            end
            --dmginfo:SetDamage(dmginfo:GetDamage() * 1)
            --dmginfo:SetDamageForce(Vector(0, 0, 0))
            --target:TakeDamageInfo(dmginfo)
            --dmginfo:SetDamage(0)
    end

    if target:GetClass() == "prop_ragdoll" then
    	if target:IsEFlagSet(EFL_NO_DAMAGE_FORCES) == false then
        	target:AddEFlags(EFL_NO_DAMAGE_FORCES)
        end
    end
	
	if ( target:IsPlayer() && target:GTeam() == TEAM_SCP ) then
		--dmginfo:SetDamageType(DMG_GENERIC)
		if OUTSIDE_BUFF( target:GetPos() ) then
			dmginfo:ScaleDamage(1.2)
		else
			dmginfo:ScaleDamage(0.9)
		end
		target:SetHealth(target:Health() - dmginfo:GetDamage());
	  dmginfo:SetDamage(0);
	end

	if target:IsPlayer() and target:HasWeapon( "item_scp_500" ) then
		if target:Health() <= dmginfo:GetDamage() then
			target:GetWeapon( "item_scp_500" ):OnUse()
			target:PrintMessage( HUD_PRINTTALK, "Использую SCP 500" )
		end
	end

	local at = dmginfo:GetAttacker()
	if at:IsVehicle() or ( at:IsPlayer() and at:InVehicle() ) then
		dmginfo:SetDamage( 0 )
	end
	--[[
	if at:IsNPC() then
		if at:GetClass() == "npc_fastzombie" then
			dmginfo:ScaleDamage( 4 )
		end
		--]]
	if target:IsPlayer() then
		if target:Health() > 0 and target:GTeam() != TEAM_SCP and target:GTeam() != TEAM_SPEC then
				util.StartBleeding(target, dmginfo:GetDamage(), 5)
		end
			--print(target)
			local dmgtype = dmginfo:GetDamageType()

			if dmgtype == 268435464 or dmgtype == 8 then

				if target:GTeam() == TEAM_SCP or target:GetNClass() == ROLES.ROLE_SCP457 then
					dmginfo:SetDamage( 0 )
				    dmginfo:ScaleDamage(0)
					return true
        		end

			end

			if (dmgtype == DMG_SHOCK) and target.UsingArmor == "armor_fireproof" then
				dmginfo:ScaleDamage(0.2)

			elseif (dmgtype == DMG_SHOCK or dmgtype == DMG_ENERGYBEAM) and target.UsingArmor == "armor_electroproof" then
				dmginfo:ScaleDamage(0.2)
			end

			if ( target:GetNWBool("InMolotov") == true) then --(target:GetNWBool("InMolotov") == true && dmgtype == 8)

				dmginfo:ScaleDamage( 4 )

			end


			if ( target:GetNClass() == ROLES.ROLE_MTFJAG && dmginfo:GetDamageType() == DMG_SLASH ) then

				dmginfo:ScaleDamage( .15 )

			end



			if target.UsingArmor == "armor_goc" and target:GetNClass() == ROLES.ROLE_GOCSPY then

				dmginfo:ScaleDamage(0.94)

			elseif ( target:GetNClass() == ROLES.ROLE_MTFJAG && dmginfo:GetDamageType() == DMG_BULLET ) then

				dmginfo:ScaleDamage(0.5)

			--elseif target:GetNClass() == ROLES.ROLE_FAT then
				--dmginfo:ScaleDamage(0.7)

			--elseif target:GetNClass() == ROLES.ROLE_TOPKEK then
				--dmginfo:ScaleDamage(0.8)

			elseif ( target.UsingArmor == "armor_chaoss" ) then

				dmginfo:ScaleDamage(0.55)

			end


			if ( target:GTeam() != TEAM_SPEC && dmginfo:GetDamageType() == DMG_BULLET ) then

				dmginfo:ScaleDamage( 2 )

			end

	end

	if IsValid(ent) and ent:GetClass() == "prop_alien_locker" then
	   dmginfo:ScaleDamage(0.1)
	end
	
	if target:IsPlayer() and dmginfo:GetAttacker():IsPlayer() then
		print("DMG to "..target:GetName().."["..target:GetNClass().."], DMG: "..dmginfo:GetDamage()..", TYPE: "..dmginfo:GetDamageType()..", FROM: "..dmginfo:GetAttacker():GetName().."["..dmginfo:GetAttacker():GetNClass().."], HITGROUP: "..target:LastHitGroup()..", WEAPON: "..dmginfo:GetAttacker():GetActiveWeapon():GetClass()..", V POS: "..tostring(target:GetPos())..", A POS: "..tostring(dmginfo:GetAttacker():GetPos()))
	end

end)

hook.Add("ScalePlayerDamage", "rxsend_scaleplayerdamage", function(ply, hitgroup, dmginfo)

	if ply:GetActiveWeapon().PhantomForceEnabled then
		dmginfo:ScaleDamage(0)
	end

	if dmginfo:GetAttacker():IsPlayer() then
		if ply:GTeam() == TEAM_SCP and dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "cwc_cbar" then
			dmginfo:ScaleDamage(0.2)
		end
	end

	if ply:GTeam() != TEAM_SCP then
		if string.find(ply:GetModel(), "female") and hitgroup != HITGROUP_HEAD then
			ply:EmitSound("vo/npc/female01/pain0"..math.random(1,9)..".wav")
		elseif !string.find(ply:GetModel(), "female") and hitgroup != HITGROUP_HEAD then
			ply:EmitSound('vo/npc/male01/pain0'..math.random(1,9)..'.wav')
		end
	end

	if ply:GTeam() == TEAM_NAZI and dmginfo:GetAttacker():GTeam() == TEAM_NAZI then
		dmginfo:ScaleDamage(0)
	end

	if ply:GTeam() == TEAM_USSR and dmginfo:GetAttacker():GTeam() == TEAM_USSR then
		dmginfo:ScaleDamage(0)
	end

	if ply:GTeam() == TEAM_SCP then
		dmginfo:ScaleDamage(0.15)
	end

	--if ply:GetNClass() == ROLES.ROLE_SCP0492 then
		--dmginfo:ScaleDamage(0.6)
	--end

	if ply:Health() < 0 then
		if dmginfo:IsBulletDamage() then

			if dmginfo:GetAmmoType() == "Pistol" then
				ply.DiedFromPistolBullets = true

				for k, v in ipairs(player.GetAll()) do
					v:SendLua("ply.DiedFromPistolBullets = true")
				end

			elseif dmginfo:GetAmmoType() == "SMG1" then
				ply.DiedFromSMG1Bullets = true

				for k, v in ipairs(player.GetAll()) do
					v:SendLua("ply.DiedFromSMG1Bullets = true")
				end

			elseif dmginfo:GetAmmoType() == "AR2" then
				ply.DiedFromAR2Bullets = true

				for k, v in ipairs(player.GetAll()) do
					v:SendLua("ply.DiedFromAR2Bullets = true")
				end
			end

			if hitgroup == HITGROUP_HEAD then
				ply.DiedFromHeadshot = true
	
				for k, v in ipairs(player.GetAll()) do
					v:SendLua("ply.DiedFromHeadshot = true")
				end
			end
			
		end

		elseif dmginfo:GetDamageType() == DMG_SLASH then
			ply.DiedFromSlash = true

			for k, v in ipairs(player.GetAll()) do
				v:SendLua("ply.DiedFromSlash = true")
			end

		else
			ply.DeathReasonUnknown = true

			for k, v in ipairs(player.GetAll()) do
				v:SendLua("ply.DiedFromSlash = true")
			end
		end


	if ply:Armor() > 0 and hitgroup == HITGROUP_HEAD then
		ply:EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(1,3)..".wav", 75, 100, 2)
		local DamagedPlayerSpark    =    ents.Create( "env_spark" )

                DamagedPlayerSpark:SetPos( dmginfo:GetDamagePosition() )

                DamagedPlayerSpark:SetKeyValue( "Magnitude" , "1" )
                DamagedPlayerSpark:SetKeyValue( "spawnflags" , "256" )
				DamagedPlayerSpark:SetKeyValue( "TrailLength" , "1" )
                DamagedPlayerSpark:Spawn()

                if IsValid( DamagedPlayerSpark ) then

                    DamagedPlayerSpark:Fire( "SparkOnce" , 0 , 0 )
                    DamagedPlayerSpark:Fire( "SparkOnce" , 0 , 0 )



                end

                timer.Simple( 0.02 , function()

                    if IsValid( DamagedPlayerSpark ) then

                        DamagedPlayerSpark:Remove()

                    end

                end)

	end

	if hitgroup == HITGROUP_HEAD and dmginfo:GetAttacker():IsPlayer() and ply:GTeam() != TEAM_SCP then
		ply.WasHeadShoted = true
		--EmitSound("player/headshot11.wav", ply:GetPos(), ply:EntIndex())
	end
	/*
	if SERVER then
		local at = dmginfo:Getat()
		if ply:GTeam() == at:GTeam() then
			at:TakeDamage( 25, at, at )
		end
	end
	*/
	if ply.UsingHL2Armor == true and ply:Armor() <= 0 then
		ply.UsingHL2Armor = false
		ply:RXSENDWarning("Ваша броня разрушена!")
	end
local mul = 1
		local armormul = 1
		mul = mul * armormul
		//mul = math.Round(mul)
		//print("mul: " .. mul)
		dmginfo:ScaleDamage(mul)
		if ply:GTeam() == TEAM_SCP and OUTSIDE_BUFF( ply:GetPos() ) then
			dmginfo:ScaleDamage( 0.8 )
		end

		if ply:GetNWBool("debuff", true) then

	    dmginfo:ScaleDamage(3)

		--local scale = math.Clamp( GetConVar( "br_scale_bullet_damage" ):GetFloat(), 0.1, 2 )
		--dmginfo:ScaleDamage( scale )
		end

	local attacker = dmginfo:GetAttacker()
	--if attacker.GetActiveWeapon then

	if attacker:IsPlayer() then

		if attacker:GetActiveWeapon():GetClass() == "cwc_cbar" then
			dmginfo:ScaleDamage(0.3)
		elseif attacker:GetActiveWeapon():GetClass() == "weapon_stunstick" then
			dmginfo:ScaleDamage(0.5)
		end

	local at = dmginfo:GetAttacker()
	local mul = 1
	local armormul = 1
		local rdm = false
		if at != ply then
			if at:IsPlayer() and dmginfo:IsDamageType( DMG_BULLET ) and ply.UsingArmor != nil then
				--if dmginfo:IsDamageType( DMG_BULLET ) then
					--if ply.UsingArmor != nil then
				if ply.UsingArmor != "armor_fireproof" and ply.UsingArmor != "armor_electroproof" then
					armormul = 0.75
				end

				if postround == false then -- and at.GTeam and ply.GTeam
					if at:GTeam() == TEAM_GUARD then
						if ply:GTeam() == TEAM_GUARD then
							rdm = true
						elseif ply:GTeam() == TEAM_SCI then
							rdm = true
						end
					elseif at:GTeam() == TEAM_CHAOS then
						if ply:GTeam() == TEAM_CHAOS or ply:GTeam() == TEAM_CLASSD then
							rdm = trueGTeam
						end
					elseif at:GTeam() == TEAM_SCP then
						if ply:GTeam() == TEAM_SCP then
							rdm = true
						end
					elseif at:GTeam() == TEAM_CLASSD then
						if ply:GTeam() == TEAM_CLASSD or ply:GTeam() == TEAM_CHAOS then
							rdm = true
						end
					elseif at:GTeam() == TEAM_SCI then
						if ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_SCI then
							rdm = true
						end
					end
				end

			end
		end
	end
	--local pl = ply

  --if ply:GTeam() != TEAM_SCP then
  		if ply:GTeam() == TEAM_GUARD then
  			dmginfo:ScaleDamage(0.8)
  		end

  		if ply:GTeam() == TEAM_CLASSD or ply:GTeam() == TEAM_SCI then
  			dmginfo:ScaleDamage(0.6)
  		end

		if (hitgroup == HITGROUP_HEAD) then
			--print("lolk")
			if !ply:GetNClass() == ROLES.ROLE_MTFJAG and ply:GTeam() != TEAM_SCP then
				dmginfo:ScaleDamage(3)
			--	print("HITGROUP_HEAD4")
			else
				dmginfo:ScaleDamage(1.2)
				--print("HITGROUP_HEAD")
			end

		end
		if (hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			if !ply:GetNClass() == ROLES.ROLE_MTFJAG and ply:GTeam() != TEAM_SCP then
				dmginfo:ScaleDamage(2)
				--print("HITGROUP_LEFTARM2")
			else
				dmginfo:ScaleDamage(3)
					--print("HITGROUP_LEFTARM")
			end
		end
		if (hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) then
			if !ply:GetNClass() == ROLES.ROLE_MTFJAG and ply:GTeam() != TEAM_SCP then
				dmginfo:ScaleDamage(1)
			else
				dmginfo:ScaleDamage(3)
				--print("HITGROUP_LEFTLEG")
			end
		end
		if (hitgroup == HITGROUP_GEAR) then
			if !ply:GetNClass() == ROLES.ROLE_MTFJAG and ply:GTeam() != TEAM_SCP then
				dmginfo:ScaleDamage(2)
			else
				dmginfo:ScaleDamage(0.8)
				--print("Gear")
			end
		end
		if (hitgroup == HITGROUP_STOMACH) then
			if !ply:GetNClass() == ROLES.ROLE_MTFJAG and ply:GTeam() != TEAM_SCP then
				dmginfo:ScaleDamage(2)
			else
				dmginfo:ScaleDamage(0.8)
				--print("HITGROUP_STOMACH")
			end
		end
		if (hitgroup == HITGROUP_CHEST) then
			if !ply:GetNClass() == ROLES.ROLE_MTFJAG and ply:GTeam() != TEAM_SCP then
				dmginfo:ScaleDamage(2)
			else
				dmginfo:ScaleDamage(0.8)
				--print("HITGROUP_STOMACH")
			end
		end

		--[[
		if at:IsPlayer() then
			if at.GetNKarma then
				mul = mul * (at:GetNKarma() / StartingKarma())
			end
		end
		--]]
end)