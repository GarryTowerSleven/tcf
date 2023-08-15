hook.Add("PlayerCanHearPlayersVoice", "GMTAdminAllTalk", function(listener, talker)

    if not IsLobby then return true end

	if Location.Find(talker:GetPos()) == 7 && Location.Find(listener:GetPos()) != 7 then -- bind to devhq
		return false
	end
	
    if listener:GetPos():WithinDistance( talker:GetPos(), 1024 ) then
        return true, true
    end

	return false
end)