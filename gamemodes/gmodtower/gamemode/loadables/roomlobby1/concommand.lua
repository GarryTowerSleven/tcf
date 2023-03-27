module("GTowerRooms", package.seeall )

TimeToLeaveRoom = 6 * 60
TalkingTo = {}

util.AddNetworkString("gmt_lockcondo")
util.AddNetworkString("gmt_closevault")
util.AddNetworkString("GRoomParty")

net.Receive("gmt_closevault",function(len, ply)

	if Location.GetCondoID( Location.Find( ply:GetPos() ) ) then

	for k,v in pairs( ents.FindByClass("gmt_condo_vault") ) do
		if Location.Find( v:GetPos() ) == Location.Find( ply:GetPos() ) then
			v:CloseVault()
		end
	end

	end

end)

net.Receive("gmt_lockcondo",function(len, ply)
	
	if ply:GetNWBool("GRoomParty") then
		return
	end

	local room = net.ReadInt(16)
	local lock = net.ReadBool()
	//if lock then
	//	MsgC( co_color, "[Room] Locking Condo #" .. tostring(room) .. "\n")
	//else
	//	MsgC( co_color, "[Room] Unlocking Condo #" .. tostring(room) .. "\n")
	//end
	
	if !ply.GRoom then return end

	if ply:GetNet( "RoomID" ) != room then return end
	//MsgC( co_color, "[Room] Setting GRoomLock \n")
	ply:SetNet( "RoomLock", lock )

end)

local _LastRoomCheck = 0
hook.Add( "Think", "CheckPlayerOnRoom", function()
	if ( _LastRoomCheck > CurTime() ) then return end

	for _, room in ipairs( Rooms ) do
		if ( room:IsValid() ) then
			if ( room:OwnerInRoom() ) then
				room.LastActive = CurTime()
			elseif ( CurTime() - room.LastActive > TimeToLeaveRoom ) then
				umsg.Start("GRoom", room.Owner)
					umsg.Char( 5 )
					umsg.Char( TimeToLeaveRoom / 60 )
				umsg.End()
	
				room:Finish()
			end
		end
	end

	_LastRoomCheck = CurTime() + 1
end )


function OnlyInYourRoom( ply )

	umsg.Start("GRoom", ply)
    umsg.Char( 8 )
    umsg.End()

end

function NowAllowedSuite( ply )

	umsg.Start("GRoom", ply)
    umsg.Char( 12 )
    umsg.End()

end

function ShowRentWindow( ent, ply )

	if ClientSettings && ClientSettings:Get( ply, "GTAllowSuite" ) == false then
		NowAllowedSuite( ply )
		return
	end

	if ply._LastRoomExit && CurTime() - ply._LastRoomExit < 3 then
		return
	end

	TalkingTo[ ply ] = ent

	local Answer = -1

	//Does he have a room?
	if ply:GetRoom() != nil then
		Answer = -1

	else

		Answer = 0

		//Get how many rooms are avalible
		for k, v in pairs( Rooms ) do
			if v:CanRent() then
				Answer = Answer + 1
			end
		end

	end

	umsg.Start("GRoom", ply)
    umsg.Char( 2 )
    umsg.Char( Answer )
    umsg.End()

	if ply:GetNWInt("BAL") > 0 then
		ply:SetAchievement( ACHIEVEMENTS.SUITEPICKUPLINE, 1 )
	end

	ply:AddAchievement( ACHIEVEMENTS.SUITELADYAFF, 1 )

end

local Settings = {
	[1] = "Drinks",
	[2] = "Movies",
	[3] = "Music",
	[4] = "Games",
	[5] = "TV Shows",
	[6] = "Instruments",
}

