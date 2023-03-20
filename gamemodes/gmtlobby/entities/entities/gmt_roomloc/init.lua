AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

/*function ENT:Initialize()
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end*/

function ENT:SetId( id )
	self.RoomId = id
	self:SetNWInt( "RoomID", id )
end