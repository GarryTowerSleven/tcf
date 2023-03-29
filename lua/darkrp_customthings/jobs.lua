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


TEAM_CITIZEN = DarkRP.createJob("Player", {
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
    description = [[The Citizen is the most basic level of society you can hold besides being a hobo. You have no specific role in city life.]],
    weapons = {},
    command = "player",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
})

TEAM_STAFF = DarkRP.createJob("Staff", {
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
    description = [[The Citizen is the most basic level of society you can hold besides being a hobo. You have no specific role in city life.]],
    weapons = {},
    command = "staff",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
})

TEAM_MAYOR = DarkRP.createJob("Boss", {
    color = Color(150, 20, 20, 255),
    model = "models/player/breen.mdl",
    description = [[The Mayor of the city creates laws to govern the city.
    If you are the mayor you may create and accept warrants.
    Type /wanted <name>  to warrant a player.
    Type /jailpos to set the Jail Position.
    Type /lockdown initiate a lockdown of the city.
    Everyone must be inside during a lockdown.
    The cops patrol the area.
    /unlockdown to end a lockdown]],
    weapons = {},
    command = "boss",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 1.89,
    admin = 0,
    vote = true,
    hasLicense = false,
    mayor = true,
    category = "Civil Protection",
})

TEAM_HOBO = DarkRP.createJob("Hobo", {
    color = Color(80, 45, 0, 255),
    model = "models/player/corpse1.mdl",
    description = [[The lowest member of society. Everybody laughs at you.
        You have no home.
        Beg for your food and money
        Sing for everyone who passes to get money
        Make your own wooden home somewhere in a corner or outside someone else's door]],
    weapons = {"weapon_bugbait"},
    command = "hobo",
    max = 5,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Citizens",
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
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)
