
-----------------------------------------------------
miniMap = CreateClientConVar( "sk_minimap", 0, true, false )
local horn = CreateClientConVar( "sk_hornnum", 3, true, true )

//function GM:PlayerBindPress( ply, bind, pressed )
hook.Add("PlayerBindPress","RCCarControls",function( ply, bind, pressed )

	// Jump
	if bind == "+jump" && pressed then

		local kart = ply:GetKart()
		if IsValid( kart ) then
			RunConsoleCommand( "sk_jump" )
			kart:Jump()
		end
	end

	// Horn
	if bind == "+use" && pressed then
		local kart = ply:GetKart()

		if IsValid( kart ) then
			RunConsoleCommand( "sk_horn", horn:GetInt() )
		end

	end

end)
