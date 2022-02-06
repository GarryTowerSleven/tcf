function GAMEMODE:EndServer()

	//I guess it it good bye
	GTowerServers:EmptyServer()
	GTowerServers:ResetServer()

	Msg( " !! You are all dead !!\n" )

end