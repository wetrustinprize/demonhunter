function createRagdoll(player)

    local seq = {
    "death_01",
    "death_03",
    player:GetSequence()
    }
	
	local OldRagdoll = player:GetRagdollEntity()
	if ( OldRagdoll && OldRagdoll:IsValid() ) then OldRagdoll:Remove() end


	local Ragdoll = ents.Create( "base_entity" )
	Ragdoll:SetGroundEntity ( NULL )	
	Ragdoll:SetModel(player:GetModel())
	Ragdoll:SetPos(player:GetPos()+Vector(0,0,5))
	Ragdoll:SetAngles(player:GetAngles()) 
	Ragdoll:SetVelocity(player:GetVelocity())	
	Ragdoll:SetSkin(player:GetSkin())
	Ragdoll:SetColor(player:GetColor())
	Ragdoll:SetMaterial(player:GetMaterial())
	Ragdoll:SetFlexScale(player:GetFlexScale())
	Ragdoll:SetNoDraw( false )
	Ragdoll:DrawShadow( true )
	Ragdoll:Activate()
	
	
	Ragdoll:SetSequence( table.Random( seq ) )
	Ragdoll:SetPlaybackRate( 1 )	
	Ragdoll.AutomaticFrameAdvance = true
--    Ragdoll:SetCycle(player:GetCycle())
	function Ragdoll:Think()
		self:NextThink( CurTime() )
		return true
	end		
	
	Ragdoll:SetMoveType( MOVETYPE_FLYGRAVITY )
	
	for k,v in pairs(player:GetBodyGroups()) do
		Ragdoll:SetBodygroup(v.id,player:GetBodygroup(v.id))
	end
	
	Ragdoll:Spawn()
	
	Ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	Ragdoll:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	
	Ragdoll.CanConstrain = false
	Ragdoll.GravGunPunt = false
	Ragdoll.PhysgunDisabled = true
	
	local PlayerColor = player:GetPlayerColor()
	Ragdoll.RagColor = Vector(PlayerColor.r, PlayerColor.g, PlayerColor.b)
	
	Ragdoll:SetCreator(player)
	
	Ragdoll:Fire( "BecomeRagdoll", "", 0 )
	player:Spectate( OBS_MODE_DEATHCAM )													//The old death camera!
	player:SpectateEntity( Ragdoll )
	player:SetEyeAngles(Ragdoll:GetAngles()+Angle(0,180,0))
	player:SetPos(Ragdoll:GetPos()+Vector(0,0,20))
	
	return Ragdoll
end