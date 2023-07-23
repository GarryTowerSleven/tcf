voicelines = {}
playerSounds = {}
local mdls = {}
local retry = {
    Laughs = {"Cheers"},
    Flails = {"Death"},
    Cheers = {"Laughs"}
}

function voicelines.Add(mdl, tbl)
    for _, t in pairs(tbl) do
        if istable(t) then
            for _2, t in pairs(t) do
                if isstring(t) and string.find(t, "{") then
                    local ids = string.Split(string.Split(t, "{")[2], "}")[1]
                    ids = string.Split(ids, "-")

                    tbl[_][_2] = {}
                    for i = ids[1], ids[2] do
                        local s = string.Split(t, "{")[1] .. i .. string.Split(t, "}")[2]
                        table.insert(tbl[_][_2], s)
                    end
                end
            end
        end
    end

    playerSounds[mdl] = tbl
end

function getSounds(ply, mdl, type)
    local tbl = playerSounds[mdl]
    local female = isFemaleDefault(mdl) or 0

    if !tbl then
        if mdls[mdl] then
            tbl = playerSounds["default_male"]
            female = mdls[mdl] == 1
        else
            mdls[mdl] = isFemaleDefault(mdl) or 0
            return getSounds(ent, mdl, type)
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
                return getSounds(ent, mdl, "Pain,Large")
            else
                snd = tbl[type[1]]
            end
        else
            snd = tbl[type[1]] or "null.wav"

            if snd == "null.wav" then
                if retry[type[1]] && ply.LastTry ~= retry[type[1]][1] then
                    ply.LastTry = retry[type[1]][1]
                    return getSounds(ent, mdl, ply.LastTry)
                else
                    ply.LastTry = nil
                    return "null.wav"
                end
            end
        end

        if istable(snd) then
            snd = table.Random(snd)
        end

        if isstring(snd) && (female == true || female == 1) then
            snd = string.Replace(snd, "male", "female")
        end

        return snd
    else
        return tbl
    end
end

function voicelines.SetFemale(mdl)
    mdls[mdl] = 1
end

function isFemaleDefault(mdl)
    if mdls[mdl] then
        return mdls[mdl]
    end

    mdls[mdl] = string.find(mdl, "female") and 1 or 0
    return mdls[mdl]
end

local cooldowns = {
    ["Pain"] = 0.4,
    ["Death"] = 0,
    ["Taunts"] = 1.4
}

// TODO: Don't hardcode this.
local models = {
    ["models/player/zoey.mdl"] = 2,
    ["models/player/miku.mdl"] = 8,
    ["models/nikout/carleypm.mdl"] = 1,
    ["models/player/faith.mdl"] = 2,
    ["models/player/midna.mdl"] = 20
}

local DSP_GASMASK = 30
local DSP_ROBOT = 38
local dsps = {
    ["models/player/tcf/gasmask_citizen.mdl"] = DSP_GASMASK,
    ["models/player/robot.mdl"] = DSP_ROBOT
}

function voicelines.Emit(ent, snd)
    local type = string.Split(snd, ",")[1]

    ent.CoolDowns = ent.CoolDowns or {}
    if ent.CoolDowns[type] and ent.CoolDowns[type] > CurTime() then return end
    ent.CoolDowns[type] = CurTime() + (cooldowns[type] or 2)

    snd = getSounds(ent, ent:GetModel(), snd)
    local vol, pitch = 75, 100 + (models[ent:GetModel()] or 0)

    if istable(snd) then

    elseif isfunction(snd) then
        snd(ent)
    elseif string.StartWith(snd, "S:") then
        EmitSentence(string.sub(snd, 3), ent:GetPos(), ent:EntIndex(), CHAN_VOICE, 1, vol, 0, pitch)
    else
        ent:EmitSound(snd, vol, pitch, 1, CHAN_VOICE, 0, dsps[ent:GetModel()] or 0)
    end
end

include("sv_pain.lua")
include("sv_taunt.lua")

include("voices/default.lua")
include("voices/gmod.lua")
include("voices/gmodtower.lua")

AddCSLuaFile("cl_init.lua")