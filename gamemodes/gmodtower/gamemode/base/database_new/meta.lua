local meta = FindMetaTable( "Player" )
if not meta then return end

function meta:DatabaseID()
    return self:AccountID()
end

function meta:DatabaseIP()
    local ip = self:IPAddress()
    local sep = string.Split( ip, ":" )

    return sep[1] or ip
end

function meta:ProfileLoaded()
    return self._DataLoaded or false
end