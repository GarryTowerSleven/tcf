---------------------------------
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
end

function RetrieveSQLData(ply)

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
					local money = row.money
					local plysize = row.plysize
					local tetrisscore = row.tetrisscore
					local hat = row.hat
					local faceHat = row.faceHat
					local achi = row.achivement
					local settings = row.clisettings
					local inv = row.inventory
					local bank = row.bank
					local bankLimit = row.BankLimit
					local pvp = row.pvpweapons
					local lvls = row.levels
					local pendingMoney = row.pendingmoney

					if achi == nil or achi == "" then
						ply:SetNWBool( "IsNewPlayer", true )
					end

					ply:SetMoney( (money or 0) )
					ply._PendingMoney = (pendingMoney or 0)

					if ply._PendingMoney > 0 then
						ply:AddMoney( pendingMoney )
						ply:SetNWInt("VideoPokerAmount",pendingMoney)
						ply._PendingMoney = 0
					end

					GTowerModels.Set( ply, tonumber( (plysize or 1) ) )

					ply.OldPlayerSize = ( plysize or 1 )

					timer.Simple( 0.0, function()
						GTowerHats.SetHat( GTowerHats, ply, hat, 1 )
						GTowerHats.SetHat( GTowerHats, ply, faceHat, 2 )
					end)

					if (tetrisscore != "") then
						ply._TetrisHighScore = tetrisscore
					end

					GTowerAchievements:Load(ply,tostring(achi))
					ClientSettings:LoadSQLSave(ply,tostring(settings))

					ply:LoadInventoryData( tostring(inv), 1 )
					ply:LoadInventoryData( tostring(bank), 2 )

					if pvp != "" then
						PvpBattle:Load( ply, pvp )
					else
						PvpBattle:LoadDefault( ply )
					end

					if lvls != "" then
						GTowerStore:UpdateInventoryData( ply, lvls )
					else
						GTowerStore:DefaultValue( ply )
					end

					if bankLimit != "" then
						ply:SetMaxBank( bankLimit )
					else
						ply:SetMaxBank( GTowerItems.DefaultBankCount )
					end

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

	SetDefaultSQLData(ply)

	timer.Simple(0.5,function() -- Networking delay fix
		RetrieveSQLData(ply)
	end)

end )
