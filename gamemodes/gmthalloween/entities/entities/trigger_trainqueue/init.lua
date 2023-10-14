ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:GetController()
    return ents.FindByClass( "logic_tracktrain" )[1]
end

function ENT:StartTouch( entity )

    local controller = self:GetController()
    if not IsValid( controller ) then return end

    

end