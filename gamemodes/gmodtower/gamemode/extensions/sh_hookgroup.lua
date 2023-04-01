module("hookgroup", package.seeall )

local MetaTable = {
	__index = getfenv()
}

function New()
	
	local t = {
		List = {}
	}
	
	setmetatable( t, MetaTable )
	
	return t
	
end

function Add( self, name, uniquename, func )

	if name == nil then
		print( debug.traceback() )
		Error("Attempting to add nil name to list!")
	end
	
	if uniquename == nil then
		print( debug.traceback() )
		Error("Attempting to hook group: " .. tostring(name) )
	end
	
	if func == nil then
		Error("Attempting to nil function to: " .. tostring(name) .. " - " .. tostring(uniquename) )
	end
	
	table.insert( self.List, {
		name = name,
		uniquename = uniquename,
		func = func
	} )
	
end

function EnableHooks( self )
	
	for _, item in ipairs( self.List ) do
		
		hook.Add( item.name, item.uniquename, item.func )
	
	end

end

function DisableHooks( self )
	
	for _, item in ipairs( self.List ) do
		
		hook.Remove( item.name, item.uniquename )
	
	end

end