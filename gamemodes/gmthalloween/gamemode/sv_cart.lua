concommand.Add( "gmt_leavetrain", function( ply )
	EjectPassengers( ply )
end )

function EjectPassengers( ply )

	if IsValid( ply.Cart ) && ply.Cart.Depart != true then
		if ply:InVehicle() then
			ply:ExitVehicle()
		end

		ply:SetPos( ply.Cart:GetPos() - Vector( 0, 160, 0 ) )
		ply:SetEyeAngles( Angle( 0, -180, 0 ) )

		TrainLeave( ply, ply.Cart )

		ply.Cart = nil
	end

end

hook.Add( "CanExitVehicle", "CartExitDisallow", function( veh, ply )
	return ply.Cart && !ply.Cart.Depart
end )

hook.Add( "PlayerLeaveVehicle", "CartLeaveException", function( ply, veh )
	EjectPassengers( ply )
end )

hook.Add( "PlayerDisconnected", "DisconnectTrainLeave", function( ply )

	if IsValid( ply.Cart ) then
		TrainLeave( ply, ply.Cart )
	end

end )

function TrainLeave( ply, cart )

	if table.HasValue( cart.Players, ply ) then
		table.RemoveByValue( cart.Players, ply )
	end

	cart.Passengers = cart.Passengers - 1

	if cart.Passengers == 2 || cart.Leave == true then 
		cart.IsFull = true 
	else
		cart.IsFull = false
	end

end

hook.Add( "TrainEnter","CheckTrainLogic", function( ply, ent )

	if !IsValid( ply ) or !IsValid( ent ) then return end

	local cart = ent:GetParent()

	if !IsValid( cart ) then return end

	ply.Cart = cart

	table.insert( cart.Players, ply )

	cart.Passengers = cart.Passengers + 1

	if cart.Passengers == 2 then 
		cart.IsFull = true
	else
		cart.IsFull = false 
	end

end )