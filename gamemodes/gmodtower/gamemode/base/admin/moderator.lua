GTowerModerators = {
    "STEAM_0:1:72402171", -- Umbre
    "STEAM_0:1:57386100", -- Squibbus

    "STEAM_0:1:85508734", -- Breezy
    "STEAM_0:1:124798129", -- Amgona
}

function IsModerator( steam )
    return table.HasValue( GTowerModerators, steam )
end

hook.Add("PlayerInitialSpawn", "GTowerCheckMod", function(ply)

	if table.HasValue( GTowerModerators, ply:SteamID() )then
        ply:SetUserGroup( "moderator" )
    end

end )