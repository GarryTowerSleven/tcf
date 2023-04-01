AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function MediaPlayer.AddSkip( mp, ply )
    if ( not IsValid( ply ) or not IsValid( mp ) ) then return end
    if ( not mp._VoteskipManager ) then return end

    if ( mp:GetQueueLocked() ) then return end

    local current = mp:CurrentMedia() or nil
    if ( not current ) then return end
    if ( current._Idlescreen ) then return end

    /*if ( current:IsOwner( ply ) ) then
        mp:NotifyListeners( T( "Theater_ForceSkipped", current:OwnerName() ) )
        mp:OnMediaFinished()

        return
    end*/

    if ( mp._VoteskipManager:HasVoted( ply ) ) then return end

    local total = table.Count( mp:GetListeners() ) or 0

    mp._VoteskipManager:AddVote( ply )

    local votes = mp._VoteskipManager:GetNumVotes( total )
    local required = mp._VoteskipManager:GetNumRequiredVotes( total )
    
    mp:NotifyListeners( T( "Theater_PlayerVoteSkipped", ply:Name(), votes, required ) )

    MediaPlayer.CheckSkip( mp, total )
end

function MediaPlayer.CheckSkip( mp, total )
    if ( not IsValid( mp ) ) then return end
    if ( not mp._VoteskipManager ) then return end

    total = total or (table.Count( mp:GetListeners() ) or 0)

    if ( mp._VoteskipManager:ShouldSkip( total ) ) then
        mp:NotifyListeners( T( "Theater_Voteskipped" ) )
        mp:OnMediaFinished()
    end
end

hook.Add( "MediaPlayerRemoveListener", "GMTVoteCheckLeave", function( mp, ply )
    if ( not IsValid( mp ) ) then return end

    if ( mp._VoteskipManager ) then
        MediaPlayer.CheckSkip( mp )
    end

    if ( mp._VoteManager ) then
        MediaPlayer.UpdateMediaVote( mp )
    end
end )

net.Receive( "MEDIAPLAYER.Voteskip", function( len, ply )
    local id = net.ReadString()

    local mp = MediaPlayer.GetById( id ) 
    if ( not mp ) then return end

    if ( mp._VoteskipManager ) then
        MediaPlayer.AddSkip( mp, ply )
    else
        mp:RequestSkip( ply )
    end
end )

util.AddNetworkString( "MEDIAPLAYER.Voteskip" )

function MediaPlayer.UpdateMediaVote( mp, media )
    mp._VoteManager:Invalidate()
    if ( media ) then
        media:SetMetadataValue( "votes", mp._VoteManager:GetVoteCountForMedia( media ) or 0 )
    end

    mp:QueueUpdated()
    mp:BroadcastUpdate()
end

function MediaPlayer.DoVote( ply, mp, uid, value )
    if ( not IsValid( ply ) ) then return end
    if ( not IsValid( mp ) ) then return end
    if ( not mp._VoteManager ) then return end

    local media

    for k, v in pairs( mp._Queue ) do
        if v:UniqueID() == uid then
            media = v
            break
        end
    end

    if ( not media ) then return end

    if ( mp._VoteManager:HasVoted( media, ply ) ) then
        mp._VoteManager:RemoveVote( media, ply )
    else
        mp._VoteManager:AddVote( media, ply, math.Clamp( value, 0, 1 ) )
    end

    MediaPlayer.UpdateMediaVote( mp, media )
end

net.Receive( "MEDIAPLAYER.VoteMedia", function( len, ply )
    local id = net.ReadString()

    local mp = MediaPlayer.GetById( id ) 
    local mediaid = net.ReadString()
    local vote = mp.net.ReadVote()

    MediaPlayer.DoVote( ply, mp, mediaid, vote )
end )

util.AddNetworkString( "MEDIAPLAYER.VoteMedia" )

hook.Add( "PostMediaPlayerMediaRequest", "GMTMediaPlayerPostRequest", function( mp, media, ply )
    if ( not IsValid( mp ) ) then return end

    // Vote for own queued media
    if ( mp._VoteManager && media && media.UniqueID ) then
        MediaPlayer.DoVote( ply, mp, media:UniqueID(), 1 )
    end
end )

/*hook.Add( "MediaPlayerNotifyPlayer", "GMTMediaPlayerNotify", function( mp, ply, msg )
    ply:Msg2( msg )

    return true
end )*/