net.Receive("ClockTimer", function()
    
    local round_acttime = net.ReadInt(32)

    hook.Call("DHOnClockTimer", nil, round_acttime)

end)

net.Receive("RoundInfo", function()

    local state = net.ReadString()

    hook.Call("DHOnRoundChangeState", nil, state)

end)

net.Receive("MidnigthEvent", function()

    local event = net.ReadString()

    hook.Call("DHOnMidnigthEvent", nil, event)

end)