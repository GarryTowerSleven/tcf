AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Think()
	if self.TaskSequenceEnd == nil then
		self:PlaySequence(1, nil, nil, 1)
	end
end

/*
function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		
		timer.Simple( 0.0, function()
			self:TypeOnComp()
			
			 GTowerRooms.OpenStore( ply )
		end )
		
    end 
end
*/