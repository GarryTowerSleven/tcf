
surface.CreateFont( "VoteTitle", { font = "TodaySHOP-BoldItalic", size = 68, weight = 200 } )

surface.CreateFont( "VoteGMTitle", { font = "Bebas Neue", size = 40, weight = 200 } )

surface.CreateFont( "VoteCancel", { font = "Oswald", size = 42, weight = 400 } )

surface.CreateFont( "VoteTip", { font = "Bebas Neue", size = 32, weight = 200 } )

surface.CreateFont( "VoteText", { font = "TodaySHOP-BoldItalic", size = 22, weight = 20 } )



//=======================================================



local PANEL = {}

PANEL.Maps = {}



function PANEL:Init()



	self:ParentToHUD()



	self.Canvas = vgui.Create( "Panel", self )

	self.Canvas:MakePopup()

	self.Canvas:SetKeyboardInputEnabled( false )



	self.lblTitle = vgui.Create( "DLabel", self.Canvas )

	self.lblGMTitle = vgui.Create( "DLabel", self.Canvas )

	self.lblTimer = vgui.Create( "DLabel", self.Canvas )

	self.lblTip = vgui.Create( "DLabel", self.Canvas )



	self.MapList = vgui.Create( "DMapList", self.Canvas )

	self.MapList:SetDrawBackground( false )

	self.MapList:SetSpacing( 4 )



	self.MapPreview = vgui.Create( "DPanel", self.Canvas )



	self.Canvas:Dock( FILL )



	self.Time = RealTime()

	self.VotedMap = nil

	self.HoveredMap = nil



	self.CancelButton = vgui.Create( "DPanel", self.Canvas )

	self.CancelButton.Paint = PanelDrawCancelButton

	self.CancelButton.OnMousePressed = function()

		surface.PlaySound("gmodtower/ui/select.wav")

		Derma_Query("Are you sure you no longer want to join this server (you will leave your group)?", "Are you sure?",

			"Yes", function()

				RunConsoleCommand("gmt_mtsrv", 2 )

				GTowerServers:CloseChooser()

				RunConsoleCommand("gmt_leavegroup")

			end,

			"No", EmptyFunction

		)

	end



end

MapsList = {}

GamemodePrefixes =
{
	["ballracer_"] 	= "br",
	["pvp_"] 		= "pvpbattle",
	["virus_"] 		= "virus",
	["uch_"] 		= "ultimatechimerahunt",
	["minigolf_"] 	= "minigolf",
	["gr_"] 		= "gourmetrace",
}

function MapsGetGamemode( map )

	// Get gamemode name based on prefix
	for prefix, gamemodename in pairs( GamemodePrefixes ) do
		if string.find( map, prefix ) then
			return gamemodename
		end
	end

	return "gmtlobby"

end



function PANEL:SetGamemode( Gamemode )

	self.Gamemode = Gamemode


	local map = table.Random( Gamemode.Maps )
	self.HoveredMap = Maps.GetMapData( map )



	self:SetupMaps()

	self:SetupPreview()



end



