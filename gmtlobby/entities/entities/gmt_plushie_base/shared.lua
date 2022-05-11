ENT.Type = "anim"
ENT.Category = "GMTower"

ENT.PrintName = "Plushie Base"
ENT.Spawnable = true

ENT.Model = "models/gmod_tower/plush_penguin.mdl"
ENT.Sound = "gmodtower/inventory/move_plush.wav"

function ENT:Squish()

	self:EmitSound(Sound(self.Sound),70)

	self:SetModelScale(0.9,0.25)
	timer.Simple(0.25,function()
		self:SetModelScale(1,0.25)
	end)

end

function ENT:CanUse()

	return true, "TOUCH"

end
