ENT.Base = "gmt_interactive_base"

ENT.Type = "anim"
ENT.Category = "GMTower"

ENT.PrintName = "Hula Doll"
ENT.Spawnable = true

ENT.Model = "models/props_lab/huladoll.mdl"
ENT.SetWaitTime = 5

function ENT:Dance()

	local seq = self:LookupSequence( "shake" )

	if ( seq == -1 ) then return end

	timer.Create("DanceRepeat",0.3,15,function()
		if !IsValid(self) then return end
		self:ResetSequence( seq )
	end )

end