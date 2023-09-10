function GTowerAchievements:GetData( ply )

	if !ply._Achievements then
		return
	end

	local Data = Hex()

	for k, v in pairs( ply._Achievements ) do
		Data:SafeWrite( k )
		Data:SafeWrite( math.floor( v ) )
	end

	return Data:Get()

end

function GTowerAchievements:NetworkUpdate( ply, id )

	if !ply._AchievementNetwork then
		ply._AchievementNetwork = { id }

	elseif !table.HasValue( ply._AchievementNetwork, id ) then
		table.insert( ply._AchievementNetwork, id )

	end

	ClientNetwork.AddPacket( ply, "AchievementNetwork", GTowerAchievements.PlayerNetworkSend )

end


function GTowerAchievements:Load( ply, val )

	ply._Achievements = {}

	local Data = Hex( val )

	while Data:CanRead( 1 ) do

		local k = Data:SafeRead()
		local v = Data:SafeRead()

		if k then
			ply._Achievements[ k ] = v or 0
		end

	end

end
