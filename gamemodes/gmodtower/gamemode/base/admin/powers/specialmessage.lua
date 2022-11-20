concommand.Add("gmt_towerunite", function( ply, cmd, args )
    if !ply:IsAdmin() then return end
    GAMEMODE:ColorNotifyAll( "Enjoying GMTower? Try Tower Unite, the standalone successor to GMTower! Find out how at towerunite.com", Color(255, 200, 0, 255) )
end)