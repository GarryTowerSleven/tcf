---------------------------------
module("GtowerRooms", package.seeall )

TimeToLeaveRoom = 6 * 60
TalkingTo = {}

util.AddNetworkString("gmt_lockcondo")
util.AddNetworkString("gmt_closevault")
util.AddNetworkString("gmt_partymessage")

util.AddNetworkString("RequestRoomBans")
util.AddNetworkString("NetworkScores")

net.Receive("gmt_closevault",function(len, ply)

	if ply:Location().CondoID then

	for k,v in pairs( ents.FindByClass("gmt_condo_vault") ) do
		if ply.Location == Location.Find( v:GetPos() ) then
			v:CloseVault()
		end
	end

	end

end)

net.Receive("gmt_lockcondo",function(len, ply)
	
	if ply:GetNWBool("Party") then
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

	if ply.GRoomId != room then return end
	//MsgC( co_color, "[Room] Setting GRoomLock \n")
	ply.GRoomLock = lock

end)

timer.Create( "CheckPlayerOnRoom", 1.0, 0, function()

	for k, Room in pairs( Rooms ) do

		if Room:IsValid() then

			if Room:OwnerInRoom() then
				Room.LastActive = CurTime()

			elseif CurTime() - Room.LastActive > TimeToLeaveRoom then

				umsg.Start("GRoom", Room.Owner)
			    umsg.Char( 5 )
			    umsg.Char( TimeToLeaveRoom / 60 )
			    umsg.End()

				Room:Finish()
			end

		end

	end

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

	if ply.BAL > 0 then
		ply:SetAchivement( ACHIVEMENTS.SUITEPICKUPLINE, 1 )
	end

	ply:AddAchivement( ACHIVEMENTS.SUITELADYAFF, 1 )

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

	print( flags )

	//ply:Msg2( tostring( ply.GRoomLock ) )
	if ply.GRoomLock then
		ply:Msg2( "Please unlock your condo before throwing a party.", "condo" )
		return
	end

	if ply:GetNWBool("Party") then return end

	if !ply.NextParty then ply.NextParty = 0 end

	if CurTime() < ply.NextParty then
		ply:Msg2( T( "RoomPartyFailedDelay", tostring( 1 ) ), "condo" )
		return
	end

	local flags = string.Explode( ",", flags )

	local amount = 0

	local invString = T( "RoomPartyMainMessage", ply:Nick(), tostring(ply.GRoomId) )

	local flagString = ""

	for k,v in pairs(flags) do
		if !v then continue end
		if k == #flags then
			flagString = flagString .. "and " .. Settings[tonumber(v)]
		elseif #flags > 1 then
			flagString = flagString .. Settings[tonumber(v)] .. ", "
		else
			flagString = flagString .. Settings[tonumber(v)]
		end
	end

	invString = invString .. " " .. T( "RoomPartyActivityMessage", flagString ) .. " Join?"

	local roomid = ply.GRoomId

	if roomid == 0 then return end

	if !ply:Afford( 250 ) then
		ply:Msg2( T( "RoomPartyFailedMoney" ), "condo" )
		return
	end

	ply:AddMoney(-250)

	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	SQLLog( 'condo', ply:Name() .. " paid and started a Condo Party. (" .. TimeString .. ")" )

	ply:SetNWBool("Party",true)

	ply.NextParty = CurTime() + (60*3)

	timer.Simple( 60*2, function()
		if IsValid(ply) && ply:GetNWBool("Party") then
			ply:SetNWBool("Party",false)
			ply:Msg2( T( "RoomPartyEnded" ), "condo" )
		end
	end)

	net.Start("gmt_partymessage")
		net.WriteString(invString)
		net.WriteString(tostring(roomid))
	net.Broadcast()

end

concommand.Add("gmt_startroomparty", function( ply, cmd, args )
	StartParty(ply,args[1])
end)

concommand.Add("gmt_endroomparty", function( ply, cmd, args )
	ply:SetNWBool("Party",false)
	ply:Msg2( T( "RoomPartyEnd" ) )
end)

concommand.Add("gmt_joinparty", function(ply, cmd, args)
	if !args[1] then return end

	if args[1] == 0 then return end

	for k,v in pairs(ents.FindByClass('gmt_condo_door')) do
		if v:GetCondoID() == tonumber(args[1]) then
			ply.DesiredPosition = ( v:GetPos() + v:GetForward() * 60 )
			ply:SetEyeAngles( -v:GetAngles() )
		end
	end

end)

concommand.Add("gmt_roomkick", function( ply, cmd, args )

	if ply._NextCommand && ply._NextCommand > CurTime() then
		return
	end
	ply._NextCommand = CurTime() + 0.25

	local Specific = false

	if #args > 0 then
		if IsValid(ents.GetByIndex(args[1])) then
			Specific = true
		end
	end

	//if ply:GetNWBool("Party") then
	//	ply:Msg2( T( "RoomPartyLock" ), "condo" )
	//	return 
	//end

	local Room = ply:GetRoom()

	if Room then

		local Players = Room:GetPlayers()

		for _, ply in pairs( Players ) do

			if Specific && ply == ents.GetByIndex(args[1]) && !ply:IsAdmin() then
				Suite.RemovePlayer( ply )
				Room.Owner:AddAchivement( ACHIVEMENTS.SUITELEAVEMEALONE, 1 )
				continue
			end

			if ply != Room.Owner && !IsFriendsWith( Room.Owner, ply ) && !ply:IsAdmin() then
				Suite.RemovePlayer( ply )
				Room.Owner:AddAchivement( ACHIVEMENTS.SUITELEAVEMEALONE, 1 )
			end
		end

	end

end )

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
	local amount = args[1]
	if !amount then return end
	amount = tonumber(amount)
	if amount > 0 then

		if (ply.GtowerBankMax + amount) > GTowerItems.MaxBankCount then

			if (GTowerItems.MaxBankCount - ply.GtowerBankMax) > 0 then
				local newAmount = (GTowerItems.MaxBankCount - ply.GtowerBankMax)
				ply:SetMaxBank( ply.GtowerBankMax + amount )
				ply:AddMoney( -(amount * GTowerItems.BankSlotWorth) )
				ply:Msg2("You've paid for " .. newAmount .. " slots instead of " .. Amount .. " due to reaching the max amount of Vault slots.")
			else
				ply:Msg2("You've reached the max amount of Vault slots.")
			end

		else
			ply:SetMaxBank( ply.GtowerBankMax + amount )
			ply:AddMoney( -(amount * GTowerItems.BankSlotWorth) )
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

					ply.GRoomEntityCount = PlyRoom:ActualEntCount()

			end

	end)

	//Congratilaions!


