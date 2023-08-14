old1 = old1 or CreateConVar
old2 = old2 or concommand.Add

function CreateConVar(cmd, ...)
    if cmd ~= "vrmod_autostart" then
    cmd = string.Replace(cmd, "vrmod_", "gmt_vr_")
    end
    return old1(cmd, ...)
end

function concommand.Add(cmd, ...)
    if cmd == "vrmod_start" then return end
    cmd = string.Replace(cmd, "vrmod_", "gmt_vr_")
    return old2(cmd, ...)
end

old1("vrmod_floatinghands", "0")
old1("vrmod_althead", "0")