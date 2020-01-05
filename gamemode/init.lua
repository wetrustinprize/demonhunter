AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

AddCSLuaFile("client/cl_hud.lua")
AddCSLuaFile("client/cl_hudfunctions.lua")
AddCSLuaFile("client/cl_networkhooks.lua")
AddCSLuaFile("client/cl_footsteps.lua")
AddCSLuaFile("client/cl_halos.lua")

AddCSLuaFile("client/huds/hud_materials.lua")
AddCSLuaFile("client/huds/hud_status.lua")
AddCSLuaFile("client/huds/hud_youare.lua")
AddCSLuaFile("client/huds/hud_crosshair.lua")
AddCSLuaFile("client/huds/hud_endinfo.lua")

include("shared.lua")

include("sv_resources.lua")
include("sv_network.lua")
include("sv_playerinfo.lua")

if not file.IsDir("demonhunters/clocks/", "DATA") then
    file.CreateDir("demonhunters/clocks/")
end

--[[

    Teams:
        0 : Dead (spectators)
        1: Demons
        2: Hunters
        3: DemonReborn

]]

-- 

include("sv_chat.lua")
include("sv_clockentity.lua")
include("sv_round.lua")
include("sv_playersprint.lua")
include("sv_concommands.lua")
include("sv_playermodels.lua")
include("sv_deathragdoll.lua")

-- Gamemode functions

function GM:Initialize()

    if file.Exists("demonhunters/clocks/" .. game.GetMap() .. ".txt", "DATA") then
        
        LoadClockFile()

    end

end

function GM:PlayerUse(ply, ent)

    if (ply:Team() == 0) or (ply:Team() == 3) then
        if ent:GetClass() == "prop_physics_multiplayer" and GetConVar("dh_ghostprops"):GetBool() then
            ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
            ent:SetColor(Color(255,255,255,255/2))
            return true
        else
            return false
        end
    else
        return true
    end

end

function GM:CreateTeams()

    team.SetUp(0, "Spectator", Color(0, 0, 0))
    team.SetUp(1, "Demon", Color(255,0,0))
    team.SetUp(2, "Hunter", Color(0,0,2555))

end

function GM:OnReloaded()

    for k, v in pairs(player.GetAll()) do
        v:SetDHDefault()
    end

end

function GM:EntityTakeDamage( target, dmg )

    if(dmg:GetInflictor():GetClass() == "weapon_fists") then
        
        dmg:ScaleDamage(0.3)
        
    end

end

function GM:PlayerShouldTakeDamage(ply, ent)

    if (not ent:IsPlayer()) then return true end

    if ply:Team() == 1 and ent:Team() == 1 then
        return false
    else
        return true
    end

end

function GM:GetFallDamage( ply, speed )
    
	return ( speed / 12 )

end

function GM:PlayerSpawn(ply)

    local model = nil

    if (ply:GetDHInfo().male == true) or (ply:GetDHInfo().male == nil) then
        model = player_manager.TranslatePlayerModel(table.Random(playermodels.male))
    else
        model = player_manager.TranslatePlayerModel(table.Random(playermodels.female))
    end

    util.PrecacheModel(model)
    ply:SetModel(model)
    ply:SetupHands()
    ply:SetPlayerColor(Vector(0,0,1))

    ply:AllowFlashlight(true)

    if round.playing == false && round.number == 0 then return end
        
    if ply:Team() == 3 && round.midnight then
        
        ply:UnSpectate()
        ply:SetTeam(1)
        ply:SetPlayerColor(Vector(1,0,0))

    elseif not round.prep then

        ply:StripWeapons()
        ply:Spectate(OBS_MODE_ROAMING)
        ply:AllowFlashlight(false)

    end

end

function GM:CanPlayerSuicide(ply, atk, dmg)

    if ply:Team() == 0 then
        return false
    else
        return true
    end

end

function GM:PlayerCanPickupWeapon(ply, wp)

    if round.playing == false then return true end
    
    if wp:GetClass() == "weapon_dh_crossbow" then
        return ply:GetDHInfo().canpickcrossbow
    else
        return true
    end


end

function GM:PlayerInitialSpawn(ply, transition)

    ply:SetDHDefault()
    ply:SetCrouchedWalkSpeed(0.3)
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(320)
    ply:AllowFlashlight(true)

    if round.number == 0 then
        timer.Simple(1, function()
            RoundStart()
        end)
    end

end

function GM:PlayerDisconnected(ply)

    timer.Simple(1, function()
        RoundCheckConditions()
    end)

end

function GM:PostPlayerDeath(ply)

    RoundCheckConditions()

end

function GM:PlayerDeathSound()
    return true
end

function GM:DoPlayerDeath(ply)

    createRagdoll(ply)

    if ply:HasWeapon("weapon_dh_crossbow") then
        ply:DropWeapon(ply:GetWeapon("weapon_dh_crossbow"))
    end

    if ply:HasWeapon("weapon_dh_pistol") then
        ply:DropWeapon(ply:GetWeapon("weapon_dh_pistol"))
    end

end

function GM:PlayerDeath(victim, inflictor, attacker)

    if round.playing == false then return end

    if (attacker:Team() == 1) and (inflictor:GetClass() == "weapon_dh_sacrificeknife") and (round.midnight == true) then
        
        local pitch = 0
        if victim:GetDHInfo().male == true then pitch = 80 else pitch = 100 end

        victim:EmitSound("ambient/creatures/town_child_scream1.wav", 100, pitch)

    end

    // ^ if no one wins
    if (inflictor:GetClass() == "weapon_dh_crossbow") and not round.midnight and victim:Team() == 2 then
        // If innocent, create demon
        victim:SetTeam(3)
        victim:SetDHCrossbowAble(false)

        // Drops the gun and disable pickup (if is innocent)
        attacker:DropWeapon(attacker:GetWeapon("weapon_dh_crossbow"))
        attacker:SetDHCrossbowAble(false)
    else
        victim:SetTeam(0)
    end

end