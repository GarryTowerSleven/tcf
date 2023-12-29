include('shared.lua')

ENT.Title = "Toilet... with a head?"
ENT.Vending = true
ENT.Offset = -114
ENT.Description = "What the hug..? It's got some items in it's mouth..."

function ENT:Think()

end

function ENT:Draw()

    if !IsValid( self.Toilet ) then

        self.Toilet = ClientsideModel("models/props/cs_militia/toilet.mdl")
        self.Toilet:SetNoDraw( true )

    end

    if !IsValid( self.Head ) then

        self.Head = ClientsideModel( "models/humans/group01/male_07.mdl" )
        self.Head:SetNoDraw( true )

        for i, mat in ipairs( self.Head:GetMaterials() ) do
            
            if string.find( mat, "citizen" ) then

                self.Head:SetSubMaterial( i - 1, "null" )

            end

        end

        local s = 1.4

        self.Head:ManipulateBonePosition( self.Head:LookupBone( "ValveBiped.Bip01_Spine4" ), Vector( -52, 0, 0 ) )
        self.Head:ManipulateBonePosition( self.Head:LookupBone( "ValveBiped.Bip01_Head1" ), Vector( 8, 8, 0 ) )
        self.Head:ManipulateBoneScale( self.Head:LookupBone( "ValveBiped.Bip01_Head1" ), Vector( s, s, s ) )

    end

    self.Toilet:SetPos(self:GetPos())
    self.Toilet:SetAngles(self:GetAngles())
    self.Toilet:DrawModel()

    self.Head:SetPos( self:GetPos()  )
    self.Head:SetAngles( self:GetAngles() )
    self.Head:DrawModel()

    self.Head:SetFlexScale( 2 )
    self.Head:SetFlexWeight( self:GetFlexIDByName( "smile" ), 1 )

    self.Head:SetEyeTarget( LocalPlayer():EyePos() )

    local bone = self.Head:LookupBone( "ValveBiped.Bip01_Head1" )

    if bone then

        local pos = self.Head:GetBonePosition( bone )
        local ang = ( LocalPlayer():EyePos() - pos ):Angle()
        self.Head:ManipulateBoneAngles( bone, Angle( math.sin( CurTime() ) * 2, -ang.p, ang.y ) )

    end

end