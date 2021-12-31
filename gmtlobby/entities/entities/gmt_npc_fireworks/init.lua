AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Think()

	if ( math.random( 1, 2 ) == 1 ) then
	
		local eff = EffectData()
	
		eff:SetOrigin( self:GetPos() + Vector( 0, 0, 100 ) + ( VectorRand():GetNormal() * 25 )  )
		eff:SetEntity( self )
	
		util.Effect( "firework_npc", eff )
		
		--self:EmitSound( "GModTower/lobby/firework/firework_explode.wav",
		--	eff:GetOrigin(),
		--	math.random( 30, 50 ),
		--	math.random( 150, 200 ) )
		
	end
	
	self:NextThink( CurTime() + 0.50 )
	
	return true
	
end