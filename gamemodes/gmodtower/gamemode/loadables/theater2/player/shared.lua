MEDIAPLAYER.Name = "theater"
MEDIAPLAYER.Base = "entity"

MEDIAPLAYER.ServiceWhitelist = { 'yt' }

function MEDIAPLAYER:IsIdlescreen()
    local media = self:CurrentMedia()
    if ( not IsValid( media ) ) then return false end

    return media._Idlescreen or false
end