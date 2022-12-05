include("shared.lua")

local showCondo = CreateClientConVar( "gmt_admin_showcondo", 0, true, false )

ENT.RenderGroup = RENDERGROUP_BOTH
surface.CreateFont( "CondoInfoText", { font = "Verdana", size = 20, weight = 500 } )

function ENT:Draw()

	--[[local pos = self:GetPos()
	local angle = self:GetAngles()

	Debug3D.DrawAxis(pos, angle:Forward(), angle:Right(), angle:Up(), 10)
	Debug3D.DrawLine( pos, LocalPlayer():GetPos(), 50, Color(255,0,0) )
	Debug3D.DrawSolidBox( pos, angle, Vector(-100,130,0), Vector(100,0,130) )]]

end

function ENT:Initialize()
    local entloc = Location.Find( self:GetPos() )
    self.Room = GtowerRooms:Get(tonumber(entloc))
    self.RoomID = Location.GetCondoID(entloc)
    self.MediaPlayer = nil
    self.Door = nil

    for k,v in pairs( ents.FindByClass("gmt_condoplayer") ) do
        if v:GetNWInt("condoID") == self.RoomID then
            self.MediaPlayer = v
        end
    end

    self.Door = GtowerRooms.GetCondoDoor(self.RoomID)
end

function ENT:DrawTranslucent()

	if not LocalPlayer():IsStaff() or not showCondo:GetBool() then return end
    if !self.Room || !self.Room.Owner then return end

	local pos = self:GetPos() + Vector( 0, 0, 65 )
	local eyes = LocalPlayer():EyeAngles()
	local ang = Angle(0,eyes.y-90,90)

	cam.Start3D2D( pos, ang, .05 )

		draw.SimpleShadowText( "Condo: " .. tostring(self), "CondoInfoText", 0, -40 )
		draw.SimpleShadowText( "Owner: " .. tostring(self.Room.Owner), "CondoInfoText", 0, -20 )
		draw.SimpleShadowText( "ItemCount: " .. tostring(self.Room.Owner.GRoomEntityCount), "CondoInfoText", 0, 0 )
		draw.SimpleShadowText( "Door Bell: " .. tostring(self.Door:GetNWInt("DoorBell")), "CondoInfoText", 0, 20 )
		draw.SimpleShadowText( "Locked: " .. tostring(self.Room.Owner.GRoomLock), "CondoInfoText", 0, 40 )
		draw.SimpleShadowText( "Party: " .. tostring(self.Room.Owner:GetNWBool("Party")), "CondoInfoText", 0, 60 )
		draw.SimpleShadowText( "Mediaplayer: " .. tostring(self.MediaPlayer), "CondoInfoText", 0, 80 )
		draw.SimpleShadowText( "Tag: " .. tostring(self.Door:GetTagText()), "CondoInfoText", 0, 100 )

	cam.End3D2D()

end