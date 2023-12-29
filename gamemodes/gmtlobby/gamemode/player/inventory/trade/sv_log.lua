local function CompileData( tbl )
	
	local Data = Hex()
	
	for _, v in pairs( tbl ) do
		Data:Write( v.mysqlid, 4 )
		Data:WriteString( v.data )
	end
	
	return Data:Get()

end

function GTowerTrade.LogTrade( ply1, ply2, money1, money2, recv1, recv2 )

	local data = {
		ply1 = ply1:DatabaseID(),
		ply2 = ply2:DatabaseID(),
		money1 = money1,
		money2 = money2,
		recv1 = CompileData(recv1),
		recv2 = CompileData(recv2),
	}

	Database.Query( "INSERT INTO `gm_log_trade` " .. Database.CreateInsertQuery( data ) .. ";" )

end