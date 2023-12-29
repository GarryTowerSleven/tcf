AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

    self.BaseClass.Initialize( self )
    self:DrawShadow( false )

end