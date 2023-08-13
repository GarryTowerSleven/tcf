ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model("models/props_c17/door01_left.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)

	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(false)
end

function ENT:Use(ply)
	if ply:IsPlayer() then

		ply.DoorDelay = ply.DoorDelay or CurTime()

		if ply.DoorDelay <= CurTime() then
			ply.DoorDelay = CurTime() + 3
			
			self:EmitSound( "doors/door1_stop.wav", 75, 100, 1, CHAN_AUTO )
			timer.Simple( 0.25, function()
				RemoveFromHallway( ply, true )
			end )
		end

	end
end
