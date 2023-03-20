module( "GTowerIcons", package.seeall )

Icons = Icons or {}

function AddIcon(fileName, Name, width, height, actw, acth )

	if SERVER then return end

    local tbl = {}

    tbl.Name = Name
	tbl.fileplace = 'icons/' .. fileName
    tbl.img = surface.GetTextureID( tbl.fileplace )
    tbl.x = width
    tbl.y = height
	tbl.actx = actw or width
	tbl.acty = acth or height

    Icons[ Name ] = tbl
end

function GetIcon( Name )
    return Icons[ Name ]
end

AddIcon('playermenu_icons_pm', 'pm',         25, 25)
AddIcon('playermenu_icons_trade', 'trade',       25, 25 )
AddIcon('playermenu_icons_information', 'information',    25, 25 )
AddIcon('playermenu_icons_group', 'group',      24, 24 )
AddIcon('playermenu_icons_admin', 'admin',      25, 25 )

AddIcon('X_close', 'X_close',  16,  16, 8, 10 )

AddIcon('checkmark', 'checkmark',  16,  16, 16, 16 )
AddIcon('cancel', 'cancel',  16,  16 , 16, 16 )

AddIcon('big_arrow_down', 'big_arrow_down',  64, 64 )
AddIcon('big_arrow_up', 'big_arrow_up',  64, 64 )