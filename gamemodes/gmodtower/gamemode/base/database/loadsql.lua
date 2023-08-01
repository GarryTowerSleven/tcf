local function SetDefaultSQLData(ply)
	// Default SQL values, get overwritten if you already have progress, else
	// they simply count as starting values.

	if ply:IsBot() then return end

	GTowerAchievements:Load( ply, 0x0 )

	ply:LoadInventoryData( 0x0, 1 )
	ply:LoadInventoryData( 0x0, 2 )
	ply:SetMaxItems( GTowerItems.DefaultInvCount )
	ply:SetMaxBank( GTowerItems.DefaultBankCount )

	ply._TetrisHighScore = 0
	ply._PendingMoney = 0
	GTowerHats:SetHat( ply, 0, 1 )
	GTowerHats:SetHat( ply, 0, 2 )

	ply._DefaultSet = true
end

function RetrieveSQLData( ply )

	if ( !IsValid(ply) || ply:IsBot() ) then return end

	if !tmysql and SQL.getDB() != false then
		return
	end

	ply.SQL:InsertPlayer()

	timer.Simple(0.5,function()

	SQL.getDB():Query(ply.SQL:GetSelectQuery(), function(res)

			if !res or res == nil then return end
			local row = res[1].data[1]
			if row then
				ply._SQLDATA = row
			end

		end)

	end)

end

hook.Add("PlayerDisconnected","SQLPlayerLeave",function(ply)

	if ply:IsBot() then return end

	if ply.HasResetData then
		local query = "DELETE FROM `gm_users` WHERE `gm_users`.`id` = \'" .. ply:SQLId() .."\'"
		SQL.getDB():Query( query, function( res ) end)
		return
	end

	local query = "UPDATE gm_users SET LastOnline='"..os.time().."', time=time + ".. ply:TimeConnected() .." WHERE id=" .. ply.SQL:SQLId()
	SQL.getDB():Query( query, function( res ) end)

	ply.SQL:Update(true) -- OH SHIT QUICK UPDATE THEIR DATA!!

end)

hook.Add("PlayerInitialSpawn", "SQLPlayerJoin", function(ply)
	//SetDefaultSQLData( ply )

	timer.Simple( 0.5, function() -- Networking delay fix
		RetrieveSQLData( ply )
	end)
end )

hook.Add( "PlayerNetInitalized", "SQLSetDefault", function( ply )
	SetDefaultSQLData( ply )
end )

hook.Add( "PlayerThink", "PlayerApplySQL", function( ply )
	if ( ply._NetInit && ply._SQLDATA && ply._DefaultSet ) then
		ply:ApplyData( ply._SQLDATA )
		ply._SQLDATA = nil
	end
end )
