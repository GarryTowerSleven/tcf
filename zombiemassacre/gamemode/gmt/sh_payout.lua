-----------------------------------------------------
payout.Register( "ThanksForPlaying", {

	Name = "Thanks For Playing",

	Desc = "For participating in the game!",

	GMC = 100,

} )



payout.Register( "BossDefeat", {

	Name = "Defeated The Boss",

	Desc = "You got that giant monster!",

	GMC = 150,

	Diff = 3,

} )



/*payout.Register( "BossDamageTier1", {

	Name = "Boss Destroyer",

	Desc = "Dealt the most damage on the boss!",

	GMC = 200,

	Diff = 4,

} )



payout.Register( "BossDamageTier2", {

	Name = "Boss Master",

	Desc = "Dealt the 2nd most damage on the boss.",

	GMC = 125,

	Diff = 4,

} )



payout.Register( "BossDamageTier3", {

	Name = "Boss Handler",

	Desc = "Dealt the 3rd most damage on the boss.",

	GMC = 50,

	Diff = 4,

} )*/



payout.Register( "Points", {

	Name = "Total Points",

	Desc = "Bonus for earning points.",

	GMC = 0,

	Diff = 2,

} )



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

			payout.Give( ply, "Points", math.Round( ply:GetNWInt( "Points" ) * .25 ) )

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
