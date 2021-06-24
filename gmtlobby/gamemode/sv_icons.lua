local WebhookURL = "https://discordapp.com/api/webhooks/616588018169544706/1cPp1kspFjyPEEmQCDQUU6WzGUQEgB6jYL_ER88_7w8d13ICJf-DNFcveutx4JoR92qE"
local SteamWebAPIKey = "64A910106F2E682F62DFFE1C78CF1422"

function getAvatarFromJson( j_response ) -- Thanks https://facepunch.com/showthread.php?t=1484549&p=48631437&viewfull=1#post48631437
    local t_response = util.JSONToTable( j_response )

    if ( !istable( t_response ) or !t_response.response ) then return false end
    if ( !t_response.response.players or !t_response.response.players[1] ) then return false end

    return t_response.response.players[1].avatarfull
end
function getAvatarURL( code, body, headers )
    if !body then
        local t_struct = {
            failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
            method = "get",
            url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/",
            parameters = { key = SteamWebAPIKey, steamid = code },
            success = getAvatarURL
        }

        HTTP( t_struct )
    else
        return( getAvatarFromJson( body ) )
    end
end
function sendChat(p_sender, s_text, b_teamChat)
    --if !p_sender then return end
    local t_post = {
        content = s_text,
        --username = "(Gmod) " .. (p_sender:Nick() or "Unknown"),
        --avatar_url = getAvatarURL( p_sender:SteamID64() )
    }
    local t_struct = {
        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
        method = "post",
        url = WebhookURL,
        parameters = t_post,
        type = "application/json" --JSON Request type, because I'm a good boy.
    }
    HTTP( t_struct )
end
hook.Add("PlayerSay","Discord_Webhook_Chat", sendChat)
