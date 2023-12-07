--[[---------------------------------------------------------
	Suite Panel Media Player
-----------------------------------------------------------]]

local MEDIAPLAYER = MEDIAPLAYER
MEDIAPLAYER.Name = "suitepanel"
MEDIAPLAYER.Base = "entity"

MEDIAPLAYER.ServiceWhitelist = { 'yt', 'af' }
MEDIAPLAYER._MaxDuration = 15*60 // 15 minutes