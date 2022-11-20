module("CondoUpgrades", package.seeall )

if SERVER then
	util.AddNetworkString( "CondoUpgraded" )
	util.AddNetworkString( "CondoDoorStatus" )
end

StoreID = GTowerStore.CONDO

local doorNamePattern = "^autoinstance..%-suitedoor_(.+)"

List = {
	[0] = {
			name = "Closet",
			unique_name = "condo_closet",
			price = 5000,
			doors = { "closet" }
	},
	[1] = {
			name = "Outside",
			unique_name = "condo_outside",
			price = 50000,
			doors = { "pool", "pool2" }
	},
	[2] = {
			name = "Dim Room",
			unique_name = "condo_dimroom",
			price = 12500,
			doors = { "extraroom" }
	},
	[3] = {
			name = "Garden",
			unique_name = "condo_garden",
			price = 30000,
			doors = { "outside" }
	},
	[4] = {
			name = "Master Bedroom",
			unique_name = "condo_bedroom",
			price = 4000,
			doors = { "bedroom" }
	},
}

hook.Add( "GTowerStoreLoad", "AddCondoUpgrades", function()

	for _, v in pairs( List ) do
	
		if v.unique_name then

			//MsgN( "Adding ", v.unique_name )

			local NewItemId = GTowerStore:SQLInsert( {
				Name = v.name,
				description = "",
				unique_Name = v.unique_name,
				price = v.price,
				doors = v.doors,
				model = "",
				ClientSide = true,
				upgradable = true,
				storeid = CondoUpgrades.StoreID
			} )
			v.id = NewItemId
			
		end

	end

end )

function HasUpgrade( ply, unique_name )

	local id = GTowerStore:GetItemByName( unique_name )

	if SERVER and ply.GetLevel then
		return id and ply:GetLevel( id )
	else
		return id and GTowerStore:GetClientLevel( ply, id )
	end
	
end

function BuyUpgrade( ply, unique_name )

	if SERVER then return end

	local id = GTowerStore:GetItemByName( unique_name )
	RunConsoleCommand( "gmt_storebuy", id, 1 )

	-- Refresh door status
	timer.Simple(0.1, function()
		net.Start( "CondoUpgraded" )
		net.SendToServer()
	end)

end

function DoorStatus( door, locked )

	if CLIENT then return end

	door:Fire("Close",0,0)

	--MsgN( "Door status change: ", door, " ", locked )

	if locked then
		door:Fire("Lock",0,0)
	else
		door:Fire("Unlock",0,0)
	end

	door.Locked = locked

	net.Start( "CondoDoorStatus" )
		net.WriteEntity( door )
		net.WriteBool( locked )
	net.Broadcast()

end

function FindDoorBasedOnName( doors, doorname )

	for _, door in pairs( doors ) do
		local doorentname = string.match( string.lower( door:GetName() ), doorNamePattern )
		if doorentname == doorname then
			return door
		end
	end

end

function LoadRoomUpgrades( room, ply )

	local doors = {}

	-- Close and unlock all doors
	for _, ent in pairs( room:EntsInRoom() ) do

		if ent:GetClass() == "func_door" then
			DoorStatus( ent, false )
			table.insert( doors, ent )
		end

	end

	-- Lock doors that they don't have upgraded.
	for _, upgrade in pairs( List ) do

		if HasUpgrade( ply, upgrade.unique_name ) == 0 then

			-- For each upgrade managed door
			for _, doorname in pairs( upgrade.doors ) do

				-- Lock the doors as they don't have this upgrade
				local door = FindDoorBasedOnName( doors, doorname )
				if door then
					DoorStatus( door, true )
				end

			end

		end

	end

end

if CLIENT then
	net.Receive( "CondoDoorStatus", function( len, ply )

		local door = net.ReadEntity()
		local locked = net.ReadBool()

		if locked then
			door.CanUse = function( self, ply ) return false, "LOCKED, UPGRADE NOT UNLOCKED" end
		else
			door.CanUse = function( self, ply ) return true, "OPEN/CLOSE" end
		end

	end )
end

if SERVER then

	function UpdateUpgrades( ply, room )

		if not IsValid( ply ) then return end

		room = room or ply:GetRoom()
		if IsValid( room ) then
			LoadRoomUpgrades( room, ply )
		end

		GTowerStore:SendItemsOfStore( ply, StoreID )

	end

	function SendDoorStatuses( ply, room )

		for _, ent in pairs( room:EntsInRoom() ) do

			if ent:GetClass() == "func_door" then
				net.Start( "CondoDoorStatus" )
					net.WriteEntity( ent )
					net.WriteBool( ent.Locked )
				net.Send( ply )
			end

		end

	end

	net.Receive( "CondoUpgraded", function( len, ply )
		UpdateUpgrades( ply )
	end )

	hook.Add( "RoomLoaded", "UpdateRoomUpgrades", function( ply, Room )
		UpdateUpgrades( ply, Room )
	end )

	hook.Add( "Location", "UpdateDoorUpgrades", function( ply, loc )
		local condoid = Location.GetCondoID( loc )
		if condoid then
			local room = GtowerRooms.GetOwner( condoid ):GetRoom()
			if room then
				SendDoorStatuses( ply, room )
			end
		end
	end )

end