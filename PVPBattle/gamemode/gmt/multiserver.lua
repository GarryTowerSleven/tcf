function GAMEMODE:EndServer()
	GTowerServers:EmptyServer()
	GTowerServers:ResetServer()
end

hook.Add("GTowerMsg", "GamemodeMessage", function()
	if GAMEMODE:GetRoundCount() == 0 then
		return "#nogame"
	else
		return math.ceil( GAMEMODE:GetTimeLeft() / 60 ) .. "/" .. math.ceil(GAMEMODE.DefaultRoundTime/60) .. "||||" .. tostring( GAMEMODE:GetRoundCount() ) .. "/" .. tostring( GAMEMODE.MaxRoundsPerGame )
	end
end )

hook.Add("EndRound", "CountEndRounds", function()
	GAMEMODE:GiveMoney()

	if GAMEMODE:GetRoundCount() == GAMEMODE.MaxRoundsPerGame then
		timer.Simple( 10 - 2.5, function()  GAMEMODE:EndServer() end)
	end
end )

hook.Add("StartRound", "CountStartRounds", function()
	SetGlobalInt( "PVPRoundCount", GAMEMODE:GetRoundCount() + 1 )

	Msg("Starting round! " .. tostring( GAMEMODE:GetRoundCount() ) .. "\n")

	//We are done here, send them back to the main server
	if  GAMEMODE:GetRoundCount() > GAMEMODE.MaxRoundsPerGame then
		return false
	end
end )

/*function GM:GiveMoney()
	local Players = player.GetAll()

	table.sort( Players, function( a, b )
		local aScore, bScore = a:Frags(), b:Frags()

		if aScore == bScore then
			return a:Deaths() < b:Deaths()
		end

		return aScore > bScore
	end )

	local PrizeMoney = { 70, 50, 30 }
	local ThanksForPlaying = 20

	for k, ply in pairs( Players ) do
		local Money = PrizeMoney[ k ] or ThanksForPlaying

		ply:AddMoney( Money )
		ply:AddAchievement( ACHIEVEMENTS.PVPVETERAN, 1 )
		ply:AddAchievement( ACHIEVEMENTS.PVPMILESTONE1, 1 )

		ply._HackerAmt = 0
		ply._TheKid = 0

	end

end*/

hook.Add("PlayerDisconnected", "StopServerEmpty", function(ply)
	if ply:IsBot() || #player.GetBots() > 0 then return end

	//No need to play an empty server, or by yourself
	timer.Simple( 5.0, function()

		local clients = player.GetCount() --gatekeeper.GetNumClients()

		if #player.GetBots() == 0 && clients < 1 && GTowerServers:GetState() != 1 then
			GTowerServers:EmptyServer()
		end

	end )
end )
