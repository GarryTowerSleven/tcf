ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:StartTouch( ply )

	if IsValid( ply ) && !ply:IsPlayer() then return end

	nums = {}

	for k,v in pairs( ents.FindByClass("func_tracktrain") ) do

		if !v.QueueNum then continue end

		local num = tonumber( v.QueueNum )

		if num > 0 && num < 7 then
			table.insert( nums, {num,v} )
		end

	end

	table.sort( nums, function(a,b) return a[1] < b[1] end )

	local ent

	pcall( function() ent = nums[1][2] end )

	if !IsValid( ent ) then
		ply:Msg2("There are currently no carts available, please wait.")
		return
	end

	local vehicles = {}
	local vehicle

	for k,v in pairs( ents.FindByClass( "prop_vehicle_prisoner_pod" ) ) do

		if v:GetParent() == ent then
			table.insert( vehicles, v )
		end

	end

	for k,v in pairs( vehicles ) do

		if !IsValid( v:GetPassenger(1) ) then
			local cart = v:GetParent()
			local seat

			if cart:GetName() != "hr_tracktrain1" && cart.Passengers == 0 then
				seat = vehicles[1]
			else
				seat = v
			end

			vehicle = seat
		end

	end

	if !IsValid( vehicle ) then return end

	local modifier = ( ( vehicle:GetParent().QueueNum * 2 ) - 2 )

	ply:EnterVehicle( vehicle )

	if vehicle:GetParent() == ent then
		modifier = 0
	end

	hook.Run( "TrainEnter", ply, vehicle )

	ply:ChatPrint("You are in the queue! Position: #"..( vehicle:GetParent().Passengers + modifier ) )

end
