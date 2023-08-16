concommand.Add("gmt_vr_start", function(ply)
    if !ply:IsAdmin() && !ply:IsStaff() && !ply:IsContributor() then return end
    RunConsoleCommand("vrmod_useworldmodels", "1")
    RunConsoleCommand("gmt_vr_useworldmodels", "1")
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

hook.Add("ShouldDrawLocalPlayer", "a", function()
    if vrmod.IsPlayerInVR(LocalPlayer()) then
        return true
    end
end)

hook.Add("ShouldDrawLocalPlayer", "a", function()
    if vrmod.IsPlayerInVR(LocalPlayer()) then
        return true
    end
end)

// g_VR.menuItems = {}

vrmod.RemoveInGameMenuItem("Toggle Noclip")
vrmod.RemoveInGameMenuItem("Settings")
vrmod.RemoveInGameMenuItem("Spawn Menu")
vrmod.RemoveInGameMenuItem("Context Menu")
vrmod.RemoveInGameMenuItem("Map Browser")

vrmod.AddInGameMenuItem("Scoreboard", 1, 1, function()
    local Gui

    if !IsValid(Gui) then
        Gui = vgui.Create("DFrame")
        GUI = vgui.Create("ScoreboardSettings", Gui)
        for _, t in ipairs(GUI.Tabs) do
            // GUI.Tabs[_].Order = 0
        end
        GUI.Think = function() end
        GUI:Dock(FILL)
        Gui:SetSize(640, 480)
        Gui:SetDeleteOnClose(false)
    end

    a = Gui

    /*VRUtilMenuOpen("weaponmenu", Gui:GetWide(), Gui:GetTall(), Gui, 4, Vector(0, 0, 64), Angle(0, 0, 45), 0.03, true, function()
        Gui:Remove()
    end)*/

    Gui:MakePopup()
end)

vrmod.AddInGameMenuItem("Reset Height", 1, 2, function()
    local cv = GetConVar("gmt_vr_heightmenu")
    cv:SetBool(!cv:GetBool())
    VRUtilOpenHeightMenu()
end)

function vrmod.UsingEmptyHands(ply)
    return !IsValid(ply:GetActiveWeapon())
end