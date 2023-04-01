include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

surface.CreateFont( "SmallHeaderFont", {
	font      = "Bebas Neue",
	size      = 48,
	weight    = 700,
	antialias = true
})

surface.CreateFont( "SelectMapFont", {
	font      = "Bebas Neue",
	size      = 100,
	weight    = 700,
	antialias = true
})

local donationFeatures = {
	"A fancy VIP tag",
	"VIP only store and items in-game",
	"VIP icon/avatar glow in-game",
	"Suite entity limit raised to 200",
	"Theater duration limit raised to 1 hour 30 minutes",
	"Invites to beta tests",
	"Our eternal love ♥",
	"And more!"
}

local rules = {
	"Chat Spamming",
	"Racism, sexism, homophobia or discrimination",
	"Impersonating developers",
	"Selling GMC for real life currencies or items",
	"Excessive Trolling",
	"Speed hacking, Aimbotting and similar tools",
	"Scripting binds",
	"Adding sexually explict videos to Theater",
	"Sexually explicit sprays",
}

local content = {
	"Press E on this board to download content",
	"",
	"Discord Link",
	"https://discord.gg/6Ty2avgn2C"
}

local OffsetUp = 106.25
local OffsetRight = 42
local OffsetForward = 0
local BoardWidth = 580
local BoardHeight = 700

function ENT:Initialize()

	--self:SharedInit()

	local min, max = self:GetRenderBounds()
	self:SetRenderBounds( min * 1.0, max * 1.0 )

end

function ENT:DrawTranslucent()

	//self:DrawModel()

	local ang = self:GetAngles()
	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )

	local pos = self:GetPos() + ( self:GetUp() * OffsetUp ) + ( self:GetForward() * OffsetForward ) + ( self:GetRight() * OffsetRight )
	pos = pos + ( self:GetRight() * ( math.sin( CurTime() ) * .5 ) )

	if ( LocalPlayer():EyePos() - pos ):DotProduct( ang:Up() ) < 0 then

		ang:RotateAroundAxis( ang:Right(), 180 )

		pos = pos + self:GetRight() * -( OffsetRight * 2 )

		if self:GetSkin() == 4 then

			pos = pos + self:GetRight() * -( OffsetRight / 2 )

		end

	end

	cam.Start3D2D( pos, ang, .15 )
		self:DrawMain()
	cam.End3D2D()

end

