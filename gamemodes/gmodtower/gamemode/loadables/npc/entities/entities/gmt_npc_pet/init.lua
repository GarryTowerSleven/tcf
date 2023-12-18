AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Think()

    self.BaseClass.Think( self )

    if !IsValid( self.Pet ) then

        self.Pet = ents.Create( "gmt_pet" )
        self.Pet:SetPos( self:GetPos() )
        self.Pet:SetOwner( self )
        self.Pet:SetPetName( "Meowlen!" )
        self.Pet:Spawn()

    end

end