ENT.Type			= "anim"
ENT.Base			= "base_anim"
ENT.PrintName		= "Billiard Cue"
ENT.Author			= "Athos"
ENT.Information		= "Billiard Cue"
ENT.Category		= "Other"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

local billiard = {
    ["billiard_cue"] = true,
    ["billiard_ball"] = true
}

hook.Add("ShouldCollide", "test", function(e1, e2)
    if billiard[e1:GetClass()] && e2:IsPlayer() || e1:IsPlayer() && billiard[e2:GetClass()] then
        return false
    end
end)