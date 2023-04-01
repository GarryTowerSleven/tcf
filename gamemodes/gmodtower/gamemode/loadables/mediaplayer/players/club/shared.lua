-- local BaseClass = baseclass.Get( "mp_entity" )

--[[---------------------------------------------------------
	Suite Media Player
-----------------------------------------------------------]]

local MEDIAPLAYER = MEDIAPLAYER
MEDIAPLAYER.Name = "club"
MEDIAPLAYER.Base = "entity"

MEDIAPLAYER.ServiceWhitelist = { 'af', 'sc' }

local BaseClass = baseclass.Get( "mp_entity" )

function MEDIAPLAYER:Init()
	BaseClass.Init(self)

	if SERVER then
		self._TransmitState = TRANSMIT_LOCATION
		self._Location = Location.GetByName( "nightclub" )

		self._Voteskips = {}
		self._VoteManager = MediaPlayer.VoteManager:New( self )
		self._VoteskipManager = MediaPlayer.VoteskipManager:New( self )
	end
end