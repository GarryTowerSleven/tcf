// Wrappers for net library

module( "net", package.seeall )

// 1 bit
function WriteBool( bool ) net.WriteBit( bool ) end
function ReadBool() return ( net.ReadBit() == 1 ) end

// 8 bits
function WriteChar( char ) net.WriteInt( char, 8 ) end
function ReadChar()	return net.ReadInt( 8 ) end

// 16 bits
function WriteShort( short ) net.WriteInt( short, 16 ) end
function ReadShort() return net.ReadInt( 16 ) end

// 32 bits
function WriteLong( long ) net.ReadInt( long, 32 ) end
function ReadLong() return net.ReadInt( 32 ) end