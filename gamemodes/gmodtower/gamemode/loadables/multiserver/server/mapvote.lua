function ServerMeta:StartMapVote()

	local Gamemode = self:GetGamemode()

	local time = Gamemode.WaitingTime or 15.0

	self.GoJoinTime = CurTime() + time
	self.MapChangeSent = false

	umsg.Start("GServ", nil )
		umsg.Char( 9 )
		umsg.Char( self.Id )
		umsg.Long( self.GoJoinTime )
	umsg.End()

	local rp = RecipientFilter()
	rp:AddAllPlayers()

	local Players = self:GetPlayers()

	for _, v in pairs( Players ) do
		Players._MultiChoosenMap = ""
		if ( IsValid( v ) and v:IsPlayer() ) then
			rp:RemovePlayer( v )
		end
	end

	self:SendMapVote()

	umsg.Start( "GServ", rp )

		umsg.Char( 13 )

		local gmode_name = Gamemode.Name or "A gamemode"
		local gmode_max = Gamemode.MaxPlayers or 0

		local plycount = math.Clamp( #Players or 0, 0, gmode_max ) or 0

		umsg.Char( self.Id )
		umsg.Long( time )
		umsg.String( gmode_name )
		umsg.Char( plycount )
		umsg.Bool( (plycount >= gmode_max) or false )

	umsg.End()

	--timer.Create("MultiServerReady" .. self.Id, Gamemode.WaitingTime + 0.1, 1, self.Think, self )

	timer.Simple(Gamemode.WaitingTime + 0.1,function() self:Think() end)

	--timer.Create("MultiServerChooseMap" .. self.Id, Gamemode.WaitingTime - 0.9, 1, self.Think, self )

	timer.Simple(Gamemode.WaitingTime - 0.9,function() self:Think() end)

end

function ServerMeta:CountMapVotes()

	local MovingPlayers = self:GetMovingPlayers()

	if !self.GoJoinTime || !MovingPlayers || #MovingPlayers == 0 then
		return
	end

	local Gamemode = self:GetGamemode()
	local Votes = {}

	for k, v in ipairs( Gamemode.Maps ) do
		Votes[ k ] = 0
	end

	for _, ply in pairs( MovingPlayers ) do

		for k, v in ipairs( Gamemode.Maps ) do

			if ply._MultiChoosenMap == v then
				Votes[ k ] = Votes[ k ]  + 1
			end
		end

	end

	local HighestVotes, HighestId = 0, 1

	for k, v in pairs( Votes ) do
		if v > HighestVotes then
			HighestVotes = v
			HighestId = k
		end
	end

	local ips = {}
	for k,v in pairs(MovingPlayers) do
		table.insert(ips, v:Name() .. "/" .. v:IPAddress())
	end

	SQLLog( "multiserver", "Authorized ips " .. table.concat(ips, ", ") )

	self:SetMap( Gamemode.Maps[ HighestId ], GTowerServers:PlayerListToHex(MovingPlayers) )
	self.MapChangeSent = true

	Maps.PlayedMap( Gamemode.Maps[ HighestId ] )

	net.Start("VoteScreenFinish")
	net.WriteString(tostring(Gamemode.Maps[ HighestId ]))
	net.Send(MovingPlayers)

end

function ServerMeta:SendMapVote()

	local Players = self:GetMovingPlayers()

	if #Players == 0 then return end

	local Gamemode = self:GetGamemode()
	local rp = RecipientFilter()

	local Votes = {}

	for k, v in ipairs( Gamemode.Maps ) do
		Votes[ k ] = 0
	end

	for _, ply in pairs( Players ) do

		for k, v in ipairs( Gamemode.Maps ) do

			if ply._MultiChoosenMap == v then
				Votes[ k ] = Votes[ k ]  + 1
			end
		end

		rp:AddPlayer( ply )

	end

	umsg.Start("GServ", rp )

		umsg.Char( 11 )

		umsg.Char( self.Id )
		umsg.Long ( self.GoJoinTime )
		umsg.String( self.GamemodeValue )
		umsg.Char( #Votes )

		for _, v in ipairs( Votes ) do
			umsg.Char( v )
		end
		
		umsg.Char( #Maps.GetNonPlayableMaps(Gamemode.Gamemode) )
		
		for _, v in ipairs( Maps.GetNonPlayableMaps(Gamemode.Gamemode) ) do
			umsg.String( v )
		end
		
	umsg.End()

end

util.AddNetworkString("VoteScreenFinish")
