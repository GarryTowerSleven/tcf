AddCSLuaFile("sh_log.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("sh_log.lua")
include("shared.lua")
include("sv_instance.lua")

module("trivia", package.seeall)

BaseURL = "https://opentdb.com/"

CODE_SUCCESS = 0
CODE_NO_RESULTS = 1
CODE_INVALID_PARAMETER = 2
CODE_TOKEN_NOT_FOUND = 3
CODE_TOKEN_EMPTY = 4

function CategoryByName( name )
    for k, v in pairs(Categories) do
        if ( v == name ) then
            return k
        end
    end

    return nil
end

function FetchToken( onSuccess, onError )
    local u = neturl.parse(BaseURL):addSegment("api_token.php")
    u:setQuery({command = "request"})

    http.Fetch( u:build(),
    
    function(body, size, headers, code)
        local data = util.JSONToTable(body)
        if ( not data ) then
            log.error( "Failed to parse JSON in `FetchToken`! (size=`%s`,code=`%s`)", size, code )
            onError()
            return
        end

        if ( data.response_code != CODE_SUCCESS ) then
            log.error( "Failed to fetch token! (Code: %s)", data.response_code )
            onError()
            return
        end

        onSuccess(data)
    end,

    function(msg)
        log.error( "Failed to fetch token! (%s)", msg )
        onError()
    end )
end

local function decode_table( tbl )
    for k, v in pairs(tbl) do
        tbl[k] = istable(v) and decode_table(v) or util.Base64Decode(v)
    end

    return tbl
end

function FetchQuestions( onSuccess, onError, amount, category, difficulty )
    local u = neturl.parse(BaseURL):addSegment("api.php")

    u.query.amount = amount or 10
    u.query.category = category or 0
    u.query.difficulty = difficulty or 0

    u.query.encode = "base64"

    http.Fetch( u:build(),
    
    function(body, size, headers, code)
        local data = util.JSONToTable(body)
        if ( not data ) then
            log.error( "Failed to parse JSON in `FetchQuestions`! (size=`%s`,code=`%s`)", size, code )
            onError()
            return
        end

        if ( data.response_code != CODE_SUCCESS ) then
            log.error( "Failed to fetch questions! (Code: %s)", data.response_code )
            onError()
            return
        end

        if ( not data.results or table.Count(data.results) <= 0 ) then
            log.error( "No questions returned! (Code: %s)", data.response_code )
            onError()
            return
        end

        // decode
        local res = decode_table(data.results)

        onSuccess(res)
    end,

    function(msg)
        log.error( "Failed to fetch questions! (%s)", msg )
        onError()
    end )
end