DeriveGamemode("darkrp")

function InCondo(pos)
    return pos.z > 11000
end

function CanBuild(ply)
    ply = ply or LocalPlayer()
    return !IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass() ~= "weapon_physgun"
end

function GM:SpawnMenuOpen()
    if CanBuild(ply) then
        notification.AddLegacy("Build in a Condo, or find Building Supplies!", NOTIFY_ERROR, 8)
        return false
    end

    return true
end

function GM:ContextMenuOpen()
    return false
end

ACHIEVEMENTS = {}
ACHIEVEMENTS.AddAchievement = function() end

local meta = FindMetaTable("Player")
local meta2 = FindMetaTable("Entity")

meta.AddAchievement = function() end

string.FormatNumber = string.Comma

meta.Afford = meta.canAfford

meta.AddMoney = meta.addMoney

meta.MsgI = function(self, _, msg)
    self:ChatPrint(msg)
end

meta.Location = function(self)
    return self:GetNWInt("Location")
end

meta.OldNick = meta.OldNick or meta.Nick

meta.Nick = function(self)
    return Location.GetFriendlyName(self:Location()) .. " | " .. self:OldNick()
end

meta.GetCondoID = function()
    return 0
end

meta2.GetCondoID = function()
    return 0
end

local meta3 = FindMetaTable("Vector")
meta3.WithinDistance = function() end

