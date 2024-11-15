---------------------------------
module("GTowerRooms", package.seeall )


hook.Add("PlayerHasControl", "CheckInRoom", function( ply, ent )

	local Room = VecInRoom( ent:GetPos() )

	if Room && Room.Owner == ply then
		return true
	end

end )

hook.Add("GTowerInvDrop", "BlockSuiteUsageDrop", function( ply, trace, Item, moving )
	local Room = VecInRoom( trace.HitPos )

	if Room then
		if Room.Owner == ply then

			if !ply:Achived( ACHIEVEMENTS.SUITEDESIGNER ) then
				if ply:GetNet( "RoomEntityCount" ) >= 200 then
					ply:SetAchievement( ACHIEVEMENTS.SUITEDESIGNER, 1 )
				end
			end
			
			//Check if the player has reached entity limit count
			if moving != true then
				local Maximun = ply:GetNet("RoomMaxEntityCount")

				if Room:ActualEntCount() >= Maximun then
					umsg.Start("GRoom", ply)
					umsg.Char( 13 )
					umsg.Char( Maximun - 120 )
					umsg.End()
					return false
				end
			end

			if !ply:Achived( ACHIEVEMENTS.SUITEOCD ) then

				if !ply._AchiSuiteOCDCount then
					ply._AchiSuiteOCDCount = {}
				end

				ply._AchiSuiteOCDCount[ Item.MysqlId ] = (ply._AchiSuiteOCDCount[ Item.MysqlId ] or 0) + 1

				if ply._AchiSuiteOCDCount[ Item.MysqlId ] > ply:GetAchievement( ACHIEVEMENTS.SUITEOCD ) then
					ply:SetAchievement( ACHIEVEMENTS.SUITEOCD, ply._AchiSuiteOCDCount[ Item.MysqlId ] )
				end

			end

			return true
		end
	end

end )


hook.Add("PlayerTeleport", "CheckUncheckSuite", function( ply, goplace )

	if goplace == Location.SUITETELEPORTERS && ply._SendSuiteIds == nil then
		GTowerRooms.SendEntIDs( ply )
		ply._SendSuiteIds = true
	end

end )

local SuitePlaces = {}

timer.Simple( 5, function()
	SuitePlaces = Location.GetSuiteLocations()
end )

hook.Add("Location", "GetOffSuite", function( ply, loc )

	local Room = ply:GetRoom()

	if Room && loc && !table.HasValue( SuitePlaces, loc )  then

		Room:Finish()

		if IsValid(ply) && ply:GetNWBool("Party") then
			ply:SetNWBool("Party", false)
			ply:Msg2( T( "RoomPartyEnded" ), "condo" )
		end

		umsg.Start("GRoom", ply)
			umsg.Char( 11 )
		umsg.End()

	end

end )

hook.Add("PlayerDeath", "CheckoutSuite", function( ply )

	local Room = ply:GetRoom()

	if Room && !ply:IsAdmin() then
		Room:Finish()

		if IsValid(ply) && ply:GetNWBool("Party") then
			ply:SetNWBool("Party", false)
			ply:Msg2( T( "RoomPartyEnded" ), "condo" )
		end

		umsg.Start("GRoom", ply)
		umsg.Char( 11 )
		umsg.End()
	end

end )

hook.Add("CanUpateHat", "GTowerUpdateSuiteHat", function( ply )
	return true
end )

hook.Add("GTowerClientUpdated", "RemoveRoom", function( ply, disconnect )
	if disconnect == true then
		local Room = ply:GetRoom()

		if Room then
			Room:Cleanup()
		end

	end
end )

hook.Add("AdminCommand", "RemoveOwnerRoom", function( args, admin, ply )

	if args[1] == "remroom" then
		local Room = ply:GetRoom()

		if Room then
			Room:Finish()

			if IsValid(ply) && ply:GetNWBool("Party") then
				ply:SetNWBool("Party", false)
				ply:Msg2( T( "RoomPartyEnded" ), "condo" )
			end

			umsg.Start("GRoom", ply)
				umsg.Char( 15 )
			umsg.End()
		end

	end

end )

hook.Add( "DatabasePostPlayerDisconnect", "CleanUpSuite", function( ply )
	
	local room = ply:GetRoom()

	if room then
		room:Finish()
	end

end )

local fuckyou = CurTime()

hook.Add("Think", "CreateRoomEnts", function()

	if CurTime() > fuckyou then
		fuckyou = CurTime() + 2
		for k,v in pairs(player.GetAll()) do
			if ( IsValid(v) && v.GRoom ) then
				v:SetNet( "RoomEntityCount", v.GRoom:ActualEntCount() )
			end
		end
	end

	for k, v in ipairs( AddingEntsRooms ) do

		SafeCall( v.EntCreateThink, v )

	end

end )

hook.Add("PlayStream", "CheckInSuite", function( ply, stream, ent )

	local RoomId = PositionInRoom( ent:GetPos() )
	if RoomId then

		local Room = Get( RoomId )

		if Room:PlayRadio( ply, stream, ent ) then
			return false
		end

	end

end )
