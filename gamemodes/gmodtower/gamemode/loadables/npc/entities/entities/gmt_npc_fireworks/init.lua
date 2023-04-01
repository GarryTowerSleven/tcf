AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.FireWorkDelay = CurTime()

function ENT:AdditionalThink()

	if ( self.FireWorkDelay > CurTime() ) then return end

	if ( math.random( 1, 2 ) == 1 ) then
		local eff = EffectData()
	
		eff:SetOrigin( self:GetPos() + Vector( 0, 0, 100 ) + ( VectorRand():GetNormal() * 25 )  )
		eff:SetEntity( self )
	
		util.Effect( "firework_npc", eff )
	end

	self.FireWorkDelay = CurTime() + .5
	
end