---------------------------------
local function UpdateData( ply, ondisconnect )

	local Room = ply:GetRoom()

	if Room then
		return Room:GetSQLSave()
	end

end

hook.Add("SQLStartColumns", "SQLRoomData", function()
	SQLColumn.Init( {
		["column"] = "roomdata",
		["selectquery"] = "HEX(roomdata) as roomdata",
		["selectresult"] = "roomdata",
		["update"] = UpdateData,
		["defaultvalue"] = function( ply )
			ply._RoomSaveData = nil
		end,
		["onupdate"] = Suite.SQLLoadData
	} )
end )
