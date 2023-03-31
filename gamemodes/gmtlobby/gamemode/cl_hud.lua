

-----------------------------------------------------
local surface = surface

local draw = draw

local Color = Color



SKIN = {}



SKIN.PrintName 					= "GMod Tower Skin"

SKIN.Author 					= "pixelTail Games"

SKIN.DermaVersion				= 1

SKIN.GwenTexture				= Material( "gwenskin/gmodtower.png" )



local darker_blue = Color(38, 109, 175)

local moredark_blue = Color(56, 142, 203)

local lighter_blue = Color(9, 127, 207) //Color(65, 148, 207)

local separator_blue = Color(49, 126, 179)



local text_white = Color(255, 255, 255)

local text_red = Color(200, 25, 25)



local inactive_blue = Color(9, 96, 155) //Color(42, 114, 169)

local rowa_blue = Color(85, 167, 221)

local rowb_blue = Color(52, 137, 195)

local header_blue = Color(25, 89, 147)



local trans_blue = Color(85, 167, 221, 50)

local dark_trans_blue = Color( 7, 51, 76, 128 )



local progress_green = Color(50, 255, 50)



SKIN.bg_color 					= darker_blue

SKIN.bg_color_sleep 			= Color( 70, 70, 70, 255 )

SKIN.bg_color_dark				= header_blue

SKIN.bg_color_bright			= lighter_blue

SKIN.bg_color_chat				= Color( 7, 51, 76, 180 )



SKIN.frame_border				= lighter_blue

SKIN.frame_title				= header_blue

SKIN.fontFrame					= "Default"

SKIN.fontItem 					= "GTowerbig"



SKIN.control_color 				= lighter_blue

SKIN.control_color_highlight	= darker_blue

SKIN.control_color_active 		= moredark_blue

SKIN.control_color_bright 		= Color( 255, 200, 100, 255 )

SKIN.control_color_dark 		= inactive_blue



SKIN.bg_alt1 					= rowa_blue

SKIN.bg_alt2 					= rowb_blue



SKIN.progressbar_color			= progress_green



SKIN.listview_hover				= Color( 55, 150, 211, 255 )

SKIN.listview_selected			= Color( 100, 170, 220, 255 )



SKIN.text_bright				= Color( 255, 255, 255, 255 )

SKIN.text_normal				= inactive_blue

SKIN.text_dark					= Color( 20, 20, 20, 255 )

SKIN.text_highlight				= text_white

SKIN.text_shadow				= Color( 0, 0, 0, 200 )



SKIN.texGradientUp				= Material( "gui/gradient_up" )

SKIN.texGradientDown			= Material( "gui/gradient_down" )



SKIN.combobox_selected			= SKIN.listview_selected



SKIN.panel_transback			= trans_blue

SKIN.tooltip					= Color( 255, 245, 175, 255 )



SKIN.colPropertySheet 			= darker_blue

SKIN.colTab			 			= moredark_blue

SKIN.colTabInactive				= lighter_blue



SKIN.colPropertySheet 			= Color( 170, 170, 170, 255 )

SKIN.colTab			 			= SKIN.colPropertySheet

SKIN.colTabText		 			= text_white

SKIN.colTabTextInactive			= inactive_blue

SKIN.colTabShadow				= separator_blue

SKIN.colTabTextAttention		= text_red

SKIN.fontTab					= "DermaDefault"



SKIN.colCollapsibleCategory		= trans_blue



SKIN.colCategoryText			= Color( 255, 255, 255, 255 )

SKIN.colCategoryTextInactive	= Color( 200, 200, 200, 255 )

SKIN.fontCategoryHeader			= "TabLarge"



SKIN.colNumberWangBG			= Color( 255, 240, 150, 255 )

SKIN.colTextEntryBG				= Color( 240, 240, 240, 255 )

SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )

SKIN.colTextEntryText			= Color( 20, 20, 20, 255 )

SKIN.colTextEntryTextHighlight	= Color( 173, 208, 208, 255 )



SKIN.colMenuBG					= Color( 255, 255, 255, 200 )

SKIN.colMenuBorder				= Color( 0, 0, 0, 200 )



SKIN.colButtonText				= Color( 255, 255, 255, 255 )

SKIN.colButtonTextDisabled		= Color( 255, 255, 255, 55 )

SKIN.colButtonBorder			= Color( 20, 20, 20, 255 )

SKIN.colButtonBorderHighlight	= Color( 255, 255, 255, 50 )

SKIN.colButtonBorderShadow		= Color( 0, 0, 0, 100 )

SKIN.fontButton					= "Default"



SKIN.tex = {}



SKIN.tex.Selection		 			= GWEN.CreateTextureBorder( 384, 32, 31, 31, 4, 4, 4, 4 );



SKIN.tex.Panels = {}

SKIN.tex.Panels.Normal				= GWEN.CreateTextureBorder( 256,		0,	63,	63,	16,	16,		16,	16 )

SKIN.tex.Panels.Bright				= GWEN.CreateTextureBorder( 256+64,	0,	63,	63,	16,	16,		16,	16 )

SKIN.tex.Panels.Dark				= GWEN.CreateTextureBorder( 256,		64,	63,	63,	16,	16,		16,	16 )

SKIN.tex.Panels.Highlight			= GWEN.CreateTextureBorder( 256+64,	64,	63,	63,	16,	16,		16,	16 )



SKIN.tex.Button						= GWEN.CreateTextureBorder( 480, 0,	31,		31,		8,	8,		8,	8 )

SKIN.tex.Button_Hovered				= GWEN.CreateTextureBorder( 480, 32,	31,		31,		8,	8,		8,	8 )

SKIN.tex.Button_Dead				= GWEN.CreateTextureBorder( 480, 64,	31,		31,		8,	8,		8,	8 )

SKIN.tex.Button_Down				= GWEN.CreateTextureBorder( 480, 96,	31,		31,		8,	8,		8,	8 )

SKIN.tex.Shadow						= GWEN.CreateTextureBorder( 448, 0,	31,		31,		8,	8,		8,	8 )



SKIN.tex.Tree						= GWEN.CreateTextureBorder( 256, 128, 127,	127,	16,	16,		16,	16 )

SKIN.tex.Checkbox_Checked			= GWEN.CreateTextureNormal( 448, 32, 15, 15 )

SKIN.tex.Checkbox					= GWEN.CreateTextureNormal( 464, 32, 15, 15 )

SKIN.tex.CheckboxD_Checked			= GWEN.CreateTextureNormal( 448, 48, 15, 15 )

SKIN.tex.CheckboxD					= GWEN.CreateTextureNormal( 464, 48, 15, 15 )

--SKIN.tex.RadioButton_Checked		= GWEN.CreateTextureNormal( 448, 64, 15, 15 )

--SKIN.tex.RadioButton				= GWEN.CreateTextureNormal( 464, 64, 15, 15 )

--SKIN.tex.RadioButtonD_Checked		= GWEN.CreateTextureNormal( 448, 80, 15, 15 )

--SKIN.tex.RadioButtonD				= GWEN.CreateTextureNormal( 464, 80, 15, 15 )

SKIN.tex.TreePlus					= GWEN.CreateTextureNormal( 448, 96, 15, 15 )

SKIN.tex.TreeMinus					= GWEN.CreateTextureNormal( 464, 96, 15, 15 )

--SKIN.tex.Menu_Strip				= GWEN.CreateTextureBorder( 0, 128, 127, 21, 1, 1, 1, 1 )

SKIN.tex.TextBox					= GWEN.CreateTextureBorder( 0, 150, 127, 21,		4,	4,		4,	4 )

SKIN.tex.TextBox_Focus				= GWEN.CreateTextureBorder( 0, 172, 127, 21,		4,	4,		4,	4 )

SKIN.tex.TextBox_Disabled			= GWEN.CreateTextureBorder( 0, 193, 127, 21,		4,	4,		4,	4 )

SKIN.tex.MenuBG_Column				= GWEN.CreateTextureBorder( 128, 128, 127, 63,		24, 8, 8, 8 )

SKIN.tex.MenuBG						= GWEN.CreateTextureBorder( 128, 192, 127, 63,		8, 8, 8, 8 )

SKIN.tex.MenuBG_Hover				= GWEN.CreateTextureBorder( 128, 256, 127, 31,		8, 8, 8, 8 )

SKIN.tex.MenuBG_Spacer				= GWEN.CreateTextureNormal( 128, 288, 127, 3 )

SKIN.tex.Menu_Strip					= GWEN.CreateTextureBorder( 0, 128, 127, 21,		8, 8, 8, 8)

SKIN.tex.Menu_Check					= GWEN.CreateTextureNormal( 448, 112, 15, 15 )

SKIN.tex.Tab_Control				= GWEN.CreateTextureBorder( 0, 256, 127, 127, 8, 8, 8, 8 )

SKIN.tex.TabB_Active				= GWEN.CreateTextureBorder( 0,		416, 63, 31, 8, 8, 8, 8 )

SKIN.tex.TabB_Inactive				= GWEN.CreateTextureBorder( 0+128,	416, 63, 31, 8, 8, 8, 8 )

SKIN.tex.TabT_Active				= GWEN.CreateTextureBorder( 0,		384, 63, 31, 8, 8, 8, 8 )

SKIN.tex.TabT_Inactive				= GWEN.CreateTextureBorder( 0+128,	384, 63, 31, 8, 8, 8, 8 )

SKIN.tex.TabL_Active				= GWEN.CreateTextureBorder( 64,		384, 31, 63, 8, 8, 8, 8 )

SKIN.tex.TabL_Inactive				= GWEN.CreateTextureBorder( 64+128,	384, 31, 63, 8, 8, 8, 8 )

SKIN.tex.TabR_Active				= GWEN.CreateTextureBorder( 96,		384, 31, 63, 8, 8, 8, 8 )

SKIN.tex.TabR_Inactive				= GWEN.CreateTextureBorder( 96+128,	384, 31, 63, 8, 8, 8, 8 )

