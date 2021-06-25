function AddMultiServer( pos, ang, id, oldSky, newSky )

	local ms = ents.Create( "gmt_multiserver" )
	ms:SetPos( pos )
	ms:SetAngles( ang )
	ms:Spawn()
	ms:Activate()
	ms:SetId( id )

	local phys = ms:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:EnableMotion( false )
	end

	if ( oldSky == nil ) then return ms end

	for _, v in pairs( ents.FindByClass( "gmt_skymsg" ) ) do
		if ( v:GetSkin() == oldSky ) then
			v:SetSkin( newSky )
		end
	end

	return ms

end

function AddEnt( class, pos, ang )

	local ent = ents.Create( class )
	if ( !IsValid( class ) ) then
		//print("[AddEnt] Invalid Entity! -> "..class)
		//return
	end
	ent:SetPos( pos )
	ent:SetAngles( ang )
	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:EnableMotion( false )
	end

	return ent

end

function CreateBoard( pos, ang, skin )
	local board = ents.Create( "gmt_board" )

	if ( !IsValid( board ) ) then return end
	board:SetPos( pos )
	board:SetAngles( ang )
	board:SetSkin( skin )
	board:Spawn()
end

local function AddSoundScape( sound, pos )
	for _, v in ipairs( pos ) do

		local ent = ents.Create( "gmt_soundscape" )

		ent:SetPos( v[ 1 ] )
		ent:Spawn()
		ent:Activate()

		ent.VolScale = v[ 2 ]
		ent.SoundFile = sound

	end
end