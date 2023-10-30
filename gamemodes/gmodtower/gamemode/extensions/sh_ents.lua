function ents.FindInRealSphere( pos, radius )

    local tbl = {}

    for _, ent in pairs( ents.FindInSphere( pos, radius ) ) do
        if ( pos - ent:GetPos() ):Length() <= radius then
            table.insert( tbl, ent )
        end
    end

    return tbl

end

function ents.FindByBase( base )

	local tbl = {}

	for _, ent in pairs( ents.GetAll() ) do

		if ent.Base == base then
			table.insert( tbl, ent )
		end

	end

	return tbl

end

/*function ents.FindInPVS( vec )

	local tbl = {}
	local entities = ents.GetAll()

	for i = 0, #entities do

		if entities[i]:VisibleVec(vec) then
			table.insert( tbl, entities[i] )
		end
		
	end

	return tbl

end*/