EFFECT.Mat = Material("gmod_tower/lobby/sale")

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.NPC = data:GetEntity()
end

function EFFECT:Think( )
	return (self.NPC && self.NPC:GetSale()) // these deals can't last forever!
end

function EFFECT:Render( )
	render.SetMaterial( self.Mat )

	local sin = math.abs(math.sin(CurTime()*1.5))
	local eyevec = EyeVector()*-1
	eyevec.z = 0

	render.DrawQuadEasy(	self.Pos,
				eyevec,
				(64/2) + sin*4,
				(32/2) + sin*4,
				color_white,
				180 + ( 20 * sin ) - 10
				)
end