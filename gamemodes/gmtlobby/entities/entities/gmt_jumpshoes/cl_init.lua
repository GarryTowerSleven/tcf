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
	
	self:SetModel("models/props_junk/shoe001a.mdl")
	
	if IsValid( owner ) then

		if ( ( owner == LocalPlayer() && !LocalPlayer().ThirdPerson ) || owner:IsNoDrawAll() ) then return end

		local size = GTowerModels.Get( owner ) or 1

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

		local spritesize = 50 * size

		render.SetMaterial( self.SpriteMat )
		render.DrawSprite( posR, spritesize, spritesize, Color(245, 125, 65, 255) )
		render.DrawSprite( posL, spritesize, spritesize, Color(245, 125, 65, 255) )

	end

end

function ENT:OnRemove()

	if self.Emitter then

		self.Emitter:Finish()
		self.Emitter = nil

	end

end
