module( "Scoreboard.News", package.seeall )

// TAB

hook.Add( "ScoreBoardItems", "AboutTab", function()
	return vgui.Create( "AboutTab" )
end )

TAB = {}
TAB.Order = 6
TAB.RemoveInactive = true

function TAB:GetText()
	return "ABOUT"
end

function TAB:CreateBody()
	return vgui.Create( "ScoreboardAbout", self )
end

vgui.Register( "AboutTab", TAB, "ScoreboardTab" )

// ABOUT


ABOUT = {}
ABOUT.Website = "https://gtower.net/index.html?p=gamemodes&app=1&gm="
ABOUT.Gamemodes = 
{
	["gmtlobby"] = "lobby",
	["ballrace"] = "ballrace",
	["pvpbattle"] = "pvpbattle",
	["virus"] = "virus",
	["gmtuch"] = "uch",
	["zombiemassacre"] = "zombiemassacre",
	["minigolf"] = "minigolf"
}

function ABOUT:Init()

	self.HTML = vgui.Create( "HTML", self )
	self.HTML:SetPos( 4, 25 )
	self.HTML:SetSize( self:GetWide(), ScrH() * 0.5 )

	// Get gamemode page
	local page = self:GetPage()

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

function ABOUT:GetPage()
	for id, gmpage in pairs( self.Gamemodes ) do
		if engine.ActiveGamemode() == tostring( id ) then
			return gmpage
		end
	end
end

function ABOUT:Think()

end

vgui.Register( "ScoreboardAbout", ABOUT )