round = {}

round.playing = false
round.timer = 0
round.midnigthtimer = 20
round.midnight = false
round.number = 0
round.prep = false

function RoundRestart()

    RoundEnd(0)
    if timer.Exists("RestartRound") then
        timer.Remove("RestartRound")
    end
    game.CleanUpMap(false, {"demonclock"})
    RoundStart()

end

function RoundStart()

    if #player.GetAll() <= 3 then
        return 
    end

    if round.playing then
        return
    end
    
    print("A new round has been started.")

    round.prep = true

    // Players setup

    choosen_satan = math.random(0, player.GetCount()-1)
    choosen_pistol = math.random(0, player.GetCount()-1)
    choosen_crossbow = math.random(0, player.GetCount()-1)

    total_males = math.Round(player.GetCount()/2)

    while (choosen_crossbow == choosen_satan) or (choosen_crossbow == choosen_pistol) do
        choosen_crossbow = math.random(0, player.GetCount()-1)
    end

    math.randomseed(CurTime())
    players = player.GetAll()

    players = shuffle(players)

    for i, ply in ipairs(players) do
        
        local info = {}
        info.powerup = "None"
        info.canpickcrossbow = true
        info.name = ply:Name()
        info.staminamax = 100
        info.stamina = 1

        ply:UnSpectate()
        ply:StripWeapons()
        ply:SetNoCollideWithTeammates(false)

        ply:Give("weapon_dh_hands")
        ply:Give("weapon_fists")

        if total_males > 0 then
            total_males = total_males - 1
            info.male = true
        else
            info.male = false
        end

        net.Start("YouAre")

            if i-1 == choosen_satan then
                net.WriteBool(true)
                ply:Give("weapon_dh_sacrificeknife")
                ply:SetTeam(1)
                info.canpickcrossbow = false
                info.class = 1
            else
                net.WriteBool(false)
                ply:SetTeam(2)
                info.class = 2
            end
        
            if i-1 == choosen_pistol then
                ply:Give("weapon_dh_pistol")
                net.WriteBool(true)
                info.powerup = "Pistol"
            else
                net.WriteBool(false)
            end

            if i-1 == choosen_crossbow then
                ply:Give("weapon_dh_crossbow")
                ply:SetAmmo(1, "XBowBolt")
                net.WriteBool(true)
                info.powerup = "Crossbow"
            else
                net.WriteBool(false)
            end

        net.Send(ply)

        ply:SetDHInfo(info)
        ply:Spawn()
        ply:Freeze(true)
    end

    round.playing = true
    round.midnight = false
    round.timer = -5
    round.midnigthtimer = GetConVar("dh_midnighttimer"):GetInt()
    round.number = round.number + 1
    round.prep = false

    net.Start("RoundInfo")
        net.WriteString("start")
    net.Broadcast()

    SetClockRotation(0)
    
    timer.Create("RoundTimer", 1, 0, RoundTimer)
    timer.Simple(4.5, function()
        for i, ply in pairs(player.GetAll()) do
            ply:Freeze(false)
        end
    end)

end

function RoundTimer()

    round.timer = round.timer + 1

    net.Start("ClockTimer")
        net.WriteInt(round.timer, 32)
    net.Broadcast()

    SetClockRotation(round.timer / round.midnigthtimer)

    hook.Call("DHOnTimerTick")

    if round.timer >= round.midnigthtimer then
        RoundMidnight()
        return
    end

end

function RoundMidnight()

    timer.Pause("RoundTimer")
    round.midnight = true
    
    local plystochat = {}
    local msg = FormatChat(":white You were an :deepblue innocent soul :white \n Now you have :red reborn :white as an revenge demon!")

    for k, v in pairs(player.GetAll()) do
        if (v:Team() ~= 1) and (v:Team() ~= 3) then continue end
        v:SetNoCollideWithTeammates(true)
        
        // Spawn new demons
        if (v:Team() == 1) then continue end
        table.insert(plystochat, v)
        v:Give("weapon_dh_sacrificeknife")
        v:Spawn()
    end

    SendChat(msg, plystochat)

    net.Start("RoundInfo")
        net.WriteString("midnight")
    net.Broadcast()

    timer.Create("MidnigthVoices", 12, 0, function()
    
        net.Start("MidnigthEvent")
            net.WriteString("voices")
        net.Broadcast()

    end)

end

function RoundCheckConditions()

    local goodAlive = 0
    local badAlive = 0

    for k, v in pairs(player.GetAll()) do

        if v:Team() == 1 and v:Alive() then
            badAlive = badAlive + 1
        elseif v:Team() == 2 and v:Alive() then
            goodAlive = goodAlive + 1
        end

    end

    if badAlive <= 0 then
        // Good wins

        RoundEnd(1)
        return 
    elseif goodAlive <= 0 then
        // Bad wins

        RoundEnd(-1)
        return 
    end

end

function RoundEnd(winner)
    winner = winner or 0

    if(timer.Exists("RoundTimer")) then
        timer.Remove("RoundTimer")
    end
    
    if(timer.Exists("MidnigthVoices")) then
        timer.Remove("MidnigthVoices")
    end
    
    if !round.playing then
        return
    end

    print("The round has ended!")

    round.playing = false
    round.timer = 0

    local txt1 = {}

    local txt2 = FormatChat("has won! :white The :red demon :white was")
    table.insert(txt2, Color(255,0,0))
    table.insert(txt2, " " .. GetDHSatan().name)
    table.insert(txt2, Color(255,255,255))
    table.insert(txt2, ".")

    net.Start("RoundInfo")
        if winner == 0 then
            net.WriteString("end")
        elseif winner == 1 then
            net.WriteString("goodend")
            txt1 = FormatChat(":deepblue Good")
        else
            net.WriteString("badend")
            txt1 = FormatChat(":red Bad")
        end
    net.Broadcast()

    local finaltxt = table.Add(txt1, txt2)

    if winner ~= 0 then SendChat(finaltxt, player.GetAll()) end

    hook.Call("DHOnRoundEnd")

    timer.Create("RestartRound", 8, 1, function()
        RoundRestart()
    end)

end