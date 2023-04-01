include( "shared.lua" )

module( "clsound", package.seeall )

net.Receive( "CLSound", function( length, ply )

	local ent = net.ReadEntity()
	local snd = ClientSounds[net.ReadInt(8) or 1]
	local volume = net.ReadInt(9) or 0
	local pitch = net.ReadInt(9) or 0

	// Default the volume and pitch
	if volume == 0 then volume = 100 end
	if pitch == 0 then pitch = 100 end

	if snd and IsValid( ent ) and ent.EmitSound then
		ent:EmitSound( snd, volume, pitch )
	end

end )