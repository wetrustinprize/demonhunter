-- Variables
local st_ballsize = 90

local sp_percentage = 1
local sp_percentage_goto = 1
local sp_color = Color(48,72,72)
local sp_color_min = Color(48,48,48)

local hp_percentage = 1
local hp_color = Color(216,72,72)
local hp_color_min = Color(144,24,24)
local hp_pulse = 0

local new_sp_color = Color(0,0,0)
local new_hp_color = Color(0,0,0)

local fs_percentage = 1

local h_demonview = 0
local dir = Vector(0,0,0)

local pp_screen = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

-- Sprint bar
function StatusHUD()

    hp_percentage = Lerp(1/10, hp_percentage, LocalPlayer():Health() / LocalPlayer():GetMaxHealth())

    if hp_percentage < 1 then
            hp_pulse = Lerp(1/20, hp_pulse, 0)
        if(hp_pulse < 0.01) then
            hp_pulse = 1
        end
    end


    sp_percentage = Lerp(1/10, sp_percentage, sp_percentage_goto)

    fs_percentage = Lerp(1/20, fs_percentage, 0)

    new_sp_color = LerpColor(sp_percentage, sp_color_min, sp_color)
    new_hp_color = LerpColor(hp_percentage, hp_color_min, hp_color)

    DrawStatusBall(0, screenh, st_ballsize, new_hp_color, hp_percentage, tex_health, 1.6 + 0.4 * (hp_pulse * (1 -hp_percentage)))

    draw.NoTexture()
    surface.SetDrawColor(sp_color)
    draw.Circle(120+st_ballsize/2*1.2*size_ratio,screenh-5-st_ballsize/2*1.2*size_ratio,st_ballsize/2*size_ratio+5*fs_percentage*size_ratio,64)

    DrawStatusBall(120, screenh-5, st_ballsize/2, new_sp_color, sp_percentage, tex_sprint, 1.3)

end

function DrawInnocentIndicator()

    if LocalPlayer():Team() ~= 1 then return end

    h_demonview = Lerp(1/150, h_demonview, 0)

    local ply = LocalPlayer()
    local dist = 99999999
    local closestPlayer = nil

    for k, v in pairs(player.GetAll()) do
        if v == ply then continue end
        local cDist = LocalPlayer():GetPos():Distance(v:GetPos())
        if(cDist < dist) then
            closestPlayer = v
            dist = cDist
        end 
    end

    local shootpos = ply:GetShootPos()
    local endshootpos = shootpos + ply:GetAimVector() * 9999

    local tr = util.TraceLine({
        start = shootpos,
        endpos = endshootpos,
        filter = {ply},
        mask = MASK_ALL
    })

    local closestPlayerVector = closestPlayer:GetPos()
    local aplha = h_demonview / 7

    local playerVector = Vector(
                math.Round(closestPlayerVector.x - tr.HitPos.x), 
                math.Round(closestPlayerVector.y - tr.HitPos.y),
                math.Round(closestPlayerVector.z - tr.HitPos.z)
    )
    playerVector:Normalize()

    dir = LerpVector(1/50, dir, playerVector)

    print(dir)


    -- Left
    surface.SetDrawColor(0, 0, 255, 63 * (math.Clamp(dir.x, 0, 1)) * h_demonview)
    surface.SetMaterial(tex_indicator_left)
    surface.DrawTexturedRect(0, 0, screenw*0.05, screenh)

    -- Rigth
    surface.SetDrawColor(0, 0, 255, 63 * (math.Clamp(dir.x, -1, 0) * -1) * h_demonview)
    surface.SetMaterial(tex_indicator_rigth)
    surface.DrawTexturedRect(screenw-screenw*0.05, 0, screenw*0.05, screenh)

    -- Up
    surface.SetDrawColor(0, 0, 255, 63 * (math.Clamp(dir.y, -1, 0) * -1) * h_demonview)
    surface.SetMaterial(tex_indicator_up)
    surface.DrawTexturedRect(0, 0, screenw, screenh*0.05)

    -- Down
    surface.SetDrawColor(0, 0, 255, 63 * (math.Clamp(dir.y, 0, 1)) * h_demonview)
    surface.SetMaterial(tex_indicator_down)
    surface.DrawTexturedRect(0, screenh-screenh*0.05, screenw, screenh*0.05)


end

function DrawStatusBall(x, y, ballsiz, ballcolor, percentage, texture, texture_scale)

    local xpos = x+ballsiz*1.2*size_ratio
    local ypos = y-ballsiz*1.2*size_ratio
    local scale = ballsiz*size_ratio

    surface.SetDrawColor(48, 48, 48, 255)
    draw.NoTexture()
    draw.Circle(xpos,ypos,scale,64)

    surface.SetDrawColor(55, 55, 55, 255)
    draw.Circle(xpos,ypos,scale*0.88,64)

    surface.SetDrawColor(ballcolor)
    draw.Circle(xpos,ypos,scale*0.83*percentage,64)

    if texture == nil then return end

    if texture_scale == nil then texture_scale = 1.6 end

    local image_scale = scale * texture_scale * percentage

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(texture)
    surface.DrawCenterTexturedRect(xpos,ypos,image_scale,image_scale)

end

net.Receive("SprintValue", function()

    sp_percentage_goto = net.ReadFloat() 

end)

hook.Add("PlayerFootstep", "HUDFootstep", function(ply, pos, foot, snd, volume, filter)

    if ply ~= LocalPlayer() then return end

    fs_percentage = volume / 0.5

end)

hook.Add("RenderScreenspaceEffects", "Status Effects", function()

    if ismidnight then
    
        pp_screen["$pp_colour_colour"] = Lerp(1/900, pp_screen["$pp_colour_colour"], 0.6)

        if LocalPlayer():Team() == 1 then
            pp_screen["$pp_colour_addr"] = Lerp(1/900, pp_screen["$pp_colour_addr"], 0.05)
            pp_screen["$pp_colour_brightness"] = Lerp(1/900, pp_screen["$pp_colour_brightness"], 0.05)
        else
            pp_screen["$pp_colour_brightness"] = Lerp(1/900, pp_screen["$pp_colour_brightness"], -0.05)
            pp_screen["$pp_colour_addb"] = Lerp(1/900, pp_screen["$pp_colour_addb"], 0.05)
        end

    else
        
        pp_screen["$pp_colour_colour"] = Lerp(1/100, pp_screen["$pp_colour_colour"], 1)
        pp_screen["$pp_colour_brightness"] = Lerp(1/100, pp_screen["$pp_colour_brightness"], 0)
        pp_screen["$pp_colour_addr"] = Lerp(1/100, pp_screen["$pp_colour_addr"], 0)
        pp_screen["$pp_colour_addb"] = Lerp(1/100, pp_screen["$pp_colour_addb"], 0)

    end

    DrawColorModify(pp_screen)


end)

hook.Add("DHOnMidnigthEvent", "Demon Indicator", function(event)

    if event ~= "voices" then return end
    h_demonview = 7

end)