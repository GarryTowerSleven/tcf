module( "Friends", package.seeall )

REL_FRIEND = 1
REL_BLOCKED = 2

function IsFriend( ply, plyOther )

	if not IsValid( ply ) or not IsValid( plyOther ) then return end
	if not ply._Friends then return false end
	if not (IsValid(plyOther) and plyOther:IsPlayer()) or plyOther:IsBot() then return end

	local status = ply._Friends[plyOther:SteamID()]
	if status then
		return status == REL_FRIEND
	end

	return false

end

function IsBlocked( ply, plyOther )

	if not IsValid( ply ) or not IsValid( plyOther ) then return end
	if ( plyOther:IsAdmin() or plyOther:IsModerator() ) and not plyOther:IsHidden() and not plyOther:IsSecretAdmin() then return false end -- Admins cannot be blocked

	if not ply._Friends then return false end
	if not plyOther:IsPlayer() or plyOther:IsBot() then return end

	local status = ply._Friends[plyOther:SteamID()]
	if status then
		return status == REL_BLOCKED
	end

	return false

end

function GetRelationshipName( ply, plyOther )

	if not IsValid( ply ) or not IsValid( plyOther) then return end
	if not ply._Friends then return false end
	if not plyOther:IsPlayer() or plyOther:IsBot() then return end

	local status = ply._Friends[plyOther:SteamID()]
	if status then
		if status == REL_FRIEND then
			return "Friend"
		end
		
		if status == REL_BLOCKED then
			return "Blocked"
		end
	end

end