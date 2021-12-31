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