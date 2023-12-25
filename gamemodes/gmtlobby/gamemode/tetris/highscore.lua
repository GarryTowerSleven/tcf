local _G = _G
local tonumber = tonumber
local player = player
local math = math
local pairs = pairs
local Database = Database

include("network.lua")
include("chat.lua")
AddCSLuaFile("cl_init.lua")

module("tetrishighscore")

HighScore = {}

local function HigherPoints( Points )
	if #HighScore < 10 then
		return true
	end

	for _, v in pairs( HighScore ) do
		if Points >= v[3] then
			return true
		end
	end
	return false
end

_G.hook.Add("TetrisEnd", "SQLTetrisGetHighScore", function( ply, ent )

	local Points = ent.Points
	local PlyPoints = Get( ply )

	local Money = math.floor( Points / 4 )

	if Money > 24 then
		if Points > 500 then
			Money = Money + 200
		end
		ply:AddMoney( Money, nil, nil, nil, "Tetris" )
	end

	if tonumber(Points) > tonumber(PlyPoints) then
		Set( ply, tonumber(Points) )

		Database.SavePlayer( ply, { "tetrisscore" } )
	end

	if HigherPoints( Points ) == true then
		GetHighScore()
	end

end )

function Set( ply, points )
	ply._TetrisHighScore = points
end

function Get( ply )
	return ply._TetrisHighScore or 0
end

function RefreshHighScore( res, status, err )
	if status != QUERY_SUCCESS then
		return
	end

	//So much for this, nothing else to do.
	HighScore = res

	for _, v in pairs( HighScore ) do
		v.id = tonumber( v.id )
		v.tetrisscore = tonumber( v.tetrisscore )
	end

	for _, v in pairs( player.GetAll() ) do
		SendNetworkPackets( v )
	end

end

function GetHighScore()
	Database.Query( "SELECT `id`,`name`,`tetrisscore` FROM `gm_users` WHERE `tetrisscore` > 0 ORDER BY `tetrisscore` DESC LIMIT 0,10", RefreshHighScore )
end

_G.hook.Add( "DatabaseConnected", "GetHighScores", GetHighScore )
