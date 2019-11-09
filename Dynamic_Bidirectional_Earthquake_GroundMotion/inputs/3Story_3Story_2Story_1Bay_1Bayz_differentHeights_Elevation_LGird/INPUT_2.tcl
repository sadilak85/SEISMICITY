#BUILDING ID 2
#GROUND
node 10000121	300.0	50.0	0.0
node 10000122	588.0	60.0	0.0
node 10000221	300.0	30.0	488.0
node 10000222	588.0	120.0	488.0
#FLOOR #1
node 20000121	300.0	168.0	0.0
node 20000122	588.0	168.0	0.0
node 20000221	300.0	168.0	488.0
node 20000222	588.0	168.0	488.0
#FLOOR #2
node 30000121	300.0	336.0	0.0
node 30000122	588.0	336.0	0.0
node 30000221	300.0	336.0	488.0
node 30000222	588.0	336.0	488.0
#FLOOR #3
node 40000121	300.0	504.0	0.0
node 40000122	588.0	504.0	0.0
node 40000221	300.0	504.0	488.0
node 40000222	588.0	504.0	488.0
#MASTERNODES
node 900000022	444.0	168.0	244.0
node 900000023	444.0	336.0	244.0
node 900000024	444.0	504.0	244.0
#BEAM
beam 220020121	20000121	20000122
beam 220020221	20000221	20000222
beam 230030121	30000121	30000122
beam 230030221	30000221	30000222
beam 240040121	40000121	40000122
beam 240040221	40000221	40000222
#BEAMLENGTH
Beamlength_220020121 288
Beamlength_220020221 288
Beamlength_230030121 288
Beamlength_230030221 288	
Beamlength_240040121 288
Beamlength_240040221 288
#GIRDER
girder 320020121	20000121	20000221
girder 320020122	20000122	20000222
girder 330030121	30000121	30000221
girder 330030122	30000122	30000222
girder 340040121	40000121	40000221
girder 340040122	40000122	40000222  	
#GIRDERLENGTH
Beamlength_320020121 288
Beamlength_320020122 288
Beamlength_330030121 288
Beamlength_330030122 288
Beamlength_340040121 288
Beamlength_340040122 288
#COLUMN
column 110020120	10000121	20000121
column 110020121	10000122	20000122
column 110020220	10000221	20000221
column 110020221	10000222	20000222
column 120030120	20000121	30000121
column 120030121	20000122	30000122
column 120030220	20000221	30000221
column 120030221	20000222	30000222
column 130040120	30000121	40000121
column 130040121	30000122	40000122
column 130040220	30000221	40000221
column 130040221	30000222	40000222
#COLUMNLENGTH
Columnlength_110020120 168
Columnlength_110020121 168
Columnlength_110020220 168
Columnlength_110020221 168
Columnlength_120030120 168
Columnlength_120030121 168
Columnlength_120030220 168
Columnlength_120030221 168
Columnlength_130040120 168
Columnlength_130040121 168
Columnlength_130040220 168
Columnlength_130040221 168
#END