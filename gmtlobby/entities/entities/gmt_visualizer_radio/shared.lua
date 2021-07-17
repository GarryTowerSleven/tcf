ENT.Base			= "mediaplayer_visualizer"
ENT.Type			= "anim"
ENT.Model			= Model( "models/props/cs_office/radio.mdl")

function ENT:CanUse( ply )
	return true, "REQUEST MUSIC"
end