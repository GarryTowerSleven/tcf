---------------------------------
include('shared.lua')

function ENT:Think()
    self:ResetSequence("idle_all_01")
    self:SetEyeTarget( self:GetForward() * 100 )
end
