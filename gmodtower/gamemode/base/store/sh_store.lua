---------------------------------
GTowerStore.SUITE 		= 1
GTowerStore.HAT 		= 2
GTowerStore.PVPBATTLE 	= 3
GTowerStore.BAR 		= 4
GTowerStore.BALLRACE 	= 5
GTowerStore.SOUVENIR 	= 6
GTowerStore.ELECTRONIC 	= 7
GTowerStore.MERCHANT 	= 8
--GTowerStore.VIP 		= 9
GTowerStore.HOLIDAY 	= 10
GTowerStore.BUILDING 	= 11
GTowerStore.PLAYERMODEL = 13
GTowerStore.FIREWORKS 	= 14
GTowerStore.POSTERS 	= 15
GTowerStore.VENDING 	= 17
GTowerStore.THANKSGIVING = 18
GTowerStore.HALLOWEEN	= 19
GTowerStore.BATHROOM	= 21
GTowerStore.TOY = 22
GTowerStore.PARTICLES	= 23
GTowerStore.DUEL		= 24
GTowerStore.FOOD	= 25
GTowerStore.PET = 26
GTowerStore.MUSIC	= 27

GTowerStore.Stores = {
	[GTowerStore.SUITE] = {
		NpcClass = "gmt_npc_suitesell",
		WindowTitle = "Furniture Store",
		ModelStore = true,
		ModelSize = 400,
		CameraZPos = 25,
		Logo = "sweetsuite"
	},
	[GTowerStore.HAT] = {
		NpcClass = "gmt_npc_hat",
		WindowTitle = "Hat Store",
		ModelStore = true,
		ModelSize = 1000,
		CameraZPos = -2.5,
		Logo = "toweroutfitters"
	},
	[GTowerStore.PVPBATTLE] = {
		NpcClass = "gmt_npc_pvpbattle",
		WindowTitle = "PVP Battle Store",
	},
	[GTowerStore.BAR] = {
		NpcClass = "gmt_npc_bar",
		WindowTitle = "Bar",
		ModelSize = 400,
		CameraZPos = -2.5,
	},
	[GTowerStore.BALLRACE] = {
		NpcClass = "gmt_npc_ballracer",
		WindowTitle = "Ball Race Store",
		ModelSize = 300,
		CameraZPos = -2.5,
		Logo = "ballrace"
	},
	[GTowerStore.SOUVENIR] = {
		NpcClass = "gmt_npc_souvenir",
		WindowTitle = "Decorations",
		Logo = "sweetsuite",
		ModelSize = 600,
		CameraZPos = 50,
	},
	[GTowerStore.ELECTRONIC] = {
		NpcClass = "gmt_npc_electronic",
		WindowTitle = "Electronic Store",
		ModelStore = true,
		Logo = "centralcircuit",
		ModelSize = 400,
		CameraZPos = 25,
	},
	[GTowerStore.MERCHANT] = {
		NpcClass = "gmt_npc_merchant",
		WindowTitle = "Wandering Merchant",
		ModelSize = 500,
		CameraZPos = 25,
	},
	[9] = {
		NpcClass = "gmt_npc_rabbit",
		WindowTitle = "Rabbits!",
		ModelStore = true,
		CameraZPos = 55,
		ModelSize = 450
	},
	[GTowerStore.HOLIDAY] = {
		NpcClass = "gmt_presentbag",
		WindowTitle = "Happy Holidays!",
		ModelSize = 400,
		CameraZPos = -2.5,
	},
	[GTowerStore.BUILDING] = {
		NpcClass = "gmt_npc_building",
		WindowTitle = "Building Blocks Store",
		ModelStore = true,
		CameraZPos = 0,
		ModelSize = 450,
		Logo = "sweetsuite"
	},
	[12] = {
		NpcClass = "gmt_npc_digi",
		WindowTitle = "HyenaShack"
	},
	[GTowerStore.PLAYERMODEL] = {
		NpcClass = "gmt_npc_models",
		WindowTitle = "Player Models",
		ModelStore = true,
		ModelSize = 700,
		CameraZPos = 45,
		Logo = "toweroutfitters"
	},
	[GTowerStore.FIREWORKS] = {
		NpcClass = "gmt_npc_fireworks",
		WindowTitle = "Fireworks Store",
		ModelSize = 400,
		CameraZPos = -2.5,
	},
	[GTowerStore.POSTERS] = {
		NpcClass = "gmt_npc_posters",
		WindowTitle = "Poster Store",
		ModelStore = true,
		ModelSize = 1000,
		CameraZPos = 25,
		Logo = "sweetsuite"
	},
	[GTowerStore.VENDING] = {
		NpcClass = "gmt_vending_machine",
		WindowTitle = "Vending Machine",
		ModelSize = 1000,
		CameraZPos = 15,
	},
	[GTowerStore.THANKSGIVING] = {
		NpcClass = "gmt_npc_thanksgiving",
		WindowTitle = "Thanksgiving",
		ModelSize = 1000,
		CameraZPos = -2.5,
	},
	[GTowerStore.HALLOWEEN] = {
		NpcClass = "gmt_npc_halloween",
		WindowTitle = "Spooky Scary Halloween",
		ModelStore = true,
		ModelSize = 500,
		CameraZPos = -2.5,
	},
	[GTowerStore.BATHROOM] = {
		NpcClass = "gmt_npc_bathroom",
		WindowTitle = "Bathroom Attendant",
	},
	[GTowerStore.TOY] = {
		NpcClass = "gmt_npc_toys",
		WindowTitle = "Toys and Gizmos",
		Logo = "thetoystop",
		ModelSize = 400,
		CameraZPos = -2.5,
	},
	[GTowerStore.PARTICLES] = {
		NpcClass = "gmt_npc_particles",
		WindowTitle = "Particles",
	},
	[GTowerStore.DUEL] = {
		NpcClass = "gmt_npc_duel",
		WindowTitle = "Duels",
		ModelSize = 500,
		CameraZPos = -2.5,
	},
	[GTowerStore.FOOD] = {
		NpcClass = "gmt_npc_food",
		WindowTitle = "Smoothie Bar",
		Logo = "smoothiebar",
		ModelSize = 1000,
		CameraZPos = 25,
	},
	[GTowerStore.PET] = {
		NpcClass = "gmt_npc_pets",
		WindowTitle = "Pets",
		Logo = "thetoystop",
		ModelSize = 1000,
		CameraZPos = 10,
	},
	[GTowerStore.MUSIC] = {
		NpcClass = "gmt_npc_music",
		WindowTitle = "Music Store",
		Logo = "songbirds",
		ModelSize = 300,
		CameraZPos = 10,
	},
	[50] = {
		NpcClass = nil -- Handled internally
	},
}
