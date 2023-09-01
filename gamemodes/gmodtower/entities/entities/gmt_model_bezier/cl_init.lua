include( "shared.lua" )

ENT.ClientModels = {}
ENT.FinishCount = 0
ENT.SoundDelay = 0

function ENT:Initialize()

    self:SetNoDraw( true )

end

function ENT:Draw() end

function ENT:Position( ent, progess )

    return math.CubicBezier( progess, ent.P0, ent.P1, ent.P2, ent.P3 ), ent:GetAngles() + Angle( 0, FrameTime() * self.SpinSpeed, FrameTime() * self.SpinSpeed )

end

function ENT:Setup()

    if not IsValid( self.GoalEntity ) then return end

    local endPos = util.GetCenterPos( self.GoalEntity ) + self.GoalOffset

    for i=1, self.ModelCount do

        local entity = ClientsideModel( self.ModelString, RENDERGROUP_OPAQUE )

        if not IsValid( entity ) then return end

        if self.MaterialOverride then
            entity:SetMaterial( self.MaterialOverride )
        end
        
        local startPos = self:GetPos()
        local time = self.Approach + ((i / self.ModelCount) * self.Duration)

        local rand_ang = Angle( 0, 0, 0 )
        rand_ang:Random()

        entity:SetPos( startPos )
        entity:SetAngles( rand_ang )

        entity.P0 = startPos
		entity.P1 = startPos + Vector( 0, 0, 50 )
		entity.P2 = endPos + Vector( 0, 0, 50 )
		entity.P3 = endPos

        entity.start_random_offset = VectorRand() * self.RandomPos
		entity.progress = 0
        entity.approach = time
		entity.starttime = CurTime()

        table.insert( self.ClientModels, entity )

    end

    self.Active = true

end

function ENT:Think()

	if not self.Active or not self.ClientModels then return end

    for k, v in ipairs( self.ClientModels ) do
        
        if not IsValid( v ) or not IsValid( self.GoalEntity ) then continue end

        local startPos = self:GetPos() + v.start_random_offset
        local endPos = util.GetCenterPos( self.GoalEntity ) + self.GoalOffset

        v.P0 = startPos
		v.P1 = startPos + Vector( 0, 0, 50 )
		v.P2 = endPos + Vector( 0, 0, 50 )
		v.P3 = endPos

		v.progress = v.progress + ( FrameTime() / v.approach )

        local pos, ang = self:Position( v, v.progress )

        v:SetPos( pos )
        v:SetAngles( ang )

        if v.progress >= 1 then

            self.FinishCount = self.FinishCount + 1
            self:Arrived()

            v:Remove()
            table.remove( self.ClientModels, k )

        end

    end

end

function ENT:Arrived()

    if not IsValid( self.GoalEntity ) then return end
    if not self.Sound then return end

    if self.SoundDelay > CurTime() then return end

    local i = self.ModelCount - self.FinishCount
    local ratio = i / self.ModelCount

    self.GoalEntity:EmitSound( self.Sound, self.SoundVolume, Lerp( ratio, 75, 150 ), 1, CHAN_STATIC )

    self.SoundDelay = CurTime() + .025

end

function ENT:ReceiveNet()
    
    local goalent = net.ReadEntity()
    if not IsValid( goalent ) then return end

    self.GoalEntity = goalent
    self.GoalOffset = net.ReadVector()

    self.ModelString = Model( net.ReadString() )
    self.ModelCount = net.ReadUInt( 8 )

    local hasSound = net.ReadBool()

    if hasSound then
        self.Sound = Sound( net.ReadString() )
        self.SoundVolume = net.ReadUInt( 7 )
    end

    self.Duration = net.ReadFloat()
    self.Approach = net.ReadFloat()
    self.RandomPos = net.ReadFloat()
    self.SpinSpeed = net.ReadUInt( 8 )

    self:Setup()

end

net.Receive( ENT.NetString, function()

    local ent = net.ReadEntity()
    if not IsValid( ent ) or not ent.ReceiveNet then return end

    ent:ReceiveNet()

end )

function ENT:OnRemove()

    if not self.ClientModels then return end

    for _, v in ipairs( self.ClientModels ) do
        if IsValid( v ) then
            v:Remove()
        end 
    end

	self.ClientModels = nil

end

/*hook.Add( "PostDrawTranslucentRenderables", "BezierDebug", function()

	local seg = 8
	
	for _, v in ipairs( ents.FindByClass( "gmt_*_bezier" ) ) do
        if not v.Active or not v.ClientModels then return end

        for _, mdl in pairs( v.ClientModels ) do
            if not IsValid( mdl ) then return end

            for i=1, seg do
                local pos = v:Position( mdl, i / seg )
                local pos2 = v:Position( mdl, math.Clamp( (i + 1) / seg, 0, 1 ) )

                render.DrawLine( pos, pos2, color_red )
            end
        end
	end

end )*/