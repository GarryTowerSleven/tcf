---------------------------------
include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

local mat = Material( "decals/snow01" )

net.Receive( "SnowDecal", function()

	local pos, normal = net.ReadVector(), net.ReadVector()
	local tr = util.QuickTrace( pos, normal )

	if !IsValid( tr.Entity ) then return end

	util.DecalEx( mat, tr.Entity, tr.HitPos, -tr.HitNormal, color_white, 0.4, 0.4 )

end )