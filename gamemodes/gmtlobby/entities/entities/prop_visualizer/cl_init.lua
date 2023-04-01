include( "shared.lua" )

-- Name of the material proxy that causes things to glow to the visualizer color
local VisualizerProxyName = "VisualizerGlowColor"

function ENT:Draw()
	self.Entity:DrawModel()
end

-- Same as the rainbow function but the colors match for all clients
local function Rainbow( speed, offset, saturation, value )
	-- HSVToColor doesn't actually return a color object, just something that mimics one
	clr = HSVToColor( ( CurTime() * (speed or 50) % 360 ) + ( offset or 0 ),
		saturation or 1, value or 1 )

	return Color(clr.r, clr.g, clr.b, clr.a)
end

function ENT:Think()
end


-- Material proxy for the prop_visualizers
matproxy.Add( {
	name = VisualizerProxyName,
	init = function( self, mat, values )
		self.ColorVar = values.resultvar 
	end,

	bind = function( self, mat, ent )
		if ent and ent.VisualizerGlowVector then
			mat:SetVector(self.ColorVar, ent.VisualizerGlowVector)
		end
	end
})
