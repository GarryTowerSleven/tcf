GtowerAchivements:Add( ACHIVEMENTS.ZOMBIERP, {
	Name = "Zombie RP",
	Description = "Roleplay as a zombie.",
	Value = 1
	}
)

if CLIENT then return end

hook.Add("PlayerThink", "AchiZombieHat", function(ply)

	if ply:AchivementLoaded() && ply:Alive() then

		if ply:GetModel() == "models/player/zombie_classic.mdl" then

      if !ply.CosmeticEquipment then return end

      for k,v in pairs( ply.CosmeticEquipment ) do
        if v:GetModel() == "models/gmod_tower/headcrabhat.mdl" then
          ply:SetAchivement( ACHIVEMENTS.ZOMBIERP, 1 )
        end
      end

		end
	end

end )
