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

DisplayNames = {
	["storesale"] = "Store Sale",
	["balloonpop"] = "Balloon Pop",
	["obamasmash"] = "Obama Smash",
	["chainsaw"] = "Chainsaw Massacre",
	["pvpnarnia"] = "PVP Narnia",
}

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

	local eventname = DisplayNames[eventname] or eventname

	local font = "GTowersmall"
	local time = "Next Event (" .. eventname .. ") in " .. timeformat
		
	time = string.upper(time)
	font = "GTowerHUDMainSmall"
	surface.SetFont( font )

	local tw, th = surface.GetTextSize( time )
	local tx, ty = GTowerHUD.Info.X + GTowerHUD.Info.Width-24-tw, GTowerHUD.Info.Y + GTowerHUD.Info.TextureHeight - 10

	surface.SetTextColor( 0, 0, 0, 255 )
	surface.SetTextPos( tx + 1, ty + 1 )
	surface.DrawText( time )

	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( tx, ty )
	surface.DrawText( time )
end )