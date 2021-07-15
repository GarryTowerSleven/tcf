/*MEDIAPLAYER = {}

include "shared.lua"

local BaseClass = baseclass.Get( "mp_entity" )

---
-- Audio plays throughout the whole condo.
--
MEDIAPLAYER.Enable3DAudio = false

---
-- Don't draw anything for the condo panel.
--
/function MEDIAPLAYER:Draw()
end

function MediaPlayer.RequestShuffle( mp )

	mp = MediaPlayer.GetByObject(mp)
	if not mp then return end

	net.Start( "MEDIAPLAYER.Shuffle" )
		net.WriteString( mp:GetId() )
	net.SendToServer()

end

function MEDIAPLAYER:NetReadUpdate()
	BaseClass.NetReadUpdate(self)
	self._Shuffle = net.ReadBit() == 1
	self._ShuffleNext = net.ReadChar()
end

MediaPlayer.Register( MEDIAPLAYER )
MEDIAPLAYER = nil*/