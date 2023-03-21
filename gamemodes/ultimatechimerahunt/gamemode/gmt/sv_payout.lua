function GAMEMODE:GiveMoney()

	if CLIENT then return end

	local PlayerTable = player.GetAll()
	local teamid = self.WinningTeam

	// Payout
	for _, ply in ipairs( PlayerTable ) do

		payout.Clear( ply )
		
		// Chimera won
		if teamid == TEAM_CHIMERA then

			if ply:GetNWBool("IsChimera") then

				payout.Give( ply, "UCWinBonus" )

				if ply.HighestKilledRank then
					payout.Give( ply, "UCRank" .. ply.HighestKilledRank )
				end

			end

		// Pigs won
		elseif teamid == TEAM_PIGS then

			// Alive players get more bonus
			if ply:Team() == TEAM_PIGS then

				payout.Give( ply, "WinBonus" )

				if ply:GetNWBool("PressedButton") then
					payout.Give( ply, "ButtonPress" )
				end

				payout.Give( ply, "Rank" .. ply:GetNWInt("Rank") )

			// You died during play, half of the winning bonus for you
			elseif ply:Team() == TEAM_GHOST then

				payout.Give( ply, "WinBonusGhost" )

			end

			if #team.GetPlayers( TEAM_PIGS ) == 1 then
				payout.Give( ply, "UCLastPig" )
			end

		end

		// Chimera gets paid a little more for more action
		if ply:GetNWBool("IsChimera") then

			local deadpigs = #team.GetPlayers( TEAM_GHOST )
			if deadpigs > 0 then
				payout.Give( ply, "UCDeadPigs", ( deadpigs * 15 ) )
			end

		end

		payout.Payout( ply )

	end

end