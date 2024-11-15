local matLight 	= Material( "effects/select_ring" )
local matLight2 = Material( "sprites/powerup_effects" )

function EFFECT:Init( data )

	//Energy Orb Decay
	self.Resize = 0
	self.Size = 0
	self.MaxSpriteSize = 32
	self.Alpha = 255

	self.Entity:SetRenderBounds( Vector() * -( self.MaxSpriteSize * 2 ), Vector() * ( self.MaxSpriteSize * 2 ) )

	self.Pos = data:GetOrigin()
	self.Norm = data:GetNormal()

	local emitter = ParticleEmitter( self.Pos )

	//Energy Debris
	for i=1,5 do
		local particle = emitter:Add( "sprites/flamelet" .. tostring( math.random( 1, 5 ) ), self.Pos )
		if particle then

			particle:SetVelocity( ( VectorRand() * 1 ) * math.Rand( 15, 35 )  )
			particle:SetAngleVelocity( Angle( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) * 1200 )
			//particle:SetAngles( Angle( math.Rand( 0, 360 ), math.Rand( 0, 360 ), math.Rand( 0, 360 ) ) )
				
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 1 )
				
			particle:SetStartSize( 8 )
			particle:SetEndSize( 0 )

			particle:SetColor( math.random( 240, 255 ), math.random( 100, 128 ), 0, 200 )

			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -2, 2 ) )
				
			particle:SetAirResistance( 5 )

			particle:SetGravity( Vector( 0, 0, -800 ) )
			particle:SetBounce( 0.6 )
			particle:SetCollide( true )
			
		end
	end

	//Energy Sparks
	for i = 1, 20 do

		local particle = emitter:Add( "effects/spark", self.Pos )
		if particle then
			particle:SetVelocity( ( ( self.Norm + VectorRand() * 0.5 ) * math.Rand( 80, 150 ) ) * -1.5 )
			particle:SetDieTime( math.random( .25, .75 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 50 )
			particle:SetEndSize( 0 )
			particle:SetColor( math.random( 240, 255 ), math.random( 100, 128 ), 0 )
			particle:SetStartLength( 0 )
			particle:SetEndLength( 8 )
			particle:SetAirResistance( 150 )
		end

	end

	emitter:Finish()

end

function EFFECT:Think()

	self.Alpha = self.Alpha - FrameTime() * 500
	self.Resize = self.Resize + 1.5 * FrameTime()
	self.Size = self.MaxSpriteSize * self.Resize^( 0.15 )
	
	if self.Alpha <= 0 then return false end
	return true

end

function EFFECT:Render()

	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos2 = self.Entity:GetPos() + ( EyePos()-self.Entity:GetPos() ):GetNormal() * Distance * ( self.Resize^( 0.3 ) ) * 0.8

	render.SetMaterial( matLight2 )
	render.DrawSprite( Pos2, self.Size / 2, self.Size / 2, Color( math.random( 240, 255 ), math.random( 100, 128 ), 0, self.Alpha ) )

end