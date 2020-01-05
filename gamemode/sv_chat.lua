function SendChat(args, players)

    if players == nil then
        return
    end

    net.Start("Chat")
        net.WriteTable(args)
    net.Send(players)

end

function FormatChat(args)

    if args == nil then return {} end

    local final = string.Split(args, " ")

    for k, v in ipairs(final) do
        
        if v == ":red" then
            final[k-1] = Color(255,0,0)
            continue
        end

        if v == ":blue" then
            final[k-1] = Color(0,0,255)
            continue
        end

        if v == ":deepblue" then
            final[k-1] = Color(0,191,255)
            continue
        end

        if v == ":white" then
            final[k-1] = Color(255,255,255)
            continue
        end

        final[k-1] = " " .. v


    end

    table.remove(final, #final)

    return final

end