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

	if !self.LastMove or self.LastMove < CurTime() then
		self.EyeTarget = VectorRand() * 8
		self.LastMove = CurTime() + math.Rand(0.2, 1.2)
	end

	self.ET = self.ET or Vector(0, 0, 0)
	self.ET = LerpVector(FrameTime() * 8, self.ET, self.EyeTarget)

	local att = self.Ragdoll:GetAttachment(1)

	self.Ragdoll:SetEyeTarget(att.Pos + att.Ang:Forward() * 64 + self.ET)

	local ragdoll = self.Ragdoll or self
	ragdoll.BlinkTime = ragdoll.BlinkTime or 0
    ragdoll.BlinkF = ragdoll.BlinkF or 0

    if ragdoll.BlinkTime < CurTime() then
        ragdoll.Blink = CurTime() + 0.1
        ragdoll.BlinkTime = CurTime() + math.Rand(1.25, 4)
    end

    ragdoll.BlinkF = math.Approach(ragdoll.BlinkF, ragdoll.Blink > CurTime() and 1 or 0, FrameTime() * 8)

    ragdoll:SetFlexWeight(ragdoll:GetFlexIDByName("blink"), math.ease.OutCubic(ragdoll.BlinkF))

	if !ragdoll.RandFace or ragdoll.RandFace < CurTime() then
		ragdoll.Smile = ragdoll.Smile or 0
		ragdoll.Smile = math.abs(math.fmod(ragdoll.Smile + math.Rand(0, 1), 1))
		ragdoll.RandFace = CurTime() + math.Rand(1.8, 2.8)
	end
	ragdoll.S = ragdoll.S or 0
	ragdoll.S = math.Approach(ragdoll.S, ragdoll.Smile, FrameTime() * 1.4)
    ragdoll:SetFlexWeight(ragdoll:GetFlexIDByName("smile"), ragdoll.S)
    ragdoll:SetFlexWeight(ragdoll:GetFlexIDByName("wrinkler"), ragdoll.S)



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


local new = Material( "gmod_tower/icons/new_large.png" )
local newsize = 256/2.5

function ENT:DrawTranslucent()

	if IsLobbyOne then

		local title = self:GetTitle()
		local offset = Vector( 0, 0, 90 )

		if !title then title = "" end
		
		-- Offset PVP and Ballrace stores
		if ( self:GetStoreId() == 3 || self:GetStoreId() == 5 ) then
			offset = Vector( 0, 0, 110 )
		elseif self:GetStoreId() == 21 then
			offset = Vector( 0, 0, 100 )
		elseif self:IsOnSale() then
			offset = Vector( 0, 0, 108 )
		end
		
		local ang = LocalPlayer():EyeAngles()
		local pos = self:GetPos() + offset + ang:Up() * ( math.sin( CurTime() ) * 4 ) + Vector( 0, 0, -5 )

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
			draw.DrawText( title, "GTowerNPC", 2, 2, Color( 0, 0, 0, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.DrawText( title, "GTowerNPC", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			if self:HasNewItems() then
				surface.SetMaterial( new )
				surface.SetDrawColor( 255, 255, 255 )
				surface.DrawTexturedRect( -newsize/2, -newsize/2 - 6, newsize, newsize )
			end

		cam.End3D2D()

	else

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