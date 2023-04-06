ITEM.Name = "Fairy Wings"
ITEM.Description = "Tinker Bell's remains are now part of your wingspan."
ITEM.Model = "models/gmod_tower/fairywings.mdl"
ITEM.DrawModel = true

ITEM.Equippable = true
ITEM.UniqueEquippable = true
ITEM.EquipType = "Jetpack"

ITEM.IsJetpack = true
ITEM.JetpackPower = 0.5
ITEM.JetpackFuel = -1
ITEM.JetpackRecharge = 0.05
ITEM.JetpackStartRecharge = 1
ITEM.JetpackHideFuel = true
ITEM.ExtraOnFloor = 50 //Amount of force the player has extra when jumping from the floor

ITEM.EquippableEntity = true //Should an entity be created from CreateEquipEntity ?


ITEM.StoreId = GTowerStore.MERCHANT
ITEM.StorePrice = 800

if SERVER then

	function ITEM:OnCreate( data )
	end
	
	function ITEM:OnEquip()
		self.Ply._JetpackFuel = 0.0
		self.Ply._JetpackLastStart = CurTime()
	end
	
	function ITEM:CreateEquipEntity()
		
		local JetpackEnt = ents.Create("gmt_jetpack")
		
		if IsValid( JetpackEnt ) then
			JetpackEnt:SetModel( self.Model )
			JetpackEnt:SetOwner( self.Ply )
			JetpackEnt:SetParent( self.Ply )
			JetpackEnt.Owner = self.Ply

			JetpackEnt:SetPos( self.Ply:GetPos() + Vector(0,0,32) )
			JetpackEnt:Spawn()
		end
		
		return JetpackEnt
		
	end
	
	
	function ITEM:CustomNW()
		local Valid = self:IsEquiped()
		
		umsg.Bool( Valid )
		//net.WriteBool( Valid )

		if self:IsEquiped() then
			umsg.Float( self.Ply._JetpackFuel )
			//net.WriteFloat( self.Ply._JetpackFuel )
			//net.WriteLong( self.Ply._JetpackLastStart )
			umsg.Long( self.Ply._JetpackLastStart )
		end	
	end
	
else	

	function ITEM:ReadFromNW( um )
		
		if um:ReadBool() == true then			
		//if net.ReadBool() == true then
			jetpack.ActiveJetpack = self
			
			self.Ply._JetpackFuel = um:ReadFloat() //net.ReadFloat()
			self.Ply._JetpackLastStart = um:ReadLong() //net.ReadLong()
			
		else
			jetpack.ActiveJetpack = nil
		end		
		
	end

end