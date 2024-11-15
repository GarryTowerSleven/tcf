payout.Register( "ThanksForPlaying", {
	Name = "Thanks For Playing",
	Desc = "For participating in the game!",
	GMC = 50,
} )

payout.Register( "FirstInfectedBonus", {
	Name = "First Infected",
	Desc = "You successfully spread the virus as patient zero.",
	GMC = 50,
	Diff = 2,
} )

payout.Register( "InfectedBonus", {
	Name = "Spread the Infection",
	Desc = "You helped spread the infection.",
	GMC = 25,
	Diff = 2,
} )

payout.Register( "SurvivorBonus", {
	Name = "Survived the Infection",
	Desc = "You didn't get infected with the virus.",
	GMC = 50,
	Diff = 2,
} )

payout.Register( "LastSurvivorBonus", {
	Name = "Last Survivor",
	Desc = "Cold Blooded.\nYou were the only remaining survivor and you lived!",
	GMC = 100,
	Diff = 3,
} )

payout.Register( "TeamPlayer", {
	Name = "Team Player",
	Desc = "Survived with 3 or more survivors.",
	GMC = 25,
	Diff = 3,
} )

payout.Register( "Kills", {
	Name = "Kills",
	Desc = "Bonus for killing players (5 GMC each).", 
	GMC = 0,
	Diff = 4,
} )

payout.Register( "Rank1", {
	Name = "1st Place",
	Desc = "For being the top killer.",
	GMC = 50,
	Diff = 5,
} )

payout.Register( "Rank2", {
	Name = "2nd Place",
	Desc = "For being the second top killer.",
	GMC = 25,
	Diff = 5,
} )

payout.Register( "Rank3", {
	Name = "3rd Place",
	Desc = "For being the third top killer.",
	GMC = 10,
	Diff = 5,
} )

function GAMEMODE:GiveMoney( VirusWins )

	if CLIENT then return end

	local PlayerTable = player.GetAll()

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
			payout.Give( ply, "Kills", ply:Frags() * 5 )
			if k == 1 then payout.Give( ply, "Rank1" ) end
			if k == 2 then payout.Give( ply, "Rank2" ) end
			if k == 3 then payout.Give( ply, "Rank3" ) end
		end

		if VirusWins then

			if ply:Team() == TEAM_INFECTED then

				// Give bonus to first infected for winning the round!
				if ply == self.FirstInfected then
					payout.Give( ply, "FirstInfectedBonus" )
				end
				
				if ply != self.LastSurvivor && ply != self.FirstInfected then -- dont give a bonus to the last survivor, they likely racked up kills and got first place
					payout.Give( ply, "InfectedBonus" )
				end
				
			end

		else // Survivors won

			if ply:Team() == TEAM_PLAYERS then

				// Survivors get a bit more
				payout.Give( ply, "SurvivorBonus" )

				// Give the last survivor a bonus!
				if self.HasLastSurvivor && ply == self.LastSurvivor then
					payout.Give( ply, "LastSurvivorBonus" )
				end

				if #team.GetPlayers( TEAM_PLAYERS ) >= 3 then
					payout.Give( ply, "TeamPlayer" )
				end

			end

		end

		payout.Payout( ply )

	end

end