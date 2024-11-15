include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

CreateClientConVar( "gmt_vip_jetpackpower", 1, true, true )
local drawSmoke = CreateClientConVar( "gmt_jetpacksmoke", 1, true, false )

local matHeatWave		= Material( "sprites/heatwave" )
local matFire			= Material( "effects/fire_cloud1" )
local matSprite 		= Material( "sprites/heatwave" )

local ModelDrawFlame = {
	["models/gmod_tower/jetpack.mdl"] = true,
	["models/gmod_tower/fairywings.mdl"] = false,
}

local ModelRotate = {
	["models/gmod_tower/jetpack.mdl"] = 0,
	["models/gmod_tower/fairywings.mdl"] = -90,
}

local ModelOffsets = {
	// ["models/gmod_tower/jetpack.mdl"] = Vector( 0, 0, 0 ),
	["models/gmod_tower/fairywings.mdl"] = Vector( 0, 3, 0 ),
	["models/gmod_tower/backpack.mdl"] = Vector( 4, -4, 0 ),
}

local ModelScale = {
	["models/gmod_tower/jetpack.mdl"] = .5,
	["models/gmod_tower/fairywings.mdl"] = .75,
	["models/gmod_tower/backpack.mdl"] = .6
}

function ENT:InitOffset()
	
end

function ENT:GetJetpackAttchment( ply )

	if !IsValid( ply ) then return end

	// Try to fix offset for rayman
	if ply:GetModel() == "models/player/rayman.mdl" then
		local attachmentData = ply:GetAttachment( ply:LookupAttachment("eyes") )
		local pos = util.GetCenterPos(ply) + Vector(0,0,ply:BoundingRadius())
		local ang = attachmentData.Ang
		local scale = GTowerModels.GetScale( ply:GetModel() )

		if( ply:IsPlayer() && ply:Alive() && ply:KeyDown(IN_DUCK) && ply:GetVelocity():Length() == 0 ) then
			pos = pos + ang:Forward() * 5 - Vector(0,0,10)
		end

		return pos, ang, scale
	end

	local Torso = ply:LookupBone( "ValveBiped.Bip01_Spine2" )

	if Torso then
		local pos, ang = ply:GetBonePosition( Torso )
		local scale = ( ply:GetModelScale() or 1 ) * ( ModelScale[self:GetModel()] or .5 )
	
		ang:RotateAroundAxis( ang:Up(), 90 )
		ang:RotateAroundAxis( ang:Forward(), 90 )
	
		return pos, ang, scale * 1.5
	end

end

function ENT:PositionItem(ply)

	local pos, ang, scale = self:GetJetpackAttchment( ply )
	if !pos || !ang then return end

	// if ( ModelForward[ self:GetModel() ] ) then
	// 	pos = pos + self:GetForward() * ModelForward[ self:GetModel() ]
	// end

	local Offsets = ModelOffsets[ self:GetModel() ]

	if Offsets then
		
		local offsets = ang:Up() * Offsets[1] + ang:Forward() * Offsets[2] + ang:Right() * Offsets[3]
		
		offsets.x = offsets.x * scale
		offsets.y = offsets.y * scale
		offsets.z = offsets.z * scale

		pos = pos + offsets

	end

	ang:RotateAroundAxis( ang:Up(), ModelRotate[ self:GetModel() ] or 0 )


	return pos, ang, scale

end

function ENT:DrawFireAttchment( att, ply, seed )
	
	if !ply:GetNet("IsJetpackOn") then return end

	local jetpackstart = ply:GetNet("JetpackStart") or 0
	local tdiff = (CurTime() - jetpackstart)
	local Scale = math.Clamp(tdiff * 2, 0, 1 )
	local c = ply:GetPlayerColor()
	
	if ply:GetVelocity().z > 100 and tdiff <= 0.1 then
		Scale = 1
	end
	
	if ( ply:GetNet("JetpackStart") or 0 ) < 0 then
		Scale = 1 - Scale
	end
	
	if Scale == 0 then
		return
	end
	
	Scale = Scale * 0.5 * ply:GetModelScale()
	
	local Attchment = self:LookupAttachment( att ) 
	local AttchmentTbl = self:GetAttachment( Attchment )
	if !AttchmentTbl then
		return
	end	
	
	local Up = Vector(0,0,0)
	local vOffset = AttchmentTbl.Pos + Up
	local vNormal = ply:GetVelocity():GetNormal() * -1
	local scroll = seed + (CurTime() * -10)
	
	if vNormal:DotProduct( Up ) > 0 then
		vNormal = Up * -1
	end
	
	matFire:SetVector( "$color2", c )
	render.SetMaterial( matFire )
	
	render.StartBeam( 3 )
		render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128) )
		render.AddBeam( vOffset + vNormal * 60 * Scale, 32 * Scale, scroll + 1, Color( 255, 255, 255, 128) )
		render.AddBeam( vOffset + vNormal * 148 * Scale, 32 * Scale, scroll + 3, Color( 255, 255, 255, 0) )
	render.EndBeam()

	scroll = scroll * 0.5
	render.UpdateRefractTexture()
	render.SetMaterial( matHeatWave )
	render.StartBeam( 3 )
		render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128) )
		render.AddBeam( vOffset + vNormal * 32 * Scale, 32 * Scale, scroll + 2, Color( 255, 255, 255, 255) )
		render.AddBeam( vOffset + vNormal * 128 * Scale, 48 * Scale, scroll + 5, Color( 0, 0, 0, 0) )
	render.EndBeam()
	
	
	scroll = scroll * 1.3
	render.SetMaterial( matFire )
	render.StartBeam( 3 )
		render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128) )
		render.AddBeam( vOffset + vNormal * 60 * Scale, 16 * Scale, scroll + 1, Color( 255, 255, 255, 128) )
		render.AddBeam( vOffset + vNormal * 148 * Scale, 16 * Scale, scroll + 3, Color( 255, 255, 255, 0) )
	render.EndBeam()
		
	render.SetMaterial( matSprite )
	render.DrawSprite( vOffset, Scale * 32, Scale * 32, Color( 255, 0, 0, 128) )
	matFire:SetVector( "$color2", Vector(1, 1, 1) )

	if not Location.IsEquippablesNotAllowed( ply:Location() ) then
		self:DrawSmoke( vOffset, Scale, vNormal )
	end
	
