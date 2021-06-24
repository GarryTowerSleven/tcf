
function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local Color = data:GetStart()
	local emitter = ParticleEmitter( Pos )
	
	for i = 1,math.random(15,50) do

		local particle = emitter:Add( "particles/pumbkinface01", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 
		 
		--if particle == nil then particle = emitter:Add( "particles/pumbkinface01", Pos + Vector(   math.random(0,0),math.random(0,0),math.random(0,0) ) ) end
		
		if (particle) then
			particle:SetVelocity(Vector(math.random(-51,51),math.random(-50,51),math.random(-53,51)))
			particle:SetLifeTime(1) 
			particle:SetDieTime(2) 
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(25) 
			particle:SetEndSize(0.25)
			particle:SetAngles( Angle(0,0,0) )
			particle:SetAngleVelocity( Angle(0,0,0) ) 
			particle:SetRoll(math.Rand( 0, 360 ))
			particle:SetColor( Color.r, Color.g, Color.b )
			--particle:SetColor(math.random(199,255),math.random(73,204),math.random(0,0),math.random(255,255))
			particle:SetGravity( Vector(0,0,0) ) 
			particle:SetAirResistance(0 )  
		end
	end

	emitter:Finish()
		
end

function EFFECT:Think()		
	return false
end

function EFFECT:Render()
end
