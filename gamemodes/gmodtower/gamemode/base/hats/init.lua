
include('shared.lua')
AddCSLuaFile('list.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
//AddCSLuaFile('sh_translation.lua')
include('hat.lua')

include("db.lua")

local DEBUG = false

hook.Add("GTowerStoreLoad", "AddHats", function()
	for _, v in pairs( GTowerHats.Hats ) do

		if v.unique_Name then

			if !v.storeid then
				v.storeid = GTowerHats.StoreId
			end
			v.upgradable = true
			v.ClientSide = true

			local NewItemId = GTowerStore:SQLInsert( v )

			v.id = NewItemId

		end

	end

end )

function GTowerHats:Sendclient( ply )

	if GTowerStore.SendItemsOfStore then
		GTowerStore:SendItemsOfStore( ply, GTowerHats.StoreId )
	end

end

concommand.Add("gmt_requesthatstoreupdate", function(ply)
	if GTowerStore.SendItemsOfStore then
		GTowerStore:SendItemsOfStore( ply, GTowerHats.StoreId )
		GTowerStore:SendItemsOfStore( ply, 19 ) -- Halloween hats
	end
end)

function GTowerHats:OpenStore( ply )
	ply:ConCommand("gmt_requesthatstoreupdate")
	timer.Simple(0.25, function()
		GTowerStore:OpenStore( ply, self.StoreId )
	end)
end


// Hat 2 Client
/*
util.AddNetworkString( "clientHatRequest" )
net.Receive( "clientHatRequest", function( len, ply )
	local requests net.ReadTable()
	//local requests = net.ReadData()
	//requests = util.Decompress(requests)
	//requests = util.JSONToTable(requests)

	PrintTable(requests)
end )
*/

local function getHatFromTable( hat, model )
	if GlobalHatOffsets[model][hat] then
		return GlobalHatOffsets[model][hat]
	end

	return nil
end

util.AddNetworkString( "hat_req" )
util.AddNetworkString( "hat_snd" )
net.Receive( "hat_req", function( len, ply )
	local hat = net.ReadString()
	local model = net.ReadString()

	local hatdata = getHatFromTable( hat, model )

	if !hatdata then return end

	local pos = Vector( tonumber(hatdata[2]), tonumber(hatdata[3]), tonumber(hatdata[4]) )
	local ang = Angle( tonumber(hatdata[5]), tonumber(hatdata[6]), tonumber(hatdata[7]) )
	local scale = tonumber(hatdata[8])

	net.Start( "hat_snd" )
		net.WriteString(hat)
		net.WriteString(model)

		net.WriteVector( pos )
		net.WriteAngle( ang )
		net.WriteFloat( scale )
	net.Send( ply )
end )

local function HatUpdateResult(res, stats, err)
	if stats != 1 then
		ErrorNoHalt( err )
	end
end

concommand.Add("gmt_admsethatpos", function( ply, cmd, args )

	if !GTowerHats:Admin( ply ) then
		return
	end

	local HatName = args[1]
	local ModelName = args[2]
	local XPos = tonumber( args[3] )
	local YPos = tonumber( args[4] )
	local ZPos = tonumber( args[5] )
	local PAng = tonumber( args[6] )
	local YAng = tonumber( args[7] )
	local RAng = tonumber( args[8] )
	local Scale = tonumber( args[9] )

	local Pos = Vector( XPos, YPos, ZPos )
	local Ang = Angle( PAng, YAng, RAng )
	local ModelList = GTowerHats:GetModelPlayerList()

	if !GTowerHats:GetHatByName( HatName ) || !ModelList[ ModelName ] then
		return
	end

	if DEBUG then
		Msg( "HAT ADMIN UPDATE - ", HatName, " - ", ModelName, ":\n" )
	end

	 /*SQL.getDB():Query( "REPLACE INTO `gm_hats`(hat,model,vx,vy,vz,ap,ay,ar,scale) VALUES ('"..HatName.."','"..ModelName.."',"
		..XPos..","..YPos..","..ZPos..","..PAng..","..YAng..","..RAng..","..Scale..")",
		HatUpdateResult )*/

		SQL.getDB():Query("SELECT * FROM gm_hats WHERE hat='"..HatName.."' AND plymodel='"..ModelName.."'", function(res)

			if #res[1].data == 0 then
				SQL.getDB():Query( "INSERT INTO `gm_hats`(hat,plymodel,vx,vy,vz,ap,ay,ar,scale) VALUES ('"..HatName.."','"..ModelName.."',"
		 		..XPos..","..YPos..","..ZPos..","..PAng..","..YAng..","..RAng..","..Scale..")",
		 		HatUpdateResult )
			else
				SQL.getDB():Query(
				"UPDATE gm_hats SET hat='"..HatName.."',plymodel='"..ModelName.."',vx="..XPos..",vy="..YPos..",vz="..ZPos..",ap="..PAng..",ay="..YAng..",ar="..RAng..",scale="..Scale.." WHERE hat='"..HatName.."' AND plymodel='"..ModelName.."'",HatUpdateResult)
			end

		end)

	local rp = RecipientFilter()

	for _, v in pairs( player.GetAll() ) do
		if v != ply then
			rp:AddPlayer( v )
			if DEBUG then
				Msg("Adding " .. tostring( v ) .. " to the sending list\n")
			end
		end
	end

	if DEBUG then Msg("\n") end

	umsg.Start( "HatAdm", rp )
		umsg.String( HatName )
		umsg.String( ModelName )
		umsg.Float( XPos )
		umsg.Float( YPos )
		umsg.Float( ZPos )
		umsg.Float( PAng )
		umsg.Float( YAng )
		umsg.Float( RAng )
		umsg.Float( Scale )
	umsg.End()

end )

hook.Add("PlayerLevel", "ZeldaFanboy", function( ply )

	if GTowerAchievements && !ply:Achived( ACHIEVEMENTS.ZELDAFANBOY ) then

		ply:SetAchievement( ACHIEVEMENTS.ZELDAFANBOY , ply:GetLevel("hatlinkhat") + ply:GetLevel("hatfairywings") + ply:GetLevel("hatmajorasmask") )

	end

end )

local function BuildHatsResult(modelhats)

	local buffer = {"HatTranslations = {"}
	local t = 0
	for model, hatdata in pairs(modelhats) do
		print("\nWRITING HATS FOR MODEL "..tostring(t+1)..": "..tostring(model))
		t=t+1
		table.insert(buffer, string.format("[\"%s\"]={", model))
		for hat, tbl in pairs(hatdata) do
		--Msg(hat, tbl[1], tbl[2], tbl[3], tbl[4], tbl[5], tbl[6], tbl[7])
			// Dank hat fix
			if tbl[1]=="" or tbl[1]=="" or tbl[1]=="" or tbl[1]=="" or tbl[1]=="" or tbl[1]=="" or tbl[1]=="" then
				MsgC( Color( 255, 0, 0 ),"FOUND A CORRUPTED HAT, MODEL: "..(tostring(model) or "[UNKNOWN MODEL]")..", HAT: "..(tostring(hat) or "[UNKNOWN HAT]")..". SKIPPING...")
				continue
			end
			print("	WRITING HAT: "..tostring(hat))
			table.insert(buffer, string.format("[\"%s\"]={%g,%g,%g,%g,%g,%g,%g},",
								hat, tbl[1], tbl[2], tbl[3], tbl[4], tbl[5], tbl[6], tbl[7]))
		end
		table.insert(buffer, "},")
	end

	table.insert(buffer, "}")

	file.Write("sh_translation.txt", table.concat(buffer, ""))

	print("Wrote " .. table.Count(modelhats) .. " hat entries.")
end

concommand.Add("gmt_writehattranslations", function(ply, cmd, args)
	if ply != NULL && !ply:IsAdmin() then return end

	local QueryCount = 0
	local EndTable = {}

	local function AddToResults( res )

		if res[1].status != true then
			ErrorNoHalt("Error getting hats" .. tostring(res[1].error))
			QueryCount = -1 //Do not let this finish
			return
		end

		for k, v in pairs(res[1].data) do
			if !EndTable[v.model] then
				EndTable[v.model] = {}
			end

			if !EndTable[v.model][v.hat] then
				EndTable[v.model][v.hat] = {v.vx, v.vy, v.vz, v.ap, v.ay, v.ar, v.scale}
			end
		end

		QueryCount = QueryCount - 1

		if QueryCount == 0 then
			BuildHatsResult( EndTable )
		end

	end

	 SQL.getDB():Query("SELECT COUNT(*) FROM gm_hats", function( res )

		if res[1].status != true then
			ErrorNoHalt("Error getting hats" .. tostring(res[1].error))
			return
		end

		local Count = #res[1].data

		for i=0, Count, 18000 do

			 SQL.getDB():Query("SELECT * FROM gm_hats LIMIT ".. i ..",18000", AddToResults)
			QueryCount = QueryCount + 1

		end


	end )



end)