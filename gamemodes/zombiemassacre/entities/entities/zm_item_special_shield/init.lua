AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetPos(self:GetPos()+Vector(0,0,10))
	self:SetMaterial("models/wireframe")
	self:SetColor(Color(255,102,0,255))
	self:SetParent(self:GetOwner())

	self.ShieldSound = CreateSound( self, self.Sound )
	self.ShieldSound:Play()

	self.KillCount = 0
	self.PrevKillCount = 0
end

function ENT:Think()
	for _, target in ipairs( ents.FindInSphere(self:GetPos(), 30) ) do
		if !string.StartWith( target:GetClass(), "zm_npc_" ) then continue end

		self:EmitSound(self.HitSound)

		local dmg = 100

		if string.StartWith( target:GetClass(), "zm_npc_boss_" ) then
			dmg = 10
		else
			target:SetVelocity( target:GetAngles():Forward() * 1000000 )
		end

		self.KillCount = self.KillCount + 1
		target:TakeDamage( dmg, self:GetOwner(), self )
	end

	if self.KillCount != self.PrevKillCount then
		local eff = EffectData()
		eff:SetEntity( self )
		eff:SetOrigin( self:GetPos() )
		eff:SetNormal( self:GetUp() )
		util.Effect( "shield_block", eff )
		
		self.PrevKillCount = self.KillCount
	end

	if self.KillCount > 14 then
		self:GetOwner():AddAchievement( ACHIEVEMENTS.ZMOUTOFMYWAY, 1 )
	end

	self:NextThink( CurTime() )
	return true
end

function ENT:OnRemove()
	self.ShieldSound:Stop()
end