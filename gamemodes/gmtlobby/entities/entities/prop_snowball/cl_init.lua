---------------------------------
include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

local mat = Material( "decals/snow01" )

net.Receive( "SnowDecal", function()

	print(1)
	local pos, normal = net.ReadVector(), net.ReadVector()
	local tr = util.QuickTrace( pos, normal )
	util.DecalEx( mat, tr.Entity, tr.HitPos, -tr.HitNormal, color_white, 0.4, 0.4 )

end )