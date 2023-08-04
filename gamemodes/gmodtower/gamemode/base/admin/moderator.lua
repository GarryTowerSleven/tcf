GTowerModerators = {
    "STEAM_0:1:57386100", -- Squibbus
    "STEAM_0:0:156132358", -- Basical
    "STEAM_0:1:85508734", -- Breezy
	"STEAM_0:0:115320789", -- Zia
	"STEAM_0:0:241528576", -- Scienti[-]
}

function IsModerator( steam )
    return table.HasValue( GTowerModerators, steam )
end

hook.Add("PlayerInitialSpawn", "GTowerCheckMod", function(ply)

	if table.HasValue( GTowerModerators, ply:SteamID() )then
        ply:SetUserGroup( "moderator" )
    end

end )