module( "clsound", package.seeall )

ClientSounds = ClientSounds or {}

function Register( snd )
	table.uinsert( ClientSounds, snd )
	--MsgN( "Registered client sound: ", snd )
	return Sound( snd )
end