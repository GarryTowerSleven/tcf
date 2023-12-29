module("trivia", package.seeall)

local color_identifier = Color(135,175,235)
local color_default = color_white

local color_info = color_white
local color_warn = Color(255,255,80)
local color_error = Color(255,80,80)

local function _printIdentifier()
    MsgC( color_identifier, "[Trivia] " )
end

local function _printLevel( str, color )
    MsgC( color or color_default, "(" .. str .. ") " )
end

local function _printMessage( str, color )
    MsgC( color or color_default, str .. "\n" )
end

log = {}

function log.info( ... )
    _printIdentifier()
    //_printLevel( "Info" )
    _printMessage( Format( ... ), color_info )
end

function log.warn( ... )
    _printIdentifier()
    //_printLevel( "Warn" )
    _printMessage( Format( ... ), color_warn )
end

function log.error( ... )
    _printIdentifier()
    //_printLevel( "ERROR" )
    _printMessage( Format( ... ), color_error )

    //debug.Trace()
end