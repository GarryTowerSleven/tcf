--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]


TEAM_CITIZEN = DarkRP.createJob("GMTower Player", {
    color = Color(255, 200, 0),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[]],
    weapons = {},
    command = "player",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Other",
})

TEAM_STAFF = DarkRP.createJob("GMTower Shopkeeper", {
    color = Color(81, 182, 255),
    model = {
        "models/humans/gmtsui1//Female_01.mdl",
        "models/humans/gmtsui1//Female_02.mdl",
        "models/humans/gmtsui1//Female_03.mdl",
        "models/humans/gmtsui1//Female_04.mdl",
        "models/humans/gmtsui1//Female_06.mdl",
        "models/humans/gmtsui1//male_01.mdl",
        "models/humans/gmtsui1//Male_02.mdl",
        "models/humans/gmtsui1//male_03.mdl",
        "models/humans/gmtsui1//Male_04.mdl",
        "models/humans/gmtsui1//Male_05.mdl",
        "models/humans/gmtsui1//Male_06.mdl",
        "models/humans/gmtsui1//Male_07.mdl",
        "models/humans/gmtsui1//Male_08.mdl",
        "models/humans/gmtsui1//Male_09.mdl"
    },
    description = [[]],
    weapons = {},
    command = "staff",
    max = 4,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Other",
})

TEAM_STAFF2 = DarkRP.createJob("GMTower Staff Member", {
    color = Color(82, 82, 82),
    model = {
        "models/humans/gmtsui1//Female_01.mdl",
        "models/humans/gmtsui1//Female_02.mdl",
        "models/humans/gmtsui1//Female_03.mdl",
        "models/humans/gmtsui1//Female_04.mdl",
        "models/humans/gmtsui1//Female_06.mdl",
        "models/humans/gmtsui1//male_01.mdl",
        "models/humans/gmtsui1//Male_02.mdl",
        "models/humans/gmtsui1//male_03.mdl",
        "models/humans/gmtsui1//Male_04.mdl",
        "models/humans/gmtsui1//Male_05.mdl",
        "models/humans/gmtsui1//Male_06.mdl",
        "models/humans/gmtsui1//Male_07.mdl",
        "models/humans/gmtsui1//Male_08.mdl",
        "models/humans/gmtsui1//Male_09.mdl"
    },
    description = [[]],
    weapons = {},
    command = "staff2",
    max = 6,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Other",
})

TEAM_STAFF3 = DarkRP.createJob("GMTower Owner", {
    color = Color(21, 21, 21),
    model = "models/player/macdguy.mdl",
    description = [[]],
    weapons = {},
    command = "staff3",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = true,
    mayor = true,
    category = "Other",
})

TEAM_STAFF4 = DarkRP.createJob("Merchant", {
    color = Color(136, 42, 128),
    model = "models/gmod_tower/merchant.mdl",
    description = [[]],
    weapons = {},
    command = "staff4",
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Other",
})

TEAM_PIG = DarkRP.createJob("Pigmask", {
    color = Color(255, 175, 224),
    model = "models/uch/pigmask.mdl",
    description = [[]],
    weapons = {},
    command = "pigmask",
    max = 4,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Other",
})

TEAM_PIG2 = DarkRP.createJob("Pigmask Colonel", {
    color = Color(255, 175, 224),
    model = "models/uch/pigmask.mdl",
    description = [[]],
    weapons = {},
    command = "pigmaskc",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = true,
    category = "Other",
})


--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    TEAM_STAFF2,
    TEAM_STAFF3
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
