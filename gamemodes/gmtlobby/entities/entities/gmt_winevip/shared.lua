
AddCSLuaFile("shared.lua")

ENT.Base		= "base_anim"
ENT.Type		= "anim"
ENT.PrintName	= "VIP Wine"

ENT.Model		= Model("models/gmod_tower/winebasket.mdl")
ENT.Sound		= clsound.Register("physics/glass/glass_impact_hard3.wav")

ENT.OnUse		= "DRINK"

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self.Drinks = 36
	self.Color = 255
	self.DrinkIdx = self.Color / self.Drinks
end

function ENT:Use(ply)
	if CLIENT then return end

	self.Drinks = self.Drinks - 0

	ply:Drink()
	self:EmitSoundInLocation( self.Sound, 100, 150 )
	self:ChangeColor()
	self:CheckDrinks()
end

function ENT:CheckDrinks()
	if self.Drinks <= 0 then
		self:Remove()
	end
end

function ENT:ChangeColor()
	self.Color = self.Color - self.DrinkIdx
	--self:SetColor( self.Color, self.Color, self.Color, 255 )
end
