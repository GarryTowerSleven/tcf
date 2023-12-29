AddCSLuaFile "shared.lua"
include "shared.lua"

local BaseClass = baseclass.Get( "mp_entity" )

MEDIAPLAYER._YouTubeAddictionThink = 0

function MEDIAPLAYER:Think()
	BaseClass.Think( self )

	local listeners = self:GetListeners()
	for _, v in ipairs( listeners ) do
		if ( not IsValid( v ) ) then return end

		if ( v:Location() != self:GetLocation() ) then
			self:RemoveListener( v )
		end

		// Youtube Addiction
		if ( self._YouTubeAddictionThink < CurTime() ) then
			local media = self:CurrentMedia()
			if ( media and string.StartsWith( media.UniqueID and media:UniqueID() or "", "yt-" ) ) then
				v:AddAchievement( ACHIEVEMENTS.SUITEYOUTUBE, 5 / 60 )
			end

			self._YouTubeAddictionThink = CurTime() + 5
		end
	end
	
	if ( not self:GetOwner() ) then
		local roomid = Location.GetSuiteID( self:GetLocation() )
		if ( roomid > 0 ) then
			local owner = GTowerRooms.GetOwner( roomid )
			if ( not owner ) then return end

			self:SetOwner( owner )
		end
	end
end

/*function MEDIAPLAYER:IsPlayerPrivileged( ply )
	// always allow admins
	if ( ply.IsStaff && ply:IsStaff() ) then return true end

	// check if in suite
	local roomid = Location.GetSuiteID( self:GetLocation() )
	if ( roomid < 1 ) then return false end

	local plyRoom = ply:GetNet( "RoomID" ) or 0

	return plyRoom == roomid
end*/