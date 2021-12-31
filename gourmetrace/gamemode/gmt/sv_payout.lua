function GAMEMODE:GiveMoney()

	if CLIENT then return end

		for k, ply in pairs( player.GetAll() ) do

			if ply.AFK then continue end

			payout.Clear( ply )

			local points = ply:GetNWInt("Points")

			if ply:GetNWInt( "Pos" ) > 0 then
				if ply:GetNWInt( "Pos" ) == 1 then payout.Give( ply, "Rank1" ) end
				if ply:GetNWInt( "Pos" ) == 2 then payout.Give( ply, "Rank2" ) end
				if ply:GetNWInt( "Pos" ) == 3 then payout.Give( ply, "Rank3" ) end

				if points > 0 then
					payout.Give( ply, "Collected", math.Clamp( points * 5, 0, (25 * 5) ) )
				end

			end

			if ply:Team() == TEAM_FINISHED then
				payout.Give( ply, "FinishBonus" )
			end

			payout.Payout( ply )
		end

end