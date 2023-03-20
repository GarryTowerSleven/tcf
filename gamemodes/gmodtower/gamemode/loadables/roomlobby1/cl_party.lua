local Settings = {
	[1] = "Drinks",
	[2] = "Movies",
	[3] = "Music",
	[4] = "Games",
	[5] = "TV Shows",
	[6] = "A Piano",
}

local SettingsControls = {}
local Price = 250
local DelayBetween = 60 * 30 // Time for parties
local PartyMessageIgnored = CreateClientConVar( "gmt_ignore_party", 0, true, false )

// Accept/decline GUI
net.Receive( "GRoomParty", function( len, ply )

	if PartyMessageIgnored:GetBool() then return end
	if Dueling.IsDueling( LocalPlayer() ) then return end

	local message = net.ReadString()
	local roomid = net.ReadInt( 6 )

	local Question = Msg2( message .. " Join?", 30 )
	Question:SetupQuestion(
		function() 
			RunConsoleCommand( "gmt_joinparty", roomid )
			//net.Start( "GRoomParty" )
			//	net.WriteInt( roomid, 6 )
			//net.SendToServer()
		end, //accept
		function() end, //decline
		function() end, //timeout
		nil,
		{120, 160, 120}, 
		{160, 120, 120}
	)

end )

// Creating a party GUI
local function OpenSuiteParty()

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "Start a Party" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )
		
	local InnerPanel = vgui.Create( "DPanel", Window )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetText( T( "RoomPartyDesc", Price, DelayBetween / 60 ) )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
		
	local Button = vgui.Create( "DButton", ButtonPanel )
	Button:SetText( "Start Party (-" .. Price .. " GMC)" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function()

		flags = ""
		for _, Control in pairs( SettingsControls ) do
			if Control.enabled then // Because :GetValue() doesn't work...
				flags = flags .. Control.id .. ","
			end
		end

		if ( string.EndsWith( flags, "," ) ) then
			flags = flags:sub( 1, #flags - 1 )
		end

		RunConsoleCommand( "gmt_startroomparty", flags )
		Window:Close()

	end
		
	local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
	ButtonCancel:SetText( "Cancel" )
	ButtonCancel:SizeToContents()
	ButtonCancel:SetTall( 20 )
	ButtonCancel:SetWide( Button:GetWide() + 20 )
	ButtonCancel:SetPos( 5, 5 )
	ButtonCancel.DoClick = function() Window:Close() end
	ButtonCancel:MoveRightOf( Button, 5 )

	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )


	local w, h = Text:GetSize()
	w = math.max( w, 400 )
	
	Window:SetSize( w + 50, h + 25 + 75 + 10 + 20 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	Text:StretchToParent( 5, 5, 5, 35 )

	local controlH = 0
	SettingsControls = {}
	for id, text in pairs( Settings ) do
	
		local Control = vgui.Create( "DCheckBoxLabel", Window )
		Control:SetText( text )
		Control:SetWidth( 300 )
		Control:SetContentAlignment( 5 )
		Control:SetPos( Text.x, 10 + Text:GetTall() + Text.y + ( id * Control:GetTall() ) )
		Control:AlignLeft( 30 )
		Control.id = id
		Control.enabled = false

		Control.OnChange = function( self, val )
			Control.enabled = val
		end

		controlH = controlH + Control:GetTall()
		table.insert( SettingsControls, Control )

	end

	Window:SetSize( Window:GetWide(), Window:GetTall() + controlH )
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
	Window:DoModal()

end

concommand.Add( "gmt_roomparty", function( ply, cmd, args )

	if ply.GRoomId && ply.GRoomId != 0 && !ply:GetNWBool("GRoomParty") then
		OpenSuiteParty()
	end

end )

concommand.Add( "gmt_roompartyend", function( ply, cmd, args )

	if !ply:GetNWBool("GRoomParty") then return end

	Derma_Query( 
		"Are you sure you want to end the party?",
		"End Suite Party",
		T("yes"), function()
			RunConsoleCommand( "gmt_endroomparty" )
		end,
		T("no"), EmptyFunction
	)

end )