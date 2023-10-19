ENT.Base = "base_point"
ENT.Type = "point"

ENT.Carts = {}
ENT.CartsInStation = {}
ENT.CartQueue = {}

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

		self.Carts[ k ] = v
		
	end

end

function ENT:GetCarts()
	return self.Carts
end

function ENT:GetAvailableCart()

	local carts = {}

	for _, v in ipairs( ents.FindByClass( "func_tracktrain" ) ) do
		if v.Stopped != nil && string.StartsWith( v.Stopped, "hr_trainstation" ) && v.Stopped != "hr_trainstationleave" && v.Depart != true then
			table.insert( carts, v )
		end
	end

	table.sort( carts, function( a, b )
		return self:TrainNumber( a ) < self:TrainNumber( b )
	end )

	self.CartsInStation = carts

	return self.CartsInStation, #self.CartsInStation

end

function ENT:RefreshCartQueue()

	local carts, c2 = self:GetAvailableCart()
	local newcarts = {}

	for _,v in pairs( carts ) do
		v.QueueNum = tonumber( v.Stopped[16] )
		newcarts[v.QueueNum] = v
	end

	self.CartQueue = newcarts

end

function ENT:GetCartQueue()
	return self.CartQueue
end

function ENT:StartRide()

	local carts = self:GetCarts()
	local doors = ents.FindByClass("func_door_rotating")

	for _, v in ipairs( doors ) do
		if v:GetName() == "hr_doors1" then
			v:Fire("Open")
		end
	end

	for _, v in ipairs( carts ) do
		self:Input( "StartForward", v, self )
	end

end

function ENT:AcceptInput( name, activator, caller, data )

	local cart = self:GetCarts()[self:TrainNumber( activator )]

	if name == "StartForward" then

		activator:Input( "StartForward", self, self )

		if cart.Stopped == "hr_trainstation1" then
			cart.Depart = true
			cart.IsFull = true
			cart.QueueNum = nil
		end

	elseif name == "Stop" then

		cart.Stopped = caller:GetName()

		activator:Input( "Stop", self, self )

		if caller:GetName() == "hr_trainstationleave" then
			local c1, c2 = self:GetAvailableCart()

			timer.Create( tostring(cart).."CartRestore", 5, 6-c2, function()
				activator:Input( "StartForward", self, self )

				if cart.Depart == true then
					for k,v in pairs( cart.Players ) do
						if IsValid( v ) then
							v:ConCommand( "gmt_leavetrain" )
							v:AddAchievement( ACHIEVEMENTS.HALLOWEENRIDE, 1 )
						end
					end

					cart.Depart = false
				end
			end )
		end

	elseif name == "TeleportToPathTrack" then
		
		activator:Input( "TeleportToPathTrack", self, self, data )

	end

	self:RefreshCartQueue()

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
			cart1.StartTime = 30 + CurTime()
		elseif cart1.StartTime != nil && CurTime() > cart1.StartTime && cart1.Passengers > 0 then
			self:StartRide()
		elseif cart1.Passengers == 0 then
			cart1.StartTime = nil
		end
	end

end 