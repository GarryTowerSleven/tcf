
-----------------------------------------------------
CurrentHole = null

hook.Add("GTowerMsg", "GamemodeMessage", function()
	if player.GetCount() < 1 then
		return "#nogame"
	else
		local numhole
		local numpar

		if CurrentHole == null then
			numhole = 1
		else
			numhole = CurrentHole.Hole
		end

		for _,hole in pairs(ents.FindByClass("golfstart")) do
			if hole.Hole == tostring(numhole) then
				numpar = hole.par
			end
		end

		return tostring(numhole) .. "/18||||"..tostring(numpar)
		--return tostring(GAMEMODE:GetState()) .. "/18||||"..tostring(GAMEMODE:GetPar())
	end
end )

function GM:BeginGame()
	self:SetState( STATE_WAITING )
	self:SetTime( WaitTime )
	globalnet.SetNet( "HasPractice", true )
end

function GM:SaveBestScore(ply, score, update)
	if update then
		local update_data = {
			score = Database.Escape( score, true ),
		}

		local where = {
			ply = Database.Escape( ply:SteamID64(), true ),
			map = Database.Escape( game.GetMap(), true ),
		}

		local query_string2 = "UPDATE `gm_minigolf` SET " .. Database.CreateUpdateQuery( update_data ) .. " WHERE " .. Database.CreateWhereQuery( where ) .. ";"
		Database.Query( query_string2 )
		return
	end

	local insert_data = {
		ply = Database.Escape( ply:SteamID64(), true ),
		name = Database.Escape( ply:Nick(), true ),
		map = Database.Escape( game.GetMap(), true ),
		score = Database.Escape( score, true )
	}

	local query_string = "INSERT INTO `gm_minigolf` " .. Database.CreateInsertQuery( insert_data ) .. ";"
	Database.Query( query_string )
end

function GM:GetBestScore(ply)
	local where = {
		ply = Database.Escape( ply:SteamID64(), true ),
		map = Database.Escape( game.GetMap(), true ),
	}
	local query_string = "SELECT * FROM `gm_minigolf` WHERE " .. Database.CreateWhereQuery( where ) .. ";"

	Database.Query( query_string, function( data, status, err )
		if status != QUERY_SUCCESS then return end
		if not data[1] then return end
		
		if IsValid(ply) then
			ply.BestScore = tonumber( data[1].score )
		end
	end )
end

function GM:UpdateBestScore(ply)
	if self.GetHole() < 18 then return end
	ply.EndScore = ply:Frags() + ply:Swing()
	if Database.IsConnected() then
		self:GetBestScore(ply)
		timer.Simple(1, function()
			if ply.BestScore == nil then
				self:SaveBestScore(ply, ply.EndScore, false)
				self:ColorNotifyPlayer( ply, "New best score!", Color(100, 100, 255, 255) )
			else
				if ply.BestScore <= ply.EndScore then
					self:ColorNotifyPlayer( ply, "Your best score is still "..ply.BestScore, Color(100, 100, 255, 255) )
				end

				if ply.BestScore > ply.EndScore then
					self:SaveBestScore(ply, ply.EndScore, true)
					self:ColorNotifyPlayer( ply, "New best score: "..ply.EndScore.."! Your old score was "..ply.BestScore, Color(100, 100, 255, 255) )
				end
			end
			ply.BestScore = nil
		end)
	end
end

function GM:Think()
	if self:IsPracticing() then
		if self:GetTimeLeft() <= 0 then
			self:SetState( STATE_SETTINGS )
			self:SetTime( 12 )

			umsg.Start( "ShowCustomizer" )
			umsg.Bool( true )
			umsg.End()

			self:PlaySound( MUSIC_SETTINGS )
			SetWaitingCams()

			globalnet.SetNet( "HasPractice", false )
			self.PreGame = true
			SetAllTeams(TEAM_FINISHED)
		end
	else
		if self:IsPlaying() && team.NumPlayers(TEAM_FINISHED) >= 1 && !self:AreAllPlayersFinished() then
			if self.TimeOutStarted != true then
				self:SetTime( 60 )
				self.TimeOutStarted = true
			end
		end

		if self:IsPlaying() && self:GetTimeLeft() <= 0 then
			GetAllUnfinished()
		end

		if self:GetTimeLeft() <= 0 && self.PreGame == true then
			umsg.Start( "ShowCustomizer" )
			umsg.Bool( false )
			umsg.End()

			self:StartRound()
		end

		if GAMEMODE:AreAllPlayersFinished() then
			if self:GetHole() < 18 then
				if self.EndSoundPlayed != true then
					self:PlaySound( MUSIC_ENDGAME )
					self.EndSoundPlayed = true
					GAMEMODE:GiveMoney()

					for k,v in pairs(player.GetAll()) do
						v:SetCamera( "Pocket", 2 )
					end

					timer.Simple( 2, function()
						if !self:IsPracticing() then
							umsg.Start( "ShowScores" )
							umsg.Bool( true )
							umsg.End()
						end
					end )
				end

				timer.Simple( 10, function()
					if GAMEMODE:AreAllPlayersFinished() then
						self.EndSoundPlayed = false
						self:EndRound()
					end
				end )
			else
				if self.EndSoundPlayed != true then
					self:SetState( STATE_ENDING )

					if self.EndSoundPlayed != true then
						timer.Simple( 0, function()
							self:PlaySound( MUSIC_ENDINGGAME )
							FreezeAll()

							GAMEMODE:GiveMoney()
						end )

						timer.Simple( 2, function()
							SetWaitingCams()
							umsg.Start( "ShowScores" )
							umsg.Bool( true )
							umsg.End()
						end )

						timer.Simple( 20,function()
							self:EndServer()
						end )
					end

					self.EndSoundPlayed = true
				end
			end
		end
	end
end

function GM:StartRound()
	if self.PreGame == true then
		self.PreGame = false
	end

	RemoveAllBalls()
	self.EndSoundPlayed = false

	if self:GetHole() == 0 then
		self:UpdateNetHole( 1 )
		self:HoleSetup()
		PrepAllBalls()
		SetupAllBalls()
	else
		self:UpdateNetHole( self:GetHole()+1 )
		self:HoleSetup()
		PrepAllBalls()
		SetupAllBalls()
	end

	self:PlaySound( MUSIC_INTERMISSION )
	SetAllCams("Preview"..self:GetHole())
	SetAllTeams(TEAM_FINISHED)

	self:SetState( STATE_PREVIEW )
	self:SetTime( 6000 )
	self.TimeOutStarted = false

	timer.Simple( 8, function()
		SetAllTeams(TEAM_PLAYING)
		self:SetState( STATE_PLAYING )
		SetAllCams("Playing")
		UnpocketAllBalls()
		SetAllMoveType(MOVETYPE_NOCLIP)
		self:PlaySound( MUSIC_NONE )
	end )
end

function GM:HoleSetup()
	for _,hole in pairs(ents.FindByClass("golfstart")) do
		if hole.Hole == tostring(GAMEMODE:GetHole()) then
			self:SetPar(hole.par)
			self:SetHoleName(hole.name)
			CurrentHole = hole
		end
	end
end

function GM:EndRound()
	RemoveAllBalls()

	umsg.Start( "ShowScores" )
	umsg.Bool( false )
	umsg.End()

	if self:GetHole() < 18 then
		self:StartRound()
	end
end
