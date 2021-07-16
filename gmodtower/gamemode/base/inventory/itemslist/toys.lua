module( "GTowerItems", package.seeall )

RegisterItem( "toytrainsmall", {
	Name = "Toy Train Small",
	Description = "Choo Choo (but small)",
	ClassName = "gmt_toy_train_small",
	Model = "models/minitrains/loco/swloco007.mdl",
	DrawModel = true,
	StorePrice = 5000,
	StoreId = GTowerStore.TOY,
	InvCategory = "toy"
} )

RegisterItem( "toytrain", {
	Name = "Toy Train",
	Description = "Choo Choo!",
	ClassName = "gmt_toy_train",
	Model = "models/minitrains/loco/swloco007.mdl",
	DrawModel = true,
	StorePrice = 6000,
	StoreId = GTowerStore.TOY,
	InvCategory = "toy"
} )

RegisterItem("rubikscube",{
	Name = "Huge Rubik's Cube",
	Description = "Play with your cubes, Rubik.",
	Model = "models/gmod_tower/rubikscube.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 800,
	InvCategory = "toy"
})

RegisterItem("portaltoy",{
	Name = "Portal Papertoy",
	Description = "Portal, paper edition!",
	Model = "models/gmod_tower/portaltoy.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 1000,
	MoveSound = "paper",
	InvCategory = "toy",
	UseSound = "use_portal.wav"
})

RegisterItem("trampoline",{
	Name = "Trampoline",
	Description = "Jump around all crazy like!",
	Model = "models/gmod_tower/trampoline.mdl",
	ClassName = "gmt_trampoline",
	UniqueInventory = false,
	DrawModel = true,
	CanRemove = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 500,
	InvCategory = "toy"
})

/*RegisterItem("checkers",{
	Name = "Checkers",
	Description = "An in-game variant of the classic game, checkers. Made by Clockwork.",
	Model = "models/gmod_tower/gametable.mdl",
	ClassName = "gmt_game_checkers",
	UniqueInventory = false,
	DrawModel = true,
	CanRemove = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 2000,
	InvCategory = "toy"
})*/

RegisterItem("obamacutout",{
	Name = "Obama Cutout",
	Description = "Your very own Obama.",
	Model = "models/gmod_tower/obamacutout.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 1500,
	InvCategory = "toy"
})

RegisterItem("huladoll",{
	Name = "Hula Doll",
	Description = "Reminds you of a place you'd like to be.",
	Model = "models/props_lab/huladoll.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 5,
	InvCategory = "toy",
	UseSound = "use_hula.wav",
	UseAnim = "Shake",
	UseScale = true,
})

RegisterItem("sunshrine",{
	Name = "Sunabouzu Shrine",
	Description = "A shrine in honor of Sunabouzu. Warning: Choking Hazard",
	Model = "models/gmod_tower/sunshrine.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 150000,
	OverrideSellPrice = 5,
	MoveSound = "furniture",
	InvCategory = "toy"
})

RegisterItem("plush_fox",{
	Name = "Plushy: Fox",
	Description = "A cute fuzzy plush.",
	Model = "models/gmod_tower/plush_fox.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 1500,
	InvCategory = "toy",
	MoveSound = "plush",
	UseSound = "move_plush.wav",
	UseScale = true,
	ModelSkinId = 0,
	DateAdded = 1399197707,
})

RegisterItem("plush_fox2",{
	Base = "plush_fox",
	Name = "Plushy: Blue Fox",
	ModelSkinId = 1,
})

RegisterItem("plush_fox3",{
	Base = "plush_fox",
	Name = "Plushy: Grey Fox",
	ModelSkinId = 2,
})

RegisterItem("plush_fox4",{
	Base = "plush_fox",
	Name = "Plushy: Pink Fox",
	ModelSkinId = 3,
})

RegisterItem("plush_fox5a",{
	Base = "plush_fox",
	Name = "Plushy: Orange Fox",
	ModelSkinId = 4,
})

RegisterItem("lightsabertoy",{
	Name = "Lightsaber",
	Description = "May the force be with you.",
	Model = "models/gmod_tower/toy_lightsaber.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 5000,
	MoveSound = "lightsaber",
	InvCategory = "toy",
	ClassName = "gmt_toy_lightsaber",
	DateAdded = 1399271681,
})

RegisterItem("plush_penguin",{
	Name = "Plushy: Penguin (Red Tie)",
	Description = "A cute fuzzy plush.",
	Model = "models/gmod_tower/plush_penguin.mdl",
	UniqueInventory = false,
	DrawModel = true,
	StoreId = GTowerStore.TOY,
	StorePrice = 1800,
	InvCategory = "toy",
	MoveSound = "plush",
	UseSound = "use_penguin.wav",
	UseScale = true,
	ModelSkinId = 0,
	DateAdded = 1403265069,
})

RegisterItem("plush_penguin2",{
	Base = "plush_penguin",
	Name = "Plushy: Penguin (Blue Tie)",
	ModelSkinId = 1,
})

RegisterItem("plush_penguin3",{
	Base = "plush_penguin",
	Name = "Plushy: Penguin (Whacky Orange Tie)",
	ModelSkinId = 2,
})

RegisterItem("plush_penguin4",{
	Base = "plush_penguin",
	Name = "Plushy: Penguin (Black Tie)",
	ModelSkinId = 3,
})

RegisterItem("plush_penguin5",{
	Base = "plush_penguin",
	Name = "Plushy: Penguin (Pink Tie)",
	ModelSkinId = 4,
})