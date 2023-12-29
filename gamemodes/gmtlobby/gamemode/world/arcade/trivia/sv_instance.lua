module("trivia", package.seeall)

instance = {}
instance.__index = instance

function instance:init()
    self.events = {
        ["questions"] = {},
        ["token"] = {},
    }

    self.config = {
        ["question_count"] = 10,
        ["category"] = 0,
        ["difficulty"] = 0,
    }

    self.questions = nil

    self.token = nil

    log.info( "Initialized new instance." )
end

function instance:setConfig( key, value )
    if ( not self.config[key] ) then
        log.error( "Config key \"%s\" doesn't exist!", key )
        return false
    end

    self.config[key] = value
    return true
end

function instance:onEvent(event, callback)
    if ( not self.events[event] ) then
        log.error( "Event \"%s\" doesn't exist, can't add callback!", event )
        return false
    end

    table.insert( self.events[event], callback )
    return true
end

function instance:doEvent(event, ...)
    if ( not self.events[event] ) then
        log.error( "Event \"%s\" doesn't exist, can't call it!", event )
        return false
    end

    for _, v in ipairs(self.events[event]) do
        v(...)
    end
    return true
end

function instance:refreshToken()
    FetchToken(
        function(data)
            self.token = data.token
            self:doEvent( "token", self.token )
        end,

        function()
            self.token = nil
            self:doEvent( "token", self.token )
        end )
end

function instance:getQuestions()
    FetchQuestions(
        function(data)
            self.questions = data
            self:doEvent( "questions", self.questions )
        end,

        function()
            self.questions = nil
            self:doEvent( "questions", self.questions )
        end,

        self.config.question_count,
        self.config.category,
        self.config.difficulty )
end

function New()
    local i = {}

    setmetatable( i, instance )
    i:init()

    return i
end