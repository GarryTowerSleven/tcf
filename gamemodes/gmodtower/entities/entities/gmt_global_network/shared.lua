AddCSLuaFile()

ENT.Base		= "base_anim"
ENT.Type		= "anim"

function ENT:Initialize()

	if SERVER then

		self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

	end

	globalnet.InitializeOn( self )

end

/*function ENT:SetupDataTables()
	globalnet.InitializeOn( self )
end*/

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Draw()
end