function ValidPlayer( ply )
	return ply && ply:IsValid() && ply:IsPlayer()
end
IsPlayer = ValidPlayer

function SafeRemove( obj )
	
	if type( obj ) == "table" then
		table.walk( obj, SafeRemove )
		return
	end
	
	if obj && obj:IsValid() then
		obj:Remove()
	end
	
end

function timetoint( min, sec )
	return min * 60 + sec
end

function numtobool( num )
	return num > 0
end

function booltonum( bool )
	if bool then return 1 end
	return 0
end

// insane hash algorithm
function simplehash(str)
	local hash = 1

	for i=1, #str do
		hash = (2 * hash) + string.byte(str, i)
	end
	hash = hash % 55565

	return hash
end

ApproachSupport = function( cur, target, TarMulti )
	return SpecialApproach( cur , target, (math.abs( target - cur ) + 1) * (TarMulti or 1) * FrameTime() )
end

ApproachSupport2 = function ( cur, target, TarMulti )
	return math.Approach( cur , target, (math.abs( target - cur ) + 1) * (TarMulti or 1) * FrameTime() )
end

function SpecialApproach(cur, target, inc)

	if (cur < target) then
		
		return math.Clamp( math.ceil( cur + inc ), cur, target )

	elseif (cur > target) then

		return math.Clamp( math.floor( cur - inc ) , target, cur )

	end

	return target

end

if CLIENT then

	if !GetWorldEntity then
		GetWorldEntity = function() return GetWorldEntity() end
	end

	function SetDrawColor( color )
		surface.SetDrawColor( color.r, color.g, color.b, color.a )
	end

	hook.Add( "InitPostEntity", "CallPlayerSpawn", function()
		for _, ply in pairs( player.GetAll() ) do
			timer.Simple( 1.0, hook.Call, "PlayerSpawn", GAMEMODE, ply )
		end
	end )

end