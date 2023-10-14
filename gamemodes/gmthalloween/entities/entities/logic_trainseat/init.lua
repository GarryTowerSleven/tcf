AddCSLuaFile("cl_init.lua")

ENT.Base = "base_point"
ENT.Type = "point"

function ENT:Initialize()

    if not self._Target then print( "bye", self, "NOOOO" ) self:Remove() end

    local track = ents.FindByName( self._Target )[1]
    if not IsValid( track ) then print( "bye", self, self._Target ) self:Remove() return end

    if ( not track.Seats ) then
        track.Seats = {}
    end

    table.uinsert( track.Seats, self )
    self:SetMoveParent( track )

end

function ENT:KeyValue( key, value )

    if key == "train" then
        self._Target = value
    end

end