end )


hook.Add("ClientSetting", "GTCheckSuite", function( ply, id, val )

	if ClientSettings:GetName( id ) == "GTAllowSuite" then
		TalkingTo[ ply ] = nil

		local Room = ply:GetRoom()

		if val == false && Room  then
			Room:Finish()
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

	ply:Msg2("Your items have been moved to your vault.")

end)

net.Receive("RequestRoomBans", function( len, ply )
	if ply.RoomBans then
		net.Start( "NetworkScores" )
			net.WriteEntity( ply )
			net.WriteTable( ply.RoomBans )
		net.Send( ply )
	end
end )

concommand.Add("gmt_roomban", function( ply, cmd, args )
	local index = args[1]
	if !index then return end
	local ent = ents.GetByIndex(index)
	if !IsValid(ent) or !ent:IsPlayer() then return end

	// Kick the guy
	ply:SendLua([[RunConsoleCommand("gmt_roomkick","]] .. tostring(index) .. [[")]])

	if !ply.RoomBans then ply.RoomBans = {} end

	table.insert( ply.RoomBans, ent )

end )

concommand.Add("gmt_roomdebugpos", function( ply, cmd, args )

	local Room = ply:GetLocationRoom()

	if Room then

		print( Room.RefEnt:WorldToLocal( ply:GetPos() ) )
		print( Room.RefEnt:WorldToLocalAngles( ply:GetAngles() ) )

	end

end )
