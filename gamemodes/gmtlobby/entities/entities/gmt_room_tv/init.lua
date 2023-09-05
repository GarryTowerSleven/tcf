AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Use(ply)
    ply:SendLua([[local ent = ents.GetByIndex(]] .. self:EntIndex() .. [[) ent.On = !ent.On]])
end