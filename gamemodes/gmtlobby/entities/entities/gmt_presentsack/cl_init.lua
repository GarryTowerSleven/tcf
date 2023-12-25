include('shared.lua')

ENT.Vending = true
ENT.Offset = 21
ENT.Scale = 1.5

hook.Add("StoreFinishBuy", "PlayBuySound_Holiday", function()
	if GTowerStore.StoreId == GTowerStore.HOLIDAY then
		LocalPlayer():EmitSound("misc/jingle_bells/jingle_bells_nm_0" .. math.random( 5 ) .. ".wav")
	end
end )