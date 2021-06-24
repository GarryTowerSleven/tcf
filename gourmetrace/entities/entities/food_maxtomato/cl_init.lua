include("shared.lua")

ENT.Color = nil
ENT.SpriteMat = Material( "sprites/powerup_effects" )

function ENT:Initialize()

	self.csModel = ClientsideModel(self.Model)
	self.csModel:SetModelScale(self.FoodScale,0)
	self.csModel:DrawShadow(false)

		if IsValid( self ) then
			self.BaseClass:Initialize()
			self.OriginPos = self:GetPos()
		end

end

ENT.NoGlow = false

function ENT:Draw()

	local FoodAngle = math.sin(CurTime() * 8) * 16
	local FoodHeight = math.sin(CurTime() * 2) * 8
  local CurAng = self:GetAngles()

	self.csModel:SetPos(self:GetPos() + Vector(0,0, FoodHeight))
	self.csModel:SetAngles(Angle(CurAng.p,CurAng.y,CurAng.r + FoodAngle))

	if !self.NoGlow then
		render.SetMaterial( Material("effects/brightglow_y") )
		render.DrawSprite( self.csModel:GetPos(), 175 + math.sin(CurTime()*4)*10, 175 + math.sin(CurTime()*4)*10, Color(255,125,25,255) )
	end

end

function ENT:OnRemove()
	self.csModel:Remove()
end

function ENT:FoodAlpha()
	self.NoGlow = true
	self.csModel:SetColor(Color(255,255,255,125))
	timer.Simple(5,function()
		if IsValid(self) then
			self.NoGlow = false
			self.csModel:SetColor(Color(255,255,255,255))
		end
	end)
end
