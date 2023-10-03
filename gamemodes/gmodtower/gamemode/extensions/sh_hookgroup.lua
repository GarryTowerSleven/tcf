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
	
	self.id = tostring( math.Round( UnPredictedCurTime() + math.random( 1000, 9999 ) ) )

	table.insert( self.List, {
		name = name,
		uniquename = uniquename,
		func = func,
	} )
	
end

local function hookname( id, item )
	return "hookgroup" .. id .. "__" .. item.uniquename
end

function EnableHooks( self )
	
	for _, item in ipairs( self.List ) do

		// print( "enable", item.name, hookname( self.id, item ), item.func )
		
		hook.Add( item.name, hookname( self.id, item ), item.func )
	
	end

end

function DisableHooks( self )
	
	for _, item in ipairs( self.List ) do
		
		// print( "disable", item.name, hookname( self.id, item ), item.func )

		hook.Remove( item.name, hookname( self.id, item ) )
	
	end

end