AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

include("dice.lua")

function ENT:Initialize()

	self:SetModel( self.Model )
	self:SetSubMaterial( 2, self.Material )
	self:SetUseType( SIMPLE_USE )
	self:SetSolid( SOLID_VPHYSICS )

	self:DrawShadow( false )

	local phys = self:GetPhysicsObject()

	if(phys:IsValid()) then

		phys:Wake()
		phys:EnableMotion( false )

	end

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

function ENT:Use( activator, caller )

	local prize
	local gmc_earn

	if IsValid( caller ) and caller:IsPlayer() then
		if self:GetState() == 0 && caller.IsSpinning != true  then
			if caller:Afford( self.Cost ) then
				caller.IsSpinning = true
				caller:TakeMoney( self.Cost, false, self )
				caller:AddAchievement( ACHIEVEMENTS.BORNTOSPIN, 1 )

				self:SetSpinTime( self.SpinDuration )
				self:SetState( 4 )

				self:SetTarget( tonumber( self:SpinRoll() ) - 1 )
				self:SetUser( caller )
				prize = ( self:GetTarget() + 1 )
				timer.Simple( self.SpinDuration + self.ExtraSettleTime, function()
					self:SetState( 0 )
					self:SetUser( NULL )
					if IsValid( caller ) then
						caller.IsSpinning = false
						self:PayOut( caller,prize )
					end
				end)
			else
				caller:Msg2( "[Spinner] You cannot spin, you do not have enough GMC." )
			end
		elseif caller.IsSpinning == true then
			caller:Msg2( "[Spinner] You cannot spin, you are already spinning a wheel." )
		end
	end

end

function ENT:SendItem( caller, entity_name )

	if entity_name == "[No Entity Found]" then return end

	local Item = GTowerItems:Get( simplehash( entity_name ) )

	local UniqueModel = Item.Model

	if Item.UniqueInventory == true && caller:HasItemById( Item.MysqlId ) then
		caller:AddMoney( math.floor( Item.StorePrice / 2 ), true, true, true)
		caller:Msg2( "[Spinner] You already own this unique item, so you've won its sell value!" )
	else
		caller:InvGiveItem( simplehash( entity_name ), slot )

		CreateModelBezier( {
			pos = util.GetCenterPos( self ),
			goal_entity = caller,
	
			model = UniqueModel,
			count = 1,
					
			approach = 0.5,
			duration = 2.0,
			random_position = 0,
			spin = 0,
	
			begin = true,
		} )
	end

end

function ENT:PayOut( ply, prize )

	local entity_name
	local gmc_earn
	local realprize

	if self.SLOTS[prize][3] != nil then
		if prize == 3 then
			entity_name = self.SLOTS[prize][3][math.random(1,4)]
		else
			entity_name = self.SLOTS[prize][3]
		end
	else
		entity_name = "[No Entity Found]"
	end

	if prize == 1 || prize == 2 || prize == 8 || prize == 16 then
		self:EmitSound( self.LoseSound )
	elseif prize == 4 || prize == 5 || prize == 10 || prize == 11 || prize == 13 then
		realprize = self.SLOTS[prize][1]
		self:Win( ply, 3, self.SoundSet, entity_name, nil, realprize, nil )
	else
		realprize = self.SLOTS[prize][1]
		self:Win( ply, 2, self.SoundSet, entity_name, nil, realprize, nil )
	end

	if string.StartWith( self.SLOTS[prize][1], "Lose" ) then
		gmc_earn = self.GMCPayouts[prize]
		self:Win( ply, 3, self.SoundSet, nil, nil, nil, gmc_earn )
	elseif string.StartWith( self.SLOTS[prize][1], "10 Candy" ) then
		gmc_earn = self.GMCPayouts[prize]
		self:Win( ply, 3, self.SoundSet, nil, nil, nil, gmc_earn )
		ply.Candy = ( ply.Candy or 0 ) + 10
	end

end

function WinEffects( ply, repetitions )

	local effectdata = EffectData();
	effectdata:SetOrigin( ply:GetPos() );
	effectdata:SetStart( Vector(1, 1, 1) );
	util.Effect("confetti", effectdata);

	timer.Create( "FunniEffects"..tostring( ply:EntIndex() ), 0.5, repetitions, function()
		local eff = EffectData()

		eff:SetOrigin( ply:GetPos() + ( ply:GetForward() * 2 ) + ( ply:GetRight() * math.random( -50,50 ) ) + ( ply:GetUp() * math.random( -50,50 ) ) )
		eff:SetEntity( ply )

		util.Effect( "firework_npc", eff )

		ply:EmitSound( "GModTower/lobby/firework/firework_explode.wav",
			/*eff:GetOrigin(),*/
			30,
			math.random( 150, 200 ) )
	end )

end

function ENT:Win( ply, times, winSound, prize, prizeNum, prizeName, GMC )

	if winSound != nil then
		self:EmitSound( winSound, 70 )
		WinEffects( ply, times )
	end

	if ( GMC != nil ) then
		ply:AddMoney( GMC )
	else
		local count = ( prizeNum or 1 )

		for i=1, count do
			self:SendItem( ply, prize )
		end
	end

	ply:Msg2( "[Spinner] You won: " .. string.upper( prizeName ) )

end