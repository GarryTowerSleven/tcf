local EVENT = {}

EVENT.MinLength = 60 * 2
EVENT.MaxLength = 60 * 3
EVENT.ShopList = {
	GTowerStore.SUITE,
	GTowerStore.HAT, 
	GTowerStore.PVPBATTLE, 
	GTowerStore.BAR,
	GTowerStore.BALLRACE, 
	GTowerStore.SOUVENIR, 
	GTowerStore.ELECTRONIC, 
	GTowerStore.MERCHANT, 
	GTowerStore.BUILDING, 
	GTowerStore.VENDING,
	GTowerStore.PLAYERMODEL, 
	GTowerStore.POSTERS,
	GTowerStore.FOOD,
	--GTowerStore.DUEL,
	GTowerStore.TOY,
	GTowerStore.PET,
	GTowerStore.MUSIC,
}

EVENT.MinSale = 0.1
EVENT.MaxSale = 0.5

//Called when the events is created and started
function EVENT:Start()

	if CLIENT then
		return
	end

	self.StoreId = table.Random( self.ShopList )
	self.Value = math.Rand( self.MinSale, self.MaxSale )
	
	SafeCall( GTowerStore.BeginSale, GTowerStore, self.StoreId, self.Value )
	
	MsgT( "MiniStoreGameStart", math.floor( self.Value * 100 ), GTowerStore.Stores[ self.StoreId ].WindowTitle )
	
end

//Called when the event has ended and needs to be cleaned
function EVENT:End()

	if CLIENT then
		return
	end

	GTowerStore:EndSale( self.StoreId )

	MsgT( "MiniStoreGameEnd", GTowerStore.Stores[ self.StoreId ].WindowTitle )

	
end

minievent.Register( "StoreSale", EVENT )