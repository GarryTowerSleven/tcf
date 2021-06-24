---------------------------------
include('shared.lua')

function ENT:Initialize()
    self:SetSequence(self.CurAnimation)
    timer.Create("AnimationLoop",0.5,0,function()
      self:SetSequence(self.CurAnimation)
    end)
end

function ENT:OnRemove()
    if !timer.Exists("AnimationLoop") then return end
    timer.Destroy("AnimationLoop")
end
