include("cl_expression.lua")
include("shared.lua")

local RealTime = RealTime

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AnimSpeed = 1

ENT.NPCExpression = "happy"

function ENT:Initialize()
end

function ENT:BlinkThink()
	local ragdoll = self.Ragdoll or nil 
	if ( not ragdoll ) then return end

	// TODO
end

function ENT:Think()

	if not self:IsDormant() then
		if not (IsValid(self.Ragdoll) and IsValid(self.Ragdoll:GetParent())) then
			self:SetupModel()
			self.Ragdoll:SetNoDraw(false)
		end

		local dt = RealTime() - (self.LastThink or RealTime())
		self.Entity:FrameAdvance( dt * self.AnimSpeed )
		self:SetExpression( self.NPCExpression )
	else
		if IsValid(self.Ragdoll) then
			self.Ragdoll:SetNoDraw(true)
		end
	end

	self:BlinkThink()
	self:AdditionalThink()

	self:SetNextClientThink( CurTime() )
	self.LastThink = RealTime()

	return true

end

function ENT:AdditionalThink() end

function ENT:Draw()
	--self:DrawModel()
end


local new_mat = Material( "gmod_tower/icons/new_large.png" )
local new_size = 256/2.5

local sale_mat = Material("gmod_tower/lobby/sale")

function ENT:DrawTranslucent()

	local title = self:GetTitle()
	local offset = Vector( 0, 0, 90 )

	if !title then title = "" end
	
	-- Offset PVP and Ballrace stores
	if ( self:GetStoreId() == 3 || self:GetStoreId() == 5 ) then
		offset = Vector( 0, 0, 110 )
	elseif self:GetStoreId() == 21 then
		offset = Vector( 0, 0, 100 )
	elseif self:IsOnSale() then
		//offset = Vector( 0, 0, 110 )
	end
	
	local ang = EyeAngles()
	local pos = self:GetPos() + offset + ang:Up() * ( math.sin( CurTime() ) * 4 ) + Vector( 0, 0, -5 )

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.05 )

		draw.DrawText( title, "GTowerNPC", 2, 2, Color( 0, 0, 0, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( title, "GTowerNPC", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		if self:HasNewItems() then
			surface.SetMaterial( new_mat )
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( -new_size/2, -new_size/2 - 6, new_size, new_size )
		end

		//if self:IsOnSale() then
		//	draw.DrawText( "50% OFF", "GTowerNPC", 2, 76, Color( 0, 0, 0, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		//	draw.DrawText( "50% OFF", "GTowerNPC", 0, 74, colorutil.Rainbow(50) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		//end

		//local scale = math.EaseInOut( math.abs( math.sin( UnPredictedCurTime() * 2 ) ), .25, .25 ) + .5
		
		//surface.SetMaterial( sale_mat )
		//surface.SetDrawColor( color_white )
		//surface.DrawTexturedRect( 0 - ((sale_w * scale) / 2), -90 - ((sale_h * scale) / 2), sale_w * scale, sale_h * scale )

	cam.End3D2D()

	if self:IsOnSale() then

		render.SetMaterial( sale_mat )

		local sin = math.abs( math.sin( UnPredictedCurTime() * 2 ) )
		local eyevec = EyeVector()*-1
		eyevec.z = 0

		render.DrawQuadEasy(
			self:GetPos() + offset + self:GetUp() * (7 - math.sin(UnPredictedCurTime() * 4) * 2) + eyevec:Angle():Right() * math.sin(UnPredictedCurTime() * 2) * 4,
			eyevec,
			(64/2) + sin*4,
			(32/2) + sin*4,
			color_white,
			180 + ( 4 * math.sin(UnPredictedCurTime() * 2) )
		)

	end
	
end

function ENT:SetupHats( ragdoll )
	if ( not IsValid( ragdoll ) ) then return end
	if ( not self.Hat or not self.HatOffset ) then return end
	if ( IsValid( ragdoll.HatEntity ) ) then return end

	ragdoll.HatEntity = ClientsideModel( self.Hat )
	print( ragdoll.HatEntity )

	local OffsetAng = self.HatOffset.Ang or Angle( 0, 0, 0 )
	local OffsetPos = self.HatOffset.Pos or Vector( 0, 0, 0 )
	
	ragdoll.HatEntity:SetPos( ragdoll.HatEntity:GetPos() + OffsetPos )
	ragdoll.HatEntity:SetAngles( ragdoll.HatEntity:GetAngles() + OffsetAng )
	ragdoll.HatEntity:SetModelScale( self.HatOffset.Scale or 1 )

	ragdoll.HatEntity:Spawn()

	ragdoll.HatEntity:FollowBone( ragdoll, 7 )
end

---
-- Called after the clientside ragdoll is created.
--
-- @param ragdoll Clientside ragdoll model.
--
function ENT:SetupRagdoll( ragdoll )
	// self:SetupHats( ragdoll )
end