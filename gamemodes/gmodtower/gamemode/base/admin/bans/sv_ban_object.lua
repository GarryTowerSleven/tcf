
module( "Bans", package.seeall )

BanObject = {}
BanObject.__index = BanObject

function New()

    local NewBan = {
        steamid = nil,
        banner = "SERVER",
        name = "Unknown",
        ip = "",
        reason = DefaultReason,
        banned_on = os.time(),
        duration = 0,
	}

    setmetatable( NewBan, BanObject )
	return NewBan

end

AccessorFunc( BanObject, "steamid",     "SteamID" )
AccessorFunc( BanObject, "banner",      "Banner" )
AccessorFunc( BanObject, "name",        "Name" )
AccessorFunc( BanObject, "ip",          "IP" )
AccessorFunc( BanObject, "reason",      "Reason" )
AccessorFunc( BanObject, "duration",    "Length" )
AccessorFunc( BanObject, "banned_on",   "Date" )

function BanObject:SetFromSQL( row )
    
    self:SetSteamID( row.steamid )
    self:SetName( row.name )
    self:SetIP( row.ip )
    self:SetReason( row.reason )
    self:SetLength( row.time )
    self:SetDate( row.bannedOn )

end

function BanObject:GetInsert()

    local data = {
		steamid = Database.Escape( self:GetSteamID(), true ),
		name = Database.Escape( self:GetName(), true ),
		ip = Database.Escape( self:GetIP(), true ),
		reason = Database.Escape( self:GetReason(), true ),
		bannedOn = self:GetDate(),
        time = self:GetLength(),
	}

	local query_string = "INSERT INTO `gm_bans` " .. Database.CreateInsertQuery( data ) .. ";"

    return query_string

end

function BanObject:GetRemoveQuery()

    local query_string = "UPDATE `gm_bans` SET `time` = -1 WHERE `steamid` = " .. Database.Escape( self:GetSteamID(), true ) .. " AND `bannedOn` = " .. Database.Escape( self:GetDate() ) .. ";"

    return query_string

end

function BanObject:SetData( steamid, name, ip )

    if not steamid then return end

    self.steamid = steamid
    self.name = name or self.name
    self.ip = ip or self.ip

end

function BanObject:SetPlayer( ply )

    if not IsValid( ply ) then return end

    self:SetData( ply:SteamID(), ply:Nick(), ply:DatabaseIP() )

end

function BanObject:TimeLeft()

    if self:IsPermanent() then
        return 0
    end

    return math.Clamp( ( self.banned_on + self.duration ) - os.time(), 0, self.duration )

end

function BanObject:ExpiryDate()

    if self:IsPermanent() then
        return 0
    end

    return self:GetDate() + self:GetLength()

end

function BanObject:IsExpired()

    if self:IsPermanent() then
        return false
    end

    return self:TimeLeft() == 0

end

function BanObject:IsPermanent()

    return self.duration == 0

end

function BanObject:BanNotice()
    
    local str = Format( "You are banned from %s.", ServerName )
    local reason = self:GetReason()

    if self:IsPermanent() then
        str = Format( "You are banned permanently from %s due to the following: %s", ServerName, reason )
    else
        local date_str = os.date( "%I:%M %p %Z - %m/%d/%Y", self:ExpiryDate() )
        str = Format( "You are banned from %s until (%s) due to the following: %s", ServerName, date_str, reason )
    end

    return str

end