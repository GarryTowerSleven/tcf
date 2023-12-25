// ENUMS
GTowerStore.SUITE 		= 1
GTowerStore.HAT 		= 2
GTowerStore.PVPBATTLE 	= 3
GTowerStore.BAR 		= 4
GTowerStore.BALLRACE 	= 5
GTowerStore.SOUVENIR 	= 6
GTowerStore.ELECTRONIC 	= 7
GTowerStore.MERCHANT 	= 8
GTowerStore.VIP 		= 9
GTowerStore.HOLIDAY 	= 10
GTowerStore.BUILDING 	= 11
GTowerStore.VENDING 	= 17
GTowerStore.PLAYERMODEL = 13
GTowerStore.FIREWORKS 	= 14
GTowerStore.POSTERS 	= 15
GTowerStore.BASICAL		= 16
GTowerStore.FOOD		= 25
GTowerStore.DUEL		= 24
GTowerStore.HALLOWEEN	= 19
GTowerStore.PARTICLES	= 23
GTowerStore.CASINOCHIPS	= 20
GTowerStore.NATURE		= 29
GTowerStore.TOY 		= 22
GTowerStore.THANKSGIVING = 18
GTowerStore.PET 		= 26
GTowerStore.MUSIC		= 27
GTowerStore.BEACH		= 28
GTowerStore.BATHROOM	= 21
GTowerStore.MONEY		= 30
GTowerStore.CONDO		= 50
GTowerStore.ROOM		= 51
GTowerStore.RABBIT		= 69

// Definitions
GTowerStore.Stores = {
	[GTowerStore.SUITE] = {
		NpcClass = "gmt_npc_suitesell",
		WindowTitle = "Furniture Store",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 30,
		CameraFar = 100
	},
	[GTowerStore.HAT] = {
		NpcClass = "gmt_npc_hat",
		WindowTitle = "Hat Store",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 5,
		CameraFar = 25
	},
	[GTowerStore.PVPBATTLE] = {
		NpcClass = "gmt_npc_pvpbattle",
		WindowTitle = "PVP Battle Upgrades",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 5,
		CameraFar = 25
	},
	[GTowerStore.BAR] = {
		NpcClass = "gmt_npc_bar",
		WindowTitle = "Bar Lady",
	},
	[GTowerStore.BALLRACE] = {
		NpcClass = "gmt_npc_ballracer",
		WindowTitle = "Ball Racer Store",
	},
	[GTowerStore.SOUVENIR] = {
		NpcClass = "gmt_npc_souvenir",
		WindowTitle = "Souvenir Store",
		ModelStore = true,
	},
	[GTowerStore.ELECTRONIC] = {
		NpcClass = "gmt_npc_electronic",
		WindowTitle = "Electronic Store",
		ModelStore = true,
	},
	[GTowerStore.NATURE] = {
		NpcClass = "gmt_npc_nature",
		WindowTitle = "Nature Store",
		ModelStore = true,
	},
	[GTowerStore.MERCHANT] = {
		NpcClass = "gmt_npc_merchant",
		WindowTitle = "Wandering Merchant",
	},
	[GTowerStore.VIP] = {
		NpcClass = "gmt_npc_vip",
		WindowTitle = "VIP Store"
	},
	[GTowerStore.MONEY] = {
		NpcClass = "gmt_npc_money",
		WindowTitle = "Money Giver"
	},
	[GTowerStore.HOLIDAY] = {
		NpcClass = "gmt_presentsack",
		WindowTitle = "Happy Holidays!",
		ModelStore = true,
	},
	[GTowerStore.BUILDING] = {
		NpcClass = "gmt_npc_building",
		WindowTitle = "Building Blocks Store",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 5,
		CameraFar = 100
	},
	[GTowerStore.BASICAL] = {
		NpcClass = "gmt_npc_basical",
		WindowTitle = "Basical's Goods",
		ModelStore = true,
		ModelSize = 400,
		CameraZPos = 15,
	},
	[GTowerStore.VENDING] = {
		NpcClass = "gmt_vending_machine",
		WindowTitle = "Vending Machine",
	},
	[GTowerStore.PLAYERMODEL] = {
		NpcClass = "gmt_npc_models",
		WindowTitle = "Player Models",
		ModelStore = true,
		CameraZPos = 40,
		CameraFar = 80
	},
	[GTowerStore.RABBIT] = {
		NpcClass = "gmt_npc_rabbit",
		WindowTitle = "Rabbits!",
		ModelStore = true,
		ModelSize = 700,
		CameraZPos = 45,
	},
	[GTowerStore.FIREWORKS] = {
		NpcClass = "gmt_npc_fireworks",
		WindowTitle = "Fireworks Store",
		ModelStore = true,
	},
	[GTowerStore.POSTERS] = {
		NpcClass = "gmt_npc_posters",
		WindowTitle = "Poster Store",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 30,
		CameraFar = 60
	},
	[GTowerStore.FOOD] = {
		NpcClass = "gmt_npc_food",
		WindowTitle = "Smoothie Bar",
	},
	[GTowerStore.DUEL] = {
		NpcClass = "gmt_npc_duel",
		WindowTitle = "Duels",
	},
	[GTowerStore.HALLOWEEN] = {
		NpcClass = "gmt_npc_halloween",
		WindowTitle = "Spooky Scary Halloween",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 35,
		CameraFar = 60
	},
	[GTowerStore.BEACH] = {
		NpcClass = "gmt_npc_beach",
		WindowTitle = "Beach Store",
		ModelSize = 400,
		CameraZPos = 25,
	},
	[GTowerStore.PARTICLES] = {
		NpcClass = "gmt_npc_particles",
		WindowTitle = "Particles",
	},
	[GTowerStore.CASINOCHIPS] = {
		NpcClass = "gmt_npc_casinochips",
		WindowTitle = "Tower Casino",
	},
	[GTowerStore.TOY] = {
		NpcClass = "gmt_npc_toys",
		WindowTitle = "Toys and Gizmos",
	},
	[GTowerStore.PET] = {
		NpcClass = "gmt_npc_pet",
		WindowTitle = "Pets",
		ModelStore = true,
		ModelSize = 1000,
		CameraZPos = 10,
	},
	[GTowerStore.MUSIC] = {
		NpcClass = "gmt_npc_music",
		WindowTitle = "Music Store",
	},
	[GTowerStore.BATHROOM] = {
		NpcClass = "gmt_npc_bathroom",
		WindowTitle = "Bathroom Attendant",
	},

	[GTowerStore.ROOM] = {
		NpcClass = "gmt_npc_roomlady",
		WindowTitle = "Suite Lady",
	},
	
	[GTowerStore.THANKSGIVING] = {
		NpcClass = "gmt_npc_thanksgiving",
		WindowTitle = "Thanksgiving",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 10,
		CameraFar = 25
	},
	[GTowerStore.CONDO] = {
		NpcClass = nil -- Handled internally
	},
}
