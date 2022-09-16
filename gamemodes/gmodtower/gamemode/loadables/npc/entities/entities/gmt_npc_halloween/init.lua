AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Think()
	if self.TaskSequenceEnd == nil then
		self:PlaySequence(nil, "idle_all_01", nil, 1)
	end
end