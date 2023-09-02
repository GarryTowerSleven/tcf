module("Hats", package.seeall )

List = {}
StoreId = GTowerStore.HAT
DEBUG = false
DefaultValue = { 6, -2.5, 0, 13, 0, 0, 1, 1 }

PlayerList = nil
Data = Data or {}

SLOT_HEAD = 1
SLOT_FACE = 2

plynet.Register( "String", "ActiveWearables", { default = "0-0" } )

include('list.lua')

for k,v in pairs(List) do
	util.PrecacheModel(v.model) //Precache all models
end

function Admin( ply )

	if ply:IsAdmin() then
		return true
	end

	if ply.GetSetting && ply:GetSetting("GTAllowEditHat") == true then
		return true
	end

	return false

end

function Get( HatName, ModelName )

	if not HatName or not ModelName then return end

	HatName = string.lower( HatName )
	ModelName = string.lower( ModelName )
	
	if Data[ ModelName ] then
		return Data[ ModelName ][ HatName ] or DefaultValue
	end
	
	return DefaultValue
	
end

function GetData( PlayerModel, HatModel )

	local HatName = GetNameFromModel( HatModel )
	local Data = Get( HatName, FindPlayerModelByName( PlayerModel ) )

	return Data

end

function GetWearables( ply )

	local wearables = ply:GetNet("ActiveWearables")

	if !wearables then
		ply:SetNet("ActiveWearables", "0-0")
		wearables = "0-0"
	end
	
	local explode = string.Explode( "-", wearables )
	return tonumber( explode[1] ), tonumber( explode[2] )

end

function GetWearablesModels( ply )

	local slot1, slot2 = GetWearables( ply )
	local wear1, wear2 = GetItem( slot1 ), GetItem( slot2 )

	return wear1.model, wear2.model

end

function GetNoHat()
	return "models/gmod_tower/no_hat.mdl"
end

function SetWearable( ply, hatId, slot )

	if !slot then
		return
	end

	if !ply.Wearables then
		ply.Wearables = { 0, 0 }
	end

	ply.Wearables[slot] = hatId or 0

	// String it up
	local s = ""
	for id, hat in pairs( ply.Wearables ) do

		s = s .. hat

		if id != #ply.Wearables then
			s = s .. "-"
		end

	end

	// Network it
	ply:SetNet("ActiveWearables", s)

end

function GetItem( id )
	return List[ id ]
end

function GetByName( name )
	for k, v in pairs( List ) do
		if string.lower(v.unique_name or "") == string.lower(name) then
			return k
		end	
	end

	return nil
end

function GetNameFromModel( mdl )
	for k, v in pairs( List ) do
		if v.model == mdl then
			return v.unique_name
		end	
	end
end

function GetItemFromModel( mdl )
	for k, v in pairs( List ) do
		if string.lower(v.model) == string.lower(mdl) then
			return v
		end	
	end
end

function IsWearing( ply, uniquename )

	local slot1, slot2 = GetWearables( ply )
	local wear1, wear2 = GetItem( slot1 ), GetItem( slot2 )

	if (wear1 and wear1.unique_name == uniquename) || (wear2 and wear2.unique_name == uniquename) then
		return true
	end

	return false

end

function IsWearingID( ply, hatid )

	local slot1, slot2 = GetWearables( ply )

	if slot1 == hatid || slot2 == hatid then
		return true
	end

	return false

end

function GetModelPlayerList()
	
	if PlayerList then
		return PlayerList
	end
	
	PlayerList = {}
	local RealPlayerList = player_manager.AllValidModels()
	
	for k, v in pairs( RealPlayerList ) do
		if string.match(k, "female*") == "female" then
			k = "female*"
		elseif string.match(k, "male*") == "male" then
			k = "male*"
		end
		
		PlayerList[ k ] = v	
	end
	
	return PlayerList
end


function FindPlayerModelByName( model )

	if !model then return end
	model = string.lower(model)

	local PlayerId = ""
	
	for k, v in pairs( player_manager.AllValidModels() ) do
		if model == string.lower(v) then
			PlayerId = string.lower( k )
		end
	end
		
	if PlayerId == "" then
		PlayerId = "alyx"
	elseif string.match(PlayerId, "female*") == "female" then
		PlayerId = "female*"
	elseif string.match(PlayerId, "male*") == "male" then
		PlayerId = "male*"
	end

	return PlayerId

end

function TranformationOrigin( ent, attachId )

	if !attachId then
		return ent:GetPos(), ent:GetAngles()
	end
	
	local AtachTbl = AttachmentsList[ attachId ] or AttachmentsList[1]
	local Ghost = ( ent:GetModel() == "models/uch/mghost.mdl" )

	if AtachTbl.IsBone || Ghost then 

		local bone = ent:LookupBone( AtachTbl.Key )

		if !bone then
			bone = ent:LookupBone( "head" )
		end

		if !bone then
			return ent:GetPos(), ent:GetAngles()
		end

		return ent:GetBonePosition( bone )
	
	end
	
	local Attachment = ent:LookupAttachment( AtachTbl.Key ) 
	local Tbl = ent:GetAttachment( Attachment )
	
	if !Tbl then
		return ent:GetPos(), ent:GetAngles()
	end
	
	return Tbl.Pos, Tbl.Ang
	
end

function ApplyTranslation( ent, Offsets, scale )

	if !Offsets then
		return Vector( 0, 0, 0 ), Angle( 0, 0, 0 )
	end
	
	local origin = 1
	if Offsets && Offsets[8] then
		origin = Offsets[8]
	end

	local pos, ang = TranformationOrigin( ent, origin )
	local scale = scale or ent:GetModelScale()
	/*
		local scaleFactor = 2
		local invScaleFactor = 1 / scaleFactor
		local scale = plyscale * invScaleFactor + 1 * invScaleFactor
	*/
	
	ang:RotateAroundAxis( ang:Right(), Offsets[4] )
	ang:RotateAroundAxis( ang:Up(), Offsets[5] )
	ang:RotateAroundAxis( ang:Right(), Offsets[6] )
	
	local HatOffsets = ang:Up() * Offsets[1] + ang:Forward() * Offsets[2] + ang:Right() * Offsets[3]

	if not scale then scale = 1 end
	
	HatOffsets.x = HatOffsets.x * scale
	HatOffsets.y = HatOffsets.y * scale
	HatOffsets.z = HatOffsets.z * scale

	pos = pos + HatOffsets
	
	return pos, ang, scale

end

hook.Add( "CanWearHat", "CheckStoreAllow", function( ply, uniquename )

	local id = GTowerStore:GetItemByName( uniquename )

	if SERVER && ply.GetLevel then
		return id && ply:GetLevel( id )
	else
		return id && GTowerStore:GetClientLevel( ply, id )
	end
	
end )