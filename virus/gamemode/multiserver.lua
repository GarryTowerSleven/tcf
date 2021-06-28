hook.Add("GTowerMsg", "GamemodeMessage", function()
	if GAMEMODE.CurrentRound == 0 then		
		return "#nogame"
	else
		return GAMEMODE:GetTimeLeft() .. "||||" .. tostring( GAMEMODE.CurrentRound ) .. "/" .. GAMEMODE.NumRounds
	end
end )

function GM:EndServer()

	GTowerServers:EmptyServer()
	GTowerServers:ResetServer()
	
end