AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

// To-do
// - Recompile model under pt
// - Fix weird chair physics issue
// - Implement local bet with slots_spin command
// - Define multiplier combinations (In-Progress)
// - Send winnings
// - Jackpot System
//		- All money bet that doesn't win

/*---------------------------------------------------------
	Basics
---------------------------------------------------------*/
function ENT:Initialize()

	self.BetAmount = 10
	self.SlotsPlaying = nil
	self.SlotsSpinning = false
	self.LastSpin = CurTime()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow( false )
	// self:SetAngles( Angle( 0, 90, 0) )

	self:SetupChair()
	self:SetupLight()

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
end

function ENT:FetchFromSQL()

    if not Database.IsConnected() then return end

    Database.Query( "SELECT * FROM `gm_casino` WHERE `type` = 'slots';", function( res, status, err )
    
        if status != QUERY_SUCCESS then
            return
        end

        if table.Count( res ) == 0 then
            Database.Query( "INSERT INTO gm_casino (type, jackpot) VALUES ('slots', 0);" )
        else
            self:SetJackpot( res[1].jackpot )
        end

    end )

end

function ENT:UpdateToSQL()

    if not Database.IsConnected() or GMT_IS_RESTARTING then return end

    Database.Query( "UPDATE `gm_casino` SET `jackpot` = " .. tonumber( self:GetJackpot() ) .. " WHERE `type` = 'slots';" )

end

hook.Add( "DatabaseConnected", "FetchSlots", function()

    local ent = ents.FindByClass( "gmt_casino_slotmachine" )[1]
    if IsValid( ent ) then
        ent:FetchFromSQL()
    end

end )

function ENT:Think()

	// Player In Chair Check
	if !self.SlotsPlaying && self:IsInUse() then

		self:SendPlaying()

	elseif self.SlotsPlaying && !self:IsInUse() then

		if IsValid( self.chair ) then
			self.chair:Remove()
		end

		self.SlotsPlaying = nil
		
	/*elseif !self:IsInUse() then
		if !self.LastPlay or self.LastPlay < CurTime() then
			if #Location.GetPlayersInLocation(self:Location()) > 3 then
				// self:PullLever()
				self:PickResults(true)
				self:EmitSoundInLocation( Casino.SlotWinSound, 60, 100 )
			end

			self.LastPlay = CurTime() + math.Rand(60, 140)
		end*/
	end

	// Player Idling Check
	if ( self.LastSpin + (60*3) < CurTime() ) && self:IsInUse() then
		local ply = self:GetPlayer()
		ply:ExitVehicle()
		// GAMEMODE:PlayerMessage( ply, "Slots", "You have been ejected due to idling!" )
	end

	if ( self.Jackpot && self.Jackpot < CurTime() ) then
		self.Jackpot = nil
	end

	self:NextThink(CurTime()) // Don't change this, the animation requires it

	return true
end


/*---------------------------------------------------------
	Chair Related Functions
---------------------------------------------------------*/

function ENT:SetupChair()

	// Chair Model
	self.chairMdl = ents.Create("prop_physics_multiplayer")
	self.chairMdl:SetModel(self.ChairModel)

	if self:GetAngles().y == 270 then
		self.chairMdl:SetPos( self:GetPos() + Vector(0,-35,0) )
	else
		self.chairMdl:SetPos( self:GetPos() + Vector(0,35,0) )
	end

	if self:GetAngles().y == 270 then
		self.chairMdl:SetAngles( Angle(0, 90, 0) )
	else
		self.chairMdl:SetAngles( Angle(0, -90, 0) )
	end

	// self.chairMdl:SetPos( self:GetPos() + Vector(0,35,-2) )
	// self.chairMdl:SetAngles( Angle(0, math.random(-180,180), 0) )
	self.chairMdl:DrawShadow( false )
	
	self.chairMdl:PhysicsInit(SOLID_VPHYSICS)
	self.chairMdl:SetMoveType(MOVETYPE_NONE)
	self.chairMdl:SetSolid(SOLID_VPHYSICS)
	
	self.chairMdl:Spawn()
	self.chairMdl:Activate()
	
	local phys = self.chairMdl:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
	self.chairMdl:SetKeyValue( "minhealthdmg", "999999" )

	self.chairMdl.OnSeatUse = function( ply )
		self:Use( ply )
	end

