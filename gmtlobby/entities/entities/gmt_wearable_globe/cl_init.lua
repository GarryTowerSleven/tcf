
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.ClientModel = nil

function ENT:Draw()
	//self:DrawModel()
end


function ENT:CheckModel(ply)

	local hide = ply == LocalPlayer() && !LocalPlayer().ThirdPerson

	if IsValid( self.ClientModel ) && hide then
		self.ClientModel:Remove()
		return
	end

	if hide then return end

	if !IsValid(self.ClientModel) then
		self.ClientModel = ClientsideModel(self.Model)
		self.ClientModel:SetPos( ply:GetPos() )
	end

	if IsValid(self.ClientModel) then
		local pos = ply:GetBonePosition( ply:LookupBone("ValveBiped.Bip01_Spine2") )
		pos = pos + ply:GetUp() * -9.5 + ply:GetForward() * 2

		self.ClientModel:SetPos(pos)

		local ang = ply:GetAngles()
		ang:RotateAroundAxis( ply:GetUp(), -90 )
		ang.z = 0

		self.ClientModel:SetAngles( ang )
	end

end

function ENT:OnRemove()
  if IsValid( self.ClientModel ) then
		self.ClientModel:Remove()
	end
end

function ENT:Think()

	local ply = self:GetOwner()

	if !IsValid( self:GetOwner() ) then return end

	self:CheckModel( ply )
end
