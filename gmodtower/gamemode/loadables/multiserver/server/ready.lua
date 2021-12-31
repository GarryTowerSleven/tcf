---------------------------------
//Return the list of players what would be joining the server
function ServerMeta:GetMovingPlayers()

	local PlayerBatches = self:GetBatches()

	//print(self.Id, "GetMovingPlayers", PlayerBatches, #PlayerBatches, table.Count(PlayerBatches))
	if !PlayerBatches || #PlayerBatches == 0 then return end

	return PlayerBatches[1]

end

function ServerMeta:IsReady()

	//First let's check if the server is ready
	//And that the gamemode handles players in packs
	//Give 60 seconds from last players joining to the server to update
	//print(self.Id, "IsReady", self:Online(), self.Status, self.LastPlayerJoin, CurTime())

	if !self:Online() || self.Status == 2 || (self.LastPlayerJoin && (CurTime() - self.LastPlayerJoin) < 60) then
		return false
	end

	//Now check for the player count and see if it meets the requirements
	local PlayerList = self:GetMovingPlayers()
	local Gamemode = self:GetGamemode()

	//print(self.Id, "PlayerList", PlayerList)

	if !PlayerList then
		return false
	end

	//Check the limitations with the minimun amount of players
	local PlayerCount = table.Count( PlayerList )

	//print(self.Id, "PlayerCount", PlayerCount, Gamemode.MinPlayers)
	if PlayerCount == 0 || (Gamemode.MinPlayers && PlayerCount < Gamemode.MinPlayers) then
		return false
	end

	return true
end

// to make the table needed n suchchc
concommand.Add("gmt_makeloading", function(ply)
	if !ply:IsAdmin() then return end

	local gamemodes = { "ballrace", "pvpbattle", "ultimtechimerahunt", "minigolf", "sourcekarts", "gourmetrace", "virus", "zombiemassacre" }

	SQL.getDB():Query( "TRUNCATE TABLE `gm_loading`;" )
	for k,v in pairs(gamemodes) do
		SQL.getDB():Query( "INSERT INTO `gm_loading`(`gamemode`, `steamids`) VALUES ('" .. v .. "','');" )
	end
end)

function ServerMeta:SendToLoading( movingPlayers )
	local SteamIDS = ""

	for k,v in pairs( movingPlayers ) do
		if SteamIDS == "" then
			SteamIDS = v:SteamID64()
		else
			SteamIDS = SteamIDS .. "," .. v:SteamID64()
		end
	end

	local gmode = self:GetGamemode().Gamemode

	if gmode then
		SQL.getDB():Query( "UPDATE `gm_loading` SET `steamids` = '".. SteamIDS .."' WHERE gamemode = '".. self:GetGamemode().Gamemode .."';" )
	end
end

function ServerMeta:Think()

	local IsReady = self:IsReady()
	local Gamemode = self:GetGamemode()

	if IsReady == true then

		//print(self.GoJoinTime, #self:GetMovingPlayers())

		if !self.GoJoinTime then

			// don't vote while the game is in state 3, it will reset itself
			if self.Status != 1 then return end

			//print(self.Id, "start vote")
			self:StartMapVote()
			self.SendPlayersFinal = nil

		elseif CurTime() > self.GoJoinTime - 1 && self.MapChangeSent != true then

			//print(self.Id, "count vote")
			self:CountMapVotes()
			self.SendPlayersFinal = self:GetMovingPlayers() // this is it, these players are going whether they like it or not

			self:SendToLoading(self.SendPlayersFinal)

		elseif CurTime() > self.GoJoinTime && self.SendPlayersFinal then

			if self.Status == 3 then
				//print(self.Id, "move it!")
				self:PlayersToServer(self.SendPlayersFinal)
			end

		else

			self:SendMapVote()

		end

	else

		if self.GoJoinTime then

			if self.GoJoinTime then
				umsg.Start("GServ", nil )
					umsg.Char( 10 )
					umsg.Char( self.Id )
				umsg.End()

				timer.Destroy( "MultiServerReady" .. self.Id )
				timer.Destroy( "MultiServerChooseMap" .. self.Id )

				self.GoJoinTime = nil

			end

		end

	end

end

function ServerMeta:PlayersToServer(PlayerList)

	//Well, the time has passed, and we are still here
	self.LastPlayerJoin = CurTime()
	self.GoJoinTime = nil

	local gameMode = self:GetGamemode()

	GTowerServers:RedirectPlayers( self.Ip, self.Port, self.Password, PlayerList, true, gameMode )

end

function ServerMeta:TimedThink( time )
	--timer.Create("MultiServerThink" .. self.Id, time or 0.0, 1, self.Think, self  )
	timer.Simple( (time or 0) ,function() self:Think() end)
end
