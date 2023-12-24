include("cl_expression.lua")
include("shared.lua")

local RealTime = RealTime

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AnimSpeed = 1
ENT.Scale = 1

ENT.NPCExpression = "happy"

function ENT:Initialize()
end

function ENT:BlinkThink()
	local ragdoll = self.Ragdoll or nil 
	if ( not ragdoll ) then return end

	if EyePos():DistToSqr( self:GetPos() ) > 240000 then
		self:SetPoseParameter( "head_yaw", 0 )

		return
	end

	self.blink = self.blink or 0
	self.blinktime = self.blinktime or 0
	self.Closest = nil
	self.ThinkTime = 0

	if self.blinktime < CurTime() then
		self.blink = 1
		self.blinktime = CurTime() + math.Rand(4, 8)
	end

	if self.ThinkTime < CurTime() then

		local closest = nil
		local dist = math.huge
	
		for _, ply in ipairs( player.GetAll() ) do
			
			local dis = ply:GetPos():DistToSqr( self:GetPos() )
			local ang = self:GetAngles()
			local len = ply:GetPos() - self:GetPos()

			if dis < dist && dis <= ( 128 * 128 ) && ang:Forward():Dot(len) / len:Length() > -0.95 then
	
				closest = ply
				dist = dis
	
			end
	
		end

		self.Closest = closest
		self.ThinkTime = CurTime() + 0.1

	end

	self.blink = math.max(self.blink - FrameTime() * 8, 0)

	self.ET = self.ET or self:EyePos()
	self.ET = LerpVector(FrameTime() * 4, self.ET, IsValid(self.Closest) and self.Closest:EyePos() or self:GetPos() + self:GetForward() * 64 + self:GetUp() * 64)
	self:SetPoseParameter("head_yaw", math.NormalizeAngle((self.ET - self:EyePos()):Angle().y - self:GetAngles().y) / 1.4)
	ragdoll:SetEyeTarget(self.ET)

	ragdoll:SetFlexWeight(ragdoll:GetFlexIDByName("blink") or 0, self.blink)
	// TODO
end

function ENT:Think()

	if self.Vending then return end

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

	if self.Vending then

		self:DrawModel()

		return

	end

	--self:DrawModel()

	if IsChristmas then

		if self.Mat then

			self.Mat:SetTexture( "$basetexture", self.Material )

		else

			if !self.Material then

				for _, m in ipairs(self.Ragdoll:GetMaterials()) do
					if string.find(m, "gmtsui1") && string.find(m, "sheet") then
						local gender = string.find(m, "fe") && "female" || "male"
						local rand = self:EntIndex() % 2 == 1

						self.Mat = self.Mat || Material( m )
						self.Material = "models/humans/gmt_employee_christmas_" .. gender .. ( rand && 2 || "" )

						self.Mat:SetTexture( "$basetexture", self.Material )
					end
				end

			end

		end

	end

	if self.Hat then

		local model = self.Hat
		local pos, ang = self.HatOffset.Pos, self.HatOffset.Ang

		if !IsValid( self.HatModel ) then

			self.HatModel = ClientsideModel( model )

		else

			local att = self:GetAttachment( 1 )
			self.HatModel:SetPos( att.Pos + att.Ang:Forward() * pos.x + att.Ang:Right() * pos.y + att.Ang:Up() * pos.z )
			self.HatModel:SetAngles( att.Ang + ang )
			self.HatModel:SetModelScale( self.HatOffset.Scale )

		end

	end
end


local new_mat = Material( "gmod_tower/icons/new_large.png" )
local new_size = 256/2.5

local sale_mat = Material("gmod_tower/lobby/sale")



function ENT:DrawTranslucent()

	local title = self:GetTitle()
	local offset = Vector( 0, 0, 16 )

	if !title then title = "" end
	
	-- Offset PVP and Ballrace stores
	if ( self:GetStoreId() == 3 || self:GetStoreId() == 5 ) then
		offset = Vector( 0, 0, 110 )
	elseif self:GetStoreId() == 21 then
		offset = Vector( 0, 0, 100 )
	elseif self:IsOnSale() then
		//offset = Vector( 0, 0, 110 )
	end

	local uid = self:EntIndex() * 24

	local eye = self:LookupAttachment("eyes")
	local pos

	if eye and eye > 0 then
		pos = self:GetAttachment(eye).Pos
	end
	
	local ang = EyeAngles()
	local pos = (pos || self:GetPos() + Vector(0, 0, 64)) + offset + ang:Up() * ( math.sin( CurTime() + uid ) ) + Vector( 0, 0, self.Offset || 0 )

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	self.Description2 = self.Description2 || 0
	self.Description2 = math.Approach( self.Description2, self.Description && LocalPlayer():GetUseEntity() == self && 1 || 0, FrameTime() * 4 )
	local l = math.ease.InOutSine(self.Description2)

	cam.Start3D2D( pos, Angle( math.sin(CurTime() * 2.35 + uid), ang.y, 90 ), 0.05 * self.Scale )

		draw.DrawText( title, "GTowerNPC", 2, 2, Color( 0, 0, 0, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( title, "GTowerNPC", 0, 0, title == "VIP Store" && colorutil.Rainbow( 24 ) || Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		if self.Description then
			local offset = ( string.find( title, "g" ) ) && 18 || 0

			draw.DrawText( self.Description, "GTowerNPC2", 2, 140 + 2 + 8 * (1 - l) + offset, Color( 0, 0, 0, 225 * l ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.DrawText( self.Description, "GTowerNPC2", 0, 140 + 8 * (1 - l) + offset, Color( 255, 255, 255, 255 * l ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

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