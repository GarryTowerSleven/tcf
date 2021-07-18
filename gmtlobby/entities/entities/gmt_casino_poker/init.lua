AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_panel_board.lua" )
AddCSLuaFile( "cl_panel_player.lua" )

include( "shared.lua" )

ENT.TableChairs = {}
ENT.PreviousPlayerBet = 0

function ENT:KeyValue(key, value)

	if key == "minbet" then
		self.DefaultMinBet = tonumber(value)
	end

	if key == "maxbet" then
		self.DefaultMaxBet = tonumber(value)
	end

end

function ENT:SetCurrentActivePlayer()

	self:SetCurrentPlayerID( self:GetCurrentPlayerID()+1 )

end

function ENT:ClearPlayerActions(ply)
	net.Start( "ClientPoker" )
		net.WriteEntity( ply.PokerTable )
		net.WriteEntity( ply )
		net.WriteInt( self.Network.ACTION, 4 )
		net.WriteInt( self.Actions.NONE, 4 )
	net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )
end

// CONCOMMANDS

concommand.Add( "gmt_poker_call", function( ply, cmd, args )

	if !IsValid(ply.PokerTable) then return end
	if args[1] == nil then return end

	local self = Entity(args[1])

	local AllowedStates = {
		3,
		5,
	}

	if ply:EntIndex() != self:GetCurrentPlayerID() && !table.HasValue(AllowedStates, self:GetState()) then return end

	self:SetIn( ply, self:GetIn(ply)+self:GetTopBet(), 4 )
	self:SetPot( self:GetPot()+self:GetTopBet() )

	net.Start( "ClientPoker" )
		net.WriteEntity( ply.PokerTable )
		net.WriteEntity( ply )
		net.WriteInt( self.Network.ACTION, 4 )
		net.WriteInt( self.Actions.CALL, 4 )
	net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )

	self:SetTime(self.BetTime+CurTime())
	self:SetCurrentActivePlayer()

end )

concommand.Add( "gmt_poker_raise", function( ply, cmd, args )

	if !IsValid(ply.PokerTable) then return end
	if args[1] == nil then return end

	local self = Entity(args[1])

	local AllowedStates = {
		3,
		5,
	}

	if ply:EntIndex() != self:GetCurrentPlayerID() && !table.HasValue(AllowedStates, self:GetState()) then return end

	self:SetIn( ply, self:GetIn(ply)+args[2], 4 )
	self:SetPot( self:GetPot()+args[2] )

	net.Start( "ClientPoker" )
		net.WriteEntity( ply.PokerTable )
		net.WriteEntity( ply )
		net.WriteInt( self.Network.ACTION, 4 )
		net.WriteInt( self.Actions.RAISE, 4 )
	net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )

	self:SetTime(self.BetTime+CurTime())
	self:SetCurrentActivePlayer()

	self.PreviousPlayerBet = args[2]

end )

concommand.Add( "gmt_poker_fold", function( ply, cmd, args )

	if !IsValid(ply.PokerTable) then return end
	if args[1] == nil then return end

	local self = Entity(args[1])

	local AllowedStates = {
		3,
		5,
	}

	if ply:EntIndex() != self:GetCurrentPlayerID() && !table.HasValue(AllowedStates, self:GetState()) then return end
	
	local fold_action = self.Actions.FOLD

	if args[2] == "auto" then
		fold_action = self.Actions.FOLDAUTO
	end

	net.Start( "ClientPoker" )
		net.WriteEntity( ply.PokerTable )
		net.WriteEntity( ply )
		net.WriteInt( self.Network.ACTION, 4 )
		net.WriteInt( fold_action, 4 )
	net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )

	self:SetTime(self.BetTime+CurTime())
	self:SetCurrentActivePlayer()

end )

concommand.Add( "gmt_poker_discard", function( ply, cmd, args )

	if !IsValid(ply.PokerTable) then return end
	if args[1] == nil then return end

	local self = Entity(args[1])

	if ply:EntIndex() != self:GetCurrentPlayer() && self:GetState() != self.States.DRAW then return end

	local discarded = string.Explode( "|", args[2] )
	local discardint = (#discarded-1)

	net.Start( "ClientPoker" )
		net.WriteEntity( ply.PokerTable )
		net.WriteEntity( ply )
		net.WriteInt( self.Network.ACTION, 4 )
		net.WriteInt( self.Actions.DISCARD, 4 )
		net.WriteInt( discardint, 4 )
	net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )

	for k,v in pairs(discarded) do
		if v != "" then
			ply.HandT.cards[tonumber(v)] = self.deck:GetCard()
		end
	end

	ply.Hand = ply.HandT:ToInt()
	
	net.Start( "ClientPokerCards" )
		net.WriteEntity(self)
		net.WriteEntity(ply)
		net.WriteInt(ply.Hand,32)
	net.Send(ply)

end )

function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

    timer.Simple(1,function()
      self:SetupChairs()
    end)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self:SetMinBet(self.DefaultMinBet)
	self:SetMaxBet(self.DefaultMaxBet)

	self.Players = {}

