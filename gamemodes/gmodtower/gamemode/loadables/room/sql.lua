---------------------------------
local function UpdateData( ply, ondisconnect )

	local Room = ply:GetRoom()

	if Room then
		return Room:GetSQLSave()
	end

end

hook.Add("SQLStartColumns", "SQLRoomData", function()
	SQLColumn.Init( {
		["column"] = "condodata",
		["selectquery"] = "HEX(condodata) as condodata",
		["selectresult"] = "condodata",
		["update"] = UpdateData,
		["defaultvalue"] = function( ply )
			ply._RoomSaveData = nil
		end,
		["onupdate"] = Suite.SQLLoadData
	} )
end )
