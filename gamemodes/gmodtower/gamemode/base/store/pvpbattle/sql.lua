hook.Add("SQLStartColumns", "SQLLoadPvpWeapons", function()
	SQLColumn.Init( {
		["column"] = "pvpweapons",
		["selectresult"] = "pvpweapons",
        ["update"] = function( ply )
			return "'" .. PVPBattle.Serialize( ply:GetPVPLoadout() ) .. "'"
		end,
		["defaultvalue"] = function( ply )
            //LogPrint( string.format( "SQLColumn-DefaultValue : ply=%s", ply:Nick() ), nil, "PVPColumns" )
        end,
		["onupdate"] = function( ply, val )
            //LogPrint( string.format( "SQLColumn-OnUpdate : ply=%s val=%s", ply:Nick(), val or "nil" ), nil, "PVPColumns" )
        end
	} )
end )
