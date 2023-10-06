local EVENT = {}

EVENT.Base = "BalloonPop"

EVENT.Translation = "MiniGhostGameStart"

EVENT.Entity = "gmt_minigame_ghost"
EVENT.EntityLimit = 25

function EVENT:CreateEntity( pos, lifetime )

    local ent = ents.Create( self.Entity )

    ent:SetPos( pos )

    ent._Event = true
    
    ent._CreationTime = CurTime()
    ent._LifeTime = lifetime or math.Rand( 20, 30 )
    
    ent:Spawn()

    ent:SetForce( math.Rand( 20, 25 ) )

    local ang = ent:GetAngles()
    ang:RotateAroundAxis( ang:Up(), math.random( 0, 360 ) )

    ent:SetAngles( ang )

    local phys = ent:GetPhysicsObject()
    if IsValid( phys ) then
        phys:SetVelocity( Vector( math.Rand( -5, 5 ), math.Rand( -5, 5 ), 0 ) )
        phys:SetAngleVelocity( Vector( 0, 0, math.Rand( 25, 75 ) ) )
    end

    self.LastEntity = CurTime()

    table.insert( self.Entities, ent )

end

minievent.Register( "GhostPop", EVENT )