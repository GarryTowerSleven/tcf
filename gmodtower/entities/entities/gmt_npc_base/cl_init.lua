include( "cl_expression.lua" )
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.NPCExpression = ""
ENT.AnimSpeed = 1

function ENT:Think()

	if self.NPCExpression != self:GetExpression() then
		self.NPCExpression = self:GetExpression()
	end

	if not self:IsDormant() then
		local dt = RealTime() - (self.LastThink or RealTime())
		self.Entity:FrameAdvance( dt * self.AnimSpeed )
		self:SetExpression( self.NPCExpression )
	end

	self:SetNextClientThink( CurTime() )
	self.LastThink = RealTime()

	return true

end

function ENT:Draw()
	self:DrawModel()
end

local new = Material( "gmod_tower/icons/new_large.png" )
local newsize = 256/2.5

function ENT:DrawTranslucent()

	if self:IsDormant() then return end

	local offset = Vector( 0, 0, 90 )
	
	-- Offset PVP and Ballrace stores
	if ( self:GetStoreId() == 3 or self:GetStoreId() == 5 ) then
		offset = Vector( 0, 0, 110 )
	elseif self:GetStoreId() == 21 then
		offset = Vector( 0, 0, 100 )
	end
	
	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos() + offset + ang:Up() * ( math.sin( RealTime() ) * 4 ) + Vector( 0, 0, -5 )

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )


	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
		if self:GetNew() then
			surface.SetMaterial( new )
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( -newsize/2, -newsize/2 - 6, newsize, newsize )
		end
	cam.End3D2D()
	
end