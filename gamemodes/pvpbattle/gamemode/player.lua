PlayerMeta = FindMetaTable( "Player" )

// switches to the next available weapon on the player
function PlayerMeta:SwitchToNextWeapon()

	if !SERVER then return end
	
	local solved = false
	
	local weps = self:GetWeapons()
	
	local curwep = self:GetActiveWeapon():GetClass()
	
	for k, v in ipairs( weps ) do
		Classname = v:GetClass()
		if ( curwep != Classname ) then
			solved = true
			break
		end
	end
	
	if solved == true then
		self:SelectWeapon( Classname )
	else
		return
	end
	
end