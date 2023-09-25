
local CLASS = {}

CLASS.Name = "Journalist"
CLASS.PlayerModel = ""

CLASS.SpecialItemName = "Radio Tower"
CLASS.SpecialItemDesc = "This novelty radio tower sends out a precisely tuned frequency that explodes zombie into the air."
CLASS.SpecialItem = "zm_item_special_radio"
CLASS.SpecialItemDelay = 60

CLASS.PowerName = "Camera Flash"
CLASS.PowerDesc = "The blinding flash damages every zombie around you. Say cheese."
CLASS.PowerLength = .1
CLASS.PowerGotSound = "GModTower/zom/powerups/powerup_journalist.wav"

if CLIENT then
	CLASS.SpecialItemMat = surface.GetTextureID( "gmod_tower/zom/hud_item_radio" )
	CLASS.PowerMat = surface.GetTextureID( "gmod_tower/zom/hud_power_camera" )
end

if SERVER then
	util.AddNetworkString( "CameraFlash")
end

function CLASS:Setup( ply )
	self.Player = ply
end

function CLASS:PowerStart( ply )

	PostEvent( ply, "survivorCamera" )

	local count = 0

	for _, ent in pairs( ents.FindInSphere( ply:GetPos(), 384 ) ) do

		if ent:IsNPC() then
			ent:TakeDamage( 250, ply )
			ply:AddAchievement( ACHIEVEMENTS.ZMCAMERA, 1 )
			count = count + 1
		end

	end

	ply:EmitSound( "GModTower/zom/powerups/camera_flash.wav" )

	net.Start( "CameraFlash" )
		net.WriteEntity( ply )
	net.Broadcast()

	ply:PowerEnd()

end

function CLASS:PowerEnd( ply )
end

if CLIENT then

	net.Receive( "CameraFlash", function( len )

		local ent = net.ReadEntity()

		if !IsValid( ent ) then return end

		if ConVarDLights:GetInt() < 1 then return end

		local dlight = DynamicLight( ent:EntIndex() .. "camera" )

		if dlight then
			dlight.Pos = ent:GetPos()
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 5
			dlight.Decay = 400
			dlight.size = 512
			dlight.DieTime = CurTime() + .4
		end

		local emitter = ParticleEmitter( ent:GetPos() )

		for i=1, 20 do

			local particle = emitter:Add( "effects/yellowflare", ent:GetPos() + Vector( 0, 0, 32 ) )
			particle:SetVelocity( VectorRand() * 100 )
			particle:SetDieTime( 1 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 32 )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
			particle:SetColor( 255, 255, 255 )
			particle:SetGravity( Vector( 0, 0, -100 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.5 )

		end

		emitter:Finish()

	end)

end

classmanager.Register( "journalist", CLASS )
