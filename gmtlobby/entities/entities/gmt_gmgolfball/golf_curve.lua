
-----------------------------------------------------

STORED_CURVES = STORED_CURVES or {}
local curve = CreateBezierCurve()

curve:Add(Vector(7232,-5368,-872), Angle(0,0,0),nil,nil,nil,nil)
curve:Add(Vector(7376,-5368,-872), Angle(0,0,0),50,50,nil,nil)
curve:Add(Vector(7536,-5456,-808), Angle(0,270,0),50,50,nil,nil)
curve:Add(Vector(7376,-5544,-872), Angle(0,180,0),50,50,nil,nil)
curve:Add(Vector(7080,-5544,-872), Angle(0,180,0),50,50,nil,nil)
curve:Add(Vector(7070,-5544,-882), Angle(90,180,0),50,50,nil,nil)
curve:Add(Vector(7070,-5544,-930), Angle(0,90,-90),nil,nil,nil,nil)
curve:Add(Vector(7216,-5368,-930), Angle(0,0,-90),nil,nil,nil,nil)


local offsetPos = Vector(0,0,5)

for i=1, #curve.Points do
	curve.Points[i].Pos = curve.Points[i].Pos + offsetPos
end

STORED_CURVES["golf"] = curve
