
-----------------------------------------------------
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Escalator"
ENT.Information		= "It spins around"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model			= Model("models/map_detail/deluxe_lobby_escalator.mdl")
ENT.Sound		= Sound( "GModTower/lobby/trainstation/escalator.mp3")

ENT.EscalatorSpeed = 5.5

hook.Add( "Move", "EscalatorMove", function( ply, mv )

  if IsValid(ply:GetGroundEntity()) && ply:GetGroundEntity():GetClass() == "gmt_escalator" then

    local self = ply:GetGroundEntity()

    local vel = mv:GetVelocity()

    if self:GetNWBool("Up") then
      vel = vel + (self:GetAngles():Forward() * (self.EscalatorSpeed - 2.25) )
    else
      vel = vel + (-self:GetAngles():Forward() * self.EscalatorSpeed )
    end

    mv:SetVelocity(vel)

  end

end )
