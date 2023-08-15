ITEM.Name = "Suite Canvas: Landscape"
ITEM.Description = "A nice canvas to decorate your suite with."
ITEM.ClassName = "gmt_painting_landscape"
ITEM.Model = "models/gmod_tower/suite_art_large.mdl"
ITEM.UniqueInventory = true
ITEM.DrawModel = true
ITEM.Tradable = true
ITEM.ModelSkinId = 1

ITEM.StoreId = 1
ITEM.StorePrice = 250

ITEM.Manipulator = function( ang, pos, normal )

	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), 0 )
	ang:RotateAroundAxis( ang:Forward(), 90 )

	return pos

end
