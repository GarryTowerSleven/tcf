module( "Volume", package.seeall )

VIDEO = 1
AUDIO = 2

VarVideo = "gmt_volume_video"
ConVarVideo = CreateClientConVar( VarVideo, 75.0, true )

VarAudio = "gmt_volume_audio"
ConVarAudio = CreateClientConVar( VarAudio, 75.0, true )

function Get(id)
	if id == VIDEO then
		return ConVarVideo:GetFloat()
	end
	if id == AUDIO then
		return ConVarAudio:GetFloat()
	end
	return 1
end
	
function GetNormal(id)
	return Get(id) / 100
end

function Set( val, id )
	if id == VIDEO then
		RunConsoleCommand( VarVideo, math.Clamp( val, 0, 100 ) )
	end
	if id == AUDIO then
		RunConsoleCommand( VarAudio, math.Clamp( val, 0, 100 ) )
	end
end

cvars.AddChangeCallback( VarAudio, function( CVar, previus, new )
	timer.Create( "GMTChangeVolume", 0.5, 1, hook.Call, "Volume", GAMEMODE, tonumber( new ) )
end )