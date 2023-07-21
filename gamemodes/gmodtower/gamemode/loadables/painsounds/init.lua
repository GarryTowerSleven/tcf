voicelines = {}
playerSounds = {}
local mdls = {}

function voicelines.Add(mdl, tbl)
    playerSounds[mdl] = tbl
end

function getSounds(mdl, type)
    local tbl = playerSounds[mdl]
    local female

    if !tbl then
        if mdls[mdl] then
            tbl = playerSounds["default_male"]
            female = mdls[mdl] == 1
        else
            mdls[mdl] = isFemaleDefault(mdl) or 0
            return getSounds(mdl, type)
        end
    end

    if type then
        local snd = "null.wav"
        type = string.Split(type, ",")

        if type[1] == "Pain" || type[1] == "Taunts" then
            if #type[1] == 1 then
                return table.Random(tbl[type[1]])
            else
                // TODO: Go from large to medium to small idiot!!!
                if !tbl[type[1]][type[2]] then
                    snd = table.Random(tbl[type[1]])
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

        if isstring(snd) && female then
            snd = string.Replace(snd, "male", "female")
        end

        return snd
    else
        return tbl
    end
end

function voicelines.SetFemale(mdl)
    mdls[mdl] = true
end

function isFemaleDefault(mdl)
    if mdls[mdl] then
        return mdls[mdl]
    end

    mdls[mdl] = string.find(mdl, "female") and 1 or 0
end

local cooldowns = {
    ["Pain"] = 0.4,
    ["Death"] = 0,
    ["Taunts"] = 1.4
}

function voicelines.Emit(ent, snd)
    local type = string.Split(snd, ",")[1]

    ent.CoolDowns = ent.CoolDowns or {}
    if ent.CoolDowns[type] and ent.CoolDowns[type] > CurTime() then return end
    ent.CoolDowns[type] = CurTime() + (cooldowns[type] or 2)

    snd = getSounds(ent:GetModel(), snd)

    if istable(snd) then

    elseif isfunction(snd) then
        snd(ent)
    elseif string.StartWith(snd, "S:") then
        EmitSentence(string.sub(snd, 3), ent:GetPos(), ent:EntIndex(), CHAN_VOICE, 1, 60, 0, 100)
    else
        ent:EmitSound(snd, 60, 100, 1, CHAN_VOICE)
    end
end

include("sv_pain.lua")
include("sv_taunt.lua")

include("voices/default.lua")
include("voices/gmod.lua")
include("voices/gmodtower.lua")