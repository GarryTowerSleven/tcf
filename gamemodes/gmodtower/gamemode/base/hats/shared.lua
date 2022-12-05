
GTowerHats = GTowerHats or {}
GTowerHats.Hats = {}
GTowerHats.BodyGroups = {}
GTowerHats.StoreId = 2
GTowerHats.DEBUG = false
GTowerHats.DefaultValue = { Vector(6, -2.5, 0), Angle(13, 0, 0), 1 }
GTowerHats.HatAttachment = "eyes"

GTowerHats.PlayerList = nil

SLOT_HEAD = 1
SLOT_FACE = 2

//include('sh_translation.lua')
include('list.lua')

for k,v in pairs(GTowerHats.Hats) do
	Model(v.model)
end

function GTowerHats:Admin( ply )
	return ply:IsAdmin() || ply:GetSetting("GTAllowEditHat") == true
end

function GTowerHats:GetHatByName( Name )
	for k, v in pairs( self.Hats ) do
		if v.unique_Name == Name then
			return k
		end
	end

	return nil
end

function GTowerHats:FindByModel( mdl )
	for k, v in pairs( self.Hats ) do
		if v.model == mdl then
			return v.unique_Name
		end
	end
end

function GTowerHats:GetItemFromModel( mdl )
	for k, v in pairs( GTowerHats.Hats ) do
		if string.lower(v.model) == string.lower(mdl) then
			return v
		end
	end
end

function GTowerHats:IsWearing( ply, uniquename )
	if !ply.CosmeticEquipment then return end
	for k,v in pairs(ply.CosmeticEquipment) do
		local hat = v:GetNWString("HatName")
		if !hat then return end

		if hat == uniquename then return true end

		return false

	end
end

function GTowerHats:GetModelPlayerList()

	if self.PlayerList then
		return self.PlayerList
	end

	self.PlayerList = {}
	local RealPlayerList = player_manager.AllValidModels()

	for k, v in pairs( RealPlayerList ) do
		if string.match(k, "female*") == "female" then
			k = "female*"
		elseif string.match(k, "male*") == "male" then
			k = "male*"
		elseif string.match(k, "redrabbit*") == "redrabbit" then
			k = "redrabbit"
		end

		self.PlayerList[ k ] = v
	end

	return self.PlayerList
end


function GTowerHats:FindPlayerModelByName( model )

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

hook.Add( "CanWearHat", "CheckStoreAllow", function( ply, uniquename )

	local id = GTowerStore:GetItemByName( uniquename )
	if uniquename == "ReallyHatTopHat" then
		return ply:IsAdmin() && 1 or 0
	end
	if SERVER && ply.GetLevel then
		return id && ply:GetLevel( id )
	else
		return id && GTowerStore:GetClientLevel( ply, id )
	end

end)