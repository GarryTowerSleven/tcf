---------------------------------
module( "Scoreboard.News", package.seeall )

// TAB

hook.Add( "ScoreBoardItems", "AboutTab", function()
	return vgui.Create( "AboutTab" )
end )

TAB = {}
TAB.Order = 6

function TAB:GetText()
	return "ABOUT"
end

function TAB:CreateBody()
	return vgui.Create( "ScoreboardAbout", self )
end

vgui.Register( "AboutTab", TAB, "ScoreboardTab" )

// ABOUT


ABOUT = {}
ABOUT.Website = "http://gmtdeluxe.org/?p=gamemodes&g="
ABOUT.Gamemodes =
{
	["gmtlobby"] = "lobby",
	["ballrace"] = "ballrace",
	["pvpbattle"] = "pvpbattle",
	["virus"] = "virus",
	["ultimatechimerahunt"] = "ultimatechimerahunt",
	["zombiemassacre"] = "zombiemassacre",
	["minigolf"] = "minigolf",
	["sourcekarts"] = "sourcekarts",
	["gourmetrace"] = "gourmetrace",
}


function ABOUT:Init()

	self.HTML = vgui.Create( "HTML", self )
	self.HTML:SetPos( 4, 25 )
	self.HTML:SetSize( self:GetWide(), ScrH() * 0.5 )

	// Get gamemode page
	local page = nil

	for id, gmpage in pairs( self.Gamemodes ) do
		if gamemode.Get( tostring( id ) ) then
			page = gmpage
		end
	end

	// Display it
	if page then

		local url = self.Website .. page
		self.HTML:OpenURL( url )

		self.HTML:Dock( FILL )

		self:SetTall( 24 + ( ScrH() * 0.5 ) - 4 )

	else
		self:SetVisible( false )
	end

	//self:Center()
	self:InvalidateLayout()

end

function ABOUT:Think()

end

vgui.Register( "ScoreboardAbout", ABOUT )
