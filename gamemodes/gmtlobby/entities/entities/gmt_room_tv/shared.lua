ENT.Base		= "mediaplayer_base"
ENT.Type		= "anim"

ENT.PrintName	= "Television"
ENT.Model		= Model( "models/gmod_tower/suitetv.mdl" )

ENT.SoundOn = clsound.Register( "GModTower/lobby/misc/tv_on.wav" )
ENT.SoundOff = clsound.Register( "GModTower/lobby/misc/tv_off.wav" )

ENT.MediaPlayerType = "suitetv"

local BaseClass = baseclass.Get( "mediaplayer_base" )

function ENT:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar( "String", 1, "Thumbnail" )
end