
-----------------------------------------------------
-- Noooooo don't look ;-;

GENICON = {}

function GenerateIcon( ID, Model )
	GENICON.iconPanel = vgui.Create( "DFrame" )
	GENICON.iconPanel:SetPos( 0, 0 )
	GENICON.iconPanel:SetSize( 64, 64 )
	GENICON.iconPanel:SetTitle( " " )
	GENICON.iconPanel:SetVisible( true )
	GENICON.iconPanel:MakePopup()
	GENICON.iconPanel.btnMaxim:SetVisible( false )
	GENICON.iconPanel.btnMinim:SetVisible( false )
	GENICON.iconPanel.btnClose:SetVisible( false )
	GENICON.iconPanel.Paint = function()

		surface.SetDrawColor(36,49,93)
		surface.DrawRect( 0, 0, GENICON.iconPanel:GetWide(), GENICON.iconPanel:GetTall() )

	end

	print( "Generating Icon(" .. ID .. ") \"" .. Model .. "\"" )

	GENICON.icon = vgui.Create( "SpawnIcon", GENICON.iconPanel )
	GENICON.icon:SetSize( 48, 48 )
	GENICON.icon:SetPos( 8, 8 )
	GENICON.icon:SetModel( Model )

	timer.Simple( 0.2, function()
		IconGenID = ID
		CanGenIcon = true
	end )

end

hook.Add( "PostRender", "IconFix", function()
	if !CanGenIcon then return end
	CanGenIcon = false

			local capData = {
			format = "jpeg", -- Wai you break PNG garry?
			h = 64,
			w = 64,
			quality = 100,
			x = 0,
			y = 0
		}

		local data = render.Capture( capData )

		GENICON.iconPanel:Close()

		local f = file.Open( "gmt_icons/"..IconGenID..".jpg", "wb", "DATA" )
		f:Write( data )
		f:Close()

end)

function GenerateIconID( ID )
	local Model = GTowerItems.Items[ID].Model
	GenerateIcon( ID, Model )
end

function GenerateIcons( tbl )
	local i = 0

	for ID, Model in pairs( tbl ) do

		timer.Simple( i, function()

			GenerateIcon( ID, Model )

		end )

		i = i + 0.3 -- Lets not break our game heh

	end
end

concommand.Add( "gmt_generateicons", function( ply )
	if( !ply:IsAdmin() ) then return end

	local tblList = {}
	print( "Creating model list" )
	local f = file.Open( "gmt_icons/itemList.txt", "wb", "DATA" )

	for id, item in pairs( GTowerItems.Items ) do

		if item.Model == "" then continue end -- No model
		f:Write( id .. " - " .. item.Model .. "\r\n" )
		tblList[id] = item.Model

	end

	f:Close()

	print( "Generating " .. table.Count( tblList ) .. " icons!" )
	GenerateIcons( tblList )
end )
