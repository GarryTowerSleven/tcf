module( "plynet", package.seeall )

DEBUG = false

function Register( nettype, name, nwtable )

	if not nwtable then nwtable= {} end

	if not nettype then
		ErrorNoHalt( "Error registering null player network var type! ", name, "\n" )
		return
	end

	RegisterDTVar( nettype, name, nwtable.default, nwtable.callback )

end

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

function Initialize( ply )
	-- if ( ply:IsBot() ) then return end
	if ( ply._NetInit ) then return end

	for i, var in pairs( PlayerNetworkVars ) do
		if DEBUG then MsgN( "Init: ", var.nettype, " id: ", var.id, " name: ", var.name ) end
		ply:NetworkVar( var.nettype, var.id, var.name )

		if ( var.callback && isfunction( var.callback ) ) then
			ply:NetworkVarNotify( var.name, function( ent, name, old, new )
				var.callback( ent, old, new, var )
			end )
		end

		-- Set default
		if var.default and SERVER then
			ply.dt[var.name] = var.default
		end
	end

	ply._NetInit = true
	hook.Call( "PlayerNetInitalized", GAMEMODE, ply )
end

local meta = FindMetaTable( "Player" )
if !meta then 
	return
end

function meta:IsNetInitalized()
	return self._NetInit == true
end

if SERVER then

	function meta:SetNet( name, value )

		-- if self:IsBot() then return end

		if self._NetInit then
			if ( self.dt[name] ~= value ) then
				local var = GetByName( name )
				if ( var && var.callback && isfunction( var.callback ) ) then
					self:CallDTVarProxies( var.nettype, var.id, value )
				end
			end

			self.dt[name] = value
		else
			// Initialize( self )
			if DEBUG then
				ErrorNoHalt("Missing network! Can't set '", name, "' to ", value, " on ", self, "\n")
				debug.Trace()
			end
		end

		return value

	end

end

function meta:GetNet( name )

	if not IsValid( self ) then return end
	-- if self:IsBot() then return end

	if self._NetInit and self.dt then
		return self.dt[name]
	else
		if DEBUG then
			ErrorNoHalt("Missing network! Can't get '", name, "' on ", self, "\n")
			debug.Trace()
		end
	end

end

/*if CLIENT then

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

end*/

Register( "Int", "Money" )
Register( "String", "FakeName" )
Register( "Entity", "DrivingObject" )