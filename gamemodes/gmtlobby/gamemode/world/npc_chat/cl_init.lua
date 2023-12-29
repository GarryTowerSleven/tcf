GTowerNPCChat = {}
GTowerNPCChat.MainChat = nil
GTowerNPCChat.OpenTime = 0

GTowerNPCChat.TalkingLady = nil
GTowerNPCChat.NPCMaxTalkDistance = 1024

include("cl_question.lua")

/*
	tbl = {
		Text = "Hello.",
		Responses = {
			1 = {
				Response = "Hello.",
				Text = "How is it going?",
				Responses = {
					1 = {
						Response = "Fine.",
						data = "I Is Fine.",
						Func = function( data ) Msg( data ) end					
					},
					2 = {
						Response = "Bye."
					}
					3 = {
						data = nil
						Response = function(data) return "I don't like you" end
					}
			
			},
			2 = {
				Response = "Go Away."	
			}
		}	
	}
*/

function GTowerNPCChat:StartChat( tbl )

	if IsValid( GTowerNPCChat.MainChat ) then
		GTowerNPCChat.MainChat:DisperseSelf()
		GTowerNPCChat.MainChat = nil
	end
	
	GTowerNPCChat.TalkingLady = tbl.Entity
	GTowerNPCChat.NPCMaxTalkDistance = tbl.NPCMaxTalkDistance or 128
	
	GTowerNPCChat.MainChat = vgui.Create("GTowerChatQuestion")
	GTowerNPCChat.MainChat:SetupQuestion( tbl )
	GTowerNPCChat.MainChat:SetVisible( true )	
	
	GTowerNPCChat.OpenTime = SysTime()
	
	RememberCursorPosition()
	gui.EnableScreenClicker( true )
	//GTowerMainGui:ShowMenus()
	
end

function GTowerNPCChat:CloseChat()

	if IsValid( GTowerNPCChat.MainChat ) then
		GTowerNPCChat.MainChat:DisperseSelf()
	else
		return
	end
	
	GTowerNPCChat.MainChat = nil
	
	gui.EnableScreenClicker( false )
	RestoreCursorPosition()
	//GTowerMainGui:HideMenus()
	
end

function GTowerNPCChat:Test()

	GTowerNPCChat:StartChat( {
		Text = "Hello!? This is an extremely lenght string that i need to check if garry is cliiping it right. No questions asked.",
		Responses = {
			{
				Response = "Answer #1.",
				Text = "I love cheese and you know it.",
				Responses = {
					{
						Response = "Another response",
					},
					{
						Response = "A third one response",
					}
				}
			},
			{
				Response = "Answer #2.",
			},
			{
				Response = "Answer #3.",
			}		
		}

	} )

end

hook.Add( "PlayerThink", "CloseChatOnDeath", function( ply )

	if !ply:Alive() then
		GTowerNPCChat:CloseChat()
	end

end )