---------------------------------
include("shared.lua")

function ENT:Draw()
	self.Entity:DrawModel()
end

surface.CreateFont( "SleepText", {
	font = "KoorkinW04-BoldItalic",
	extended = false,
	size = 45,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local messageOpacity = 0
local opacitySpeed = 0

hook.Add( "GTowerHUDPaint", "SleepyTimeMessage", function()
	if LocalPlayer().Sleeping == true || messageOpacity > 0 then
		messageOpacity = messageOpacity + FrameTime() * opacitySpeed

		if messageOpacity > 70 && opacitySpeed > 0 then
			opacitySpeed = -opacitySpeed
		end

		local clr = Color( 255, 255, 255, messageOpacity )
		draw.DrawText( LocalPlayer().SleepMessage, "SleepText", math.fmod( RealTime() * 15, ScrW() * 0.5 ), math.fmod( RealTime() * 5, ScrH() * 0.25 ), clr, TEXT_ALIGN_CENTER )
	else
		opacitySpeed = 30
		messageOpacity = -25
	end
end )

net.Receive( "BedMessage", function( len, ply )
	local message = net.ReadString()
	local sleeping = net.ReadBool()

	LocalPlayer().Sleeping = sleeping

	if message == null || message == "" then return end
	LocalPlayer().SleepMessage = message
end )
