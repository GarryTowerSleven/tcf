include("shared.lua")

ENT.Color = nil
ENT.SpriteMat = Material( "sprites/powerup_effects" )

net.Receive("FoodAlpha",function()

	local ent = net.ReadEntity()

	ent:FoodAlpha()

end)

function ENT:Initialize()

	self.csModel = ClientsideModel(self.Model)
	self.csModel:SetModelScale(self.FoodScale,0)
	self.csModel:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.csModel:DrawShadow(false)

		if IsValid( self ) then
			self.BaseClass:Initialize()
			self.OriginPos = self:GetPos()
		end

end

ENT.NoGlow = false

function ENT:Draw()

	local FoodAngle = CurTime() * 128 % 360
	local FoodHeight = math.sin(CurTime() * 2) * 8
  local CurAng = self:GetAngles()

	self.csModel:SetPos(self:GetPos() + Vector(0,0, FoodHeight))
	self.csModel:SetAngles(Angle(CurAng.p,CurAng.y + FoodAngle,CurAng.r))

	if !self.NoGlow then
		render.SetMaterial( Material("effects/brightglow_y") )
		render.DrawSprite( self.csModel:GetPos() + Vector(0,0,10), 75 + math.sin(CurTime()*4)*10, 75 + math.sin(CurTime()*4)*10, Color(175,175,175,225) )
	end

end

function ENT:OnRemove()
	self.csModel:Remove()
end

function ENT:FoodAlpha()
	self.NoGlow = true
	self.csModel:SetColor(Color(255,255,255,125))
	timer.Simple(16,function()
		if IsValid(self) then
			self.NoGlow = false
			self.csModel:SetColor(Color(255,255,255,255))
		end
	end)
end
