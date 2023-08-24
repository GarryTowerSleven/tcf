AddCSLuaFile('cl_admin.lua')
AddCSLuaFile('list.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')
include('sv_admin.lua')
include('sql.lua')

module("Hats", package.seeall )

hook.Add("GTowerStoreLoad", "AddHats", function()
	for _, v in pairs( List ) do

		if v.unique_Name then

            v.storeid = v.storeid || StoreId
			v.upgradable = true
            
			local NewItemId = GTowerStore:SQLInsert( v )
            
			v.id = NewItemId

		end

	end
end )

function CreateWearable( ply, data, slot )

    if IsValid( ply.WearableEntities[ slot ] ) then
        ply.WearableEntities[ slot ]:Remove()
    end

    local ent = ents.Create( "gmt_hat" )
    ent:SetOwner( ply )

    if engine.ActiveGamemode() == "minigolf" then
        ent:SetOwner( ply:GetGolfBall() )
    end

    ent:SetModel( data.model )
    ent:SetSkin( data.ModelSkinId or 0 )

    ent:Spawn()

    ent._PlayerModel = nil
    ent._HatID = nil

    ply.WearableEntities[ slot ] = ent

    return ent

end

function UpdateWearable( ply, hatid, slot )

    local item = GetItem( hatid )
    if not item then return end

    local ent = ply.WearableEntities[ slot ]

    local playermodel = ply:GetModel()
    if engine.ActiveGamemode() == "minigolf" then
        playermodel = ply:GetGolfBall():GetModel()
    end

    if not IsValid( ent ) or ent._PlayerModel != playermodel or ent._HatID != hatid then

        // ?????????????? asshole
        local shouldnotify = IsValid( ent ) and ent._HatID != hatid or true

        if IsLobby and shouldnotify then
            ply:MsgT( "HatUpdated", item.name )
        end
       
        ent = CreateWearable( ply, item, slot )

        ent._PlayerModel = playermodel
        ent._HatID = hatid

        local data = Get( item.unique_Name, Hats.FindPlayerModelByName( playermodel ) )

        // print( "" )
        // print( "Hats.GetData", playermodel, item.model )
        // print( "Hats.GetData", "HatName=", item.unique_Name )
        // print( "Hats.GetData", "FindPlayerModelByName=", Hats.FindPlayerModelByName( PlayerModel ) )
        // print( "Hats.GetData", "DefaultValue=", data == DefaultValue )
        // print( "" )

        ent:SetHatData( data )

    end

end

function RemoveWearable( ply, slot, notify )

    local ent = ply.WearableEntities[ slot ] or nil

    if IsValid( ent ) then
        if IsLobby and notify then
            ply:MsgT( slot == SLOT_HEAD and "HatNone" or "HatFaceNone" )
        end

        ent:Remove()
    end

end

function UpdateWearables( ply )

    // print( "Hats.UpdateWearables", ply )
    
	local slot1, slot2 = GetWearables( ply )

    if not ply.WearableEntities then
        ply.WearableEntities = {}
    end

    if ( slot1 == 0 ) then
        RemoveWearable( ply, SLOT_HEAD, true )
    else
        local item = GetItem( slot1 )
        
        if item and item.slot == SLOT_HEAD then
            UpdateWearable( ply, slot1, SLOT_HEAD )
        end
    end
    
    if ( slot2 == 0 ) then
        RemoveWearable( ply, SLOT_FACE, true )
    else
        local item = GetItem( slot2 )

        if item and item.slot == SLOT_FACE then
            UpdateWearable( ply, slot2, SLOT_FACE )
        end
    end

end

hook.Add( "PlayerSetModelPost", "UpdateHats", UpdateWearables )

function SetHat( ply, hatid, slot, force )

    // print( "Hats.SetHat", ply, hatid, slot )

    hatid = tonumber( hatid ) or 0
    slot = math.Clamp( tonumber( slot ), 1, 2 ) or SLOT_HEAD

    local item = GetItem( hatid )
    if not item then return end

    if hatid > 0 and item.slot != slot then return end

    if not force and hatid > 0 and hook.Run( "CanWearHat", ply, item.unique_Name ) != 1 then return end

    SetWearable( ply, hatid, slot )
    UpdateWearables( ply )

end

concommand.Add( "gmt_sethat", function( ply, _, args )

    if not args[1] or not args[2] then return end

    SetHat( ply, args[1], args[2] )
    
end )

concommand.Add( "gmt_requesthatstoreupdate", function( ply )

	if GTowerStore.SendItemsOfStore then

		GTowerStore:SendItemsOfStore( ply, StoreId )
		GTowerStore:SendItemsOfStore( ply, GTowerStore.HALLOWEEN )

	end

end )

local meta = FindMetaTable( "Player" )
if !meta then return end

function meta:SetHat( name, slot, force )
    local item = GetByName( name )
    if not item then return end

    SetHat( self, item, slot, force or false )
end

function meta:SetHatID( hatid, slot, force )
    SetHat( self, hatid, slot, force or false )
end
