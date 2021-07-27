util.AddNetworkString( "MEDIAPLAYER.VoteMedia" )
util.AddNetworkString( "MEDIAPLAYER.Voteskip" )
util.AddNetworkString( "MEDIAPLAYER.RequestListen" )
util.AddNetworkString( "MEDIAPLAYER.RequestUpdate" )
util.AddNetworkString( "MEDIAPLAYER.RequestMedia" )
util.AddNetworkString( "MEDIAPLAYER.RequestPause" )
util.AddNetworkString( "MEDIAPLAYER.RequestSkip" )
util.AddNetworkString( "MEDIAPLAYER.RequestSeek" )
util.AddNetworkString( "MEDIAPLAYER.RequestRemove" )
util.AddNetworkString( "MEDIAPLAYER.RequestRepeat" )
util.AddNetworkString( "MEDIAPLAYER.RequestShuffle" )
util.AddNetworkString( "MEDIAPLAYER.RequestLock" )

local REQUEST_DELAY = 0.2

local function RequestWrapper( func )
	local nextRequest
	return function( len, ply )
		if not IsValid(ply) then return end

		if nextRequest and nextRequest > RealTime() then
			return
		end

		local mpId = net.ReadString()
		local mp = MediaPlayer.GetById(mpId)
		if not IsValid(mp) then return end

		func( mp, ply )

		nextRequest = RealTime() + REQUEST_DELAY
	end
end

local songpick

net.Receive( "MEDIAPLAYER.VoteMedia", RequestWrapper(function(mp, ply)

	if (ply:Location() != Location.Find(mp.Entity:GetPos())) then return end

	if songpick == nil then
		songpick = MediaPlayer.VoteManager:New( mp )
	end

	if songpick:HasVoted( ply ) then
		songpick:RemoveVote( mp, ply )
	else
		songpick:AddVote( mp, ply, value )
		ply:ChatPrint(songpick:GetVoteCountForMedia( mp, forceCalc ))
	end

end) )

local MediaVoteSkip

net.Receive( "MEDIAPLAYER.Voteskip", RequestWrapper(function(mp, ply)

	if (ply:Location() != Location.Find(mp.Entity:GetPos())) then return end

	local LastMediaLocation = ply:Location()

	if (MediaVoteSkip == nil || LastMediaLocation != ply:Location()) then
		MediaVoteSkip = MediaPlayer.VoteskipManager:New( mp, ratio )
	end

	if MediaVoteSkip:HasVoted( ply ) then
		MediaVoteSkip:RemoveVote( ply )
	else
		MediaVoteSkip:AddVote( ply, 1 )
		VoteSkipAnnounce(ply,Location.GetPlayersInLocation( ply:Location() ))
	end

	if MediaVoteSkip:ShouldSkip( #Location.GetPlayersInLocation( ply:Location() ) ) then
		mp:OnMediaFinished()
		MediaVoteSkip:Clear()
	end

end) )

function VoteSkipAnnounce(ply,location)
	for k,v in pairs(location) do
		if MediaVoteSkip:GetNumRemainingVotes( #location ) == 0 then
			--v:ChatPrint(ply:Nick().." has voted to skip the song ("..MediaVoteSkip:GetNumVotes().."/"..#location..") Votes. SKIPPED")
			v:ChatPrint( T( "Theater_PlayerVoteSkipped", ply:Nick(), MediaVoteSkip:GetNumVotes(), #location ) .. " SKIPPED" )
		else
			--v:ChatPrint(ply:Nick().." has voted to skip the song ("..MediaVoteSkip:GetNumVotes().."/"..#location..") Votes. "..MediaVoteSkip:GetNumRemainingVotes( #location ).." more votes need to skip.")
			v:ChatPrint( T( "Theater_PlayerVoteSkipped", ply:Nick(), MediaVoteSkip:GetNumVotes(), #location ) .. " " .. MediaVoteSkip:GetNumRemainingVotes( #location ) .. " more votes need to skip." )
		end
	end
end

net.Receive( "MEDIAPLAYER.RequestListen", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestListen:", mpId, ply)
	end

	-- TODO: check if listener can actually be a listener
	if mp:HasListener(ply) then
		mp:RemoveListener(ply)
	else
		mp:AddListener(ply)
	end

end) )

---
-- Event called when a player requests a media update. This will occur when
-- a client determines it's not synced correctly.
--
-- @param len Net message length.
-- @param ply Player who sent the net message.
--
net.Receive( "MEDIAPLAYER.RequestUpdate", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestUpdate:", mpId, ply)
	end

	mp:SendMedia( mp:GetMedia(), ply )

end) )

net.Receive( "MEDIAPLAYER.RequestMedia", RequestWrapper(function(mp, ply)

	local url = net.ReadString()

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestMedia:", url, mp:GetId(), ply)
	end

	local allowWebpage = MediaPlayer.Cvars.AllowWebpages:GetBool()

	if Location.IsNightclub( ply:Location() ) then
		allowWebpage = false // Prevent webpage requests in the Nightclub
	end

	-- Validate the URL
	if not MediaPlayer.ValidUrl( url ) and not allowWebpage then
		ply:ChatPrint( "The requested URL wasn't valid." )
		return
	end

	-- Build the media object for the URL
	local media = MediaPlayer.GetMediaForUrl( url, allowWebpage )
	media:NetReadRequest()

	mp:RequestMedia( media, ply )

end) )

net.Receive( "MEDIAPLAYER.RequestPause", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestPause:", mp:GetId(), ply)
	end

	mp:RequestPause( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestSkip", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestSkip:", mp:GetId(), ply)
	end

	mp:RequestSkip( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestSeek", RequestWrapper(function(mp, ply)

	local seekTime = net.ReadInt(32)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestSeek:", mp:GetId(), seekTime, ply)
	end

	mp:RequestSeek( ply, seekTime )

end) )

net.Receive( "MEDIAPLAYER.RequestRemove", RequestWrapper(function(mp, ply)

	local mediaUID = net.ReadString()

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestRemove:", mp:GetId(), mediaUID, ply)
	end

	mp:RequestRemove( ply, mediaUID )

end) )

net.Receive( "MEDIAPLAYER.RequestRepeat", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestRepeat:", mp:GetId(), ply)
	end

	mp:RequestRepeat( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestShuffle", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestShuffle:", mp:GetId(), ply)
	end

	mp:RequestShuffle( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestLock", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestLock:", mp:GetId(), ply)
	end

	mp:RequestLock( ply )

end) )
