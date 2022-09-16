
local DEBUG = false

GTowerAchievements.PlayerNetworkSend = function( ply )
	
	if #ply._AchievementNetwork == 0 then
		return
	end
	
	local SpaceLeft = 255 - 10
	
	if DEBUG then Msg("Sending to the client: " , ply , "\n") end
	
	umsg.Start( "GTAch", ply )
	
	while #ply._AchievementNetwork > 0 do
				
		local ItemId = table.remove( ply._AchievementNetwork )
		local Item = GTowerAchievements:Get( ItemId )
		local NWData = Item._NWInfo
		
		if DEBUG then Msg( "\tAchievement: ",Item.Name, "\n") end
			
		SpaceLeft = SpaceLeft - NWData[2] - 2
			
		if SpaceLeft < 0 then
			table.insert( ply._AchievementNetwork, ItemId )
			break
		end
			
		local Value = math.floor( ply:GetAchievement( ItemId ) )
			
		if !ply._AchievementSentValues then
			ply._AchievementSentValues = {}
		end
	
		ply._AchievementSentValues[ ItemId ] = Value
			
			
		if NWData[3] then
			Value = Value - NWData[3]
		end
			
		umsg.Short( ItemId )
		umsg[ NWData[1] ]( Value )
			
	end
	
	umsg.End()

	return #ply._AchievementNetwork > 0

end

/*
hook.Add("PlayerThink", "GTowerAchievementNetwork", function(ply)
		
		if ply._AchievementNetwork && #ply._AchievementNetwork > 0 then
			
			local SpaceLeft = 255 - 10
			 
			if DEBUG then Msg("Sending to the client: " , ply , "\n") end
			
			umsg.Start( "GTAch", ply )
			
			while #ply._AchievementNetwork > 0 do
				
				local ItemId = table.remove( ply._AchievementNetwork )
				local Item = GTowerAchievements:Get( ItemId )
				local NWData = Item._NWInfo
				
				if DEBUG then Msg( "\tAchievement: ",Item.Name, "\n") end
				
				SpaceLeft = SpaceLeft - NWData[2] - 2
				
				if SpaceLeft < 0 then
					table.insert( ply._AchievementNetwork, ItemId )
					break
				end
				
				local Value = math.floor( ply:GetAchievement( ItemId ) )
				
				if !ply._AchievementSentValues then
					ply._AchievementSentValues = {}
				end
				ply._AchievementSentValues[ ItemId ] = Value
				
				
				if NWData[3] then
					Value = Value - NWData[3]
				end
				
				umsg.Short( ItemId )
				umsg[ NWData[1] ]( Value )
				
			end
			
			umsg.End()
		
		end

end )
*/