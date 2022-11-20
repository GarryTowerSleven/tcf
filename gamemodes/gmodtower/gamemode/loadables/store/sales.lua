---------------------------------
GTowerStore.Discount = {}

function GTowerStore:UpdateStatus(id, sale)
	local StoreTbl = GTowerStore.Stores[ id ]

	if !StoreTbl then
		ErrorNoHalt("Unable to start sale for store " .. tostring(id) )
		return false
	end

	if GTowerStore.Discount[id] == sale then
		return false
	end

	local value = sale or 0
	local onsale = (value != 0)

	local rp = RecipientFilter()

	for _, v in pairs( ents.FindByClass( StoreTbl.NpcClass ) ) do
		v:SetSale( onsale )
		//v.Sale = onsale
		rp:AddPVS(v:EyePos())
	end

	GTowerStore.Discount[id] = sale

	net.Start("Store")
		net.WriteInt(5,16)
		net.WriteInt(id,16)
		net.WriteFloat(value)
	net.Send(rp)

	/*umsg.Start("Store", rp)
		umsg.Char(5)
		umsg.Char(id)
		umsg.Float(value)
	umsg.End()*/

	return true
end

function GTowerStore:BeginSale(id, sale)
	if sale == 0 then
		Error("Can't begin a sale with 0 discount, did you mean to EndSale?")
	end

	for k,v in pairs( ents.FindByClass("gmt_salesignpos") ) do
		if v.StoreID == id then
		
			if IsValid(v.Sign) then v.Sign:Remove() end
		
			v.Sign = ents.Create("gmt_salesign")
			v.Sign:SetPos( v:GetPos() )
			v.Sign:SetAngles( v:GetAngles() )
			v.Sign:Spawn()
			v.Sign:SetStoreID( id )
		end
	end
	self:UpdateStatus(id, sale)
end

// need to tell clients it ended, if they have the store window open
function GTowerStore:EndSale(id)
	self:UpdateStatus(id, nil)
	
	for k,v in pairs( ents.FindByClass("gmt_salesignpos") ) do
		if v.StoreID == id then
			if IsValid(v.Sign) then v.Sign:Remove() end
		end
	end
	
end

concommand.Add("gmt_storesetdiscount", function(ply, cmd, args)
	if !IsValid(ply) || !ply:IsAdmin() then return end

	local store = tonumber(args[1])
	local value = math.Clamp(tonumber(args[2]), -math.huge, 1)
	if !store || !value then return end

	if value == 0 then
		GTowerStore:EndSale(store)
		AdminNotify( T("AdminEndSale", ply:GetName(), GTowerStore.Stores[ store ].WindowTitle) )
	else
		AdminNotify( T("AdminSetSale", ply:GetName(), GTowerStore.Stores[ store ].WindowTitle, value*100) )
		GTowerStore:BeginSale(store, value)
	end
end)

concommand.Add("gmt_store_allsale", function(ply, cmd, args)
	
	if !ply == NULL or IsValid(ply) && !ply:IsAdmin() then return end

	local value = math.Clamp( tonumber(args[1]*.01), -math.huge, 1 ) or 0

	if value == 0 then
		AdminNotify( T( "AdminEndSaleAll", ply:GetName() ) )
		for k,_ in pairs( GTowerStore.Stores ) do
			GTowerStore:EndSale( k )
		end
		return 
	end

	AdminNotify( T( "AdminSetSaleAll", ply:GetName(), value*100 ) )
	for k,_ in pairs( GTowerStore.Stores ) do
		GTowerStore:BeginSale( k, value )
	end

end)