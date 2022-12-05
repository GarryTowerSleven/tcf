/*module( "plynet", package.seeall )

DEBUG = false
UseTransmitTools = true

function Register( nettype, name, nwtable )

	if not nwtable then nwtable= {} end

	if not nettype then
		ErrorNoHalt( "Error registering null player network var type! ", name, "\n" )
		return
	end

	if UseTransmitTools then

		local transmittype = DTVarToTransmitTools[nettype]

		if not transmittype then
			ErrorNoHalt( "Error registering invalid transmit tools network var type! ", name, "\n" )
			return
		end

		RegisterNWTablePlayer( { { name, nwtable.default or DTVarDefaults[nettype], transmittype, nwtable.repl or REPL_EVERYONE, function(entity, name, old, new)
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
	Register( "Int", "Money" )
	Register( "String", "FakeName" )
	if IsLobby then	Register( "Entity", "DrivingObject" ) end
	return
end -- DTVar support
------------------------------------------------------------

PlayerNetworkVars = {}
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
	table.insert( PlayerNetworkVars, var )

end

function GetByType( nettype )

	local tbl = {}

	for i, var in pairs( PlayerNetworkVars ) do

		if var.nettype == nettype then
			table.insert( tbl, var )
		end

	end

	return tbl

end

function GetByName( name )

	for i, var in pairs( PlayerNetworkVars ) do

		if var.name == name then
			return var
		end

	end

end

function InitializeOn( ent, ply )

	for i, var in pairs( PlayerNetworkVars ) do

		-- Create the networkvar
		if DEBUG then MsgN( "Init: ", var.nettype, " id: ", var.id, " name: ", var.name ) end
		ent:NetworkVar( var.nettype, var.id, var.name )

		-- Set default
		if var.default and SERVER then
			ent.dt[var.name] = var.default
		end

	end

	ply._NetworkVarTable = table.Copy( PlayerNetworkVars )

end

local meta = FindMetaTable( "Player" )
if !meta then 
	return
end

if SERVER then

	hook.Add( "PlayerSpawn", "SetupPlayerNetworking", function( ply ) ply:SetupNetworking() end )
	hook.Add( "PlayerAuthed", "SetupPlayerNetworking", function( ply ) ply:SetupNetworking() end )
	hook.Add( "PlayerThink", "SetupPlayerNetworking", function( ply ) ply:SetupNetworking() end )

	function meta:SetupNetworking()

		if self:IsBot() then return end
		if IsValid( self._Network ) then return end

		local ent = ents.Create( "gmt_player_network" )
		ent:SetOwner( self )
		ent:Spawn()

		self._Network = ent

	end

	function meta:SetNet( name, value )

		if self:IsBot() then return end

		if IsValid( self._Network ) then
			self._Network.dt[name] = value
		else
			self:SetupNetworking()
			if DEBUG then ErrorNoHalt("Missing network! Can't set '", name, "' to ", value, " on ", self, "\n") end
		end

		return value

	end

end

function meta:GetNet( name )

	if not IsValid( self ) then return end
	if self:IsBot() then return end

	-- Cache client network
	if CLIENT and not IsValid( self._Network ) then
		for _, ent in pairs( ents.FindByClass("gmt_player_network") ) do
			if ent:GetOwner() == self then
				self._Network = ent
			end
		end
	end

	local network = self._Network

	if IsValid( network ) and network.dt then
		return network.dt[name]
	else
		if DEBUG then ErrorNoHalt("Missing network! Can't get '", name, "' on ", self, "\n") end
	end

end

if CLIENT then

	-- Handle clientside call backs
	hook.Add( "Think", "PlayerNetCallBackThink", function()

		-- Go through all players
		for _, ply in pairs( player.GetAll() ) do

			if not ply._NetworkVarTable then continue end

			-- Go through their network vars
			for i, var in pairs( ply._NetworkVarTable ) do

				-- Check if they have a call back
				if var.callback and type(var.callback) == "function" then

					-- Gather new and old network states
					local new = ply:GetNet( var.name )
					local old = var.value

					-- Run the call back
					if var.value ~= new then

						var.value = new -- Update to the new
						var.callback( ply, old or var.default, new, var )
						if DEBUG then MsgN( "plynet: Callback ", ply, " old: ", old, " new: ", new ) end

					end

				end

			end

		end

	end )

end

Register( "Int", "Money" )
Register( "String", "FakeName" )
Register( "Entity", "DrivingObject" )*/