GTowerModerators = {
    "STEAM_0:1:57386100", -- Squibbus
    "STEAM_0:0:156132358", -- Basical
    "STEAM_0:1:85508734", -- Breezy
	"STEAM_0:0:115320789", -- Zia
	"STEAM_0:0:41914866", -- Sunni
	"STEAM_0:1:53166133", -- Orlok
	"STEAM_0:1:72402171", -- Umbre
}

function IsModerator( steam )
    return table.HasValue( GTowerModerators, steam )
end

hook.Add("PlayerInitialSpawn", "GTowerCheckMod", function(ply)

	if table.HasValue( GTowerModerators, ply:SteamID() )then
        ply:SetUserGroup( "moderator" )
    end

end )