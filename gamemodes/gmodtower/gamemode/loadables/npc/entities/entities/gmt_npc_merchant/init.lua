AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Use( ply )
	GTowerStore:OpenStore( ply, GTowerStore.MERCHANT )

	if self:IsOnSale() then
		if math.random(1,2) == 1 then
			self:EmitSound(Sound("GModTower/stores/merchant/sale.wav"), 75, 100, 1, CHAN_VOICE)
		else
			self:EmitSound(Sound("GModTower/stores/merchant/sale2.wav"), 75, 100, 1, CHAN_VOICE)
		end
	else
		self:EmitSound(Sound("GModTower/stores/merchant/open.wav"), 75, 100, 1, CHAN_VOICE)
	end
end