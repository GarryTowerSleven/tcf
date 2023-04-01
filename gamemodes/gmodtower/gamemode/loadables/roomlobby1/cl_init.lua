---------------------------------
GTowerRooms = {}
GTowerRooms.Rooms = {}


local QueryPanel = nil

include("shared.lua")
include("room_maps.lua")
//include("cl_closet.lua")
include("cl_party.lua")

usermessage.Hook("GRoom", function(um)

    local id = um:ReadChar()

    if id == 0 then
        GTowerRooms:LoadRooms( um )
    elseif id == 1 then
		GTowerRooms:RemoveOwner( um )
	elseif id == 2 then
		GTowerRooms:ShowRentWindow( um )
	elseif id == 3 then
		/*local menu = {
			{
				title = "Information",
				icon = "about",
				func = function() MsgN( "wow!" ) end,
			},
		}

		SelectionMenuManager.Create( "towercondos", menu, "Sorry, no condos available." )*/
	elseif id == 4 then
		GTowerRooms:ShowNewRoom( um )
	elseif id == 5 then
		local Minutes = um:ReadChar()

		GTowerMessages:AddNewItem( T("RoomLongAway", Minutes) )
	//elseif id == 6 then
	//	local itemid = um:ReadChar()
	//
	//	GTowerMessages:AddNewItem( GetTranslation("RoomNotEnoughMoney", GTowerRooms.RoomUps[ itemid ].name ) )
	//elseif id == 7 then
	//	local itemid = um:ReadChar()
	//	local level = um:ReadChar()
	//
	//	GTowerRooms:AskNewRoom( itemid, level )
	elseif id == 8 then
		GTowerMessages:AddNewItem( T("RoomInventoryOwnRoom") )
	//elseif id == 9 then
	//	GTowerRooms:RecieveRefEnts( um )
	elseif id == 10 then
		GTowerMessages:AddNewItem( T("RoomNotOwner") )
	elseif id == 11 then
		GTowerMessages:AddNewItem( T("RoomCheckedOut"), nil, nil, "condo" )
	elseif id == 12 then
		GTowerMessages:AddNewItem( T("RoomAdminDisabled"), nil, nil, "condo" )
	elseif id == 13 then
		local Maximun = um:ReadChar() + 120
		GTowerMessages:AddNewItem( T("RoomMaxEnts", Maximun ), nil, nil, "condo" )
	elseif id == 14 then
		GTowerRooms:GetEntIndexs( um )
	elseif id == 15 then
		GTowerMessages:AddNewItem( T("RoomAdminRemoved"), nil, nil, "condo" )
	else
		MsgC( co_color2 ,"[Room] Recieved Room of unknown ID: " .. tostring(id) .. "\n")
	end

end )

hook.Add("GTowerScorePlayer", "AddRoomNumber", function()

	GtowerScoreBoard.Players:Add(
		"Room #",
		5,
		75,
		function(ply)
			return (ply:GetNet( "RoomID" ) && ply:GetNet( "RoomID" ) > 0 && tostring(ply:GetNet( "RoomID" ))) or " - "
		end,
		99
	)

end )

hook.Add("GTowerAdminPly", "AddSuiteRemove", function( ply )

	local PlyId = ply:EntIndex()

	if ply:GetNet( "RoomID" ) then
		return {
			["Name"] = "Remove Room",
			["function"] = function() RunConsoleCommand("gt_act", "remroom", PlyId ) end
		}
	end

end )

function GTowerRooms:CanManagePanel( room, ply )
  local owner = GTowerRooms:RoomOwner( room )
  return (owner == ply)
end

function GTowerRooms:Get( id )
	if !self.Rooms || !id then return end

	if !self.Rooms[ id ] then
		self.Rooms[ id ] = {}
	end

	return self.Rooms[ id ]
end

function GTowerRooms:ShowNewRoom( um )
	local RoomId = um:ReadChar()

	GTowerNPCChat:StartChat( {
		Text = T("RoomGet", RoomId )
	})

	Msg2( T( "RoomGetSmall", RoomId ) )
end


function GTowerRooms:ChatTrunkUpgradeSlot( num )
	local cost = num * GTowerItems.BankSlotWorth

	if ( not Afford( cost ) ) then
		return {
			Response = num .. " Slot " .. "(" .. string.FormatNumber( cost ) .. " GMC)",
			Func = EmptyFunction,
			Text = "Sorry, you don't have enough GMC to buy this upgrade."
		}
	end

	return {
			Response = num .. " Slot " .. "(" .. string.FormatNumber( cost ) .. " GMC)",
			Func = function() RunConsoleCommand( "gmt_buybankslots", num ) end,
			Text = "Thanks. I've put in an order for " .. num .. " extra slot(s) for your trunk."
	}
end

