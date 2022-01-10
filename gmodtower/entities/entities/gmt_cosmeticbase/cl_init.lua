include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.LastModel = ""
ENT.LastPlayerModel = ""
ENT.LastScale = Vector(0,0,0)
ENT.MaxDist = 800

local HatsGM = {}
HatsGM["ballrace"] = true
HatsGM["minigolf"] = true

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

	if IsLobby then
		// Hide for distance
		local dist = LocalPlayer():EyePos():Distance( self:GetPos() )
		if dist > self.MaxDist then
			return false
		end
	end

	local ply = self:GetOwner()

	local pos, ang = self:Position()
	if pos != false then
		self:SetPos( pos )
		self:SetAngles( ang )
		self:DrawModel()
	end
	
	if engine.ActiveGamemode() == "minigolf" then
		local ball = ply:GetGolfBall()
		if IsValid(ball) then
			self:SetNoDraw(true)
		else
			self:SetNoDraw(false)
		end
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Position()
	local ply = self:GetOwner()

	if !self:Check( ply ) then return false end

	if GAMEMODE.OverrideHatEntity then
		ply = GAMEMODE:OverrideHatEntity(ply)
	elseif !ply:Alive() then
		ply = ply:GetRagdollEntity()
	end

	if !IsValid(ply) then return false end
	ply:SetupBones()

	return self:PositionItem(ply)
end

function ENT:Check( ply )
	if !IsValid( ply ) then return false end

	if ply == LocalPlayer() then
		if ply.ThirdPerson || !ply:Alive() || HatsGM[engine.ActiveGamemode()] then
			return true
		end

		if engine.ActiveGamemode() == "ultimatechimerahunt" && ply:GetNWBool("IsTaunting") then
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
