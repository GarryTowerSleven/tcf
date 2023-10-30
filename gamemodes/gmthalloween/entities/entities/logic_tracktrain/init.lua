ENT.Base = "base_point"
ENT.Type = "point"

ENT.Carts = {}

function ENT:Initialize()
	self:SetupCarts()
end

function ENT:TrainNumber( train )
	return tonumber( ( train:GetName() or "" ):sub( -1 ) ) or 1
end

function ENT:FindCarts()

	local carts = {}

	for _, v in ipairs( ents.FindByClass( "func_tracktrain" ) ) do
		if string.StartsWith( v:GetName(), "hr_tracktrain" ) then
			table.insert( carts, v )
		end
	end

	table.sort( carts, function( a, b )
		return self:TrainNumber( a ) < self:TrainNumber( b )
	end )

	return carts

end

function ENT:SetupCarts()

	local carts = self:FindCarts()

	for k, v in ipairs( carts ) do

		v.QueueNum = k
		self.Carts[ k ] = v
		
	end

	ents.FindByClass( "trigger_trainqueue" )[1]:RefreshQueue()

end

function ENT:GetCarts()
	return self.Carts
end

function ENT:GetCartQueue()
	return ents.FindByClass( "trigger_trainqueue" )[1].Queue
end

function ENT:StartRide()

	local carts = self:GetCarts()

	for _, v in ipairs( carts ) do
		self:Input( "StartForward", v, self )
	end

end

function ENT:AcceptInput( name, activator, caller, data )

	local cart = self:GetCarts()[self:TrainNumber( activator )]

	if !IsValid( cart ) then return end

	if name == "StartForward" then

		activator:Input( "StartForward", self, self )

		if cart.Stopped == "hr_trainstation1" then
			cart.Depart = true
			cart.IsFull = true
			cart.QueueNum = nil
		end

		ents.FindByClass( "trigger_trainqueue" )[1]:RefreshQueue()

	elseif name == "Stop" then

		cart.Stopped = caller:GetName()

		activator:Input( "Stop", self, self )

		if cart.Station != nil then
			if cart.Stopped == cart.Station then
				cart.Station = nil
			else
				activator:Input( "StartForward", self, self )
			end
		end

		if caller:GetName() == "hr_trainstationleave" then
			ents.FindByClass( "trigger_trainqueue" )[1]:RefreshQueue()

			local carts = #self:GetCartQueue()

			for k,v in pairs( cart.Players ) do

				if IsValid( v ) then
					v.RideCompleted = true
					v.RideCompleteTimer = 0.5 + CurTime()
					v:ConCommand( "gmt_leavetrain" )
				end

			end

			cart.Depart = false
			cart.IsFull = false
			cart.QueueNum = carts + 1

			cart.Station = "hr_trainstation"..(cart.QueueNum)

			activator:Input( "StartForward", self, self )
		end

	elseif name == "TeleportToPathTrack" then
		
		activator:Input( "TeleportToPathTrack", self, self, data )

	end

end

function ENT:KeyValue( key, value )

	if key == "targetname" then
		self:SetName( value )
	end

end

function ENT:Think()

	local cart1 = self:GetCartQueue()[1]

	if IsValid( cart1 ) then
		if cart1.StartTime == nil && cart1.Passengers > 0 then
			cart1.StartTime = 40 + CurTime()
		elseif cart1.StartTime != nil && CurTime() > cart1.StartTime && cart1.Passengers > 0 then
			self:StartRide()
		elseif cart1.Passengers == 0 then
			cart1.StartTime = nil
		end
	end

end 