include("shared.lua")

local BAL = 0

hook.Add("CalcView", "DrunkCalc", function(ply, origin, angle, fov)
	local newBAL = ply:GetNet("BAL")

	if !newBAL then return end

	if newBAL < BAL then
		BAL = math.Approach(BAL, newBAL, -0.2)
	else
		BAL = math.Approach(BAL, newBAL, 0.1)
	end

	if newBAL <= 0 then return end

	local multiplier = ( 20 / 100 ) * BAL;
	angle.pitch = angle.pitch + math.sin( RealTime() ) * multiplier;
	angle.roll = angle.roll + math.cos( RealTime() ) * multiplier;
end)

hook.Add("RenderScreenspaceEffects", "DrunkEffect", function()
	local lp = LocalPlayer()
	if !IsValid(lp) || BAL <= 0 then return end
	
	local alpha = ( ( 1 / 100 ) * BAL );
	if( alpha > 0 ) then
	
		alpha = math.Clamp( 1 - alpha, 0.04, 0.99 );
		
		DrawMotionBlur( alpha, 0.9, 0.0 );
		
	end

	local sharp = ( ( 0.75 / 100 ) * BAL );
	if( sharp > 0 ) then
		DrawSharpen( sharp, 0.5 );
	end
	
	local frac = math.min( BAL / 60, 1 );
	
	local rg = ( ( ( 0.2 / 100 ) * BAL ) + 0.1 ) * frac;

	local tab = {};
	tab[ "$pp_colour_addr" ] 		= rg
	tab[ "$pp_colour_addg" ] 		= rg
	tab[ "$pp_colour_addb" ] 		= 0
	tab[ "$pp_colour_brightness" ] 	= -( ( 0.05 / 100 ) * BAL )
	tab[ "$pp_colour_contrast" ] 	= 1 - ( ( 0.5 / 100 ) * BAL )
	tab[ "$pp_colour_colour" ] 		= 1
	tab[ "$pp_colour_mulr" ] 		= 0
	tab[ "$pp_colour_mulg" ] 		= 0
	tab[ "$pp_colour_mulb" ] 		= 0
	
	DrawColorModify( tab );

end)


hook.Add("CreateMove", "DrunkMove", function(ucmd)
	local ply = LocalPlayer()
	if !IsValid(ply) || BAL <= 0 then return end

	local sidemove = math.sin( CurTime() ) * ( ( 150 / 100 ) * ply:GetNet("BAL") )
	ucmd:SetSideMove( ucmd:GetSideMove() + sidemove )
end)