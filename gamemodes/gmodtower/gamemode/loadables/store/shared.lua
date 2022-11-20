---------------------------------
GTowerStore = GTowerStore or {}
GTowerStore.DEBUG2 = false //Leave DEBUG for the main store, not the module
//GTowerStore.SendOnlyClientSide = true

function GTowerStore:CalculatePrice( PriceTbl, CurMax, GoMax )

	local i
	local MoneyNeeded = 0

	for i = CurMax + 1, GoMax do
		MoneyNeeded = MoneyNeeded + PriceTbl[ i ]		
	end
	
	return MoneyNeeded

end