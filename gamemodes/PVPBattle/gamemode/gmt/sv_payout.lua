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
			if k == 1 then payout.Give( ply, "Rank1" ) end
			if k == 2 then payout.Give( ply, "Rank2" ) end
			if k == 3 then payout.Give( ply, "Rank3" ) end
		end

		if ply._HackerAmt >= 1 then
			payout.Give( ply, "Headshot" )
		end

		payout.Payout( ply )

	end

end