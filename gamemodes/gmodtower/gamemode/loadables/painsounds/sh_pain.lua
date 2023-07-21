voicelines = {}
playerSounds = {}
local mdls = {}

function voiceines.Add(mdl, tbl)
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
        return mdls[mdl] == 1
    end

    mdls[mdl] = string.find(mdl, "female") and 1 or 0
end

function voiceline.Emit(ent, snd)
    if istable(snd) then

    elseif isfunction(snd) then
        snd(ent)
    elseif string.StartWith(snd, "S:") then
        EmitSentence(string.sub(snd, 3), ent:GetPos(), ent:EntIndex(), CHAN_VOICE, 1, 60, 0, 100)
    else
        ent:EmitSound(snd, 60, 100, 1, CHAN_VOICE)
    end
end