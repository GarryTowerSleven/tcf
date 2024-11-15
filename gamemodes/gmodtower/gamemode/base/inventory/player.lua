local meta = FindMetaTable( "Player" )
//local GtowerPlayerItems = {}
//local GTowerBankItems  = {}

if (!meta) then
    Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

/* ==============================
 == MAX ITEMS COUNT
================================= */
function meta:MaxItems()
	if not IsValid(self) or not self:IsNetInitalized() or not self.GetNet or not self:GetNet("MaxItems") then
		return GTowerItems.DefaultInvCount
	end

    return /*self:GetNet( "MaxItems" ) or*/ GTowerItems.DefaultInvCount
end

function meta:SetMaxItems( num )
	self:SetNet( "MaxItems", math.Clamp( tonumber( num or GTowerItems.DefaultInvCount ), 1, GTowerItems.MaxInvCount ) )
end

function meta:BankLimit()
    if not IsValid(self) or not self:IsNetInitalized() or not self.GetNet or not self:GetNet("BankMax") then
		return GTowerItems.DefaultBankCount
	end
	
	return self:GetNet("BankMax")
end

function meta:SetMaxBank( num )
	local n = math.Clamp(
		math.max(
			tonumber( num or GTowerItems.DefaultBankCount ),
			GTowerItems.DefaultBankCount
		),
		1,
		GTowerItems.MaxBankCount )

	self:SetNet( "BankMax", n )
end

/* ==============================
 == INTERACTIONS
================================= */

function meta:HasControl( ent )

	if hook.Call("PlayerHasControl", GAMEMODE, self, ent ) == true then
		return true
	end

	return self:IsAdmin() || self:GetSetting( "GTAllowInvAllEnts" ) == true

end

meta.InvCanUse = meta.HasControl

/* ==============================
 == BASIC GET/SET ITEM FUNCTIONS
================================= */

function meta:ValidSlot( slot )
	return slot && slot >= 1 && slot <= self:MaxItems()
end

function meta:InvGetSlot( id, slot )
	if self._GtowerPlayerItems && self._GtowerPlayerItems[ slot ] then
		return self._GtowerPlayerItems[ slot ][ id ]
	end
end

/*
	@ id = mysql id of the inventory item
	@ invonly = If it is only to check in the inventory, and not other places, such as the suites
*/

function meta:HasItemById( id, invonly )
	
	if ( not self._GtowerPlayerItems ) then return false end

	for _, SlotList in pairs(self._GtowerPlayerItems) do
		for _, Item in pairs( SlotList ) do
			if Item.MysqlId == id then
				return true
			end
		end
    end

	if invonly != true && hook.Call("InvUniqueItem", GAMEMODE, self, id ) == true then
		return true
	end

    return false
end

function meta:ForceItem( id, slot, item )
	self._GtowerPlayerItems[ slot ][ id ] = item
end

function meta:GetBankSlot( id )
    if self._GTowerBankItems && self:ValidBankSlot( id ) then
		return self._GTowerBankItems[ id ]
	end
end

function meta:ValidBankSlot( slot )
	return slot >= 1 && slot <= self:BankLimit()
end

function meta:ForceBankSlot( slot, item )
	if !self._GTowerBankItems then
		self._GTowerBankItems = {}
	end

	if item then
		item.IsBank = true
	end

	self._GTowerBankItems[ slot ] = item
end

function meta:FindInBank( ItemId )
	for k, v in pairs( self._GTowerBankItems ) do
		if v.MysqlId == ItemId then
			return k
		end
	end
end

function meta:BankCount()
	return table.Count( self._GTowerBankItems )
end

function meta:GetBankItems()
	return self._GTowerBankItems
end

/* ==============================
 == INTERACTIONS
================================= */

function meta:InvGiveItem( ItemId, slot, nobank )

	local ItemSlot = GTowerItems:NewItemSlot( self, slot )

	if !ItemSlot || !ItemSlot:CanManage() then return end

	local Item = GTowerItems:CreateById( ItemId, self )
	if !Item then return false end

	if !ItemSlot:IsValid() then
		ItemSlot:FindUnusedSlot( Item, true )

		if !ItemSlot:IsValid() then //IT's FULL!
			if not nobank then
				ItemSlot = GTowerItems:NewItemSlot( self, "-2" ) //In the bank!
				ItemSlot:FindUnusedSlot( Item, true )	
			else 
				return false
			end
		end
	end

	if !ItemSlot:Allow( Item, true ) then
		return false
	end

	ItemSlot:Set( Item )
	ItemSlot:ItemChanged()
	Item:PlayMoveSound()

	hook.Call("InvGrab", GAMEMODE, self, ItemSlot )

	return true

