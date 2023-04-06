include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
SetupBrowser( ENT, 720, 480 )

usermessage.Hook( "StartGame", function( um )

	local ent = um:ReadEntity()
	local game = ent.GameIDs[ ent:GetSkin() + ( ent.StartId or 1 ) ] or "Patapon"
	ent:DisplayControls( game .. " - Powered by Ruffle", GAMEMODE.WebsiteUrl .. "arcade/?flash=" .. game /*, function() net.Start( "LeaveArcade" ) net.SendToServer() end*/ )

end )

function ENT:MouseThink() end
function ENT:DrawBrowser() end

/*local GameIDS = ENT.GameIDs

usermessage.Hook( "ArcJunkie", function(um)

	local Count = um:ReadChar()
	local Names = {}
	
	Msg("You still need to complete:\n")
	
	for i=1, Count do
		
		local Id = um:ReadChar()
		
		Msg( "\t" .. i .. ". " .. GameIDS[ Id ] .. "\n")
	end

end )*/

concommand.Add("gmt_arcade_open", function(_, _, args)
	if IsValid(arcade) then
		arcade:Remove()
	end

	arcade = vgui.Create("DFrame")
	html = vgui.Create("DHTML", arcade)
	html:Dock(FILL)
	arcade:SetSize(ScrW() / 1.2, ScrH() / 1.2)
	arcade:SetTitle(args[2] or "Arcade")
	arcade:Center()
	arcade:MakePopup()
	html:OpenURL("https://gtower.net/apps/arcade/?game=" .. args[1])
end)

local press = {}
local keys = {
	/*{
		key = KEY_W,
		keycode = "ArrowUp",
		code = 39
	},
	{
		key = KEY_A,
		keycode = "ArrowLeft",
		code = 39
	},
	{
		key = KEY_D,
		keycode = "ArrowRight",
		code = 39
	}*/
}

for i = KEY_0, KEY_RIGHT do
	local name = input.GetKeyName(i)
	table.insert(keys,
{
	key = i,
	keycode = name,
	code = 39
})
end

local l = {
	["LEFTARROW"] = "ArrowLeft",
	["RIGHTARROW"] = "ArrowRight",
	["UPARROW"] = "ArrowUp",
	["DOWNARROW"] = "ArrowDown"
}

hook.Add("Move", "ARCADE", function()
	if !IsValid(html) then return end

	local key
	local code
	local event = "keypress"

	for _, k in ipairs(keys) do
		local down = input.IsKeyDown(k.key)
		local pressing = press[k.key]

		if down && !pressing then
			event = "keydown"
			key = k.keycode
			code = k.code
			press[k.key] = true
		elseif !down && pressing then
			event = "keyup"
			key = k.keycode
			code = k.code
			press[k.key] = false
		end

		if key then
			html:RunJavascript([[
				var player = document.querySelector( "ruffle-player" );
				player.dispatchEvent(new PointerEvent("pointerdown"));
				player.dispatchEvent(new KeyboardEvent("]] .. event .. [[", {
					key:']] .. key .. [[',code: ']] .. (l[key] and l[key] or "Key" .. string.upper(key)) .. [[', keyCode: ]] .. code ..[[, which: ]] .. code .. [[, bubbles: true, 
				  }));
			]])
		end
	end
end)