
local CLASS = {}

CLASS.Name = "Doctor"
CLASS.PlayerModel = ""

CLASS.SpecialItemName = "Healing Kit"
CLASS.SpecialItemDesc = "This miracle of modern medicine will heal players within a small radius automatically."
CLASS.SpecialItem = "zm_item_special_healkit"
CLASS.SpecialItemDelay = 60

CLASS.PowerName = "Transplant"
CLASS.PowerDesc = "Why should the zombies have all the health? Take some from them and give it back to your teammates."
CLASS.PowerItem = "zm_item_power_transplant"
CLASS.PowerLength = 20
CLASS.PowerGotSound = "GModTower/zom/powerups/powerup_generic.wav"

if CLIENT then
	CLASS.SpecialItemMat = surface.GetTextureID( "gmod_tower/zom/hud_item_healkit" )
	CLASS.PowerMat = surface.GetTextureID( "gmod_tower/zom/hud_power_transplant" )
end

function CLASS:Setup( ply )
	self.Player = ply
end

function CLASS:PowerStart( ply )

	local ent = ents.Create( self.PowerItem )
	ent:SetPos( ply:GetPos() )
	ent:SetTransplant( ply )
	ent:Spawn()

	ply.TransplantEnt = ent

end

function CLASS:PowerEnd( ply )

	if IsValid( ply.TransplantEnt ) then
		ply.TransplantEnt:EmitSound("gmodtower/zom/weapons/explode"..math.random(3,5)..".wav", 80)
		ply.TransplantEnt:Remove()
	end

end

classmanager.Register( "doctor", CLASS )