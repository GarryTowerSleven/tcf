
AddCSLuaFile( "cl_init.lua" )

// chat commands module, allows easy registration of commands like /sit, /tetris, etc
ChatCommands = {}
ChatCommands.Cmds = {}


function ChatCommands.Register( cmd, time, func )

	ChatCommands.Cmds[ cmd ] = {}

	ChatCommands.Cmds[ cmd ].Time = time
	ChatCommands.Cmds[ cmd ].Func = func

end

function ChatCommands.Unregister( cmd )

	ChatCommands.Cmds[ cmd ] = nil

end

hook.Add( "GTCommands", "GChatCommands", function( ply, chat )

	if ( ply.CmdTime == nil ) then ply.CmdTime = {} end
	local cmd = string.Split(chat, " ")[1]

	if !ChatCommands.Cmds[ cmd ] then return end

	local sayFunc = ChatCommands.Cmds[ cmd ].Func
	local funcDelay = ChatCommands.Cmds[ cmd ].Time or 1

	if !sayFunc then return end

	local cmdTime = ply.CmdTime[ cmd ]

	if ( !cmdTime || cmdTime < CurTime() ) then

		ply.CmdTime[ cmd ] = CurTime() + funcDelay

		local b, ret = pcall( sayFunc, ply, chat )

		if !b then
			SQLLog( 'error', "chat function failed for '" .. cmd .. "': " .. ret .. "\n" )
			return ""
		end

	else

		ply:Msg2( T( "ChatCommandTooFast" ), "exclamation" )

	end

	return ""

end )
