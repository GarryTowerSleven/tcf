
-----------------------------------------------------

local ScoreTable = {"LOADING DATA"}

net.Receive("UpdateTetrisBoard",function()
  local tbl = net.ReadTable()

  if !tbl then ScoreTable = {"No scores available!"} return end
  ScoreTable = tbl[1]
  ChampTable = tbl[2]

  ScoreTables = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, }

  for k,v in pairs(ScoreTable) do
    if k <= 10 then
      table.insert( ScoreTables[1], v )
    elseif k > 10 && k <= 20 then
      table.insert( ScoreTables[2], v )
    elseif k > 20 && k <= 30 then
      table.insert( ScoreTables[3], v )
    elseif k > 30 && k <= 40 then
      table.insert( ScoreTables[4], v )
    elseif k > 40 && k <= 50 then
      table.insert( ScoreTables[5], v )
    end
  end

end)

surface.CreateFont("GMTTetrisTitle", {font = "Oswald", size = 200, weight = 800, antialias = true} )
surface.CreateFont("GMTTetrisSubTitle", {font = "Oswald", size = 124, weight = 800, antialias = true} )
surface.CreateFont("GMTTetrisTitleThin", {font = "Oswald", size = 100, weight = 25, antialias = true} )

surface.CreateFont("GMTTetrisEntry", {font = "Oswald", size = 62, weight = 450, antialias = true} )

local champMode = false

local page = 1

hook.Add( "PostDrawOpaqueRenderables", "DrawTetrisBoard", function()

  if CurTime() > (champSwitchDelay or 0) then
    champSwitchDelay = CurTime() + 10
    if page == 6 then page = 1 else
      page = page + 1
    end
    if page == 6 then champMode = true else champMode = false end

  end

  local pos = Vector(10239, -2280, 9060)

  if ( !LocalPlayer():GetPos():WithinDistance( pos, 3785 ) ) then return end

	cam.Start3D2D( pos, Angle(0,-90,90), 0.5 )
  draw.DrawText( "Blockles Highscores", "GMTTetrisTitle", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
  if #ChampTable > 0 && champMode then
    draw.DrawText( "GRAND CHAMPION", "GMTTetrisSubTitle", 0, 200, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
  elseif ScoreTables[1] != "LOADING DATA" then
    draw.DrawText( table.concat(ScoreTables[page],"\n"),"GMTTetrisEntry",-475,210,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
    draw.DrawText( tostring(page) .. "/" .. "5","GMTTetrisEntry",480,210,Color( 255, 255, 255, 255 ),TEXT_ALIGN_RIGHT)
  else
    draw.DrawText( table.concat(ScoreTables,"\n"),"GMTTetrisEntry",-475,210,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
  end

    surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
    surface.DrawRect( -475, 200, 950, 10 )

	cam.End3D2D()

  cam.Start3D2D( pos - Vector(0,0,180 + math.sin( RealTime() * 6 ) * 4 ), Angle(math.sin( RealTime() * 2 ) * 2,-90,90), 0.5 )
  if #ChampTable > 0 && #ChampTable[1] > 1 && champMode then
    draw.DrawText( ChampTable[1][1], "GMTTetrisTitle", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
    draw.DrawText( "With a score of " .. tostring( ChampTable[1][2] ) .. " points", "GMTTetrisTitleThin", 0, 150, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
  end
  cam.End3D2D()
end )
