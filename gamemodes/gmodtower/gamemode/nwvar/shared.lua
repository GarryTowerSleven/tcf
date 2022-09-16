if SERVER then
	AddCSLuaFile()
end

local globalvars = {}
local playervars = {}
local entvars = {}
REPL_EVERYONE = 0
REPL_PLAYERONLY = 1
NWTYPE_STRING = 0
NWTYPE_NUMBER = 1
NWTYPE_FLOAT = 2
NWTYPE_CHAR = 3
NWTYPE_SHORT = 4
NWTYPE_BOOL = 5
NWTYPE_BOOLEAN = NWTYPE_BOOL
NWTYPE_ANGLE = 6
NWTYPE_VECTOR = 7
NWTYPE_ENTITY = 8

DTVarToTransmitTools = {
	["String"] = NWTYPE_STRING,
	["Bool"] = NWTYPE_BOOL,
	["Float"] = NWTYPE_FLOAT,
	["Char"] = NWTYPE_CHAR,
	["Short"] = NWTYPE_SHORT,
	["Int"] = NWTYPE_NUMBER,
	["Vector"] = NWTYPE_VECTOR,
	["Angle"] = NWTYPE_ANGLE,
	["Entity"] = NWTYPE_ENTITY,
}
DTVarDefaults = {
	["String"] = "",
	["Bool"] = false,
	["Float"] = 0.0,
	["Int"] = 0,
	["Vector"] = Vector(0,0,0),
	["Angle"] = Angle(0,0,0),
	["Entity"] = Entity(0),
}

function RegisterNWTable(ent, vars)
	for _, var in ipairs(vars) do
		local name = var[1]
		ent[name] = var[2]

		table.insert(entvars, {ent, name, var[5]})
	end
end

function RegisterNWTableGlobal(vars)
	for _, var in ipairs(vars) do
		local name = var[1]
		local type = var[3]

		timer.Simple(0, function()
			game.GetWorld()[name] = var[2]
		end)

		table.insert(globalvars, {name, type})
	end
end

function RegisterNWTablePlayer(vars)
	for _, var in ipairs(vars) do
		local name = var[1]
		local type = var[3]

		table.insert(playervars, {name, type, var[2], var[5]})
	end
end

function ImplementNW()

	ENT.__OldSetupDataTables = ENT.SetupDataTables

	local function OverrideNetworkVar( self, nwType, nwIndex, nwName, nwExtend )

		local default = nil
		if type(nwExtend) != "table" then default = nwExtend end

		table.insert( self.__varTable,
			{ nwName, default or DTVarDefaults[ nwType ], DTVarToTransmitTools[ nwType ], REPL_EVERYONE }
 		)

		self["Get" .. nwName] = function( e ) return e:GetNet( nwName ) end
		self["Set" .. nwName] = function( e, value ) e:SetNet( nwName, value ) end

	end

	ENT.SetupDataTables = function( self )

		self.__varTable = {}

		self.NetworkVar = OverrideNetworkVar
		self.__OldSetupDataTables( self )

		RegisterNWTable( self, self.__varTable )

		self.__varTable = nil

	end

end

hook.Add("Think", "ModuleReplacement", function()
	for _, var in ipairs(globalvars) do
		if SERVER then
			if game.GetWorld()[var[1]] != GetGlobalFloat(var[1]) then
				SetGlobalFloat(var[1], game.GetWorld()[var[1]])
			end
		elseif CLIENT then
			game.GetWorld()[var[1]] = GetGlobalFloat(var[1])
		end
	end

	for _, ply in ipairs(player.GetAll()) do
		for _, var in ipairs(playervars) do
			if ply[var[1]] == nil then
				ply[var[1]] = var[3]
			end

			if SERVER then
				if isbool(ply[var[1]]) then
					ply:SetNWBool(var[1], ply[var[1]])
				else
					if isfunction(ply[var[1]]) then continue end
					ply:SetNWFloat(var[1], ply[var[1]])
				end
			elseif CLIENT then
				if isbool(ply[var[1]]) then
					ply[var[1]] = ply:GetNWBool(var[1])
				else
					ply[var[1]] = ply:GetNWFloat(var[1])
					if var[4] != nil then
						if ply[var[1]] != var[3] then
							var[4]( ply, var[1], var[3], ply[var[1]] )
							var[3] = ply[var[1]]
						end
					end
				end
			end
		end
	end

	for i, var in ipairs(entvars) do
		local ent = var[1]

		if !IsValid(ent) then
			table.remove(entvars, i)
			continue
		end

		if SERVER then
			if isbool(ent[var[2]]) then
				if ent:GetNWBool(var[2]) != ent[var[2]] && var[3] then
					--logger.debug( string.format("CALLBACK ON %s: %s", tostring(ent), tostring(var[3])), "SERVER NWVARS" )

					var[3]( ent, var[2], ent[var[2]], ent:GetNWBool(var[2]) )
				end

				ent:SetNWBool(var[2], ent[var[2]])
			else
				if ent:GetNWFloat(var[2]) != ent[var[2]] && var[3] then
					--logger.debug( string.format("CALLBACK ON %s: %s", tostring(ent), tostring(var[3])), "SERVER NWVARS" )

					var[3]( ent, var[2], ent[var[2]], ent:GetNWFloat(var[2]) )
				end

				ent:SetNWFloat(var[2], ent[var[2]])
			end
		elseif CLIENT then
			if isbool(ent[var[2]]) then
				if ent:GetNWBool(var[2]) != ent[var[2]] && var[3] then
					--logger.debug( string.format("CALLBACK ON %s: %s", tostring(ent), tostring(var[3])), "CLIENT NWVARS" )

					var[3]( ent, var[2], ent[var[2]], ent:GetNWBool(var[2]) )
				end

				ent[var[2]] = ent:GetNWBool(var[2])
			else
				if ent:GetNWFloat(var[2]) != ent[var[2]] && var[3] then
					--logger.debug( string.format("CALLBACK ON %s: %s", tostring(ent), tostring(var[3])), "CLIENT NWVARS" )

					var[3]( ent, var[2], ent[var[2]], ent:GetNWFloat(var[2]) )
				end

				ent[var[2]] = ent:GetNWFloat(var[2])
			end
		end
	end
end)