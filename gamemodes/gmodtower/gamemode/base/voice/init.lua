hook.Add( "PlayerCanHearPlayersVoice", "GMTAdminAllTalk", function(listener, talker)

	if talker._Muted then return false end
	if talker._AllTalk then return true, false end
	
    if not IsLobby then return true end

	if talker._VoiceLockedToLocation or listener._VoiceLockedToLocation then
		if talker:Location() == listener:Location() then
			return true, true
		end
	end
	
    if listener:GetPos():WithinDistance( talker:GetPos(), 1024 ) then
        return true, true
    end

	return false
	
end )


hook.Add( "Location", "LocationVoiceLock", function( ply, loc ) 

	if Location.Is( loc, "Dev HQ" ) then
		ply._VoiceLockedToLocation = true
	else
		ply._VoiceLockedToLocation = false
	end

end )