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
	GMC = 25,
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
	GMC = 50,
	Diff = 3,
} )

payout.Register( "Rank2", {
	Name = "2nd Place",
	Desc = "For completing the level second.",
	GMC = 25,
	Diff = 3,
} )

payout.Register( "Rank3", {
	Name = "3rd Place",
	Desc = "For completing the level third.",
	GMC = 10,
	Diff = 3,
} )

function GAMEMODE:GiveMoney()

	if CLIENT then return end

	--local PlayerTable = player.sqlGetAll()

	for _, ply in pairs( player.GetAll() ) do

		if ply.AFK then continue end

		payout.Clear( ply )

		local placement = ply:GetNet( "CompletedRank" )

		if ply:Team() == TEAM_COMPLETED then
			payout.Give( ply, "Completed" )
		end

		if GAMEMODE.PreviousState == STATE_PLAYING && !ply:GetNWBool("Died") then
			payout.Give( ply, "NoDeath" )
		end

		if ply:GetNWBool("PressedButton") then
			payout.Give( ply, "Button" )
		end

		if placement == 1 then
			payout.Give( ply, "Rank1" )
		elseif placement == 2 then
			payout.Give( ply, "Rank2" )
		elseif placement == 3 then
			payout.Give( ply, "Rank3" )
		end

		if ply:Frags() > 0 then
			if ply:Team() == TEAM_COMPLETED || GAMEMODE.PreviousState == STATE_PLAYINGBONUS then
				payout.Give( ply, "Collected", ply:Frags() * 5 )
			end
		end

		payout.Payout( ply )

	end

end
