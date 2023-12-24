
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	if !self.Owner then return end

	local owner = self.Owner

	self:SetModel("models/player/items/all_class/pet_reinballoonicorn.mdl")
	self:SetMoveType(MOVETYPE_NONE)

	self:SetAngles(self:GetAngles() + Angle(90,0,0))
	self:DrawShadow(false)

	self.LastThink = 0

	if IsValid( owner ) then
		local BoneIndx = owner:LookupBone("ValveBiped.Bip01_Head1")
		local BonePos, BoneAng = owner:GetBonePosition( BoneIndx )
		local pos = BonePos + Vector(0,0,-10)
		local ang = owner:GetAngles()
		self:SetPos(pos + owner:GetRight() * 35 + owner:GetForward() * 30 )
		self:SetAngles(Angle(90,ang.y,ang.r))
	end

end

function ENT:UpdatePetName()
	local ply = self:GetOwner()
	if IsValid( ply ) then
		self:SetPetName( string.sub(ply:GetInfo("gmt_petname_rndr"),1,15) )
	end
end

function ENT:Think()

	if self.LastThink < CurTime() then

		self:UpdatePetName()
		self.LastThink = CurTime() + 0.1

	end

end