include('shared.lua')

hook.Add("StoreFinishBuy", "PlayBuySound", function()

	if GTowerStore.StoreId == GTowerStore.MERCHANT then
		for _, ent in pairs( ents.FindByClass("gmt_npc_merchant" ) ) do
			ent:EmitSound("GModTower/stores/merchant/buyitem"..math.random(1,2)..".wav", 70, 100, 1, CHAN_VOICE)
		end
	end

end )