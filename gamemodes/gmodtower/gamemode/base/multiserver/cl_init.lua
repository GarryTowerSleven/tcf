---------------------------------
include("shared.lua")

usermessage.Hook("MServ", function(um)

	local MsgId = um:ReadChar()

	if MsgId == 0 then
		
		local ip = um:ReadString()
		local port = um:ReadString()
		local password = um:ReadString()
		
		Msg( string.format( "Redirecting you to: %s:%d (password: %s)", ip, tonumber( port ), password ) )
		
		GTowerServers:ConnectToServer( ip, port, password )

	end
	
end )

net.Receive( "MultiserverJoinRemove", function( len, ply )
	local enabled = net.ReadInt( 2 )

	if enabled == 1 then
		LocalPlayer()._QueuedGamemode = net.ReadString() or nil
	else
		LocalPlayer()._QueuedGamemode = nil
	end

	hook.Call( "GMTClientGamemodeChange", GAMEMODE, LocalPlayer()._QueuedGamemode != nil, LocalPlayer()._QueuedGamemode )
end )


function GTowerServers:ConnectToServer( ip, port, password )

	print(ip, port, password)
	RunConsoleCommand("password", password )
	LocalPlayer():ConCommand( string.format("connect %s:%d", ip, tonumber(port)) )

end