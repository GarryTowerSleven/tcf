
playerSounds = {}
local mdls = {}

function addSounds(mdl, tbl)
    playerSounds[mdl] = tbl
end

function getSounds(mdl, type)
    local tbl = playerSounds[mdl]
    local female

    if !tbl then
        if mdls[mdl] then
            tbl = playerSounds["default_male"]
            female = true
        else
            mdls[mdl] = isFemaleDefault(mdl)
            return getSounds(mdl, type)
        end
    end

    if type then
        local snd = "null.wav"
        type = string.Split(type, ",")

        if type[1] == "Pain" then
            if #type[1] == 1 then
                return table.Random(tbl[type[1]])
            else
                // TODO: Go from large to medium to small idiot!!!
                if !tbl["Pain"][type[2]] then
                    snd = table.Random(tbl["Pain"])
                else
                    snd = tbl[type[1]][type[2]]
                end
            end
        elseif type[1] == "Death" then
            if !tbl["Death"] or #tbl["Death"] == 0 then
                return getSounds(mdl, "Pain,Large")
            end
        end

        if istable(snd) then
            snd = table.Random(snd)
        end

        if female then
            snd = string.Replace(snd, "male", "female")
        end

        return snd
    else
        return tbl
    end
end

function isFemaleDefault(mdl)
    if mdls[mdl] then
        return mdls[mdl] == 1
    end

    mdls[mdl] = string.find(mdl, "female") and 1 or 0
end

function emitSound(ent, snd)
    if istable(snd) then

    elseif string.StartWith(snd, "S:") then
        EmitSentence(string.sub(snd, 3), ent:GetPos(), ent:EntIndex(), CHAN_VOICE, 1, 60, 0, 100)
    else
        ent:EmitSound(snd, 60, 100, 1, CHAN_VOICE)
    end
end

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


addSounds("default_male", {
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
    Death = {}, // We'll typically reuse Large Pain.
    Taunts = {}
})

addSounds("models/player/charple.mdl", zombie)
addSounds("models/player/corpse1.mdl", zombie) // DarkRP Hobo
addSounds("models/player/skeleton.mdl", zombie) // TODO: do some funny bone noises
addSounds("models/player/zombie_classic.mdl", zombie)
addSounds("models/player/zombie_fast.mdl", zombie)
addSounds("models/player/zombie_soldier.mdl", zombie)

addSounds("models/player/arctic.mdl", cs_bot)
addSounds("models/player/gasmask.mdl", cs_bot)
addSounds("models/player/leet.mdl", cs_bot)
addSounds("models/player/phoenix.mdl", cs_bot)
addSounds("models/player/riot.mdl", cs_bot)
addSounds("models/player/swat.mdl", cs_bot)
addSounds("models/player/urban.mdl", cs_bot)

mdls["models/player/alyx.mdl"] = 1
mdls["models/player/mossman.mdl"] = 1
mdls["models/player/mossman_arctic.mdl"] = 1
mdls["models/player/p2_chell.mdl"] = 1
mdls["models/player/police_fem.mdl"] = 1