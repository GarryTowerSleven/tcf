AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Think()
	if self.TaskSequenceEnd == nil then
		self:PlaySequence(self:LookupSequence("vip_store_idle01"), nil, nil, 1)
	end
end

function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		if !ply:GetNWBool("VIP") then ply:MsgI("gmtsmall", "StoreVIPOnly" ) return end
		timer.Simple( 0.0, function()
			GTowerStore:OpenStore( ply, self.StoreId )
		end )
    end 
end