include('shared.lua')
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.SpriteMat = Material( "sprites/powerup_effects" )

function ENT:Initialize()

	self.Owner = self:GetOwner()
	self.NextParticle = CurTime()
	self.TimeOffset = math.Rand( 0, 3.14 )

	//self.Emitter = ParticleEmitter( self:GetPos() )

end

function ENT:Draw()

	local owner = self:GetOwner()
	if IsValid( owner ) then

		local size = owner:GetNet( "ModelSize" ) or 1

		local FootR = owner:LookupBone( "ValveBiped.Bip01_R_Foot" )
		local FootL = owner:LookupBone( "ValveBiped.Bip01_L_Foot" )
		
		if FootR == nil && FootL == nil then return end

		local posR, ang = owner:GetBonePosition( FootR )
		local posL, ang = owner:GetBonePosition( FootL )

		if !FootR and !FootL then
			posR, ang = owner:GetPos(), owner:GetAngles()
			posL, ang = owner:GetPos(), owner:GetAngles()
		else
			posR, ang = owner:GetBonePosition( FootR )
			posL, ang = owner:GetBonePosition( FootL )
		end

		if IsValid( owner:GetBallRaceBall() ) then
			pos = owner:GetBallRaceBall():GetPos()
		end

		if size >= 1 then
			render.SetMaterial( self.SpriteMat )
			render.DrawSprite( posR, 50, 50, Color(245, 125, 65, 255) )
			render.DrawSprite( posL, 50, 50, Color(245, 125, 65, 255) )
		end

	end

end

function ENT:OnRemove()

	if self.Emitter then

		self.Emitter:Finish()
		self.Emitter = nil

	end

end
