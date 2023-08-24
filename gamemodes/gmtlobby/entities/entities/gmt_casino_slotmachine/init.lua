---------------------------------
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

	if !IsLobby then
		self:SetAngles(Angle(0,90,0))
	end

	timer.Simple(1,function()
		self:SetupChair()
		self:SetupLight()
	end)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
	SQL.getDB():Query( "SELECT * FROM gm_casino WHERE type='slots'", function(res)
		local data = res[1].data[1]
		if #res[1].data == 0 then
			SQL.getDB():Query( "INSERT INTO gm_casino (type,jackpot) VALUES ('slots', " .. self:GetRandomPotSize() .. ")" )
		else
			self:SetJackpot(data.jackpot)
		end
	end)

end


function ENT:Think()

	// Player In Chair Check
	if !self.SlotsPlaying && self:IsInUse() then		// Game not in play, player in chair
		self:SendPlaying()
	elseif self.SlotsPlaying && !self:IsInUse() then	// Game in play, nobody in chair
		if IsValid(self.chair) then
			self.chair:Remove()
		end
		self.SlotsPlaying = nil
	else
		if !self.LastPlay or self.LastPlay < CurTime() then
			// self:PullLever()
			self:PickResults(true)
			self:EmitSound( Casino.SlotWinSound, 60, 100 )
			self.LastPlay = CurTime() + math.Rand(60, 140)
		end
	end

	// Player Idling Check
	if ( self.LastSpin + (60*3) < CurTime() ) && self:IsInUse() then
		local ply = self:GetPlayer()
		ply:ExitVehicle()
		//GAMEMODE:PlayerMessage( ply, "Slots", "You have been ejected due to idling!" )
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
local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER )
end

function ENT:SetupChair()

	// Chair Model
	self.chairMdl = ents.Create("prop_physics_multiplayer")
	self.chairMdl:SetModel("models/gmod_tower/aigik/casino_stool.mdl")
	//self.chairMdl:SetModel(self.ChairModel)
	--self.chairMdl:SetParent(self)

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

	self.chairMdl:DrawShadow( false )

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

end

function ENT:SetupVehicle()
	// Chair Vehicle
	self.chair = ents.Create("prop_vehicle_prisoner_pod")
	self.chair:SetModel("models/nova/airboat_seat.mdl")
	self.chair:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	self.chair:SetParent(self.chairMdl)
	self.chair:SetPos( self.chairMdl:GetPos() + Vector(0,0,30) )

	self.chair:SetAngles( Angle(0,self:GetAngles().y+90,0) )

	self.chair:SetNotSolid(true)
	self.chair:SetNoDraw(true)
	self.chair:DrawShadow( false )

	self.chair.HandleAnimation = HandleRollercoasterAnimation
	self.chair.bSlots = true

	self.chair:Spawn()
	self.chair:Activate()

	local phys = self.chair:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if (phys:IsValid()) then
		phys:EnableMotion(false)
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

		self:SetupVehicle()

		if !IsValid(self.chair) then return end -- just making sure...

		ply.SeatEnt = self.chair
		ply.EntryPoint = ply:GetPos()
		ply.EntryAngles = ply:EyeAngles()
		ply.LastBetTime = CurTime()

		ply:SetNWVector("SeatEntry",ply.EntryPoint)
		ply:SetNWVector("SeatEntryAng",ply.EntryAngles)

		ply:EnterVehicle( self.chair )
		self:SendPlaying( ply )
	else
		return
	end

end

hook.Add( "PlayerLeaveVehicle", "ResetCollisionVehicle", function( ply )

	ply.SeatEnt = nil
	ply.EntryPoint = nil
	ply.EntryAngles = nil
	ply.SlotMachine = nil

	umsg.Start("slotsPlaying", ply)
	umsg.End()

	ply:SetCollisionGroup( COLLISION_GROUP_PLAYER )
end )

hook.Add( "CanPlayerEnterVehicle", "PreventEntry", function( ply, vehicle )

	/*if ( ply:GetBilliardTable() ) then
		//GAMEMODE:PlayerMessage( ply, "Warning!", "You cannot play slots while you are in a billiards game.\nYou must quit your billiards game!" )
		return false
	end*/

	return true

end )

