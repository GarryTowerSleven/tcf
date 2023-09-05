include "shared.lua"

--[[--------------------------------------------------------
	Networking
----------------------------------------------------------]]

function MediaPlayer.Voteskip( mp )

	local mp = MediaPlayer.GetByObject(mp)
	if not mp then return end

	net.Start( "MEDIAPLAYER.Voteskip" )
		net.WriteString( mp:GetId() )
	net.SendToServer()

end

function MediaPlayer.VoteMedia( mp, media, value )

	local mp = MediaPlayer.GetByObject(mp)
	if not mp then return end

	net.Start( "MEDIAPLAYER.VoteMedia" )
		net.WriteString( mp:GetId() )
		net.WriteString( media:UniqueID() )
		mp.net.WriteVote( value )
	net.SendToServer()

end

function MediaPlayer.Shuffle( mp )

	local mp = MediaPlayer.GetByObject(mp)
	if not mp then return end

	net.Start( "MEDIAPLAYER.Shuffle" )
		net.WriteString( mp:GetId() )
	net.SendToServer()

end


--[[--------------------------------------------------------
	Sidebar
----------------------------------------------------------]]

local ShowSidebarTbl = {
	theater = true,
	// jukebox = true,
	club = true,
}

hook.Add( "GetMediaPlayer", "GMTMediaPlayerCheck", function()

	local mpLocal
	local plyLoc = LocalPlayer():Location()

	for _, mp in pairs(MediaPlayer.List) do
		if ShowSidebarTbl[mp:GetType()] and mp:GetLocation() == plyLoc then
			mpLocal = mp
			break
		end
	end

	return mpLocal

end )

//MediaPlayer.ShowSidebar = EmptyFunction
//MediaPlayer.HideSidebar = EmptyFunction

// Classic Sidebar
hook.Add( "OpenSideMenu", "OpenTheaterControls", function()

	local mp = hook.Run( "GetMediaPlayer" )

	-- First check if we're looking at a media player
	if not mp then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) then
			mp = MediaPlayer.GetByObject( ent )
		end
	end

	-- Else, maybe the gamemode handles this some other way (location system, etc.)
	if not mp then
		mp = hook.Run( "GetMediaPlayer" )
	end

	if not mp then
		if Location.IsSuite(LocalPlayer():Location()) then
			for _, jukebox in ipairs(ents.FindByClass("gmt_jukebox")) do
				if jukebox:Location() == LocalPlayer():Location() then
					mp = MediaPlayer.GetByObject( jukebox )
				end
			end
		end
	end

	if ( not IsValid( mp ) ) then return end
	
	local ent = mp.Entity
	if ( not IsValid( ent ) ) then return end

	local Form = vgui.Create( "DForm" )
	Form:SetName( "Media" )

	local VolumeSlider = vgui.Create( "DNumSlider2", Form )
	VolumeSlider:SetText( "Volume" )
	VolumeSlider:SetMinMax( 0, 100 )
	VolumeSlider:SetDecimals( 0 )
	VolumeSlider:SetConVar( Volume.VarVideo )
	VolumeSlider:SizeToContents()
	Form:AddItem( VolumeSlider, nil )

	local mpRequest = Form:Button( "Add New Video" )
	mpRequest.DoClick = function()
		MediaPlayer.OpenRequestMenu( mp )
	end

	local mpRemove = Form:Button( "Vote Remove" )
	mpRemove.DoClick = function()
		MediaPlayer.Voteskip( mp )
	end

	local mpVideos = Form:Button( "Videos" )
	mpVideos.DoClick = function()
		//MediaPlayer.Voteskip( mp )
		MediaPlayer.ShowSidebar( mp )
	end

	return Form

end )

// hook.Add( "GTowerShowMenus", "GMTShowMPSidebar", MediaPlayer.ShowSidebar )
hook.Add( "GTowerHideMenus", "GMTHideMPSidebar", MediaPlayer.HideSidebar )


--[[--------------------------------------------------------
	Setup sidebar buttons
----------------------------------------------------------]]

local AllowedMPTypes = {
	theater = true,
	jukebox = true,
	club = true
}

