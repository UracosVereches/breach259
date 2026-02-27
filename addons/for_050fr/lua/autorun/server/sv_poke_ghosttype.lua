util.AddNetworkString("GHOSTPOKESENDTP")
util.AddNetworkString("GHOSTPOKEEFFECT")
util.AddNetworkString("GHOSTPOKELASER")
util.AddNetworkString("GHOSTPOKECONFUSE")
util.AddNetworkString("GHOSTPOKECONFUSESTOP")
util.AddNetworkString("GHOSTPOKEMIRRORCOAT")
util.AddNetworkString("GHOSTPOKESHADOWCLAW")
function GHOSTPOKE_Effect(pos,effect,scale,normal,ply)
	if !ply then ply = nil end
	net.Start("GHOSTPOKEEFFECT")
		net.WriteVector(pos)
		net.WriteString(effect)
		net.WriteInt(scale,32)
		net.WriteVector(normal)
		net.WriteEntity(ply)
	net.Broadcast()
end
function GHOSTPOKE_Laser(startpos,endpos,effect)
	net.Start("GHOSTPOKELASER")
		net.WriteVector(startpos)
		net.WriteVector(endpos)
		net.WriteString(effect)
	net.Broadcast()
end
local function GhostPokeDMG(target,damage)
	local att = damage:GetAttacker()
	if IsValid(target) then
		if target:IsPlayer() && att != Entity(0) then
			local twep = target:GetActiveWeapon()
			if IsValid(twep) then
				if twep.PokeSWEP then

					if target == att && damage:GetInflictor():GetClass() == "prop_physics" then
						damage:SetDamage(0)
					end

					if twep.MirrorCoatEnabled then
						twep.MirrorCoatAbsorbed = twep.MirrorCoatAbsorbed + damage:GetDamage()
						damage:SetDamage(0)
					end
					
					if twep.PhantomForceEnabled then
						if (att:IsPlayer() && !att:GetActiveWeapon().PokeSWEP) or (!att:IsPlayer()) then
							damage:SetDamage(0)
						end
					end

					if twep.ShadowClawEnabled or twep.PhantomForceEnabled then
						if att:IsPlayer() && att != target then
							if IsValid(att:GetActiveWeapon()) then
								if att:GetActiveWeapon().PokeSWEP then
									print("[ghostpoke] Is POKESWEP. took damage!")
								else
									print("[ghostpoke] Is NOT POKESWEP. take no damage.")
									damage:SetDamage(0)
								end
							end
						end
					end
				end
			end
		end
	end
end
hook.Add("EntityTakeDamage","GHOSTPOKEDMGHOOK",GhostPokeDMG)

local function GhostPokeResetPlayer(ply)
	net.Start("GHOSTPOKECONFUSESTOP")
		net.WriteEntity(ply)
	net.Send(ply)
	ply.POKE_Confused = false
	timer.Remove("GHOSTPOKECONFUSERAYDMG"..ply:SteamID())
end
hook.Add("PlayerSpawn","GHOSTPOKEPLAYERSPAWN",GhostPokeResetPlayer)
hook.Add("PlayerDeath","GHOSTPOKEDEATHHOOK",GhostPokeResetPlayer)