end

function ENT:SetupChairs()

	local one80vec = {
		"-52 60 0",
		"-57 30 0",
		"-62 0 0",
		"-57 -30 0",
		"-52 -60 0",
	}

	local one80ang = {
		"0 -20 0",
		"0 -10 0",
		"0 0 0",
		"0 10 0",
		"0 20 0",
	}

	local vec = {
		"52 -60 0",
		"57 -30 0",
		"62 0 0",
		"57 30 0",
		"52 60 0",
	}

	local ang = {
		"0 160 0",
		"0 170 0",
		"0 180 0",
		"0 -170 0",
		"0 -160 0",
	}

	self.TableChairsMdl = {}

	for k,v in pairs(vec) do
		// Chair Model
		self.chairMdl = ents.Create("prop_physics_multiplayer")
		self.chairMdl:SetModel("models/gmod_tower/aigik/casino_stool.mdl")

		if self:GetAngles().y == 180 then
			self.chairMdl:SetPos( self:GetPos() + Vector(one80vec[k]) )
		else
			self.chairMdl:SetPos( self:GetPos() + Vector(vec[k]) )
		end

		if self:GetAngles().y == 180 then
			self.chairMdl:SetAngles( Angle(one80ang[k]) )
		else
			self.chairMdl:SetAngles( Angle(ang[k]) )
		end

		self.chairMdl:PhysicsInit(SOLID_VPHYSICS)
		self.chairMdl:SetMoveType(MOVETYPE_NONE)
		self.chairMdl:SetSolid(SOLID_VPHYSICS)

		self.chairMdl:Spawn()
		self.chairMdl:Activate()
		self.chairMdl:SetParent(self)

		local phys = self.chairMdl:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
			phys:Sleep()
		end

		self.chairMdl:SetKeyValue( "minhealthdmg", "999999" )
		table.insert( self.TableChairsMdl, self.chairMdl )
	end

end

function ENT:SetupVehicles()

	local chairNum

	if table.Count(self.TableChairs) == 0 then
		chairNum = 1
	else
		chairNum = (table.Count(self.TableChairs)+1)
	end

	// Chair Vehicle
	local chair = ents.Create("prop_vehicle_prisoner_pod")
	chair:SetModel("models/nova/airboat_seat.mdl")
	chair:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	chair:SetParent(self.TableChairsMdl[chairNum])
	chair:SetPos(self.TableChairsMdl[chairNum]:GetPos() + Vector(0,0,26))

	chair:SetAngles( Angle(0,self:GetAngles().y+65,0) )

	chair:SetNotSolid(true)
	chair:SetNoDraw(true)
	chair:DrawShadow( false )

	chair:Spawn()
	chair:Activate()

	local phys = chair:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	table.insert( self.TableChairs, chair )

end

function ENT:Use(caller)

	/*caller:Msg2( "Poker is currently in development, check back later!", "cards" )
	do return end*/

	if !(self:GetState() <= self.States.STARTING) then return end

	if caller:PokerChips() < self.DefaultMinBet*2 then
		chipdiff = math.abs((self.DefaultMinBet*2-caller:PokerChips()))
		caller:MsgI( "cards", "PokerCannotAfford", chipdiff )
		return
	end

	if !table.HasValue( self.Players, caller ) then
		self:SetupVehicles()
		table.insert( self.Players, caller )
		net.Start( "ClientPoker" )
			net.WriteEntity( self )
			net.WriteEntity( caller )
			net.WriteInt( self.Network.JOIN, 4 )
			net.WriteTable( self.Players )
		net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )

		if table.Count(self.Players) <= self.MaxPlayers then
			if (self:GetState() == self.States.NOPLAY && table.Count(self.Players) >= self.MinPlayers && self:GetTime() == 0) then
				self:SetTime(self.StartDelay+CurTime())
				self:SetState(self.States.STARTING)
			end

			caller.PokerTable = self

			for k,v in pairs(self.TableChairs) do
				if (IsValid(v) && v:GetDriver() == NULL) then
					caller.EntryPoint = caller:GetPos()
					caller.EntryAngles = caller:EyeAngles()

					caller:SetNWVector("SeatEntry",caller.EntryPoint)
					caller:SetNWVector("SeatEntryAng",caller.EntryAngles)

					caller:EnterVehicle(v)
					caller.PokerSeat = v
				end
			end
		end
	end

end

function ENT:NewRound()

	for _,ply in pairs(self.Players) do
		self:ClearPlayerActions(ply)
	end

	net.Start( "ClientPoker" )
		net.WriteEntity( self )
		net.WriteEntity( caller )
		net.WriteInt( self.Network.NEW, 4 )
		net.WriteTable( self.Players )
	net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )

end

function ENT:SeatRelease()

	for k,v in pairs(self.Players) do
		v:ExitVehicle()
	end

end

