local matLight 	= Material( "effects/select_ring" )
local matLight2 = Material( "sprites/pickup_light" )

function EFFECT:Init( data )

	//Energy Orb Decay
	self.Resize = 0
	self.Size = 0
	self.MaxSpriteSize = 16
	self.Alpha = 255

	self.Entity:SetRenderBounds( Vector() * -( self.MaxSpriteSize * 2 ), Vector() * ( self.MaxSpriteSize * 2 ) )

	self.Pos = data:GetOrigin()
	self.Norm = data:GetNormal()

	local emitter = ParticleEmitter( self.Pos )

	//Energy Sparks
	for i = 1, 20 do

		local particle = emitter:Add( "effects/spark", self.Pos )
		if particle then
			particle:SetVelocity( ( ( self.Norm + VectorRand() * 0.5 ) * math.Rand( 35, 80 ) ) * -1.5 )
			particle:SetDieTime( math.random( .25, .75 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 50 )
			particle:SetEndSize( 0 )
			particle:SetColor( math.random( 50, 80 ), math.random( 50, 80 ), math.random( 240, 255 ) )
			particle:SetStartLength( 0 )
			particle:SetEndLength( 8 )
			particle:SetAirResistance( 150 )
		end

	end

	//Missile Sparks
	for i =0, 50 do

		local particle = emitter:Add( "effects/spark", self.Pos )
		if particle then
			particle:SetVelocity( ( ( self.Norm + VectorRand() ) * math.Rand( 80, 150 ) ) )
			particle:SetDieTime( .25 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 20 )
			particle:SetEndSize( 0 )
			particle:SetColor( math.random( 50, 80 ), math.random( 50, 80 ), math.random( 240, 255 ) )
			particle:SetStartLength( 1 )
			particle:SetEndLength( 5 )
			particle:SetAirResistance( 50 )
		end

	end

	//Flek
	local Dist = LocalPlayer():GetPos():Distance( self.Pos )
	local FleckSize = math.Clamp( Dist * 0.01, 8, 64 )

	for i =1, 15 do
	
		local particle
	
		if ( math.random( 0, 1 ) == 1 ) then
			particle = emitter:Add( "effects/fleck_cement1", self.Pos )
		else
			particle = emitter:Add( "effects/fleck_cement2", self.Pos )
		end

		if particle then

			particle:SetVelocity( ( (self.Norm + VectorRand() * 0.5 ) * math.Rand( 150, 200 ) ) * -1 )
			//particle:SetLifeTime( i )
			particle:SetDieTime( 4 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
			particle:SetStartSize( FleckSize * math.Rand( 0.25, 0.5 ) )
			particle:SetEndSize( 0 )
			particle:SetLighting( true )
			particle:SetGravity( Vector( 0, 0, -800 ) )
			particle:SetAirResistance( 40 )
			particle:SetAngles( Angle( math.Rand( 0, 360 ), math.Rand( 0, 360 ), math.Rand( 0, 360 ) ) )
			//particle:SetAngleVelocity( Angle( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) * 800 )
			particle:SetCollide( true )
			particle:SetBounce( 0.2 )
				
			if ( math.fmod( i, 2 ) == 0 ) then
				particle:SetColor( 0, 0, 0 )
			end

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

	local Pos = self.Entity:GetPos() + self.Norm * 2 * ( self.Resize^( 0.3 ) ) * 0.8

	render.SetMaterial( matLight )
	render.DrawQuadEasy( Pos, self.Norm, self.Size, self.Size, Color( math.random( 50, 80 ), math.random( 50, 80 ), math.random( 240, 255 ), self.Alpha ) )

	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos2 = self.Entity:GetPos() + ( EyePos()-self.Entity:GetPos() ):GetNormal() * Distance * ( self.Resize^( 0.3 ) ) * 0.8

	render.SetMaterial( matLight2 )
	render.DrawSprite( Pos2, self.Size / 2, self.Size / 2, Color( math.random( 50, 80 ), math.random( 50, 80 ), math.random( 240, 255 ), self.Alpha ) )

end