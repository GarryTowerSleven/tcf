function http.ParseHeader( str )

	str = string.Trim( str )
	str = string.Replace( str, '\r\n', '\n' )
	str = string.Split( str, '\n' )

	local tbl = {}

	if !string.find( str[1], ': ' ) then
		tbl._Head = table.remove( str, 1 )
	end

	for _, v in pairs( str ) do
		
		if string.len( v ) < 1 then continue end

		v = string.Split( v, ': ' )
		tbl[ v[1] ] = v[2]

	end

	return tbl

end