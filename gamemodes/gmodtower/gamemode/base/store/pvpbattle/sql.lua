---------------------------------
hook.Add("SQLStartColumns", "SQLLoadPvpWeapons", function()
	SQLColumn.Init( {
		["column"] = "pvpweapons",
		["selectquery"] = "HEX(pvpweapons) as pvpweapons",
		["selectresult"] = "pvpweapons",
		["update"] = function( ply ) 
			if ply:GetNWBool("SQLApplied") == true then return PvpBattle:SndData( ply ) end
			return
		end,
		["defaultvalue"] = function( ply )
			PvpBattle:LoadDefault( ply )
		end,
		["onupdate"] = function( ply, val )
			if ply:GetNWBool("SQLApplied") == true then PvpBattle:Load( ply, val ) end
			return
		end
	} )
end )