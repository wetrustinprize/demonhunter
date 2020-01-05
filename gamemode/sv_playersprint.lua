local CMoveData = FindMetaTable( "CMoveData" )

function CMoveData:RemoveKeys( keys )
	-- Using bitwise operations to clear the key bits.
	local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
	self:SetButtons( newbuttons )
end

function GM:PlayerTick(ply, mvd)

    if ply:Team() == 0 then return end

    local stamina = ply:GetDHInfo().stamina
    local speed = mvd:GetMaxSpeed()
    local health = math.Clamp(ply:Health(), 0, 100)

    local damagepct = (health / 100)

    if mvd:KeyDown( IN_SPEED ) then

        if (stamina <= 0.5 and (not (bit.band(mvd:GetOldButtons(), 131072) == 131072))) or stamina <= 0.1 then

            mvd:SetMaxClientSpeed( speed * 0.625 * damagepct )
            mvd:SetMaxSpeed( speed * 0.625 * damagepct )
            mvd:RemoveKeys( IN_SPEED )

        elseif (mvd:GetVelocity():Length() > 200) then

            mvd:SetMaxClientSpeed( speed * damagepct )
            mvd:SetMaxSpeed( speed * damagepct )

            if ply:Team() == 1 then
                ply:SetDHStamina(stamina - 1/450)
            else
                ply:SetDHStamina(stamina - 1/300)
            end

        end

    else
        mvd:SetMaxClientSpeed( speed * damagepct )
        mvd:SetMaxSpeed( speed * damagepct )
        ply:SetDHStamina(math.Clamp(stamina + 1/500, 0, 1))
    end

    net.Start("SprintValue")
        net.WriteFloat(stamina)
    net.Send(ply)

end