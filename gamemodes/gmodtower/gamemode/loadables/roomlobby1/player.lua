---------------------------------
local meta = FindMetaTable( "Player" )

if (!meta) then 
	MsgC( co_color2, "[Room] ALERT! Could not hook Player Meta Table\n" )
	return
end

function meta:GetRoom()
	return self.GRoom
end

function meta:GetLocationRoom()
	return GTowerRooms.VecInRoom( self:GetPos() )
end