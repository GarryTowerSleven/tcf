include "shared.lua"

local BaseClass = baseclass.Get( "mp_entity" )

-- Play the audio globally
MEDIAPLAYER.Enable3DAudio = false

function MEDIAPLAYER:Draw()
end


--[[--------------------------------------------
	Voting
----------------------------------------------]]

function MEDIAPLAYER:HasVoteskipped()
	return self._hasVoteskipped
end

function MEDIAPLAYER:NetReadUpdate()
	BaseClass.NetReadUpdate( self )

	self._hasVoteskipped = net.ReadBool()
end

function MEDIAPLAYER:OnNetReadMedia( media )
	local voteCount = self.net.ReadVote()
	media:SetMetadataValue("votes", voteCount)

	local plyVote = self.net.ReadVote()
	media:SetMetadataValue("localVote", plyVote)
end