AddCSLuaFile()

ENT.Base		= "base_anim"
ENT.Type		= "anim"
ENT.PrintName	= "Candy Bucket"

ENT.Model			= Model("models/gmod_tower/halloween_candybucket.mdl")

ENT.SoundOpen 		= Sound("gmodtower/inventory/use_candy.wav")
ENT.SoundCollect 	= Sound("misc/halloween/spell_pickup.wav")

function ENT:Initialize()

	if CLIENT then return end

	self:SetModel( self.Model )

	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetCollisionBounds( Vector( -10, -10, -10 ), Vector( 10, 10, 10 )  )
	self:SetTrigger( true )

	self.Used = false
	self.RemoveTime = CurTime() + ( 60 * 3 )

end

function ENT:Touch( ply )

	if !ply:IsPlayer() || self.Used then return end

	if ply:GetNet( "Candy", 0 ) >= 1 then
		if ply._NoticeDelay && ply._NoticeDelay > CurTime() then return end

		ply._NoticeDelay = CurTime() + 10
		ply:Msg2( "You can only carry a single candy bucket!" )
		return
	end

	self.Used = true

	self:EmitSound( self.SoundOpen, 65, math.random(80,125), .5 )
	self:EmitSound( self.SoundCollect, 65, 100, .5 )	

    ply:SetNet( "Candy", ply:GetNet( "Candy", 0 ) + 1 )
	ply:AddAchievement( ACHIEVEMENTS.HALLOWEENCANDY, 1 )
	self:Remove()

end

function ENT:Think()
	if self.RemoveTime && self.RemoveTime < CurTime() then
		self:Remove()
	end
end

if SERVER then return end

ENT.Color = Color( 255, 128, 40, 255 )
ENT.SpriteMat = Material( "sprites/powerup_effects" )

function ENT:Initialize()

	timer.Simple( 1, function() 

		if IsValid( self ) then
			self.BaseClass:Initialize()
			self.OriginPos = self:GetPos()
			self.NextParticle = CurTime()
			self.TimeOffset = math.Rand( 0, 3.14 )

			self.Emitter = ParticleEmitter( self:GetPos() )
		end

	end )

end

function ENT:Draw()

	if !self.OriginPos || !self.TimeOffset then return end

	self:DrawModel()

	render.SetMaterial( self.SpriteMat )
	render.DrawSprite( self:GetPos(), 50, 50, self.Color )

end

function ENT:Think()

	local rot = self:GetAngles()
	rot.y = rot.y + 90 * FrameTime()

	self:SetAngles(rot)	
	self:SetRenderAngles(rot)

	if !self.OriginPos || !self.TimeOffset then return end

	local SinTime = math.sin( CurTime() + self.TimeOffset )
	self:SetRenderOrigin( self.OriginPos + Vector(0,0, 35 +  SinTime * 4 ) )
	
	if CurTime() > self.NextParticle then
		local emitter = self.Emitter

		local pos = self:GetPos() + ( VectorRand() * ( self:BoundingRadius() * 0.75 ) )
		local vel = VectorRand() * 3

		vel.z = vel.z * ( vel.z > 0 && -3 or 3 )

		local particle = emitter:Add( "sprites/powerup_effects", pos )

		if particle then
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand( 1, 3 ) )
			particle:SetStartAlpha( 100 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 18 )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
			particle:SetColor( self.Color.r, self.Color.g, self.Color.b )
		end

		self.NextParticle = CurTime() + 0.15
	end

end