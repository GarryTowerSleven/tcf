
local CLASS = {}

CLASS.Name = "Survivor"
CLASS.PlayerModel = ""

CLASS.SpecialItemName = "Blade Trap"
CLASS.SpecialItemDesc = "Having played too much Half-Life 2 before the outbreak, the Survivor constructed his own blade trap."
CLASS.SpecialItem = "zm_item_special_blade"
CLASS.SpecialItemDelay = 60

CLASS.PowerName = "Ramming Shield"
CLASS.PowerDesc = "The Survivor took a page out of someone’s book and decided to ram into the zombies, except he took a shield, too."
CLASS.PowerItem = "zm_item_special_shield"
CLASS.PowerLength = 10
CLASS.PowerGotSound = "GModTower/zom/powerups/powerup_generic.wav"

if CLIENT then
	CLASS.SpecialItemMat = surface.GetTextureID( "gmod_tower/zom/hud_item_blade" )
	CLASS.PowerMat = surface.GetTextureID( "gmod_tower/zom/hud_power_ramming" )
end

function CLASS:Setup( ply )
	self.Player = ply
end

function CLASS:PowerStart( ply )

	local ent = ents.Create( self.PowerItem )

	if !IsValid( ply.ShieldEnt ) then
		ent:SetPos( ply:GetPos() )
		ent:SetOwner(ply)
		ent:Spawn()

		ply.ShieldEnt = ent

		ply:SpeedUp()
		ply:EmitSound( "weapons/cguard/charging.wav", 100, 120 )
	end

end

function CLASS:PowerEnd( ply )
	if IsValid( ply.ShieldEnt ) then
		ply.ShieldEnt:Remove()
	end

	--ply:ResetSpeeds()
	-- Only works when calling directly for some odd reason.
	ply:SetLaggedMovementValue(1)

	ply:EmitSound( "ambient/energy/powerdown2.wav", 100, 120 )
end

classmanager.Register( "survivor", CLASS )