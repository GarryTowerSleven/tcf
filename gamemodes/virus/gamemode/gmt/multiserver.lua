hook.Add("GTowerMsg", "GamemodeMessage", function()

	if GAMEMODE:GetRound() == 0 then		
		return "#nogame"
	else
		return GAMEMODE:GetTimeLeft() .. "||||" .. tostring( GAMEMODE:GetRound() ) .. "/" .. globalnet.GetNet( "MaxRounds" )
	end

end )

function GAMEMODE:EndServer()

	GTowerServers:EmptyServer()
	GTowerServers:ResetServer()
	
end