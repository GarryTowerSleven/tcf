
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Width = 740
ENT.Height = 474

ENT.RenderDistance = 2300

ENT.MonorailDriveTime = 60 + 55

local DeluxeGradient = Material( "gmod_tower/hud/bg_gradient_deluxe.png", "unlightsmooth" )
local Monorail = Material( "gmod_tower/lobby/hud/monorail.png", "unlightsmooth" )

surface.CreateFont( "MonoScreenTitle", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 800,
	size = 72
} )

surface.CreateFont( "MonoScreenTime", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size = 40
} )

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > ( self.RenderDistance * self.RenderDistance ) then return end

	local pos = self:GetPos() + self:GetForward() * 4
	local ang = self:GetAngles()
	local scl = .5

	ang:RotateAroundAxis( self:GetRight(), -90 )
	ang:RotateAroundAxis( self:GetUp(), 0 )
	ang:RotateAroundAxis( self:GetForward(), 90 )

	cam.Start3D2D( pos, ang, scl )

		local x = -(self.Width / 2)
		local y = -(self.Height / 2)
		local w = self.Width
		local h = self.Height

		surface.SetDrawColor( 31, 8, 62 )
		surface.DrawRect(x,y,w,h)

		surface.SetDrawColor( 161, 138, 192, 115 )
		surface.SetMaterial( DeluxeGradient )
		surface.DrawTexturedRectUV( x, y, w, h, .4, .4, .6, .6)

		surface.SetDrawColor( 0, 0, 0, 125 )
		surface.DrawRect( -self.Width / 2, (25 - self.Height / 2), self.Width, 80 )
		draw.DrawText( "GMTower Monorail", "MonoScreenTitle", 0, (25 - self.Height / 2), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		local time = CurTime() - ( GetGlobalInt("MonorailLeaveTime") + self.MonorailDriveTime )
		local timeLeft = math.abs(time)
		if time > 0 then timeLeft = 0 end

		/*local hours = string.format("%02.f", math.floor(timeLeft/3600));
		local mins = string.format("%02.f", math.floor(timeLeft/60 - (hours*60)));
		local secs = string.format("%02.f", math.floor(timeLeft - hours*3600 - mins *60));*/

		draw.DrawText( "Next arrival in:", "MonoScreenTime", 0, -48, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.DrawText( string.NiceTime(timeLeft), "MonoScreenTitle", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		surface.SetMaterial( Monorail )
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(0 - 100 + ( math.sin( CurTime() ) * 250 ),150,200,75)

	cam.End3D2D()
end
