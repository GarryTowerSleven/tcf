AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.CollisionBounds = {
    min = Vector( -20, -20, 0 ),
    max = Vector( 20, 20, 72 ),
}

ENT.EnemyHealth = 60
ENT.Damage = 30
ENT.SwingTime = 0.6
ENT.AttackRange = 30
ENT.AttackSize = 30

ENT.Speed = 140


ENT.AttackSequenceSpeed = 0.8
ENT.AttackSequence = {
    "Melee",
    "Melee_01",
}