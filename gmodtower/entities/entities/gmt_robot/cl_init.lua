---------------------------------
include("shared.lua")

function ENT:Think()
    if self.Owner:KeyPressed(IN_RELOAD) then self.QueueAction = true end
end

function ENT:Initialize()
  timer.Create("ActionCheck",0.25,0,function()
    if self.QueueAction and !self.ActionTimeout then
      self.ActionTimeout = true
      self:Action()
      timer.Simple(5,function()
        self.QueueAction = false
        self.ActionTimeout = false
      end)
    end
  end)
end

function ENT:Action()
  timer.Create("Bleeper",0.1,8,function()
    self:EmitSound("player/cyoa_pda_beep"..math.random(1,8)..".wav",50)
  end)
end
