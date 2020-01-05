concommand.Add("dh_restartround", function(ply) 

    if ply:IsAdmin() == false then return end

    RoundRestart()
    
end)

concommand.Add("dh_printinfo", function(ply)

    if ply:IsAdmin() == false then return end

    print("Player teams:")

    for i, v in pairs(player.GetAll()) do
        print(v:Name())
        print(table.ToString(v:GetDHInfo(), "Player Info", true))
    end

end)

concommand.Add("dh_savemapclock", function(ply)

    if ply:IsAdmin() == false then return end

    SaveClockFile()

end)
concommand.Add("dh_loadmapclock", function(ply)

    if ply:IsAdmin() == false then return end

    LoadClockFile()

end)
concommand.Add("dh_destroyclock", function(ply)

    if ply:IsAdmin() == false then return end

    for k, v in pairs(ents.FindByClass("demonclock")) do
        v:Remove()
    end

end)