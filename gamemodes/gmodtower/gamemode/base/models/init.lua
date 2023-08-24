AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

module("GTowerModels", package.seeall)

/*hook.Add("SQLStartColumns", "SQLForcePlySize", function()
	_G.SQLColumn.Init( {
		["column"] = "plysize",
		["update"] = function( ply ) 
			return ply._ForcePlayerSize or 1.0
		end,
		["onupdate"] = function( ply, val )
			Set( ply, tonumber( val ) )
		end
	} )
end )*/

function Get( ply )
	return ply._PlyScaleTemp or ( ply._PlyScaleNormal or 1.0 )
end

function SendToClients( ply )
	ply:SetNet( "ModelSize", Get( ply ) or 1.0 )
end

local function CalculateScale( ply, size )
	return math.Clamp( (size or 1) * GetScale( ply:GetModel() ), 0, MaxScale )
end

function Set( ply, size )
	
	if hook.Call("PlayerResize", GAMEMODE, ply, size ) == false then
		return 
	end

	local scale = CalculateScale( ply, size )
	
	if ( scale <= 0.01 ) then
		ply._PlyScaleNormal = 1.0
	else
		ply._PlyScaleNormal = scale
	end

	ClearTemp( ply )
	
	SendToClients( ply )
	ChangeHull( ply )

end

function SetTemp( ply, size )

	if hook.Call("PlayerResize", GAMEMODE, ply, size ) == false then
		return 
	end
	
	local scale = CalculateScale( ply, size )
	
	if ( scale <= 0.01 ) then
		ply._PlyScaleTemp = nil
	else
		ply._PlyScaleTemp = scale
	end
	
	SendToClients( ply )
	ChangeHull( ply )
	
end

function ClearTemp( ply, send )

	ply._PlyScaleTemp = nil

	if ( send ) then
		SendToClients( ply )
		ChangeHull( ply )
	end

end

function TestSize( ply, scale )

	local tr = util.TraceHull( {
		start = ply:GetPos(),
		endpos = ply:GetPos(),
		maxs = Vector( 16,  16,  72 ) * scale,
		mins = Vector( -16, -16, 0 ) * scale,
		filter = ply
	} )

	return tr

end

/*hook.Add("PlayerSetModel", "AllowModelOverride", function( ply )

	if ply._PlyModelOverRide then
		local OverRide = ply._PlyModelOverRide
		ply._PlyModelOverRide = nil
		ply:SetModel( OverRide[1] )
		ply:SetSkin( OverRide[2] )
		ply:SetupHands()
		return true
	end
	
end )*/
	
hook.Add( "PlayerDeath", "GTowerChangePlyDeath", function( victim )
	ClearTemp( victim, true )
end )

concommand.Add( "gmt_setsize", function( ply, cmd, args )
	if ply:IsAdmin() then	
		SetTemp( ply, tonumber(args[1]) )
	end
end )

hook.Add( "AdminCommand", "ChangePlayerSize", function( args, admin, target )
	
	if args[1] == "plysize" then
		Set( target, tonumber(args[3]) )
	elseif args[1] == "plytsize" then
		SetTemp( target, tonumber(args[3]) )
	elseif args[1] == "remsize" then
		ClearTemp( target )
		Set( target, nil )
	end
	
end )

DefaultModels = DefaultModels or {}

function CatalogDefaultModels()
	for name, model in pairs( player_manager.AllValidModels() ) do
		if not GTowerModels.Models[name] or not GTowerModels.AdminModels[name] then

			if string.StartWith( name, "medic" ) || string.StartWith( name, "dod_" ) then continue end
			if name == "kdedede_pm" or name == "bond" or name == "classygentleman" || name == "maskedbreen" or name == "windrunner" || name == "grayfox" || name == "hostage01" || name == "hostage02" || name == "hostage03" then continue end
			table.insert( DefaultModels, model )

		end
	end
end

function GM:DefaultPlayerModel(model)
	return table.HasValue( DefaultModels, model )
end

function IsDefaultModel( name )
	return GTowerModels.AdminModels[ name ] == nil and GTowerModels.Models[ name ] == nil
end

hook.Add( "InitPostEntity", "DefaultPlayermodels", CatalogDefaultModels )

// should make this a hook
function CanUseModel( ply, name, skin )

	// local model = player_manager.TranslatePlayerModel( name )

	if ( engine.ActiveGamemode() == "virus" and name == "infected" ) then
		return ply:GetNet( "IsVirus" )
	end

	if ( GTowerModels.AdminModels[ name ] ) then
		return ply:IsAdmin()
	end

	if ( GTowerModels.Models[ name ] ) then		
		local model_item = GTowerItems.ModelItems[ name .. "-" .. (skin or "none") ]
		
		if model_item && ply:HasItemById( model_item.MysqlId ) then
			return true
		end
	end

	return IsDefaultModel( name ) or false
	
end

concommand.Add( "gmt_updateplayermodel", function( ply, cmd, args )

	if ( engine.ActiveGamemode() == "ultimatechimerahunt" ) then return end
	
	if ply:GetNWBool("ForceModel") || ply:GetNWBool("InLimbo") then return end
	
	if IsLobby && IsValid( ply:GetVehicle() ) then return end

	local modelinfo = string.Explode( "-", ply:GetInfo("gmt_playermodel") or "kleiner" )
	local modelname = modelinfo[1]
	local modelskin = tonumber( modelinfo[2] or 0 ) or 0
	
	if ( not CanUseModel( ply, modelname, modelskin ) ) then
		modelname = nil
		modelskin = 0
	end

	if modelname == "steve" && ply:GetInfo("cl_minecraftskin") != "" && ply:GetInfo("cl_minecraftskin") != ply:GetNet( "MCSkinName" ) then
		ply:SetNet( "MCSkinName", ply:GetInfo("cl_minecraftskin")) 
		ply:Msg2( T( "MCSkinChange" ) )
	end

	local model = player_manager.TranslatePlayerModel(modelname)

	ply:SetModel(model)
	ply:SetSkin(modelskin)
	ply:SetupHands()

	Set( ply )

	hook.Call( "PlayerSetModelPost", GAMEMODE, ply, model, modelskin )

end )

concommand.Add("gmt_updateplayercolor", function(ply)
	if ply:GetNWBool( "InLimbo" ) then 
		ply:SetPlayerColor( Vector(0.098039, 0.254902, 0.309804) )
		return
	end
	
	ply:SetPlayerColor( Vector(ply:GetInfo("cl_playercolor")) )
end)