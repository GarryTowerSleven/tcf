ENT.Base = "base_brush"
ENT.Type = "brush"

util.AddNetworkString( "FerrisWheelPlayerAdded" )

function ENT:Initialize()
end

function ENT:StartTouch( ply )

	local FerrisWheel = ents.FindByClass("gmt_ferriswheel")[1]
	if ( !IsValid( FerrisWheel ) or !IsValid(ply) ) then return end

	if !ply:IsPlayer() then return end

	local seat

	if ply:GetPos().y <= 1388 then
		seat = 1
	else
		seat = 2
	end

	if ply.IsSeated == nil || ply.IsSeated == false then

		ply:SetOwner( FerrisWheel )

		net.Start( "FerrisWheelPlayerAdded" )
			net.WriteEntity( FerrisWheel )
			net.WriteEntity( ply )
			net.WriteUInt( FerrisWheel:GetBottomCarriage(FerrisWheel:GetCurrentRotation()) , 8 )
			net.WriteUInt( seat , 1 )
		net.Broadcast()
		ply:SetPos(Vector('-6526.492188 970.022400 -857.061646'))
		ply.IsSeated = true

	end

end

function ENT:EndTouch( ply )
end

function ENT:Touch()
end

function ENT:KeyValue( key, value )
end

function ENT:AcceptInput( input, activator, ply )

end

hook.Add( "KeyPress", "LeaveFerrisWheel", function( ply, key )
	if ( key == IN_USE ) then
		if ply.IsSeated then
			ply:SetPos( Vector(-6599, 1361, -794) )
			ply.IsSeated = false
			ply:SetOwner(ply)
		end
	end
end )
