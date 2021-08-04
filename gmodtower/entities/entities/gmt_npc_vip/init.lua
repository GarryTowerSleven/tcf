AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Think()
	if self.TaskSequenceEnd == nil then
		self:PlaySequence(2, nil, nil, 1)
	end
end

function ENT:AcceptInput( name, activator, ply )

	if !ply.IsVIP and !ply:IsVIP() then return end

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		timer.Simple( 0.0, function()
			GTowerStore:OpenStore( ply, self.StoreId )
		end )
    end 
end