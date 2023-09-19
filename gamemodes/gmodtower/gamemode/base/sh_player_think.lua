if SERVER then

    UseNewThink = CreateConVar( "gmt_use_new_think", "0", FCVAR_ARCHIVE, nil, 0, 1 )

    local PlayerList = nil
    local PlayerTodo = 1
    local LastTime = 0
    local ExtraTicks = 0
    local Increment = 0

    hook.Add( "Tick", "PlayerThink", function()

        if not UseNewThink:GetBool() then return end

        if PlayerList and table.IsEmpty( PlayerList ) then
            PlayerList = nil
        end

        if not PlayerList and LastTime + 1 < CurTime() then

            PlayerList = player.GetAll()
            local tickrate = ( 1 / engine.TickInterval() )

            PlayerTodo = math.floor( #PlayerList / tickrate )
            ExtraTicks = tickrate * ( (#PlayerList / tickrate) % 1 )

            LastTime = CurTime()

            Increment = 0

        end

        if not PlayerList then return end

        for i=1, math.Clamp( PlayerTodo + ( Increment < ExtraTicks and 1 or 0 ), 1, #PlayerList ) do

            local ply = table.remove( PlayerList, 1 )

            if IsValid( ply ) then
                
                hook.Run( "PlayerThink", ply )

            end

        end

        Increment = Increment + 1

    end )
    
end

local ThinkTime = 0

hook.Add( "Think", "GTowerPlayerThink", function()

    if SERVER and UseNewThink:GetBool() then return end

	if ThinkTime < CurTime() then

		if SERVER then

			for _, v in ipairs( player.GetAll() ) do

				if IsValid( v ) then
					hook.Call("PlayerThink", GAMEMODE, v)
				end

			end

		else
			if IsValid( LocalPlayer() ) then
				hook.Call( "PlayerThink", GAMEMODE, LocalPlayer() )
			end
		end

		ThinkTime = CurTime() + 1

	end
	
end )