function StartParty( ply, flags )
	if not IsValid(ply) then return end

	if !flags then return end

	//ply:Msg2( tostring( ply:GetNet( "RoomLock" ) ) )
	if ply:GetNet( "RoomLock" ) then
		ply:Msg2( "Please unlock your condo before throwing a party.", "condo" )
		return
	end

	if ply:GetNWBool("GRoomParty") then return end

	if !ply.NextParty then ply.NextParty = 0 end

	if CurTime() < ply.NextParty then
		ply:Msg2( T( "RoomPartyFailedDelay", tostring( 3 ) ), "condo" )
		return
	end

	if !ply:Afford( 250 ) then
		ply:Msg2( T( "RoomPartyFailedMoney" ), "condo" )
		return
	end

	local flags = string.Explode( ",", flags )

	local amount = 0

	local invString = T( "RoomPartyMainMessage", ply:Name(), tostring(ply:GetNet( "RoomID" )) )

	local flagString = ""

	for k,v in pairs(flags) do
		v = string.Trim( v )
		if !v || v == "" || v == " " then continue end

		local thing = string.lower( Settings[tonumber(v)] ) or "stuff"

		if ( k == 1 ) then
			flagString = thing
		elseif ( #flags > 1 && k == #flags ) then
			flagString = flagString .. ", and " .. thing
		else
			flagString = flagString .. ", " .. thing
		end
	end

	invString = invString .. " " .. T( "RoomPartyActivityMessage", flagString )

	local roomid = ply:GetNet( "RoomID" )

	if roomid == 0 then return end

	ply:AddMoney(-250)

	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	SQLLog( 'condo', ply:Name() .. " paid and started a Condo Party. (" .. TimeString .. ")" )

	ply:SetNWBool( "GRoomParty", true )

	ply.NextParty = CurTime() + (60*3)

	timer.Simple( 60*2, function()
		if IsValid(ply) && ply:GetNWBool( "GRoomParty" ) then
			ply:SetNWBool( "GRoomParty", false )
			ply:Msg2( T( "RoomPartyEnded" ), "condo" )
		end
	end)

	net.Start("GRoomParty")
		net.WriteString(invString)
		net.WriteInt(roomid, 6)
	net.Broadcast()

end

concommand.Add("gmt_startroomparty", function( ply, cmd, args )
	StartParty( ply, args[1] )
end)

concommand.Add("gmt_endroomparty", function( ply, cmd, args )
	ply:SetNWBool("GRoomParty",false)
	ply:Msg2( T( "RoomPartyEnd" ) )
end)

concommand.Add("gmt_joinparty", function(ply, cmd, args)
	if !args[1] then return end
	if args[1] == 0 then return end

	local room = Get( args[1] )

	if ( room ) then
		local owner = room.Owner
		if ( !owner or !owner:IsValid() ) then return end
		if ( !owner:GetNWBool("GRoomParty") ) then return end

		room:SendToDoor( ply )
	end

end)

local ValidExplodeRockets = {}

local function MakeRocketDoDamage( ent )

	if ent:GetClass() != "rpg_missile" then
		return
	end

	for k, v in ipairs( ValidExplodeRockets ) do

		if !IsValid( v ) then
			table.remove( ValidExplodeRockets, k )

		elseif ent == v then

			table.remove( ValidExplodeRockets, k )

			util.BlastDamage( ent, ent.EntityOwner, ent:GetPos(), ent.Damage * 2, ent.Damage )

		end

	end

	if #ValidExplodeRockets == 0 then
		hook.Remove("EntityRemoved", "ExplodeRocket" )
	end

end

concommand.Add( "gmt_buybankslots", function( ply, cmd, args )
	local amount = tonumber( args[1] ) or 0
	if amount > 0 then
		local cost = (amount * GTowerItems.BankSlotWorth)

		if ( not ply:Afford( cost ) ) then
			return
		end

		if (ply:BankLimit() + amount) > GTowerItems.MaxBankCount then
			if (GTowerItems.MaxBankCount - ply:BankLimit()) > 0 then
				local newAmount = (GTowerItems.MaxBankCount - ply:BankLimit())
				ply:SetMaxBank( ply:BankLimit() + amount )
				ply:AddMoney( -cost )
				ply:Msg2("You've paid for " .. newAmount .. " slots instead of " .. Amount .. " due to reaching the max amount of Trunk slots.")
			else
				ply:Msg2("You've reached the max amount of Trunk slots.")
			end
		else
			ply:SetMaxBank( ply:BankLimit() + amount )
			ply:AddMoney( -cost )
		end
	end
end )

concommand.Add( "gmt_dieroom", function( ply, cmd, args )

	if !IsValid( TalkingTo[ ply ] ) then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 7, cmd, args )
		end
		return
	end

	if ply.NextDieRoom && CurTime() < ply.NextDieRoom then
		return
	end
	ply.NextDieRoom = CurTime() + 5

	if !TalkingTo[ ply ]:GetPos():WithinDistance( ply:GetPos(), NPCMaxTalkDistance ) then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 8, cmd, args )
		end
		return
	end

	local Room = ply:GetRoom()

	if Room then
		Room:Finish()
		if IsValid(ply) && ply:GetNWBool("GRoomParty") then
			ply:SetNWBool("GRoomParty", false)
			ply:Msg2( T( "RoomPartyEnded" ), "condo" )
		end
	end


end )