end

function meta:InvGrabEnt( ent, slot )

	if ent.DisallowGrab then
		return false
	end


	local ItemId = GTowerItems:FindByEntity( ent )

	if !ItemId then
		return false
	end

	local OriginalItem = GTowerItems:Get( ItemId )
	local ItemSlot = GTowerItems:NewItemSlot( self, slot )

	if !ItemSlot || !ItemSlot:CanManage() then return end

	if !ItemSlot:IsValid() then
		ItemSlot:FindUnusedSlot( OriginalItem, true )

		if !ItemSlot:IsValid() then //IT's FULL!
			return
		end
	end


	if ItemSlot:Get() then //There is already something on that slot
		return
	end

	local Item = GTowerItems:CreateById( ItemId, self )

	if !Item || !ItemSlot:Allow( Item, true ) then
		return false
	end

	if Item.AllowAnywhereDrop then

		if ent.PlayerOwner != self && !( self:IsAdmin() || self:GetSetting( "GTAllowInvAllEnts" ) ) then
			return false
		end

	else

		if !self:HasControl( ent ) && ClientSettings:Get( self, "GTAllowInvAllEnts" ) == false then
			return
		end
	end

	if self.Selling then
		self:Msg2( "Nice try." )
		SQLLog('exploit', self:SteamID() .. " caught on selling check 1." )
		return
	end

	self.Grabbed = true
	timer.Simple(0.15, function()
		self.Grabbed = false
	end )
	
	ItemSlot:Set( Item )
	ItemSlot:ItemChanged()

	hook.Call("InvGrab", GAMEMODE, self, ItemSlot )
	ent:Fire("Kill",0,0)

	return true
end

function meta:InvSwap( slot1, slot2 )

	local ItemSlot1 = GTowerItems:NewItemSlot( self, slot1 )
	local ItemSlot2 = GTowerItems:NewItemSlot( self, slot2 )

	if !ItemSlot1 || !ItemSlot2 then
		return
	end

	if ItemSlot1:Compare( ItemSlot2 ) then //Switching with your self?
		return
	end

	if !ItemSlot1:IsValid() || !ItemSlot1:CanManage() || !ItemSlot1:Allow( ItemSlot2:Get() ) then
		return
	end

	if !ItemSlot2:IsValid() || !ItemSlot2:CanManage() || !ItemSlot2:Allow( ItemSlot1:Get() ) then
		return
	end

	if self.Grabbed then
		SQLLog('exploit', self:SteamID() .. " caught on swap check." )
		return
	end
	
	local Item1 = ItemSlot1:Get()
	local Item2 = ItemSlot2:Get()

	ItemSlot1:Set( Item2 )
	ItemSlot2:Set( Item1 )

	ItemSlot1:ItemChanged()
	ItemSlot2:ItemChanged()

	Item1:PlayMoveSound()

	hook.Call("InvSwap", GAMEMODE, self, ItemSlot1, ItemSlot2 )
end

