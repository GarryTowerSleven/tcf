include( "shared.lua" )

CreateConVar( "cl_playerglowcolor", "0 0 0", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateClientConVar( "gmt_vip_enableglow", 1, true, true )

//local VIPColor = Color( 163, 73, 164 )
local haloVIP = CreateClientConVar( "gmt_vipglow", 1, true, false )
local VIPHalos = {}
local LastThink = 0

cvars.AddChangeCallback("gmt_vip_enableglow", function()
	RunConsoleCommand("gmt_updateglow")
end)

hook.Add( "PlayerThink", "VIPHaloCheck", function( ply )

	if !IsLobby then return end
	if !haloVIP:GetBool() then return end
	if LastThink > CurTime() then return end

	VIPHalos = {}

	for _, ply2 in pairs( Location.GetPlayersInLocation( ply:Location() ) ) do

		if !ply2:IsPlayer() || !ply2:IsVIP() || !ply2:IsGlowEnabled() || Dueling.IsDueling( ply2 ) || ply2:GetNWBool( "InLimbo" ) then continue end
		if ply2:IsTransparent() or ply2:IsNoDrawAll() then continue end // TODO

		if IsValid( ply2 ) and ply2:Alive() and ply2:GetColor().a == 255 and ply2:GetGlowColor() then

			local color = ply2:GetGlowColor() * 255

			if color.r == 0 && color.g == 0 && color.b == 0 then continue end

			local objects = {}

			-- Support driving object glow
			local ent = ply2:GetNet("DrivingObject")
			if IsValid( ent ) then
				table.insert( objects, ent )
			else

				-- Player is not using a drivable
				table.insert( objects, ply2 )

				// Gather their hats and stuff
				if ply2.CosmeticEquipment then
					table.Add( objects, ply2.CosmeticEquipment )
				end

			end

			local halodata = {
				color = Color( color.r, color.g, color.b, 128 ),
				objects = objects
			}
			table.insert( VIPHalos, halodata )

		end

	end

	LastThink = CurTime() + 1

end )

hook.Add( "PreDrawHalos", "VIPHalos", function()

	if !IsLobby then return end
	if !haloVIP:GetBool() then return end
	if !VIPHalos then return end

	for id, halodata in pairs( VIPHalos ) do

		halo.Add( halodata.objects, halodata.color, 2, 2, 1 )

	end

end )