function GAMEMODE:GiveMoney()



	if CLIENT then return end



	local PlayerTable = player.GetAll() --player.sqlGetAll()



	// Sort for boss payout

	/*local SortedPlayerTable

	if self.WonBossRound then



		SortedPlayerTable = table.Copy( PlayerTable )



		table.sort( SortedPlayerTable, function( a, b )

			return a._BossDamage > b._BossDamage

		end )



	end*/



	// Payout

	for _, ply in pairs( PlayerTable ) do


		if ply.AFK then continue end

		payout.Clear( ply )



		if !self.LostRound then

			payout.Give( ply, "Points", math.Round( ply:GetNWInt( "Points" ) * .15 ) )

		end



		if self.WonBossRound then

			if game.GetMap() == "gmt_zm_arena_trainyard01" then
				for k,v in pairs(player.GetAll()) do
					v:AddAchievement( ACHIEVEMENTS.ZMSPIDER, 1 )
				end
			elseif game.GetMap() == "gmt_zm_arena_thedocks01" then
				for k,v in pairs(player.GetAll()) do
					v:AddAchievement( ACHIEVEMENTS.ZMDINO, 1 )
				end
			end

			payout.Give( ply, "BossDefeat" )



			// Players don't like this as it's too luck based.

			/*if SortedPlayerTable[1] == ply then payout.Give( ply, "BossDamageTier1" ) end

			if SortedPlayerTable[2] == ply then payout.Give( ply, "BossDamageTier2" ) end

			if SortedPlayerTable[3] == ply then payout.Give( ply, "BossDamageTier3" ) end*/



		end



		payout.Payout( ply )



	end



end