function meta:DropItem( slot, aim, rotation, shoot )

	rotation = rotation or 0
	aim = aim or self:GetAimVector()

	local ItemSlot = GTowerItems:NewItemSlot( self, slot )

	if !ItemSlot || !ItemSlot:IsValid() || !ItemSlot:CanManage() then
		return
	end

	local Item = ItemSlot:Get()

	if !Item then
		return
	end

	local ShootPos = shoot or self:GetShootPos()
	local Trace = util.QuickTrace(
		ShootPos,
		aim * GTowerItems.MaxDistance,
		self
	)

	if !Trace.Hit then
		return
	end

	if IsValid(Trace.Entity) && string.find(Trace.Entity:GetClass(), "door") then
		return
	end

	if Item.CanEntCreate == false then
		return
	end

	if Item.AllowAnywhereDrop || Item.AllowDropLocation || Item.AllowBarDrop then
		local playerEnts = 0
		for _, v in ipairs( ents.GetAll() ) do
			if ( v.PlayerOwner == self ) then
				playerEnts = playerEnts + 1
			end
		end

		local max = self:GetSetting( "GTOpenEntityLimit" )

		if playerEnts >= max && !self:IsAdmin() then
			self:Msg2( "You cannot place any more entities." )
			return
		end

	end

	if !Item.AllowDropLocation && !Item.AllowAnywhereDrop && !Item.AllowBarDrop then
		if hook.Call("GTowerInvDrop", GAMEMODE, self, Trace, Item ) != true && ClientSettings:Get( self, "GTAllowInvAllEnts" ) == false then
			return
		end
	end

	if Item.RemoveOnTheater == true && Location.IsTheater( Location.Find(self:GetPos()) ) then
		return
	end

	if Item.RemoveOnNarnia == true && Location.Is( self:GetPos(), "duelarena" ) then
		return
	end

	if Item.MaxSuite and !self:IsAdmin() and (self.GRoom and self.GRoom:GetItemCount(Item.MysqlId) >= Item.MaxSuite - 1) then
		self:Msg2( "You cannot place down more than " .. Item.MaxSuite .. " " .. Item.Name .. "s in your suite." )
		return
	end

	if self.Selling then
		self:Msg2( "Nice try." )
		SQLLog('exploit', self:SteamID() .. " caught on selling check 2." )
		return
	end
	
	//Return false so it does nothng
	local DropEnt = Item:OnDrop()
	local VarType = type( DropEnt )

	DropEnt.Item = Item

	if VarType == "Entity" || VarType == "Weapon"  then //Returned a entity to be set

		//You have to spawn it first for special entites
		//That the model is not set until it is spawned
		DropEnt:Spawn()

		local min = DropEnt:OBBMins()
		local Ang = Trace.HitNormal:Angle()

		// fix some odd issues with models!
		if AngleWithinPrecisionError(Ang.p, 270) || AngleWithinPrecisionError(Ang.p, 90) then
			Ang.y = 0
		end

		Ang:RotateAroundAxis( Ang:Right(), -90 )
		Ang:RotateAroundAxis( Ang:Up(), rotation )

		local Pos = Trace.HitPos - Trace.HitNormal * min.z

		if ( Item.Manipulator ) then
			Item.OriginalPos = Pos
			Pos = Item.Manipulator( Ang, Pos, Trace.HitNormal )
		end

		local snapSize = self:GetInfoNum( "gmt_itemsnapsize", 0 )

		if snapSize > 0 then
			snapSize = math.Clamp(snapSize, 2, 16)
			Pos.x = math.Round(Pos.x / snapSize) * snapSize
			Pos.y = math.Round(Pos.y / snapSize) * snapSize
		end

		DropEnt:SetPos( Pos /*Trace.HitPos - Trace.HitNormal * min.z*/ )
		DropEnt:SetAngles( Ang )
		DropEnt._GTInvSQLId = Item.MysqlId

		//To know who spawned it
		DropEnt:SetDTEntity( 5, self )

		local e = EffectData()
		e:SetOrigin(DropEnt:GetPos())
		e:SetEntity( DropEnt )
		util.Effect( 'spawneffect', e, true, true )

		if Item.AllowDropLocation or Item.AllowAnywhereDrop or Item.AllowBarDrop then // lets assign the owner here so we can count how many items we dropped
			DropEnt.PlayerOwner = self
		end

		if Item.AllowBarDrop && !ClientSettings:Get( self, "GTAllowInvAllEnts" ) && !Item.AllowAnywhereDrop && Location.GetSuiteID( DropEnt:Location() ) < 1 && !Location.IsBarDropAllowed( DropEnt:Location() ) then
			DropEnt:Remove()
			return
		end

		if Item.AllowDropLocation && !ClientSettings:Get( self, "GTAllowInvAllEnts" ) && !Item.AllowAnywhereDrop && Location.GetSuiteID( DropEnt:Location() ) < 1 && !Location.Is( DropEnt:Location(), Item.AllowDropLocation ) then
			DropEnt:Remove()
			return
		end

		if !GTowerItems:CheckTraceHull( DropEnt ) then //Not a really good place to put it, eh?
			DropEnt:Remove()
			return
		end

		if DropEnt.LoadRoom && type( DropEnt.LoadRoom ) == "function" then
			DropEnt:LoadRoom()
		end

		local phys = DropEnt:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( Item.EnablePhyiscs )
		end

		ItemSlot:Remove()
	else
		Msg("WARNING! DROPPED ENT AND OnDrop DID NOT RETURN AN ENTITY!\n")
		return
	end

	Item:PlayMoveSound()


	ItemSlot:ItemChanged()
	hook.Call("InvDrop", GAMEMODE, self, ItemSlot )

