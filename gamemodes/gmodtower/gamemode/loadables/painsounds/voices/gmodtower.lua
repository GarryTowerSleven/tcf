voicelines.Add("models/player/re/chris.mdl", {
    Pain = {
        Small = {
            "gmodtower/player/re/chris/pain01.wav",
            "gmodtower/player/re/chris/pain02.wav"
        },
        Medium = {
            "gmodtower/player/re/chris/pain03.wav",
            "gmodtower/player/re/chris/pain04.wav",
        },
        Large = {
            "gmodtower/player/re/chris/pain05.wav",
            "gmodtower/player/re/chris/pain016.wav"
        }
    },
    Death = {
        "gmodtower/player/re/chris/death01.wav"
    },
    Taunts = {
    }
})

voicelines.Add("models/player/re/albert_wesker_overcoat_pm.mdl", {
    Pain = {
        Small = {
            "gmodtower/player/wesker/25.mp3",
            "gmodtower/player/wesker/28.mp3"
        },
        Medium = {
            "gmodtower/player/wesker/26.mp3",
            "gmodtower/player/wesker/27.mp3",
            "gmodtower/player/wesker/60.mp3",
            ""
        },
        Large = {
            "gmodtower/player/wesker/36.mp3",
            "gmodtower/player/wesker/37.mp3",
            "gmodtower/player/wesker/61.mp3",
            "gmodtower/player/wesker/62.mp3",
        }
    },
    Death = {
        "gmodtower/player/wesker/38.mp3",
        "gmodtower/player/wesker/39.mp3"
    },
    Taunts = {
        "gmodtower/player/wesker/s506_80_Wesker.mp3",
        "gmodtower/player/wesker/s506_76_Wesker.mp3",
        "gmodtower/player/wesker/s506_75_Wesker.mp3",
        "gmodtower/player/wesker/s508_95_Wesker.mp3",
        "gmodtower/player/wesker/w_67.mp3",
        "gmodtower/player/wesker/w_68.mp3",
        "gmodtower/player/wesker/s309_74_Wesker.mp3",
    },
    Lines = {
        ["7 Minutes"] = "gmodtower/player/wesker/s309_88_Wesker.mp3"
    },
    Laughs = {
        "gmodtower/player/wesker/41.mp3",
        "gmodtower/player/wesker/42.mp3"
    },
    Downed = {
        "gmodtower/player/wesker/w_45.mp3",
        "gmodtower/player/wesker/w_43.mp3"
    },
    RoundStart = {
        "gmodtower/player/wesker/s508_87_Wesker.mp3",
        "gmodtower/player/wesker/s309_88_Wesker.mp3",
        "gmodtower/player/wesker/s309_73_Wesker.mp3"
    },
    RoundWin = {
        "gmodtower/player/wesker/s508_84_Wesker.mp3",
        "gmodtower/player/wesker/s508_85_Wesker.mp3",
        "gmodtower/player/wesker/s508_86_Wesker.mp3",
        "gmodtower/player/wesker/s508_88_Wesker.mp3"
    }
})

voicelines.Add("models/player/virusi.mdl", {
    Pain = {"Zombie.Pain"},
    Death = {"Zombie.Die"},
    Taunts = {"Zombie.Idle"}
})

voicelines.Add("models/player/drpyspy/spy.mdl", {
    Pain = {
        Small = {
            "vo/spy_painsharp01.mp3",
            "vo/spy_painsharp02.mp3",
            "vo/spy_painsharp03.mp3",
            "vo/spy_painsharp04.mp3"
        },
        Large = {
            "vo/spy_painsevere01.mp3",
            "vo/spy_painsevere02.mp3",
            "vo/spy_painsevere03.mp3",
            "vo/spy_painsevere04.mp3",
            "vo/spy_painsevere05.mp3"
        }
    },
    Death = {
        "vo/spy_paincrticialdeath01.mp3",
        "vo/spy_paincrticialdeath02.mp3",
        "vo/spy_paincrticialdeath03.mp3"
    },
    Laughs = {
        "vo/spy_laughlong01.mp3"
    },
    Cheers = {
        "vo/spy_laughevil02.mp3"
    },
    RoundWin = {
        "vo/spy_sf13_influx_big01.mp3",
        "vo/spy_sf13_influx_big02.mp3"
    }
})

voicelines.Add("models/player/zoey.mdl", {
    Pain = {
        Small = "player/survivor/voice/TeenGirl/HurtMinor0{1-4}.wav",
        Medium = "player/survivor/voice/TeenGirl/HurtMajor0{1-4}.wav",
        Large = "player/survivor/voice/TeenGirl/HurtCritical0{1-4}.wav"
    },
    Death = "player/survivor/voice/TeenGirl/DeathScream0{1-9}.wav",
    Taunts = "player/survivor/voice/TeenGirl/Taunt{18-31}.wav"
})

voicelines.Add("models/player/mcsteve.mdl", {
    Pain = {
        "gmodtower/player/minecraft/classic_hurt.ogg"
    }
})

voicelines.Add("models/ex-mo/quake3/players/doom.mdl", {
    Pain = {
        Small = "gmodtower/player/doom/pain50_1.wav",
        Medium = "gmodtower/player/doom/pain75_1.wav",
        Large = "gmodtower/player/doom/pain100_1.wav",
    },
    Death =  "gmodtower/player/doom/death{1-3}.wav",
    Taunts = {
        "gmodtower/player/doom/taunt.wav"
    }
})

voicelines.Add("models/player/lordvipes/haloce/spartan_classic.mdl", {
    Pain = {
        {
            "gmodtower/player/halo/shield_hit.wav"
        }
    },
    Death =  "gmodtower/player/halo/death_violent_{1-5}.wav"
})


voicelines.Add("models/player/tcf/gasmask_citizen.mdl", playerSounds["models/player/group01/male_07.mdl"])

voicelines.SetFemale("models/player/zoey.mdl")
voicelines.SetFemale("models/player/miku.mdl")
voicelines.SetFemale("models/player/samusz.mdl")
voicelines.SetFemale("models/player/zelda.mdl")
voicelines.SetFemale("models/player/faith.mdl")
voicelines.SetFemale("models/nikout/carleypm.mdl")
voicelines.SetFemale("models/player/midna.mdl")