ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true

ENT.DelayTime = 0.75 //how long until the screen begins to fade
ENT.FadeTime = 0.25 //how long it takes to fade completely
ENT.WaitTime = 0.3 //period for it to stay completely black

function ENT:CanUse( ply )
	return true, "ENTER"
end
