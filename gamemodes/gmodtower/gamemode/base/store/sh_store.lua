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
GTowerStore.FOOD		= 25
GTowerStore.DUEL		= 24
GTowerStore.HALLOWEEN	= 19
GTowerStore.PARTICLES	= 23
GTowerStore.CASINOCHIPS	= 20
GTowerStore.TOY 		= 22
GTowerStore.THANKSGIVING = 18
GTowerStore.PET 		= 26
GTowerStore.MUSIC		= 27
GTowerStore.BATHROOM	= 21
GTowerStore.MONEY		= 30
GTowerStore.CONDO		= 50

// Definitions
GTowerStore.Stores = {
	[GTowerStore.SUITE] = {
		NpcClass = "gmt_npc_suitesell",
		WindowTitle = "Furniture Store",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 30,
		CameraFar = 100,
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
		WindowTitle = "Pulse Nightclub Bar"
	},
	[GTowerStore.BALLRACE] = {
		NpcClass = "gmt_npc_ballracer",
		WindowTitle = "Ball Race Customizables",
	},
	[GTowerStore.SOUVENIR] = {
		NpcClass = "gmt_npc_souvenir",
		WindowTitle = "Decorations"
	},
	[GTowerStore.ELECTRONIC] = {
		NpcClass = "gmt_npc_electronic",
		WindowTitle = "Central Circuit"
	},
	[GTowerStore.MERCHANT] = {
		NpcClass = "gmt_npc_merchant",
		WindowTitle = "Wandering Merchant",
		ModelStore = false
		/*ModelSize = 600,
		CameraZPos = 10,
		CameraFar = 30*/
	},
	[GTowerStore.VIP] = {
		NpcClass = "gmt_npc_vip",
		WindowTitle = "VIP"
	},
	[GTowerStore.MONEY] = {
		NpcClass = "gmt_npc_money",
		WindowTitle = "Money Giver"
	},
	[GTowerStore.HOLIDAY] = {
		NpcClass = "gmt_presentbag",
		WindowTitle = "Happy Holidays!"
	},
	[GTowerStore.BUILDING] = {
		NpcClass = "gmt_npc_building",
		WindowTitle = "Building Sets",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 5,
		CameraFar = 100
	},
	[GTowerStore.VENDING] = {
		NpcClass = "gmt_vending_machine",
		WindowTitle = "Vending Machine"
	},
	[GTowerStore.PLAYERMODEL] = {
		NpcClass = "gmt_npc_models",
		WindowTitle = "Player Models",
		ModelStore = true,
		CameraZPos = 40,
		CameraFar = 80
	},
	[GTowerStore.FIREWORKS] = {
		NpcClass = "gmt_npc_fireworks",
		WindowTitle = "Fireworks",
	},
	[GTowerStore.POSTERS] = {
		NpcClass = "gmt_npc_posters",
		WindowTitle = "Posters",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 30,
		CameraFar = 60
	},
	[GTowerStore.FOOD] = {
		NpcClass = "gmt_npc_food",
		WindowTitle = "Smoothies Stand",
	},
	[GTowerStore.DUEL] = {
		NpcClass = "gmt_npc_duel",
		WindowTitle = "Dueling Arena",
	},
	[GTowerStore.HALLOWEEN] = {
		NpcClass = "gmt_npc_halloween",
		WindowTitle = "Spooky Scary Halloween",
		ModelStore = true,
		ModelSize = 600,
		CameraZPos = 35,
		CameraFar = 60
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
	},
	[GTowerStore.MUSIC] = {
		NpcClass = "gmt_npc_music",
		WindowTitle = "Songbirds",
	},
	[GTowerStore.BATHROOM] = {
		NpcClass = "gmt_npc_bathroom",
		WindowTitle = "Bathroom Attendant",
	},
	
	[GTowerStore.CONDO] = {
		NpcClass = nil -- Handled internally
	},
}