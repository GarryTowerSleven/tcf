AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

/*
function ENT:UpdateModel()
	self:SetModel( self.Model )
	self:UpdateAnimation()
end

function ENT:UpdateAnimation()
	if !IsValid( self ) then
		return
	end

	local anim = self:LookupSequence("idle_subtle")

	if anim <= 0 then
		Msg("Could not find animation")
	end

	self:SetAnimation( anim )

end
*/
function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		GTowerStore:OpenStore( ply, 8 )
			if self:GetNWBool("Sale") then
				if math.random(1,2) == 1 then
					self:EmitSound(Sound("GModTower/stores/merchant/sale.wav"), 75, 100, 1, CHAN_VOICE)
				else
					self:EmitSound(Sound("GModTower/stores/merchant/sale2.wav"), 75, 100, 1, CHAN_VOICE)
				end
			else
				self:EmitSound(Sound("GModTower/stores/merchant/open.wav"), 75, 100, 1, CHAN_VOICE)
			end
    end

	--timer.Simple( 0.0, self.UpdateAnimation, self )
end

function ENT:Think()
	if self.TaskSequenceEnd == nil then
		self:PlaySequence(self:LookupSequence("scaredidle"), nil, nil, 1)
	end
end