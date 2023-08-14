AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "TurtleUse" )

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType( SIMPLE_USE )
end

function SendToHallway( ply )
	ply:SetNWBool( "InLimbo", true )
	ply:SafeTeleport( Vector(math.random(15945, 16155), math.random(-3935, -3485), -16290 ))
	GAMEMODE:SetPlayerSpeed( ply, 100, 100 )
	ply:SetModel("models/player/group01/male_01.mdl")
	ply:ConCommand( "gmt_updateplayercolor" )
	ply:SetModelScale(1)
	ply:StripWeapons()
end

function RemoveFromHallway( ply, giveachievement )
	if ( not ply:GetNWBool( "InLimbo" ) ) then return end

	ply:SetNWBool( "InLimbo", false )
	ply:SafeTeleport( Vector(928, -1472, 168 ))
	ply:ConCommand( "gmt_updateplayermodel" )
	ply:ConCommand( "gmt_updateplayercolor" )
	ply:ResetSpeeds()

	

	if ( giveachievement ) then
		ply:SetAchievement( ACHIEVEMENTS.SMOOTHDETECTIVE, 1 )
	end
end

concommand.AdminAdd( "gmt_hallway", function( ply, cmd, args )
	local user = args[1] and ( IsValid( player.GetByID( args[1] ) ) and player.GetByID( args[1] ) or NULL ) or ply

	if ( not user ) then return end

	if ( ply:GetNWBool( "InLimbo" ) ) then
		RemoveFromHallway( user )
	else
		SendToHallway( user )
	end
end )

function ENT:Use( activator )

	if activator:IsPlayer() then
	
		activator.Delay = activator.Delay or CurTime()
		activator.TurtleNumber = activator.TurtleNumber or 0
		
		if activator.Delay <= CurTime() then
			activator.Delay = CurTime() + 3
			
			if self.TurtleNumber == 6 && activator.TurtleNumber == 6 then
				activator.TurtleNumber = 0
				net.Start( "TurtleUse" )
					net.WriteBool( true )
					net.WriteEntity( self )
				net.Send( activator )
				// Pt 2
				timer.Simple(0.25, function()
					SendToHallway( activator )
				end)
			elseif self.TurtleNumber == 1 && activator.TurtleNumber == 0 then
				activator.TurtleNumber = 2
				net.Start( "TurtleUse" )
					net.WriteBool( true )
					net.WriteEntity( self )
				net.Send( activator )
			elseif self.TurtleNumber == activator.TurtleNumber then	
				activator.TurtleNumber = activator.TurtleNumber + 1
				net.Start( "TurtleUse" )
					net.WriteBool( true )
					net.WriteEntity( self )
				net.Send( activator )
			else
				activator.TurtleNumber = 0
				net.Start( "TurtleUse" )
					net.WriteBool( false )
					net.WriteEntity( self )
				net.Send( activator )
			end
			
		end
	end
end

function ENT:KeyValue( key, value )

	if key == "door" then
		self.TurtleNumber = tonumber(value)
	end

end

hook.Add("PlayerDeath", "RemoveHallwayEffects", function( ply )

	if ply:GetNWBool( "InLimbo" ) then

		ply:SetNWBool( "InLimbo", false )
		ply:ConCommand( "gmt_updateplayermodel" )

	end

end )

hook.Add( "DisableEmotes", "LimboDisableEmotes", function( ply )
	if ( ply:GetNWBool( "InLimbo", false ) ) then
		return true
	end
end )