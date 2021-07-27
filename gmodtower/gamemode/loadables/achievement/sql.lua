
hook.Add("SQLStartColumns", "SQLLoadAchievements", function()
	SQLColumn.Init( {
		["column"] = "achivement",
		["selectquery"] = "HEX(achivement) as achivement",
		["selectresult"] = "achivement",
		["update"] = function( ply )
			return GTowerAchievements:GetData( ply )
		end,
		["defaultvalue"] = function( ply )
			GTowerAchievements:Load( ply, 0x0 )
		end,
		["onupdate"] = function( ply, val )
			GTowerAchievements:Load( ply, val )
		end,
		["UnimportantUpdate"] = true
	} )
end )

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
