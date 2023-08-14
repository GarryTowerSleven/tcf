concommand.Add("gmt_vr_start", function(ply)
    if !ply:IsAdmin() then return end
    startVR()
end)

if !startVR then
    startVR = VRUtilClientStart
    VRUtilClientStart = function() end
end

hook.Add("CreateMove", "a", function()
    timer.Simple(2.1, function()
        timer.Remove("vrutil_timer_tryautostart")
    end)
    hook.Remove("CreateMove", "a")
end)