
-----------------------------------------------------
local function GetRandomSong( idx )
	return GAMEMODE.Music[idx][1] .. math.random( 1, GAMEMODE.Music[idx][2] ) .. ".mp3"
end

function PlayMusic( idx, win )
	idx = idx or MUSIC_WAITING
end

usermessage.Hook( "ZMPlayMusic", function( um )
end )
