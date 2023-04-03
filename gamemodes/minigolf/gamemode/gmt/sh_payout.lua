payout.Register( "ThanksForPlaying", {
	Name = "Thanks For Playing",
	Desc = "For participating in the game!",
	GMC = 25,
} )

payout.Register( "HoleInOne", {
	Name = "Hole In One!",
	Desc = "A perfect putt.",
	GMC = 200,
} )

payout.Register( "OverBogey", {
	Name = "Over Double Bogey",
	Desc = "You do know the goal is to get\nthe lowest score, right?",
	GMC = 20,
} )

local MoneyScores = {
	[-4] = { 150, "Way to soar!" },
	[-3] = { 120, "Really well done!" },
	[-2] = { 110, "Fly like an eagle." },
	[-1] = { 100, "Early bird gets the worm." },
	[0] = { 80, "Just average." },
	[1] = { 40, "Not bad. Try lowering your putt amounts." },
	[2] = { 30, "You can do better." },
}

for k, score in pairs( MoneyScores ) do
	
	payout.Register( Scores[k], {
		Name = string.Uppercase( Scores[k] ), // .. " (" .. k .. ")",
		Desc = score[2],
		GMC = score[1],
	} )

end