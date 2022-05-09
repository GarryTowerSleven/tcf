module( "GTowerItems", package.seeall )

// Christmas
// ============
RegisterItem("sack_plushie",{
	Name = "Sack Plushie",
	Description = "Holiday version of everyone's favorite plushie.",
	Model = "models/gmod_tower/sackplushie.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HOLIDAY,
	StorePrice = 3500,
})

RegisterItem("snowman",{
	Name = "Snowman",
	Description = "A wonderous snowman that will bring holiday cheer.",
	Model = "models/gmod_tower/snowman.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HOLIDAY,
	StorePrice = 600,
	UseSound = "use_snowman.mp3",
})

RegisterItem("candycane",{
	Name = "Candy Cane",
	Description = "A candy cane wrapped in ribbons.",
	Model = "models/gmod_tower/candycane.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HOLIDAY,
	StorePrice = 80,
	UseSound = "use_candycane.wav",
})

RegisterItem("stocking",{
	Name = "Stocking",
	Description = "A decorative stocking for all your small gifts.",
	Model = "models/wilderness/stocking.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HOLIDAY,
	StorePrice = 125,
	
	/*Manipulator = function( ang, pos, normal )
		ang:RotateAroundAxis( ang:Right(), 270 )
		ang:RotateAroundAxis( ang:Up(), 180 )
		ang:RotateAroundAxis( ang:Forward(), 180 )
		
		pos = pos + ( normal * -15 )
		
		return pos
	end*/
})

for i=0, 8 do
	RegisterItem("presenta" .. i,{
		Name = "Big Present #" ..( i + 1 ),
		Description = "A decorative large present to put under your christmas tree.",
		Model = "models/wilderness/presenta.mdl",
		UniqueInventory = false,
		DrawModel = true,
		StoreId = GTowerStore.HOLIDAY,
		ModelSkinId = i,
		StorePrice = 180,
	})
end

for i=0, 7 do
	RegisterItem("present2b" .. i,{
		Name = "Present #" ..( i + 1 ),
		Description = "A decorative present to put under your christmas tree.",
		Model = "models/wilderness/presentb.mdl",
		UniqueInventory = false,
		DrawModel = true,
		StoreId = GTowerStore.HOLIDAY,
		ModelSkinId = i,
		StorePrice = 80,
	})
end

RegisterItem("christmastree",{
	Name = "Christmas Tree w/ Lights and Train",
	Description = "A celebrative christmas tree with its own train set and lights!",
	Model = "models/wilderness/hanukkahtree.mdl",
	ClassName = "gmt_christmas_tree",
	UniqueInventory = true,
	DrawModel = true,
	CanRemove = true,
	StoreId = GTowerStore.HOLIDAY,
	StorePrice = 10000,
})

RegisterItem("christmastreesimple",{
	Name = "Christmas Tree",
	Description = "A celebrative christmas tree!",
	Model = "models/wilderness/hanukkahtree.mdl",
	ClassName = "gmt_christmas_tree_simple",
	UniqueInventory = true,
	DrawModel = true,
	CanRemove = true,
	StoreId = GTowerStore.HOLIDAY,
	StorePrice = 3000,
})

// Thanksgiving
// ============
RegisterItem("turkeydinnerthanks",{
	Name = "Turkey Dinner",
	Description = "Turkey dinner has never been more pixelated before.",
	Model = "models/gmod_tower/turkey.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.THANKSGIVING,
	StorePrice = 1000,
})

// Halloween
// ============
RegisterItem("scarytoyhouse",{
	Name = "Scary House",
	Description = "Boo.",
	Model = "models/gmod_tower/halloween_scaryhouse.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 1600,
	UseSound = "use_hauntedhouse.mp3",
})

RegisterItem("gravestone",{
	Name = "R.I.P. Tombstone",
	Description = "Remember when FPS games didn't suck?",
	Model = "models/gmod_tower/halloween_gravestone.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 1800,
	UseSound = "use_ripstone.mp3",
})

RegisterItem("candybucket",{
	Name = "Candy Bucket",
	Description = "A candy bucket used to decorate, not for throwing into the cauldron.",
	Model = "models/gmod_tower/halloween_candybucket.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 500,
	UseSound = "use_candy.wav",
})

RegisterItem("cauldron",{
	Name = "Mini Cauldron",
	Description = "A decorative mini cauldron.",
	Model = "models/gmod_tower/halloween_minicauldron.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 1000,
	UseSound = "use_cauldron.mp3",
})

