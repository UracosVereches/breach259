/*===============================================================
                           Concommands
===============================================================*/

// Global settings
if !ConVarExists("sv_ragdollblood_enable") then
    CreateConVar("sv_ragdollblood_enable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable ragdoll blood")
end

// Decal settings
if !ConVarExists("sv_ragdollblood_decalsenable") then
    CreateConVar("sv_ragdollblood_decalsenable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable ragdolls leaving decals")
end
if !ConVarExists("sv_ragdollblood_maxdecaldistance") then
    CreateConVar("sv_ragdollblood_maxdecaldistance", 50, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Maximum distance of a wall to leave a decal on")
end

// Impact effect settings
if !ConVarExists("sv_ragdollblood_effectimpactenable") then
    CreateConVar("sv_ragdollblood_effectimpactenable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable blood impact effect")
end

// Blood Spray settings
if !ConVarExists("sv_ragdollblood_effectsprayenable") then
    CreateConVar("sv_ragdollblood_effectsprayenable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable blood spray effect")
end
if !ConVarExists("sv_ragdollblood_maxspraytime") then
    CreateConVar("sv_ragdollblood_maxspraytime", 0.4, FCVAR_ARCHIVE + FCVAR_NOTIFY, "How long to make the spray effect last in seconds")
end
if !ConVarExists("sv_ragdollblood_onlyspraywithbullets") then
    CreateConVar("sv_ragdollblood_onlyspraywithbullets", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Only make the spray effect if the ragdoll was hit by a bullet")
end

// Chunk effect settings
if !ConVarExists("sv_ragdollblood_effectchunkenable") then
    CreateConVar("sv_ragdollblood_effectchunkenable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable blood chunk effect")
end

// Droplets effect settings
if !ConVarExists("sv_ragdollblood_effectdropletsenable") then
    CreateConVar("sv_ragdollblood_effectdropletsenable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable blood droplets effect")
end
if !ConVarExists("sv_ragdollblood_onlydropletswithbullets") then
    CreateConVar("sv_ragdollblood_onlydropletswithbullets", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Only make the droplets effect if the ragdoll was hit by a bullet")
end
if !ConVarExists("sv_ragdollblood_maxdropletstime") then
    CreateConVar("sv_ragdollblood_maxdropletstime", 0.4, FCVAR_ARCHIVE + FCVAR_NOTIFY, "How long to make the droplets effect last in seconds")
end

// Whitelists
if !ConVarExists("sv_ragdollblood_redbloodwhitelist") then
    CreateConVar("sv_ragdollblood_redbloodwhitelist", "", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Red blood whitelist")
end
if !ConVarExists("sv_ragdollblood_yellowbloodwhitelist") then
    CreateConVar("sv_ragdollblood_yellowbloodwhitelist", "", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Yellow blood whitelist")
end
if !ConVarExists("sv_ragdollblood_whitebloodwhitelist") then
    CreateConVar("sv_ragdollblood_whitebloodwhitelist", "models/combine_strider.mdl models/combine_dropship.mdl models/hunter.mdl", FCVAR_ARCHIVE + FCVAR_NOTIFY, "White blood whitelist")
end

// Blacklists
if !ConVarExists("sv_ragdollblood_redbloodblacklist") then
    CreateConVar("sv_ragdollblood_redbloodblacklist", "models/hunter.mdl", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Red blood blacklist")
end
if !ConVarExists("sv_ragdollblood_yellowbloodblacklist") then
    CreateConVar("sv_ragdollblood_yellowbloodblacklist", "", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Yellow blood blacklist")
end
if !ConVarExists("sv_ragdollblood_whitebloodblacklist") then
    CreateConVar("sv_ragdollblood_whitebloodblacklist", "", FCVAR_ARCHIVE + FCVAR_NOTIFY, "White blood blacklist")
end


/*===============================================================
                        Blood effect list
===============================================================*/

// Red blood
local RedBloodDecal = "Blood"
local RedBloodEffectImpact = "blood_impact_red_01"
local RedBloodEffectSpray = {
    "blood_advisor_pierce_spray",
    "blood_advisor_pierce_spray_b",
    "blood_advisor_pierce_spray_c",
    "blood_advisor_puncture_withdraw",
    "blood_zombie_split_spray"
}
local RedBloodEffectChunk = "blood_impact_red_01_chunk"
local RedBloodEffectDroplets = "blood_impact_red_01_droplets"

// Yellow blood
local YellowBloodDecal = "YellowBlood"
local YellowBloodEffectImpact = "blood_impact_green_01"
local YellowBloodEffectSpray = {
    "blood_advisor_shrapnel_spray_1",
    "blood_advisor_shrapnel_spray_2",
    "blood_advisor_shrapnel_spurt_1",
    "blood_advisor_shrapnel_spurt_2",
    "blood_advisor_shrapnel_impact"
}
local YellowBloodEffectChunk = {
    "blood_impact_green_01_chunk",
    "blood_impact_green_02_chunk"
}
local YellowBloodEffectDroplets = {
    "blood_impact_green_01_droplets",
    "blood_impact_green_02_droplets"
}
   
// White blood
local WhiteBloodDecal = "BirdPoop"
local WhiteBloodEffectImpact = "blood_impact_synth_01"
local WhiteBloodEffectSpray = {
    "blood_impact_synth_01_spurt",
    "blood_drip_synth_01",
    "blood_drip_synth_01c",
}
local WhiteBloodEffectChunk = "blood_impact_synth_01_armor"
local WhiteBloodEffectDroplets = "blood_impact_synth_01_droplets"


/*===============================================================
                    Ragdoll blood effect code
===============================================================*/

function RagdollBloodEffect(ent, dmginfo)

    // If a ragdoll was damaged and ragdollblood is enabled
	if (ent:GetClass() == "prop_ragdoll" && GetConVar("sv_ragdollblood_enable"):GetInt() == 1) then
    
        // Initialize some variables
        local EntModel = ent:GetModel()
        local BloodDecal          = nil
        local BloodEffectImpact   = nil
        local BloodEffectSpray    = nil
        local BloodEffectChunk    = nil
        local BloodEffectDroplets = nil
        
        // Get whitelists and blacklists
        local RedWhitelist    = string.Split( GetConVar("sv_ragdollblood_redbloodwhitelist"):GetString(), " " )
        local YellowWhitelist = string.Split( GetConVar("sv_ragdollblood_yellowbloodwhitelist"):GetString(), " " )
        local WhiteWhitelist  = string.Split( GetConVar("sv_ragdollblood_whitebloodwhitelist"):GetString(), " " )
        local RedBlacklist    = string.Split( GetConVar("sv_ragdollblood_redbloodblacklist"):GetString(), " " )
        local YellowBlacklist = string.Split( GetConVar("sv_ragdollblood_yellowbloodblacklist"):GetString(), " " )
        local WhiteBlacklist  = string.Split( GetConVar("sv_ragdollblood_whitebloodblacklist"):GetString(), " " )
	
        // Get the angle of the hit (for the particle emission)
        local AngleHit = ent:GetPos() - dmginfo:GetAttacker():GetPos()
        AngleHit = AngleHit:Angle()
        AngleHit.p = -100
		
        // Decide on the what blood effects to emit based on materials and whitelists
		if (table.HasValue(RedWhitelist, EntModel) || (ent:GetMaterialType() == MAT_FLESH || ent:GetMaterialType() == MAT_BLOODYFLESH)) && !table.HasValue(RedBlacklist, EntModel) then
            BloodDecal          = RedBloodDecal
            BloodEffectImpact   = RedBloodEffectImpact
            BloodEffectChunk    = RedBloodEffectChunk
            BloodEffectSpray    = RedBloodEffectSpray
            BloodEffectDroplets = RedBloodEffectDroplets
		elseif (table.HasValue(YellowWhitelist, EntModel) || ent:GetMaterialType() == MAT_ANTLION || ent:GetMaterialType() == MAT_ALIENFLESH) && !table.HasValue(YellowBlacklist, EntModel) then
			BloodDecal          = YellowBloodDecal
			BloodEffectImpact   = YellowBloodEffectImpact
			BloodEffectChunk    = YellowBloodEffectChunk
            BloodEffectSpray    = YellowBloodEffectSpray
            BloodEffectDroplets = YellowBloodEffectDroplets
        elseif table.HasValue(WhiteWhitelist, EntModel) && !table.HasValue(WhiteBlacklist, EntModel) then
            BloodDecal          = WhiteBloodDecal
			BloodEffectImpact   = WhiteBloodEffectImpact
			BloodEffectChunk    = WhiteBloodEffectChunk
            BloodEffectSpray    = WhiteBloodEffectSpray
            BloodEffectDroplets = WhiteBloodEffectDroplets
        else
            return
		end
        
        // Disable spray/droplets depending on the config
        if !dmginfo:IsBulletDamage() && GetConVar("sv_ragdollblood_onlyspraywithbullets"):GetInt() == 1 then
            BloodEffectSpray = nil
        end
        if !dmginfo:IsBulletDamage() && GetConVar("sv_ragdollblood_onlydropletswithbullets"):GetInt() == 1 then
            BloodEffectDroplets = nil
        end
        
        // Handle decal drawing
        if BloodDecal != nil && GetConVar("sv_ragdollblood_decalsenable"):GetInt() == 1 then
            // Setup the trace
            local startp = dmginfo:GetDamagePosition()
            local endp
            if dmginfo:GetAttacker():IsPlayer() then
                endp = startp + dmginfo:GetAttacker():GetAimVector()*GetConVar("sv_ragdollblood_maxdecaldistance"):GetInt()
            else
                endp = startp - ent:GetVelocity():GetNormalized()*GetConVar("sv_ragdollblood_maxdecaldistance"):GetInt()
            end
            local traceinfo = {
                start = startp, 
                endpos = endp, 
                filter = ent, 
                mask = MASK_SOLID_BRUSHONLY
            }
            
            // Emit the trace and draw the decal
            local trace = util.TraceHull(traceinfo)
            local todecal1 = trace.HitPos + trace.HitNormal
            local todecal2 = trace.HitPos - trace.HitNormal
            util.Decal(BloodDecal, todecal1, todecal2)
        end
            
        // Handle blood effect emission
        for i=1, 4 do
        
            // Select what effect to emit
            local Effect = nil
            local Time = 0.4
            if i == 1 && GetConVar("sv_ragdollblood_effectimpactenable"):GetInt() == 1 then
                Effect = BloodEffectImpact
            elseif i == 2 && GetConVar("sv_ragdollblood_effectsprayenable"):GetInt() == 1 then
                Effect = BloodEffectSpray
                Time = GetConVar("sv_ragdollblood_maxspraytime"):GetFloat()
            elseif i == 3 && GetConVar("sv_ragdollblood_effectchunkenable"):GetInt() == 1 then
                Effect = YellowBloodEffectChunk
            elseif i == 4 && GetConVar("sv_ragdollblood_effectdropletsenable"):GetInt() == 1 then
                Effect = BloodEffectDroplets
                Time = GetConVar("sv_ragdollblood_maxdropletstime"):GetFloat()
            end
            
            // If the effect is valid
            if Effect != nil then
                // If the effect is a table, pick one at random
                if type(Effect) == "table" then
                    Effect = table.Random(Effect)
                end
        
                // Emit the effect
                local BloodParticle = ents.Create( "info_particle_system" )
                BloodParticle:SetKeyValue( "effect_name", Effect )
                BloodParticle:SetKeyValue( "start_active", tostring( 1 ) )
                BloodParticle:SetPos( dmginfo:GetDamagePosition() )
                BloodParticle:SetAngles(AngleHit)
                BloodParticle:SetParent(ent)
                BloodParticle:Spawn()
                BloodParticle:Activate()
                BloodParticle:Fire( "Kill", nil, Time )
            end
        end
        
	end
    
end
hook.Add("EntityTakeDamage", "BuuRagdollBloodEffect", RagdollBloodEffect)


/*===============================================================
                       Spawn menu settings
===============================================================*/

if CLIENT then
	hook.Add("PopulateToolMenu", "BuuRagdollBloodSettings", function()
		spawnmenu.AddToolMenuOption("Options", "Ragdoll Blood Settings", "BuuRagdollBlood_Server", "Server", "", "", function(panel)

            // Setup the menu
			local RagdollBloodSettings = {
				Options = {}, 
				CVars = {}, 
				Label = "#Presets", 
				MenuButton = "1", 
				Folder = "Ragoll Blood Settings"
			}
			
            // Set the default values
			RagdollBloodSettings.Options["#Default"] = {	
				sv_ragdollblood_enable                  = "1",
				sv_ragdollblood_decalsenable            = "1",
				sv_ragdollblood_maxdecaldistance        = "50",
				sv_ragdollblood_effectimpactenable      = "1",
				sv_ragdollblood_effectsprayenable       = "1",
				sv_ragdollblood_maxspraytime            = "0.4",
				sv_ragdollblood_onlyspraywithbullets    = "1",
				sv_ragdollblood_effectchunkenable       = "1",
				sv_ragdollblood_effectdropletsenable    = "1",
				sv_ragdollblood_onlydropletswithbullets = "1",
				sv_ragdollblood_maxdropletstime         = "0.4",
                sv_ragdollblood_redbloodwhitelist       = "",
                sv_ragdollblood_yellowbloodwhitelist    = "",
                sv_ragdollblood_whitebloodwhitelist     = "models/combine_strider.mdl models/combine_dropship.mdl models/hunter.mdl",
                sv_ragdollblood_redbloodblacklist       = "models/hunter.mdl",
                sv_ragdollblood_yellowbloodblacklist    = "",
                sv_ragdollblood_whitebloodblacklist     = "",
			}
			panel:AddControl("ComboBox", RagdollBloodSettings)
			
            // Show the author
			panel:AddControl("Label", {Text = "By buu342"})
            panel:AddControl("Label", {Text = ""})
            
            // Global 
			panel:AddControl("CheckBox", {
				Label = "Enable ragdoll blood",
				Command = "sv_ragdollblood_enable",
			})
            panel:AddControl("Label", {Text = ""})

            // Decals
			panel:AddControl("CheckBox", {
				Label = "Enable decals",
				Command = "sv_ragdollblood_decalsenable",
			})
			panel:AddControl("Slider", {
				Label = "Max decal distance",
				Command = "sv_ragdollblood_maxdecaldistance",
                Type 		= "Integer",
				Min 		= "0",
				Max 		= "200",
			})
            panel:AddControl("Label", {Text = ""})
		
            // Impact effect
			panel:AddControl("CheckBox", {
				Label = "Enable impact effect",
				Command = "sv_ragdollblood_effectimpactenable",
			})
			panel:AddControl("Label", {Text = ""})
            
            // Spray effect
            panel:AddControl("CheckBox", {
				Label = "Enable spray effect",
				Command = "sv_ragdollblood_effectsprayenable",
			})
            panel:AddControl("CheckBox", {
				Label = "Only spray with bullets",
				Command = "sv_ragdollblood_onlyspraywithbullets",
			})
            panel:AddControl("Slider", {
				Label = "Spray effect duration",
				Command = "sv_ragdollblood_maxspraytime",
                Type 		= "Float",
				Min 		= "0",
				Max 		= "1",
			})
            panel:AddControl("Label", {Text = ""})
            
            // Chunk effect
			panel:AddControl("CheckBox", {
				Label = "Enable chunk effect",
				Command = "sv_ragdollblood_effectchunkenable",
			})
			panel:AddControl("Label", {Text = ""})
            
            // Droplets effect
            panel:AddControl("CheckBox", {
				Label = "Enable droplets effect",
				Command = "sv_ragdollblood_effectdropletsenable",
			})
            panel:AddControl("CheckBox", {
				Label = "Only emit droplets with bullets",
				Command = "sv_ragdollblood_onlydropletswithbullets",
			})
            panel:AddControl("Slider", {
				Label = "Droplets effect duration",
				Command = "sv_ragdollblood_maxdropletstime",
                Type 		= "Float",
				Min 		= "0",
				Max 		= "1",
			})
            panel:AddControl("Label", {Text = ""})
			
            // Whitelist
            panel:AddControl("Label", {Text = "Whitelist. Seperate by spaces"})
            panel:AddControl("TextBox", {
				Label = "Red blood whitelist",
				Command = "sv_ragdollblood_redbloodwhitelist",
			})
            panel:AddControl("TextBox", {
				Label = "Yellow blood whitelist",
				Command = "sv_ragdollblood_yellowbloodwhitelist",
			})
            panel:AddControl("TextBox", {
				Label = "White blood whitelist",
				Command = "sv_ragdollblood_whitebloodwhitelist",
			})
            panel:AddControl("Label", {Text = ""})
            
            // Blacklist
            panel:AddControl("Label", {Text = "Blacklist. Seperate by spaces"})
            panel:AddControl("TextBox", {
				Label = "Red blood blacklist",
				Command = "sv_ragdollblood_redbloodblacklist",
			})
            panel:AddControl("TextBox", {
				Label = "Yellow blood blacklist",
				Command = "sv_ragdollblood_yellowbloodblacklist",
			})
            panel:AddControl("TextBox", {
				Label = "White blood blacklist",
				Command = "sv_ragdollblood_whitebloodblacklist",
			})
			
		end)
	end)
end