function ENT:EndGame()

	self:SeatRelease()

	timer.Simple( 0.5, function()
		self:SetState(self.States.NOPLAY)
		self:SetTime(0)
		self:SetPot(0)
		self:SetCurrentPlayerID(0)
		self:SetRound(0)
		self.deck = nil

		self.Players = {}

		net.Start( "ClientPoker" )
			net.WriteEntity( self )
			net.WriteEntity( ply )
			net.WriteInt( self.Network.CLEAR, 4 )
		net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )
	end )

end

hook.Add( "PlayerLeaveVehicle", "LeavePokerTable", function( ply )

	local self = ply.PokerTable

	if IsValid( self ) then

		table.remove( self.Players, table.KeyFromValue( self.Players, ply ) )

		net.Start( "ClientPoker" )
			net.WriteEntity( self )
			net.WriteEntity( ply )
			net.WriteInt( self.Network.LEAVE, 4 )
			net.WriteTable( self.Players )
		net.Send( Location.GetPlayersInLocation( Location.Find( self:GetPos() ) ) )

		if (self:GetState() == self.States.STARTING && table.Count(self.Players) < self.MinPlayers) then
			self:SetTime(0)
			self:SetState(self.States.NOPLAY)
		end

		ply.PokerTable = nil
		ply.EntryPoint = nil
		ply.EntryAngles = nil

		table.remove( self.TableChairs, table.KeyFromValue( self.TableChairs, ply.PokerSeat ) )

		ply.PokerSeat:Remove()

	end

end )

function ENT:Think()

	if (self:GetState() == self.States.NOPLAY) then return end
	if (self:GetState() > self.States.STARTING && table.Count(self.Players) <= 1) then self:EndGame() return end

	if ( self:GetState() == self.States.STARTING && self:GetTimeLeft() == 0 ) then
		self:SetState(self.States.DEAL)
		self:SetTime(0)
	elseif self:GetState() == self.States.DEAL then
		if ( self:GetTime() == 0 && self:GetTimeLeft() <= 0 ) then
			self.deck = Cards.Deck()
			self.deck:Shuffle()

			for k,v in pairs(self.Players) do
				v.HandT = self.deck:GetHand()
				v.Hand = v.HandT:ToInt()

				net.Start( "ClientPokerCards" )
					net.WriteEntity(self)
					net.WriteEntity(v)
					net.WriteInt(v.Hand,32)
				net.Send(v)

				self:SetIn( v, self.DefaultMinBet, 4 )
				v:GivePokerChips( self.DefaultMinBet, v, self )
				self:SetPot( self:GetPot()+self.DefaultMinBet )
			end

			self:SetTime(2+CurTime())
		end

		if ( self:GetTimeLeft() <= 0 ) then
			self:SetState(self.States.BET)
			self:SetRound(1)
			self:SetCurrentPlayerID(1)
			self:SetTime(0)
		end
	elseif self:GetState() == self.States.BET then
		if ( self:GetTime() == 0 && self:GetTimeLeft() <= 0 ) then
			self:SetTime(self.BetTime+CurTime())
		end
		
		if ( IsValid(self:GetCurrentPlayer()) && IsValid(self.Players[self:GetCurrentPlayerID()+1]) && self:GetTimeLeft() <= 0 ) then
			self:GetCurrentPlayer():ConCommand( "gmt_poker_fold "..self:EntIndex().." auto" )
		end
	
		if ( !IsValid(self:GetCurrentPlayer()) || self:GetTimeLeft() <= 0 ) then
			self:SetState(self.States.DRAW)
			self:SetTime(0)
			self:NewRound()
			self:SetCurrentPlayerID(1)
		end
	elseif self:GetState() == self.States.DRAW then
		if self:GetTime() == 0 && self:GetTimeLeft() <= 0 then
			self:SetTime(self.DrawTime+CurTime())
		end

		if self:GetTimeLeft() <= 0 then
			self:SetState(self.States.BETFINAL)
			self:SetTime(0)
			self:NewRound()
			self:SetCurrentPlayerID(1)
		end
	elseif self:GetState() == self.States.BETFINAL then
		if self:GetTime() == 0 && self:GetTimeLeft() <= 0 then
			self:SetTime(self.BetTime+CurTime())
		elseif self:GetTimeLeft() <= 0 then
			self:SetState(self.States.REVEAL)
			self:SetTime(0)
			self:NewRound()
			
			for k,v in pairs(self.Players) do
				net.Start( "ClientPokerCards" )
					net.WriteEntity(self)
					net.WriteEntity(v)
					net.WriteInt(v.Hand,32)
				net.Send(self.Players)
			end
		end
	elseif self:GetState() == self.States.REVEAL then
		if self:GetTime() == 0 && self:GetTimeLeft() <= 0 then
			self:SetTime(15+CurTime())
		elseif self:GetTimeLeft() <= 0 then
			self:SetState(self.States.END)
			self:SetTime(0)
		end
	elseif self:GetState() == self.States.END then
		self:EndGame()
	end

	self:NextThink( CurTime() )
	return true

end

util.AddNetworkString( "ClientPoker" )
util.AddNetworkString( "ClientPokerCards" )
