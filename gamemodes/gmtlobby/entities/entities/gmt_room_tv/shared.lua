ENT.Base		= "gmt_mediaplayer_relay"
ENT.Type		= "anim"

ENT.PrintName	= "Television"
ENT.Model		= Model( "models/gmod_tower/suitetv.mdl" )

ENT.SoundOn = clsound.Register( "GModTower/lobby/misc/tv_on.wav" )
ENT.SoundOff = clsound.Register( "GModTower/lobby/misc/tv_off.wav" )

function ENT:SetupDataTables()
	if self.Base == "gmt_mediaplayer_relay" then
		self.BaseClass.SetupDataTables(self)
	else
		self.BaseClass.BaseClass.SetupDataTables(self)
	end

	self:NetworkVar( "String", 1, "Thumbnail" )
end