SKIN.tex.Tab_Bar					= GWEN.CreateTextureBorder( 128, 352, 127, 31, 4, 4, 4, 4 )

		

SKIN.tex.Window = {}



SKIN.tex.Window.Normal				= GWEN.CreateTextureBorder( 0,	0,	127,	127,	8,	32,		8,	8 )

SKIN.tex.Window.Inactive			= GWEN.CreateTextureBorder( 128,	0,	127,	127,	8,	32,		8,	8 )



SKIN.tex.Window.Close				= GWEN.CreateTextureNormal( 32, 448, 31, 31 );

SKIN.tex.Window.Close_Hover			= GWEN.CreateTextureNormal( 64, 448, 31, 31 );

SKIN.tex.Window.Close_Down			= GWEN.CreateTextureNormal( 96, 448, 31, 31 );



SKIN.tex.Window.Maxi				= GWEN.CreateTextureNormal( 32 + 96*2, 448, 31, 31 );

SKIN.tex.Window.Maxi_Hover			= GWEN.CreateTextureNormal( 64 + 96*2, 448, 31, 31 );

SKIN.tex.Window.Maxi_Down			= GWEN.CreateTextureNormal( 96 + 96*2, 448, 31, 31 );



SKIN.tex.Window.Restore				= GWEN.CreateTextureNormal( 32 + 96*2, 448+32, 31, 31 );

SKIN.tex.Window.Restore_Hover		= GWEN.CreateTextureNormal( 64 + 96*2, 448+32, 31, 31 );

SKIN.tex.Window.Restore_Down		= GWEN.CreateTextureNormal( 96 + 96*2, 448+32, 31, 31 );



SKIN.tex.Window.Mini				= GWEN.CreateTextureNormal( 32 + 96, 448, 31, 31 );

SKIN.tex.Window.Mini_Hover			= GWEN.CreateTextureNormal( 64 + 96, 448, 31, 31 );

SKIN.tex.Window.Mini_Down			= GWEN.CreateTextureNormal( 96 + 96, 448, 31, 31 );



SKIN.tex.Scroller = {}

