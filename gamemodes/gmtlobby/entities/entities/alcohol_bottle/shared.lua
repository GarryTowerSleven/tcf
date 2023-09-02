---------------------------------
AddCSLuaFile("shared.lua")

ENT.Base		= "base_anim"
ENT.Type		= "anim"
ENT.PrintName		= "Alcohol Bottle"

ENT.Model		= Model("models/gmod_tower/boozebottle.mdl")

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	timer.Simple(0, function()
		if self:GetColor().r == 254 then
			self:GetPhysicsObject():EnableMotion(true)
		end
	end)

	self.Drank = false
end

function ENT:PhysicsCollide(data)
	if data.Speed < 400 then return end

	if self.Ply then
		self.Ply:SetAchievement( ACHIEVEMENTS.DOMESTICABUSE, 1 )
		self.Ply:AddAchievement( ACHIEVEMENTS.TRASHCOMPACTOR, 1 )
	end

	local fx = EffectData()
	fx:SetOrigin(self:GetPos())
	util.Effect("AntlionGib", fx, true, true)
	util.Decal("BeerSplash", self:GetPos(), self:GetPos() + data.HitNormal * 24, self)
	self:EmitSound("GlassBottle.Break")
	self:Remove()
end

function ENT:Use(ply)
	if CLIENT || self.Drank then return end

	if self:GetColor().r == 254 then
		if !self:IsPlayerHolding() then
			ply:PickupObject(self)
			self.Ply = ply
		end
		return
	end

	self.Drank = true
	ply:Drink()

	self:Remove()

	local Item = GTowerItems:CreateById( ITEMS.empty_bottle )
	local ent = Item:OnDrop()

	ent:SetPos(self:LocalToWorld(self:OBBCenter()))
	ent:SetAngles(self:GetAngles())
	
	ent:Spawn()

	if IsValid(ent:GetPhysicsObject()) then
		ent:GetPhysicsObject():Wake()
	end
end

local mat = Material("models/debug/debugwhite")

function ENT:Draw()
	if self:GetColor().r != 254 then
	self:SetModelScale(0.95)
	render.SetBlend(0.9)
	render.SetColorModulation(0.718, 0.541, 0.125)
	render.ModelMaterialOverride(mat)
	render.EnableClipping(true)
	local n = -self:GetUp()
	render.PushCustomClipPlane(n, n:Dot(self:WorldSpaceCenter() + self:GetUp() * 6))
	self:DrawModel()
	render.PopCustomClipPlane()
	render.EnableClipping(false)
	end
	self:SetModelScale(1)
	render.SetBlend(0.8)
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride()
	self:DrawModel()
end