end

function ENT:SetupVehicle( ply )

	self.chair = seats.ForceEnterGivenSeat( self.chairMdl, ply )
	
	if not IsValid( self.chair ) then return end

	self.chair.OnSeatLeave = function( leaver )

		if self.SlotsSpinning then
			return false
		end

		leaver.SlotMachine = nil

		net.Start( "casino.slots.play" )
			net.WriteEntity( NULL )
		net.Send( leaver )
		
		return true

	end

end

function ENT:SetupLight()

	self.light = ents.Create("slotmachine_light")

	self.light.Jackpot = false

	if self:GetAngles().y == 270 then
		self.light:SetPos( self:GetPos() + Vector( 0, 5, 80 ) )
	else
		self.light:SetPos( self:GetPos() + Vector( 0, -5, 80 ) )
	end

	self.light:Spawn()
	self.light:Activate()

	self.light:SetParent(self)

end

function ENT:IsInUse()

	if IsValid(self.chair) && self.chair:GetDriver():IsPlayer() then
		return true
	else
		return false
	end

end

/*---------------------------------------------------------
	Initial Player Interaction
---------------------------------------------------------*/
function ENT:Use( ply )

	if !IsValid(ply) || !ply:IsPlayer() then
		return
	end

	if !self:IsInUse() then

		self:SetupVehicle( ply )

		if !IsValid(self.chair) then return end -- just making sure...

		ply.LastBetTime = CurTime()
		self:SendPlaying( ply )

	else
		return
	end

end

/*---------------------------------------------------------
	Console Commands
---------------------------------------------------------*/
concommand.Add( "slotm_spin", function( ply, cmd, args )
	if ply.LastBetTime >= CurTime() then return end

	local bet = tonumber(args[1]) or 10
	bet = math.Clamp( bet, 10, 1000 )

	local ent = ply.SlotMachine

	if IsValid(ent) && !ent.SlotsSpinning && !ent.Jackpot then

		if not ply:Afford( bet ) then
			ply:MsgI( "slots", "SlotsNoAfford" )
		else
			ply:TakeMoney( bet, false, ent )

			ent.LastSpin = CurTime()
			ent.BetAmount = bet
			ent:PullLever()
			ent:PickResults()

			ply:AddAchievement( ACHIEVEMENTS.SOREFINGER, 1 )
		end

	end

	ply.LastBetTime = CurTime() + 1
end )

/*---------------------------------------------------------
	Slot Machine Functions
---------------------------------------------------------*/
function ENT:GetPlayer()

	local ply = player.GetByID( self.SlotsPlaying )

	if IsValid(ply) && ply:IsPlayer() && self:IsInUse() then
		return ply
	end

end

function ENT:SendPlaying( ply )

	if ( !IsValid( self ) || !IsValid(self.chair) ) then return end

	self.SlotsPlaying = self.chair:GetDriver():EntIndex()
	self.LastSpin = CurTime()

	--local ply = self:GetPlayer()
	ply.SlotMachine = self

	net.Start( "casino.slots.play" )
		net.WriteEntity( self )
	net.Send( ply )

end

function ENT:PullLever()

	local seq = self:LookupSequence("pull_handle")

	if seq == -1 then return end

	self:ResetSequence(seq)

end

