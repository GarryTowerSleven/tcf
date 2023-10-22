AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_tracker.lua")
AddCSLuaFile("cl_post_events.lua")
// AddCSLuaFile("cl_ragdoll_manager.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("sv_cart.lua")

CreateConVar( "gmt_srvid", 85 )

GM.PlayerSpeed = 100

function GM:PlayerSpawn( ply )

    // speed
    ply:SetSpeed( self.PlayerSpeed )
    ply:PostEvent( "death_off", 1, 0 )

	ply:SetCustomCollisionCheck( true )

	if ply.Connected == true && ply.ITM == nil then
		ply:SetPos( Vector( -9072.031250, 3808, 32 ) )
		ply:SetEyeAngles( Angle( 0, -180, 0 ) )
	else
		ply:SetPos( ply.ITM:GetPos() )
		ply:SetEyeAngles( ply.ITM:GetAngles() )

		ply:GiveEquipment()
	end

end

function GM:PostEntityTakeDamage( target, dmginfo, took )

    if not took then return end
    if not IsValid( target ) or not target:IsPlayer() or not target:Alive() then return end

    local attacker = dmginfo:GetAttacker()

    if IsValid( attacker ) then

        local _, ang = WorldToLocal( attacker:GetPos(), attacker:GetAngles(), target:EyePos(), target:EyeAngles() )
        target:ViewPunch( ang * .25 )
    
    end

    target:PostEvent( "damageflash", 1, 2 )

    target.HealthUpdate = CurTime() + self.HealthDamageDelay
    target:UpdateSpeed()

end

function GM:PostPlayerDeath( ply )

    ply:PostEvent( "death_on", 1, 0 )

end

GM.HealthAdd = 1
GM.HealthAddDelay = .1
GM.HealthDamageDelay = 2
hook.Add( "Think", "HalloweenThink", function()

    for _, ply in ipairs( player.GetAll() ) do

        if not ply:Alive() then continue end

		if ply.RideCompleted then
			if ply.RideCompleteTimer < CurTime() then
				ply:AddAchievement( ACHIEVEMENTS.HALLOWEENRIDE, 1 )
				ply.RideCompleted = false
			end
		end

        if not ply.HealthUpdate then ply.HealthUpdate = CurTime() end

        if ply.HealthUpdate < CurTime() then

            if ply:Health() < ply:GetMaxHealth() then

                ply:SetHealth( math.min( ply:Health() + GAMEMODE.HealthAdd, ply:GetMaxHealth() ) )
                ply.HealthUpdate = CurTime() + GAMEMODE.HealthAddDelay

                ply:UpdateSpeed()

            end

        end

    end

end )

// flashlight
hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
	return false
end )

// teleports player to start point
hook.Add( "PlayerSpawnClient", "PlayerTP", function( ply )

	ply.Connected = true

	ply:SetPos( Vector( -9072.031250, 3808, 32 ) )
	ply:SetEyeAngles( Angle( 0, -180, 0 ) )

end )

hook.Add( "CanPlayerSuicide", "SuicideCheck", function( ply )
	return !( IsValid( ply.ITM ) || IsValid( ply.Cart ) )
end )

// weapon switch commands
concommand.Add( "toggleflashlight", function( ply )

    ply:SelectWeapon( "lighter" )

end, nil, nil )

concommand.Add( "toggleghosttracker", function( ply )

    ply:SelectWeapon( "tracker" )

end, nil, nil )

// player meta functions
local meta = FindMetaTable( "Player" )

function meta:GiveEquipment()

    self:Give( "lighter" )
	self:Give( "tracker" )
	self:Give( "ectogun" )

	if !IsValid( self.ITM ) then
		self:ReplenishAmmo()
	else
		self:StripAmmo()
	end

end

function meta:ReplenishAmmo()

    // tracker battery
    self:SetAmmo( 100, "Battery" )

    // ecto-gun
    self:SetAmmo( 24, "AR2" )

    local wep = self:GetWeapon( "ectogun" )
    if IsValid( wep ) then
        wep:SetClip1( wep.Primary.DefaultClip )
    end

end

function meta:ReplenishHealth()

    self:SetHealth( self:GetMaxHealth() )

end

function meta:SetSpeed( speed )

    speed = speed or GAMEMODE.PlayerSpeed

    self:SetWalkSpeed( speed )
    self:SetRunSpeed( speed )
    self:SetSlowWalkSpeed( speed )

end

function meta:UpdateSpeed()

    local default = GAMEMODE.PlayerSpeed

    local health = self:Health()
    local maxhealth = self:GetMaxHealth()

    local ratio = health / maxhealth
    local speed = default * ratio

    self:SetSpeed( speed )

end