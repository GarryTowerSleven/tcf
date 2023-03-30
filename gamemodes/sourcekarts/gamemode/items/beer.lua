
-----------------------------------------------------
local ITEM = {}



ITEM.Name = "Beer"

ITEM.Model = "models/props/de_inferno/wine_barrel.mdl"

ITEM.Material = Material( "gmod_tower/sourcekarts/cards/beer" )

ITEM.Entity = "sk_item_beer"

ITEM.MaxUses = 1

ITEM.Fling = true



ITEM.Battle = false

ITEM.Chance = items.RARE

ITEM.MaxPos = 1



function ITEM:Start( ply, kart, power )



	if power > .25 then

		ply:FlingItem( self.Entity, 1000 * power )

	else

		--ply:DropItem( self.Entity )
		ply:FlingItem( self.Entity, 0 )

	end



end



items.Register( ITEM )



if CLIENT then



	hook.Add( "RenderScreenspaceEffects", "DrunkEffect", function()



		local BAL = LocalPlayer():GetNet("BAL")

		if BAL <= 0 then return end

		

		local alpha = ( ( 1 / 100 ) * BAL )

		if alpha > 0 then

		

			alpha = math.Clamp( 1 - alpha, 0.04, 0.99 )

			DrawMotionBlur( alpha, 0.9, 0.0 )

			

		end



		local sharp = ( ( 0.75 / 100 ) * BAL )

		if sharp > 0 then

			DrawSharpen( sharp, 0.5 )

		end

		

		local frac = math.min( BAL / 60, 1 )

		

		local rg = ( ( ( 0.2 / 100 ) * BAL ) + 0.1 ) * frac



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



	end )



end