module("minievent", package.seeall )

local DrawTimer = CreateClientConVar( "gmt_draweventtimer", 1, true, false )

local endtime = GetGlobalInt( "NextEventTime" )
local eventname = GetGlobalString( "NextEvent" )

function UpdateEventTimer()
	endtime = GetGlobalInt( "NextEventTime" )
	eventname = GetGlobalString( "NextEvent" )
end

local timeSinceUpdate = 0
hook.Add( "GTowerHUDPaint", "DrawNextEvent", function()
	if HUDStyle_Lobby1 && DrawTimer:GetBool() then
		local timeleft = endtime - CurTime()

		if timeleft <= 0 then
			timeleft = 0
			if timeSinceUpdate < CurTime() then
				UpdateEventTimer()
				timeSinceUpdate = CurTime() + 1
			end
		end

		if !endtime or !eventname then return end

		local timeformat = string.FormattedTime( timeleft, "%02i:%02i" )
		local time = "NEXT EVENT (" .. string.upper( eventname ) .. ") IN " .. timeformat

		surface.SetFont( "GTowerHUDMainSmall" )

		local tw, th = surface.GetTextSize( time )
		local tx, ty = GTowerHUD.Info.X + GTowerHUD.Info.Width-24-tw, GTowerHUD.Info.Y + GTowerHUD.Info.TextureHeight - 10

		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( tx + 1, ty + 1 )
		surface.DrawText( time )

		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( tx, ty )
		surface.DrawText( time )

	end
end )