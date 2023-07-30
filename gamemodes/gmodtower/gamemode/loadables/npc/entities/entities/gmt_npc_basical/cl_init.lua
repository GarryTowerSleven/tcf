include('shared.lua')

function ENT:GetPlayerColor()
    return Vector(0, 0, 0)
end

function ENT:Draw()
    self.Ragdoll.GetPlayerColor = function()
        return Vector(0, 0, 0)
    end
end