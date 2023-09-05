ENT.Type			= "anim"

ENT.PlayerConfig = {
	angle = Angle(0, 0, 0),
	offset = Vector(0, 0, 0),
	width = 0,
	height = 0
}

function ENT:GetFirstMediaPlayerInLocation()

	// print("!!!!!!!!!")
	// pritn(self.MediaPlayer)
	-- Return already valid media player
	if IsValid(self.MediaPlayer) then return self.MediaPlayer end

	-- Find new one
	local mp

	for _, m in ipairs(Location.GetMediaPlayersInLocation( self:Location() )) do
	// print(m, m.Entity, m.Entity:GetClass(), !mp)
	if m.Entity and m.Entity:GetClass() == "gmt_jukebox" or !mp then
		mp = m
	end
end
	if mp then
		self.MediaPlayer = mp
		return self.MediaPlayer
	end

end

function ENT:CanUse( ply )

	local RoomId = Location.GetSuiteID( self:Location() )
	local Room = GTowerRooms:Get( RoomId )

	if Room then
		if GTowerRooms.CanManagePanel( RoomId, ply ) then
			return true, "REQUEST MUSIC"
		end
	end

end