module( "GTowerTheater", package.seeall )

function AllowControl( ply )
    return ply:IsStaff()
end

globalnet.Register( "String", "CurVideo", {
    default = "No Video Playing",
} )