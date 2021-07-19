ENT.Type = "anim"
ENT.Base = "gmt_door"

ENT.DelayTime = 0.75 //how long until the screen begins to fade
ENT.FadeTime = 0.25 //how long it takes to fade completely
ENT.WaitTime = 0.3 //period for it to stay completely black

OUTER_DOOR = 1
INNER_DOOR = 2

function ENT:SetupDataTables()
	/*self:NetworkVar( "Int", 0, "CondoID" )
	self:NetworkVar( "Bool", 0, "Locked" )
	self:NetworkVar( "Entity", 0, "Player" )*/

	--[[if SERVER and self.CondoDoorType == OUTER_DOOR then
		self:SetLocked( true )
	end]]
end

function ENT:GetCondoID()
	return self:GetNWInt("CondoID",0)
end

function ENT:GetCondoDoorType()
	return self:GetNWInt("CondoDoorType",1)
end

function ENT:GetCondo()
	local condoid = self:GetCondoID()
	return GtowerRooms:Get( condoid )
end

function ENT:CanEnterWhileLocked( ply, room )

	--if ply:IsAdmin() then return true end -- Admins can always enter (disabled for testing)
	local room = room or self:GetCondo()

	if room then
		return room.Owner == ply --or Friends.IsFriend( room.Owner, ply )
	end

	return false

end

function ENT:GetLocked()
	local room = room or self:GetCondo()

	if room && IsValid(room.Owner) then
		return room.Owner.GRoomLock
	end

end

function ENT:CanUse( ply )

	local room = self:GetCondo()
	local owner = nil

	if room then
		owner = room.Owner

		/*if CLIENT then
			owner = IsValid(room.RefEnt) and room.RefEnt:GetOwner()
		end*/
	end

	-- No owner, no entry
	if not room or not IsValid( owner ) then

		-- No owner, no entry (from lobby)
		if Location.Is( self:Location(), "condolobby" ) then
			return false
		end

		-- Inner door, always let them leave
		return true, "LEAVE"

	end

	-- Check if the room is loading
	/*if SERVER then
		if room:IsLoading() then
			return false
		end
	else -- CLIENT
		if room.RefEnt and room.RefEnt.GetLoading and room.RefEnt:GetLoading() then
			return false, "CONDO IS LOADING, PLEASE WAIT"
		end
	end*/

	-- Check if they are banned
	/*local banned = Friends.IsBlocked( owner, ply )
	if SERVER then banned = room:PlayerIsBanned( ply ) or banned end
	if banned then
		ply:MsgT( "RoomBannedFrom", owner:GetName() )
		return false
	end*/

	-- Check if you can get in
	if self:GetLocked() and not self:CanEnterWhileLocked( ply, room ) then

		-- Ring door bell
		if SERVER then room:RingDoorbell() end
		return false, "RING DOORBELL"

	end

	local text = "ENTER CONDO #" .. self:GetCondoID()
	if CLIENT and owner == LocalPlayer() then
		text = "ENTER YOUR CONDO" .. " [#".. self:GetCondoID() .. "]"
	end

	return true, text

end

--ImplementNW() -- Implement transmit tools instead of DTVars