SKIN.tex.Scroller.TrackV				= GWEN.CreateTextureBorder( 384,				208, 15, 127, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonV_Normal		= GWEN.CreateTextureBorder( 384 + 16,		208, 15, 127, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonV_Hover			= GWEN.CreateTextureBorder( 384 + 32,		208, 15, 127, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonV_Down			= GWEN.CreateTextureBorder( 384 + 48,		208, 15, 127, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonV_Disabled		= GWEN.CreateTextureBorder( 384 + 64,		208, 15, 127, 4, 4, 4, 4 );



SKIN.tex.Scroller.TrackH				= GWEN.CreateTextureBorder( 384,	128,		127, 15, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonH_Normal		= GWEN.CreateTextureBorder( 384,	128 + 16,	127, 15, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonH_Hover			= GWEN.CreateTextureBorder( 384,	128 + 32,	127, 15, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonH_Down			= GWEN.CreateTextureBorder( 384,	128 + 48,	127, 15, 4, 4, 4, 4 );

SKIN.tex.Scroller.ButtonH_Disabled		= GWEN.CreateTextureBorder( 384,	128 + 64,	127, 15, 4, 4, 4, 4 );



SKIN.tex.Scroller.LeftButton_Normal		= GWEN.CreateTextureBorder( 464,			208,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.LeftButton_Hover		= GWEN.CreateTextureBorder( 480,			208,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.LeftButton_Down		= GWEN.CreateTextureBorder( 464,			272,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.LeftButton_Disabled	= GWEN.CreateTextureBorder( 480 + 48,	272,	15, 15, 2, 2, 2, 2 );



SKIN.tex.Scroller.UpButton_Normal		= GWEN.CreateTextureBorder( 464,			208 + 16,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.UpButton_Hover		= GWEN.CreateTextureBorder( 480,			208 + 16,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.UpButton_Down			= GWEN.CreateTextureBorder( 464,			272 + 16,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.UpButton_Disabled		= GWEN.CreateTextureBorder( 480 + 48,	272 + 16,	15, 15, 2, 2, 2, 2 );



SKIN.tex.Scroller.RightButton_Normal	= GWEN.CreateTextureBorder( 464,			208 + 32,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.RightButton_Hover		= GWEN.CreateTextureBorder( 480,			208 + 32,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.RightButton_Down		= GWEN.CreateTextureBorder( 464,			272 + 32,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.RightButton_Disabled	= GWEN.CreateTextureBorder( 480 + 48,	272 + 32,	15, 15, 2, 2, 2, 2 );



SKIN.tex.Scroller.DownButton_Normal		= GWEN.CreateTextureBorder( 464,			208 + 48,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.DownButton_Hover		= GWEN.CreateTextureBorder( 480,			208 + 48,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.DownButton_Down		= GWEN.CreateTextureBorder( 464,			272 + 48,	15, 15, 2, 2, 2, 2 );

SKIN.tex.Scroller.DownButton_Disabled	= GWEN.CreateTextureBorder( 480 + 48,	272 + 48,	15, 15, 2, 2, 2, 2 );



SKIN.tex.Menu = {}

SKIN.tex.Menu.RightArrow				= GWEN.CreateTextureNormal( 464, 112, 15, 15 );



SKIN.tex.Input = {}



SKIN.tex.Input.ComboBox = {}

SKIN.tex.Input.ComboBox.Normal			= GWEN.CreateTextureBorder( 384,	336,	127, 31, 8, 8, 32, 8 );

SKIN.tex.Input.ComboBox.Hover			= GWEN.CreateTextureBorder( 384,	336+32, 127, 31, 8, 8, 32, 8 );

SKIN.tex.Input.ComboBox.Down			= GWEN.CreateTextureBorder( 384,	336+64, 127, 31, 8, 8, 32, 8 );

SKIN.tex.Input.ComboBox.Disabled		= GWEN.CreateTextureBorder( 384,	336+96, 127, 31, 8, 8, 32, 8 );



SKIN.tex.Input.ComboBox.Button = {}

SKIN.tex.Input.ComboBox.Button.Normal		 = GWEN.CreateTextureNormal( 496,	272,	15, 15 );

SKIN.tex.Input.ComboBox.Button.Hover		 = GWEN.CreateTextureNormal( 496,	272+16, 15, 15 );

SKIN.tex.Input.ComboBox.Button.Down			 = GWEN.CreateTextureNormal( 496,	272+32, 15, 15 );

SKIN.tex.Input.ComboBox.Button.Disabled		 = GWEN.CreateTextureNormal( 496,	272+48, 15, 15 );



SKIN.tex.Input.UpDown = {}

SKIN.tex.Input.UpDown.Up = {}

SKIN.tex.Input.UpDown.Up.Normal				= GWEN.CreateTextureCentered( 384,		112,	7, 7 );

SKIN.tex.Input.UpDown.Up.Hover				= GWEN.CreateTextureCentered( 384+8,	112,	7, 7 );

SKIN.tex.Input.UpDown.Up.Down				= GWEN.CreateTextureCentered( 384+16,	112,	7, 7 );

SKIN.tex.Input.UpDown.Up.Disabled			= GWEN.CreateTextureCentered( 384+24,	112,	7, 7 );



SKIN.tex.Input.UpDown.Down = {}

SKIN.tex.Input.UpDown.Down.Normal			= GWEN.CreateTextureCentered( 384,		120,	7, 7 );

SKIN.tex.Input.UpDown.Down.Hover			= GWEN.CreateTextureCentered( 384+8,	120,	7, 7 );

SKIN.tex.Input.UpDown.Down.Down				= GWEN.CreateTextureCentered( 384+16,	120,	7, 7 );

SKIN.tex.Input.UpDown.Down.Disabled			= GWEN.CreateTextureCentered( 384+24,	120,	7, 7 );



SKIN.tex.Input.Slider = {}

SKIN.tex.Input.Slider.H = {}

SKIN.tex.Input.Slider.H.Normal			= GWEN.CreateTextureNormal( 416,	32,	15, 15 );

SKIN.tex.Input.Slider.H.Hover			= GWEN.CreateTextureNormal( 416,	32+16, 15, 15 );

SKIN.tex.Input.Slider.H.Down			= GWEN.CreateTextureNormal( 416,	32+32, 15, 15 );

SKIN.tex.Input.Slider.H.Disabled		= GWEN.CreateTextureNormal( 416,	32+48, 15, 15 );



SKIN.tex.Input.Slider.V = {}

SKIN.tex.Input.Slider.V.Normal			= GWEN.CreateTextureNormal( 416+16,	32,	15, 15 );

SKIN.tex.Input.Slider.V.Hover			= GWEN.CreateTextureNormal( 416+16,	32+16, 15, 15 );

SKIN.tex.Input.Slider.V.Down			= GWEN.CreateTextureNormal( 416+16,	32+32, 15, 15 );

SKIN.tex.Input.Slider.V.Disabled		= GWEN.CreateTextureNormal( 416+16,	32+48, 15, 15 );



SKIN.tex.Input.ListBox = {}

SKIN.tex.Input.ListBox.Background		= GWEN.CreateTextureBorder( 256,	256, 63, 127, 8, 8, 8, 8 );

SKIN.tex.Input.ListBox.Hovered			= GWEN.CreateTextureBorder( 320,	320, 31, 31, 8, 8, 8, 8 );

SKIN.tex.Input.ListBox.EvenLine			= GWEN.CreateTextureBorder( 352,  256, 31, 31, 8, 8, 8, 8 );

SKIN.tex.Input.ListBox.OddLine			= GWEN.CreateTextureBorder( 352,  288, 31, 31, 8, 8, 8, 8 );

SKIN.tex.Input.ListBox.EvenLineSelected			= GWEN.CreateTextureBorder( 320,	270, 31, 31, 8, 8, 8, 8 );

SKIN.tex.Input.ListBox.OddLineSelected			= GWEN.CreateTextureBorder( 320,	288, 31, 31, 8, 8, 8, 8 );



SKIN.tex.ProgressBar = {}

SKIN.tex.ProgressBar.Back		= GWEN.CreateTextureBorder( 384,	0, 31, 31, 8, 8, 8, 8 );

SKIN.tex.ProgressBar.Front		= GWEN.CreateTextureBorder( 384+32,	0, 31, 31, 8, 8, 8, 8 );





SKIN.tex.CategoryList = {}

SKIN.tex.CategoryList.Outer		= GWEN.CreateTextureBorder( 256,		384, 63, 63, 8, 8, 8, 8 );

SKIN.tex.CategoryList.Inner		= GWEN.CreateTextureBorder( 256 + 64,	384, 63, 63, 8, 21, 8, 8 );

SKIN.tex.CategoryList.Header	= GWEN.CreateTextureBorder( 320,			352, 63, 31, 8, 8, 8, 8 );



SKIN.tex.Tooltip		= GWEN.CreateTextureBorder( 384,	64, 31, 31, 8, 8, 8, 8 );

		

SKIN.Colours = {}



SKIN.Colours.Window = {}

SKIN.Colours.Window.TitleActive			= Color( 255, 255, 255 ); //GWEN.TextureColor( 4 + 8 * 0, 508 );

SKIN.Colours.Window.TitleInactive		= Color( 255, 255, 255 ); //GWEN.TextureColor( 4 + 8 * 1, 508 );



SKIN.Colours.Button = {}

SKIN.Colours.Button.Normal				= GWEN.TextureColor( 4 + 8 * 2, 508 );

SKIN.Colours.Button.Hover				= GWEN.TextureColor( 4 + 8 * 3, 508 );

SKIN.Colours.Button.Down				= GWEN.TextureColor( 4 + 8 * 2, 500 );

SKIN.Colours.Button.Disabled			= GWEN.TextureColor( 4 + 8 * 3, 500 );



SKIN.Colours.Tab = {}

SKIN.Colours.Tab.Active = {}

SKIN.Colours.Tab.Active.Normal			= GWEN.TextureColor( 4 + 8 * 4, 508 );

SKIN.Colours.Tab.Active.Hover			= GWEN.TextureColor( 4 + 8 * 5, 508 );

SKIN.Colours.Tab.Active.Down			= GWEN.TextureColor( 4 + 8 * 4, 500 );

SKIN.Colours.Tab.Active.Disabled		= GWEN.TextureColor( 4 + 8 * 5, 500 );



SKIN.Colours.Tab.Inactive = {}

SKIN.Colours.Tab.Inactive.Normal		= GWEN.TextureColor( 4 + 8 * 6, 508 );

SKIN.Colours.Tab.Inactive.Hover			= GWEN.TextureColor( 4 + 8 * 7, 508 );

SKIN.Colours.Tab.Inactive.Down			= GWEN.TextureColor( 4 + 8 * 6, 500 );

SKIN.Colours.Tab.Inactive.Disabled		= GWEN.TextureColor( 4 + 8 * 7, 500 );



SKIN.Colours.Label = {}

SKIN.Colours.Label.Default				= GWEN.TextureColor( 4 + 8 * 8, 508 );

SKIN.Colours.Label.Bright				= GWEN.TextureColor( 4 + 8 * 9, 508 );

SKIN.Colours.Label.Dark					= Color( 255, 255, 255 );

SKIN.Colours.Label.Highlight			= GWEN.TextureColor( 4 + 8 * 9, 500 );



SKIN.Colours.Tree = {}

SKIN.Colours.Tree.Lines					= GWEN.TextureColor( 4 + 8 * 10, 508 );		---- !!!

SKIN.Colours.Tree.Normal				= GWEN.TextureColor( 4 + 8 * 11, 508 );

SKIN.Colours.Tree.Hover					= GWEN.TextureColor( 4 + 8 * 10, 500 );

SKIN.Colours.Tree.Selected				= GWEN.TextureColor( 4 + 8 * 11, 500 );



SKIN.Colours.Properties = {}

SKIN.Colours.Properties.Line_Normal			= GWEN.TextureColor( 4 + 8 * 12, 508 );

SKIN.Colours.Properties.Line_Selected		= GWEN.TextureColor( 4 + 8 * 13, 508 );

SKIN.Colours.Properties.Line_Hover			= GWEN.TextureColor( 4 + 8 * 12, 500 );

SKIN.Colours.Properties.Title				= GWEN.TextureColor( 4 + 8 * 13, 500 );

SKIN.Colours.Properties.Column_Normal		= GWEN.TextureColor( 4 + 8 * 14, 508 );

SKIN.Colours.Properties.Column_Selected		= GWEN.TextureColor( 4 + 8 * 15, 508 );

SKIN.Colours.Properties.Column_Hover		= GWEN.TextureColor( 4 + 8 * 14, 500 );

SKIN.Colours.Properties.Border				= GWEN.TextureColor( 4 + 8 * 15, 500 );

SKIN.Colours.Properties.Label_Normal		= GWEN.TextureColor( 4 + 8 * 16, 508 );

SKIN.Colours.Properties.Label_Selected		= GWEN.TextureColor( 4 + 8 * 17, 508 );

SKIN.Colours.Properties.Label_Hover			= GWEN.TextureColor( 4 + 8 * 16, 500 );



SKIN.Colours.Category = {}

SKIN.Colours.Category.Header				= GWEN.TextureColor( 4 + 8 * 18, 500 );

SKIN.Colours.Category.Header_Closed			= GWEN.TextureColor( 4 + 8 * 19, 500 );

SKIN.Colours.Category.Line = {}

SKIN.Colours.Category.Line.Text				= GWEN.TextureColor( 4 + 8 * 20, 508 );

SKIN.Colours.Category.Line.Text_Hover		= GWEN.TextureColor( 4 + 8 * 21, 508 );

SKIN.Colours.Category.Line.Text_Selected	= GWEN.TextureColor( 4 + 8 * 20, 500 );

SKIN.Colours.Category.Line.Button			= GWEN.TextureColor( 4 + 8 * 21, 500 );

SKIN.Colours.Category.Line.Button_Hover		= GWEN.TextureColor( 4 + 8 * 22, 508 );

SKIN.Colours.Category.Line.Button_Selected	= GWEN.TextureColor( 4 + 8 * 23, 508 );

SKIN.Colours.Category.LineAlt = {}

SKIN.Colours.Category.LineAlt.Text				= GWEN.TextureColor( 4 + 8 * 22, 500 );

SKIN.Colours.Category.LineAlt.Text_Hover		= GWEN.TextureColor( 4 + 8 * 23, 500 );

SKIN.Colours.Category.LineAlt.Text_Selected		= GWEN.TextureColor( 4 + 8 * 24, 508 );

SKIN.Colours.Category.LineAlt.Button			= GWEN.TextureColor( 4 + 8 * 25, 508 );

SKIN.Colours.Category.LineAlt.Button_Hover		= GWEN.TextureColor( 4 + 8 * 24, 500 );

SKIN.Colours.Category.LineAlt.Button_Selected	= GWEN.TextureColor( 4 + 8 * 25, 500 );



SKIN.Colours.TooltipText	= GWEN.TextureColor( 4 + 8 * 26, 500 );





function SKIN:DrawGenericBackground( x, y, w, h, color )

	draw.RoundedBox( 8, x, y, w, h, color )

end



--[[---------------------------------------------------------

	Panel

-----------------------------------------------------------]]

function SKIN:PaintPanel( panel, w, h )



	if ( !panel.m_bBackground ) then return end	

	self.tex.Panels.Normal( 0, 0, w, h, panel.m_bgColor );



end



--[[---------------------------------------------------------

	Panel

-----------------------------------------------------------]]

function SKIN:PaintShadow( panel, w, h )



	SKIN.tex.Shadow( 0, 0, w, h );



end



--[[---------------------------------------------------------

	Frame

-----------------------------------------------------------]]

function SKIN:PaintFrame( panel, w, h )



	

	if ( panel.m_bPaintShadow ) then

	

		DisableClipping( true )

		SKIN.tex.Shadow( -4, -4, w+10, h+10 );

		DisableClipping( false )

	

	end

	

	if ( panel:HasHierarchicalFocus() ) then

	

		self.tex.Window.Normal( 0, 0, w, h );

		

	else

	

		self.tex.Window.Inactive( 0, 0, w, h );

		

	end



end



--[[---------------------------------------------------------

	Button

-----------------------------------------------------------]]

/*function SKIN:PaintButton( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel.Depressed || panel:IsSelected() || panel:GetToggle() ) then

		return self.tex.Button_Down( 0, 0, w, h );	

	end	

	

	if ( panel:GetDisabled() ) then

		return self.tex.Button_Dead( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Button_Hovered( 0, 0, w, h );	

	end

			

	self.tex.Button( 0, 0, w, h );



end*/



function SKIN:PaintButton( panel, w, h )



	panel:SetTextColor( Color( 255, 255, 255 ) )



	if ( panel.m_bBackground ) then



		if ( panel:GetDisabled() ) then



			draw.RoundedBox( 2, 0, 0, w, h, self.control_color_dark )



		elseif ( panel.Depressed ) then



			draw.RoundedBox( 2, 0, 0, w, h, self.control_color_dark )



		elseif ( panel.Hovered ) then



			draw.RoundedBox( 2, 0, 0, w, h, Color( 15 + 30, 78 + 30, 132 + 30 ) )



		else



			draw.RoundedBox( 2, 0, 0, w, h, self.control_color )



		end



	end



end



function SKIN:DrawButtonBorder( x, y, w, h, depressed )



	surface.SetDrawColor( self.colButtonBorder )

	surface.DrawOutlinedRect( x, y, w, h )



end



function SKIN:PaintOverButton( panel )

	return false

end





--[[---------------------------------------------------------

	Tree

-----------------------------------------------------------]]

function SKIN:PaintTree( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	//self.tex.Tree( 0, 0, w, h, panel.m_bgColor );



end





--[[---------------------------------------------------------

	CheckBox

-----------------------------------------------------------]]

function SKIN:PaintCheckBox( panel, w, h )



	if ( panel:GetChecked() ) then

	

		if ( panel:GetDisabled() ) then

			self.tex.CheckboxD_Checked( 0, 0, w, h )

		else

			self.tex.Checkbox_Checked( 0, 0, w, h )

		end

		

	else

	

		if ( panel:GetDisabled() ) then

			self.tex.CheckboxD( 0, 0, w, h )

		else

			self.tex.Checkbox( 0, 0, w, h )

		end

		

	end	



end



--[[---------------------------------------------------------

	ExpandButton

-----------------------------------------------------------]]

function SKIN:PaintExpandButton( panel, w, h )



	if ( !panel:GetExpanded() ) then 

		self.tex.TreePlus( 0, 0, w, h )

	else 

		self.tex.TreeMinus( 0, 0, w, h )	

	end	



end



--[[---------------------------------------------------------

	TextEntry

-----------------------------------------------------------]]

function SKIN:PaintTextEntry( panel, w, h )



	if ( panel.m_bBackground ) then

	

		/*if ( panel:GetDisabled() ) then

			self.tex.TextBox_Disabled( 0, 0, w, h )

		elseif ( panel:HasFocus() ) then

			self.tex.TextBox_Focus( 0, 0, w, h )

		else*/

			self.tex.TextBox( 0, 0, w, h )

		//end

	

	end

	

	panel:DrawTextEntryText( panel.m_colText, panel.m_colHighlight, panel.m_colCursor )

	

end



function SKIN:SchemeTextEntry( panel ) ---------------------- TODO

	

	panel:SetTextColor( self.colTextEntryText )

	panel:SetHighlightColor( self.colTextEntryTextHighlight )

	panel:SetCursorColor( Color( 0, 0, 100, 255 ) )



end



--[[---------------------------------------------------------

	Menu

-----------------------------------------------------------]]

function SKIN:PaintMenu( panel, w, h )



	draw.RoundedBox( 8, 0, 0, w, h, self.colMenuBG )



	/*if ( panel:GetDrawColumn() ) then

		self.tex.MenuBG_Column( 0, 0, w, h )

	else

		self.tex.MenuBG( 0, 0, w, h )

	end*/

	

end



function SKIN:PaintOverMenu( panel )

	draw.RoundedBox( 8, 0, 0, w, h, self.colMenuBorder )

end



/*---------------------------------------------------------

   Chat

---------------------------------------------------------*/

function SKIN:PaintChat( panel )



	local col = self.bg_color_chat

	if GTowerChat then

		col = GTowerChat.BGColor

	end



	surface.SetDrawColor( col.r, col.g, col.b, 250 )

	surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )



end



/*---------------------------------------------------------

   Scoreboard

---------------------------------------------------------*/

function SKIN:PaintScoreboard( panel )



	local color = self.bg_color

	self:DrawGenericBackground( 0, 40, panel:GetWide(), panel:GetTall() - 40, color )



end



/*---------------------------------------------------------

   ScoreboardItem

---------------------------------------------------------*/

function SKIN:PaintScoreboardItem( panel )

	surface.SetDrawColor(255,255,255,255)



	surface.SetTexture( panel.MiddleTexture ) 

	surface.DrawTexturedRect( panel.MiddlePosStart, 0, panel.MiddleWidth, 64 )

    

	if panel.IsFirst then

        surface.SetTexture( panel.LeftTexture )

        surface.DrawTexturedRect( 0, 0, 16, 64 )

	end

    

	if panel.IsLast then

        surface.SetTexture( panel.RightTexture )

        surface.DrawTexturedRect( panel.RightPos, 0, 16, 64 )

	end

    

    surface.SetFont(self.fontItem)



	local col = self.text_highlight

	local alpha = math.Clamp( CurTime() - panel.HoverTime, 0.0, 0.7 )

    

	if panel:IsSelected() then 

		surface.SetTextColor( self.text_shadow.r, self.text_shadow.g, self.text_shadow.b, self.text_shadow.a )

		surface.SetTextPos( panel.TextX + 1, panel.TextY + 2 )

		surface.DrawText( panel.Text )

	end

	

	if !panel:IsSelected() && !panel.Hovered then

		alpha = 0.7 - alpha

	end

	

	surface.SetTextColor( col.r, col.g, col.b, (alpha+0.3) * 255 )

	

    

	surface.SetTextPos( panel.TextX, panel.TextY )

	surface.DrawText( panel.Text )

end



/*---------------------------------------------------------

   ScoreboardHeader

---------------------------------------------------------*/

function SKIN:PaintScoreboardHeaderItem( panel )

	local col = self.bg_color_dark

	surface.SetDrawColor( col.r, col.g, col.b, col.a )

    

	surface.DrawRect( 3,0, panel:GetWide() - 6, 23 )

end



/*---------------------------------------------------------

   ScoreboardListItem

---------------------------------------------------------*/

function SKIN:PaintScoreboardListItem( panel )

	local col = self.bg_alt1

	if panel.Alt then col = self.bg_alt2 end

	surface.SetDrawColor( col.r, col.g, col.b, col.a )



	surface.DrawRect( 0,0, panel:GetWide(), panel:GetTall() )

end



/*---------------------------------------------------------

   Contect menu when you click on players

---------------------------------------------------------*/

function SKIN:PaintClientMenuMain( panel )

	

	local col = self.bg_color

	surface.SetDrawColor( col.r, col.g, col.b, col.a )



end



function SKIN:PaintClientMenuTitle( panel )

	

	local col = self.bg_color_dark

	surface.SetDrawColor( col.r, col.g, col.b, col.a )

	

	surface.SetTextColor( 255, 255, 255, 255 )



end



function SKIN:PaintClientMenuClose( panel )

	 local col = self.control_color_dark 

	 

	 if panel.Hovered then

		col = self.control_color_active

    end

	

	 surface.SetDrawColor( col.r, col.g, col.b, 255 )

	



end



--[[---------------------------------------------------------

	Menu

-----------------------------------------------------------]]

function SKIN:PaintMenuSpacer( panel, w, h )



	self.tex.MenuBG( 0, 0, w, h )

	

end



--[[---------------------------------------------------------

	MenuOption

-----------------------------------------------------------]]

function SKIN:PaintMenuOption( panel, w, h )



	if ( panel.m_bBackground && (panel.Hovered || panel.Highlight) ) then

		self.tex.MenuBG_Hover( 0, 0, w, h )

	end

	

	if ( panel:GetChecked() ) then

		self.tex.Menu_Check( 5, h/2-7, 15, 15 )

	end

	

end



--[[---------------------------------------------------------

	MenuRightArrow

-----------------------------------------------------------]]

function SKIN:PaintMenuRightArrow( panel, w, h )

	

	self.tex.Menu.RightArrow( 0, 0, w, h );



end



--[[---------------------------------------------------------

	PropertySheet

-----------------------------------------------------------]]

function SKIN:PaintPropertySheet( panel, w, h )



	-- TODO: Tabs at bottom, left, right



	local ActiveTab = panel:GetActiveTab()

	local Offset = 0

	if ( ActiveTab ) then Offset = ActiveTab:GetTall()-8 end

	

	self.tex.Tab_Control( 0, Offset, w, h-Offset )

	

end



--[[---------------------------------------------------------

	Tab

-----------------------------------------------------------]]

function SKIN:PaintTab( panel, w, h )



	//panel:SetTextColor( 255, 255, 255 )



	if ( panel:GetPropertySheet():GetActiveTab() == panel ) then

		return self:PaintActiveTab( panel, w, h )

	end

	

	self.tex.TabT_Inactive( 0, 0, w, h )

	

end



function SKIN:PaintActiveTab( panel, w, h )



	self.tex.TabT_Active( 0, 0, w, h )

	

end



--[[---------------------------------------------------------

	Button

-----------------------------------------------------------]]

function SKIN:PaintWindowCloseButton( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel:GetDisabled() ) then

		return self.tex.Window.Close( 0, 0, w, h, Color( 255, 255, 255, 50 ) );	

	end	

	

	if ( panel.Depressed || panel:IsSelected() ) then

		return self.tex.Window.Close_Down( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Window.Close_Hover( 0, 0, w, h );	

	end

			

	self.tex.Window.Close( 0, 0, w, h );



end



function SKIN:PaintWindowMinimizeButton( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel:GetDisabled() ) then

		return self.tex.Window.Mini( 0, 0, w, h, Color( 255, 255, 255, 50 ) );	

	end	

	

	if ( panel.Depressed || panel:IsSelected() ) then

		return self.tex.Window.Mini_Down( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Window.Mini_Hover( 0, 0, w, h );	

	end

			

	self.tex.Window.Mini( 0, 0, w, h );



end



function SKIN:PaintWindowMaximizeButton( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel:GetDisabled() ) then

		return self.tex.Window.Maxi( 0, 0, w, h, Color( 255, 255, 255, 50 ) );	

	end	

	

	if ( panel.Depressed || panel:IsSelected() ) then

		return self.tex.Window.Maxi_Down( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Window.Maxi_Hover( 0, 0, w, h );	

	end

			

	self.tex.Window.Maxi( 0, 0, w, h );



end



--[[---------------------------------------------------------

	VScrollBar

-----------------------------------------------------------]]

function SKIN:PaintVScrollBar( panel, w, h )



	//surface.SetDrawColor( self.bg_color.r, self.bg_color.g, self.bg_color.b, self.bg_color.a )

	//surface.DrawRect( 0, 0, w, h )



	self.tex.Scroller.TrackV( 0, 0, w, h );	



end



function SKIN:LayoutVScrollBar( panel )



	/*panel:SetPos( panel:GetParent():GetWide() - 12, 0 )

	panel:SetSize( 12, panel:GetParent():GetTall() )*/

	

	local Wide = panel:GetWide()

	local Scroll = panel:GetScroll() / panel.CanvasSize

	local BarSize = math.max( panel:BarScale() * panel:GetTall(), 10 )

	local Track = panel:GetTall() - BarSize

	Track = Track + 1

	

	Scroll = Scroll * Track

	

	panel.btnGrip:SetPos( 0, math.Clamp( Scroll, Scroll, Track ) )

	panel.btnGrip:SetSize( Wide, BarSize )



	panel.btnUp:SetSize( 0, 0 )

	panel.btnUp:SetVisible( false )



	panel.btnDown:SetSize( 0, 0 )

	panel.btnDown:SetVisible( false )

	

	/*panel.btnUp:SetPos( 0, 0, Wide, Wide )

	panel.btnUp:SetSize( Wide, Wide )

	

	panel.btnDown:SetPos( 0, panel:GetTall() - Wide, Wide, Wide )

	panel.btnDown:SetSize( Wide, Wide )*/



end



--[[---------------------------------------------------------

	ScrollBarGrip

-----------------------------------------------------------]]

function SKIN:PaintScrollBarGrip( panel, w, h )



	//draw.RoundedBox( 8, 0, 0, panel:GetWide(), panel:GetTall(), Color( self.control_color.r, self.control_color.g, self.control_color.b, self.control_color.a ) )



	if ( panel:GetDisabled() ) then

		return self.tex.Scroller.ButtonV_Disabled( 0, 0, w, h );	

	end

	

	if ( panel.Depressed ) then

		return self.tex.Scroller.ButtonV_Down( 0, 0, w, h );	

	end

	

	if ( panel.Hovered ) then

		return self.tex.Scroller.ButtonV_Hover( 0, 0, w, h );	

	end

		

	return self.tex.Scroller.ButtonV_Normal( 0, 0, w, h );



end



--[[---------------------------------------------------------

	ButtonDown

-----------------------------------------------------------]]

function SKIN:PaintButtonDown( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel.Depressed || panel:IsSelected() ) then

		return self.tex.Scroller.DownButton_Down( 0, 0, w, h );	

	end	

	

	if ( panel:GetDisabled() ) then

		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Scroller.DownButton_Hover( 0, 0, w, h );	

	end

			

	self.tex.Scroller.DownButton_Normal( 0, 0, w, h );



end



--[[---------------------------------------------------------

	ButtonUp

-----------------------------------------------------------]]

function SKIN:PaintButtonUp( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel.Depressed || panel:IsSelected() ) then

		return self.tex.Scroller.UpButton_Down( 0, 0, w, h );	

	end	

	

	if ( panel:GetDisabled() ) then

		return self.tex.Scroller.UpButton_Dead( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Scroller.UpButton_Hover( 0, 0, w, h );	

	end

			

	self.tex.Scroller.UpButton_Normal( 0, 0, w, h );



end



--[[---------------------------------------------------------

	ButtonLeft

-----------------------------------------------------------]]

function SKIN:PaintButtonLeft( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel.Depressed || panel:IsSelected() ) then

		return self.tex.Scroller.LeftButton_Down( 0, 0, w, h );	

	end	

	

	if ( panel:GetDisabled() ) then

		return self.tex.Scroller.LeftButton_Dead( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Scroller.LeftButton_Hover( 0, 0, w, h );	

	end

			

	self.tex.Scroller.LeftButton_Normal( 0, 0, w, h );



end



--[[---------------------------------------------------------

	ButtonRight

-----------------------------------------------------------]]

function SKIN:PaintButtonRight( panel, w, h )



	if ( !panel.m_bBackground ) then return end

	

	if ( panel.Depressed || panel:IsSelected() ) then

		return self.tex.Scroller.RightButton_Down( 0, 0, w, h );	

	end	

	

	if ( panel:GetDisabled() ) then

		return self.tex.Scroller.RightButton_Dead( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Scroller.RightButton_Hover( 0, 0, w, h );	

	end

			

	self.tex.Scroller.RightButton_Normal( 0, 0, w, h );



end





--[[---------------------------------------------------------

	ComboDownArrow

-----------------------------------------------------------]]

function SKIN:PaintComboDownArrow( panel, w, h )



	if ( panel.ComboBox:GetDisabled() ) then

		return self.Input.ComboBox.Button.Disabled( 0, 0, w, h );	

	end	

	

	if ( panel.ComboBox.Depressed || panel.ComboBox:IsMenuOpen() ) then

		return self.tex.Input.ComboBox.Button.Down( 0, 0, w, h );	

	end	

	

	if ( panel.ComboBox.Hovered ) then

		return self.tex.Input.ComboBox.Button.Hover( 0, 0, w, h );	

	end

			

	self.tex.Input.ComboBox.Button.Normal( 0, 0, w, h );



end



--[[---------------------------------------------------------

	ComboBox

-----------------------------------------------------------]]

function SKIN:PaintComboBox( panel, w, h )

	

	if ( panel:GetDisabled() ) then

		return self.Input.ComboBox.Disabled( 0, 0, w, h );	

	end	

	

	if ( panel.Depressed || panel:IsMenuOpen() ) then

		return self.tex.Input.ComboBox.Down( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Input.ComboBox.Hover( 0, 0, w, h );	

	end

			

	self.tex.Input.ComboBox.Normal( 0, 0, w, h );

	

end



--[[---------------------------------------------------------

	ComboBox

-----------------------------------------------------------]]

function SKIN:PaintListBox( panel, w, h )

	

	self.tex.Input.ListBox.Background( 0, 0, w, h );

	

end



--[[---------------------------------------------------------

	NumberUp

-----------------------------------------------------------]]

function SKIN:PaintNumberUp( panel, w, h )



	if ( panel:GetDisabled() ) then

		return self.Input.UpDown.Up.Disabled( 0, 0, w, h );	

	end	

	

	if ( panel.Depressed ) then

		return self.tex.Input.UpDown.Up.Down( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Input.UpDown.Up.Hover( 0, 0, w, h );	

	end

			

	self.tex.Input.UpDown.Up.Normal( 0, 0, w, h );

	

end

		

--[[---------------------------------------------------------

	NumberDown

-----------------------------------------------------------]]

function SKIN:PaintNumberDown( panel, w, h )



	if ( panel:GetDisabled() ) then

		return self.tex.Input.UpDown.Down.Disabled( 0, 0, w, h );	

	end	

	

	if ( panel.Depressed ) then

		return self.tex.Input.UpDown.Down.Down( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Input.UpDown.Down.Hover( 0, 0, w, h );	

	end

			

	self.tex.Input.UpDown.Down.Normal( 0, 0, w, h );

	

end



function SKIN:PaintTreeNode( panel, w, h )



	if ( !panel.m_bDrawLines ) then return end

	

	surface.SetDrawColor( self.Colours.Tree.Lines )

	

	if ( panel.m_bLastChild ) then

	

			surface.DrawRect( 9, 					0,		1, 	7 )

			surface.DrawRect( 9, 					7,		9, 	1 )

	

	else

			surface.DrawRect( 9, 					0,		1, 	h )

			surface.DrawRect( 9, 					7,		9, 	1 )

	end



end





function SKIN:PaintTreeNodeButton( panel, w, h )



	if ( !panel.m_bSelected ) then return end

	

	-- Don't worry this isn't working out the size every render

	-- it just gets the cached value from inside the Label

	local w, _ = panel:GetTextSize() 

	

	self.tex.Selection( 38, 0, w+6, h );



end



function SKIN:PaintSelection( panel, w, h )



	self.tex.Selection( 0, 0, w, h );



end



function SKIN:PaintSliderKnob( panel, w, h )



	if ( panel:GetDisabled() ) then	return self.tex.Input.Slider.H.Disabled( 0, 0, w, h ); end	

	

	if ( panel.Depressed ) then

		return self.tex.Input.Slider.H.Down( 0, 0, w, h );	

	end	

	

	if ( panel.Hovered ) then

		return self.tex.Input.Slider.H.Hover( 0, 0, w, h );	

	end

			

	self.tex.Input.Slider.H.Normal( 0, 0, w, h );



end



local function PaintNotches( x, y, w, h, num )



	if ( !num ) then return end



	local space = w / num

	

	for i=0, num do

	

		surface.DrawRect( x + i * space, y+4,	1,  5 )

	

	end



end



function SKIN:PaintNumSlider( panel, w, h )



	self:DrawGenericBackground( 0, 0, w, h, self.colCollapsibleCategory )

	surface.SetDrawColor( Color( 0, 0, 0, 100 ) )

	surface.DrawRect( 8, h/2-1,		w-15,  1 )

	

	PaintNotches( 8, h/2-1,		w-16,  1, panel.m_iNotches )



end



function SKIN:PaintProgress( panel, w, h )



	self.tex.ProgressBar.Back( 0, 0, w, h );

	self.tex.ProgressBar.Front( 0, 0, w * panel:GetFraction(), h );



end



function SKIN:PaintCollapsibleCategory( panel, w, h )



	surface.SetFont( "GTowerHUDMain" )



	// Override header

	local header = panel.Header:GetText()

	if ( !panel.Title || panel.Title != header ) && header != "" then

		panel.Title = header

		panel.Header:SetText( "" )

	end



	local title = panel.Title

	local txtw, txth = surface.GetTextSize( title )

	local alpha = 255

	local tabcolor = Color( 17, 50, 78, 255 )

	local bgcolor = Color( 57, 131, 181, 255 )



	if !panel.IsMouseOver then

		panel.IsMouseOver = function()

			local x,y = panel:CursorPos()

			return x >= 0 and y >= 0 and x <= txtw and y <= txth

		end

	end



	if !panel:GetExpanded() then

		alpha = 50

		tabcolor = colorutil.Brighten( Color( 34, 100, 156 ), .75 )

		bgcolor = Color( 57, 131, 181, 255 )



		if panel:IsMouseOver() then

			alpha = 150

			tabcolor = colorutil.Brighten( tabcolor, 1.1 )

		end

	end



	surface.SetTextColor( 255, 255, 255, alpha )



	// Top bar

	surface.SetDrawColor( tabcolor )

	surface.DrawRect( 0, 0, w, txth )



	// BG

	//surface.SetDrawColor( bgcolor.r, bgcolor.g, bgcolor.b, alpha )

	//surface.DrawRect( 0, txth, w, h - txth )



	// Text

	surface.SetTextPos( 3, -1 )

	surface.DrawText( title )



	/*if ( !panel:GetExpanded() && h < 40 ) then

		return self.tex.CategoryList.Header( 0, 0, w, h );

	end

	

	self.tex.CategoryList.Inner( 0, 0, w, h );*/



end



function SKIN:PaintCategoryList( panel, w, h )



	self.tex.CategoryList.Outer( 0, 0, w, h );



end



function SKIN:PaintCategoryButton( panel, w, h )



	if ( panel.AltLine ) then



		if ( panel.Depressed || panel.m_bSelected ) then surface.SetDrawColor( self.Colours.Category.LineAlt.Button_Selected );

		elseif ( panel.Hovered ) then surface.SetDrawColor( self.Colours.Category.LineAlt.Button_Hover );

		else surface.SetDrawColor( self.Colours.Category.LineAlt.Button ); end

	

	else

	

		if ( panel.Depressed || panel.m_bSelected ) then surface.SetDrawColor( self.Colours.Category.Line.Button_Selected );

		elseif ( panel.Hovered ) then surface.SetDrawColor( self.Colours.Category.Line.Button_Hover );

		else surface.SetDrawColor( self.Colours.Category.Line.Button ); end

		

	end



	surface.DrawRect( 0, 0, w, h );



end



function SKIN:PaintListViewLine( panel, w, h )



	if ( panel:IsSelected() ) then



		self.tex.Input.ListBox.EvenLineSelected( 0, 0, w, h );

	 

	elseif ( panel.Hovered ) then



		self.tex.Input.ListBox.Hovered( 0, 0, w, h );

	 

	elseif ( panel.m_bAlt ) then



		self.tex.Input.ListBox.EvenLine( 0, 0, w, h );

	         

	end



	/*local Col = nil

	

	if ( panel:IsSelected() ) then

		Col = self.listview_selected

	elseif ( panel.Hovered ) then

		Col = self.listview_hover

	elseif ( panel.m_bAlt ) then

		Col = self.bg_alt2

		

	else

		return

	end

		

	surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )

	surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )*/



end



function SKIN:PaintListView( panel, w, h )



	self.tex.Input.ListBox.Background( 0, 0, w, h )



	/*if ( panel.m_bBackground ) then

		//surface.SetDrawColor( 45, 125, 175, 255 )

		//panel:DrawFilledRect()

	end*/



end



function SKIN:PaintTooltip( panel, w, h )



	self.tex.Tooltip( 0, 0, w, h )



end



function SKIN:PaintMenuBar( panel, w, h )



	self.tex.Menu_Strip( 0, 0, w, h )



end





derma.DefineSkin( "gmtower", SKIN.PrintName, SKIN )



function GM:ForceDermaSkin() return "gmtower" end



// in the chance that the above is being bypassed

local gtowerskin = derma.GetNamedSkin("gmtower")

function derma.GetDefaultSkin() return gtowerskin end

function derma.GetNamedSkin() return gtowerskin end

GTowerHUD = {}

-- draw the hud?
GTowerHUD.Enabled = CreateClientConVar( "gmt_hud", 1, true, false )
local HideBetaMessage = CreateClientConVar( "gmt_admin_hidebetamsg", 0, true, false )

-- because native weapons don't have a way of giving us a max clip count
-- we need to cache the highest values we see
GTowerHUD.MaxAmmo = {}

-- Main HUD
GTowerHUD.Info = {
	Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),
	Texture = GTowerIcons2.GetIcon("gmt"),
	TextureWidth = 64,
	TextureHeight = 64,
	X = 10,
	Y = ScrH() - 90,
	Height = 70,
	Width = 250,
	OffHeight = 48,
	Background = Material( "gmod_tower/hud/bg_gradient.png", "unlightsmooth" )
}

-- Crosshair
GTowerHUD.Crosshair = {
	Enabled = CreateClientConVar( "gmt_hud_crosshair", 1, true, false ),
	AlwaysOn = CreateClientConVar( "gmt_hud_crosshair_always", 0, true, false ),
	Action = CreateClientConVar( "gmt_hud_crosshair_action", 0, true, false ),
	Material = Material( "gmod_tower/hud/crosshair.png" ),
	Size = 4,
	MaxSize = 16,
}

-- Money
GTowerHUD.Money = {
	LastAmount = 0,
	Amount = 0, -- this is approached
	Font = "GTowerHUDMainLarge",
}

-- Location
GTowerHUD.Location = {
	Font = "GTowerHUDMainSmall",
}

-- Ammo
GTowerHUD.Ammo = {
	Enabled = CreateClientConVar( "gmt_hud_ammo", 1, true, false ),
	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/ammo" ),
	Width = 256,
	Height = 256,
	MainFont =  "GTowerhuge",
	SecondaryFont = "GTowerbigbold",
}

-- Ammo bar
GTowerHUD.AmmoBar = {
	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/ammobar" ),
	Width = 130 - 4,
	Height = 130 - 4,
	CurrentRotation = 0, -- approached in think
	TargetRotation = 0, -- updated in draw
}

GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),
}

-- Location Change Notice
GTowerHUD.LocationChangeNotice = {
	Enabled = CreateClientConVar( "gmt_location_notice", 1, true, false ),
	Alpha = 0,
}


--[[GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),
	Title = "GMod 13 Notice!",
	Text = "Expect lots of bugs, Lua errors, and things just generally not working.\n "..
			"TVs, some Arcades, and Radios do not work. Please check our website for updates.\n "..
			"You can disable this notice in the settings.",
	--Text = "CHANGING LEVEL, REJOIN IF IT BREAKS!!",
}

GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_gmnotice", 1, true, false ),
	Title = "No Gamemodes Notice!",
	Text = "This is server is lobby only. There are no gamemodes on this server.\n "..
			"Join server #1 for gamemodes - IP: join.gmtower.org\n"..
			"You can disable this notice in the settings.",
	--Text = "CHANGING LEVEL, REJOIN IF IT BREAKS!!",
}]]

--[[GTowerHUD.News = {
	Enabled = CreateClientConVar( "gmt_newsticker", 1, true, false ),
	FeedURL = "http://www.gmtower.org/ticker.txt",
	Current = "No news."
}]]

--[[GTowerHUD.BallRace = {
	Texture = surface.GetTextureID( "gmod_tower/balls/hud_icon_antlion" ),
	LastSpeed = 0,
	Speed = 0,
	Rotation = 0,
}]]

-- Health
--[[GTowerHUD.Health = {
	Texture = surface.GetTextureID( "gmod_tower/lobby/hud/bar" ),
	Size = 0, -- this is changed in the think, because it's approached
	Height = 12,
	Font = "GTowerHUDMainSmall",
	MaxSize = GTowerHUD.Info.Width - 50,
	EnabledY = GTowerHUD.Info.Y + GTowerHUD.Info.Height - 8 - (12*2),
	DisabledY = GTowerHUD.Info.Y + GTowerHUD.Info.Height + 6,
	CurY = GTowerHUD.Info.Y + GTowerHUD.Info.Height + 6, -- approached in think
}]]

-- util func to cache unknown max clip values
function GTowerHUD.GetMaxAmmo( wepName, clip )
	
	-- if we haven't cached it, or it's larger
	if !GTowerHUD.MaxAmmo[ wepName ] || clip > GTowerHUD.MaxAmmo[ wepName ] then
		GTowerHUD.MaxAmmo[ wepName ] = clip
		return clip
	end
	
	return GTowerHUD.MaxAmmo[ wepName ]
end

local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )
function GTowerHUD.DrawInfo()

	if !GTowerHUD.Info.Enabled:GetBool() then return end
	if hook.Call( "DisableHUD", GAMEMODE, ply ) then return end

	surface.SetMaterial( GTowerHUD.Info.Background )
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawTexturedRect( 0, GTowerHUD.Info.Y-2, GTowerHUD.Info.Width, GTowerHUD.Info.TextureHeight+4 )

	surface.SetMaterial( GTowerHUD.Info.Texture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.TextureWidth, GTowerHUD.Info.TextureHeight )
	
	-- Ease money
    local function Money()
        return LocalPlayer():getDarkRPVar("money") or 0
    end
	if GTowerHUD.Money.LastAmount != Money() then
		GTowerHUD.Money.LastAmount = Money()
	end

	if GTowerHUD.Money.Amount != Money() then
		local diffMoney = GTowerHUD.Money.Amount - GTowerHUD.Money.LastAmount
		local increaseAmount = math.ceil( math.abs( diffMoney * .1 ) )
		GTowerHUD.Money.Amount = math.Approach( GTowerHUD.Money.Amount, Money(), increaseAmount )
	end

	-- GMC
	local money = string.Comma( GTowerHUD.Money.Amount )
	surface.SetFont( GTowerHUD.Money.Font )
	local tw, th = surface.GetTextSize( money )

	local x = GTowerHUD.Info.X + 75
	local y = GTowerHUD.Info.Y + 22

	draw.SimpleShadowText( money, GTowerHUD.Money.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
	draw.SimpleShadowText( "GMC", GTowerHUD.Location.Font, x + tw + 4, y + 6, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

	-- Icon
	--[[draw.SimpleShadowText( money, GTowerHUD.Money.Font, x + 32 - 8, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
	
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( GTowerIcons2.GetIcon("money") )
	surface.DrawTexturedRect( x - 6, y - 15, 32, 32 )]]

	-- Location
	y = y + 24
	local location = string.upper(LocalPlayer():getDarkRPVar("job") or "UNKNOWN") or "SOMEWHERE" // string.upper( LocalPlayer():LocationName() )
	draw.SimpleShadowText( location, GTowerHUD.Location.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

	-- Condo
	local roomid = LocalPlayer():GetNWInt("RoomID")

	if roomid and roomid > 0 then
		GTowerHUD.DrawExtraInfo( GTowerIcons2.GetIcon("condo"), "#" .. tostring(roomid) )
	end

end

function GTowerHUD.DrawExtraInfo( icon, text, iconSize )

	local x = GTowerHUD.Info.X - 10
	local y = GTowerHUD.Info.Y + GTowerHUD.Info.TextureHeight + 4
	local tall = 20

	iconSize = iconSize or 32

	surface.SetDrawColor( 0,0,0, 200 )
	surface.SetMaterial( GTowerHUD.Info.Background )
	surface.DrawTexturedRect( 0, y, GTowerHUD.Info.Width, tall )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( icon )
	surface.DrawTexturedRect( x, y + ( ( tall /2 ) - ( iconSize /2 ) ), iconSize, iconSize )

	draw.SimpleShadowText( text, "GTowerHUDMainSmall2", x+iconSize, y+10, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

end

function GTowerHUD.DrawUseMessage( ent, x, w, h )

	if not IsValid( ent ) then return end

	local use, nokey = CanPlayerUse( ent )
	if not use then return end

	if use then

		surface.SetFont( "GTowerHUDMain" )
		local tw, th = surface.GetTextSize(use)
		local offset = -(tw/2)

		if not nokey then

			local usekey = string.upper( input.LookupBinding( 'use' ) or "e" )

			surface.SetFont( "GTowerHUDMainLarge" )
			tw, th = surface.GetTextSize(usekey)
			tw = math.max(tw+8,th)
			offset = tw/2

			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( w + x - tw/2, h - th/2 + 2, tw, th )

			draw.SimpleText( usekey, "GTowerHUDMainLarge", w + x, h - th/2, Color( 255, 255, 255, 255 ), 1 )

		end

		draw.SimpleShadowText( use, "GTowerHUDMain", w + x + 4 + offset, h, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), TEXT_ALIGN_LEFT, 1, 1 )

	end

end

function GTowerHUD.DrawCrosshair()

	if LocalPlayer():ShouldDrawLocalPlayer() || !LocalPlayer():Alive() then return end

	local w, h = ScrW() / 2, ScrH() / 2
	local color = Color( 255, 255, 255 )
	local x = 0


		local size = GTowerHUD.Crosshair.Size
		surface.SetMaterial( GTowerHUD.Crosshair.Material )
		surface.SetDrawColor( color.r, color.g, color.b, 100 )
		surface.DrawTexturedRect( w - size/2, h - size/2, size, size )

		--[[if GTowerHUD.Crosshair.Action:GetBool() then
			GTowerHUD.DrawActionCrosshair()
		end]]


end

local curSpread = 5
local curAlpha = 180
function GTowerHUD.DrawActionCrosshair()

	local x = ScrW() / 2
	local y = ScrH() / 2
	local spread = 5
	local alpha = 180

	if LocalPlayer():KeyDown( IN_ATTACK ) then
		spread = 15
		alpha = 255
	end

	curSpread = math.Approach( curSpread, spread, FrameTime() * 60 )
	curAlpha = math.Approach( curAlpha, alpha, FrameTime() * 180 )

	local thickness = 4
	local width = 3
	local height = 3
	local halfWidth = width / 2
	local halfHeight = height / 2


	-- Black
	surface.SetDrawColor( 0, 0, 0, curAlpha * .85 )

	surface.DrawRect( x - halfWidth, y - halfHeight, width, height )

	-- Sides
	surface.DrawRect( x - curSpread - thickness - 1, y - halfHeight - 1.5, thickness + 2, height + 2 )
	surface.DrawRect( x + curSpread - 2, y - halfHeight - 1.5, thickness + 2, height + 2 )

	-- Top
	surface.DrawRect( x - halfWidth - 1.5, y - curSpread - thickness - 1, width + 2, thickness + 2 )
	surface.DrawRect( x - halfWidth - 1.5, y + curSpread - 2, width + 2, thickness + 2 )


	-- White
	surface.SetDrawColor( 255, 255, 255, curAlpha )

	-- Sides
	surface.DrawRect( x - curSpread - thickness, y - halfHeight, thickness, height )
	surface.DrawRect( x + curSpread - 1, y - halfHeight, thickness, height )

	-- Top
	surface.DrawRect( x - halfWidth, y - curSpread - thickness, width, thickness )
	surface.DrawRect( x - halfWidth, y + curSpread - 1, width, thickness )

end

function GTowerHUD.DrawHealth()

	// if !Location.Is( LocalPlayer():Location(), "duelarena" ) then return end

	local w = GTowerHUD.Info.Width
	local h = 8
	local x = 0 --GTowerHUD.Info.X - 6
	local y = GTowerHUD.Info.Y - h - 6
	local iconSize = 32
	local health = LocalPlayer():Health()
	if health < 0 then health = 0 end
	local maxHealth = 100
	if Dueling && Dueling.IsDueling( LocalPlayer() ) then
		maxHealth = 300
	end
	local percent = ( health / maxHealth )
	local ratio = 1 - ( percent )
	local oppred = 200 - ratio * math.sin( CurTime() * ratio * 3 ) * 55 + ( 1 - ratio ) * 55

	-- Gradient background
	surface.SetDrawColor( 0,0,0, 200 )
	surface.SetMaterial( GTowerHUD.Info.Background )
	surface.DrawTexturedRect( 0, y-10, w, 20 )

	-- Draw heart
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( GTowerIcons2.GetIcon("heart") )
	surface.DrawTexturedRect( x, y-16, iconSize, iconSize )

	-- Draw background
	surface.SetDrawColor( 80, 80, 80, 200 )
	surface.DrawRect( x+iconSize, y-4, w, h )

	-- Draw health bar
	surface.SetDrawColor( 255, 255, 255, 255 )
	draw.RectFillBorder( x+iconSize, y-4, w, h, 1, percent, Color( 125, 125, 125, 0 ), Color( 255, oppred, oppred ) )

end

function GTowerHUD.DrawAmmo()

	if !GTowerHUD.Ammo.Enabled:GetBool() then return end

	local weapon = LocalPlayer():GetActiveWeapon()
	
	if !IsValid( weapon ) then return end
	
	local name = weapon:GetPrintName()
	
	local currentMag = weapon:Clip1()
	local currentMax = 100 -- default max
	local currentAmmoType = weapon:GetPrimaryAmmoType()
	local currentAmmoLeft = LocalPlayer():GetAmmoCount( currentAmmoType )
	
	if !currentMag then return end --there's no ammo
	if currentMag <= 0 && currentAmmoLeft <= 0 then return end  --we're out of ammo - don't display this
	
	local ammoX = ScrW() - 160
	local ammoY = ScrH() - 160
	
	local ammoBarX = ammoX + ( 130 / 2 ) + 8
	local ammoBarY = ammoY + ( 130 / 2 ) + 6
	local ammoBarRot = 180 - ( ( currentMag / ( currentMax or 1 ) ) * 180 )
	
	GTowerHUD.AmmoBar.TargetRotation = ammoBarRot
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetTexture( GTowerHUD.AmmoBar.Texture )
	surface.DrawTexturedRectRotated( ammoBarX, ammoBarY, GTowerHUD.AmmoBar.Width, GTowerHUD.AmmoBar.Height, GTowerHUD.AmmoBar.CurrentRotation )

	surface.SetTexture( GTowerHUD.Ammo.Texture )
	surface.DrawTexturedRect( ammoX, ammoY, GTowerHUD.Ammo.Width, GTowerHUD.Ammo.Height )
	
	if currentMag != -1 then
		-- draw ammo text
		-- draw how much current ammo we have
		surface.SetFont( GTowerHUD.Ammo.MainFont )

		local curMagW, curMagH = surface.GetTextSize( currentMag )
		local curMagX, curMagY = ammoBarX - ( curMagW / 2 ), ammoBarY - ( curMagH / 2 )

		surface.SetTextPos( curMagX + 3, curMagY + 3 )
		surface.SetTextColor( 0, 0, 0, 40 )
		surface.DrawText( currentMag )

		surface.SetTextPos( curMagX, curMagY )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.DrawText( currentMag )
	end

	-- draw how much the mag can contain/how much ammo is left
	surface.SetFont( GTowerHUD.Ammo.SecondaryFont )  

	local fullMagW, fullMagH = surface.GetTextSize( currentAmmoLeft )
	local fullMagX, fullMagY = ammoX + 91 + ( 62 / 2 ) - ( fullMagW / 2 ), ammoY + 87 + ( 62 / 2 ) - ( fullMagH / 2 )

	surface.SetTextPos( fullMagX + 3, fullMagY + 3 )
	surface.SetTextColor( 0, 0, 0, 40 )
	surface.DrawText( currentAmmoLeft )

	surface.SetTextPos( fullMagX, fullMagY )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.DrawText( currentAmmoLeft )

end

function GTowerHUD.DrawNotice( title, message )

	if !GTowerHUD.Notice.Enabled:GetBool() then return end

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() / 2
	h = ( h * 2 ) - 150

	-- Draw gradient boxes
	--draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
	--draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 512, h, 1024, 110 )

	-- Draw title
	draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( message or "", "GTowerHudCSubText", w, h + 40, Color( 255, 255, 255, 255 ), 1 )

end

function GTowerHUD.DrawLocationChange( title, message )

	if !GTowerHUD.LocationChangeNotice.Enabled:GetBool() then return end
	if GTowerHUD.LocationChangeNotice.Alpha == 0 then return end

	local alpha = GTowerHUD.LocationChangeNotice.Alpha
	GTowerHUD.LocationChangeNotice.Alpha = math.Approach( alpha, 1, .002 )

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() - 150

	-- Draw gradient boxes
	draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, alpha*230 ) )
	draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, alpha*230 ), Color( 0, 0, 0, 0 ) )
	
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 512, h, 1024, 110 )


	draw.DrawText( "YOU ARE NOW IN", "GTowerHudCSubText", w, h + 10, Color( 200, 200, 200, alpha*255 ), 1 )

	-- Draw title
	draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, alpha*255 ), 1, 1 )

	-- Draw text
	draw.DrawText( message or "", "GTowerHudCSubText", w, h + 30, Color( 255, 255, 255, alpha*255 ), 1 )

end

--[[function GTowerHUD.DrawBallRace()

	GTowerHUD.BallRace.LastSpeed = GTowerHUD.BallRace.Speed or 0 
	GTowerHUD.BallRace.Speed = LocalPlayer()._BallRaceSpeed or 0

	local changeSpeed = math.floor( ( GTowerHUD.BallRace.LastSpeed - GTowerHUD.BallRace.Speed ) )

	if changeSpeed < -9 then
		changeSpeed = changeSpeed * .009 -- yay magic numbers!! this is to lower the speed for rotation
		GTowerHUD.BallRace.Rotation = GTowerHUD.BallRace.Rotation + changeSpeed
	end

	LocalPlayer():ChatPrint( tostring( GTowerHUD.BallRace.Rotation ) )

	surface.SetTexture( GTowerHUD.BallRace.Texture )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.DrawTexturedRectRotated( GTowerHUD.Info.X + GTowerHUD.Info.Width + 32, GTowerHUD.Info.Y + ( GTowerHUD.Info.Width / 2 ), 64, 64, GTowerHUD.BallRace.Rotation )

end]]

--[[function GTowerHUD.DrawNotice()

	if !GTowerHUD.Notice.Enabled:GetBool() then return end

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() / 2
	h = ( h * 2 ) - 150

	-- Draw gradient boxes
	draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
	draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 255, h, 512, 110 )

	-- Draw title
	draw.SimpleText( GTowerHUD.Notice.Title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( GTowerHUD.Notice.Text or "", "GTowerHudCSubText", w, h + 50, Color( 255, 255, 255, 255 ), 1 )


end

function GTowerHUD.DrawNoGamemodeNotice()

	if GetConVarNumber("port") == "27015" then return end
	if !GTowerHUD.GMNotice.Enabled:GetBool() then return end

	-- Handle notice
	local w, h = ScrW() / 2, ScrH() / 2
	h = ( h * 2 ) - 150

	-- Draw gradient boxes
	draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
	draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( w - 255, h, 512, 110 )

	-- Draw title
	draw.SimpleText( GTowerHUD.GMNotice.Title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

	-- Draw text
	draw.DrawText( GTowerHUD.GMNotice.Text or "", "GTowerHudCSubText", w, h + 50, Color( 255, 255, 255, 255 ), 1 )

end]]

--[[function GTowerHUD.DrawNews()

	if !GTowerHUD.News.Enabled:GetBool() then return end

	surface.SetDrawColor( 0, 0, 0, 230 )
	surface.DrawRect( 0, ScrH() - 20, ScrW(), 20 )

	draw.SimpleText( "Latest News", "GTowerHudCSubText", 50 + 2, ScrH() - 25 + 2, Color( 0, 0, 0, 255 ), 1, 1 )
	draw.SimpleText( "Latest News", "GTowerHudCSubText", 50, ScrH() - 25, Color( 255, 255, 255, 255 ), 1, 1 )


	local news = GTowerHUD.News.Current or "No news."

	surface.SetFont( "GTowerHudCNewsText" )
	surface.SetTextColor( 255, 255, 255, 255 )

	local w, h = surface.GetTextSize( news )
	local xpos = 4

	-- Marquee scroll text
	if w > ScrW() then

		if !LocalPlayer()._MarqueeDelay then
			LocalPlayer()._MarqueeDelay = CurTime() + math.random( 2, 3 )
		end

		if LocalPlayer()._MarqueeDelay < CurTime() then

			if LocalPlayer()._MarqueeDir == 1 then -- Right

				local pos = ScrW() - w - 2

				if xpos != pos then
					xpos = math.Approach( xpos, pos, FrameTime() * 10 )
				else
					LocalPlayer()._MarqueeDir = 0
					LocalPlayer()._MarqueeDelay = CurTime() + math.random( 2, 3 )
				end

			else -- Left

				local pos = 4

				if xpos != pos then
					xpos = math.Approach( xpos, pos, FrameTime() * 10 )
				else
					LocalPlayer()._MarqueeDir = 1
					LocalPlayer()._MarqueeDelay = CurTime() + math.random( 2, 3 )
				end

			end

		end

	end

	surface.SetTextPos( xpos, ScrH() - 19 )
	surface.DrawText( news )

end

function GTowerHUD.NewsThink()

	if !GTowerHUD.News.Enabled:GetBool() then return end

	if !LocalPlayer()._LastTickerUpdate || LocalPlayer()._LastTickerUpdate < CurTime() then

		http.Fetch( GTowerHUD.News.FeedURL,
			function( content )
				GTowerHUD.News.Current = content
			end,
			function() ErrorNoHalt( "Failed to get news feed." ) end
		)

		LocalPlayer()._LastTickerUpdate = CurTime() + ( 60 * 5 )

	end

end]]

--local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )
--local award = surface.GetTextureID( "gmod_tower/ui/award" )

function GTowerHUD.ShouldDraw()

	if !IsValid( LocalPlayer() ) then return false end

	if not hook.Run( "GTowerHUDShouldDraw" ) then return false end

	if !GTowerHUD.Enabled:GetBool() then return false end

	local weapon = LocalPlayer():GetActiveWeapon()
	if IsValid( weapon ) && weapon:GetClass() == "gmt_camera" then return false end

	return true

end

function GTowerHUD.Paint()

	if GTowerHUD.ShouldDraw() then

		//jetpack.JetpackFuelDraw( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.Width, GTowerHUD.Info.Height-4 )

		GTowerHUD.DrawHealth()
		GTowerHUD.DrawInfo()
		// GTowerHUD.DrawVolumeIcon()
	    hook.Call( "GTowerHUDPaint", GAMEMODE )

		GTowerHUD.DrawAmmo()
		--GTowerHUD.DrawNotice()
		--GTowerHUD.DrawNews()
		GTowerHUD.DrawCrosshair()

	end

	--[[if !( HideBetaMessage:GetBool() and LocalPlayer():IsAdmin()  ) then
		draw.SimpleShadowText( "This game is still a work in progress, this beta may not represent the final quality of the product.", "GTowerHudCSubText", ScrW()/2, ScrH() - 50, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
		draw.SimpleShadowText( "Follow us at http://www.gmtower.org/", "GTowerHudCSubText", ScrW()/2, ScrH() - 25, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
	end]]

	--[[local time = RealTime() * 150

	surface.SetTexture( award )
	surface.SetDrawColor( 255, 255, 255, 255 )

	local size = 512+32
	surface.DrawTexturedRectRotated( ScrW()/2, ScrH()/2, size, size, time+35 )

	local size = 512
	surface.DrawTexturedRectRotated( ScrW()/2, ScrH()/2, size, size, time )]]

	--[[local notice = "Your microphone levels are low. People may not be able to hear you."
	surface.SetFont( "GTowerHudCNoticeText" )
	local tw, th = surface.GetTextSize( notice ) + 16, 28

	local w, h = ScrW() / 2, ScrH() - 64
	local x, y = w - (tw/2), h

	local col = colorutil.Rainbow(50)
	surface.SetDrawColor( col.r, col.g, col.b, 230 )
	surface.DrawRect( x, y, tw, th )

	surface.SetDrawColor( 40, 40, 40, 250 )
	surface.DrawRect( x+1, y+1, tw-2, th-2 )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.SetTexture( gradientUp )
	surface.DrawTexturedRect( x+1, y+1, tw-2, th-2 )

	-- Draw title
	draw.SimpleText( notice, "GTowerHudCNoticeText", w, h+(th/2), Color( 255, 255, 255, 255 ), 1, 1 )]]

	--[[local y = h + 31
	local p = 2
	for i=1, 50 do
		surface.SetDrawColor( i/p, i/p, i/p, math.Fit( i, 1, 50, 200, 0 ) )
		surface.DrawRect( x+i, y + ( i / p ), 512-(i*2), 1 )
	end]]

end

function GTowerHUD.Think()

	if !IsValid( LocalPlayer() ) then return end

	-- Ammo
	if GTowerHUD.AmmoBar.CurrentRotation != GTowerHUD.AmmoBar.TargetRotation then
	
		GTowerHUD.AmmoBar.CurrentRotation = math.Approach(
			GTowerHUD.AmmoBar.CurrentRotation,
			GTowerHUD.AmmoBar.TargetRotation,
			( math.abs( GTowerHUD.AmmoBar.CurrentRotation - GTowerHUD.AmmoBar.TargetRotation ) + 1 ) * 3 * FrameTime()
		)
		
	end

	--GTowerHUD.NewsThink()
	
end

hook.Add( "Think", "GTowerHUDThink", GTowerHUD.Think )
hook.Add( "HUDPaint", "GTowerHUDPaint", GTowerHUD.Paint )

function GM:GTowerHUDShouldDraw()
	return true
end

local e = {
    ["CHudMenu"] = true,
    ["CHudGMod"] = true,
    ["CHudChat"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_HUD"] = false
}

function GM:HUDShouldDraw(element)
    return e[element] or false
end

hook.Add("HUDShouldDraw", "HUDFIX", function(e)
    if e == "DarkRP_HUD" then
        return false
    end
end)