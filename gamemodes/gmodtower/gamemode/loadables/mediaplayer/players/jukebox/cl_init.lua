include "shared.lua"

local BaseClass = baseclass.Get( "mp_entity" )

local IsValid = IsValid
local MediaPlayer = MediaPlayer

MEDIAPLAYER.Enable3DAudio = false

function MEDIAPLAYER:NetReadUpdate()
	BaseClass.NetReadUpdate( self )

	self._hasVoteskipped = net.ReadBool()
end

function MEDIAPLAYER:OnNetReadMedia( media )
	local voteCount = self.net.ReadVote()
	media:SetMetadataValue( "votes", voteCount )

	local plyVote = self.net.ReadVote()
	media:SetMetadataValue( "localVote", plyVote )
end

function MEDIAPLAYER:HasVoteskipped()
	return self._hasVoteskipped
end
