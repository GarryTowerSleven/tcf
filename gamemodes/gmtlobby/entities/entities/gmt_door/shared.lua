ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true

ENT.DelayTime = 0.75 //how long until the screen begins to fade
ENT.FadeTime = 0.25 //how long it takes to fade completely
ENT.WaitTime = 0.3 //period for it to stay completely black

ENT.OpenSound = Sound("sunabouzu/private_door_open.wav")
ENT.CloseSound = Sound("sunabouzu/private_door_close.wav")

ENT.OpenSoundRoulette = Sound("gmodtower/lobby/club/club_roulette_door_open.wav")
ENT.CloseSoundRoulette = Sound("gmodtower/lobby/club/club_roulette_door_close.wav")

ENT.ExitSoundRoulette = Sound("gmodtower/lobby/club/club_roulette_door_open2.wav")
ENT.OpenSoundRouletter = Sound("gmodtower/lobby/club/club_rouletter_door_open.wav")

function ENT:CanUse( ply )
	return true, "ENTER"
end
