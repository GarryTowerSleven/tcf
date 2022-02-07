local VerbalPattern = {}
local VerbalPatternMeta = {
	__index = VerbalPattern,
	__tostring = function( self ) return self:Compile() end
}

function VerbalPattern:New()
	local obj = {}
	setmetatable( obj, VerbalPatternMeta )

	obj._prefixes = ""
	obj._source = ""
	obj._suffixes = ""
	obj._modifiers = "gm"

	return obj
end

local sanitize = {
	[' '] = '%s'
}

function VerbalPattern:Sanitize( value )
	local str = ""
	for i = 1, #value do
		local char = value[i]
		str = str .. (sanitize[char] or char)
	end
	return str
end

function VerbalPattern:Compile()
	return self._prefixes .. self._source .. self._suffixes
end

function VerbalPattern:Add( value )
	self._source = self._source .. ( value or '' )
	return self
end

function VerbalPattern:StartOfLine( enable )
	enable = enable ~= false
	self._prefixes = enable and '^' or ''
	self:Add( '' )
	return self
end

function VerbalPattern:EndOfLine( value )
	enable = enable ~= false
	self._suffixes = enable and '$' or ''
	self:Add( '' )
	return self
end

function VerbalPattern:Then( value )
	value = self:Sanitize( value )
	self:Add( value )
	return self
end

VerbalPattern.Find = VerbalPattern.Then

function VerbalPattern:Maybe( value )
	value = self:Sanitize( value )
	self:Add( "[" .. value .. "]?" )
	return self
end

function VerbalPattern:Anything()
	self:Add( ".*" )
	return self
end

function VerbalPattern:AnythingBut( value )
	value = self:Sanitize( value )
	self:Add( "[^" .. value .. "]+" )
	return self
end

function VerbalPattern:Something()
	self:Add( ".+" )
	return self
end

function VerbalPattern:SomethingBut( value )
	self:Add( "[^" .. value .. "]+" )
	return self
end

function VerbalPattern:LineBreak( windows )
	self:Add( windows and "\\n\\r" or "\\n" )
	return self
end

function VerbalPattern:Tab()
	self:Add( "\\t" )
	return self
end

function VerbalPattern:Word()
	self:Add( "%a+" )
	return self
end

function VerbalPattern:Alphanumeric()
	self:Add( "%w+" )
	return self
end

function VerbalPattern:Numeric()
	self:Add( "%d+" )
	return self
end

function VerbalPattern:AnyOf( value )
	self:Add( "[" .. value .. "]" )
	return self
end

VerbalPattern.Any = VerbalPattern.AnyOf

function VerbalPattern:BeginCapture()
	self._prefixes = self._prefixes .. '('
	self._suffixes = self._suffixes .. ')'
	return self
end

function VerbalPattern:EndCapture()
	-- self._suffixes = self._suffixes:sub( 1, self._suffixes:len() - 1 )
	return self
end

function VerbalPattern:Test( value )
	self._suffixes = self._suffixes:sub( 1, self._suffixes:len() - 1 )
	return string.match( value, self:Compile() ) and true or false
end

function VerPat()
	return VerbalPattern:New()
end