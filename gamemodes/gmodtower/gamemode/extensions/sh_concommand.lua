local concommandAdd = concommand.Add

concommand.Add = function( cmd, func, ... )
	
	concommandAdd( cmd, function(...)
		SafeCall( func, ... )
	end, ... )

end

concommand.StaffAdd = function( cmd, func, ... )
	
	concommandAdd( cmd, function( ply, ...)
		
		if ply:IsStaff() then
			SafeCall( func, ply, ... )
		end
		
	end, ... )

end

concommand.AdminAdd = function( cmd, func, ... )
	
	concommandAdd( cmd, function( ply, ...)
		
		if ply:IsAdmin() then
			SafeCall( func, ply, ... )
		end
		
	end, ... )

end

concommand.DeveloperAdd = function( cmd, func, ... )
	
	concommandAdd( cmd, function( ply, ...)
		
		if ply.IsDeveloper && ply:IsDeveloper() then
			SafeCall( func, ply, ... )
		end
		
	end, ... )

end

concommand.StoreAdd = function( cmd, npcclass, func, ... )
	
	concommandAdd( cmd, function( ply, ...)

		local npc = GTowerStore:FindDealerNearby( ply:GetPos() )
		if IsValid( npc ) && npc:GetClass() == npcclass then
			SafeCall( func, ply, ... )
		end
		
	end, ... )

end