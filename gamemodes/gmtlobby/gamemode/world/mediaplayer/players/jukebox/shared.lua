--[[---------------------------------------------------------
	Jukebox Media Player
-----------------------------------------------------------]]

local MEDIAPLAYER = MEDIAPLAYER
MEDIAPLAYER.Name = "jukebox"
MEDIAPLAYER.Base = "entity"

MEDIAPLAYER.ServiceWhitelist = { 'yt', 'af' }
MEDIAPLAYER._MaxDuration = 15*60 // 15 minutes