local mediaplayer

---
-- Hook up events for sidebar voteskipping
--
local function SetupVoteskip( SidebarPresenter, mp )

	mediaplayer = mp

	SidebarPresenter:RegisterHook( "mp.events.ui.voteskipMedia", function()
		MediaPlayer.Voteskip( mp:GetId() )
	end )

	SidebarPresenter:RegisterHook( MP.EVENTS.UI.VOTE_MEDIA, function( media, value )
		MediaPlayer.VoteMedia( mp:GetId(), media, value )
	end )

end
hook.Add( MP.EVENTS.UI.SETUP_SIDEBAR, "GMT.TheaterVoteskip", SetupVoteskip )

---
-- Add button to sidebar playback panel
--
local function AddVoteskipBtn( PlaybackPanel )

	if not mediaplayer then return end
	if not AllowedMPTypes[mediaplayer:GetType()] then return end

	if mediaplayer:HasVoteskipped() then return end

	local SkipBtn = vgui.Create( "MP.VoteSkipButton" )

	PlaybackPanel:AddButton( SkipBtn )

end
hook.Add( MP.EVENTS.UI.SETUP_PLAYBACK_PANEL, "GMT.TheaterVoteskip", AddVoteskipBtn )

---
-- Add button to sidebar playback panel
--
local function AddVoteControls( panel )

	if not mediaplayer then return end
	if not AllowedMPTypes[mediaplayer:GetType()] then return end

	local VoteControls = vgui.Create( "MP.VoteControls" )
	VoteControls:SetDownvoteEnabled( false )

	panel:AddButton( VoteControls )

end
hook.Add( MP.EVENTS.UI.SETUP_MEDIA_PANEL, "GMT.TheaterVoteControls", AddVoteControls )


--[[--------------------------------------------------------
	Voteskip Sidebar Button
----------------------------------------------------------]]

local SKIP_BTN = {}

function SKIP_BTN:Init()

	self.BaseClass.Init( self )

	self:SetIcon( "mp-thumbs-down" )

end

function SKIP_BTN:DoClick()

	hook.Run( "mp.events.ui.voteskipMedia", self.m_Media )

end

derma.DefineControl( "MP.VoteSkipButton", "", SKIP_BTN, "MP.SidebarButton" )


--[[--------------------------------------------------------
	Idlescreen
----------------------------------------------------------]]

local DefaultIdlescreen = [[
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
</head>
<body>
	<style>
		body {
			width: 100vw;
			height: 100vh;
			padding: 0;
			margin: 0;

			overflow: hidden;

			background-image: url( http://i.imgur.com/OWx2lVs.png );
			background-position: center;
			background-size: cover;

			font-family: 'Trebuchet MS';
			font-size: 3rem;
		}
		.content {
			background-color: black;
			color: white;
			text-align: center;

			position: absolute;
			width: 100%;
			top: 1em;

			padding-block: .25em;

			opacity: .85;
		}
		.content b {
			font-size: 1.25em;
		}
	</style>
	<div class="content">
		<b>A video has not yet been selected</b>
		<br>
		<span>Note: Embed disabled videos will not play properly</span>
	</div>
</body>
</html>
]]

hook.Add( "MediaPlayerSetupIdlescreen", "GMTSetupIdlescreen", function(browser)
	browser:SetHTML( DefaultIdlescreen )
	return true
end )


--[[--------------------------------------------------------
	Utils
----------------------------------------------------------]]

cvars.TwoWayBind( "gmt_volume_video", "mediaplayer_volume",
	-- `gmt_volume_video` => `mediaplayer_volume`
	function(value)
		return tonumber(value) / 100
	end,

	-- `mediaplayer_volume` => `gmt_volume_video`
	function(value)
		return tonumber(value) * 100
	end
)


--[[--------------------------------------------------------
	Misc
----------------------------------------------------------]]

hook.Add( "MediaPlayerFullscreenToggled", "GMTNotice", function( isFullscreen )
	local status = isFullscreen and "ON" or "OFF"
	local msg = ("Fullscreen %s: Press F11 to toggle."):format( status )

	Msg2( msg )
end)
