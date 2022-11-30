---------------------------------
local meta = FindMetaTable( "Player" )

if (!meta) then 
	MsgC( color_red, "[Room] ALERT! Could not hook Player Meta Table\n" )
	return
end

function meta:GetRoom()
	return self.GRoom
end

function meta:GetLocationRoom()
	return GtowerRooms.VecInRoom( self:GetPos() )
end