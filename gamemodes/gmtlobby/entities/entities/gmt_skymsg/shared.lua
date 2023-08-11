ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Model			= ""

ENT.Messages = {
	[1] = "",
	[2] = "Gamemode Ports",
	[3] = "Entertainment Plaza",
	[4] = "Suite Floor",
	[5] = "Suites 1-5",
	[6] = "Suites 6-10",
	[7] = "Arcade",
	[8] = "Teleporters",
	[9] = "Lobby",
	[10] = "Resturant",
	[11] = "Ball Race",
	[12] = "Action Genre",
	[13] = "PVP Battle",
	[14] = "Stealth - Coming Soon",
	[15] = "Coming Soon",
	[16] = "GMT: Adventure",
	[17] = "Stealth",
	[18] = "Puzzle: Impossible",
	[19] = "Tetris",
	[20] = "Bar",
	[21] = "Theatre",
	[22] = "Party Suite",
	[23] = "The Gallery",
	[24] = "Twist of the Mind",
	[25] = "Mini-Golf",
	[26] = "Monotone",
	[27] = "Harvest",
	[28] = "Furniture Store",
	[29] = "Hat Store",
	[30] = "Souvenir Store",
	[31] = "Electronic Store",
	[32] = "Conquest",
	[33] = {Name = "Chainsaw Battle!", IgnoreTrace = true, Color = Color( 255, 0, 0, 255 ) },
	[34] = {Name = "Blizzard Storm!", IgnoreTrace = true, Color = Color( 215, 255, 255, 255 ) },
	[35] = "Virus",
	[36] = "Chimera Hunt",
	[37] = "PVP Battle",
	[38] = "Source Karts",
	[39] = "Gourmet Race",
	[40] = "Ultimate Chimera Hunt",
	[41] = "Zombie Massacre",
	[42] = "Suites 1 - 9",
	[44] = "Suites 10 - 18",
	[45] = "Building Store",
	[46] = "Smoothie Bar",
	[47] = "Casino",
	[48] = {Name = "Bar Fight!", IgnoreTrace = true, Color = Color( 215, 0, 0, 255 ) },
}

// Add to this table to override the current messages
ENT.OverrideMessages = {
	[40] = "Chimera Hunt",
	[16] = "",
	[17] = "Metroid: Deathmatch",
	[18] = "Virus",
	[23] = "Gourmet Race",
	[24] = "Zombie Massacre",
	[25] = "Minigolf",
	[29] = "Appearance Store",
	[36] = "Monotone",
	[46] = "Restaurant",
	[43] = "Suites 16 - 24",
	[44] = "Suites 10 - 15",
	[30] = "General Goods",
	[32] = "",
}

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data,phys)
end