function GTowerRooms:ChatTrunkUpgrade()
	return {
		Response = "Buy Trunk Slots",
		Text = "You need more space for your trunk? Sure thing!\n"..
				"The current rate of trunk slots is " .. string.FormatNumber( 1 * GTowerItems.BankSlotWorth ) .. " GMC per extra slot.\n"..
				"How many slots do you want to buy?",
		Responses = {
			{
				Response = T("cancel"),
				Text = "Alright. Let me know if I can help with anything else."
			},
			self:ChatTrunkUpgradeSlot( 1 ),
			self:ChatTrunkUpgradeSlot( 2 ),
			self:ChatTrunkUpgradeSlot( 10 ),
		}
	}
end

function GTowerRooms:ShowRentWindow( um )
	local Answer = um:ReadChar()

	if Answer == -2 then

		GTowerNPCChat:StartChat({
			Entity = GTowerRooms.NPCClassname,
			Text = T("I am sorry, the server is having some issues with the enties at the moment. \n Come back later."),
		})

	elseif Answer == -1 then
		GTowerNPCChat:StartChat({
			Entity = GTowerRooms.NPCClassname,
			Text = "Hello " .. LocalPlayer():GetName() .. ", \nWhat can I do for you?",
			Responses = {
				{
					Response = T("checkout"),
					Text = T("RoomReturnYes"),
					Func = function() RunConsoleCommand("gmt_dieroom") end
				},
				{
					Response = T("cleanup"),
					Text = T("RoomCleanUp"),
					Responses ={
						{
							Response = T("no"),
						},
						{
							Response = T("yes"),
							Text = T("RoomCleanUpConfirm"),
							Responses = {
								{
									Response = T("no"),
								},
								{
									Response = T("yes"),
									Func = function() RunConsoleCommand("gmt_resetroom") end,
									Text = T("RoomCleanedUp")
								}
							}
						},
						
					},
				},
				self:ChatTrunkUpgrade(),
				{
					Response = T("cancel"),
					Text = T("RoomReturnNo")
				},
			}
		})
	elseif Answer == 0 then

		GTowerNPCChat:StartChat({
			Entity = GTowerRooms.NPCClassname,
			Text = T("RoomNotAvalible", LocalPlayer():GetName() ),
			Responses = {
				self:ChatTrunkUpgrade(),
				{
					Response = T("cancel"),
					Text = T("RoomDeny"),
				},
			}
		})

	else

		GTowerNPCChat:StartChat({
			Entity = GTowerRooms.NPCClassname,
			Text = T( "RoomRoomsAvalible", LocalPlayer():GetName(), Answer ),
			Responses = {
				{
					Response = T("yes"),
					//Text = GetTranslation("RoomGet"),
					Text = T("RoomWait"),
					Func = function() RunConsoleCommand("gmt_acceptroom") end
				},
				self:ChatTrunkUpgrade(),
				{
					Response = T("no"),
					Text = T("RoomDeny")
				},
			}
		})

	end
end

function GTowerRooms:RemoveOwner( um )

	local RoomId = um:ReadChar()
	local Room = self:Get( RoomId )

	Room.Owner = nil

end

function GTowerRooms.ReceiveOwner( ply, roomid )

	local Room = GTowerRooms:Get( roomid )

	if Room then
		Room.HasOwner = true
		Room.Owner = ply
	end

end

RoomsHats = {}

function GTowerRooms:LoadRooms( um )

	local Count = um:ReadChar()

	for i=1, Count do

		local RoomId = um:ReadChar()
		local ValidOwner = um:ReadBool()

		local Room =  self:Get( RoomId )

		Room.Hats = {}

		if ValidOwner then
			Room.HasOwner = true

			/*if GtowerHats.Hats then
				Room.Hats[ 0 ] = true

				for k, hat in ipairs( GtowerHats.Hats ) do
					if hat.unique_name then
						Room.Hats[ k ] = um:ReadBool()
					end
				end
			end*/

		else

			Room.Owner = nil
			Room.HasOwner = false

		end
		RoomsHats[RoomId] = Room.Hats


	end

end

function GTowerRooms:GetEntIndexs( um )

	local Count = um:ReadChar()

	for i=1, Count do
		local Room = self:Get( i )

		Room.EntId = um:ReadShort()
	end

	 GTowerRooms:FindRefEnts()
end

function GTowerRooms:FindRefEnts()

	local MapData = GTowerRooms.RoomMapData[ game.GetMap() ]

	if !MapData then
		MsgC( co_color2, "[Room] Map data not found.\n")
		return
	end

	for _, v in pairs( ents.FindByClass( MapData.refobj ) ) do
		local EntIndex = v:EntIndex()

		for _, Room in pairs( GTowerRooms.Rooms ) do
			if Room.EntId == EntIndex then
				Room.RefEnt = v
				Room.StartPos = v:LocalToWorld( MapData.min )
				Room.EndPos = v:LocalToWorld( MapData.max )

				OrderVectors( Room.EndPos, Room.StartPos )
			end
		end

	end

end

function GTowerRooms:RoomOwner( RoomId )
	if !RoomId then return end
    return self:Get( RoomId ).Owner
end

