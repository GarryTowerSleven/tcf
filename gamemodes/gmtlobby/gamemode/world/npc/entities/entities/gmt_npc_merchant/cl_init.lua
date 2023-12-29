include('shared.lua')

hook.Add("StoreFinishBuy", "PlayBuySound", function()

	if GTowerStore.StoreId == GTowerStore.MERCHANT then
		for _, ent in pairs( ents.FindByClass("gmt_npc_merchant" ) ) do
			ent:EmitSound("GModTower/stores/merchant/buyitem"..math.random(1,2)..".wav", 70, 100, 1, CHAN_VOICE)
		end
	end

end )

hook.Add( "Think", "MerchantLight", function() 

	for _, self in ipairs( ents.FindByClass( "gmt_npc_merchant" ) ) do

		if LocalPlayer():Location() != self:Location() then

			if IsValid( self.Light ) then

				self.Light:Remove()

			end

			return

		end


		if !IsValid( self.Light ) then

			self.Light = ProjectedTexture()

			self.Light:SetTexture( "effects/flashlight001" )

			self.Light:SetFarZ( 200 )
			self.Light:SetFOV( 40 )

			self.Light:SetBrightness( 2 )
			self.Light:SetColor( Color( 75, 177, 255) )

			self.Light:SetPos( self:GetPos() + self:GetUp() * 128 + self:GetForward() * 128 )
			self.Light:SetAngles( Angle( 40, -self:GetAngles().y, 0 ) )

			self.Light:Update()

		end

	end

end)