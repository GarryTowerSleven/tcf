AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		timer.Simple( 0.0, function()
			GTowerStore:OpenStore( ply, 29 )
		end)

		self:EmitSound("ambient/rottenburg/smallbird_0"..math.random(4,7)..".wav")


    end

end
