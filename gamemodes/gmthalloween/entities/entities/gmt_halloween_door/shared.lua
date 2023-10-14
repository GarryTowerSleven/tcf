ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.BoundsMin = Vector( -4, -48, 0 )
ENT.BoundsMax = Vector( 0, 48, 112 )

ENT.DoorTime = 0.5
ENT.DelayTime = 1.0

function ENT:CanUse( ply )
    return true, "ENTER"
end