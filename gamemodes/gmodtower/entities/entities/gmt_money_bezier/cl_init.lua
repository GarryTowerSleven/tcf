include( "shared.lua" )

function ENT:ReceiveNet()
    
    local goalent = net.ReadEntity()
    if not IsValid( goalent ) then return end

    self.GoalEntity = goalent
    self.ModelCount = net.ReadUInt( 8 )
    
    self.GoalOffset = net.ReadVector()
    self.RandomPos = net.ReadFloat()

    self:Setup()

end