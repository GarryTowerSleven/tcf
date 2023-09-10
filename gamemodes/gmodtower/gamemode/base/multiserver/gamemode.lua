---------------------------------
local LastThink = 0
local InQuery = false

local function GoMapResult(res, status, err)
	InQuery = false

	if status != QUERY_SUCCESS then
		return
	end

	if table.Count( res ) == 0 then
		return
	end

	local Result = string.lower( res[1].authplayers )

	--PrintTable(res[1].data[1])

	for k,v in ipairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTCONSOLE, "Got gomap to " .. Result)
	end

	//if Result != game.GetMap() then //Change map anyway
	--ChangeLevel( Result, 0.25 )
	timer.Simple(0.25,function()
		hook.Call("LastChanceMapChange", GAMEMODE, Result)
		RunConsoleCommand("gmt_forcelevel", Result)
	end)

	//end

	file.Write("authedusers" .. tostring(GTowerServers:GetServerId()) .. ".txt", res[1].gomap, "DATA")

	Database.Query( "DELETE FROM `gm_gomap` WHERE `serverid` = " .. GTowerServers:GetServerId() .. ";" )

end

hook.Add("DatabaseConnected", "MultiServerBufferMap", function()

	hook.Add("Think", "BufferGoMap", function()
		//Worse thing ever made in the whole tower

		local Gamemode = GTowerServers:Self()

		if !Gamemode || Gamemode.Private != true then
			//Msg("Removing map buffer since server is public\n")
			hook.Remove("Think", "BufferGoMap")
		end

		if  GTowerServers:GetState() != 1 || InQuery == true then
			return
		end

		if LastThink > CurTime() then
			return
		end

		LastThink = CurTime() + 0.5

		InQuery = true

		Database.Query( "SELECT authplayers, HEX(`gomap`) as `gomap` FROM `gm_gomap` WHERE `serverid` = " .. GTowerServers:GetServerId() .. ";", GoMapResult )

	end )
	
end )

function GTowerServers:GetRandomMap()

	local Gamemode = GTowerServers:Self()

	if Gamemode && Gamemode.Maps then
		return Gamemode.Maps[ math.random( 1, #Gamemode.Maps ) ]
	end

end

concommand.Add("gmt_mapbufferinquery", function( ply, cmd, args )

	if ply == NULL then
		Msg( "Query in : " , InQuery , "\n")
	end

end )
