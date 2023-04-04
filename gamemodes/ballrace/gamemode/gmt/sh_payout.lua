local BananaBonus = 5 // Bonus for the amount of bananas you got

payout.Register( "ThanksForPlaying", {
	Name = "Thanks For Playing",
	Desc = "For participating in the game!",
	GMC = 25,
} )

payout.Register( "Completed", {
	Name = "Completed Level",
	Desc = "For completing the level.",
	GMC = 25,
	Diff = 1,
} )

payout.Register( "Collected", {
	Name = "Collected Bananas",
	Desc = "Bonus for collecting bananas (" .. BananaBonus .. " GMC each).", 
	GMC = 0,
	Diff = 2,
} )

payout.Register( "Button", {
	Name = "Button Master",
	Desc = "Pressed a button.\nThanks for being a team player.", 
	GMC = 15,
	Diff = 2,
} )

payout.Register( "NoDeath", {
	Name = "Didn't Die",
	Desc = "You didn't lose any lives.", 
	GMC = 10,
	Diff = 2,
} )

payout.Register( "Rank1", {
	Name = "1st Place",
	Desc = "For completing the level first.",
	GMC = 100,
	Diff = 3,
} )

payout.Register( "Rank2", {
	Name = "2nd Place",
	Desc = "For completing the level second.",
	GMC = 75,
	Diff = 3,
} )

payout.Register( "Rank3", {
	Name = "3rd Place",
	Desc = "For completing the level third.",
	GMC = 50,
	Diff = 3,
} )