-- variables
local h_demonview = 0

hook.Add("PreDrawHalos", "Weapon Halos", function()

    halo.Add(ents.FindByClass("weapon_dh_crossbow"), Color(255,127,80), 0, 0, 5)
    halo.Add(ents.FindByClass("weapon_dh_pistol"), Color(0,191,255), 0, 0, 5)

end)

hook.Add("PreDrawHalos", "Ghost View", function()

    if (LocalPlayer():Team() != 0) and (LocalPlayer():Team() != 3) then return end

    local plys = {}

    for k, v in pairs(player.GetAll()) do

        if v:Team() == 0 then continue end
        if v:Team() == 3 then continue end

        table.insert(plys, v)

    end

    halo.Add(plys, Color(255,255,255), 1, 1, 1, true, true)

end)

hook.Add("PreDrawHalos", "Friend Demon", function()

    if ismidnight == false then return end

    if LocalPlayer():Team() ~= 1 then return end

    local plys = {}

    for k, v in pairs(player.GetAll()) do
        if v:Team() == 1 then
            table.insert(plys, v)
        end
    end

    halo.Add(plys, Color(255,0,0), 0, 0, 7, true, false)

end)

hook.Add("PreDrawHalos", "Demon View", function()

    if LocalPlayer():Team() ~= 1 then return end
    if math.Round(h_demonview) == 0 then return end

    h_demonview = Lerp(1/150, h_demonview, 0)
    local blur = 6 *(h_demonview / 7)

    local plys = {}

    for k, v in pairs(player.GetAll()) do
        if v:Team() == 2 then
            table.insert(plys, v)
        end
    end

    halo.Add(plys, Color(0,0,255), blur, blur, math.Round(h_demonview), true, true)

end)

hook.Add("DHOnMidnigthEvent", "Demon View Call", function(event)

    if event ~= "voices" then return end
    h_demonview = 7

end)