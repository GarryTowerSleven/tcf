util.AddNetworkString("UpdateTetrisBoard")
util.AddNetworkString("UpdatePersonalTetrisScore")

local UpdateInterval = 60 * 5
local MaxPlayers = 10

local LatestScores = {}

function NetworkLocalScorePosition(ply, points)
  if !points then points = tonumber(ply._TetrisHighScore) end

  if !points || points <= 0 then return end

  local query = "SELECT COUNT(*) FROM gm_users WHERE `tetrisscore` > " .. points

  SQL.getDB():Query(query, function(res)
    net.Start("UpdatePersonalTetrisScore")
      net.WriteInt(points, 32)
      net.WriteInt(res[1].data[1]["COUNT(*)"] + 1, 32)
    net.Send(ply)
  end)
end

function UpdateTetrisBoard( force, ply )
  if !tmysql then return end

  if (force && LatestScores && IsValid(ply)) then
    SendTetrisBoard(LatestScores, true, ply)
    return
  end

  local Query = "SELECT `steamid`,`name`,`tetrisscore` FROM gm_users WHERE tetrisscore > 0 ORDER BY cast(tetrisscore as int) DESC LIMIT "..MaxPlayers
  SQL.getDB():Query( Query, function(res)
    if !res or res == nil then return end
    local data = res[1].data

    local scores = {}

    for k,v in pairs(data) do
      table.insert(scores, k, {
        ["Name"] = v.name,
        ["Score"] = v.tetrisscore,
        ["Id"] = v.steamid,
        ["Pos"] = k
      })
    end

    SendTetrisBoard( scores )

  end)

end

function SendTetrisBoard( tbl, force, ply )

  if force then
    net.Start("UpdateTetrisBoard")
      net.WriteTable(tbl)
    net.Send( ply )
    return
  end

  LatestScores = tbl

  net.Start("UpdateTetrisBoard")
    net.WriteTable(tbl)
  net.Broadcast()

end

concommand.Add("gmt_updatetetrisboard",function(ply)
  if ply:IsAdmin() then UpdateTetrisBoard() end
end)

hook.Add("InitPostEntity", "StartTetrisBoard", function()
  UpdateTetrisBoard()
  timer.Create("TetrisBoardUpdater", UpdateInterval, 0, function()
    UpdateTetrisBoard()
  end)
end)

hook.Add("PlayerSQLApplied", "PlyJoinShowScores", function(ply)
  UpdateTetrisBoard( true, ply )
  NetworkLocalScorePosition(ply)
end)

hook.Add("TetrisEnd", "UpdatePersonalTetrisScore", function(ply, machine)
  if !IsValid(ply) || !IsValid(machine) then return end

	local newPoints = machine.Points
	local prevHighscore = tonumber(ply._TetrisHighScore) or 0

  if newPoints > prevHighscore then
    NetworkLocalScorePosition(ply, newPoints)
  end
end)