AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString("TV")

function ENT:Use(ply)
    net.Start("TV")
    net.WriteEntity(self)
    net.Send(ply)
end