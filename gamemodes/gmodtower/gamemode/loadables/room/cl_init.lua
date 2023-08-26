---------------------------------
GTowerRooms = {}
GTowerRooms.Rooms = {}


local QueryPanel = nil

include("shared.lua")
include("room_maps.lua")
//include("upgrades.lua")

NoPartyMsg = CreateClientConVar( "gmt_ignore_party", "0", true, false )

CondoSkyBox 	= CreateClientConVar( "gmt_condoskybox" , "1", true, true )
CondoDoorbell 	= CreateClientConVar( "gmt_condodoorbell" , "1", true, true )
CondoBackground = CreateClientConVar( "gmt_condobg" , "1", true, true )
CondoBlinds 	= CreateClientConVar( "gmt_condoblinds" , "1", true, true )

cvars.AddChangeCallback( "gmt_condodoorbell", function(cmd, old, new)
	RunConsoleCommand( "gmt_setdoorbell", new )
end )

net.Receive("gmt_partymessage", function()
	if NoPartyMsg:GetBool() then return end
	if Dueling.IsDueling( LocalPlayer() ) then return end

	local invString = net.ReadString()
	local roomid = net.ReadString()

	local Question = Msg2( invString, 30 )
	Question:SetupQuestion(
	function() RunConsoleCommand( "gmt_joinparty", roomid ) end,
	function() end,
	function() end,
	nil,
	{120, 160, 120},
	{160, 120, 120})
end)

usermessage.Hook("GRoom", function(um)

    local id = um:ReadChar()

    if id == 0 then
        GTowerRooms:LoadRooms( um )
    elseif id == 1 then
		GTowerRooms:RemoveOwner( um )
	elseif id == 2 then
		GTowerRooms:ShowRentWindow( um )
	elseif id == 3 then
		local menu = {
			{
				title = "Information",
				icon = "about",
				func = function() MsgN( "wow!" ) end,
			},
		}

		SelectionMenuManager.Create( "towercondos", menu, "Sorry, no condos available." )
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
		MsgC( color_red ,"[Room] Recieved Room of unknown ID: " .. tostring(id) .. "\n")
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
			["function"] = function() RunConsoleCommand("gmt_act", "remroom", PlyId ) end
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

	/*GtowerNPCChat:StartChat( {
		Text = T("RoomGet", RoomId )
	})*/

	GTowerMessages:AddNewItem( T( "RoomGetSmall", RoomId ), nil, nil, "condo" )
end


local function TrunkSlot( num )

	local plural = num > 1
	local title = "Buy " .. num .. " Vault Slot"
	if plural then plural = "s" else plural = "" end

	local cost = num * GTowerItems.BankSlotWorth

	return {
		title = title .. plural,
		desc = "",
		icon = "safe",
		func = function()
			SelectionMenuManager.CreateConfirmation( "Purchase " .. num .. " vault slot" .. plural .. " for " .. string.FormatNumber(cost) .. " GMC",
				function()
					RunConsoleCommand( "gmt_buybankslots", num )
					SelectionMenuManager.Remove()
				end
			)
		end,
		cost = cost,
		ogPrice = cost,
	}
end

function GTowerRooms:TrunkUpgrade()

	local menu = {
		TrunkSlot( 1 ),
		TrunkSlot( 2 ),
		TrunkSlot( 5 ),
		TrunkSlot( 10 ),
	}

	SelectionMenuManager.SetMenu( menu, true )

end

function GTowerRooms:ShowRentWindow( um )
	local Answer = um:ReadChar()

	if Answer == -2 then

		GtowerNPCChat:StartChat({
			Entity = GTowerRooms.NPCClassname,
			Text = T("I am sorry, the server is having some issues with the enties at the moment. \n Come back later."),
		})

	elseif Answer == -1 then
		/* GtowerNPCChat:StartChat({
			Entity = GTowerRooms.NPCClassname,
			Text = T("RoomReturn", LocalPlayer():GetName() ),
			Responses = {
				{
					Response = T("yes"),
					Text = T("RoomReturnYes"),
					Func = function() RunConsoleCommand("gmt_dieroom") end
				},
				{
					Response = T("no"),
					Text = T("RoomReturnNo")
				},
			}
		}) */

		local menu = {
			{
				title = T("checkout"),
				large = true,
				icon = "condo",
				func = function()
					RunConsoleCommand("gmt_dieroom")
					GTowerMessages:AddNewItem( T("RoomReturnYes"), nil, nil, "condo" )
					SelectionMenuManager.Remove()
				end,
			},
			{
				title = "Clean Up",
				icon = "broom",
				func = function()
					SelectionMenuManager.CreateConfirmation( T("RoomCleanUp"), function() RunConsoleCommand("gmt_resetroom") SelectionMenuManager.Remove() end )
				end,
			},
			{
				title = "Buy Vault Slots",
				icon = "safe",
				func = function()
					self:TrunkUpgrade()
				end,
			},
			{
				title = "Information",
				icon = "about",
				func = function() MsgN( "wow!" ) end,
			},
		}

		SelectionMenuManager.Create( "towercondos", menu )

	elseif Answer == 0 then

		local menu = {
			{
				title = "Buy Vault Slots",
				icon = "safe",
				func = function()
					self:TrunkUpgrade()
				end,
			},
			{
				title = "Information",
				icon = "about",
				func = function() MsgN( "wow!" ) end,
			},
		}

		SelectionMenuManager.Create( "towercondos", menu, "Sorry, no condos available." )

	else

		local menu = {
			{
				title = "CHECK IN",
				large = true,
				icon = "condo",
				func = function()
					RunConsoleCommand("gmt_acceptroom")
					SelectionMenuManager.Remove()
				end,
			},
			{
				title = "Buy Vault Slots",
				icon = "safe",
				func = function()
					self:TrunkUpgrade()
				end,
			},
			{
				title = "Information",
				icon = "about",
				func = function() MsgN( "wow!" ) end,
			},
		}

		local condos = 12

		SelectionMenuManager.Create( "towercondos", menu, Answer .. "/" .. condos .. " condos available." )

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

			/*if Hats.List then
				Room.Hats[ 0 ] = true

				for k, hat in ipairs( Hats.List ) do
					if hat.unique_Name then
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

	local MapData = self.RoomMapData[ game.GetMap() ]

	if !MapData then
		MsgC( color_red, "[Room] Map data not found.\n")
		return
	end

	for _, v in pairs( ents.FindByClass( MapData.refobj ) ) do
		local EntIndex = v:EntIndex()

		for _, Room in pairs( self.Rooms ) do
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

CondoNames = {}

net.Receive('gmt_senddoortexts',function()
	CondoNames = net.ReadTable()
end)

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
