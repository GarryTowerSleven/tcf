include("shared.lua")

function ENT:Initialize()
	local min, max = self:GetRenderBounds()
	self:SetRenderBounds(min *2, max * 2)

	self.Delta = 1
	self.Hide = 0
end

function ENT:PositionBox( ply )
	local ang = ply:EyeAngles()
	local pos = ply:EyePos()

	ang.p = 0

	ang:RotateAroundAxis(ang:Right(), 40 * self.Delta)
	
	pos = pos - Vector(0,0,24 - (self.Delta * 18))

	if ply != LocalPlayer() then
		pos = pos + ang:Forward() * 14
	end

	self.Entity:SetAngles(ang)
	self.Entity:SetPos(pos)
end

function ENT:SetAlpha( ply, alpha )
	if IsLobby && emote && emote.IsEmoting( ply ) then
		self:SetNoDraw( true )
	return end
	
	if !alpha then
		alpha = 0
	end

	if ply == LocalPlayer() then
		alpha = math.Clamp(alpha, 150, 255)
	end

	local c = ply:GetColor() // GMod 13
	local r,g,b = c.r, c.g, c.b

	self:SetColor( Color( r, g, b, alpha ) )
	ply:SetColorAll( Color( r, g, b, alpha ) )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetNoDraw( false )
	
	local weapon = ply:GetActiveWeapon()
	
	if IsValid(weapon) then
		weapon:SetColor( Color( 255, 255, 255, alpha or 150 ) )
		weapon:SetRenderMode( RENDERMODE_TRANSALPHA )
	end
end

function ENT:Think()
	local ply = self:GetOwner()
	if !IsValid(ply) || !ply:Alive() then return end

	local hidden = ply:Crouching() && ply:GetVelocity():Length() <= 0.1

	if (self.Hide > 0 && !hidden) || self.Hide <= 0 && hidden then
		self.Hide = CurTime()
		if !hidden then self.Hide = -self.Hide end
	end

	local delta = math.Clamp((CurTime() - math.abs(self.Hide)) * 3, 0, 1)

	if self.Hide > 0 then
		self.Delta = 1 - delta
	elseif self.Hide < 0 then
		self.Delta = delta
	end

	self:SetAlpha( ply, self.Delta * 255 )
end

function ENT:Draw()
	local ply = self:GetOwner()
	if !IsValid(ply) || !ply:Alive() then return end

	self:PositionBox(ply)

	self.Entity:DrawModel()
end

function ENT:OnRemove()
	local ply = self:GetOwner()

	if IsValid(ply) then
		self:SetAlpha( ply, 255 )
	end
end