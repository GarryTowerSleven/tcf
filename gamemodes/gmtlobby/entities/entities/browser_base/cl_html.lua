local PANEL = {}

function PANEL:Init()
	//self.BaseClass.Init( self )
	self:SetPaintedManually( true )
	//print("initing HTML Panel")
end

function PANEL:SetEntity( ent )
	self.Entity = ent
end

function PANEL:OpeningURL( url, target, postdata, postdataset )
	
end

function PANEL:FinishedURL( url )
	if IsValid( self.Entity ) then
		self.Entity:onBeginNavigation( url )
	end
end

function PANEL:StatusChanged( status )
	
end


/**
	FUNCTION FOR BACKWARDS COMPABILITY
*/

function PANEL:Exec( js )
	self:QueueJavascript( js )
end

function PANEL:LoadURL( target )
	print("Loading url: ", target )
	self:OpenURL( target )
end

function PANEL:KeyEvent( key, bool, bool )
	
end

function PANEL:Update()
	
end

function PANEL:MouseUpDown( down, amount )

	if down then
		gui.InternalMousePressed( MOUSE_LEFT )
	else
		gui.InternalMouseReleased( MOUSE_LEFT )
	end

end

function PANEL:MouseMove( x, y )

	gui.InternalCursorMoved( x, y )

end

function PANEL:MouseScroll( delta )

	gui.InternalMouseWheeled( self, delta )

end

function PANEL:Free()
	self:Remove()
end

vgui.Register( "GMTBrowserHTML", PANEL, "DHTML" )