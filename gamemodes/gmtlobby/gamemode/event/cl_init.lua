module("minievent", package.seeall )

local DrawTimer = CreateClientConVar( "gmt_draweventtimer", 1, true, false )

local endtime = GetGlobalInt( "NextEventTime" )
local eventname = GetGlobalString( "NextEvent" )

function UpdateEventTimer()
	endtime = GetGlobalInt( "NextEventTime" )
	eventname = GetGlobalString( "NextEvent" )
end

local timeSinceUpdate = 0

local function displayTimer()
	if Location.IsCasino( LocalPlayer():Location() ) then return false end
	local locid = LocalPlayer().GRoomId
	if locid && locid != 0 then return false end

	return true
end

hook.Add( "GTowerHUDPaint", "DrawNextEvent", function()
	if !DrawTimer:GetBool() then return end

	local timeleft = endtime - CurTime()
	local timeformat = string.FormattedTime( timeleft, "%02i:%02i" )

	if timeleft <= 0 then
		timeleft = 0
		if timeSinceUpdate < CurTime() then
			UpdateEventTimer()
			timeSinceUpdate = CurTime() + 1
		end
	end

	if !endtime or !eventname then return end

	if HUDStyle_L2 && displayTimer() then
		GTowerHUD.DrawExtraInfo( nil, "Next Event (" .. eventname .. ") in " .. timeformat  )
	end

	if HUDStyle_Lobby1 || HUDStyle_Lobby1AB then
		local font = "GTowersmall"
		local time = "Next Event (" .. eventname .. ") in " .. timeformat
		
		if !HUDStyle_Lobby1AB then
			time = string.upper(time)
			font = "GTowerHUDMainSmall"
		end

		surface.SetFont( font )

		local tw, th = surface.GetTextSize( time )
		local tx, ty = GTowerHUD.Info.X + GTowerHUD.Info.Width-24-tw, GTowerHUD.Info.Y + GTowerHUD.Info.TextureHeight - 10

		if HUDStyle_Lobby1AB then
			tx, ty = GTowerHUD.Info.X + (GTowerHUD.Info.Width/2) - (tw/2), GTowerHUD.Info.Y + 110
		end

		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( tx + 1, ty + 1 )
		surface.DrawText( time )

		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( tx, ty )
		surface.DrawText( time )
	end
end )