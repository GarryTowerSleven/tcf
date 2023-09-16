hook.Add("PlayerCanHearPlayersVoice", "GMTAdminAllTalk", function(listener, talker)

	if talker:GetNWBool("GlobalMute") then return false end
	
    if not IsLobby then return true end

	if talker._VoiceLockedToLocation or listener._VoiceLockedToLocation then
		if talker:Location() == listener:Location() then
			return true, true
		end
	end
	
	//Let's find a better way to do this? I hope this raises the perf
	/*if Location.Find(talker:GetPos()) == 7 && Location.Find(listener:GetPos()) != 7 then -- bind to devhq
		return false
	end*/
	
    if listener:GetPos():WithinDistance( talker:GetPos(), 1024 ) then
        return true, true
    end

	return false
end)


hook.Add( "Location", "LocationVoiceLock", function( ply, loc ) 

	if Location.Is( loc, "Dev HQ" ) then
		ply._VoiceLockedToLocation = true
	else
		ply._VoiceLockedToLocation = false
	end

end )