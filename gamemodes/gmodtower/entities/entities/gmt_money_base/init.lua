AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    
    self:PhysicsInitSphere( 30 )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
    self:SetTrigger( true )
    
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
    
    self.MoneyAlreadyTouch = false

end

function ENT:Touch( ply )

    if not IsValid(ply) or not ply:IsPlayer() then return end
	
    ply:EmitSound( self.PickupSound )
	ply:AddMoney( self.MoneyValue, nil, nil, nil, "gmt_money Entity" )

    self:Remove()

end

concommand.Add("gmt_devmoney", function(ply, cmd, args)

    if not ply:IsStaff() then return end
	
	local modelvalues = {
		{"one", 1},
		{"ten", 10},
		{"twentyfive", 25},
		{"fifty", 50}
	}
	
	local num = math.Clamp(tonumber(args[1] or 4), 1, 4)
	
	local modelname = Model("models/gmt_money/" .. modelvalues[ num ][ 1 ] .. ".mdl")

    AdminNotif.SendStaff( Format( "%s has spawned money. (%s GMC)", ply:Nick(), tostring( modelvalues[ num ][ 2 ] ) ), nil, "GREEN" )
	
    local ent = ents.Create( "gmt_money_base" )
	ent:SetModel( modelname )
	ent.MoneyValue = modelvalues[ num ][ 2 ]
    ent:SetPos( ply:GetEyeTrace().HitPos + Vector(0, 0, 10) )
    ent:Spawn()

end)
