hook.Add("PlayerFootstep", "Footstep System", function(ply, pos, foot, snd, volume, filter)

    local vel = math.Round(ply:GetVelocity():Length())
    
    if vel < 199 then
        return true
    end

end)