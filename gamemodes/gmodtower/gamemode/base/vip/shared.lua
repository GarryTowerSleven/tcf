Vip = {}

include( "sh_player.lua" )

Vip.VIPForAll = false

plynet.Register( "Bool", "VIP" )

if IsLobby then
	plynet.Register( "Vector", "GlowColor" )
	plynet.Register( "Bool", "GlowEnabled" )
end