RegisterItem("toyspider",{
	Name = "Toy Spider",
	Description = "Love spiders? So do we!",
	Model = "models/gmod_tower/halloween_spidertoy.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 800,
	UseSound = "use_spider.wav",
})

RegisterItem("spookboyplush",{
	Name = "Spook Boy Plushie",
	Description = "Your very own spooky sack boy.",
	Model = "models/gmod_tower/spookboy_plushie.mdl",
	DrawModel = true,
	StorePrice = 50,
})

RegisterItem("toytraincart",{
	Name = "Toy Train Cart",
	Description = "A toy cart from the Haunted Mansion ride.",
	Model = "models/gmod_tower/halloween_minitraincar.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 3000,
})

RegisterItem("toysmokemachine",{
	Name = "Fog Machine",
	Description = "Fog up your place with this smoke machine.",
	Model = "models/gmod_tower/halloween_fogmachine.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 3000,
	ClassName = "gmt_smokemachine",
	DateAdded = 1416196221
})

RegisterItem("cutoutcat",{
	Name = "Cutout: Cat",
	Description = "Decorate with this cutout cat.",
	Model = "models/gmod_tower/halloween_cutout_cat.mdl",
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 600,
	DateAdded = 1416196221
})

RegisterItem("cutoutbat",{
	Name = "Cutout: Bat",
	Description = "Decorate with this cutout bat.",
	Model = "models/gmod_tower/halloween_cutout_bat.mdl",
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 600,
	DateAdded = 1416196221
})

RegisterItem("lantern_lamp",{
	Name = "Lantern",
	Description = "A lightup spooky lantern to decorate your place with.",
	Model = "models/gmod_tower/halloween_lantern.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.HALLOWEEN,
	StorePrice = 1000,
	ClassName = "gmt_room_lamp_lantern",
	DateAdded = 1416196221
})

// New Halloween stuff
//-----------------------------

RegisterItem("flaskpotion",{
	Name = "Flask Potion",
	Description = "Please, do not drink this.",
	Model = "models/props_halloween/hwn_flask_vial.mdl",
	DrawModel = true,
	StorePrice = 100,
})

RegisterItem("hwpumpkin1",{
	Name = "Pumpkin #1",
	Description = "A pumpkin.",
	Model = "models/map_detail/halloween/pumpkin_face_01.mdl",
	DrawModel = true,
	StorePrice = 100,
})

RegisterItem("hwpumpkin2",{
	Name = "Pumpkin #2",
	Description = "A pumpkin.",
	Model = "models/map_detail/halloween/pumpkin_face_02.mdl",
	DrawModel = true,
	StorePrice = 100,
})

RegisterItem("hwpumpkin3",{
	Name = "Pumpkin #3",
	Description = "A pumpkin.",
	Model = "models/map_detail/halloween/pumpkins_01.mdl",
	DrawModel = true,
	StorePrice = 100,
})

RegisterItem("hwpumpkin4",{
	Name = "Pumpkin #4",
	Description = "A pumpkin.",
	Model = "models/map_detail/halloween/pumpkins_03.mdl",
	DrawModel = true,
	StorePrice = 100,
})

RegisterItem("cardboardzombie",{
	Name = "Zombie Cutout",
	Description = "Braaiinsss...",
	Model = "models/zerochain/props_halloween/cardboard_zombie01.mdl",
	DrawModel = true,
	DrawName = true,
	StorePrice = 100,
})

RegisterItem("scarecrow",{
	Name = "Scarecrow",
	Description = "That's a scary crow you got there!",
	Model = "models/props_manor/gmt_scarycrowman.mdl",
	DrawModel = true,
	StorePrice = 100,
})

RegisterItem("coffin",{
	Name = "Coffin",
	Description = "Bell not included.",
	Model = "models/props_manor/coffin_02.mdl",
	DrawModel = true,
	StorePrice = 100,
	UseSound = "misc/halloween/spell_skeleton_horde_cast.wav",
})

/*RegisterItem("hauntedcertificate",{
	Name = "Haunted Certificate",
	Description = "Show off to your friends that you survived the Haunted Mansion ride.",
	Model = "models/gmod_tower/halloween_certificate.mdl",
	UniqueInventory = true,
	DrawModel = true,
	Tradable = false
})*/