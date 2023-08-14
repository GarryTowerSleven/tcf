if SERVER then
    AddCSLuaFile("gmt_vr.lua")
else
    include("gmt_vr.lua")
end