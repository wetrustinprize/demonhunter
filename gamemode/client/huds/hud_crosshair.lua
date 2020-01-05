local cs_thick = 1
local cs_size = 25
local cs_color = Color(0,255,0)

function CrosshairHUD()

    surface.SetDrawColor(cs_color)
    surface.DrawRect(screenw/2-cs_thick/2*size_ratio, screenh/2-cs_size/2*size_ratio, cs_thick*size_ratio, cs_size*size_ratio)
    surface.DrawRect(screenw/2-cs_size/2*size_ratio, screenh/2-cs_thick/2*size_ratio, cs_size*size_ratio, cs_thick*size_ratio)

end