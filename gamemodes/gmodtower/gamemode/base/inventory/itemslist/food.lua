---------------------------------

-----------------------------------------------------
module( "GTowerItems", package.seeall )

RegisterItem("ingredient_apple",{
	Name = "Apple",
	Description = "An ingredient to make smoothies with the blender.",
	Model = "models/sunabouzu/fruit/apple.mdl",
	DrawModel = true,
	StoreId = GTowerStore.FOOD,
	StorePrice = 35,
	DrawName = true,
	CanUse = true,

	OnUse = function(self)
		if IsValid( self.Ply ) && self.Ply:IsPlayer() then
			self.Ply:SetHealth( math.min( self.Ply:Health() + 15, self.Ply:GetMaxHealth() ) )
			self.Ply:EmitSound( "ambient/levels/canals/toxic_slime_gurgle" .. math.random(7, 8) .. ".wav", 75, math.random(90, 110) )
			return nil
		end

		return self
	end
})

RegisterItem("ingredient_straw",{
	Base = "ingredient_apple",
	Name = "Strawberry",
	Model = "models/sunabouzu/fruit/strawberry.mdl",
})

RegisterItem("ingredient_watermel",{
	Base = "ingredient_apple",
	Name = "Watermelon",
	Model = "models/props_junk/watermelon01_chunk01b.mdl",
})

RegisterItem("ingredient_banana",{
	Base = "ingredient_apple",
	Name = "Banana",
	Model = "models/props/cs_italy/bananna.mdl",
})

RegisterItem("ingredient_orange",{
	Base = "ingredient_apple",
	Name = "Orange",
	Model = "models/props/cs_italy/orange.mdl",
})

RegisterItem("ingredient_glass",{
	Base = "ingredient_apple",
	Name = "Ethanol",
	Model = "models/props_junk/glassjug01.mdl",
	StorePrice = 20,
	
	OnUse = function(self)
		if IsValid( self.Ply ) && self.Ply:IsPlayer() then
			self.Ply:Drink(15)
			self.Ply:ViewPunch(Angle(2, math.random(-1, 1), 0))
			self.Ply:EmitSound("ambient/levels/canals/toxic_slime_gurgle7.wav", 75, math.random(90, 110))
			return nil
		end

		return self
	end
})

RegisterItem("ingredient_plastic",{
	Base = "ingredient_apple",
	Name = "Plastic",
	Model = "models/props_junk/garbage_plasticbottle002a.mdl",
	StorePrice = 25,
	
	OnUse = function(self)
		if IsValid( self.Ply ) && self.Ply:IsPlayer() then
			self.Ply:TakeDamage(50, self.Ply, self.Ply)
			self.Ply:ViewPunch(Angle(8, math.random(-4, 4), 0))
			self.Ply:EmitSound("ambient/levels/canals/toxic_slime_gurgle7.wav", 75, math.random(90, 110))
			return nil
		end

		return self
	end
})

RegisterItem("ingredient_bone",{
	Base = "ingredient_apple",
	Name = "Bone",
	Model = "models/gibs/hgibs.mdl",
	StorePrice = 50,
	
	OnUse = function(self)
		if IsValid( self.Ply ) && self.Ply:IsPlayer() then
			self.Ply:Ignite(3, 0)
			self.Ply:EmitSound("ambient/levels/canals/toxic_slime_gurgle" .. math.random(7, 8) .. ".wav", 75, math.random(90, 110))
			return nil
		end

		return self
	end
})

// TODO!!

/*
RegisterItem("shake_morningfruit",{
	Name = "Morning Fruit Shake",
	Description = "A delicious smoothie.",
	Model = "models/sunabouzu/juice_cup.mdl",
	DrawModel = true,
	InvCategory = "food",
	StorePrice = 65,
	DrawName = true,
	ModelColor = Color( 159, 209, 31, 255 ),
})

RegisterItem("shake_midafternoonfruit",{
	Base = "shake_morningfruit",
	Name = "Mid-Afternoon Fruit Shake",
	ModelColor = Color( 209, 73, 31, 255 ),
})*/

RegisterItem("ingredient_water",{
	Base = "ingredient_apple",
	Name = "Water",
	Description = "Don't drink the water! They put something in it - to make you forget!",
	Model = "models/props/cs_office/Water_bottle.mdl",
	StoreId = GTowerStore.VENDING,
	StorePrice = 1,
})