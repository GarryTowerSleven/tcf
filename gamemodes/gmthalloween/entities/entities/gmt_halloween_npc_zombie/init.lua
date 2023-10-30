AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.CollisionBounds = {
    min = Vector( -16, -16, 0 ),
    max = Vector( 16, 16, 72 ),
}

ENT.EnemyHealth = 40
ENT.Damage = 20
ENT.SwingTime = 0.75
ENT.AttackRange = 25
ENT.AttackSize = 20
ENT.AttackHeight = 50
ENT.Speed = 150

ENT.AttackSequenceSpeed = 0.5
ENT.AttackSequence = {
    "attack01",
    "attack02",
    "attack03",
}