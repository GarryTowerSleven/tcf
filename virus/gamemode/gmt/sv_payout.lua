function GAMEMODE:GiveMoney()

	if CLIENT then return end

	local PlayerTable = player.GetAll()
	local survivors = team.GetPlayers( TEAM_PLAYERS )

	// Gather last survivor
	local lastSurvivor = nil
	if #survivors == 1 then
		lastSurvivor = survivors[ 1 ]
	end

	// Sort by best score, not rank
	table.sort( PlayerTable, function( a, b )

		local aScore, bScore = a:Frags(), b:Frags()
		if aScore == bScore then
			return a:Deaths() < b:Deaths()
		end

		return aScore > bScore

	end )

	// Payout
	for k, ply in pairs( PlayerTable ) do

		if ply.AFK then continue end

		payout.Clear( ply )

		self:ProcessRank( ply )

		if ply:Frags() > 0 then
			if k == 1 then payout.Give( ply, "Rank1" ) end
			if k == 2 then payout.Give( ply, "Rank2" ) end
			if k == 3 then payout.Give( ply, "Rank3" ) end
		end

		if self.VirusWins then

			if ply:Team() == TEAM_INFECTED then

				// Give bonus to first infected for winning the round!
				if ply == self.FirstInfected then
					payout.Give( ply, "FirstInfectedBonus" )
				end

				payout.Give( ply, "WinBonus" )

			end

		else // Survivors won

			if ply:Team() == TEAM_PLAYERS then

				// Survivors get a bit more
				payout.Give( ply, "SurvivorBonus" )

				// Give the last survivor a bonus!
				if lastSurvivor && ply == lastSurvivor then
					payout.Give( ply, "LastSurvivorBonus" )
				end

				if #team.GetPlayers( TEAM_PLAYERS ) >= 3 then
					payout.Give( ply, "TeamPlayer" )
				end

				payout.Give( ply, "WinBonus" )

			end

		end

		payout.Payout( ply )

	end

end