local hook = hook
local CurTime = CurTime
local tmysql = tmysql
local IsValid = IsValid
local tonumber = tonumber
local Msg = Msg
local umsg = umsg
local SQLLog = SQLLog
local ChatCommands = ChatCommands
local SQL = SQL
local pairs = pairs

module("tetrishighscore")

if !ChatCommands then
	SQLLog( 'error', "Chat commands module not loaded, /tetris commands will be unavailable\n" )
	return
end

ChatCommands.Register( "/tetris", 5, function( ply )
	SQL.getDB():Query( "SELECT COUNT(*) FROM gm_users WHERE `tetrisscore`>" .. Get( ply ), function(res)
		local Position = ( res[1].data[1]["COUNT(*)"] + 1 )
		ply:ChatPrint( "Tetris: "..ply:Name().. " is #" .. Position.. " in tetris." )
	end )
	return ""
end )
