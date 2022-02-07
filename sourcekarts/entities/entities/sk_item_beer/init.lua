AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
  self:SetModel(self.Model)
  self:DrawShadow(false)
  self:PhysicsInitSphere(8)
  self:GetPhysicsObject():SetMass(50)
  self:SetTrigger(true)

  self.SpawnTime = CurTime()

end

function ENT:PhysicsCollide( colData, collider )
  local ent = colData.HitEntity

  if ( ent:GetClass() == "worldspawn" ) then
    self:OnHitGround()
  end

end

function ENT:OnHitGround()
  local phys = self:GetPhysicsObject()

  if IsValid(phys) then

    phys:EnableMotion(false)
    --self:DropToFloor()

  end

end

function ENT:Touch(v)
  if v:GetClass() == "sk_kart" && v:GetOwner():Team() == TEAM_PLAYING then

    if self:GetOwner() == v:GetOwner() && CurTime() - self.SpawnTime < 2 then return end

    if v:GetIsInvincible() then
      v:EmitSound( SOUND_REFLECT, 80 )
      self:Remove()
      return
    end

    if self:GetOwner() != v:GetOwner() then
      net.Start( "HUDMessage" )
      net.WriteString( "YOU HIT "..string.upper( v:GetOwner():Name() ) )
      net.Send( self:GetOwner() )
    end
v:GetOwner():SetNWInt("BAL",50)
v:GetOwner():Drink(60)
v:GetOwner():AddAchievement( ACHIEVEMENTS.SKDWI, 1 )

timer.Simple( 12, function()
  v:GetOwner():SetNWInt("BAL",0)
  v:GetOwner():UnDrunk()
end )

    self:Remove()

  end
end


function ENT:Think()
    /*for k,v in pairs( ents.FindInSphere( self:GetPos(), 18 ) ) do
      if v:GetClass() == "sk_kart" && v:GetOwner():Team() == TEAM_PLAYING then

        if v:GetIsInvincible() then
          v:EmitSound( SOUND_REFLECT, 80 )
          return
        end

        net.Start( "HUDMessage" )
			if self:GetOwner() == v:GetOwner() then
				net.WriteString( "YOU HIT YOURSELF!" )
			else
				net.WriteString( "YOU HIT "..string.upper( v:GetOwner():Name() ) )
			end
        net.Send( self:GetOwner() )

		v:GetOwner():SetNWInt("BAL",50)
		v:GetOwner():Drink(60)
		v:GetOwner():AddAchievement( ACHIEVEMENTS.SKDWI, 1 )

		timer.Simple( 12, function()
			v:GetOwner():SetNWInt("BAL",0)
			v:GetOwner():UnDrunk()
		end )

        self:Remove()

      end
    end

    self:NextThink(CurTime())*/

end