function ENT:DrawMain()

	//surface.SetDrawColor( 255, 0, 255 )
	//surface.DrawRect( 0, 0, BoardWidth, BoardHeight )

	// Custom messages

	if self.Text && self.Text != "" then

		local lines = string.Split( self.Text, '|' )
		local curX = 50

		for _, text in pairs( lines ) do

			draw.SimpleText( text, "SelectMapFont", 50, curX, Color(255,255,255), TEXT_ALIGN_LEFT )

			curX = curX + 70

		end

		return

	end

	// Donation!

	if self:GetSkin() == 1 then

		// Player donated!

		--if LocalPlayer().IsVIP && LocalPlayer():IsVIP() then
		if LocalPlayer():GetNWBool("VIP") == true then

			draw.SimpleText( "THANKS FOR JOINING!", "SelectMapFont", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
			draw.SimpleText( "by the way...", "SelectMapFont", 0, 70, Color(255,255,255), TEXT_ALIGN_LEFT )

			draw.SimpleText( "You can press E on this to open the group discord", "SmallHeaderFont", 30, 300, Color(255,255,255), TEXT_ALIGN_LEFT )

			draw.SimpleText( "You're awesome ♥ ", "SmallHeaderFont", 30, 180, Color(255,255,255), TEXT_ALIGN_LEFT )

			return

		end

		// Advertise donating

		draw.SimpleText( "JOIN THE GROUP TODAY!", "SelectMapFont", 0, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
		draw.SimpleText( "and get...", "SelectMapFont", 0, 65, Color(255,255,255), TEXT_ALIGN_LEFT )

		local curX = 65 + 80

		for _, feature in ipairs( donationFeatures ) do

			draw.SimpleText( "• " .. feature, "SmallHeaderFont", 30, curX, Color(255,255,255), TEXT_ALIGN_LEFT )
			curX = curX + 35

		end

		draw.SimpleText( "Press E on this to visit the group page!", "SelectMapFont", 0, curX + 30, Color(255,255,255), TEXT_ALIGN_LEFT )

	end

	// Direction to pool/lobby

	if self:GetSkin() == 2 then

		draw.SimpleText( "← lobby", "SelectMapFont", 160, 240, Color(255,255,255), TEXT_ALIGN_LEFT )
		draw.SimpleText( "pool →", "SelectMapFont", 160, 310, Color(255,255,255), TEXT_ALIGN_LEFT )

	end

	// Direction to pool/lobby

	if self:GetSkin() == 3 then

		draw.SimpleText( "lobby →", "SelectMapFont", 160, 240, Color(255,255,255), TEXT_ALIGN_LEFT )
		draw.SimpleText( "← pool", "SelectMapFont", 160, 310, Color(255,255,255), TEXT_ALIGN_LEFT )

	end

	// Rules

	if self:GetSkin() == 4 then

		draw.SimpleText( "RULES", "SelectMapFont", 200, 0, Color(255,255,255), TEXT_ALIGN_LEFT )

		local curX = 100

		for _, rule in ipairs( rules ) do

			draw.SimpleText( "• No " .. rule, "SmallHeaderFont", 0, curX, Color(255,255,255), TEXT_ALIGN_LEFT )

			curX = curX + 35

		end

	end

	// Missing Content

	if self:GetSkin() == 5 then

		draw.SimpleText( "DOWNLOAD CONTENT", "SelectMapFont", 200, 0, Color(255,255,255), TEXT_ALIGN_LEFT )

		local curX = 100
		for _, list in ipairs( content ) do

			draw.SimpleText( list, "SmallHeaderFont", 475, curX, Color(255,255,255), TEXT_ALIGN_CENTER )
			curX = curX + 35

		end

	end

	// Welcome Board

	if self:GetSkin() == 6 then

		draw.SimpleText( "Welcome to GMod Tower!", "SelectMapFont", 200, 0, Color(255,255,255), TEXT_ALIGN_LEFT )

	end

end

net.Receive( "OpenDonation", function( len, pl )

	local url

	Donation = vgui.Create("DFrame")
	Donation:SetSize(ScrW(), ScrH())
	Donation:Center()
	Donation:SetDraggable(false)
	Donation:MakePopup()

	if LocalPlayer():GetNWBool("VIP") != true then
		Donation:SetTitle("Steam Group")
		url = "https://steamcommunity.com/groups/TheCommunityFirst"
	else
		Donation:SetTitle("Group Discord")
		url = "https://gmtower.nailgunworld.com/chat"
	end

	Donation.btnMaxim:Hide()
	Donation.btnMinim:Hide()
	Donation.Paint = function(self, w, h)
	draw.RoundedBox(0,0,0,w,h,Color(0,80,161))
	draw.RoundedBox(0,0,0,w,25,Color(0,65,129))
	end

	local OpenDonation = vgui.Create("DHTML", Donation)
	OpenDonation:Center()
	OpenDonation:Dock( FILL )
	function OpenDonation:ConsoleMessage( msg ) end

	local ctrls = vgui.Create( "DHTMLControls", Donation ) -- Navigation controls
	ctrls:SetWide( 750 )
	ctrls:SetPos( 0, -50 )
	ctrls:SetHTML( OpenDonation ) -- Links the controls to the DHTML window
	ctrls.AddressBar:SetText(url) -- Address bar isn't updated automatically
	OpenDonation:MoveBelow( ctrls ) -- Align the window to sit below the controls
	OpenDonation:OpenURL(url)

end)

net.Receive( "OpenDownload", function()

	gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=213278392" )

end )

usermessage.Hook( "OpenDonation", function( um )

	local URL = "https://steamcommunity.com/groups/TheCommunityFirst"
	local Title = "Steam Group"

	if LocalPlayer().IsVIP && LocalPlayer():IsVIP() then

		URL = "https://gmtower.nailgunworld.com/chat"
		Title = "Group Discord"

	end

	browser.OpenURL( URL, Title )

end )

usermessage.Hook( "OpenSetBoard", function( um )

	local entid = um:ReadShort()
	local board = ents.GetByIndex( entid )

	Derma_StringRequest(
		"Set Board",
		"Set the text of this board",
		board.Text or "",
		function(text) RunConsoleCommand( "gmt_setboard", entid, text ) end
	)

end )
