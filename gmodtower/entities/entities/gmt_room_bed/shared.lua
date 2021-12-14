ENT.Type 			= "anim"
ENT.PrintName 		= "Bed"

ENT.Model			= Model( "models/gmod_tower/suitebed.mdl" )
ENT.SleepSound		= Sound( "GModTower/music/sleep.mp3" )
ENT.HealSound		= Sound( "player/geiger1.wav" )

function ENT:CanUse( ply )
	return true, "SLEEP"
end