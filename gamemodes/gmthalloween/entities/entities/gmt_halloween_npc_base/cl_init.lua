include( "shared.lua" )

local debugBounding = CreateClientConVar( "gmt_halloween_collision_debug", "0", false, true, nil, 0, 1 )

function ENT:Draw()
	self:DrawModel()
end

hook.Add( "PostDrawTranslucentRenderables", "DrawBounding", function()

	if not debugBounding:GetBool() then return end

	for _, v in ipairs( ents.FindByClass( "gmt_halloween_npc*" ) ) do
		
		local min, max = v:GetCollisionBounds()
		local pos, ang = v:GetPos(), angle_zero // v:GetAngles()

		local color = Color( 234, 155, 37)

		render.DrawWireframeBox( pos, ang, min, max, color, true )

	end

end )