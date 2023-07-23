AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.Model		= "models/weapons/w_vir_tnt.mdl"
ENT.BlastRange	= 256
ENT.BlastDmg	= 512

ENT.TriggerRange = 50

function ENT:Initialize()

	self:SetModel( self.Model )
	
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self:GetPhysicsObject()

	if !IsValid(phys) then

		self:PhysicsInitSphere(8)
		phys = self:GetPhysicsObject()

	end

	if IsValid(phys) then

		phys:Wake()
		phys:SetDamping( 0.2, 0 )
		phys:AddAngleVelocity( VectorRand() * 360 )

	end
	
	self.Timer			= false
	self.NextChangeSpot = 0
	self.NextLaserSpawn = 0

end

function ENT:Think()

	local owner = self:GetOwner()

	if !IsValid( owner ) || !owner:Alive() || owner:GetNet("IsVirus") then

		self:Detonate()

	end

	if self.Timer then

		self:EmitLasers()

	else

		local objs = ents.FindInSphere( self:GetPos(), self.TriggerRange )

		for _, v in ipairs( objs ) do

			if IsValid( v ) && v:IsPlayer() && v:GetNet( "IsVirus" ) && v:Alive() then		

				self:Remove()

			end

		end
	
	end

	if self.Detontated != nil then
		if self.Detontated < CurTime() then
			self:Remove()
		end
	end

	if !self.NextBeep or self.NextBeep < CurTime() then
		self.Beep = self.Beep or 0

		if self.Timer then return end

		if self.Beep == 1 then
			self.Beep = 0
			self:EmitSound("buttons/blip1.wav", 65, 90)
			self.NextBeep = CurTime() + 0.99
		else
			self.Beep = self.Beep + 1
			self:EmitSound("buttons/blip1.wav", 65, 140)
			self.NextBeep = CurTime() + 0.01
		end

	end

end

function ENT:EmitLasers()

	if CurTime() >= self.NextLaserSpawn then

		local effectdata = EffectData()

		for i=1,3 do

			effectdata:SetEntity( self )
			effectdata:SetStart( self:GetPos() )
			effectdata:SetRadius( 1023 )
			effectdata:SetAngles( Angle( math.random( -180,180 ), math.random( -180,180 ), math.random( -180,180 ) ) )
			util.Effect( "tnt_laser", effectdata )

		end

		self:EmitSound("buttons/blip1.wav", 65, 90)

		self.NextLaserSpawn = CurTime() + 0.1

	end

end

function ENT:SetTNTOwner( ply )

	self:SetOwner( ply )

	ply.TNT = self

end

function ENT:Detonate()

	if self.Timer then return end

	sound.Play( "GModTower/virus/weapons/TNT/timer.wav", self:GetPos() )
	self.Timer = true

	self.Detontated = CurTime() + 1.5

end

function ENT:OnRemove()

	local owner = self:GetOwner()
	local pos = self:GetPos()

	if IsValid( owner ) then

		util.BlastDamage( self, owner, pos, self.BlastRange, self.BlastDmg )

	end

	sound.Play( "GModTower/virus/weapons/TNT/explode.wav", self:GetPos() )
	
	local explode = EffectData()
		explode:SetStart( pos )
		explode:SetOrigin( pos )
	util.Effect( "tnt_explosion", explode )
	
	local sexplode = EffectData()
		sexplode:SetStart( pos )
		sexplode:SetOrigin( pos )
	util.Effect( "super_explosion", sexplode )

	owner:RemoveUsedTNT()

end

function ENT:PhysicsCollide(phys)
	self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity() / 8)
end