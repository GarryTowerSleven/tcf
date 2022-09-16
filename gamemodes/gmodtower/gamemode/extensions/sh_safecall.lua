local xpcall = xpcall
local unpack = unpack
local debug = debug
local SQLLog = SQLLog
local ErrorNoHalt = ErrorNoHalt
local print = print
local _G = _G
local SERVER = SERVER
local LocalPlayer= LocalPlayer
local table = table

module("hook2")

local HandleError
local ErrorMemory = {}

if SERVER then
	HandleError = function( err )
		if err == nil then err = "#EMPTY_ERROR" end
		local traceback = debug.traceback()
		if traceback == nil then traceback = "#EMPTY_TRACEBACK" end
		
		local ErrorMsg = err .. "\n" .. traceback
		
		if table.HasValue( ErrorMemory, err ) then
			return
		end
		
		table.insert( ErrorMemory, err )
		SQLLog('error', ErrorMsg ) 
		ErrorNoHalt( "\n\n" .. ErrorMsg .. "\n\n" )
		
		return ErrorMsg
	end
else
	HandleError = function( err )
		if table.HasValue( ErrorMemory, err ) then
			return
		end
		
		table.insert( ErrorMemory, err )
	
		if LocalPlayer():IsAdmin() then
			ErrorNoHalt( err )
		else
			print( err )
		end
		
		print( debug.traceback() .. "\n" )
		
		return err
	end
end

function SafeCall( func, ... )
	
	local argcache = {...}
	
	if #argcache == 0 then
		return xpcall( func, HandleError )
	end
	
	return xpcall( function()
		return func( unpack( argcache ) )
	end, HandleError )

end

_G.SafeCall = SafeCall