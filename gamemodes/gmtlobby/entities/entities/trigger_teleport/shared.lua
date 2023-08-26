ENT.Base = "base_brush"
ENT.Type = "brush"

ENT.Offets = {
	["tele_totrain_right"] = Vector(0, 139, -47.2),
	["tele_totrain_left"] = Vector(0, 139, -47),
	["tele_tooutside_right"] = Vector(0, -131, 46.8),
	["tele_tooutside_left"] = Vector(0, -131, 47)
}

function ENT:Teleport(ply)
	if !ply:IsPlayer() || !IsValid( self.TargetEntity ) then return end

	local targetPosition = self.TargetEntity:GetPos()

	if self.Origin and self.TargetEntity.Origin then
		local playerOffset = ply:GetPos() - Vector(self.Origin)
		targetPosition = Vector(self.TargetEntity.Origin) + playerOffset

		if self.Offets[self.TargetName] then
			targetPosition = targetPosition + self.Offets[self.TargetName]
		end
	end

	ply._teleportTriggerTarget = targetPosition
end

function ENT:StartTouch(ply)
end

function ENT:EndTouch(ply)
	self:Teleport(ply)
end

function ENT:KeyValue( key, value )
	if ( key == "target" ) then
		self.Target = value
	end

	if ( key == "origin" ) then
		self.Origin = value
	end
end

hook.Add("Move", "trigger_teleport", function( ply, mv )
	local target = ply._teleportTriggerTarget

	if target then
		ply._teleportTriggerTarget = nil
		mv:SetOrigin(target)
	end
end)