/*---------------------------------------------------------
	Console Commands
---------------------------------------------------------*/
concommand.Add( "slotm_spin", function( ply, cmd, args )
	local bet = tonumber(args[1]) or 10

	if ply.LastBetTime <= CurTime() then
		if bet < 10 then bet = 10 end
		if bet > 1000 then bet = 1000 end
		
		local ent = ply.SlotMachine

		if !ply:Afford( bet ) && IsValid(ent) && !ent.SlotsSpinning && !ent.Jackpot then
			ply:MsgI( "slots", "SlotsNoAfford" )
		else
			if IsValid(ent) && !ent.SlotsSpinning && !ent.Jackpot then
				ply:AddMoney(-bet)
				ply:AddAchievement( ACHIEVEMENTS.SOREFINGER, 1 )
				ent.LastSpin = CurTime()
				ent.BetAmount = bet
				ent:PullLever()
				ent:PickResults()

				local bzr = ents.Create("gmt_money_bezier")

				if IsValid( bzr ) then
					bzr:SetPos( ply:GetPos() - Vector(0,0,10) )
					bzr.GoalEntity = ent
					bzr.GMC = bet
					bzr.RandPosAmount = 5
					bzr.Offset = ent:GetRight() * -8 + ent:GetUp() * 28 - ent:GetForward() * 8
					bzr:Spawn()
					bzr:Activate()
					bzr:Begin()
				end

			end
		end
		ply.LastBetTime = CurTime() + 1
	end
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

	local rf = RecipientFilter()
	rf:AddPlayer( ply )

	umsg.Start("slotsPlaying", rf)
		umsg.Short( self:EntIndex() )
	umsg.End()

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
		if self:GetJackpot() < 5000 && math.random(5) != 1 then
			random[3] = math.random(6)
		elseif self:GetJackpot() < 10000 && math.random(4) != 1 then
			random[3] = math.random(6)
		elseif self:GetJackpot() < 25000 && math.random(3) != 1 then
			random[3] = math.random(6)
		elseif self:GetJackpot() < 50000 && math.random(2) != 1 then
			random[3] = math.random(6)
		end
	end

	umsg.Start("slotsResult", rf)
		umsg.Short( self:EntIndex() )
		umsg.Short( random[1] )
		umsg.Short( random[2] )
		umsg.Short( random[3] )
	umsg.End()

	if fake then return end
	
	self:EmitSound( Casino.SlotPullSound, 60, math.random(98, 102) )

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

	// Jackpot
	if table.concat(random) == "222" then
		local winnings = math.Round( self:GetJackpot() + self.BetAmount )
		self:SendWinnings( ply, winnings, true )

		self:SetJackpot(self:GetRandomPotSize())
		SQL.getDB():Query("UPDATE gm_casino SET jackpot=" .. self:GetJackpot() .. " WHERE type='slots'")

		return
	end

	// Exact Combos
	for x, combo in pairs( self.ExactCombos ) do
		if table.concat(random) == table.concat(combo) then
			local winnings = math.Round( self.BetAmount * tonumber(x) )
			self:SendWinnings( ply, winnings )
			SQL.getDB():Query("UPDATE gm_casino SET jackpot=jackpot + " .. math.Round( self.BetAmount / 2 ).. " WHERE type='slots'")
			self:SetJackpot( self:GetJackpot() + math.Round( self.BetAmount / 2 ) )
			return
		end
	end

	// Any Two Combos
	for x, combo in pairs( self.AnyTwoCombos ) do
		if random[3] == combo then
			local winnings = math.Round( self.BetAmount * tonumber(x) )
			self:SendWinnings( ply, winnings )
			SQL.getDB():Query("UPDATE gm_casino SET jackpot=jackpot + " .. math.Round( self.BetAmount / 2 ).. " WHERE type='slots'")
			self:SetJackpot( self:GetJackpot() + math.Round( self.BetAmount / 2 ) )
			return
		end
	end

	// Player lost
	ply:MsgI( "slots", "SlotsLose" )
	SQL.getDB():Query("UPDATE gm_casino SET jackpot=jackpot + " .. math.Round( self.BetAmount / 2 ).. " WHERE type='slots'")
	self:SetJackpot( self:GetJackpot() + math.Round( self.BetAmount / 2 ) )

end

function ENT:BroadcastJackpot(ply, amount)
	for _, v in ipairs(player.GetAll()) do
		if v != ply then
			v:MsgI( "slots", "SlotsJackpotAll", string.upper(ply:Name()), string.FormatNumber(amount) )
		end
	end
end

function ENT:SendWinnings( ply, amount, bJackpot )

	if bJackpot then
		self:BroadcastJackpot(ply, amount)
		ply:MsgI( "slots", "SlotsJackpot" )
		ply:AddMoney(amount, true, true)
		ply:AddAchievement( ACHIEVEMENTS.MONEYWASTER, 1 )
		self:EmitSound( Casino.SlotJackpotSound, 100, 100 )
		self.Jackpot = CurTime() + 25

		timer.Create("JackpotFun",0.25,50,function()

			local bzr = ents.Create("gmt_money_bezier")

			if IsValid( bzr ) then
				bzr:SetPos( self:GetPos() )
				bzr.GoalEntity = ply
				bzr.GMC = 50
				bzr.RandPosAmount = 5
				bzr:Spawn()
				bzr:Activate()
				bzr:Begin()
			end

		end)

	else
		self:EmitSound( Casino.SlotWinSound, 75, 100 )
		ply:MsgI( "slots", "SlotsWin", string.FormatNumber(amount) )
		ply:AddMoney(amount, true, true)

		local bzr = ents.Create("gmt_money_bezier")

		if IsValid( bzr ) then
			bzr:SetPos( self:GetPos() )
			bzr.GoalEntity = ply
			bzr.GMC = amount
			bzr.RandPosAmount = 10
			bzr:Spawn()
			bzr:Activate()
			bzr:Begin()
		end

	end

	if self.light then
		self.light:CreateLight( bJackpot )
	end

	--GAMEMODE:Payout( ply, amount )

	//ParticleEffect( "coins", self:GetPos(), self:GetForward(), self )

end
