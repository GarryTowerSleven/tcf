include( "shared.lua" )

function ENT:Think()
	self:NextThink( CurTime() )
	return true
end

local ENT2 = {}

ENT2.Type = "nextbot"
ENT2.Base = "base_nextbot"

function ENT2:Draw()
end

scripted_ents.Register(ENT2, "mr_saturn_navigator")