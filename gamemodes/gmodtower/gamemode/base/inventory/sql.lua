concommand.Add("gmt_invuploaddatabase", function( ply )

	if ply != NULL && !ply:IsAdmin() then
		return
	end

	local UpdateStrs = {}

	for _, item in pairs( GTowerItems.Items ) do

		table.insert( UpdateStrs,
			string.format("(%s,'%s','%s','%s',%s,%s,'%s',%s)",
				item.MysqlId,
				Database.Escape(item.UniqueName or "") ,
				Database.Escape(item.Name or "") ,
				Database.Escape(item.Description or ""),
				item.StoreId or 0,
				item.StorePrice or 0,
				item.Model or "",
				item:IsWeapon() and 1 or 0
			)
		)

	end

	local EndRequest = string.format( "REPLACE INTO `gm_items`(`id`,`unique`,`Name`,`desc`,`storeid`,`price`,`model`,`weapon`) " ..
		"VALUES %s", table.concat( UpdateStrs,",") )

	local Start = SysTime()

	Database.Query( EndRequest, function( res, status, err )

		if status != QUERY_SUCCESS then
			ErrorNoHaltWithStack( "gmt_invuploaddatabase FAILIURE! : " .. tostring( err ) )
		end

		LogPrint( "Query took: " .. (SysTime() - Start ) .. " seconds.", nil, "Inventory" )

	end )

end )
