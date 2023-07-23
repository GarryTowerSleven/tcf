local citizen = {
    Pain = {
        Small = {
            "vo/npc/male01/ow01.wav",
            "vo/npc/male01/ow02.wav"
        },
        Medium = {
            "vo/npc/male01/pain01.wav",
            "vo/npc/male01/pain02.wav",
            "vo/npc/male01/pain03.wav",
            "vo/npc/male01/pain04.wav",
            "vo/npc/male01/pain05.wav",
            "vo/npc/male01/pain06.wav"
        },
        Large = {
            "vo/npc/male01/pain07.wav",
            "vo/npc/male01/pain08.wav",
            "vo/npc/male01/pain09.wav"
        }
    },
    Death = {},
    Taunts = {
        "vo/coast/odessa/male01/nlo_cheer03.wav",
        "vo/npc/male01/gotone02.wav",
        "vo/npc/male01/likethat.wav",
        "vo/npc/male01/nice01.wav",
        "vo/npc/male01/question17.wav",
        "vo/npc/male01/yeah02.wav",
        "vo/npc/male01/vquestion01.wav"
    }
}

local zombie = {
    Pain = {"Zombie.Pain"},
    Death = {"Zombie.Die"},
    Taunts = {"Zombie.Idle"}
}

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
    },
    Taunts = {
        "bot/do_not_mess_with_me.wav",
        "bot/i_am_dangerous.wav",
        "bot/i_am_on_fire.wav",
        "bot/i_wasnt_worried_for_a_minute.wav",
        "bot/nice2.wav",
        "bot/owned.wav",
        "bot/made_him_cry.wav",
        "bot/they_never_knew_what_hit_them.wav",
        "bot/who_wants_some_more.wav",
        "bot/whos_the_man.wav",
        "bot/yea_baby.wav",
        "bot/wasted_him.wav"
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
    },
    Taunts = {
        "S:METROPOLICE_KILL_PLAYER4"
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
    },
    Taunts = {
        "S:COMBINE_PLAYERHIT2"
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

voicelines.Add("models/player/police.mdl", combine)
voicelines.Add("models/player/police_fem.mdl", combine)
voicelines.Add("models/player/combine_soldier.mdl", combine2)
voicelines.Add("models/player/combine_super_soldier.mdl", combine2)

voicelines.SetFemale("models/player/alyx.mdl")
voicelines.SetFemale("models/player/mossman.mdl")
voicelines.SetFemale("models/player/mossman_arctic.mdl")
voicelines.SetFemale("models/player/p2_chell.mdl")
voicelines.SetFemale("models/player/police_fem.mdl")

for i = 1, 9 do
    voicelines.Add("models/player/group01/male_0" .. i .. ".mdl", citizen)
    voicelines.Add("models/player/group02/male_0" .. i .. ".mdl", citizen)
    voicelines.Add("models/player/group03/male_0" .. i .. ".mdl", citizen)
    voicelines.Add("models/player/group01/female_0" .. i .. ".mdl", citizen)
    voicelines.Add("models/player/group02/female_0" .. i .. ".mdl", citizen)
    voicelines.Add("models/player/group03/female_0" .. i .. ".mdl", citizen)
end