

-----------------------------------------------------
//local matRefraction	= Material( "refract_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	/*self.Refract = 0
	self.Size = 32
	self.Entity:SetRenderBounds( Vector()*-786, Vector()*786 )*/

	local Pos = data:GetOrigin()
	local Norm = Vector( 0, 0, 1 )
	local Scale = 1

	local Dist = LocalPlayer():GetPos():Distance( Pos )
	local FleckSize = math.Clamp( Dist * 0.01, 8, 64 )		
	local emitter = ParticleEmitter( Pos + Norm * 32 )
	
	for i=0,4 do
	
		local particle = emitter:Add( "particles/smokey", Pos + ( Norm * 10 ) )
		particle:SetVelocity( Vector( 0, 0, 1 ) * math.Rand( 50, 100 ) + VectorRand() * 50 )
		particle:SetDieTime( 7 )
		particle:SetStartAlpha( math.Rand( 195, 200 ) )
		particle:SetStartSize( math.Rand( 68, 128 ) )
		particle:SetEndSize( math.Rand(128, 256 ) )
		particle:SetColor(80,80,80)
		particle:SetAirResistance( 100 )
		particle:SetCollide( false )
	
	end

	for i=0,4 do

		local particle = emitter:Add( "particles/smokey", Pos + ( Norm * 32 ) )
		particle:SetVelocity( Vector( 0, 0, 1 ) * 300 + VectorRand() * 200 )
		particle:SetDieTime( math.Rand( 3, 8 ) )
		particle:SetStartAlpha( 200 )
		particle:SetStartSize( math.Rand( 64,128 ) )
		particle:SetEndSize( 256 )
		particle:SetRoll( 0 )
		particle:SetColor(80,80,80)
		particle:SetGravity( Vector( 0, 0, math.Rand( -200, -150 ) ) )
		particle:SetAirResistance( 100 )
		particle:SetCollide( false )

	end
		
	emitter:Finish()
		
	local emitter = ParticleEmitter( Pos, true )
	
	for i =0, ( 8 + ( 2 * Scale ) ) do
	
		local particle
		
		if ( math.random( 0, 1 ) == 1 ) then
			particle = emitter:Add( "effects/fleck_cement1", Pos )
		else
			particle = emitter:Add( "effects/fleck_cement2", Pos )
		end

		particle:SetVelocity( VectorRand():GetNormal() * math.Rand( 150, 300 ) )
		//particle:SetLifeTime( i )
		particle:SetDieTime( 4 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( FleckSize * math.Rand( 0.25, 1 ) )
		particle:SetEndSize( 0 )
		particle:SetLighting( true )
		particle:SetGravity( Vector( 0, 0, -200 ) )
		particle:SetAirResistance( 40 )
		particle:SetAngles( Angle( math.Rand( 0, 360 ), math.Rand( 0, 360 ), math.Rand( 0, 360 ) ) )
		//particle:SetAngleVelocity( Angle( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) * 800 )
		particle:SetCollide( true )
		particle:SetBounce( 0.2 )
		
		if ( math.fmod( i, 2 ) == 0 ) then
			particle:SetColor( 0, 0, 0 )
		end
	
	end
	
	emitter:Finish()
	
end

function EFFECT:Think()
	return true
end

function EFFECT:Render()
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
/*function EFFECT:Think( )

	self.Refract = self.Refract + 2.0 * FrameTime()
	self.Size = 512 * self.Refract^(0.2)
	
	if ( self.Refract >= 1 ) then return false end
	
	return true
	
end*/


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
/*function EFFECT:Render()

	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos = self.Entity:GetPos() + (EyePos()-self.Entity:GetPos()):Normalize() * Distance * (self.Refract^(0.3)) * 0.8

	matRefraction:SetFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawSprite( Pos, self.Size, self.Size )

end*/