hook.Add("PlayerCanHearPlayersVoice", "GMTAdminAllTalk", function(listener, talker)

    if not IsLobby then return true end

    if listener:GetPos():WithinDistance( talker:GetPos(), 1024 ) then
        return true, true
    end

    return false

end)