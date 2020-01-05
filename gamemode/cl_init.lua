include("shared.lua")
include("client/cl_networkhooks.lua")
include("client/cl_hud.lua")
include("client/cl_footsteps.lua")
include("client/cl_halos.lua")

-- Midnigth voice event

sound.Add({
    name = "dh_midnigth_voices",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 25,
    pitch = 100,
    sound = {
        "ambient/levels/citadel/strange_talk1.wav",
        "ambient/levels/citadel/strange_talk2.wav",
        "ambient/levels/citadel/strange_talk3.wav",
        "ambient/levels/citadel/strange_talk4.wav",
        "ambient/levels/citadel/strange_talk5.wav",
        "ambient/levels/citadel/strange_talk6.wav",
        "ambient/levels/citadel/strange_talk7.wav",
        "ambient/levels/citadel/strange_talk8.wav",
        "ambient/levels/citadel/strange_talk9.wav",
        "ambient/levels/citadel/strange_talk10.wav"
    }
})

hook.Add("DHOnMidnigthEvent", "Voices", function(event)

    if event ~= "voices" then return end

    LocalPlayer():EmitSound("dh_midnigth_voices")

end)

-- Chat
net.Receive("Chat", function()


    txt = net.ReadTable()

    chat.AddText(unpack(txt, 0))

end)