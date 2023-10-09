AddCSLuaFile "shared.lua"

MEDIAPLAYER = {}

local BaseClass = baseclass.Get( "mp_entity" )

include "shared.lua"

MEDIAPLAYER._IdlescreenData = {
    url = "https://www.youtube.com/watch?v=rnNUGAcbJEk",
    title = "Idlescreen",
    duration = (60*8)+29,
}

function MEDIAPLAYER:CreateIdlescreenMedia( url, title, duration )
    local media = MediaPlayer.GetMediaForUrl( url )

    media._metadata = {
        title = title,
		duration = duration
	}

    media._Idlescreen = true

    return media
end

function MEDIAPLAYER:AddIdlescreen()
    if ( not self:IsQueueEmpty() ) then return end

    local media = self:CreateIdlescreenMedia( self._IdlescreenData.url, self._IdlescreenData.title, self._IdlescreenData.duration )
    self:AddMedia( media )
end

function MEDIAPLAYER:Init()
	BaseClass.Init( self )

    self._TransmitState = TRANSMIT_LOCATION

    self._Voteskips = {}
    self._VoteManager = MediaPlayer.VoteManager:New( self )
    self._VoteskipManager = MediaPlayer.VoteskipManager:New( self )

    self:on( "mediaChanged", function( media )
        self._VoteskipManager:Clear()
        
        // hacky?
        if ( Location.Is( self:GetLocation(), "Theater" ) ) then
            globalnet.SetNet( "CurVideo", media && media:Title() or "Idlescreen" )
        end

        if ( media == nil && self:IsQueueEmpty() ) then
            self:AddIdlescreen()
        end

        if ( not IsValid( media ) or media._Idlescreen ) then return end

        self._VoteManager:ClearVotesForMedia( media )
        MediaPlayer.UpdateMediaVote( self )

        self:NotifyListeners( T( "Theater_VideoRequestedBy", media:OwnerName() or "Unknown" ) )
    end )

    self:on( "mp.events.queueChanged", function( queue )

        // get rid of idlescreen when videos are queued
        local current = self:CurrentMedia()
        if ( not self:IsQueueEmpty() && current && current._Idlescreen == true ) then
            self:OnMediaFinished()
        end
        
    end )

    self:AddIdlescreen()
end

function MEDIAPLAYER:SetTheaterConfig( config )
    self._TheaterConfig = config
    //self._Location = Location.GetIDByName( config.location )
end

function MEDIAPLAYER:NetWriteUpdate( ply )
    BaseClass.NetWriteUpdate( self )

    // send width and height
    net.WriteUInt( self._TheaterConfig.screenwidth or 800, 32 )
    net.WriteUInt( self._TheaterConfig.screenheight or 400, 32 )

    // _hasVoteskipped
    net.WriteBool( self._VoteskipManager:HasVoted( ply ) or false )
end

function MEDIAPLAYER:OnNetWriteMedia( media, ply )
    // votecount
	self.net.WriteVote( media:GetMetadataValue( "votes" ) or 0 )

    // ply vote
	self.net.WriteVote( self._VoteManager:HasVoted( media, ply ) && 1 or -1 )
end

local function queueVoteSort( a, b )
	local avote = a:GetMetadataValue( "votes" ) or 0
	local bvote = b:GetMetadataValue( "votes" ) or 0

    if ( avote == bvote ) then
        local atime = a:GetMetadataValue( "queueTime" )
	    local btime = b:GetMetadataValue( "queueTime" )

	    return atime < btime
    end

    return avote > bvote
end

function MEDIAPLAYER:SortQueue()
	table.sort( self._Queue, queueVoteSort )
end

/*function MEDIAPLAYER:IsPlayerPrivileged( ply )
	if ( ply.IsStaff && ply:IsStaff() ) then
        return true
    end

    return false
end*/

MEDIAPLAYER._MaxDuration = 30*60 // 30 minutes

function MEDIAPLAYER:ShouldQueueMedia( media )
    local owner = media:Owner() or NULL
    if ( owner.IsStaff and owner:IsStaff() ) then return true end

    if ( not media:IsTimed() ) then return false, "Livestreams cannot be queued." end

    local duration = media:Duration() or nil
    if ( not duration ) then return false, T( "Theater_RequestFailed" ) end

    local MaxDuration = self._MaxDuration * ( owner:IsVIP() and 4 or 1 )

    // check duration
    if ( duration > MaxDuration ) then return false, T( "TheaterTooLong" ) end

    for _, v in ipairs( self._Queue ) do
        if ( v.IsOwner && v:IsOwner( owner ) ) then
            return false, "You already have a video in the queue."
        end
    end

    return true
end

MediaPlayer.Register( MEDIAPLAYER )
MEDIAPLAYER = nil