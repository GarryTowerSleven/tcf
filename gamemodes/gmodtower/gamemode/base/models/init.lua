AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

module("GTowerModels", package.seeall)

hook.Add("SQLStartColumns", "SQLForcePlySize", function()
	_G.SQLColumn.Init( {
		["column"] = "plysize",
		["update"] = function( ply ) 
			return ply._ForcePlayerSize or 1.0
		end,
		["onupdate"] = function( ply, val )
			Set( ply, tonumber( val ) )
		end
	} )
end )

function Get( ply )
	return ply._TempPlayerSize or ply._ForcePlayerSize
end

function SendToClients( ply )	
	ply:SetNet( "ModelSize", Get( ply ) or 1.0 )
end

function Set( ply, size )
	
	if hook.Call("PlayerResize", _G.GAMEMODE, ply, size ) == false then
		return 
	end

	size = math.Clamp( size or 0, 0, MaxScale )
	
	if size <= 0.01 || size == 1 then
		ply._ForcePlayerSize = nil	
		ply._TempPlayerSize = nil
	else
		ply._ForcePlayerSize = size
	end
	
	ChangeHull( ply )
	SendToClients( ply )	
end

function SetTemp( ply, size )

	if hook.Call("PlayerResize", _G.GAMEMODE, ply, size ) == false then
		return 
	end
	
	size = math.Clamp( size or 0, 0, MaxScale )
	local OldSize = ply._TempPlayerSize
	
	if size <= 0.01 || size == 1 then
		ply._TempPlayerSize = nil	
	else
		ply._TempPlayerSize = size
	end
	
	if OldSize != ply._TempPlayerSize then
		ply._IginoreChangeSize = true
		timer.Simple( 0.1, function() ply.Spawn( ply ) end)
		timer.Simple( 0.15, function() ply.SetPos( ply:GetPos() ) end)
	end
	
	ChangeHull( ply )
	SendToClients( ply )
	
end

function RemoveTemp( ply )
	if ply._TempPlayerSize then
		ply._TempPlayerSize = nil
		ChangeHull( ply, Get( ply ) )
		SendToClients( ply )
	end
end

hook.Add("PlayerSetModel", "AllowModelOverride", function( ply )

	if ply._PlyModelOverRide then
		local OverRide = ply._PlyModelOverRide
		ply._PlyModelOverRide = nil
		ply:SetModel( OverRide[1] )
		ply:SetSkin( OverRide[2] )
		ply:SetupHands()
		return true
	end
	
end )
	
hook.Add("PlayerDeath","GTowerChangePlyDeath", RemoveTemp )
hook.Add("PlayerSpawn","GTowerChangePlySpawn", function( ply )
	if !ply._IginoreChangeSize then
		RemoveTemp( ply )
	end
	ply._IginoreChangeSize = nil
	ply:UnDrunk()
end )

concommand.Add("gmt_plysize", function( ply, cmd, args )
	if ply:IsAdmin() then	
		Set( ply, tonumber(args[1]) )
	end
end )

concommand.Add("gmt_plysize2", function( ply, cmd, args )
	if ply:IsAdmin() then	
		SetTemp( ply, tonumber(args[1]) )
	end
end )

hook.Add("AdminCommand", "ChangePlayerSize", function( args, admin, target )
	
	if args[1] == "plysize" then
		Set( target, tonumber(args[3]) )
	elseif args[1] == "plytsize" then
		SetTemp( target, tonumber(args[3]) )
	elseif args[1] == "remsize" then
		Set( target, 1 )
		SetTemp( target, 1 )
	end
	
end )

concommand.Add( "gmt_updateplayermodel", function( ply, cmd, args )

	if ( engine.ActiveGamemode() == "ultimatechimerahunt" ) then return end
	
	if ply:GetNWBool("ForceModel") || ply:GetNWBool("Outside") then return end
	
	local modelinfo = string.Explode( "-", ply:GetInfo("gmt_playermodel") )
	local modelname = modelinfo[1]
	local modelskin = modelinfo[2]
	local model = player_manager.TranslatePlayerModel(modelname)
	
	if modelname == "steve" && ply:GetInfo("cl_minecraftskin") != "" && ply:GetInfo("cl_minecraftskin") != ply:GetNet( "MCSkinName" ) then
		ply:SetNet( "MCSkinName", ply:GetInfo("cl_minecraftskin")) 
		ply:Msg2( T( "MCSkinChange" ) )
	end

	local size = ( List[model] or 1 )

	if ( IsLobby ) then
		if ( ( ply:GetModelScale() != size && ply:GetModel() == model ) ) then
			size = ply.OldPlayerSize
			ply.OldPlayerSize = size
		end
	else
		if ( engine.ActiveGamemode() != "ballrace" ) then
			size = 1
		end
	end

	ply:SetModel(model)
	ply:SetSkin((modelskin || 0))
	ply:SetModelScale( tonumber( size ) or 1 )
	ply:SetupHands()
	Set( ply, size )
end )

concommand.Add("gmt_updateplayercolor", function(ply)
	ply:SetPlayerColor( Vector(ply:GetInfo("cl_playercolor")) )
end)