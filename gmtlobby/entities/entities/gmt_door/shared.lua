
-----------------------------------------------------
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true

ENT.Model = Model("models/sunabouzu/theater_door02.mdl")

ENT.DelayTime = 0.75 //how long until the screen begins to fade
ENT.FadeTime = 0.25 //how long it takes to fade completely
ENT.WaitTime = 0.3 //period for it to stay completely black

ENT.OpenSound = Sound("sunabouzu/private_door_open.wav")
ENT.CloseSound = Sound("sunabouzu/private_door_close.wav")

ENT.OpenSoundRoulette = Sound("gmodtower/lobby/club/club_roulette_door_open.wav")
ENT.CloseSoundRoulette = Sound("gmodtower/lobby/club/club_roulette_door_close.wav")

function ENT:CanUse( ply )
	return true, "ENTER"
end