end

function meta:InvUse( slot )

	local ItemSlot = GTowerItems:NewItemSlot( self, slot )

	if !ItemSlot || !ItemSlot:IsValid() || !ItemSlot:CanManage() then
		return
	end

	local Item = ItemSlot:Get()

	if !Item || Item.CanUse != true then
		return
	end

	if Item.OnUse then
		local b, rtn = SafeCall( Item.OnUse, Item, ItemSlot )

		if !b then
			return
		end

		if rtn == true then
			ItemSlot:ItemChanged()
		elseif rtn != Item then
			ItemSlot:Set( rtn )
			ItemSlot:ItemChanged()
		end

		hook.Call("InvUse", GAMEMODE, ItemSlot, rtn, Item )
	end

end

function meta:InvRemove( slot, force )

	local ItemSlot = GTowerItems:NewItemSlot( self, slot )

	self.Selling = true

	if !ItemSlot || !ItemSlot:IsValid() || !ItemSlot:CanManage() then
		return
	end

	local Item = ItemSlot:Get()

	if !Item || Item.CanRemove != true then
		return
	end

	local GiveMoney = Item:SellPrice()

	ItemSlot:Remove()
	ItemSlot:ItemChanged()

	if !ItemSlot:Get() then
		if GiveMoney > 0 and !force then
			self:AddMoney( GiveMoney, nil, nil, nil, "Sold (" .. Item.Name .. ")" )
			self:Msg2( T("InventorySold", Item.Name), "storage" )
		else
			self:Msg2( T("InventoryDiscard", Item.Name), "storage" )
		end
	else
		self:Msg2( "Huh... something weird happened! Maybe the server broke!.. Or maybe you're just a bug finder." )
	end
	
	self.Selling = false
	hook.Call("InvRemove", GAMEMODE, ItemSlot )

end

/* ==============================
 == BANK FUNCTIONS
================================= */

function meta:AllowBank()
	//if self:IsAdmin() || hook.Call("AllowBank", GAMEMODE, self ) == true then
		return true
	//end

	//return false
end

/* ==============================
 == Equpiable items
================================= */

function meta:GetEquipment( name )

	if self._InvEquipItems then
		local Item = self._InvEquipItems[ name ]

		if Item && Item:IsValid() then
			return Item
		end
	end

end

function meta:SetEquipment( name, item )

	if !self._InvEquipItems then
		self._InvEquipItems = {}
	end

	//Allow to reset it or set a valid item
	if !item || item:IsValid() then
		self._InvEquipItems[ name ] = item
	end

end

function meta:GetEquipedItems()

	local Items = {}

	for i=1, GTowerItems.EquippableSlots do
		local Slot = GTowerItems:NewItemSlot( self, i )
		local Item = Slot:Get()

		if IsValid( Item ) then
			table.insert( Items, Item )
		end

	end

	return Items

end

hook.Add( "PlayerSetModelPost", "ApplyEquips", function( ply )

	local equips = ply:GetEquipedItems()

	for _, v in ipairs( equips ) do
		
		if ( v.UniqueEquippable and v.EquipType == "Potion" and isfunction( v.OnEquip ) ) then
			v:OnEquip()
		end

	end

end )

/* ==============================
 == MySQL Saving
================================= */
function meta:LoadInventoryData( data, slotid )

	if !self._GtowerPlayerItems then
		self._GtowerPlayerItems = {}
	end

	self._GtowerPlayerItems[ slotid ] = {}

	local ItemList = GTowerItems:Decode( data, self )

	local function CreateItem( v )
		local Slot = GTowerItems:NewItemSlot( self, v[1] .. "-" .. slotid )
		local Item = GTowerItems:CreateById( v[2], self, v[3] )

		Slot:Set( Item )

		Slot:ItemChanged()
	end

	for _, v in pairs( ItemList ) do
		SafeCall( CreateItem, v )
    end

end

function meta:GetInventoryData( slotid )
	if self._GtowerPlayerItems then
		return GTowerItems:Encode( self._GtowerPlayerItems[ slotid ] )
	end
end

hook.Add( "PlayerDisconnected", "InventoryCleanup", function( ply )
	for _, v in ipairs( ents.GetAll() ) do
		if ( v.PlayerOwner == ply ) then
			v:Remove()
			v = nil
		end
	end
end )
