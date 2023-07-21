local zombie = {
    Pain = {"Zombie.Pain"},
    Death = {"Zombie.Die"},
    Taunts = {"Zombie.Idle"}
}

// This isn't used, since we're reimplementing HEV Voice Lines...
local hev = {
    Pain = {
        Small = {"S:HEV_DMG4"},
        Medium = {"S:HEV_DMG5"},
        Large = {"S:HEV_DMG5"}
    },
    Death = {"S:HEV_DEAD0", "S:HEV_DEAD1"}
}

local cs = {
    Pain = {
        "hostage/hpain/hpain1.wav",
        "hostage/hpain/hpain2.wav",
        "hostage/hpain/hpain3.wav",
        "hostage/hpain/hpain4.wav",
        "hostage/hpain/hpain5.wav",
        "hostage/hpain/hpain6.wav"
    },
    Death = {
        "player/death1.wav",
        "player/death2.wav",
        "player/death3.wav",
        "player/death4.wav",
        "player/death5.wav",
        "player/death6.wav"
    }
}

local cs_bot = {
    Pain = {
        "bot/ouch.wav",
        "bot/ow.wav",
        "bot/aah.wav",
        "bot/oh.wav"
    },
    Death = {
        "bot/pain2.wav",
        "bot/pain4.wav",
        "bot/pain5.wav",
        "bot/pain8.wav",
        "bot/pain9.wav"
    }
}

local combine = {
    Pain = {
            "S:METROPOLICE_PAIN0",
            "S:METROPOLICE_PAIN1",
            "S:METROPOLICE_PAIN2"
    },
    Death = {
        "S:METROPOLICE_DIE0",
        "S:METROPOLICE_DIE1",
        "S:METROPOLICE_DIE2"
    }
}


local combine2 = {
    Pain = {
            "S:COMBINE_PAIN0",
            "S:COMBINE_PAIN1",
            "S:COMBINE_PAIN2"
    },
    Death = {
        "S:COMBINE_DIE0",
        "S:COMBINE_DIE1",
        "S:COMBINE_DIE2"
    }
}

voicelines.Add("models/player/charple.mdl", zombie)
voicelines.Add("models/player/corpse1.mdl", zombie) // DarkRP Hobo
voicelines.Add("models/player/skeleton.mdl", zombie) // TODO: do some funny bone noises
voicelines.Add("models/player/zombie_classic.mdl", zombie)
voicelines.Add("models/player/zombie_fast.mdl", zombie)
voicelines.Add("models/player/zombie_soldier.mdl", zombie)

voicelines.Add("models/player/arctic.mdl", cs_bot)
voicelines.Add("models/player/gasmask.mdl", cs_bot)
voicelines.Add("models/player/leet.mdl", cs_bot)
voicelines.Add("models/player/phoenix.mdl", cs_bot)
voicelines.Add("models/player/riot.mdl", cs_bot)
voicelines.Add("models/player/swat.mdl", cs_bot)
voicelines.Add("models/player/urban.mdl", cs_bot)

voicelines.SetFemale("models/player/alyx.mdl")
voicelines.SetFemale("models/player/mossman.mdl")
voicelines.SetFemale("models/player/mossman_arctic.mdl")
voicelines.SetFemale("models/player/p2_chell.mdl")
voicelines.SetFemale("models/player/police_fem.mdl")