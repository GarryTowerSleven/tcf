include("shared.lua")

concommand.Add("gmt_loadmini", function( ply, cmd, args )
	
	if !ply:IsAdmin() then
		return
	end
	
	local MiniGameStr = args[1]
	if !MiniGameStr then 
		ply:Msg2("gmt_loadmini <gamename>")
		return
	end
	
	local MiniGame = minigames[ MiniGameStr ]
	if !MiniGame then 
		ply:Msg2("Could not find minigame.")
		return 
	end
	
	if MiniGameStr == "obamasmash" then
	
		local locationname = ""
		local flags = ""

		if args[2] == "lobby" then
			locationname = "Lobby"
			flags = "a"
		elseif args[2] == "plaza" then
			locationname = "Entertainment Plaza"
			flags = "b"
		elseif args[2] == "suites" then
			locationname = "Suites"
			flags = ""
		else
			locationname = "Suites"
			flags = ""
		end
		
		for _, v in ipairs(player.GetAll()) do
			v:MsgT( minigames[ MiniGameStr ]._M.MinigameMessage, locationname )
		end
		AdminNotify(T( "AdminMiniStart", ply:GetName(), minigames[ MiniGameStr ]._M.MinigameName or MiniGameStr ))
		SafeCall( MiniGame.Start, flags )
		
	return
	end
	
	for _, v in ipairs(player.GetAll()) do
		v:MsgT( minigames[ MiniGameStr ]._M.MinigameMessage, ( minigames[ MiniGameStr ]._M.MinigameArg1 or "" ), ( minigames[ MiniGameStr ]._M.MinigameArg2 or "" ) )
	end
	AdminNotify(T( "AdminMiniStart", ply:GetName(), minigames[ MiniGameStr ]._M.MinigameName or MiniGameStr ))
	
	/*if MiniGameStr == "obamasmash" then 
		if ( math.random( 0, 1 ) == 0 ) then
			SafeCall( MiniGame.Start, "" )
		else
			SafeCall( MiniGame.Start, "a" )
		end
		return
	end*/
	
	SafeCall( MiniGame.Start, args[2] or "" )
	
end )

concommand.Add("gmt_endmini", function( ply, cmd, args )
	
	if !ply:IsAdmin() then
		return
	end
	
	local MiniGameStr = args[1]
	if !MiniGameStr then 
		ply:Msg2("gmt_loadmini <gamename>")
		return
	end
	
	local MiniGame = minigames[ MiniGameStr ]
	if !MiniGame then 
		ply:Msg2("Could not find minigame")
		return 
	end
	
		AdminNotify(T( "AdminMiniEnd", ply:GetName(), minigames[ MiniGameStr ]._M.MinigameName or MiniGameStr ))

	SafeCall( MiniGame.End )
	
end )

util.AddNetworkString("MinigameMusic")