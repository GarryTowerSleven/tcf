GM.Name		= "GMTower: Gamemode Base"
GM.Author	= "pixelTail Games"
GM.Website	= "http://www.gmtower.org/"

DeriveGamemode( "gmodtower" )

include( "sh_load.lua" )

Loader.Load( "extensions" )
Loader.Load( "modules" )

/*SetupGMTGamemode( "Base", {
	Loadables = nil, -- Additional loadables

	AllowChangeSize = false, -- Changable player size
	AllowSmall = true, -- Small player models

	DrawHatsAlways = true, -- Always draw hats

	AllowMenu = false, -- Allow to hook into GTowerMenu events
	DisablePlayerClick = false, -- Disable clicking on players

	EnableWeaponSelect = true, -- Allow weapon selection
	EnableCrosshair = true, -- Draw the crosshair
	EnableDamage = true, -- Draw red damage effects

	AFKDelay = 60, -- Seconds before they will be marked as AFK

	ChatY = 0, -- Chat offset Y
	ChatX = 0, -- Chat offset X
	ChatBGColor = Color( 80, 80, 80 ), -- Color of the chat gui
	ChatScrollColor = Color( 50, 50, 50 ), -- Color of the chat scroll bar gui

	UsesHands = false, -- Do we want custom hands for the weapons?

	Particles = {}, -- List of default particles to load

	DisableDucking = false, -- Disable ducking
	DisableJumping = false, -- Disable jumping
	DisableRunning = false, -- Disable running
} )	*/