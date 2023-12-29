local hook = hook
local CurTime = CurTime
local IsValid = IsValid
local tonumber = tonumber
local Msg = Msg
local umsg = umsg
local SQLLog = SQLLog
local ChatCommands = ChatCommands
local pairs = pairs
local Database = Database
local QUERY_SUCCESS = QUERY_SUCCESS
local print = print

module("tetrishighscore")

if !ChatCommands then
	SQLLog( 'error', "Chat commands module not loaded, /tetris commands will be unavailable\n" )
	return
end

local function rankcommand( ply )

	ply:ChatPrint( "Getting blockles rank..." )

	Database.Query( "SELECT COUNT(*) FROM `gm_users` WHERE `tetrisscore` > " .. Get( ply ) .. ";", function( res, status, err )
	
		if status != QUERY_SUCCESS then
			return
		end

		if IsValid( ply ) then
			
			local pos = ( res[1]["COUNT(*)"] + 1 ) or 0
			ply:ChatPrint( "You are rank #" .. pos.. " in blockles." )

		end

	end )

	return ""

end

ChatCommands.Register( "/tetris", 5, function( ply ) rankcommand( ply ) end )
ChatCommands.Register( "/blockles", 5, function( ply ) rankcommand( ply ) end )
