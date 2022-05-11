ENT.Type = "anim"
ENT.Category = "GMTower"

ENT.PrintName = "Interactive Base"
ENT.Spawnable = true

ENT.Model = ""
ENT.SetWaitTime = 0
ENT.CustomUsePrompt = "TOUCH"

function ENT:CanUse()

	return true, self.CustomUsePrompt
	
end