AddCSLuaFile( "cl_init.lua" )AddCSLuaFile( "shared.lua" )include( "shared.lua" )function ENT:Intialize()	timer.Simple( 5, function() self:Remove() end )end