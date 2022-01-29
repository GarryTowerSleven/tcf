
-----------------------------------------------------
STORED_CURVES = STORED_CURVES or {}
local curve = CreateBezierCurve()

/*1*/  curve:Add(Vector(8952.49609375,-347.045559417456388,-352), Angle(0,90,0), 250, 250, nil, nil, 0)
/*2*/  curve:Add(Vector(8951.306640625,1425.7381591797,-352), Angle(0,90,0), 150, 100, nil, nil, .75)
/*3*/  curve:Add(Vector(8951.990234375,1668.7924804688,-245.01507568359), Angle(-32.110046386719,90,0), 100, 150, nil, nil, .25)
/*4*/  curve:Add(Vector(8953.1025390625,2156.8908691406,36.749198913574), Angle(-32.110046386719,90,0), 150, 100, nil, nil, .25)
/*5*/  curve:Add(Vector(8954.302734375,2387.02734375,112.0294342041), Angle(-1.551983833313,90,0), 80, 250, nil, nil, .5)
/*6*/  curve:Add(Vector(8612.3310546875,2678.6821289063,112.0294342041), Angle(0,-180,0), 250, 250, nil, nil, 1)
/*7*/  curve:Add(Vector(5807.1645507813,2678.6962890625,112.03125), Angle(0,180,0), 250, 250, nil, nil, .75)
/*8*/  curve:Add(Vector(5368.2377929688,2246.9035644531,112.03125), Angle(0,-90,0), 250, 100, nil, nil, .75)
/*9*/  curve:Add(Vector(5369.0219726563,2043.0471191406,112.03125), Angle(-0,-90,0), 100, 250, nil, nil, .75)
/*10*/ curve:Add(Vector(4947.4384765625,1653.880859375,110.90521240234), Angle(-1.1559829711914,180,0), 250, 100, nil, nil, .75)
/*11*/ curve:Add(Vector(4679.0678710938,1655.1147460938,86.805381774902), Angle(6.3020157814026,-180,0), 120, 180, nil, nil, 1.25)
/*12*/ curve:Add(Vector(1689.4372558594,1656.4553222656,-181.76667785645), Angle(6.3020157814026,180,0), 250, 150, nil, nil)
/*13*/ curve:Add(Vector(1382.2796630859,1720.8387451172,-208.79566955566), Angle(0.36192137002945,131.44789123535,0), 80, 250, nil, nil, 0.8)
/*14*/ curve:Add(Vector(1045.8258056641,2094.0043945313,-207.59414672852), Angle(-0.69407850503922,132.90008544922,0), 250, 180, nil, nil, 0.8)
/*15*/ curve:Add(Vector(648.40875244141,2239.7893066406,-194.87301635742), Angle(0,-180,0), 150, 250, nil, nil)
/*16*/ curve:Add(Vector(-2504.009765625,2239.087890625,-194.93821716309), Angle(0,180,0), 150, 575, nil, nil, 0.8)
/*17*/ curve:Add(Vector(-3648.4660644531,1111.0780029297,-191.96875), Angle(0,-90,0), 575, 575, nil, nil, 0.8)
/*18*/ curve:Add(Vector(-2466.5778808594,-0.77008211612701,-191.69442749023), Angle(0,0,0), 575, 150, nil, nil, 0.8)
/*19*/ curve:Add(Vector(968.6318359375,0.36877277493477,-191.96875), Angle(0,0,0), 150, 350, nil, nil, 0.8)
/*20*/ curve:Add(Vector(1975.5936279297,-590.99407958984,-191.96875), Angle(0,-67.90771484375,0), 250, 200, nil, nil)
/*21*/ curve:Add(Vector(2174.9541015625,-1076.0306396484,-191.96875), Angle(0,-67.18172454834,0), 150, 150, nil, nil)
/*22*/ curve:Add(Vector(2465.8247070313,-1401.9874267578,-191.96875), Angle(0,-33.785629272461,0), 200, 150, nil, nil)
/*23*/ curve:Add(Vector(3920.7700195313,-2374.4348144531,-191.96875), Angle(0,-33.455619812012,0), 150, 250, nil, nil)
/*24*/ curve:Add(Vector(4599.3979492188,-2543.0778808594,-191.96875), Angle(0,0,0), 250, 150, nil, nil)
/*25*/ curve:Add(Vector(8617.9091796875,-2541.8012695313,-191.96875), Angle(0,0,0), 150, 150, nil, nil, 0.8)
/*26*/ curve:Add(Vector(8949.185546875,-2254.2670898438,-191.96875), Angle(0,90,0), 150, 100, nil, nil, 1.25)
/*27*/ curve:Add(Vector(8950.8837890625,-1635.3878173828,-319.4049987793), Angle(20.359975814819,90,0), 100, 100, nil, nil)
/*28*/ curve:Add(Vector(8951.81640625,-1300,-352), Angle(0,90,0), 120, 150, nil, nil, 1)

STORED_CURVES["monorail"] = curve