function PanelDrawCancelButton( self )

	if self.Hovered then

		surface.SetDrawColor( 170, 14, 41, 190 )

		if !self.PlayedSound then
			self.PlayedSound = true
			surface.PlaySound("gmodtower/casino/videopoker/click.wav")
		end

	else

		self.PlayedSound = false

		surface.SetDrawColor( 0, 0, 0, 150 )

	end



	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )



	draw.SimpleText( "LEAVE", "VoteCancel", self:GetWide()/2, self:GetTall()/2, Color(255,255,255,255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )



end



function PANEL:PerformLayout()



	self:SetPos( 0, 0 )

	self:SetSize( ScrW(), ScrH() )



	self.Canvas:SetZPos( 0 )



	self.lblTitle:SetText( "SELECT A MAP" )

	self.lblTitle:SetFont( "VoteTitle" )

	self.lblTitle:SetTextColor( color_white )

	self.lblTitle:SizeToContents()

	self.lblTitle:SetPos( ScrW()/2 - self.lblTitle:GetWide()/2, 50 )



	self.lblGMTitle:SetText( self.Gamemode.Name )

	self.lblGMTitle:SetFont( "VoteGMTitle" )

	self.lblGMTitle:SetTextColor( color_white )

	self.lblGMTitle:SizeToContents()

	self.lblGMTitle:SetPos( ScrW()/2 - self.lblGMTitle:GetWide()/2, 10 )



	self.lblTimer:SetText( "20" )

	self.lblTimer:SetFont( "VoteTitle" )

	self.lblTimer:SetTextColor( color_white )

	self.lblTimer:SetContentAlignment( 5 )

	self.lblTimer:SizeToContents()

	self.lblTimer:SetPos( ScrW() - 95, 25 )



	self.lblTip:SetText("")

	self.lblTip:SetFont( "VoteTip" )

	self.lblTip:SetTextColor( color_white )

	self.lblTip:SetContentAlignment( 5 )

	self.lblTip:SizeToContents()

	self:SetRandomTip()



	self.MapList:SetPos( ScrW() / 4 - self.MapList:GetWide() / 2, 160 )

	self.MapList:SetSize( ScrW()/2, ScrH() - 160 )



	self.MapPreview:SetSize( 500, 500 )

	self.MapPreview:SetPos( ScrW() + self.MapPreview:GetWide(), 160 )

	self.MapPreview:MoveTo( (ScrW() * (3/4)) - self.MapPreview:GetWide() / 2, 160, 0.65 )



	self.CancelButton:SetSize( 250, 40 )

	self.CancelButton:SetPos( ( ScrW() / 2 ) - ( self.CancelButton:GetWide() / 2 ), ScrH() + 40 )

	self.CancelButton:MoveTo( ( ScrW() / 2 ) - ( self.CancelButton:GetWide() / 2 ), ScrH() - 120 - 40 - 20, 0.65 )



	self:UpdateVotes()

	self:UpdatePreview()



end

function MapsGetPreviewIcon( map )

	if map == "gmt_ballracer_nightball" or map == "gmt_gr_ruins" /*or map == "gmt_ballracer_miracle"*/ or map == "gmt_gr_nile" or map == "gmt_ballracer_metalworld"  or map == "gmt_ballracer_neonlights" or map == "gmt_ballracer_facile" or map == "gmt_ballracer_summit" or map == "gmt_ballracer_tranquil" or map == "gmt_ballracer_spaceworld" or map == "gmt_minigolf_desert" or map == "gmt_sk_stadium" or map == "gmt_sk_rave" or map == "gmt_pvp_aether" or map == "gmt_pvp_mars" or map == "gmt_pvp_aether" or map == "gmt_pvp_neo" then
		return "gmod_tower/maps/preview/" .. map
	elseif map == "gmt_sk_island01_fix" then
		return "gmod_tower/maps/preview/" .. string.sub( "gmt_sk_island01", 0, -3 )
	else
		return "gmod_tower/maps/preview/" .. string.sub( map, 0, -3 )
	end

end

function PANEL:SetupMaps()


	self.MapList:Clear()



	local Gamemode = self.Gamemode

	local maps = self.Gamemode.Maps



	for id, map in pairs( maps ) do



		// Collect map data

		local mapData = Maps.GetMapData( map )

		if !mapData then continue end

		local canPlay = !table.HasValue( GTowerServers.NonPlayableMaps, map )
		mapData.PreviewIcon = MapsGetPreviewIcon( map )



		// Setup panel

		local panel = vgui.Create( "DPanel", self.MapList )

		panel:SetPaintBackground( false )



		// Setup main data

		panel.NumVotes = GTowerServers:GetVotes( map )

		panel.Map = map

		panel.Priority = mapData.Priority



		panel.btnMap = vgui.Create( "DButton", panel )

		panel.btnMap:SetText( mapData.Name )

		panel.btnMap:SetSize( 250, 75 )

		panel.btnMap:SetTextColor( color_white )

		panel.btnMap:SetFont( "VoteText" )

		panel.btnMap:SetContentAlignment( 7 )

		panel.btnMap:SetTextInset( 8, 0 )

		if !canPlay then
			panel.btnMap:SetTextColor( Color( 255, 255, 255, 50 ) )
			panel.btnMap.Disabled = true
			panel.btnMap:SetTooltip( "Map disabled due to play amount." )
		end

		panel.btnMap.OnCursorEntered = function()

			self.HoveredMap = mapData

			surface.PlaySound("gmodtower/casino/videopoker/click.wav")

			self:UpdatePreview()

		end



		panel.btnMap.OnCursorExited = function()

			self.HoveredMap = nil

			self:UpdatePreview()

		end



		panel.btnMap.DoClick = function()

			if GTowerServers:CanStillVoteMap() and !panel.btnMap.Disabled then

				surface.PlaySound("gmodtower/ui/select.wav")

				GTowerServers:ChooseMap( map )

				self.VotedMap = mapData

				self:UpdateVotes()

				self:UpdatePreview()

			elseif panel.btnMap.Disabled then
				surface.PlaySound("gmodtower/ui/panel_error.wav")
				Msg2( T( "GamemodeCooldown", panel.btnMap:GetText() ) )
			else
				surface.PlaySound("gmodtower/ui/panel_error.wav")
			end

		end



		panel.btnMap.CurProgress = 0



		panel.lblVotes = vgui.Create( "DLabel", panel )

		if panel.NumVotes != 0 then

			panel.lblVotes:SetText( panel.NumVotes )

		else

			panel.lblVotes:SetText( "" )

		end



		panel.lblVotes:SetPos( 5, 3 )

		panel.lblVotes:SetTextColor( color_white )

		panel.lblVotes:SetFont( "VoteText" )

		panel.lblVotes:SetContentAlignment( 4 )

		panel.lblVotes:SizeToContents()


		self.MapList:AddItem( panel )



	end



	// Shuffle

	//self.MapList:Shuffle()



	// Sort by prioirty, if possible

	self.MapList:SortByMember( "Priority" )



	local panel = vgui.Create( "DPanel", self.MapList )

	panel:SetPaintBackground( false )



	panel.lblUndecided = vgui.Create( "DLabel", self.Canvas )

	panel.lblUndecided:SetText( string.format("%s player(s) haven't cast their vote", #player.GetAll() ) )



	panel.lblUndecided:SetTextColor( Color( 255, 255, 255, 255 ) )

	panel.lblUndecided:SetFont( "VoteText" )

	surface.SetFont("VoteText")
	local s = surface.GetTextSize( panel.lblUndecided:GetText() )

	panel.lblUndecided:SetPos( ScrW()/2 - s/2, 120 )

	panel.lblUndecided:SizeToContents()



	self.MapList:AddItem( panel )



end





local grad = Material("vgui/gradient_up")
local grad2 = Material("vgui/gradient_down")

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

function PANEL:SetupPreview( map )



	-- Map Preview Container

	local w, h = 500, 500

	self.MapPreview.Paint = function()

		surface.SetMaterial(grad)
		surface.SetDrawColor( Color( 11, 100, 110, 125 ) )
		surface.DrawTexturedRect(0, 0, w, h)
		surface.SetMaterial(grad2)
		surface.SetDrawColor( Color( 51, 18, 82, 125 ) )
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor( Color( 25, 25, 25, 100 ) )
		surface.DrawRect(0, 0, w, h)

		draw.OutlinedBox( 0, 0, w, h, 4, Color( 25, 25, 25, 175 ) )

		--draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 160 ) )

	end



	// Map Name

	self.lblMapName = vgui.Create( "DLabel", self.MapPreview )

	self.lblMapName:SetText( self.HoveredMap.Name )

	self.lblMapName:SetTextColor( color_white )

	self.lblMapName:SetFont( "VoteTitle" )

	self.lblMapName:SetTextInset(8, 0)

	self.lblMapName:SetSize(w-10, 64)

	self.lblMapName:SetContentAlignment(5)



	// Map Author

	self.lblAuthor = vgui.Create( "DLabel", self.MapPreview )

	self.lblAuthor:SetText( "Author: " .. self.HoveredMap.Author )

	self.lblAuthor:SetTextColor( color_white )

	self.lblAuthor:SetFont( "VoteText" )

	self.lblAuthor:SetTextInset(8, 0)

	self.lblAuthor:SetSize(w-10, 128)

	self.lblAuthor:SetContentAlignment(5)



	// Map icon

	local y = 72

	local realheight = 230



	self.MapIcon = vgui.Create( "DImage", self.MapPreview )

    self.MapIcon:SetOnViewMaterial( self.HoveredMap.PreviewIcon )

	//self.MapIcon:SetFailsafeMatName( "maps/gmt_pvp_default.vmt" ) // handled in gamemode definition

	self.MapIcon:SetSize( 512, 256 )

	self.MapIcon:SetPos( 10, y )



	// Map description

	self.lblDesc = vgui.Create( "DLabel", self.MapPreview )

	self.lblDesc:SetText( self.HoveredMap.Desc or "N/A" )

	self.lblDesc:SetTextColor( color_white )

	self.lblDesc:SetFont( "VoteText" )

	//self.lblDesc:SetWidth( 320 )

	self.lblDesc:SetSize( w - 10*2, 300 )



	y = y + realheight + 10

	self.lblDesc:SetPos( 10, y )

	self.lblDesc:SetWrap(true)

	self.lblDesc:SetContentAlignment(7)



end



PANEL.BarPercent = 0

local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )

