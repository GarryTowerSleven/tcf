-- Voice Enable Replacement
if CLIENT then
	CreateConVar( "gmt_voice_enable", 1, { FCVAR_USERINFO, FCVAR_ARCHIVE } )
else
	hook.Add( "PlayerCanHearPlayersVoice", "GMTVoiceEnable", function( listener, talker )
		if VoiceNotEnabled(listener) || VoiceNotEnabled(talker) then return false end
	end )
end

function VoiceNotEnabled(ply)
	return !tobool(ply:GetInfoNum( "gmt_voice_enable", 1 ))
end