function GTowerRooms:RoomOwnerName( RoomId )
    local Room = self:Get( RoomId )

    if IsValid( Room.Owner ) && Room.Owner:IsPlayer() then
        return Room.Owner:Name()
    elseif Room.HasOwner then
		return T("RadioLoading")
    else
		return T("vacant") .. string.rep( ".", CurTime() * 3 % 4 )
    end

end

function GTowerRooms:AdminRoomDebug()
	local tbl =  GTowerRooms.RoomMapData[ CurMap ]

	if tbl then
		local EntList = ents.FindByClass( tbl.refobj )
		OrderVectors( tbl.min, tbl.max )

		for _, v in pairs( EntList ) do
			// DEBUG:Box( v:LocalToWorld( tbl.min ), v:LocalToWorld( tbl.max ) )
		end
	end
end

hook.Add( "OpenSideMenu", "OpenSuiteControls", function()

	local ply = LocalPlayer()
	local RoomId = ply:GetNet( "RoomID" )
	
	if RoomId && Location.GetByCondoID(RoomId) == LocalPlayer():Location() then
		
		local Form = vgui.Create("DForm")
		Form:SetName( "Suite Controls: #" .. RoomId )

		Form:AddItem( vgui.Create("SuiteEntCount", Form) )

		local Manage = Form:Button(T("RoomManagePlayers"))
		Manage.DoClick = function()
			Derma_PlayerSuiteRequest( 
				"Suite Guest Management",
				"Select the players you want to kick from your suite",
				function( players ) // Kick

					for _, ply2 in pairs( players ) do
						if IsValid( ply2 ) then
							RunConsoleCommand( "gmt_roomkick", ply2:EntIndex() )
						end
					end

				end, // Ban
				function( players )

					for _, ply2 in pairs( players ) do
						if IsValid( ply2 ) then
							RunConsoleCommand( "gmt_roomban", ply2:EntIndex() )
						end
					end

				end,
				nil,
				function()
					RunConsoleCommand( "gmt_roomclearbans" )
				end,
				"KICK",
				"BAN",
				"CANCEL"
			)
		end

		local Kick = Form:Button(T("RoomKickPlayers"))
		Kick.DoClick = function() RunConsoleCommand("gmt_roomkick") end

		local SuiteName = Form:Button( "Set Suite Name" )
		SuiteName.DoClick = function()
			local curText = LocalPlayer():GetInfo( "gmt_suitename" ) or ""
			Derma_StringRequest(
				"Set Suite Name",
				"Setting a name on your suite offers a good way to express yourself.\nThe Name will appear above your door.\nSet to blank to remove.\nAbusive names will get you banned.",
				curText,
				function ( text ) RunConsoleCommand( "gmt_suitename", text ) end
			)
		end

		if LocalPlayer():GetNWBool("GRoomParty") then

			local SuiteParty = Form:Button( "End Party" )
			SuiteParty.DoClick = function()
				RunConsoleCommand( "gmt_roompartyend" )
			end

		else

			local SuiteParty = Form:Button( "Start Party" )
			SuiteParty.DoClick = function()
				RunConsoleCommand( "gmt_roomparty" )
			end

		end
		
		return Form
		
	end

end )

hook.Add("FindStream", "StreamInSuite", function( ent )

	local RoomId = GTowerRooms.PositionInRoom( ent:GetPos() )

	if RoomId then

		for _, Stream in pairs( BassStream.List ) do
			local StreamEnt = Stream:GetEntity()

			if IsValid( StreamEnt ) && GTowerRooms.PositionInRoom( StreamEnt:GetPos() ) == RoomId then
				return Stream
			end

		end

	end


end )


local PANEL = {}

function PANEL:PerformLayout()
	local RoomId = LocalPlayer():GetNet( "RoomID" )
	if ( RoomId && RoomId != 0 ) then
		local Count = LocalPlayer():GetNet( "RoomEntityCount" )

		self:SetText( "Suite count: " .. tostring(Count) .. "/" .. tostring(LocalPlayer():GetSetting("GTSuiteEntityLimit")) )
		self:SizeToContents()
	end
end

vgui.Register("SuiteEntCount", PANEL, "DLabel")

hook.Add( "PlayerBindPress", "SuiteDoorAccess", function( ply, bind, pressed )

	if bind == "+use" && pressed then
		
		if !ply._LastDoorUse || CurTime() > ply._LastDoorUse then

			// Don't do this if they're on a panel
			if !ply.IsOnPanel then

				// Find a suite door
				for _, ent in pairs( ents.FindByClass( "func_door_rotating" ) ) do

					if ent:GetPos():Distance( ply:GetShootPos() ) < 100 then
						RunConsoleCommand( "gmt_useroomdoor", ent:EntIndex() )
					end

				end

			end

			ply._LastDoorUse = CurTime() + .5
		end

	end

end )

// suite names
CreateClientConVar( "gmt_suitename", "", true, true )

cvars.AddChangeCallback( "gmt_suitename", function( cmd, old, new )
	net.Start( "SendSuiteName" )
		net.WriteString( new )
	net.SendToServer()
end )