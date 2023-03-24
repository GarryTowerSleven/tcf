include( "cl_expression.lua" )
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.NPCExpression = ""
ENT.AnimSpeed = 1

function ENT:Think()

	if self.NPCExpression != self:GetExpression() then
		ClientsideScene("scenes/Expressions/citizen_normal_idle_01.vcd", self.MDL or self)
		self.NPCExpression = self:GetExpression()
	end

	if not self:IsDormant() then
		// local dt = RealTime() - (self.LastThink or RealTime())
		// self.Entity:FrameAdvance( dt * self.AnimSpeed )
		// self:SetExpression( self.NPCExpression )
	end

	self:SetNextClientThink( CurTime() )
	self.LastThink = RealTime()

	/*for p, ply in ipairs(player.GetAll()) do
		if ply:Location() != self:Location() then return end
		if(ply:EyePos():Distance(self:EyePos()) <= 128) then
			self:SetEyeTarget(ply:EyePos())
			break
		end
	end*/

	return true

end

function ENT:Draw()
	if self.Bonemerge then
		if !IsValid(self.MDL) then
			self.MDL = ClientsideModel(self.Bonemerge)
		else
			self.MDL:SetPos(self:GetPos())
			self.MDL:SetParent(self)
			self.MDL:AddEffects(EF_BONEMERGE)
		end

		return
	end

	self:DrawModel()
end

local new = Material( "gmod_tower/icons/new_large.png" )
local newsize = 256/2.5

function ENT:DrawTranslucent()

	if ( not IsLobbyOne ) then return end

	local title = self:GetTitle()
	local offset = Vector( 0, 0, 90 )

	if !title then title = "" end
	
	-- Offset PVP and Ballrace stores
	if ( self:GetStoreId() == 3 || self:GetStoreId() == 5 ) then
		offset = Vector( 0, 0, 110 )
	elseif self:GetStoreId() == 21 then
		offset = Vector( 0, 0, 100 )
	elseif self:GetStoreId() == 69 then
		offset = Vector( 0, 0, 130 )
	elseif self:IsOnSale() then
		offset = Vector( 0, 0, 120 )
	end
	
	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos() + offset + ang:Up() * ( math.sin( CurTime() ) * 4 ) + Vector( 0, 0, -5 )

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.125 )
		draw.DrawText( title, "GTowerNPC", 2, 2, Color( 0, 0, 0, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( title, "GTowerNPC", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if self:HasNewItems() then
			surface.SetMaterial( new )
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( -newsize/2, -newsize/2 - 6, newsize, newsize )
		end

	cam.End3D2D()
	
end