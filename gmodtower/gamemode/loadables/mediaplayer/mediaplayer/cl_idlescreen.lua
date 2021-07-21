local DefaultIdlescreen = [[
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>MediaPlayer Idlescreen</title>
	<style type="text/css">
	html, body{
		padding: 0;
		margin: 0;
		background-color: #000;
		position: fixed;
		font-family: Trebuchet MS;
		color: #ccc;
	}
	body{
		width: 100%%;
		height: 100%%;
	}
	.background {
		position: absolute;
		display: block;
		width: 100%%;
		z-index: -1;
		-webkit-transform: scale(1.2);
	}
	.box {
		background-color: #000;
		width: 100%%;
		display: block;
		
		position: absolute;
		top: 50px;
		left: 0px;
		
		font-size: 150%%;
		padding: 6px;
		opacity: .9;
	}
	.box b {
		font-size: 125%%;
	}
	</style>
</head>
<body>
	<img src="https://i.imgur.com/OWx2lVs.png" class="background">
	<div align="center" class="box">
		<b>A video has not yet been selected</b>
		<br>
		Note: Embed disabled videos will not play properly
	</div>
</body>
</html>
]]

local function GetIdlescreenHTML()
	local contextMenuBind = input.LookupBinding( "+menu_context" ) or "C"
	contextMenuBind = contextMenuBind:upper()
	return DefaultIdlescreen:format( contextMenuBind )
end

function MediaPlayer.GetIdlescreen()

	if not MediaPlayer._idlescreen then
		local browser = vgui.Create( "DMediaPlayerHTML" )
		browser:SetPaintedManually(true)
		browser:SetKeyBoardInputEnabled(false)
		browser:SetMouseInputEnabled(false)
		browser:SetPos(0,0)

		local resolution = MediaPlayer.Resolution()
		browser:SetSize( resolution * 16/9, resolution )

		-- TODO: set proper browser size

		MediaPlayer._idlescreen = browser

		local setup = hook.Run( "MediaPlayerSetupIdlescreen", browser )
		if not setup then
			MediaPlayer._idlescreen:SetHTML( GetIdlescreenHTML() )
		end
	end

	return MediaPlayer._idlescreen

end
