AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

/*
function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		
		timer.Simple( 0.0, function()
			self:TypeOnComp()
			
			GTowerStore:OpenStore( ply, GTowerItems.BarStoreId )
		end )
		
    end 
end*/