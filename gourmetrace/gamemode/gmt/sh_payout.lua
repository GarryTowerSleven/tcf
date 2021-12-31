-----------------------------------------------------
payout.Register( "ThanksForPlaying", {
	Name = "Thanks For Playing",
	Desc = "For participating in the game!",
	GMC = 25,
} )

payout.Register( "FinishBonus", {
	Name = "Finished",
	Desc = "You finished the race!",
	GMC = 50,
	Diff = 1,
} )

payout.Register( "Rank1", {
	Name = "1st Place!",
	Desc = "Congratulations, you won the race!",
	GMC = 250,
	Diff = 3,
} )

payout.Register( "Rank2", {
	Name = "2nd Place",
	Desc = "Better luck next time!",
	GMC = 150,
	Diff = 3,
} )

payout.Register( "Rank3", {
	Name = "3rd Place",
	Desc = "",
	GMC = 100,
	Diff = 3,
} )

payout.Register( "Collected", {

	Name = "Collected Food",

	Desc = "Bonus for collecting food (5 GMC each up to 25).",

	Diff = 4,

	GMC = 0,
} )


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