function ENT:PickResults(fake)

	self.SlotsSpinning = !fake

	local rf = RecipientFilter()
	//rf:AddPlayer( self:GetPlayer() )
	rf:AddAllPlayers()

	local random = { getRand(), getRand(), getRand() }

	if random[1] == 2 and random[2] == 2 and random[3] == 2 then
		if self:GetJackpot() < 5000 && math.random(4) != 1 then
			random[3] = math.random(6)
		elseif self:GetJackpot() < 10000 && math.random(3) != 1 then
			random[3] = math.random(6)
		elseif self:GetJackpot() < 25000 && math.random(2) != 1 then
			random[3] = math.random(6)
		end
	end

	net.Start( "casino.slots.result" )
		net.WriteEntity( self )
		net.WriteUInt( random[1], 3 )
		net.WriteUInt( random[2], 3 )
		net.WriteUInt( random[3], 3 )
	net.SendPVS( self:GetPos() )

	if fake then return end
	
	self:EmitSoundInLocation( Casino.SlotPullSound, 60, math.random(98, 102) )

	timer.Simple( Casino.SlotSpinTime[3], function()
		self:CalcWinnings( random )
	end )

	// Prevent spin button spam
	timer.Simple( Casino.SlotSpinTime[3] + 1, function()
		self.SlotsSpinning = false
	end )
end

// Ranked highest to lowest
ENT.ExactCombos = {
	["6"] = { 2, 2, 2 }, //Jackpot?
	["5.5"] = { 1, 1, 1 },
	["5"] = { 3, 3, 3 },
	["4.5"] = { 4, 4, 4 },
	["4"] = { 5, 5, 5 },
	["3.5"] = { 6, 6, 6 },
}

ENT.AnyTwoCombos = {
	["2.5"] = 2,
}

function ENT:CalcWinnings( random )

	if !self:IsInUse() then
		return
	end

	local ply = self:GetPlayer()
	local winnings = 0

	if Emotions then
		ply:SetEmotion(EMOTION_SAD, 2)
	end

	self:SetJackpot( math.min( self:GetJackpot() + math.Round( self.BetAmount / 2 ), 80000 ) )

	// Jackpot
	if table.concat(random) == "222" then
		local winnings = math.Round( self:GetJackpot() + self.BetAmount )
		self:SendWinnings( ply, winnings, true )

		self:SetJackpot(self:GetRandomPotSize())

		return
	end

	// Exact Combos
	for x, combo in pairs( self.ExactCombos ) do
		if table.concat(random) == table.concat(combo) then
			local winnings = math.Round( self.BetAmount * tonumber(x) )
			self:SendWinnings( ply, winnings )
			return
		end
	end

	// Any Two Combos
	for x, combo in pairs( self.AnyTwoCombos ) do
		if random[3] == combo then
			local winnings = math.Round( self.BetAmount * tonumber(x) )
			self:SendWinnings( ply, winnings )
			return
		end
	end

	// Player lost
	ply:MsgI( "slots", "SlotsLose" )

end

function ENT:BroadcastJackpot(ply, amount)

	GTowerChat.AddChat( T( "SlotsJackpotAll", string.upper( ply:Name() ), string.FormatNumber( amount ) ), Color( 255, 200, 0 ), "Server" )

end

function ENT:SendWinnings( ply, amount, bJackpot )

	if Emotions then
		ply:SetEmotion(EMOTION_EXCITED, 2)
	end

	if bJackpot then

		self:BroadcastJackpot( ply, amount )
		ply:MsgI( "slots", "SlotsJackpot" )
		ply:GiveMoney( amount, false, self )
		ply:AddAchievement( ACHIEVEMENTS.MONEYWASTER, 1 )
		self:EmitSoundInLocation( Casino.SlotJackpotSound, 100, 100 )
		self.Jackpot = CurTime() + 25

	else
		self:EmitSoundInLocation( Casino.SlotWinSound, 75, 100 )
		ply:MsgI( "slots", "SlotsWin", string.FormatNumber(amount) )
		ply:GiveMoney( amount, false, self )
	end

	if self.light then
		self.light:CreateLight( bJackpot )
	end

	net.Start( "casino.slots.win" )
		net.WriteEntity( self )
		net.WriteBool( bJackpot )
	net.SendPVS( self:GetPos() )

	--GAMEMODE:Payout( ply, amount )

	//ParticleEffect( "coins", self:GetPos(), self:GetForward(), self )

end

util.AddNetworkString( "casino.slots.play" )
util.AddNetworkString( "casino.slots.result" )
util.AddNetworkString( "casino.slots.win" )