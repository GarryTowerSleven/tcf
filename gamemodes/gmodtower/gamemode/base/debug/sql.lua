local ErrorLogMessages = {}

local function SQLLogResult(res, status, err)

	if status != QUERY_SUCCESS then
		ErrorNoHaltWithStack( "SQLLOG ERROR: " .. tostring( err ) )
	end

end

function SQLLog( source, ... )

	local message = ""

	for _, v in pairs( {...} ) do
		if type( v ) == "Player" then
			message = message .. "[p=".. tostring(v:DatabaseID()) .."]"
		else
			message = message .. tostring ( v )
		end
	end

	if string.len( message ) < 3 then
		return
	end

	if !source || !message || !GTowerServers then
		print("no message")
		debug.Trace()
		return
	end

	if Database.IsConnected() then
		
		if source == 'error' then

			local Hash = tonumber( util.CRC( select(1, ...) ) )
	
			if table.HasValue( ErrorLogMessages, Hash ) then
				return
			end
	
			table.insert( ErrorLogMessages, Hash )
	
			local data = {
				message = Database.Escape( message, true ),
				srvid = "'" .. GTowerServers:GetServerId() .. "'",
			}
	
			local query = "INSERT INTO `gm_log_error` " .. Database.CreateInsertQuery( data ) .. ";"	
			Database.Query( query, SQLLogResult )
	
		else
	
			local data = {
				type = Database.Escape( tostring(source), true ),
				message = Database.Escape( message, true ),
				srvid = "'" .. GTowerServers:GetServerId() .. "'",
			}
	
			local query = "INSERT INTO `gm_log` " .. Database.CreateInsertQuery( data ) .. ";"	
			Database.Query( query, SQLLogResult )
	
		end

	end

	LogPrint( Format( "(%s) %s", source, message ), color_red, "SQLLog" )

end
