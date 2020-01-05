local meta = FindMetaTable("Player")
PlayerInfo = {}

--[[

    Default informations:
        name                :       Initial name of the player
        powerup             :       Says the powerup
        canpickcrossbow     :       Able to pick up the crossbow
        male                :       Is male?
        class               :       Initial class (team number)
        willrespawn         :       Will respawn at midnight?
        stamina             :       How much stamina the player have

]]

function GetDHSatan()

    for k, v in pairs(PlayerInfo) do
        
        if v.class == 1 then
            return v
        end

    end

end

function meta:SetDHStamina( stamina )

    stamina = math.Clamp(stamina, 0, 1)

    PlayerInfo[self:EntIndex()].stamina = stamina

end

function meta:SetDHDefault( stamina )

    local info = {}
    info.name = self:Name()
    info.powerup = ""
    info.canpickcrossbow = false
    info.male = true
    info.class = 2
    info.willrespawn = false
    info.stamina = 1

end

function meta:SetDHInfo( info )

    PlayerInfo[self:EntIndex()] = info

end

function meta:SetDHCrossbowAble( able )

    PlayerInfo[self:EntIndex()].canpickcrossbow = able

end

function meta:SetWillRespawn( spec )
    
    PlayerInfo[self:EntIndex()].willrespawn = spec

end

function meta:GetDHInfo( )
    
    info = PlayerInfo[self:EntIndex()]

    if info ~= nil then
        return info
    else
        return {"no info found."} 
    end 

end

function ResetDHInfo()

    PlayerInfo = {}

end