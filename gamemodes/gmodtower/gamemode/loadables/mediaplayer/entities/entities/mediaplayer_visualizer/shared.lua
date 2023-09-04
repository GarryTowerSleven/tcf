ENT.Type			= "anim"

ENT.PlayerConfig = {
	angle = Angle(0, 0, 0),
	offset = Vector(0, 0, 0),
	width = 0,
	height = 0
}

function ENT:GetFirstMediaPlayerInLocation()
	local mp = Location.GetMediaPlayer(self:Location())
	if !IsValid(mp) then return end
	mp = MediaPlayer.GetByObject(mp)
	self.MediaPlayer = mp
	return mp
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