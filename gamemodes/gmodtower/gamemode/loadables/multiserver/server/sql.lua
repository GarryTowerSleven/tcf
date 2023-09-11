function ServerMeta:LoadPlayerNames( res, status, err )
	if status != QUERY_SUCCESS then
		return
	end

	self.CurrentPlayers = {}
	for k, v in pairs(res) do
		table.insert(self.CurrentPlayers, v.name)
	end
end

function ServerMeta:LoadSQL( Data )

	self.GamemodeValue = string.lower( Data["gamemode"] )
	local Gamemode = self:GetGamemode()
	local MaxPlayers = tonumber( Data["maxplayers"] )
	local TrueMaxPlayers = Gamemode.MaxPlayers or MaxPlayers

	local ip = Data["ip"]
	local port = tonumber( Data["port"] )
	local password = Data["password"]
	local map = Data["map"]
	local msg = Data["msg"]

	local playercount = tonumber( Data["players"] )
	local status = tonumber( Data["status"] )
	local LastUpdate = tonumber( Data["lastupdate"] )
	local PlayerBuffer = GTowerServers:PlayerListToIDs( Data["lastplayers"] )
	local CurrentPlayerIDs = DecodePlayersFromSQLId( Data["playerlist"] )

	if self:CheckOnline( LastUpdate ) != self:Online() || status != self.Status then
		self:NetworkNeedSend()
	end

	self.Ip = ip
	self.Port = port
	self.Password = password
	self.Map = map

	self.MinPlayers = Gamemode.MinPlayers
	self.MaxPlayers = TrueMaxPlayers
	self.ServerMaxPlayers = MaxPlayers
	self.PlayerCount = playercount
	self.Status = status
	self.LastUpdate = LastUpdate
	self.PlayerBuffer = PlayerBuffer
	self.Msg = msg

	if #CurrentPlayerIDs > 0 then
		local query = "SELECT `name` FROM `gm_users` WHERE `id` IN (" .. table.concat(CurrentPlayerIDs, ",") .. ") ORDER BY name ASC;"
		
		Database.Query( query, function( res, status, err )

			self:LoadPlayerNames( res, status, err )

		end )

	else
		self.CurrentPlayers = {}
	end

	self:Think()
end

function ServerMeta:SetMap( map, playershex )

	Database.Query( "REPLACE INTO gm_gomap VALUES (" .. self.Id .. ", '" .. map .. "', " .. playershex .. ")" )

end
