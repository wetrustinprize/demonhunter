include("cl_hudfunctions.lua")

-- Screen variables
screenh = ScrH()
screenw = ScrW()
size_ratio = ((screenh / 992) + (screenw / 1768)) / 2

-- Round variables
ismidnight = false
willrespawn = false

-- HUD hide
local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudZoom"] = true,
    ["CHudDeathNotice"] = true
}

include("huds/hud_materials.lua")
include("huds/hud_status.lua")
include("huds/hud_youare.lua")
include("huds/hud_crosshair.lua")
include("huds/hud_endinfo.lua")

hook.Add("OnScreeSizeChanged", "HUDRefresh", function()

    screenh = ScrH()
    screenw = ScrW()
    size_ratio = 2 - ((screenh / 992) + (screenw / 1768))

end)

hook.Add("HUDPaint", "DemonHunterHUD", function()

    if LocalPlayer():HasWeapon("weapon_dh_hands") then
        DrawInnocentIndicator()
        StatusHUD()
        if LocalPlayer():HasWeapon("weapon_dh_crossbow") then
            if LocalPlayer():GetActiveWeapon():GetClass() == "weapon_dh_crossbow" then CrosshairHUD() end
        end
    end
    
    if ya_show then YouAreHUD() end
    EndInfoHUD()

end)

-- Hide default huds

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)

    if ( hide[ name ] ) then return false end

end)

-- Midnight check

hook.Add("DHOnRoundChangeState", "Midnight Check", function(state)

    ismidnight = state == "midnight"


end)