MEDIAPLAYER = {}

include "shared.lua"

local BaseClass = baseclass.Get( "mp_entity" )

local IsValid = IsValid
local MediaPlayer = MediaPlayer

-- Theater should use global sound
MEDIAPLAYER.Enable3DAudio = false

function MEDIAPLAYER:NetReadUpdate()
	BaseClass.NetReadUpdate( self )

	self.screenwidth = net.ReadUInt(32)
	self.screenheight = net.ReadUInt(32)

	self._hasVoteskipped = net.ReadBool()
end

function MEDIAPLAYER:OnNetReadMedia( media )
	local voteCount = self.net.ReadVote()
	media:SetMetadataValue( "votes", voteCount )

	local plyVote = self.net.ReadVote()
	media:SetMetadataValue( "localVote", plyVote )
end

function MEDIAPLAYER:GetOrientation()

	if IsLobbyOne then

		return BaseClass.GetOrientation( self )

	else

		local w, h, pos, ang = self.Entity:GetMediaPlayerPosition()

		-- Override width and height with the networked theater screen info
		w, h = self.screenwidth, self.screenheight

		return w, h, pos, ang

	end

end

function MEDIAPLAYER:HasVoteskipped()
	return self._hasVoteskipped
end

MediaPlayer.Register( MEDIAPLAYER )
MEDIAPLAYER = nil