concommand.Add( "gmt_acceptroom", function( ply, cmd, args )

	if !IsValid( TalkingTo[ ply ] ) then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 7, cmd, args )
		end
		return
	end

	if TalkingTo[ ply ]:GetPos():Distance( ply:GetPos() ) > NPCMaxTalkDistance then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 8, cmd, args )
		end
		return
	end

	if ply.NextNewRoom && CurTime() < ply.NextNewRoom then
		return
	end
	ply.NextNewRoom = CurTime() + 5

	//Already have a room?
	if ply:GetRoom() then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 10, cmd, args )
		end
		return
	end

	//Get all unused rooms
	local UnusedRooms = {}
	for k, v in pairs( Rooms ) do
		if v:CanRent() then
			table.insert(UnusedRooms, v )
		end
	end

	//If there are no rooms avalible
	if #UnusedRooms < 1 then
		umsg.Start("GRoom", ply)
		    umsg.Char( 3 )
		umsg.End()
		return
	end

	//Make random numbers a little less predictable
	math.randomseed( CurTime() )

	//Select a random one
	local PlyRoom = UnusedRooms[ math.random( 1, #UnusedRooms ) ]

	if !tmysql then
		PlyRoom:Load( ply )

		umsg.Start("GRoom", ply)
		umsg.Char( 4 )
		umsg.Char( PlyRoom.Id )
		umsg.End()
		return
	end

	SQL.getDB():Query("SELECT HEX(roomdata) as roomdata FROM `gm_users` WHERE steamid='"..ply:SteamID().."'", function(res)

			if !res or res == nil then return end
			local row = res[1].data[1]
			if row then
					local roomdata = row.roomdata
					Suite.SQLLoadData( ply, roomdata )
					PlyRoom:Load( ply )

					umsg.Start("GRoom", ply)
					umsg.Char( 4 )
					umsg.Char( PlyRoom.Id )
					umsg.End()

					ply:SetNet( "RoomEntityCount", PlyRoom:ActualEntCount() )

			end

	end)

	ply:SetNWInt( "RoomID", PlyRoom.Id )

	local panel = GTowerRooms.GetPanel( PlyRoom.Id )
	if panel then
		panel:SetText( ply:GetInfo( "gmt_suitename" ) or "" )
	end

	AdminNotif.SendStaff( ply:NickID() .. " has checked into suite #" .. PlyRoom.Id .. ".", nil, nil, 3 )

	//Congratilaions!
end )


hook.Add("ClientSetting", "GTCheckSuite", function( ply, id, val )

	if ClientSettings:GetName( id ) == "GTAllowSuite" then
		TalkingTo[ ply ] = nil

		local Room = ply:GetRoom()

		if val == false && Room  then
			Room:Finish()
			if IsValid(ply) && ply:GetNWBool("GRoomParty") then
				ply:SetNWBool("GRoomParty", false)
				ply:Msg2( T( "RoomPartyEnded" ), "condo" )
			end
		end

	end

end )

concommand.Add( "gmt_resetroom", function(ply)

	local room = ply.GRoom
	if !room then return end

	for _, v in pairs ( room:EntsInRoom() ) do

		if GTowerItems:FindByEntity( v ) then

		local ItemId = GTowerItems:FindByEntity( v )
		if !ItemId then
			MsgC( co_color2, ply:Name().." is resetting their condo, but the following entity failed to remove: "..tostring(v) )
		end

		local Item = GTowerItems:CreateById( ItemId, ply )
		local Slot = GTowerItems:NewItemSlot( ply, "-2" ) //In the bank!

		ply:SetMaxBank( ply:BankLimit() + 1 )

		Slot:FindUnusedSlot( Item, true )

		if !Slot:IsValid() then
			return
		end

		Slot:Set( Item )
		Slot:ItemChanged()

		v:Remove()

		end

	end

	ply:Msg2("Your items have been moved to your trunk.")

end)

concommand.Add("gmt_roomkick", function( ply, cmd, args )

	if ply._NextCommand && ply._NextCommand > CurTime() then
		return
	end
	
	ply._NextCommand = CurTime() + 0.25

	local target = nil 

	if ( args[1] ) then
		target = ents.GetByIndex( tonumber( args[1] ) ) or nil
	end

	if ply:GetNWBool("GRoomParty") then
		ply:Msg2( T( "RoomPartyLock" ), "condo" )
		return 
	end

	local Room = ply:GetRoom()

	if Room then
		local players = {}

		if ( target ) then
			if ( Room:PlayerInRoom( target ) ) then
				players = { target }
			end	
		else
			players = Room:GetPlayers()
		end

		for _, guest in pairs( players ) do
			if ( ply == guest or guest:IsStaff() ) then return end

			Suite.RemovePlayer( guest )
			guest:Msg2( T("RoomKickedFrom", ply:Name() ) )

			if ( target ) then
				ply:Msg2( T( "RoomKickedPlayer", guest:GetName() ) )
			end

			Room.Owner:AddAchievement( ACHIEVEMENTS.SUITELEAVEMEALONE, 1 )
		end

	end

end )

concommand.Add("gmt_roomban", function( ply, cmd, args )
	if ply._NextCommand && ply._NextCommand > CurTime() then
		return
	end
	ply._NextCommand = CurTime() + 0.25

	if ( !args or #args < 1 ) then return end
	local target = ents.GetByIndex( tonumber( args[1] ) ) or nil
	if ( !target or !IsValid( target ) ) then return end

	local Room = ply:GetRoom()

	if Room then
		Room:BanPlayer( target )
	end
end )

concommand.Add("gmt_roomclearbans", function( ply, cmd, args )
	if ply._NextCommand && ply._NextCommand > CurTime() then
		return
	end
	ply._NextCommand = CurTime() + 0.25

	local Room = ply:GetRoom()

	if Room then
		Room:UnBanAll()
	end
end )

concommand.Add("gmt_roomdebugpos", function( ply, cmd, args )

	local Room = ply:GetLocationRoom()

	if Room then

		print( Room.RefEnt:WorldToLocal( ply:GetPos() ) )
		print( Room.RefEnt:WorldToLocalAngles( ply:GetAngles() ) )

	end

end )