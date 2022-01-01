module( "file", package.seeall )

function FindDir( File, Dir )

	local files, folders = file.Find( File, Dir )
	return table.Add( files, folders )

end

function ReadJSON( filename )

	local json = file.Read( filename, "DATA" )
	if json then
		local tbl = util.JSONToTable( json )
		if tbl then return tbl end
	end

	return nil

end

function WriteJSON( filename, tbl )

	local json = util.TableToJSON( tbl )
	if json then
		file.Write( filename, json )
	end

end