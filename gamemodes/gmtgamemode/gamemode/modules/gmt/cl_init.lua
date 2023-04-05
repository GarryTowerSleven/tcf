usermessage.Hook( "ShowScores", function( um )

	local display = um:ReadBool()

	hook.Call( "ShowScores", GAMEMODE )
	
	if display then
		RunConsoleCommand( "gmt_showscores", 1 )
		RunConsoleCommand( "-attack" )
	else
		RunConsoleCommand( "gmt_showscores" )
		RunConsoleCommand( "r_cleardecals" )
	end

end )