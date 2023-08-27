include('shared.lua')
include('cl_admin.lua')

module("Hats", package.seeall )

RequestDelay = 0

hook.Add("GTowerStoreLoad", "AddHats", function()
	for _, v in pairs( List ) do
		
		if v.unique_Name then
		
			local NewItem = {}
			
			NewItem.storeid = v.storeid || StoreId
			NewItem.name = v.name
			NewItem.Name = v.name
			NewItem.description = v.description
			NewItem.prices = { v.price }
			NewItem.unique_Name = v.unique_Name
			NewItem.model = v.model
			NewItem.drawmodel = true
			NewItem.ModelSkin = v.ModelSkin
			
			GTowerStore:SQLInsert( NewItem )
			
		end
		
	end
end )

function RequestData( modelname, hats )
	if CurTime() < RequestDelay then return end

	if isstring( hats ) then
		hats = { hats }
	end

    if table.IsEmpty( hats ) then return end

	local need = false

	for _, v in ipairs( hats ) do
		if not Data[ modelname ] or not Data[ modelname ][ v ] then
			need = true
			break
		end
	end

	if not need then return end

	net.Start( "HatRequest" )
		net.WriteString( modelname )
		net.WriteUInt( table.Count( hats ), 2 )
		for _, v in ipairs( hats ) do
			net.WriteString( v )
		end
	net.SendToServer()

	RequestDelay = CurTime() + 1
end

local function readoffset()
	local hat = net.ReadString()

	local pos = net.ReadVector()
    local ang = net.ReadAngle()
    local scale = net.ReadFloat()
    local att = net.ReadUInt( 8 )

	return hat, { pos.x, pos.y, pos.z, ang.p, ang.y, ang.r, scale, att }
end

function ReceiveData()
	local model = net.ReadString()
	local num = net.ReadUInt( 2 )

	local offsets = {}

	for i=1, num do
		local hat, offset = readoffset()

		offsets[hat] = offset
	end

	if table.IsEmpty( offsets ) then return end

	if not Data[ model ] then
		Data[ model ] = {}
	end

	for k, v in pairs( offsets ) do
		Data[ model ][ k ] = v
	end

	hook.Run( "HatsReceived", model, table.GetKeys( offsets ) )
end

net.Receive( "HatRequest", ReceiveData )