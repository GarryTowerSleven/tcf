payout.Register( "ThanksForPlaying", {
	Name = "Thanks For Playing",
	Desc = "For participating in the game!",
	GMC = 25,
} )

payout.Register( "HoleInOne", {
	Name = "Hole In One!",
	Desc = "A perfect putt.",
	GMC = 150,
} )

payout.Register( "OverBogey", {
	Name = "Over Double Bogey",
	Desc = "You do know the goal is to get\nthe lowest score, right?",
	GMC = 10,
} )

local MoneyScores = {
	[-4] = { 140, "Way to soar!" },
	[-3] = { 130, "Really well done!" },
	[-2] = { 120, "Fly like an eagle." },
	[-1] = { 110, "Early bird gets the worm." },
	[0] = { 100, "Just average." },
	[1] = { 50, "Not bad. Try lowering your putt amounts." },
	[2] = { 25, "You can do better." },
}

for k, score in pairs( MoneyScores ) do
	
	payout.Register( Scores[k], {
		Name = string.Uppercase( Scores[k] ), // .. " (" .. k .. ")",
		Desc = score[2],
		GMC = score[1],
	} )

end

function GAMEMODE:GiveMoney()

	if CLIENT then return end

	for _, ply in pairs( player.GetAll() ) do

		payout.Clear( ply )

		local swing = ply:Swing()
		local pardiff = ply:GetParDiff( swing )

		if swing == 1 then
			payout.Give( ply, "HoleInOne" )
		else		
			if MoneyScores[pardiff] then
				payout.Give( ply, Scores[ pardiff ] )
			end
		end

		if pardiff > 2 then
			payout.Give( ply, "OverBogey" )
		end

		payout.Payout( ply )

	end

end