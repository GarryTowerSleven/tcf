payout.Register( "ThanksForPlaying", {
	Name = "Thanks For Playing",
	Desc = "For participating in the game!",
	GMC = 100,
	Diff = 1,
} )

payout.Register( "Kills", {
	Name = "Kills",
	Desc = "Bonus for killing players (10 GMC each).", 
	GMC = 0,
	Diff = 2,
} )

payout.Register( "Headshot", {
	Name = "Headshot Kills",
	Desc = "Bonus for getting headshot kills (5 GMC each).",
	GMC = 0,
	Diff = 3,
} )

payout.Register( "Rank1", {
	Name = "1st Place",
	Desc = "For being the top killer.",
	GMC = 100,
	Diff = 4,
} )

payout.Register( "Rank2", {
	Name = "2nd Place",
	Desc = "For being the second top killer.",
	GMC = 50,
	Diff = 4,
} )

payout.Register( "Rank3", {
	Name = "3rd Place",
	Desc = "For being the third top killer.",
	GMC = 25,
	Diff = 4,
} )

function GAMEMODE:GiveMoney()

	if CLIENT then return end

	local PlayerTable = player.GetAll()

	// Sort by top scores
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

		if ply:Frags() > 0 then
			payout.Give( ply, "Kills", ply:Frags() * 10 )
			if k == 1 then payout.Give( ply, "Rank1" ) end
			if k == 2 then payout.Give( ply, "Rank2" ) end
			if k == 3 then payout.Give( ply, "Rank3" ) end
		end

		if ply._HackerAmt > 0 then
			payout.Give( ply, "Headshot", ply._HackerAmt * 5 )
			ply._HackerAmt = 0
		end

		payout.Payout( ply )

	end

end