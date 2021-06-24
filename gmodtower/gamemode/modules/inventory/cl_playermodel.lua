hook.Add("ClientExtraModels", "InventoryCheck", function( func )

	local function TestForItem( ItemObj )
		if ItemObj.Item && ItemObj.Item:IsValid() && ItemObj.Item.ModelItem == true then
			func( ItemObj.Item.ModelName .. "-" .. ItemObj.Item.ModelSkinId, ItemObj.Item.Model, ItemObj.Item.ModelSkinId )
		end
	end

	for _, tbl in pairs( GTowerItems.Items ) do
		TestForItem( tbl )
		/*for _, v in pairs( tbl ) do
			PrintTable(tbl)
			TestForItem( v )
		end*/

	end

end )

hook.Add("InventoryChanged", "RecreatePlayerList", function( ItemObj )

	if ItemObj.Item && ItemObj.Item.ModelItem == true then

		if GtowerScoreBoard && ValidPanel( GtowerScoreBoard.SettingPanel ) then
			GtowerScoreBoard.SettingPanel:GenerateModelSelection()
		end

	end

end )