end

function ENT:DrawTranslucent()

	local ply = self:GetOwner()
	if !IsValid( ply ) then return end

	// Don't draw for ghosts
	if UCHAnim && UCHAnim.IsGhost( ply ) then return end

	self.BaseClass.DrawTranslucent( self )

	if ply == LocalPlayer() and !LocalPlayer().ThirdPerson then return end
	if !IsValid(ply) || !ply:Alive() || ply:OnGround() || ply:InVehicle() then return end
	
	if !ply:GetNet("IsJetpackOn") then
		return
	end

	if ModelDrawFlame[ self:GetModel() ] then
		
		self:DrawFireAttchment( "exhaust01", ply, 1.4 )
		self:DrawFireAttchment( "exhaust02", ply, 5.2 )
		
	end	

end

function ENT:DrawSmoke( pos, scale, normal )
	if !drawSmoke:GetBool() then return end
	
	if not self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end
	
	self.Emitter:SetPos(self:GetPos())
	
	local scale = self:GetOwner():GetModelScale()
	local sprite = self:GetOwner():GetNet("JetpackTexture")
	local color = self:GetOwner():GetPlayerColor() * 255
	
	for i=1, 2 do

		if math.random( 3 ) > 1 then

			if sprite and #sprite > 0 then
				local particle = self.Emitter:Add( sprite, pos )
				if particle then
					particle:SetAngles( Angle( math.Rand( -2, 2 ), math.Rand( -2, 2 ), math.Rand( -2, 2 ) ) )
					particle:SetAngleVelocity( Angle( math.Rand( -2, 2 ), math.Rand( -2, 2 ), math.Rand( -2, 2 ) ) ) 
					particle:SetVelocity( VectorRand() * 40 + self:GetOwner():GetVelocity() + normal * 250 ) 
					particle:SetLifeTime( 0 ) 
					particle:SetDieTime( math.Rand( 0.3, 0.6 ) ) 
					particle:SetStartAlpha( math.Rand( 80, 120 ) ) 
					particle:SetEndAlpha( 0 ) 
					particle:SetStartSize( math.random( 5, 10 ) * scale ) 
					particle:SetEndSize( math.random( 11, 13 ) * scale )
					particle:SetColor( color.r, color.g, color.b )
				end
			else
				local particle = self.Emitter:Add( "particles/smokey", pos )
				if particle then
					particle:SetVelocity( VectorRand() * 40 + self:GetOwner():GetVelocity() + normal * 250 ) 
					particle:SetLifeTime( 0 ) 
					particle:SetDieTime( math.Rand( 0.3, 0.6 ) ) 
					particle:SetStartAlpha( math.Rand( 80, 120 ) / 2 ) 
					particle:SetEndAlpha( 0 ) 
					particle:SetStartSize( math.random( 5, 10 ) * scale / 2 ) 
					particle:SetEndSize( math.random( 20, 35 ) * scale / 2 ) 

					local dark = math.Rand( 0, 150 )
					particle:SetColor( dark, dark, dark ) 
					particle:SetAirResistance( 50 )
					particle:SetGravity( Vector( 0, 0, math.random( -50, 50 ) ) )
					particle:SetCollide( true )
					particle:SetBounce( 0.2 )
				end
			end

		end

		if math.random( 3 ) == 3 then

			local particle = self.Emitter:Add( "effects/muzzleflash" .. math.random( 1, 4 ), pos )
			if particle then
				particle:SetVelocity( VectorRand() * 30 + self:GetOwner():GetVelocity() + Vector( 0, 0, 20 ) ) 
				particle:SetLifeTime( 0 ) 
				particle:SetDieTime( math.Rand( 0.1, 0.2 ) ) 
				particle:SetStartAlpha( 255 ) 
				particle:SetEndAlpha( 0 ) 
				particle:SetStartSize( math.random( 6, 12 ) * scale ) 
				particle:SetEndSize( 1 ) 
				particle:SetColor( color.r, color.g, color.b )
				particle:SetAirResistance( 50 )
			end

		end

	end

	self.Emitter:SetPos( self.Entity:GetPos() )


end