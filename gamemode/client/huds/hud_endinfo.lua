-- Variables
local ei_state = 0

local ei_text1 = "dasd"
local ei_text2 = "dasd"

local ei_text1color = Color(255,0,0,0)
local ei_text2color = Color(255,255,255,0)

local ei_textalpha = 0
local ei_textpos = 0

local ei_goto = 0
local ei_alpha = 0

local ei_showicon = false
local ei_icon = tex_bad
local ei_iconsize = 400

surface.CreateFont( "RoundInfoBig", {
	font = "Arial",
	extended = false,
	size = 128 * size_ratio,
	weight = 800,
	antialias = true,
    outline
} )

surface.CreateFont( "RoundInfoSmall", {
	font = "Arial",
	extended = false,
	size = 24 * size_ratio,
	weight = 800,
	antialias = true,
} )

function EndInfoHUD()

    ei_textpos = Lerp(1/50, ei_textpos, ei_goto)
    ei_textalpha = Lerp(1/80, ei_textalpha, ei_alpha)
    ei_textalpha = Lerp(1/80, ei_textalpha, ei_alpha)

    ei_text1color.a = ei_textalpha
    ei_text2color.a = ei_textalpha

    if ei_showicon then

        local icon_size = ei_iconsize * size_ratio

        surface.SetMaterial(tex_backlight)
        surface.SetDrawColor(255, 255, 255, 255*0.8)
        surface.DrawTexturedRectRotatedPoint(screenw/2, screenh/21*4*size_ratio+ei_textpos, icon_size, icon_size, CurTime()%360*10, 0, 0)
        
        surface.SetMaterial(ei_icon)
        surface.SetDrawColor(ei_text1color.r/3, ei_text1color.g/3, ei_text1color.b/3, 255)
        surface.DrawTexturedRectRotatedPoint(screenw/2, screenh/21*4*size_ratio+ei_textpos, icon_size, icon_size, 0, 0, 0)

    end

    draw.NoTexture()

    draw.DrawText(ei_text1, "RoundInfoBig", screenw/2, screenh/21*2+ei_textpos, ei_text1color, TEXT_ALIGN_CENTER)
    draw.DrawText(ei_text2, "RoundInfoSmall", screenw/2, screenh/29*6+ei_textpos, ei_text2color, TEXT_ALIGN_CENTER)

end

hook.Add("DHOnRoundChangeState", "Round End Info", function(state)

    if timer.Exists("HideEndInfo") then
        timer.Remove("HideEndInfo")
    end

    ei_state = state
    ei_textpos = 0
    ei_textalpha = 0

    if ei_state == "start" then
        ei_goto = 0
        ei_alpha = 0
        ei_showicon = false
    elseif ei_state == "badend" then
        ei_goto = 50
        ei_alpha = 255

        ei_showicon = true
        ei_icon = tex_bad

        ei_text1color = Color(255, 0, 0)
        ei_text1 = "EVIL WINS"
        ei_text2 = "All souls are in hell."

    elseif ei_state == "goodend" then
        ei_goto = 50
        ei_alpha = 255

        ei_showicon = true
        ei_icon = tex_good

        ei_text1color = Color(0, 191, 255)
        ei_text1 = "GOOD WINS"
        ei_text2 = "Satan has died."

    else
        ei_goto = 25
        ei_alpha = 255

        ei_text1color = Color(0, 0, 255)
        ei_text1 = "IT'S MIDNIGHT"
        ei_text2 = "Innocent souls are now evil."

        InfoHideTimer()
    end

end)

function InfoHideTimer()

    timer.Create("HideEndInfo", 4, 1, function()
        ei_goto = 0
        ei_alpha = 0
    end)

end