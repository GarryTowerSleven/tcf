---------------------------------
include('shared.lua')

surface.CreateFont( "clock",{ font = "Trebuchet MS", size = 30, weight = 800, antialias = true, additive = false })

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() - ( self:GetForward() * -4 ) - ( self:GetRight() * -2.7 ) - ( self:GetUp() * -3.4 )
	local scale = 0.055
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)

	--if scale == 0.055 then
		cam.Start3D2D(pos, ang, scale)

			draw.DrawText(os.date("%I:%M %p"), "clock", -140, -68, Color(200, 235, 255, 200))

		cam.End3D2D()
	--end
end
