function IsFriendsWith(owner,friend)
	if (!IsValid(owner) || !IsValid(friend) ) || owner.FriendsList == nil then return false end
	return table.HasValue( owner.FriendsList, friend:SteamID64() )
end