local gradientDown = surface.GetTextureID( "VGUI/gradient_down" )

local TotalPlayers = 0

function PANEL:Paint()

	surface.SetDrawColor( Color( 0, 0, 0, 180 ) )

	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )



	self.BarPercent = math.Approach( self.BarPercent, 1, .25 / 50 )



	surface.SetDrawColor( 0, 0, 0, 255 )

	surface.DrawRect( 0, 0, ScrW(), ( 120 * self.BarPercent ) )



	surface.SetTexture( gradientDown )

	surface.DrawTexturedRect( 0, 120 * self.BarPercent, ScrW(), 80 )



	surface.DrawRect( 0, ScrH() - ( 120 * self.BarPercent ), ScrW(), 120 )



	surface.SetTexture( gradientUp )

	surface.DrawTexturedRect( 0, ScrH() - ( ( 120 + 80 ) * self.BarPercent ), ScrW(), 80 )





	local TimeLeft = math.max( GTowerServers.MapEndTime - CurTime(), 0 ) / GTowerServers.MapTotalTime

	local Width = ScrW() * TimeLeft



	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.DrawRect( 0, ScrH() - 120 - 12, Width, 12 )

	surface.SetTextPos( 24, 10 )
	surface.SetTextColor(255,255,255,255)
	surface.SetFont("VoteGMTitle")
	surface.DrawText("PLAYERS QUEUED: " .. (TotalPlayers))



