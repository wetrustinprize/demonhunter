-- You Are HUD Variables
ya_show = false
local ya_text1 = ""
local ya_text2 = ""
local ya_text3 = ""
local ya_text1color = Color(255, 0, 0, 255)
local ya_detail = 0

-- You Are HUD

function YouAreHUD()

    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0,0,screenw,screenh)

    surface.SetDrawColor(10, 10, 10, 255)
    if ya_detail == 1 then
       surface.SetMaterial(tex_bad)
    elseif ya_detail == 2 then
       surface.SetMaterial(tex_crossbow)
    elseif ya_detail == 3 then
        surface.SetMaterial(tex_pistol)
    else
        surface.SetMaterial(tex_good)
    end

    surface.DrawTexturedRect(screenw/2-screenh/2, 0, screenh, screenh)

    draw.NoTexture()

    draw.DrawText(ya_text1, "DermaLarge", screenw/2, screenh/21 * 10, ya_text1color, TEXT_ALIGN_CENTER)
    draw.DrawText(ya_text2, "Trebuchet24", screenw/2, screenh/21 * 10.7, Color( 125, 125, 255, 255 ), TEXT_ALIGN_CENTER)
    draw.DrawText(ya_text3, "Trebuchet24", screenw/2, screenh/21 * 13, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)

end

net.Receive("YouAre", function()

    demon = net.ReadBool()
    pistol = net.ReadBool()
    crossbow = net.ReadBool()
    pitch = 100

    if demon then
        pitch = 40
        ya_text1 = "You are the Demon"
        ya_text2 = "Kill everyone"
        ya_text3 = "If you need help, try \"making new demons\"."
        ya_detail = 1
        ya_text1color = Color(255, 0, 0)
    else
        ya_text1 = "You are a Hunter"
        ya_text3 = "Help the crossbow hunter find the demon."
        ya_detail = 0
        ya_text1color = Color(0, 0, 255)
    end

    if pistol then
        if ya_detail ~= 1 then 
            ya_detail = 3
        end
        ya_text2 = "With a pistol."
    elseif crossbow then
        ya_detail = 2
        ya_text2 = "With a crossbow."
        ya_text3 = "Kill the demon.\nTry not to kill innocent people."
    elseif not demon then
        ya_text2 = ""
    end

    ya_show = true

    
    LocalPlayer():EmitSound("ambient/alarms/warningbell1.wav", 60, pitch)

    timer.Simple(4, function()
        ya_show = false
    end)

end)