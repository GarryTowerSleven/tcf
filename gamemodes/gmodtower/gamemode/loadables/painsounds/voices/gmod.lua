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

local barney = {
    Pain = {
        Small = {
            "vo/k_lab/ba_thingaway02.wav",
            "vo/npc/barney/ba_pain08.wav",
			"vo/npc/barney/ba_pain04.wav"
        },
        Medium = {
            "vo/npc/barney/ba_pain07.wav",
            "vo/npc/barney/ba_pain09.wav",
            "vo/npc/barney/ba_pain01.wav",
            "vo/npc/barney/ba_pain02.wav"
        },
        Large = {
            "vo/npc/barney/ba_pain05.wav",
            "vo/npc/barney/ba_pain06.wav"
        }
    },
    Death = {
		"vo/npc/barney/ba_pain03.wav",
		"vo/npc/barney/ba_pain10.wav"
	},
    Taunts = {
        "vo/npc/barney/ba_bringiton.wav",
        "vo/npc/barney/ba_gotone.wav",
        "vo/npc/barney/ba_laugh01.wav",
        "vo/npc/barney/ba_laugh02.wav",
        "vo/npc/barney/ba_laugh03.wav",
        "vo/npc/barney/ba_laugh04.wav",
        "vo/npc/barney/ba_yell.wav"
    },
    Laughs = {
        "vo/npc/barney/ba_laugh01.wav",
        "vo/npc/barney/ba_laugh02.wav",
        "vo/npc/barney/ba_laugh03.wav",
        "vo/npc/barney/ba_laugh04.wav"
    }
}

local kleiner = {
    Pain = {
        "vo/k_lab/kl_ohdear.wav",
        "vo/k_lab/kl_hedyno03.wav",
        "vo/k_lab2/kl_greatscott.wav"
    },
    Death = {
        "vo/k_lab/kl_ahhhh.wav"
    }
}

local breen = { // a bit silly
    Pain = {
		"vo/citadel/br_youfool.wav",
		"vo/citadel/br_no.wav",
		"vo/citadel/br_failing11.wav",
    },
    Death = {
		"vo/citadel/br_youneedme.wav"
	},
    Taunts = {
        "vo/citadel/br_laugh01.wav",
        "vo/citadel/br_mock05.wav",
        "vo/citadel/br_mock06.wav",
        "vo/citadel/br_mock13.wav",
        "vo/citadel/br_mock09.wav"
    },
    Laughs = {
        "vo/citadel/br_laugh01.wav"
    }
}

local monk = {
    Pain = {
        Small = {
            "vo/ravenholm/monk_pain01.wav",
            "vo/ravenholm/monk_pain02.wav",
			"vo/ravenholm/monk_pain03.wav",
			"vo/ravenholm/monk_pain05.wav"
        },
        Medium = {
            "vo/ravenholm/monk_pain04.wav",
            "vo/ravenholm/monk_pain06.wav",
            "vo/ravenholm/monk_pain08.wav",
            "vo/ravenholm/monk_pain09.wav"
        },
        Large = {
            "vo/ravenholm/monk_pain07.wav",
            "vo/ravenholm/monk_pain10.wav",
			"vo/ravenholm/monk_pain12.wav"
        }
    },
    Taunts = {
        "vo/ravenholm/madlaugh01.wav",
        "vo/ravenholm/madlaugh02.wav",
        "vo/ravenholm/madlaugh03.wav",
        "vo/ravenholm/madlaugh04.wav",
        "vo/ravenholm/monk_kill08.wav",
        "vo/ravenholm/monk_kill10.wav",
        "vo/ravenholm/monk_kill07.wav",
    },
    Laughs = {
        "vo/ravenholm/madlaugh01.wav",
        "vo/ravenholm/madlaugh02.wav",
        "vo/ravenholm/madlaugh03.wav",
        "vo/ravenholm/madlaugh04.wav"
    }
}

local alyx = {
    Pain = {
        Small = {
            "vo/npc/alyx/hurt08.wav",
            "vo/npc/alyx/hurt04.wav",
			"vo/npc/alyx/uggh01.wav"
        },
        Medium = {
            "vo/npc/alyx/hurt06.wav"
        },
        Large = {
            "vo/npc/alyx/hurt05.wav",
            "vo/npc/alyx/uggh02.wav"
        }
    },
    Taunts = {
        "vo/trainyard/al_noyoudont.wav",
        "vo/eli_lab/al_sweet.wav",
        "vo/eli_lab/al_laugh01.wav",
        "vo/eli_lab/al_laugh02.wav"
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
        Large = {"S:HEV_HLTH3"}
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
    },
    Laughs = {
        "npc/metropolice/vo/chuckle.wav"
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
    },
    Laughs = {
        "npc/metropolice/vo/chuckle.wav"
    }
}

voicelines.Add("models/player/charple.mdl", zombie)
voicelines.Add("models/player/corpse1.mdl", zombie) // DarkRP Hobo
voicelines.Add("models/player/skeleton.mdl", zombie) // TODO: do some funny bone noises
voicelines.Add("models/player/zombie_classic.mdl", zombie)
voicelines.Add("models/player/zombie_fast.mdl", zombie)
voicelines.Add("models/player/zombie_soldier.mdl", zombie)

voicelines.Add("models/player/hostage/hostage_04.mdl", cs)

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

voicelines.Add("models/player/barney.mdl", barney)
voicelines.Add("models/player/kleiner.mdl", kleiner)
voicelines.Add("models/player/alyx.mdl", alyx)
voicelines.Add("models/player/monk.mdl", monk)

voicelines.Add("models/player/breen.mdl", breen)

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