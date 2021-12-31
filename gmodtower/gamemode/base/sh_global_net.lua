/*module( "globalnet", package.seeall )

DEBUG = false
UseTransmitTools = false
_GlobalNetwork = nil

function Register( nettype, name, nwtable )

	if not nwtable then nwtable= {} end

	if not nettype then
		ErrorNoHalt( "Error registering null global network var type! ", name, "\n" )
		return
	end

	if UseTransmitTools then

		local transmittype = DTVarToTransmitTools[nettype]

		if not transmittype then
			ErrorNoHalt( "Error registering invalid transmit tools network var type! ", name, "\n" )
			return
		end

		RegisterNWTableGlobal( { { name, nwtable.default or DTVarDefaults[nettype], transmittype, nwtable.repl or REPL_EVERYONE, function(entity, name, old, new)
			-- marshall from nwvar callback to simplified plynet callback
			if nwtable.callback then
				nwtable.callback(entity, old, new)
			end
		end} } )

	else

		RegisterDTVar( nettype, name, nwtable.default, nwtable.callback )

	end

end

------------------------------------------------------------
if UseTransmitTools then 
	return
end -- DTVar support
------------------------------------------------------------

_GlobalNetworkVars = {}
TypesAndLimits = {
	["String"] = 4,
	["Bool"] = 32,
	["Float"] = 32,
	["Int"] = 32,
	["Vector"] = 32,
	["Angle"] = 32,
	["Entity"] = 32,
}

function RegisterDTVar( nettype, name, default, callback )

	-- Check if there's a conflicting name
	if GetByName( name ) then
		if DEBUG then ErrorNoHalt( "Error registering player dtvar! '", name, "' is already registered.", "\n" ) end
		return
	end

	-- Check if the nettype is actually something we can use
	if not TypesAndLimits[nettype] then
		if DEBUG then ErrorNoHalt( "Error registering invalid player dtvar type! ", nettype, name, default, "\n" ) end
		return
	end

	local typenum = #GetByType( nettype )

	-- Prevent going over the limit
	if typenum >= TypesAndLimits[nettype] then
		if DEBUG then ErrorNoHalt( "Error registering player dtvar. ", nettype, " has reached the max variables!", "\n" ) end
		return
	end

	-- Create container for the network var object
	local var = {
		nettype = nettype,
		name = name,
		default = default,
		callback = callback,
		id = typenum,
		adminonly = false,
	}

	-- Add to the table of registrations
	table.insert( _GlobalNetworkVars, var )

end

function GetByType( nettype )

	local tbl = {}

	for i, var in pairs( _GlobalNetworkVars ) do

		if var.nettype == nettype then
			table.insert( tbl, var )
		end

	end

	return tbl

end

function GetByName( name )

	for i, var in pairs( _GlobalNetworkVars ) do

		if var.name == name then
			return var
		end

	end

end

function InitializeOn( ent )

	for i, var in pairs( _GlobalNetworkVars ) do

		-- Create the networkvar
		if DEBUG then MsgN( "Init: ", var.nettype, " id: ", var.id, " name: ", var.name ) end
		ent:NetworkVar( var.nettype, var.id, var.name )

		-- Set default
		if var.default and SERVER then
			SetNetDefault( ent, var )
		end

	end

end

function GetGlobalNetworking()

	if IsValid( _GlobalNetwork ) then
		return _GlobalNetwork
	else
		return ents.FindByClass("gmt_global_network")[1]
	end

end

function GetNet( name )

	-- Cache client global network
	if CLIENT and not IsValid( _GlobalNetwork ) then
		_GlobalNetwork = GetGlobalNetworking()
	end

	local network = _GlobalNetwork

	if IsValid( network ) and network.dt then
		return network.dt[name]
	else
		if DEBUG then ErrorNoHalt("Missing network! Can't get '", name, "' on ", self, "\n") end
	end

end*/