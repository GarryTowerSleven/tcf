if ( not vrmod ) then return end



if !startVR then
    startVR = VRUtilClientStart
    VRUtilClientStart = function() end
    renderview = render.RenderView
    render.RenderView = function(data)
        if hook.GetTable()["RenderScene"]["cardboardmod_renderscene"] then
            data.dopostprocess = false
        end

        return renderview(data)
    end
end

local vrmod = vrmod
local hook = hook

module("vr", package.seeall)

// include("cl_hud.lua")

function InVR()
    return VR
end

function Start()
    if InVR() then return end
    
    hook.Remove("VRMod_Start", "voicepermissions")
    permissions.EnableVoiceChat(true)
    permissions.EnableVoiceChat(false)

    RunConsoleCommand("vrmod_useworldmodels", "1")
    RunConsoleCommand("gmt_vr_useworldmodels", "1")
    startVR()
    VR = true
end

function End()
    VRUtilClientExit()
    VR = false
end

concommand.Add("gmt_vr_start", function(ply)
    if !ply:IsAdmin() && !ply:IsStaff() && !ply:IsContributor() then return end
    Start()
end)



hook.Add("CreateMove", "a", function()
    timer.Simple(2.1, function()
        timer.Remove("vrutil_timer_tryautostart")
    end)
    hook.Remove("CreateMove", "a")
end)

hook.Add("ShouldDrawLocalPlayer", "a", function()
    if InVR() then
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