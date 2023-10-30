AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.CollisionBounds = {
    min = Vector( -30, -30, 0 ),
    max = Vector( 30, 30, 25 ),
}

ENT.Damage = 10
ENT.SwingTime = 0.775
ENT.AttackRange = 20
ENT.AttackSize = 35
ENT.AttackHeight = 50
ENT.Speed = 180

ENT.AttackSequenceSpeed = 1.75
ENT.AttackSequence = "Attack_2"