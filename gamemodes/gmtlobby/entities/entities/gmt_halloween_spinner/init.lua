---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

include("dice.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSubMaterial(2,self.Material)
	self:SetUseType( SIMPLE_USE )
	self:SetSolid(SOLID_VPHYSICS)

	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()

	if(phys:IsValid()) then

		phys:Wake()
		phys:EnableMotion(false)

	end
end

function ENT:SpinRoll()
	local sides = {}

	for i=1, 30 do
		table.insert(sides,6)
	end

	local dice = dice.roll(sides)

	local rolls = 0

	for k,v in pairs( dice ) do
		if v == 1 then rolls = rolls + 1 end
	end

	local candidates = {}

	for k,v in pairs( self.SLOTS ) do
		if v[2] <= rolls then table.insert( candidates, { odds = v[2], num = k } ) end
	end

	table.sort( candidates, function(a,b) return a.odds > b.odds end)

	if !candidates[1] then return 1 end

	return( candidates[1].num )

end

function ENT:Use( activator, caller )
	local prize
	local gmc_earn
	local ply = caller
	if IsValid( caller ) and caller:IsPlayer() then
		if self:GetState() == 0 && caller.IsSpinning != true  then
			if caller:Afford( self.Cost ) then
				caller.IsSpinning = true
				caller:AddMoney(-self.Cost)

				local bzr = ents.Create("gmt_money_bezier")

				if IsValid( bzr ) then
					bzr:SetPos( caller:GetPos() )
					bzr.GoalEntity = self
					bzr.GMC = self.Cost
					bzr.RandPosAmount = 10
					bzr:Spawn()
					bzr:Activate()
					bzr:Begin()
				end

				self:SetSpinTime(self.SpinDuration)
				self:SetState(4)

				self:SetTarget( tonumber(self:SpinRoll()) - 1 )
				self:SetUser(caller)
				prize = self:GetTarget() + 1
				timer.Simple( self.SpinDuration + self.ExtraSettleTime, function()
					self:SetState(0)
					self:SetUser(NULL)
					caller.IsSpinning = false
					self:PayOut(ply,prize)
				end)
			else
				caller:Msg2('You cannot spin, you have do not have enough GMC.')
			end
		end
	end
end

function ENT:SendItem(caller,entity_name)
	if entity_name == "[No Entity Found]" || entity_name == "slappers" then return end

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

	if self.SLOTS[prize][3] != nil then
		if prize == 3 then
			entity_name = self.SLOTS[prize][3][math.random(1,4)]
		else
			entity_name = self.SLOTS[prize][3]
		end
	else
		entity_name = "[No Entity Found]"
	end

	--ply:ChatPrint('Won ' .. self.SLOTS[prize][1] .. ', Entity Name is: ' .. entity_name .. '.')

	if prize == 1 || prize == 2 || prize == 8 || prize == 16 then
		self:EmitSound(self.LoseSound)
	elseif prize == 4 || prize == 5 || prize == 10 || prize == 11 || prize == 13 then
		local realprize = self.SLOTS[prize][1]
		BasicWin(self)
		timer.Simple( 0.5, function() BasicWin(self) end)
		timer.Simple( 0.5, function() BasicWin(self) end)
		self:EmitSound(self.SoundSet)
		self:SendItem(ply,entity_name)
		ply:Msg2("[Spinner] You won: " .. string.upper(realprize))
	else
		local realprize = self.SLOTS[prize][1]
		BasicWin(self)
		timer.Simple( 0.5, function() BasicWin(self) end)
		self:EmitSound(self.SoundSet)
		self:SendItem(ply,entity_name)
		ply:Msg2("[Spinner] You won: " .. string.upper(realprize))
	end

	if string.StartWith(self.SLOTS[prize][1],'Lose') then
		BasicWin(self)
		timer.Simple( 0.5, function() BasicWin(self) end)
		timer.Simple( 0.5, function() BasicWin(self) end)
		self:EmitSound(self.SoundSet)
		gmc_earn = self.GMCPayouts[prize]
		ply:AddMoney(gmc_earn)
	elseif string.StartWith(self.SLOTS[prize][1],'10 Candy') then
		BasicWin(self)
		timer.Simple( 0.5, function() BasicWin(self) end)
		timer.Simple( 0.5, function() BasicWin(self) end)
		self:EmitSound(self.SoundSet)
		gmc_earn = self.GMCPayouts[prize]
		ply.Candy = (ply.Candy or 0) + 10
	end
end
