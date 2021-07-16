module( "GTowerItems", package.seeall )

// LAMPS
RegisterItem( "suitelamp", {
	Name = "Lamp",
	Description = "A decorative lamp that can be turned off and on.",
	ClassName = "gmt_lamp",
	Model = "models/gmod_tower/suite_lamptakenfromhl2.mdl",
	DrawModel = true,
	StorePrice = 250,
	StoreId = GTowerStore.SUITE,
} )

RegisterItem("lamp01",{
	Name = "Desk Lamp",
	Description = "A fancy lamp for your desk.",
	Model = "models/gmod_tower/lamp01.mdl",
	DrawModel = true,
	StorePrice = 150,
	StoreId = GTowerStore.SUITE,
})

RegisterItem("lamp02",{
	Name = "Fancy Lamp",
	Description = "A fancy lamp for just about anything.",
	ClassName = "gmt_modernlamp",
	Model = "models/gmod_tower/lamp02.mdl",
	DrawModel = true,
	StorePrice = 200,
	StoreId = GTowerStore.SUITE,
})

RegisterItem("lamp",{
	Name = "Desktop Lamp",
	Description = "Add some light to your desktop.",
	Model = "models/props_lab/desklamp01.mdl",
	DrawModel = true,
	StorePrice = 15,
	StoreId = GTowerStore.SOUVENIR,
})

RegisterItem("desklampspecial",{
	Name = "Desk Lamp",
	Description = "Perfect for reading a book, or for interrogating a suspect.",
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
	ClassName = "gmt_comfybed",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 1000,
	StoreId = GTowerStore.SUITE,
} )

RegisterItem("pinkbed",{
	Name = "Pink Bed",
	Description = "Bring out your inner little girl with this childish bed.",
	Model = "models/sims/gm_pinkbed.mdl",
	ClassName = "gmt_pinkbed",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 800,
	StoreId = GTowerStore.SUITE,
})

RegisterItem("heartbed",{
	Name = "Heart Bed",
	Description = "A bed shaped like a heart that's relevant once a year, and embarrassing the rest of the time.",
	Model = "models/props_vtmb/heartbed.mdl",
	ClassName = "gmt_pinkbed",
	MoveSound = "furniture3",
	DrawModel = true,
	StorePrice = 2100,
	StoreId = GTowerStore.SUITE,
})