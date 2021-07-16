AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Use( activator )
	net.Start( "OpenReqMenu" )
		net.WriteEntity( self )
	net.Send( activator )
end

util.AddNetworkString( "OpenReqMenu" )