local spline = Catmull.Controller:New()
	spline:AddPointAngle( Vector( 3506, 6403, 1064 ), Angle( 15, -85, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3538, 6059, 1023 ), Angle( 10, -85, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3612, 5693, 1056 ), Angle( 19, -89, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3683, 5112, 884 ), Angle( 15, -103, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3709, 4703, 808 ), Angle( 9, -114, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3497, 4225, 721 ), Angle( 10, -113, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3297, 3754, 621 ), Angle( 14, -113, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3086, 3176, 475 ), Angle( 12, -107, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2887, 2345, 399 ), Angle( 14, -102, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2840, 2043, 381 ), Angle( 15, -100, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2838, 1841, 333 ), Angle( 11, -77, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2931, 1643, 305 ), Angle( 4, -59, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3030, 1518, 295 ), Angle( 3, -46, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3221, 1363, 280 ), Angle( 4, -29, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3501, 1240, 258 ), Angle( 4, -19, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3772, 1197, 240 ), Angle( 3, -2, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4047, 1215, 227 ), Angle( 3, 9, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4293, 1287, 214 ), Angle( 2, 21, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4513, 1413, 196 ), Angle( 4, 36, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4648, 1522, 187 ), Angle( 1, 39, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4798, 1650, 222 ), Angle( -17, 41, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4976, 1802, 309 ), Angle( -24, 40, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5134, 1947, 389 ), Angle( -12, 49, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5166, 2117, 380 ), Angle( 14, 102, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5114, 2346, 324 ), Angle( 13, 103, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5064, 2550, 270 ), Angle( 15, 105, 0 ), 1.0 )
camsystem.AddSplineLocation( "Waiting", spline, 7 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 1321, 5651, 1171 ), Angle( 29, 12, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 1535, 5687, 1047 ), Angle( 19, 9, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 1766, 5730, 1075 ), Angle( 13, -14, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2027, 5678, 1093 ), Angle( 27, -76, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2091, 5564, 1048 ), Angle( 29, -119, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2107, 5309, 1085 ), Angle( 32, 113, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2006, 5367, 1087 ), Angle( 28, 74, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 1967, 5514, 1047 ), Angle( 32, -6, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview1", spline, 2 )


spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 2416, 5595, 1095 ), Angle( 39, 12, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2503, 5568, 1074 ), Angle( 33, 23, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2582, 5534, 1038 ), Angle( 31, 30, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2635, 5518, 1015 ), Angle( 33, 38, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2724, 5530, 980 ), Angle( 27, 76, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2768, 5702, 913 ), Angle( 36, 129, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2775, 5837, 922 ), Angle( 25, -142, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2633, 5807, 928 ), Angle( 36, -26, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2670, 5694, 938 ), Angle( 41, 53, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview2", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 2832, 5548, 1142 ), Angle( 24, 8, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2997, 5572, 1071 ), Angle( 22, 8, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3139, 5596, 1019 ), Angle( 13, 8, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3247, 5641, 991 ), Angle( 15, 7, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3308, 5671, 973 ), Angle( 17, -7, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3417, 5694, 942 ), Angle( 17, -19, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3494, 5700, 923 ), Angle( 14, -25, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3564, 5691, 908 ), Angle( 12, -33, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3651, 5655, 889 ), Angle( 11, -37, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3691, 5625, 880 ), Angle( 8, -37, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview3", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 3963, 5626, 984 ), Angle( 5, -4, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4206, 5592, 986 ), Angle( 10, -10, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4365, 5527, 970 ), Angle( 16, -15, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4472, 5408, 954 ), Angle( 30, 33, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4579, 5419, 982 ), Angle( 41, 66, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4736, 5415, 960 ), Angle( 38, 135, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4712, 5551, 968 ), Angle( 36, -131, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview4", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 4938, 5278, 1042 ), Angle( 21, 24, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5046, 5436, 994 ), Angle( 16, 15, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5126, 5606, 1006 ), Angle( 19, 0, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5163, 5771, 1000 ), Angle( 19, -21, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5244, 5892, 1000 ), Angle( 18, -49, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5446, 5911, 981 ), Angle( 17, -86, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5661, 5771, 1036 ), Angle( 24, -122, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5637, 5585, 1029 ), Angle( 18, -94, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5593, 5368, 1022 ), Angle( 27, -21, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5644, 5208, 1031 ), Angle( 15, 27, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5892, 5203, 1037 ), Angle( 26, 39, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview5", spline, 2 )


spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 4177, 4936, 880 ), Angle( 22, -44, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4251, 4930, 894 ), Angle( 24, -38, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4337, 4940, 915 ), Angle( 25, -43, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4451, 4925, 939 ), Angle( 27, -51, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4538, 4918, 977 ), Angle( 31, -63, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4691, 4834, 990 ), Angle( 36, -124, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4745, 4729, 976 ), Angle( 36, -162, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4690, 4620, 923 ), Angle( 36, 179, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4616, 4533, 878 ), Angle( 30, 173, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4470, 4478, 820 ), Angle( 20, 159, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4374, 4467, 798 ), Angle( 20, 134, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4250, 4468, 791 ), Angle( 28, 67, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4219, 4562, 791 ), Angle( 29, -5, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4284, 4621, 791 ), Angle( 29, -84, 0 ), 1.0 )

camsystem.AddSplineLocation( "Preview6", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 3994, 5194, 942 ), Angle( 21, -145, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3763, 5008, 836 ), Angle( 20, -141, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3682, 4845, 783 ), Angle( 17, -139, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3646, 4726, 756 ), Angle( 15, -153, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3617, 4626, 773 ), Angle( 28, 153, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3520, 4555, 773 ), Angle( 29, 98, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3409, 4598, 773 ), Angle( 29, 30, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3385, 4689, 773 ), Angle( 26, -24, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3454, 4763, 773 ), Angle( 26, -72, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3549, 4758, 773 ), Angle( 26, -117, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview7", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 1930, 5002, 950 ), Angle( 32, -53, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2045, 4881, 864 ), Angle( 27, -46, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2103, 4731, 844 ), Angle( 27, -37, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2116, 4587, 873 ), Angle( 33, 1, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2167, 4394, 858 ), Angle( 31, 28, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2475, 4367, 764 ), Angle( 30, 69, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2650, 4496, 708 ), Angle( 15, 115, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2713, 4675, 754 ), Angle( 20, 164, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2649, 5022, 744 ), Angle( 19, -143, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2507, 5076, 735 ), Angle( 17, -122, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2274, 5103, 726 ), Angle( 19, -94, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2095, 5027, 674 ), Angle( 15, -66, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview8", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 2882, 4117, 824 ), Angle( 21, -116, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2916, 3889, 761 ), Angle( 20, -124, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2972, 3280, 588 ), Angle( 20, -127, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3009, 2460, 398 ), Angle( 17, -140, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2857, 1960, 341 ), Angle( 24, -143, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 2854, 1788, 340 ), Angle( 21, -134, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview9", spline, 4 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 3865, 1558, 779 ), Angle( 36, -172, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3826, 1459, 726 ), Angle( 64, -166, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3821, 1362, 677 ), Angle( 70, 178, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3766, 1237, 580 ), Angle( 70, 163, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3694, 1173, 412 ), Angle( 74, 164, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3652, 1081, 322 ), Angle( 85, 168, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3605, 1034, 250 ), Angle( 55, 92, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3547, 1097, 238 ), Angle( 46, 25, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview10", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 4013, 786, 337 ), Angle( 31, 64, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3967, 853, 320 ), Angle( 27, 37, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3939, 1029, 293 ), Angle( 25, 21, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 3974, 1283, 293 ), Angle( 24, -38, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4161, 1360, 293 ), Angle( 26, -85, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4304, 1199, 242 ), Angle( 27, -127, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4422, 1029, 242 ), Angle( 25, -168, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4362, 840, 242 ), Angle( 25, 138, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4193, 801, 222 ), Angle( 27, 90, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4050, 907, 222 ), Angle( 27, -14, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4167, 944, 190 ), Angle( 31, -82, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview11", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 4745, 1608, 314 ), Angle( 19, -73, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4775, 1492, 270 ), Angle( 19, -77, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4885, 1431, 257 ), Angle( 19, -137, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4906, 1185, 238 ), Angle( 29, 177, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4765, 1034, 182 ), Angle( 32, 124, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4601, 1067, 182 ), Angle( 26, 34, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4565, 1243, 182 ), Angle( 25, -21, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4654, 1337, 160 ), Angle( 24, -26, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4758, 1389, 139 ), Angle( 17, -48, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4908, 1434, 130 ), Angle( 13, -59, 0 ), 1.0 )

camsystem.AddSplineLocation( "Preview12", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 5493, 1211, 295 ), Angle( 22, -31, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5569, 1233, 283 ), Angle( 16, -44, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5735, 1251, 275 ), Angle( 24, -63, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5827, 1245, 309 ), Angle( 36, -120, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5889, 1147, 325 ), Angle( 33, -165, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5885, 1026, 325 ), Angle( 29, 171, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5797, 971, 295 ), Angle( 23, 154, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5592, 893, 248 ), Angle( 14, 136, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5475, 900, 228 ), Angle( 14, 113, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5309, 974, 207 ), Angle( 18, 71, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5283, 1066, 193 ), Angle( 17, 28, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5276, 1115, 190 ), Angle( 14, 5, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5277, 1159, 190 ), Angle( 11, -9, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview13", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 6136, 1965, 461 ), Angle( 36, -151, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 6033, 1908, 380 ), Angle( 29, -152, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5940, 1859, 338 ), Angle( 35, -150, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5836, 1797, 263 ), Angle( 31, -149, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5806, 1716, 223 ), Angle( 31, -150, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5811, 1576, 187 ), Angle( 31, -156, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5799, 1484, 187 ), Angle( 34, 127, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5723, 1463, 187 ), Angle( 17, 85, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5637, 1486, 187 ), Angle( 15, 49, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview14", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 5356, 1963, 375 ), Angle( 18, -171, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5187, 1887, 350 ), Angle( 23, 177, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5040, 1800, 304 ), Angle( 22, 139, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4907, 1753, 290 ), Angle( 21, 96, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4796, 1890, 276 ), Angle( 16, 17, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4807, 2040, 269 ), Angle( 17, -15, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4989, 2120, 240 ), Angle( 12, -40, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5123, 2130, 230 ), Angle( 5, -52, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5233, 2113, 224 ), Angle( 6, -73, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5335, 2092, 255 ), Angle( 28, -115, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5413, 1992, 255 ), Angle( 23, -171, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview15", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 5170, 2342, 266 ), Angle( 18, 102, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5124, 2381, 253 ), Angle( 17, 87, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5072, 2449, 230 ), Angle( 21, 93, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5048, 2508, 208 ), Angle( 20, 94, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5011, 2556, 193 ), Angle( 15, 78, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4976, 2652, 176 ), Angle( 12, 54, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4966, 2733, 167 ), Angle( 11, 26, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4964, 2811, 166 ), Angle( 11, -7, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5014, 2886, 202 ), Angle( 24, -46, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5075, 2874, 218 ), Angle( 27, -86, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5091, 2827, 215 ), Angle( 27, -90, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 5091, 2779, 218 ), Angle( 52, -91, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview16", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 4521, 2060, 188 ), Angle( 13, 126, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4459, 2077, 180 ), Angle( 10, 113, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4312, 2156, 160 ), Angle( 8, 94, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4253, 2221, 154 ), Angle( 5, 82, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4201, 2312, 150 ), Angle( -1, 57, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4168, 2394, 182 ), Angle( 13, 25, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4173, 2488, 235 ), Angle( 13, 24, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4181, 2546, 250 ), Angle( 14, 31, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4200, 2602, 259 ), Angle( 12, 49, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4235, 2664, 259 ), Angle( 20, 48, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview17", spline, 2 )

spline = Catmull.Controller:New()
spline:Reset()
	spline:AddPointAngle( Vector( 5007, 3314, 261 ), Angle( 31, -158, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4880, 3272, 272 ), Angle( 21, -162, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4684, 3213, 282 ), Angle( 28, -163, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4599, 3153, 301 ), Angle( 19, 165, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4479, 3105, 338 ), Angle( 22, 150, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4362, 3082, 351 ), Angle( 23, 138, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4189, 3076, 406 ), Angle( 33, 113, 0 ), 1.0 )
	spline:AddPointAngle( Vector( 4076, 3092, 396 ), Angle( 33, 74, 0 ), 1.0 )
camsystem.AddSplineLocation( "Preview18", spline, 2 )