end

local LockMat = Material( "gmod_tower/panelos/icons/lock.png" )

function PANEL:UpdateVotes()



	// Get player count from server

	local ServerId = GTowerServers.ChoosenServerId

	local Server = GTowerServers.Servers[ ServerId ]

	local Players = player.GetAll()

	if Server then

		Players = Server.Players

	end

	TotalPlayers = #Players





	for _, panel in pairs( self.MapList:GetItems() ) do



		if !panel.btnMap then

			local undecided = #Players - GTowerServers:GetTotalVotes()

			if undecided > 0 then

				panel.lblUndecided:SetText( string.format("%s player(s) haven't cast their vote", undecided ) )

			else

				panel.lblUndecided:SetText("")

			end



			return

		end



		local NumVotes = GTowerServers:GetVotes( panel.Map )



		if NumVotes != 0 then

			panel.lblVotes:SetText( NumVotes )
			panel.Votes = tostring( NumVotes )

		else

			panel.lblVotes:SetText( "" )
			panel.Votes = ""

		end



		panel.btnMap.Paint = function()

			local x, y = panel.btnMap:GetPos()

			local w, h = panel.btnMap:GetSize()



			local col = Color( 0, 0, 0, 120 )

			local col_progress = Color( 11, 165, 169, 125 )

			if ( panel.btnMap.Disabled ) then

				col = Color( 0, 0, 0, 235 )

			elseif ( panel.btnMap.Depressed ) then

				col = Color( 0, 0, 0, 84 )

			elseif ( panel.btnMap.Hovered ) then

				col = Color( 100, 100, 100, 84 )

			end



			if ( panel.btnMap.bgColor != nil ) then col = panel.btnMap.bgColor end



			draw.RoundedBox( 0, x, y, w, h, col )



			local progress = w * ( NumVotes / #Players )



			if !panel.btnMap.CurProgress || panel.btnMap.CurProgress != progress then



				panel.btnMap.CurProgress = math.Approach( panel.btnMap.CurProgress, progress, FrameTime() * 500 )

				draw.RoundedBox( 0, x, y, panel.btnMap.CurProgress, 75, col_progress )



			else

				draw.RoundedBox( 0, x, y, progress, 75, col_progress )

			end


			if panel.btnMap.Disabled then
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
				surface.SetMaterial( LockMat )
				surface.DrawTexturedRect(0,0,64,64)
			end


			// TODO show new/modified icons

			/*if !panel.btnMap.HasMap then

				local downloadTexture = surface.GetTextureID( "vgui/mapselector/download" )

				surface.SetDrawColor( 255, 255, 255, 33 )

				surface.SetTexture( downloadTexture )

				surface.DrawTexturedRect( w - 28, 0, 32, 32 )

			end*/



		end



	end



	self.MapList:InvalidateLayout()



end





function PANEL:UpdatePreview()



	local mapData = nil



	// Hovered map

	if self.HoveredMap then

		mapData = self.HoveredMap



	// Voted map

	elseif self.VotedMap && !self.HoveredMap then

		mapData = self.VotedMap

	end



	if !mapData then return end



	self.lblMapName:SetText( mapData.Name )

	self.MapIcon:SetOnViewMaterial( mapData.PreviewIcon )

	self.lblDesc:SetText( mapData.Desc or "N/A" )

	self.lblAuthor:SetText( "Author: " .. mapData.Author or "N/A" )



	self.MapPreview:InvalidateLayout()



end


net.Receive("VoteScreenFinish",function()

	local map = net.ReadString()

	if !ValidPanel( GTowerServers.MapChooserGUI ) then return end
	GTowerServers.MapChooserGUI:FinishVote( map )
end)


function PANEL:FinishVote( map )


	self.lblTitle:SetText( string.format( "Now Loading %q", Maps.GetName(map) ) )

	self.lblTitle:SizeToContents()

	self.lblTitle:SetPos( ScrW()/2 - self.lblTitle:GetWide()/2, 30 )



	local bar = nil

	for _, v in pairs( self.MapList:GetItems() ) do

		if v.btnMap && v.btnMap:GetText() == Maps.GetName(map) then

			bar = v.btnMap

		end

	end



	// Copied from Fretta -- temporary until I can come up with something creative

	//	- Maybe animate buttons outward and focus winning map panel in the center?

	timer.Simple( 0.0, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "gmodtower/misc/blip.wav" ) end )

	timer.Simple( 0.2, function() bar.bgColor = nil end )

	timer.Simple( 0.4, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "gmodtower/misc/blip.wav" ) end )

	timer.Simple( 0.6, function() bar.bgColor = nil end )

	timer.Simple( 0.8, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "gmodtower/misc/blip.wav" ) end )

	timer.Simple( 1.0, function() bar.bgColor = Color( 100, 100, 100 ) end )



end



// TODO: clean this up

function PANEL:SetRandomTip()



	local tip = self.lblTip:GetText()

	local tips = self.Gamemode.Tips



	if tips then



		while tip == self.lblTip:GetText() do

			tip = string.format( "Tip: %s", table.Random( tips )  )

		end



	else

		tip = ""

	end



	self.lblTip:SetText( tip )

	self.lblTip:SizeToContents()

	self.lblTip:SetPos( ScrW()/2 - self.lblTip:GetWide()/2, ScrH() - 72 )



	self.NextTip = CurTime() + 5



end



function PANEL:Think()



	if self.NextTip && self.NextTip < CurTime() then

		self:SetRandomTip()

	end



	local TimeLeft = GTowerServers.MapEndTime - CurTime()

	if TimeLeft < 0 then TimeLeft = 0 end



	local ElapsedTime = string.FormattedTime( TimeLeft )

	ElapsedTime = math.Round( ElapsedTime.s )



	self.lblTimer:SetText( ElapsedTime )

	self.lblTimer:SizeToContents()



end



vgui.Register( "MapSelector", PANEL, "DPanel" )
