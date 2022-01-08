include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.LastModel = ""
ENT.LastPlayerModel = ""
ENT.LastScale = Vector(0,0,0)
ENT.MaxDist = 800

function ENT:Initialize()
	self:SetRenderBounds( Vector(-60, -60, -60), Vector(60, 60, 60) )
	self:DrawShadow(false)

	self:InitOffset()
end

function ENT:InitOffset()
end

function ENT:Think()

	local ply = self:GetOwner()
	if !IsValid(ply) then return end

	local color = ply:GetColor()

	self:SetColor( color )

	if color.a < 255 then
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
	else
		self:SetRenderMode( RENDERMODE_NORMAL )
	end

	self:SetMaterial( ply:GetMaterial() )

	if self.PlayerEquipIndex == 0 then
		self:AddToEquipment()
	end

	if self:GetModel() != self.LastModel || ply:GetModel() != self.LastPlayerModel || ply:GetModelScale() != self.LastScale then
		self.LastModel = self:GetModel()
		self.LastPlayerModel = ply:GetModel()
		self.LastScale = ply:GetModelScale()

		self:UpdatedModel(ply)
	end

	self:NextThink(CurTime() + 0.1)
end

function ENT:UpdatedModel()
end

function ENT:Draw()

	local ply = self:GetOwner()
	if !IsValid( ply ) || !self:ShouldDraw( ply ) then return end

	pos, ang, scale = self:Position( ply )
	if !pos then return end

	self:SetPos( pos )
	self:SetAngles( ang )
	self:SetModelScale( scale or 1, 0 )
	if ply.GetBallColor then
		local color = ply:GetBallColor()
		render.SetColorModulation(color.r, color.g, color.b)
	end
	self:DrawModel()

end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Position( ply )
	local override = hook.Call( "OverrideHatEntity", GAMEMODE, ply )
	if override then
		ply = override
	end

	if ply.Alive && !ply:Alive() then
		ply = ply:GetRagdollEntity()
	end

	return self:PositionItem( ply )
end

function ENT:ShouldDraw( ply, dist )

	if !IsValid( ply ) then return false end

	if IsLobby then

		// Hide for distance
		local dist = LocalPlayer():EyePos():Distance( self:GetPos() )
		if dist > self.MaxDist then
			return false
		end

	else

		// Hide for gamemode stuff
		if hook.Call( "ShouldHideHats", GAMEMODE, ply ) then
			return false
		end

	end

	if ply == LocalPlayer() then

		if GAMEMODE.DrawHatsAlways || ( GAMEMODE.ShouldDrawLocalPlayer && GAMEMODE:ShouldDrawLocalPlayer( ply ) ) then
			return true
		end

		if ThirdPerson && !ThirdPerson.ShouldDraw then
			return false
		end

		if ply.ThirdPerson || ply.ViewingSelf then
			return true
		end

		return false

	end

	return true

end

function ENT:PositionItem()
	return false
end

local PlayerMeta = FindMetaTable("Player")

// manual drawing for ballrace!
function PlayerMeta:ManualEquipmentDraw()
 	if !self.CosmeticEquipment then return end

	for k,v in pairs(self.CosmeticEquipment) do
		if v.DrawTranslucent then // really crappy computers can't handle drawing
			v:DrawTranslucent()
		end
	end
end
