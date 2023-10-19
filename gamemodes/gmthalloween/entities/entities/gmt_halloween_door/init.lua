AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    
    // oh my god
    local min, max = self:LocalToWorld( self.BoundsMin ), self:LocalToWorld( self.BoundsMax )
    self:SetCollisionBoundsWS( min, max )
    
    self:SetSolid( SOLID_BBOX )

    
    local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:EnableMotion( false )
	end

    self:SetUseType( SIMPLE_USE )

    self:DrawShadow( false )

    // kv
    if not self._Target then self:Remove() return end

    local target = ents.FindByName( self._Target )[1]
    if not IsValid( target ) then print( self, "fart!" ) return end

    local door = ents.FindByName( self._TargetDoor )[1]
    if not IsValid( door ) then print( self, "fart!" ) return end

    self.TargetLocation = target
    self.TargetDoor = door

end

function ENT:Use( activator, caller, useType, value )

    if ( not IsValid( self.TargetLocation ) ) then return end
    if ( activator._LastDoorUse and activator._LastDoorUse + self.DelayTime > CurTime() ) then return end
    
    activator:ScreenFade( SCREENFADE.OUT, color_black, self.DoorTime, 0 )

    activator._LastDoorUse = CurTime()

    activator:Freeze( true )

    timer.Simple( self.DoorTime, function()
        self:TeleportPlayer( activator )
    end )

    // if ( IsValid( self.TargetDoor ) ) then
    //     self.TargetDoor:Fire( "Open" )
    // end

end

function ENT:TeleportPlayer( ply )

    if not IsValid( ply ) or not IsValid( self.TargetLocation ) then return end

    ply:SetPos( self.TargetLocation:GetPos() )
    ply:SetEyeAngles( self.TargetLocation:GetAngles() )
    ply:ScreenFade( SCREENFADE.IN, color_black, self.DoorTime, 0 )

	if self.TargetLocation:GetName() == "madness_enter_destination" then
		ply:GiveEquipment()
		ply.ITM = self.TargetLocation
		ply:SetNet( "PlayerLocation", 2 )
	else
		ply:StripWeapons()
		ply:StripAmmo()
		ply.ITM = nil
		ply:SetNet( "PlayerLocation", 1 )
	end

    ply:Freeze( false )

    // if ( IsValid( self.TargetDoor ) ) then
    //     self.TargetDoor:Fire( "Close" )
    // end

end

function ENT:KeyValue( key, value )

    if ( key == "target" ) then
        self._Target = value
    elseif ( key == "door" ) then
        self._TargetDoor = value
    end

end