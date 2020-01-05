function SetClockRotation( rot )

    for k, v in pairs(ents.FindByClass("demonclock")) do
        v:SetNWInt("TimerPercentage", rot)
    end

end

function LoadClockFile()

    local json = file.Read("demonhunters/clocks/" .. game.GetMap() .. ".txt")
    local clocks = util.JSONToTable(json)

    for k, v in pairs(ents.FindByClass("demonclock")) do
        v:Remove()
    end

    for k, v in pairs(clocks) do

        local clock = ents.Create("demonclock")
        clock:SetPos(v[1])
        clock:SetAngles(v[2])
        clock:Spawn()

    end

end

function SaveClockFile()

    local clocks = {}

    for k, v in ipairs(ents.FindByClass("demonclock")) do

        clocks[k] = { v:GetPos(), v:GetAngles() }

    end

    local json = util.TableToJSON(clocks, false)

    file.Write("demonhunters/clocks/" .. game.GetMap() .. ".txt", json)

end