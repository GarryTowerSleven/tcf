include( "shared.lua" )

-- Name of the material proxy that causes things to glow to the visualizer color
local VisualizerProxyName = "VisualizerGlowColor"

local bgModels = {
	["models/map_detail/nightclub_sign.mdl"] = true,
	["models/map_detail/nightclub_sign_foohy.mdl"] = true
}

local vis_mountains = surface.GetTextureID( "gmod_tower/nightclub/panel_mountains" )
local vis_glass 	= surface.GetTextureID( "gmod_tower/nightclub/panel_glass" )

function ENT:Draw2D()
	local startOffset = Vector(14.25,212,-84)

	local pos =
		  self:GetPos()
		+ self:GetRight() 	* 213
		+ self:GetUp() 			* 85
		+ self:GetForward() * -14.25

	local ang = self:GetAngles()
	local scl = .25

	ang:RotateAroundAxis( self:GetRight(), -90 )
	ang:RotateAroundAxis( self:GetForward(), 90 )

	local w = 1700
	local h = 480

	cam.Start3D2D(pos, ang, scl)
		local col = self.VisualizerGlowVector * 255

		surface.SetDrawColor( col.x, col.y, col.z, 255 )
		surface.SetTexture(vis_mountains)
		surface.DrawTexturedRectUV(0, 0, w, h, 2, 0, 4, 1)

		surface.SetDrawColor( col.x, col.y, col.z, 150 )
		surface.SetTexture(vis_glass)
		surface.DrawTexturedRectUV(0, 0, w, h, 2, 0, 3, 1)

	cam.End3D2D()
end

function ENT:Draw()
	self.Entity:DrawModel()

	if bgModels[self:GetModel()] && LocalPlayer():GetPos():WithinDistance(self:GetPos(), 5000) then
		self:Draw2D()
	end
end

-- Same as the rainbow function but the colors match for all clients
local function Rainbow( speed, offset, saturation, value )
	-- HSVToColor doesn't actually return a color object, just something that mimics one
	clr = HSVToColor( ( CurTime() * (speed or 50) % 360 ) + ( offset or 0 ),
		saturation or 1, value or 1 )

	return Color(clr.r, clr.g, clr.b, clr.a)
end

function ENT:Think()
	local Controller = self:GetOwner()

	-- Get the theme color from the controller itself
	if IsValidController(Controller) then
		self.VisualizerGlowVector = Controller:GetThemeColor():ToVector()

	-- Uhhh just kinda guess what it is
	else
		self.VisualizerGlowVector = Rainbow(10):ToVector()
	end
end


-- Material proxy for the prop_visualizers
matproxy.Add( {
	name = VisualizerProxyName,
	init = function( self, mat, values )
		self.ColorVar = values.resultvar 
	end,

	bind = function( self, mat, ent )
		if ent and ent.VisualizerGlowVector then
			local multiplier = 10
			if mat:GetName() == "models/map_detail/nightclub_steps" then
				multiplier = 100
			end
			mat:SetVector(self.ColorVar, ent.VisualizerGlowVector*multiplier)
		end
	end
})
