AddCSLuaFile "shared.lua"
include "shared.lua"

local BaseClass = baseclass.Get( "mp_entity" )

function MEDIAPLAYER:Think()
	BaseClass.Think( self )

	if ( not self:GetOwner() ) then
		local roomid = Location.GetSuiteID( self:GetLocation() )
		if ( roomid > 0 ) then
			local owner = GTowerRooms.GetOwner( roomid )
			if ( not owner ) then return end

			self:SetOwner( owner )
		end
	end

	local listeners = self:GetListeners()
	for _, v in ipairs( listeners ) do
		if ( v:Location() != self:GetLocation() ) then
			self:RemoveListener( v )
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