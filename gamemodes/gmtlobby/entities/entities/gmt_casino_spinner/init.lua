AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

include("dice.lua")

function ENT:Initialize()
	self:SetModel( self.Model )
	self:SetSubMaterial( 2, self.Material )
	self:SetUseType( SIMPLE_USE )
	self:SetSolid( SOLID_VPHYSICS )
end

function ENT:SpinRoll()
	local sides = {}

	for i=1, 21 do
		table.insert(sides,6)
	end

	local dice = dice.roll(sides)

	local rolls = 0

	for k,v in pairs( dice ) do
		if v == 1 then rolls = rolls + 1 end
	end

	local candidates = {}

	for k,v in pairs( self.SLOTS ) do
		if math.floor( math.Rand( 1, v[2] * 2 ) ) == 1 then
			local rand = v[2] < 600
			local rand2 = v[2] > 699
			if rand2 and math.random(100) == 1 or !rand and math.random(20) == 1 or rand then
				table.insert(candidates, {num = k, odds = v[2]})
			end
		else

		end
	end

	if #candidates == 0 then
		if math.random(3) == 1 then
			table.insert(candidates, {num = 1, 0})
		else
			table.insert(candidates, {num = 5, 0})
		end
	end

	table.sort( candidates, function(a,b) return a.odds > b.odds end)

	if !candidates[1] then return 1 end

	return ( candidates[1].num )
end

concommand.Add( "spinner_odds", function( ply, cmd, args )
	if ( ply != NULL ) then return end

	local ent = ents.FindByClass( 'gmt_casino_spinner' )[1]
	if ( not ent ) then return end

	local num = tonumber( args[1] or 1000 )

	print( Format( "Simulating %s spins...", num ) .. "\n" )

	local res = {}

	for i=1, num do
		local p = ent:SpinRoll()
		local prize = ent.SLOTS[ p ][1]

		if ( not res[ prize ] ) then res[ prize ] = 0 end

		res[ prize ] = res[ prize ] + 1
	end

	PrintTable( res )
end )

function ENT:Use( activator, caller )
	local prize
	local gmc_earn
	if IsValid( caller ) and caller:IsPlayer() then
		if self:GetState() == 0 && caller.IsSpinning != true  then
			if caller:Afford( self.Cost ) then
				caller.IsSpinning = true
				caller:AddMoney(-self.Cost)
				caller:AddAchievement( ACHIEVEMENTS.BORNTOSPIN, 1 )

				self:SetSpinTime(self.SpinDuration)
				self:SetState(4)

				local ent = ents.Create("gmt_money_bezier")

				if IsValid( ent ) then
				  ent:SetPos( caller:GetPos() + Vector( 0, 0, -10 ) )
				  ent.GoalEntity = self
				  ent.GMC = 100
				  ent.RandPosAmount = 50
				  ent:Spawn()
				  ent:Activate()
				  ent:Begin()
				end			

				self:SetTarget( tonumber(self:SpinRoll()) - 1 )
				self:SetUser(caller)
				prize = self:GetTarget() + 1
				timer.Simple( self.SpinDuration + self.ExtraSettleTime, function()
					if IsValid( caller ) then
						self:SetState(0)
						self:SetUser(NULL)
						caller.IsSpinning = false
						self:PayOut(caller,prize)
					end
				end)
			else
				caller:Msg2('You cannot spin, you do not have enough GMC.')
			end
		elseif caller.IsSpinning == true then
			caller:Msg2( "You cannot spin, you are already spinning a wheel." )
		end
	end
end

function ENT:SendItem(caller,entity_name)
	if entity_name == "[No Entity Found]" then return end

	local UniqueModel = GTowerItems:Get( simplehash(entity_name) ).Model
	caller:InvGiveItem( simplehash(entity_name), slot )

	local mdlbzr = ents.Create("gmt_model_bezier")

	if IsValid( mdlbzr ) then
		mdlbzr:SetPos( self.Entity:GetPos() )
		mdlbzr.GoalEntity = caller
		mdlbzr.ModelString = UniqueModel
		mdlbzr.RandPosAmount = 0
		mdlbzr:Spawn()
		mdlbzr:Activate()
		mdlbzr:Begin()
	end
end

function ENT:PayOut(ply,prize)
	local entity_name
	local gmc_earn

	local item = self.SLOTS[prize]

	if item[3] != nil then
		if prize == 14 then
			entity_name = item[3][math.random(1,13)]
		elseif prize == 15 then
			entity_name = item[3][math.random(1,12)]
		else
			entity_name = item[3]
		end
	else
		entity_name = "[No Entity Found]"
	end

	--ply:ChatPrint('Won ' .. item[1] .. ', Entity Name is: ' .. entity_name .. '.')

	if prize == 1 || prize == 5 then
		self:EmitSound("GModTower/misc/sad.mp3", 70)
		if prize == 5 then
			ply:AddMoney(1)
		end
	elseif prize == 2 || prize == 3 || prize == 4 || prize == 6 || prize == 7 || prize == 8 || prize == 10 then
		local realprize = item[1]
		BasicWin(self)
		timer.Simple( 0.5, function() BasicWin(self) end)
		timer.Simple( 0.5, function() BasicWin(self) end)
		self:EmitSound("GModTower/misc/win_gameshow.mp3", 70)
		self:SendItem( ply, entity_name )
		ply:Msg2("[Spinner] You won: " .. string.upper(realprize))
		SQLLog( "spinner", ply:Nick() .. " won: " .. string.upper(realprize) .. "." )
	else
		local realprize = item[1]
		BasicWin(self)
		timer.Simple( 0.5, function() BasicWin(self) end)
		self:EmitSound("GModTower/misc/win_crowd.mp3", 70)
		local count = item[4] or 1

		for i=1, count do
			self:SendItem( ply, entity_name )
		end

		ply:Msg2("[Spinner] You won: " .. string.upper(realprize))
		SQLLog( "spinner", ply:Nick() .. " won: " .. string.upper(realprize) .. "." )
	end

	if prize != 5 && string.EndsWith(item[1],'GMC') then
		BasicWin(self)
		timer.Simple( 0.5, function() BasicWin(self) end)
		timer.Simple( 0.5, function() BasicWin(self) end)
		self:EmitSound("GModTower/misc/win_gameshow.mp3", 70)
		gmc_earn = self.GMCPayouts[prize]
		ply:AddMoney(gmc_earn)
	end
end

function BasicWin(ply)
	local effectdata = EffectData();
	effectdata:SetOrigin(ply:GetPos());
	effectdata:SetStart(Vector(1, 1, 1));
	util.Effect("confetti", effectdata);

	timer.Create("FunniEffects"..tostring(ply:EntIndex()),0.5,3,function()
		local eff = EffectData()

		eff:SetOrigin( ply:GetPos() + (ply:GetForward() * 2) + ( ply:GetRight() * math.random(-50,50) ) + ( ply:GetUp() * math.random(-50,50) )  )
		eff:SetEntity( ply )

		util.Effect( "firework_npc", eff )

		ply:EmitSound( "GModTower/lobby/firework/firework_explode.wav",
			/*eff:GetOrigin(),*/
			30,
			math.random( 150, 200 ) )
	end)

end
