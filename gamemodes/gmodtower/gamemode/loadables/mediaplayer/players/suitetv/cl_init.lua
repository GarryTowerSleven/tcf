include "shared.lua"

local BaseClass = baseclass.Get( "mp_entity" )

local IsValid = IsValid
local MediaPlayer = MediaPlayer
local FullscreenCvar = MediaPlayer.Cvars and MediaPlayer.Cvars.Fullscreen

function MEDIAPLAYER:Init(...)
	BaseClass.Init(self, ...)

	hook.Add( "GTowerHUDShouldDraw", self, self.GTowerHUDShouldDraw )
end

function MEDIAPLAYER:Remove()
	hook.Remove( "GTowerHUDShouldDraw", self )

	BaseClass.Remove(self)
end

function MEDIAPLAYER:GTowerHUDShouldDraw()
	if IsValid(self) and FullscreenCvar and FullscreenCvar:GetBool() then
		return false
	end
end