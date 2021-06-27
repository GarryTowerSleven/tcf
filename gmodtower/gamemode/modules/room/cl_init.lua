---------------------------------
GtowerRooms = {}
GtowerRooms.Rooms = {}


local QueryPanel = nil

include("shared.lua")
include("room_maps.lua")
--include("cl_closet.lua")

net.Receive("gmt_partymessage", function()
	if NoPartyMsg:GetBool() then return end
	if LocalPlayer():GetNWBool("IsDueling") then return end
	local invString = net.ReadString()
	local roomid = net.ReadString()

	local Question = Msg2( invString )
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
        GtowerRooms:LoadRooms( um )
    elseif id == 1 then
		GtowerRooms:RemoveOwner( um )
	elseif id == 2 then
		GtowerRooms:ShowRentWindow( um )
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
		GtowerRooms:ShowNewRoom( um )
	elseif id == 5 then
		local Minutes = um:ReadChar()

		GTowerMessages:AddNewItem( T("RoomLongAway", Minutes) )
	//elseif id == 6 then
	//	local itemid = um:ReadChar()
	//
	//	GTowerMessages:AddNewItem( GetTranslation("RoomNotEnoughMoney", GtowerRooms.RoomUps[ itemid ].name ) )
	//elseif id == 7 then
	//	local itemid = um:ReadChar()
	//	local level = um:ReadChar()
	//
	//	GtowerRooms:AskNewRoom( itemid, level )
	elseif id == 8 then
		GTowerMessages:AddNewItem( T("RoomInventoryOwnRoom") )
	//elseif id == 9 then
	//	GtowerRooms:RecieveRefEnts( um )
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
		Msg("Recieved GRoom of unkown id: " .. tostring(id) .. "\n")
	end

end )

hook.Add("GTowerScorePlayer", "AddRoomNumber", function()

	GtowerScoreBoard.Players:Add(
		"Room #",
		5,
		75,
		function(ply)
			return (ply.GRoomId && ply.GRoomId > 0 && tostring(ply.GRoomId)) or " - "
		end,
		99
	)

end )

hook.Add("GTowerAdminPly", "AddSuiteRemove", function( ply )

	local PlyId = ply:EntIndex()

	if ply.GRoomId then
		return {
			["Name"] = "Remove Room",
			["function"] = function() RunConsoleCommand("gt_act", "remroom", PlyId ) end
		}
	end

end )

function GtowerRooms:CanManagePanel( room, ply )
  local owner = GtowerRooms:RoomOwner( room )
  return (owner == ply)
end

function GtowerRooms:Get( id )
	if !self.Rooms || !id then return end

	if !self.Rooms[ id ] then
		self.Rooms[ id ] = {}
	end

	return self.Rooms[ id ]
end

function GtowerRooms:ShowNewRoom( um )
	local RoomId = um:ReadChar()

	/*GtowerNPCChat:StartChat( {
		Text = T("RoomGet", RoomId )
	})*/

	GTowerMessages:AddNewItem( T( "RoomGetSmall", RoomId ), nil, nil, "condo" )
	--GTowerMessages:AddNewItem( "NOTE: Selling condos for profit is illegal.", nil, nil, "exclamation" )
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

function GtowerRooms:TrunkUpgrade()

	local menu = {
		TrunkSlot( 1 ),
		TrunkSlot( 2 ),
		TrunkSlot( 5 ),
		TrunkSlot( 10 ),
	}

	SelectionMenuManager.SetMenu( menu, true )

end

function GtowerRooms:ShowRentWindow( um )
	local Answer = um:ReadChar()

	if Answer == -2 then

		GtowerNPCChat:StartChat({
			Entity = GtowerRooms.NPCClassname,
			Text = T("I am sorry, the server is having some issues with the enties at the moment. \n Come back later."),
		})

	elseif Answer == -1 then
		/* GtowerNPCChat:StartChat({
			Entity = GtowerRooms.NPCClassname,
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
				func = function()
					GTowerMessages:AddNewItem( T("RoomInformation"), nil, nil, "condo" )
				end,
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
				func = function()
					GTowerMessages:AddNewItem( T("RoomInformation"), nil, nil, "condo" )
				end,
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
				func = function()
					GTowerMessages:AddNewItem( T("RoomInformation"), nil, nil, "condo" ) 
				end,
			},
		}

		local condos = 12

		SelectionMenuManager.Create( "towercondos", menu, Answer .. "/" .. condos .. " condos available." )

	end
end

function GtowerRooms:RemoveOwner( um )

	local RoomId = um:ReadChar()
	local Room = self:Get( RoomId )

	Room.Owner = nil

end

function GtowerRooms.ReceiveOwner( ply, roomid )
	local Room = GtowerRooms:Get( roomid )

	if Room then
		Room.HasOwner = true
		Room.Owner = ply
	end

end

RoomsHats = {}

function GtowerRooms:LoadRooms( um )

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

function GtowerRooms:GetEntIndexs( um )

	local Count = um:ReadChar()

	for i=1, Count do
		local Room = self:Get( i )

		Room.EntId = um:ReadShort()
	end

	 GtowerRooms:FindRefEnts()
end

function GtowerRooms:FindRefEnts()

	local MapData = self.RoomMapData[ game.GetMap() ]

	if !MapData then
		Msg("GtowerRooms: map data not found\n")
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

function GtowerRooms:RoomOwner( RoomId )
	if !RoomId then return end
    return self:Get( RoomId ).Owner
end

function GtowerRooms:RoomOwnerName( RoomId )
    local Room = self:Get( RoomId )

    if IsValid( Room.Owner ) && Room.Owner:IsPlayer() then
        return Room.Owner:Name()
    elseif Room.HasOwner then
		return T("RadioLoading")
    else
		return T("vacant") .. string.rep( ".", CurTime() * 3 % 4 )
    end

end

function GtowerRooms:AdminRoomDebug()
	local tbl =  GtowerRooms.RoomMapData[ CurMap ]

	if tbl then
		local EntList = ents.FindByClass( tbl.refobj )
		OrderVectors( tbl.min, tbl.max )

		for _, v in pairs( EntList ) do
			DEBUG:Box( v:LocalToWorld( tbl.min ), v:LocalToWorld( tbl.max ) )
		end
	end
end

CondoNames = {}

net.Receive('gmt_senddoortexts',function()
	CondoNames = net.ReadTable()
end)

hook.Add("FindStream", "StreamInSuite", function( ent )

	local RoomId = GtowerRooms.PositionInRoom( ent:GetPos() )

	if RoomId then

		for _, Stream in pairs( BassStream.List ) do
			local StreamEnt = Stream:GetEntity()

			if IsValid( StreamEnt ) && GtowerRooms.PositionInRoom( StreamEnt:GetPos() ) == RoomId then
				return Stream
			end

		end

	end


end )


local PANEL = {}

function PANEL:PerformLayout()

	local RoomId = LocalPlayer().GRoomId

	if ( RoomId && RoomId != 0 ) then

		local Count = LocalPlayer().GRoomEntityCount

		self:SetText( "Suite count: " .. tostring(Count) .. "/" .. tostring(LocalPlayer():GetSetting("GTSuiteEntityLimit")) )
		self:SizeToContents()

	end

end

vgui.Register("SuiteEntCount", PANEL, "DLabel")
