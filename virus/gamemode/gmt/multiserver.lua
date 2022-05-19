hook.Add("GTowerMsg", "GamemodeMessage", function()

	if GetWorldEntity():GetNet( "Round" ) == 0 then		
		return "#nogame"
	else
		return GAMEMODE:GetTimeLeft() .. "||||" .. tostring( GetWorldEntity():GetNet( "Round" ) ) .. "/" .. GetWorldEntity():GetNet( "MaxRounds" )
	end

end )

function GAMEMODE:EndServer()

	GTowerServers:EmptyServer()
	
end