Locations =  {
	[1] = {
		Regions = {
			[1] = {
				max = Vector(1581,10584,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -102,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -8416,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 1581,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 10584,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(102,8416,14450),
			},
		},
		FriendlyName = "Condo #1",
		CondoID = 1,
		Name = "condo1",
		Priority = 0,
		Group = "condos",
	},
	[2] = {
		Regions = {
			[1] = {
				max = Vector(1581,15192,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -102,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -13024,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 1581,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 15192,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(102,13024,14450),
			},
		},
		FriendlyName = "Condo #2",
		CondoID = 2,
		Name = "condo2",
		Priority = 0,
		Group = "condos",
	},
	[3] = {
		Regions = {
			[1] = {
				max = Vector(-3027,15192,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4506,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -13024,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = -3027,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 15192,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(-4506,13024,14450),
			},
		},
		FriendlyName = "Condo #3",
		CondoID = 3,
		Name = "condo3",
		Priority = 0,
		Group = "condos",
	},
	[4] = {
		Regions = {
			[1] = {
				max = Vector(-7635,15192,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 9114,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -13024,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = -7635,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 15192,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(-9114,13024,14450),
			},
		},
		FriendlyName = "Condo #4",
		CondoID = 4,
		Name = "condo4",
		Priority = 0,
		Group = "condos",
	},
	[5] = {
		Regions = {
			[1] = {
				max = Vector(-12243,15192,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 13722,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -13024,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = -12243,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 15192,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(-13722,13024,14450),
			},
		},
		FriendlyName = "Condo #5",
		CondoID = 5,
		Name = "condo5",
		Priority = 0,
		Group = "condos",
	},
	[6] = {
		Regions = {
			[1] = {
				max = Vector(-3027,10584,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4506,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -8416,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = -3027,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 10584,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(-4506,8416,14450),
			},
		},
		FriendlyName = "Condo #6",
		CondoID = 6,
		Name = "condo6",
		Priority = 0,
		Group = "condos",
	},
	[7] = {
		Regions = {
			[1] = {
				max = Vector(6189,15192,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -4710,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -13024,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 6189,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 15192,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(4710,13024,14450),
			},
		},
		FriendlyName = "Condo #7",
		CondoID = 7,
		Name = "condo7",
		Priority = 0,
		Group = "condos",
	},
	[8] = {
		Regions = {
			[1] = {
				max = Vector(10797,15192,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -9318,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -13024,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 10797,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 15192,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(9318,13024,14450),
			},
		},
		FriendlyName = "Condo #8",
		CondoID = 8,
		Name = "condo8",
		Priority = 0,
		Group = "condos",
	},
	[9] = {
		Regions = {
			[1] = {
				max = Vector(6189,10584,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -4710,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -8416,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 6189,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 10584,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(4710,8416,14450),
			},
		},
		FriendlyName = "Condo #9",
		CondoID = 9,
		Name = "condo9",
		Priority = 0,
		Group = "condos",
	},
	[10] = {
		Regions = {
			[1] = {
				max = Vector(10797,10584,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -9318,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -8416,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 10797,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 10584,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(9318,8416,14450),
			},
		},
		FriendlyName = "Condo #10",
		CondoID = 10,
		Name = "condo10",
		Priority = 0,
		Group = "condos",
	},
	[11] = {
		Regions = {
			[1] = {
				max = Vector(15405,15192,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -13926,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -13024,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 15405,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 15192,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(13926,13024,14450),
			},
		},
		FriendlyName = "Condo #11",
		CondoID = 11,
		Name = "condo11",
		Priority = 0,
		Group = "condos",
	},
	[12] = {
		Regions = {
			[1] = {
				max = Vector(15405,10584,15016),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -13926,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -8416,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = -14450,
					},
					[4] = {
						normal = Vector(1,0,0),
						dist = 15405,
					},
					[5] = {
						normal = Vector(0,1,0),
						dist = 10584,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15016,
					},
				},
				min = Vector(13926,8416,14450),
			},
		},
		FriendlyName = "Condo #12",
		CondoID = 12,
		Name = "condo12",
		Priority = 0,
		Group = "condos",
	},
	[13] = {
		Regions = {
			[1] = {
				max = Vector(7872,896,-320),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -7072,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 7872,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 896,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 896,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 608,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -320,
					},
				},
				min = Vector(7072,-896,-608),
			},
		},
		FriendlyName = "Tower Elevators Lobby",
		Name = "towerelevators",
		Priority = 2,
		Group = "lobby",
	},
	[14] = {
		Regions = {
			[1] = {
				max = Vector(9216,1568,1024),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -6112,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 9216,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 1568,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1568,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 608,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 1024,
					},
				},
				min = Vector(6112,-1568,-608),
			},
		},
		FriendlyName = "Tower Lobby",
		Name = "towerlobby",
		Priority = 1,
		Group = "lobby",
	},
	[15] = {
		Regions = {
			[1] = {
				max = Vector(3455.9899902344,768,-896),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1920,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 3455.9899902344,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 768,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 768,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 992,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -896,
					},
				},
				min = Vector(1920,-768,-992),
			},
		},
		FriendlyName = "Center Plaza",
		Name = "centerplaza",
		Priority = 1,
		Group = "plaza",
	},
	[16] = {
		Regions = {
			[1] = {
				max = Vector(6136,3240,-36),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1024,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 6136,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 3328,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 3240,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 1024,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -36,
					},
				},
				min = Vector(1024,-3328,-1024),
			},
		},
		FriendlyName = "Plaza",
		Name = "plaza",
		Priority = 0,
		Group = "plaza",
	},
	[17] = {
		Regions = {
			[1] = {
				max = Vector(1023.9949951172,1440,-36),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 1856.0050048828,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 1023.9949951172,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 1448,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1440,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 966.10906982422,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -36,
					},
				},
				min = Vector(-1856.0050048828,-1448,-966.10906982422),
			},
		},
		FriendlyName = "Stores",
		Name = "stores",
		Priority = 0,
		Group = "stores",
	},
	[18] = {
		Regions = {
			[1] = {
				max = Vector(1960,1960,-608),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1656,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 1960,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -1536,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1960,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 864,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -608,
					},
				},
				min = Vector(1656,1536,-864),
			},
			[2] = {
				max = Vector(2856,3232,-608),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1592,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2856,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -1960,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 3232,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 864,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -608,
					},
				},
				min = Vector(1592,1960,-864),
			},
		},
		FriendlyName = "Arcade Loft",
		Name = "arcadeloft",
		Priority = 1,
		Group = "plaza",
	},
	[19] = {
		Regions = {
			[1] = {
				max = Vector(240,2240,-372),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 472,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 240,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -1440,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 2240,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 672,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -372,
					},
				},
				min = Vector(-472,1440,-672),
			},
			[2] = {
				max = Vector(-191.99995422363,1440,-484),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = -1392,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = 1440,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 672,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -484,
					},
					[5] = {
						normal = Vector(-0.44721359014511,-0.89442718029022,0),
						dist = -1073.3125890525,
					},
					[6] = {
						normal = Vector(0.44721359014511,-0.89442718029022,0),
						dist = -1373.84012163,
					},
				},
				min = Vector(-479.99990844727,1392,-672),
			},
			[3] = {
				max = Vector(240.00007629395,1440,-484),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = -1392,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = 1440,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 672,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -484,
					},
					[5] = {
						normal = Vector(-0.44721359014511,-0.89442718029022,0),
						dist = -1266.5088668191,
					},
					[6] = {
						normal = Vector(0.44721359014511,-0.89442718029022,0),
						dist = -1180.6438438634,
					},
				},
				min = Vector(-47.999851226807,1392,-672),
			},
		},
		FriendlyName = "Tower Outfitters",
		Name = "toweroutfitters",
		Priority = 1,
		Group = "stores",
	},
	[20] = {
		Regions = {
			[1] = {
				max = Vector(1032,2296,-432),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -288,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 1032,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -1440,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 2296,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 671.08898925781,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -432,
					},
				},
				min = Vector(288,1440,-671.08898925781),
			},
			[2] = {
				max = Vector(584.00018310547,1440,-480),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = -1394,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = 1440,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 668,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
					[5] = {
						normal = Vector(-0.44721359014511,-0.89442718029022,0),
						dist = -1423.9280983178,
					},
					[6] = {
						normal = Vector(0.47165223956108,-0.88178461790085,0),
						dist = -994.32491145497,
					},
				},
				min = Vector(304.00015258789,1393.9998779297,-668),
			},
			[3] = {
				max = Vector(1007.9999389648,1440,-480),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = -1394,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = 1440,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 668,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
					[5] = {
						normal = Vector(-0.47165223956108,-0.88178461790085,0),
						dist = -1613.1326641528,
					},
					[6] = {
						normal = Vector(0.44721359014511,-0.89442718029022,0),
						dist = -837.1838680474,
					},
				},
				min = Vector(727.99987792969,1393.9998779297,-668),
			},
		},
		FriendlyName = "Toy Stop and Pets",
		Name = "toyfactory",
		Priority = 1,
		Group = "stores",
	},
	[21] = {
		Regions = {
			[1] = {
				max = Vector(-288,-796,-696),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 720,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -288,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 1472,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -796,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -696,
					},
				},
				min = Vector(-720,-1472,-896),
			},
			[2] = {
				max = Vector(-704,-544,-432),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 2048,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -704,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 1472,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -544,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -432,
					},
					[7] = {
						normal = Vector(-0.69810020923615,0.71600019931793,0),
						dist = 816.81312381997,
					},
				},
				min = Vector(-2048,-1472,-896.00006103516),
			},
		},
		FriendlyName = "Sweet Suite Furnishings",
		Name = "sweetsuites",
		Priority = 1,
		Group = "stores",
	},
	[22] = {
		Regions = {
			[1] = {
				max = Vector(256,-1440,-428.02304077148),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 672,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 256,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 2208,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -1440,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 672,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -428.02304077148,
					},
				},
				min = Vector(-672,-2208,-672),
			},
			[2] = {
				max = Vector(240.00007629395,-1392,-483),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = 1440,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = -1392,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 671,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -483,
					},
					[5] = {
						normal = Vector(0.44721359014511,0.89442718029022,0),
						dist = -1180.6438404514,
					},
					[6] = {
						normal = Vector(-0.44721359014511,0.89442718029022,0),
						dist = -1266.5087371643,
					},
				},
				min = Vector(-48.00012588501,-1440,-671),
			},
			[3] = {
				max = Vector(-191.99995422363,-1392,-483),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = 1440,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = -1392,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 671,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -483,
					},
					[5] = {
						normal = Vector(0.44721359014511,0.89442718029022,0),
						dist = -1373.8401079822,
					},
					[6] = {
						normal = Vector(-0.44721359014511,0.89442718029022,0),
						dist = -1073.3124662216,
					},
				},
				min = Vector(-480.00015258789,-1440,-671),
			},
		},
		FriendlyName = "Central Circuit",
		Name = "centralcircuit",
		Priority = 1,
		Group = "stores",
	},
	[23] = {
		Regions = {
			[1] = {
				max = Vector(2856,-1960,-576),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1784,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2856,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 3000,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -1960,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 864,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -576,
					},
					[7] = {
						normal = Vector(0.82958781719208,0.55837643146515,0),
						dist = 1209.6509515979,
					},
					[8] = {
						normal = Vector(0.19302186369896,0.98119449615479,0),
						dist = -1402.7541293259,
					},
					[9] = {
						normal = Vector(0.55837643146515,0.82958781719208,0),
						dist = -96.503195311481,
					},
					[10] = {
						normal = Vector(0.98119449615479,0.19302186369896,0),
						dist = 2393.084942556,
					},
				},
				min = Vector(1784,-3000,-864.00006103516),
			},
		},
		FriendlyName = "Casino Loft",
		Name = "casinoloft",
		Priority = 1,
		Group = "",
	},
	[24] = {
		Regions = {
			[1] = {
				max = Vector(3860,-9220,-2288),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -2150,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 3860,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 11780,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -9220,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 2648,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -2288,
					},
				},
				min = Vector(2150,-11780,-2648),
			},
		},
		FriendlyName = "Casino",
		Name = "casino",
		Priority = 0,
		Group = "",
	},
	[25] = {
		Regions = {
			[1] = {
				max = Vector(2880,-4304,-2240),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1472,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2880,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 5760,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -4304,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 2688,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -2240,
					},
				},
				min = Vector(1472,-5760,-2688),
			},
		},
		FriendlyName = "Pulse Nightclub",
		Name = "nightclub",
		Priority = 0,
		Group = "nightclub",
	},
	[26] = {
		Regions = {
			[1] = {
				max = Vector(2144,-4304,-2240),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1472,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2144,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 4736,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -4304,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 2688,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -2240,
					},
					[7] = {
						normal = Vector(0.44721359014511,-0.89442718029022,0),
						dist = 5123.2791616599,
					},
				},
				min = Vector(1472,-4736,-2688),
			},
			[2] = {
				max = Vector(2624,-4304,-2240),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -2144,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2624,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 4656,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -4304,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 2688,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -2240,
					},
				},
				min = Vector(2144,-4656,-2688),
			},
		},
		FriendlyName = "Pulse Nightclub Bar",
		Name = "nightclubbar",
		Priority = 1,
		Group = "nightclub",
	},
	[27] = {
		Regions = {
			[1] = {
				max = Vector(7072.009765625,-3440,176),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1456.0200195313,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 7072.009765625,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 6256,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -3440,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 176,
					},
				},
				min = Vector(1456.0200195313,-6256,-896),
			},
		},
		FriendlyName = "Games",
		Name = "games",
		Priority = 0,
		Group = "games",
	},
	[28] = {
		Regions = {
			[1] = {
				max = Vector(250,1886,15711),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4294,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 250,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 1006,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1886,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = -14983,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15711,
					},
				},
				min = Vector(-4294,-1006,14983),
			},
		},
		FriendlyName = "Tower Condos Lobby",
		Name = "condolobby",
		Priority = 0,
		Group = "condos",
	},
	[29] = {
		Regions = {
			[1] = {
				max = Vector(4981.759765625,64,-2816),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -3313.759765625,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 4981.759765625,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 1472,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 64,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 3584,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -2816,
					},
				},
				min = Vector(3313.759765625,-1472,-3584),
			},
		},
		FriendlyName = "Duel Arena Lobby",
		Name = "duels",
		Priority = 0,
		Group = "",
	},
	[30] = {
		Regions = {
			[1] = {
				max = Vector(8056,-407,-480),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -7864,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 8056,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 600,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -407,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 608,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
				},
				min = Vector(7864,-600,-608),
			},
			[2] = {
				max = Vector(8056,601,-480),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -7864,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 8056,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -408,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 601,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 608,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
				},
				min = Vector(7864,408,-608),
			},
			[3] = {
				max = Vector(7544,600,-480),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -7352,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 7544,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -407,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 600,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 608,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
				},
				min = Vector(7352,407,-608),
			},
			[4] = {
				max = Vector(7544,-407,-480),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -7352,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 7544,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 600,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -407,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 608,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
				},
				min = Vector(7352,-600,-608),
			},
			[5] = {
				max = Vector(-1670,1687,15111),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 1862,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -1670,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -1494,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1687,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = -14983,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15111,
					},
				},
				min = Vector(-1862,1494,14983),
			},
			[6] = {
				max = Vector(-1670,1063,15111),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 1862,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -1670,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -870,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1063,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = -14983,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15111,
					},
				},
				min = Vector(-1862,870,14983),
			},
			[7] = {
				max = Vector(-2182,1687,15111),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 2374,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -2182,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -1494,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1687,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = -14983,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15111,
					},
				},
				min = Vector(-2374,1494,14983),
			},
			[8] = {
				max = Vector(-2182,1063,15111),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 2374,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -2182,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -870,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1063,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = -14983,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 15111,
					},
				},
				min = Vector(-2374,870,14983),
			},
		},
		FriendlyName = "Condo Elevator",
		Name = "elevator",
		Priority = 3,
		Group = "elevators",
	},
	[31] = {
		Regions = {
			[1] = {
				max = Vector(5296,4492,-480),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -3504,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 5296,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -3240,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 4492,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
				},
				min = Vector(3504,3240,-896),
			},
		},
		FriendlyName = "Theater Main",
		Name = "theatermain",
		Priority = 1,
		Group = "theater",
	},
	[32] = {
		Regions = {
			[1] = {
				max = Vector(4112,5864,-2304),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -2852,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 4112,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -4896,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 5864,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 2944,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -2304,
					},
				},
				min = Vector(2852,4896,-2944),
			},
		},
		FriendlyName = "Theater 1",
		Name = "theater1",
		Priority = 1,
		Group = "theater",
	},
	[33] = {
		Regions = {
			[1] = {
				max = Vector(5952,5864,-2304),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -4688,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 5952,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -4896,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 5864,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 2944,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -2304,
					},
				},
				min = Vector(4688,4896,-2944),
			},
		},
		FriendlyName = "Theater 2",
		Name = "theater2",
		Priority = 1,
		Group = "theater",
	},
	[34] = {
		Regions = {
			[1] = {
				max = Vector(4682,4492,-480),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -4118,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 4682,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -4110,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 4492,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -480,
					},
				},
				min = Vector(4118,4110,-896),
			},
		},
		FriendlyName = "Theater Game Room",
		Name = "theaterarcade",
		Priority = 2,
		Group = "theater",
	},
	[35] = {
		Regions = {
			[1] = {
				max = Vector(4816,-2944,-544),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -3984,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 4816,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 3968,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -2944,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -544,
					},
				},
				min = Vector(3984,-3968,-896),
			},
		},
		FriendlyName = "Games Lobby",
		Name = "gameslobby",
		Priority = 1,
		Group = "",
	},
	[36] = {
		Regions = {
			[1] = {
				max = Vector(1024,-1440,-428.00106811523),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -288,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 1024,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 2208,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -1440,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 671.97802734375,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -428.00106811523,
					},
				},
				min = Vector(288,-2208,-671.97802734375),
			},
			[2] = {
				max = Vector(592.00012207031,-1395,-484),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = 1443,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = -1395,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 672,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -484,
					},
					[5] = {
						normal = Vector(0.44721359014511,0.89442718029022,0),
						dist = -1025.9079348493,
					},
					[6] = {
						normal = Vector(-0.44721359014511,0.89442718029022,0),
						dist = -1426.6112024363,
					},
				},
				min = Vector(303.99960327148,-1443,-672),
			},
			[3] = {
				max = Vector(1024.0001220703,-1395,-484),
				planes = {
					[1] = {
						normal = Vector(0,-1,0),
						dist = 1443,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = -1395,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 672,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = -484,
					},
					[5] = {
						normal = Vector(0.44721359014511,0.89442718029022,0),
						dist = -832.71167755445,
					},
					[6] = {
						normal = Vector(-0.44721359014511,0.89442718029022,0),
						dist = -1619.8074597311,
					},
				},
				min = Vector(735.99963378906,-1443,-672),
			},
		},
		FriendlyName = "Songbirds",
		Name = "songbirds",
		Priority = 1,
		Group = "stores",
	},
	[37] = {
		Regions = {
			[1] = {
				max = Vector(7512.0004882813,703.99993896484,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -5720,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 7512,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 704.00006103516,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 703.99993896484,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 1328,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
					[7] = {
						normal = Vector(0.001917123910971,0.49717572331429,0.86764770746231),
						dist = -385.23242472352,
					},
					[8] = {
						normal = Vector(0,-0.51711565256119,0.85591554641724),
						dist = -382.30893789452,
					},
				},
				min = Vector(5720,-704.00006103516,-1328),
			},
			[2] = {
				max = Vector(5720,271.9997253418,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -5384,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 5720,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 272.0002746582,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 271.9997253418,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 928,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(5384,-272.0002746582,-928),
			},
		},
		FriendlyName = "Transit Station",
		Name = "transit",
		Priority = 1,
		Group = "transit",
	},
	[38] = {
		Regions = {
			[1] = {
				max = Vector(8832,1256,-1024),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -5424,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 8832,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -704,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1256,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 1328,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -1024,
					},
				},
				min = Vector(5424,704,-1328),
			},
		},
		FriendlyName = "Station A",
		Name = "transita",
		Priority = 0,
		Group = "transit",
	},
	[39] = {
		Regions = {
			[1] = {
				max = Vector(8832,-704,-1024),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -5424,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 8832,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 1256,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -704,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 1328,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -1024,
					},
				},
				min = Vector(5424,-1256,-1328),
			},
		},
		FriendlyName = "Station B",
		Name = "transitb",
		Priority = 0,
		Group = "transit",
	},
	[40] = {
		Regions = {
			[1] = {
				max = Vector(256,-5856,12544),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 9984,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 256,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 16096,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -5856,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = -2304,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 12544,
					},
				},
				min = Vector(-9984,-16096,2304),
			},
		},
		FriendlyName = "Duel Arena",
		Name = "duelarena",
		Priority = 0,
		Group = "",
	},
	[41] = {
		Regions = {
			[1] = {
				max = Vector(-1720,4351.9599609375,1032),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 8120,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -1720,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 5375.9794921875,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 4351.9599609375,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 1144,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 1032,
					},
				},
				min = Vector(-8120,-5375.9794921875,-1144),
			},
		},
		FriendlyName = "Boardwalk",
		Name = "boardwalk",
		Priority = 0,
		Group = "boardwalk",
	},
	[42] = {
		Regions = {
			[1] = {
				max = Vector(-1722,-454,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4858,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -1722,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 2496,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -454,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 952,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
				},
				min = Vector(-4858,-2496,-952),
			},
		},
		FriendlyName = "Pool",
		Name = "pool",
		Priority = 1,
		Group = "boardwalk",
	},
	[43] = {
		Regions = {
			[1] = {
				max = Vector(-6134,2110.3334960938,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 7178,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -6134,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -566,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 2110.3334960938,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
				},
				min = Vector(-7178,566,-896),
			},
		},
		FriendlyName = "Ferris Wheel",
		Name = "ferriswheel",
		Priority = 1,
		Group = "boardwalk",
	},
	[44] = {
		Regions = {
			[1] = {
				max = Vector(-3192,1408,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4920,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -3192,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 454,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 1408,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 1144,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
				},
				min = Vector(-4920,-454,-1144),
			},
			[2] = {
				max = Vector(-3191.9997558594,2110,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4920,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = -1408,
					},
					[3] = {
						normal = Vector(0,1,0),
						dist = 2110,
					},
					[4] = {
						normal = Vector(0,0,-1),
						dist = 1144,
					},
					[5] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
					[6] = {
						normal = Vector(0.70610022544861,0.70811188220978,0),
						dist = -1256.8503382268,
					},
				},
				min = Vector(-4920,1407.9998779297,-1144),
			},
			[3] = {
				max = Vector(-3208,-454,1280.0001220703),
				planes = {
					[1] = {
						normal = Vector(1,0,0),
						dist = -3208,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = 814,
					},
					[3] = {
						normal = Vector(0,1,0),
						dist = -454,
					},
					[4] = {
						normal = Vector(0,0,-1),
						dist = 1144,
					},
					[5] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
					[6] = {
						normal = Vector(-0.71500670909882,-0.69911766052246,0),
						dist = 3251.786836175,
					},
					[7] = {
						normal = Vector(0.70449268817902,-0.70971119403839,0),
						dist = -1873.9296608078,
					},
				},
				min = Vector(-4104,-814,-1144),
			},
			[4] = {
				max = Vector(-3752,-648.00006103516,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 3910,
					},
					[2] = {
						normal = Vector(0,-1,0),
						dist = 814,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 1144,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
					[5] = {
						normal = Vector(0.72434544563293,0.68943721055984,0),
						dist = -3278.946003139,
					},
				},
				min = Vector(-3910,-814,-1144),
			},
			[5] = {
				max = Vector(-4663.9995117188,-453.99996948242,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4858,
					},
					[2] = {
						normal = Vector(0,1,0),
						dist = -454,
					},
					[3] = {
						normal = Vector(0,0,-1),
						dist = 1144,
					},
					[4] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
					[5] = {
						normal = Vector(0.70710676908493,-0.70710676908493,0),
						dist = -2976.9194978476,
					},
				},
				min = Vector(-4858,-648.00018310547,-1144),
			},
		},
		FriendlyName = "Beach",
		Name = "beach",
		Priority = 2,
		Group = "boardwalk",
	},
	[45] = {
		Regions = {
			[1] = {
				max = Vector(-3768,-4480,136),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4472,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -3768,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 4864,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -4480,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 232,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 136,
					},
				},
				min = Vector(-4472,-4864,-232),
			},
		},
		FriendlyName = "Top of Water Slides",
		Name = "topofslides",
		Priority = 2,
		Group = "boardwalk",
	},
	[46] = {
		Regions = {
			[1] = {
				max = Vector(-4858,2109.9997558594,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 6134,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -4858,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 2304.0002441406,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 2109.9997558594,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 1144,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
				},
				min = Vector(-6134,-2304.0002441406,-1144),
			},
		},
		FriendlyName = "Ocean",
		Name = "ocean",
		Priority = 1,
		Group = "boardwalk",
	},
	[47] = {
		Regions = {
			[1] = {
				max = Vector(-1720,-2240,1280),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = 4858,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = -1720,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 4864,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -2240,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 952,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = 1280,
					},
				},
				min = Vector(-4858,-4864,-952),
			},
		},
		FriendlyName = "Water Slides",
		Name = "slides",
		Priority = 1,
		Group = "boardwalk",
	},
	[48] = {
		Regions = {
			[1] = {
				max = Vector(2144,-3984,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1888,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2144,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 4496,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -3984,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(1888,-4496,-896),
			},
		},
		FriendlyName = "Zombie Massacre Port",
		Name = "zombiemassacre",
		Priority = 1,
		Group = "games",
	},
	[49] = {
		Regions = {
			[1] = {
				max = Vector(2144,-5200,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -1888,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2144,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 5712,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -5200,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(1888,-5712,-896),
			},
		},
		FriendlyName = "Virus Port",
		Name = "virus",
		Priority = 1,
		Group = "games",
	},
	[50] = {
		Regions = {
			[1] = {
				max = Vector(2816,-5872,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -2304,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 2816,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 6128,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -5872,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(2304,-6128,-896),
			},
		},
		FriendlyName = "UCH Port",
		Name = "uch",
		Priority = 1,
		Group = "games",
	},
	[51] = {
		Regions = {
			[1] = {
				max = Vector(3680.1899414063,-5872.2202148438,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -3168.1899414063,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 3680.1899414063,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 6128.2202148438,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -5872.2202148438,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(3168.1899414063,-6128.2202148438,-896),
			},
		},
		FriendlyName = "Ball Race Port",
		Name = "ballrace",
		Priority = 1,
		Group = "games",
	},
	[52] = {
		Regions = {
			[1] = {
				max = Vector(5632,-5872,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -5120,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 5632,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 6128,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -5872,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(5120,-6128,-896),
			},
		},
		FriendlyName = "PVP Battle Port",
		Name = "pvpbattle",
		Priority = 1,
		Group = "games",
	},
	[53] = {
		Regions = {
			[1] = {
				max = Vector(6496,-5872,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -5984,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 6496,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 6128,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -5872,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(5984,-6128,-896),
			},
		},
		FriendlyName = "Source Karts Port",
		Name = "sourcekarts",
		Priority = 1,
		Group = "games",
	},
	[54] = {
		Regions = {
			[1] = {
				max = Vector(6912,-5200,-640),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -6656,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 6912,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = 5712,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = -5200,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 896,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -640,
					},
				},
				min = Vector(6656,-5712,-896),
			},
		},
		FriendlyName = "Minigolf Port",
		Name = "minigolf",
		Priority = 1,
		Group = "games",
	},
	[55] = {
		Regions = {
			[1] = {
				max = Vector(3121, 3225, -532),
				planes = {
					[1] = {
						normal = Vector(-1,0,0),
						dist = -2855,
					},
					[2] = {
						normal = Vector(1,0,0),
						dist = 3121,
					},
					[3] = {
						normal = Vector(0,-1,0),
						dist = -3046,
					},
					[4] = {
						normal = Vector(0,1,0),
						dist = 3225,
					},
					[5] = {
						normal = Vector(0,0,-1),
						dist = 913,
					},
					[6] = {
						normal = Vector(0,0,1),
						dist = -532,
					},
				},
				min = Vector(2855, 3046, -913),
			},
		},
		FriendlyName = "???",
		Name = "secret1",
		Priority = 1,
		Group = "plaza",
	},
} 
Location = {}
Location.Find = function( pos )

	local currentLocation = 0
	local highestPriority = -1

	for id, loc in ipairs( Locations ) do

		-- Go through regions of a location

		for rid, region in ipairs( loc.Regions ) do

			if region.planes then

				--quick aabb reject
				if InBox( pos, region.min, region.max ) then
					local inside = true

					--test against each plane
					for i=1, #region.planes do
						local plane = region.planes[i]
						if pos:Dot(plane.normal) - plane.dist > 0 then
							inside = false
						end
					end

					-- Are we in it and is it highest priority?
					if inside and loc.Priority > highestPriority then
						highestPriority = loc.Priority
						currentLocation = id
					end

				end

			else
				-- Are we in it and is it highest priority?
				if InBox( pos, region.Min, region.Max ) and loc.Priority > highestPriority then
					highestPriority = loc.Priority
					currentLocation = id

					--if DEBUG then MsgN( "assn[" .. id .. " -> " .. rid .. "]: " .. loc.Name ) end
				end

			end

		end

	end

	return currentLocation

end

function InBox( pos, vec1, vec2 )
	return pos.x >= vec1.x && pos.x <= vec2.x &&
		pos.y >= vec1.y && pos.y <= vec2.y &&
		pos.z >= vec1.z && pos.z <= vec2.z
end

Location.GetCondoID = function() return 0 end
Location.Is = function() return 0 end
Location.Get = function() return end

function Location.GetByName( name )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.Name == name then
			return loc
		end

	end

end

function Location.GetIDByName( name )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.Name == name then
			return id
		end

	end

end

function Location.GetByCondoID( condoid )

	for id, loc in pairs( Locations ) do

		-- Found a matching existing location
		if loc.CondoID == condoid then
			return id
		end

	end

end

function Location.GetCondoID( location )

	local loc = Location.Get( location )
	if loc then
		return loc.CondoID
	end

end

function Location.Get( location )
	return Locations[location]
end

function Location.GetFriendlyName( location )

	local location = Location.Get( location )

	if location then
		return location.FriendlyName
	end

	return "Somewhere"

end

function Location.GetGroup( location )

	local location = Location.Get( location )

	if location then
		return location.Group
	end

	return ""

end

function Location.Is( location, name )

	local location = Location.Get( location )

	if location then
		return location.Name == name
	end
	return false

end

GtowerRooms = {}
GtowerRooms.Get = function() return end

local meta = FindMetaTable("Entity")
local plyMeta = FindMetaTable("Player")

local ownableDoors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["gmt_condo_door"] = true
}
local unOwnableDoors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true,
    ["gmt_condo_door"] = true
}
function meta:isKeysOwnable()
    if not IsValid(self) then return false end

    local class = self:GetClass()

    if (ownableDoors[class] or
            (GAMEMODE.Config.allowvehicleowning and self:IsVehicle() and (not IsValid(self:GetParent()) or not self:GetParent():IsVehicle()))) then
        return true
    end

    return false
end

function meta:isDoor()
    local class = self:GetClass()

    if unOwnableDoors[class] then
        return true
    end

    return false
end

hook.Add("getDoorCost", "test", function(ent)
    return 100
end)


-----------------------------------------------------
AddCSLuaFile()

-- Object for managing, calculating, and (de)serializing bezier curves

-- Super basic functionaltiy, add additional functionality as necessary



local CURVE = {}

CURVE.__index = CURVE

CURVE.SaveDirectory = "Curves/"



local point

-- Utility function to create the point structure

local function CreatePoint( position, angle, premag, postmag, props, targetSpeed )

	return

	{

		Pos = position,

		Angle = angle,

		PreMagnitude = premag,

		PostMagnitude = postmag,

		User = props,

		Speed = targetSpeed
	}

end



----

-- Get the world position of the anchor controlling after this node

----

function CURVE:GetNextAnchor(index)

	assert(index > 0 and index <= #self.Points, "Index out of range of table!")

	point = self.Points[index]



	-- Cache the angles, only change when something changes

	if point.LastAngle ~= point.Angle or

	point.LastPostMagnitude ~= point.PostMagnitude or

	point.LastPos ~= point.Pos or

	not point.CachedNextAnchor then

		point.LastAngle = point.Angle

		point.LastPos = point.Pos

		point.LastPostMagnitude = point.PostMagnitude



		point.CachedNextAnchor = point.Angle:Forward() * point.PostMagnitude + point.Pos

	end



	return point.CachedNextAnchor

end



----

-- Get the world position of the anchor controlling before this node

----

function CURVE:GetPreviousAnchor(index)

	assert(index > 0 and index <= #self.Points,  "Index out of range of table!")

	point = self.Points[index]



	-- Cache the angles, only change when something changes

	if point.LastAngle ~= point.Angle or

	point.LastPreMagnitude ~= point.PreMagnitude or

	point.LastPos ~= point.Pos or

	not point.CachedPreviousAnchor then

		point.LastAngle = point.Angle

		point.LastPos = point.Pos

		point.LastPreMagnitude = point.PreMagnitude



		point.CachedPreviousAnchor = -point.Angle:Forward() * point.LastPreMagnitude + point.Pos

	end



	return point.CachedPreviousAnchor

end



----

-- Add a new point to the curve at the end of the list

-- Optionally add it to a specific index

----

function CURVE:Add(position, angle, premag, postmag, index, nodeProps, targetSpeed)

	assert(position, "Invalid argument #1. Position expected, got nil")



	local point = CreatePoint(position, angle or Angle(), premag or 1, postmag or 1, nodeProps, targetSpeed or 1)



	if index ~= nil then

		table.insert(self.Points, index, point )

	else

		table.insert(self.Points, point)

	end

end



----

-- Store specific information per node

-- Useful for code that perhaps has different types/properties of nodes

----

function CURVE:SetUserobject(index, userobject )

	assert(index > 0 and index <= #self.Points,  "Index out of range of table!")



	point = self.Points[index]

	point.User = userobject

end



----

-- Retrieve stored user information about a node

----

function CURVE:GetUserobject(index, userobject )

	assert(index > 0 and index <= #self.Points,  "Index out of range of table!")



	return self.Points[index].User

end





---

-- Linearize the curve by creating a bunch of sub-points along the path

---

function CURVE:CalculateKeyPoints(tesselation)

	-- Reset the curve points

	self.KeyPoints = {}

	self.KeyPointTesselation = tesselation -- Store this so we always know the current tesselation



	-- Localize some variables

	local point, forward, right, angle, perc, dist, tdist
, index


	for i = 0, tesselation * (#self.Points-1) do

		perc = i / tesselation



		-- Calculate some useful stuff to store

		point, forward, right, index = self:Calculate(

			math.floor(perc) % (#self.Points-1) + 1,

		 	perc % 1)



		angle = self:CalculateAngle(forward, right)



		if i > 0 then

			dist = self.KeyPoints[i].Pos:Distance(point)

			tdist = (self.KeyPoints[i].TotalDistance or 0) + dist



		end



		-- Store it all in our table

		table.insert(self.KeyPoints,

		{

			Pos = point,

			Angle = angle,

			Distance = (dist or 1),

			TotalDistance = (tdist or 0)
,
			PointNum = index
		})

	end



end









-- Relocate these variables outside the function

-- Just so they aren't constantly being recreated

local u, tt, uu, uuu, ttt

local nextPoint, p, forward, ang, right

local curPoint, PosUUU, uutNext3, uttprev3, PosTTT

----

-- Calculate the position, forward, and right vectors of a percent after a given point

----

function CURVE:Calculate( index, t )

	u = 1 - t

	tt = t *t

	uu = u*u

	uuu = uu * u

	ttt = tt * t



	curPoint = self.Points[index]

	nextPoint = self.Points[index+1]



	-- Calculate the forward vector

	forward = -3 * curPoint.Pos * uu +

		3 * (1.0 - 4.0 * t + 3.0 * t * t) * self:GetNextAnchor(index) +

		3 * (2.0 * t - 3.0 * t * t) * self:GetPreviousAnchor(index+1) +

		3 * nextPoint.Pos * tt



	-- Calculate the right vector

	--ang = LerpAngle( t, curPoint.Angle, nextPoint.Angle)

	--right = forward:Cross(ang:Up())



	-- We purposefully don't normalize these vectors as their length is potentially useful

	-- Also, we calculate it here to save on a few variables



	-- The position

	return curPoint.Pos * uuu +

		3 * uu * t * self:GetNextAnchor(index) +

		3 * u * tt * self:GetPreviousAnchor(index+1) +

		ttt * nextPoint.Pos,



	-- The forward vector

	forward,



	-- The right vector

	forward:Cross(LerpAngle( t, curPoint.Angle, nextPoint.Angle):Up())
,

	-- The Index
	index
end



-- Utility function to find the closest index of the lookup table

function CURVE:FindStartIndex(distance, startIndex)



	-- It's pretty shitty we have to loop through, so we let them choose the index to start looking from

	-- Make sure it's not invalid or the last one

	startIndex = startIndex or 1

	local keyPoint = self.KeyPoints[startIndex-1]

	if not keyPoint or keyPoint.TotalDistance > distance or startIndex >= #self.KeyPoints then

		startIndex = 1

	end



	-- Given a distance, find the closest keypoint to it

	-- While we have to loop through it, we have been hinted its position so it shouldn't be bad

	local num = -1

	for k=startIndex, #self.KeyPoints do

		if self.KeyPoints[k].TotalDistance > distance then

			num = k

			break

		end

	end



	return num

end



---

-- Calculate using a cached 'linearized' version of the curve.

-- Accepts the distance along the linear curve and the start index to look from

-- It also returns the index the position was found, so that will be a hint for the loop next time around

---

function CURVE:CalculateLinear( distance, startIndex )

	local num = self:FindStartIndex(distance, startIndex)



	-- Uhh, someone wonked up

	if num < 1 then return Vector(), Angle, -1 end



	-- Store the current and next key points to interpolate across

	curPoint 	= self.KeyPoints[num-1]

	nextPoint 	= self.KeyPoints[num]



	-- Get just the percentage bit

	p = (distance - curPoint.TotalDistance) / (nextPoint.TotalDistance - curPoint.TotalDistance)



	-- Wrap around if necessary

	if not nextPoint then nextPoint = self.KeyPoints[1] end



	-- Return only position and angle

	return  LerpVector(p, curPoint.Pos, nextPoint.Pos),

			LerpAngle(p, curPoint.Angle, nextPoint.Angle),

			num
,
			self.Points[curPoint.PointNum].Speed or 1
end





-- Relocate these variables outside the function

-- Just so they aren't constantly being recreated

local up, absAngle, cross, rollAngle

----

-- Calculate the euler angle given proper forward and right vectors

----

function CURVE:CalculateAngle(forward, right)

	up = forward:Cross(right)



	absAngle = right:AngleEx(up)

	cross = right:Cross(up)

	rollAngle = forward:DotProduct(cross) >= 0 and absAngle or -absAngle

	rollAngle:RotateAroundAxis(rollAngle:Forward(), 180)



	return rollAngle

end



----

-- Serialize the points table to a text string

----

function CURVE:Serialize()

	return util.TableToJSON( self.Points )

end



local function TypeToLuaString( obj )

	local t = type(obj)



	if t == "Vector" then

		return "Vector(" .. obj.x .. ","..obj.y..","..obj.z..")"

	elseif t == "Angle" then

		return "Angle(" .. obj.p .. ","..obj.y..","..obj.r..")"

	elseif t == "number" then

		return tostring(obj)

	elseif t == "table" then

		return "util.JSONToTable([[" .. util.TableToJSON(obj) .. "]])"

	end

	-- welp

	return tostring(obj)

end



---

-- Alternate function to save as a series of points to be created with lua

---

function CURVE:SerializeLua(name)

	-- Create each line

	local lines = {}

	for _, v in pairs( self.Points ) do

		local lineStr = "curve:Add(" .. TypeToLuaString(v.Pos) ..", " ..

									  TypeToLuaString(v.Angle) ..", " ..

			 				   TypeToLuaString(v.PreMagnitude) ..", " ..

			  				  TypeToLuaString(v.PostMagnitude) ..", " ..

			   								 "nil, " ..

			    						   (v.User and TypeToLuaString(v.User) or "nil") .. ")"

		print(lineStr)

		table.insert(lines, lineStr)



	end



	-- Assemble the bigass string

	local str = "STORED_CURVES = STORED_CURVES or {}\n" ..

				"local curve = CreateBezierCurve()\n\n"



	str = str .. string.Implode("\n", lines)



	str = str .. "\n\nSTORED_CURVES[\"" .. name .. "\"] = curve"



	return str

end



----

-- Deserialize a table of points, loading the points in yonder

----

function CURVE:Deserialize( str )

	self.Points = {}

	self.Points = util.JSONToTable( str )



	-- Return if the operation was successful

	return self.Points ~= nil

end



----

-- Generic function for saving to a file, to load for later

----

function CURVE:Save(filename, shouldSaveLua)

	local fullPath = self.SaveDirectory .. filename .. ".txt"

	local fullPathLua = self.SaveDirectory .. filename .. "_lua.txt"



	-- Create the folder to make sure we can write there

	file.CreateDir(self.SaveDirectory)



	-- Write to the file

	file.Write(fullPath, self:Serialize())



	if shouldSaveLua then

		file.Write(fullPathLua, self:SerializeLua(filename) )

	end

end



----

-- Generic function for loading from a file using the previously used Save func

----

function CURVE:Load(filename)

	local fullPath = self.SaveDirectory .. filename .. ".txt"

	local json = file.Read(fullPath, "DATA")



	-- If we weren't able to load the file return false

	if not json then return false end



	-- Load it UP

	return self:Deserialize(json)

end



function CURVE:__tostring()

	return "Bezier curve of " .. #self.Points .. " points."

end



----

-- Create a new instance of our bezier curve object

----

function CreateBezierCurve()

	local tbl = {}

	tbl = setmetatable(tbl, CURVE)



	tbl.Points = {}

	tbl.KeyPoints = {}



	return tbl

end

concommand.Add("gmt_storespline",function(ply)
	if !ply:IsAdmin() then return end
	ply:ChatPrint("curve:Add(Vector("..tostring(ply:GetPos()).."), Angle("..tostring(ply:GetAngles()).."), 1, 1, nil, nil)")
end)
