---------------------------------
function ServerMeta:StartMapVote()

	local Gamemode = self:GetGamemode()

	self.GoJoinTime = CurTime() + ( Gamemode.WaitingTime or 15.0 )
	self.MapChangeSent = false

	umsg.Start("GServ", nil )
		umsg.Char( 9 )
		umsg.Char( self.Id )
		umsg.Long( self.GoJoinTime )
	umsg.End()


	local Players = self:GetPlayers()

	for _, v in pairs( Players ) do
		Players._MultiChoosenMap = ""
	end

	self:SendMapVote()

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

local function SendGMMsg(gmode,plys,id)
if timer.Exists( gmode.."delay" ) then return end
timer.Create( gmode.."delay", 25, 1, function()  end)
net.Start('gmt_gamemodestart')
net.WriteString(gmode)
net.WriteInt(plys,32)
net.WriteInt(id,32)
net.Broadcast()
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

	SendGMMsg( self.GamemodeValue, #Players, self.Id )

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
