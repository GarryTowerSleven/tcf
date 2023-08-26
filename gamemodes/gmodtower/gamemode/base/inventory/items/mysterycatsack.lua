ITEM.Name = "Mysterious Cat Sack"
ITEM.Description = "What could be inside this mysterious cat sack?"
ITEM.Model = "models/gmod_tower/catbag.mdl"
ITEM.ClassName = "mysterycatsack"
ITEM.UniqueInventory = false
ITEM.DrawModel = true
ITEM.CanUse = true
ITEM.UseDesc = "Open"

ITEM.StoreId = GTowerStore.MERCHANT
ITEM.StorePrice = 100

ITEM.Nyan = {
	"GModTower/lobby/catsack/nyan1.wav",
	"GModTower/lobby/catsack/nyan2.wav",
	"GModTower/lobby/catsack/nyan3.wav"
}

if SERVER then
	function ITEM:OnUse()
		if IsValid( self.Ply ) && self.Ply:IsPlayer() then
			self.Ply:EmitSound( self.Nyan[math.random(1, #self.Nyan)] )
			self.Ply:AddAchievement( ACHIEVEMENTS.CURIOUSCAT, 1 )

			return GTowerItems:CreateById( GTowerItems.CreateMysteryItem(self.Ply), self.Ply )
		end
		
		return self
	end
end