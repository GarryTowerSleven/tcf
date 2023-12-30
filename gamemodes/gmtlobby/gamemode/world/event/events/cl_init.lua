include("shared.lua")

module("minievent", package.seeall )

// local DrawTimer = CreateClientConVar( "gmt_draweventtimer", 0, true, false )

net.Receive( "minievent", function()

	local id = net.ReadUInt( 4 )

	if id == 0 then

		local count = net.ReadUInt( 8 )

		for i=1, count do
			
			local name = net.ReadString()
			local endtime = net.ReadFloat()
			
			Msg("Reading name: " .. name .. "\n" )
			
			local Event = New( name, endtime - CurTime() )
			
			if Event && Event.ReceiveNet then
				Event:ReceiveNet()
			end
			
		end
		
	elseif id == 1 then
	
		EndAll()

	end

end )

/*hook.Add( "GTowerHUDPaint", "DrawNextEventTime", function()

	if DrawTimer:GetBool() and GTowerHUD and GTowerHUD.Info then

		local eventname = globalnet.GetNet( "NextEvent" )
		local endtime = globalnet.GetNet( "NextEventTime" )
		local timeleft = endtime - CurTime()

		if timeleft <= 0 then
			timeleft = 0
		end

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

end )*/