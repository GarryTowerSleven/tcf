
-----------------------------------------------------
include('shared.lua')



local FONT = "GTowerSkyMsg"
local SMALLFONT = "GTowerSkyMsgSmall"
surface.CreateFont( FONT, {
	font = "Oswald",
	size = 144,
	weight = 600,
	antialias = true,
	additive = false
} )
surface.CreateFont( SMALLFONT, {
	font = "Oswald",
	size = 65,
	weight = 600,
	antialias = true,
	additive = false
} )
local NUMSides = 5



ENT.RenderGroup = RENDERGROUP_BOTH



local TEXT = "HAPPY BIRTHDAY! - "



function ENT:Initialize()

	self:SetRenderBounds(Vector(-5128,-5128,-5128), Vector(5128,5128,5128))



end



function ENT:Think() end



function ENT:Draw()

end



function ENT:DrawTranslucent()

	// Aim the screen forward

	/*

	local ang = LocalPlayer():EyeAngles()

	local pos = self.Entity:GetPos() + Vector( 0, 0, 70 ) + ang:Up() * math.sin( CurTime() ) * 8



	ang:RotateAroundAxis( ang:Forward(), 90 )

	ang:RotateAroundAxis( ang:Right(), 90 )

	*/



	local Owner = self:GetOwner()

	local NUMSides = string.len( TEXT )



	if !IsValid( Owner ) then

		return

	end



	// Aim the screen forward

	local ang = Owner:GetAimVector():Angle()

	local pos = Owner:GetPos() + ang:Up() * ( 90 + math.sin( CurTime() ) * 4 )



	local AngleDivision = 360 / NUMSides

	local LocalPos = LocalPlayer():EyePos()

	local DrawList = {}



	ang:RotateAroundAxis( ang:Up(), math.fmod( -CurTime() * 10, 360 ) )



	for i = 1, NUMSides do

		local DrawPos = pos + ang:Forward() * self.Distance

		local CurColor = Color(

			100 + math.abs( math.sin( -CurTime() * 3.14 * i * 0.03 ) * 155 ),

			100 + math.abs( math.sin( CurTime()  * 2.71	* i * 0.03 ) * 155 ),

			100 + math.abs( math.sin( -CurTime() * 6 	* i * 0.03 ) * 155 ) )



		table.insert( DrawList,

			{DrawPos, Angle( ang.p, ang.y, ang.r ), LocalPos:DistToSqr( DrawPos ), string.sub(TEXT, i, i), CurColor }

		)



		ang:RotateAroundAxis( ang:Up(), AngleDivision )



	end



	table.sort( DrawList, function( a, b )

		return a[3] > b[3]

	end )



	for _, v in ipairs( DrawList ) do

		self:DrawFace( v[1], v[2], v[4], v[5] )

	end



end



function ENT:DrawFace( pos, ang, txt, color )


	if txt == " " then

		return

	end



	local Alpha = 100



	ang:RotateAroundAxis( ang:Forward(), 90 )

	ang:RotateAroundAxis( ang:Right(), 90 )



	if (LocalPlayer():EyePos() - pos ):DotProduct( ang:Up() ) < 0 then

		Alpha = 255

		ang:RotateAroundAxis( ang:Right(), 180 )

	end





	// Start the fun

	cam.Start3D2D( pos, ang, 0.5 )


		surface.SetFont( FONT )

		surface.SetTextColor( color.r, color.g, color.b, 255 )



		local w, h = surface.GetTextSize( txt )



		surface.SetTextPos( -w/2, -h/2 )

		surface.DrawText( txt )



	cam.End3D2D()





end
