module( "GTowerItems", package.seeall )

// LAMPS
RegisterItem( "suitelamp", {
	Name = "Lamp",
	Description = "A decorative lamp that can be turned off and on.",
	ClassName = "gmt_room_lamp",
	Model = "models/gmod_tower/suite_lamptakenfromhl2.mdl",
	DrawModel = true,
	StorePrice = 250,
	StoreId = GTowerStore.SUITE,
} )

RegisterItem("lamp01",{
	Name = "Desk Lamp",
	Description = "A fancy lamp for your desk.",
	ClassName = "gmt_room_lamp_desk",
	Model = "models/gmod_tower/lamp01.mdl",
	DrawModel = true,
	StorePrice = 150,
	StoreId = GTowerStore.SUITE,
})

RegisterItem("lamp02",{
	Name = "Fancy Lamp",
	Description = "A fancy lamp for just about anything.",
	ClassName = "gmt_room_lamp_fancy",
	Model = "models/gmod_tower/lamp02.mdl",
	DrawModel = true,
	StorePrice = 200,
	StoreId = GTowerStore.SUITE,
})

RegisterItem("lamp",{
	Name = "Desktop Lamp",
	Description = "Add some light to your desktop.",
	ClassName = "gmt_room_lamp_desktop",
	Model = "models/props_lab/desklamp01.mdl",
	DrawModel = true,
	StorePrice = 15,
	StoreId = GTowerStore.SOUVENIR,
})

RegisterItem("desklampspecial",{
	Name = "Desk Lamp",
	Description = "Perfect for reading a book, or for interrogating a suspect.",
	ClassName = "gmt_room_lamp_deskread",
	Model = "models/sunabouzu/special_lamp.mdl",
	DrawModel = true,
	StorePrice = 600,
	StoreId = GTowerStore.ELECTRONIC,
})


// BEDS
RegisterItem( "bed", {
	Name = "Bed",
	Description = "Sleep off your worries.",
	Model = "models/gmod_tower/suitebed.mdl",
	ClassName = "gmt_suitebed",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 1000,
	StoreId = GTowerStore.SUITE,
} )

RegisterItem( "comfybed", {
	Name = "Comfy Bed",
	Description = "A softer, higher class bed.",
	Model = "models/gmod_tower/comfybed.mdl",
	ClassName = "gmt_room_bed_comfy",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 2000,
	StoreId = GTowerStore.SUITE,
} )

RegisterItem("pinkbed",{
	Name = "Pink Bed",
	Description = "Bring out your inner little girl with this childish bed.",
	Model = "models/sims/gm_pinkbed.mdl",
	ClassName = "gmt_room_bed_pink",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 1300,
	StoreId = GTowerStore.SUITE,
})

RegisterItem("heartbed",{
	Name = "Heart Bed",
	Description = "A bed shaped like a heart that's relevant once a year, and embarrassing the rest of the time.",
	Model = "models/props_vtmb/heartbed.mdl",
	ClassName = "gmt_room_bed_heart",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 2500,
	StoreId = GTowerStore.SUITE,
})

RegisterItem("hotelbed",{
	Name = "Hotel Bed",
	Description = "While this bed may have been bought at a bankrupt hotel auction, you'll surely never find a comfier bed to sleep on... Ignoring the bedbugs of course.",
	Model = "models/props_vtmb/fancybed.mdl",
	ClassName = "gmt_room_bed_fancy",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 3000,
	NewItem = true,
	StoreId = GTowerStore.SUITE,
})

RegisterItem( "cheapbed", {
	Name = "Dingy Bed",
	Description = "Find out back pain really can get worse, with this bed that's been loved through the ages.",
	Model = "models/props/de_inferno/bed.mdl",
	ClassName = "gmt_room_bed_dingy",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 500,
	NewItem = true,
	StoreId = GTowerStore.SUITE,
} )