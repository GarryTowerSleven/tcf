include('shared.lua')
include('player.lua')
include('sql.lua')
include('sh_store.lua')
include("pvpbattle/init.lua")
include("ballracer/init.lua")

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
AddCSLuaFile('sh_store.lua')

GTowerStore.Items = (GTowerStore.Items or {})

/*function GTowerStore:Get( id )
	
	if type( id ) == "string" then
	
		local ItemId = GTowerStore:GetItemByName( id )
		
		if ItemId then
			return GTowerStore.Items[ ItemId ]
		end
	end

	return GTowerStore.Items[ id ]
end

function GTowerStore:GetItemByName( Name )

	for k, v in pairs( self.Items ) do

		print( k, Name, v.unique_Name )
		
		if v.unique_Name == Name then
			return k
		end
	
	end

	return nil

end*/
