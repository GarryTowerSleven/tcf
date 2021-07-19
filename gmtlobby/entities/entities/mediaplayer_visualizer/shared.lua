ENT.Type			= "anim"

function ENT:GetFirstMediaPlayerInLocation()

	-- Return already valid media player
	if IsValid(self.MediaPlayer) then return self.MediaPlayer end

	-- Find new one
	local mp = Location.GetMediaPlayersInLocation( self:Location() )[1]
	if mp then
		self.MediaPlayer = mp
		return self.MediaPlayer
	end

end

function ENT:CanUse( ply )

	/*local RoomId = Location.GetCondoID( self:Location() )
	local Room = GTowerRooms:Get( RoomId )

	if Room then
		if GTowerRooms.CanManagePanel( Room, ply ) then
			return true, "REQUEST MUSIC"
		end
	end*/

end