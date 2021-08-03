function player.GetInPVS( vec )
	local tbl = {}
	local players = player.GetAll()

	for _, ply in pairs( players ) do
		if ply:VisibleVec(vec) then
			table.insert( tbl, ply )
		end
	end

	return tbl
end

function player.GetAdmins()
	local tbl = {}
	local tblAdmins = {}
	local players = player.GetAll()

	for _, ply in pairs( players ) do
		if ply:IsAdmin() or ply:IsDeveloper() /*or ply:IsModerator()*/ then
			table.insert( tblAdmins, ply )
		else
			table.insert( tbl, ply )
		end
	end

	return tblAdmins, tbl
end