#BUILDING ID 2234455
#GROUND
node 100101	0.0	0.0	0.0
node 100102	288.0	0.0	0.0
node 100201	100.0	0.0	288.0
node 100202	388.0	0.0	288.0
node 1000202	488.0	0.0	188.0
#FLOOR #1
node 200101	0.0	168.0	0.0
node 200102	288.0	168.0	0.0
node 200201	100.0	168.0	288.0
node 200202	388.0	168.0	288.0
node 2000202	488.0	168.0	188.0
#FLOOR #2
node 300101	0.0	336.0	0.0
node 300102	288.0	336.0	0.0
node 300201	100.0	336.0	288.0
node 300202	388.0	336.0	288.0
node 3000202	488.0	336.0	188.0
#FLOOR #3
node 400101	0.0	504.0	0.0
node 400102	288.0	504.0	0.0
node 400201	100.0	504.0	288.0
node 400202	388.0	504.0	288.0
node 4000202	488.0	504.0	188.0
#MASTERNODES
node 900902	194.0	168.0	144.0
node 900903	194.0	336.0	144.0
node 900904	194.0	504.0	144.0
#BEAM
beam 1020101	200101	200102
beam 1030101	300101	300102
beam 1040101	400101	400102
beam 1020201	200201	200202
beam 1030201	300201	300202
beam 1040201	400201	400202
beam 10020201	2000202	200202
beam 10030201	3000202	300202
beam 10040201	4000202	400202
#BEAMLENGTH
Beamlength_1020101 288
Beamlength_1030101 288
Beamlength_1040101 288
Beamlength_1020201 288	
Beamlength_1030201 288
Beamlength_1040201 288
Beamlength_10020201 288
Beamlength_10030201 288
Beamlength_10040201 288
#GIRDER
girder 2020101	200101	200201 
girder 2020102	200102	2000202
girder 2030101	300101	300201 
girder 2030102	300102	3000202
girder 2040101	400101	400201 
girder 2040102	400102	4000202
#GIRDERLENGTH
Beamlength_2020101 288
Beamlength_2020102 288
Beamlength_2030101 288
Beamlength_2030102 288
Beamlength_2040101 288
Beamlength_2040102 288
#COLUMN
column 20100	100101	200101 
column 20101	100102	200102 
column 30100	200101	300101 
column 30101	200102	300102 
column 40100	300101	400101 
column 40101	300102	400102 
column 20200	100201	200201 
column 20201	100202	200202 
column 30200	200201	300201 
column 30201	200202	300202 
column 40200	300201	400201 
column 40201	300202	400202 
column 1000201	1000202	2000202
column 1200201	2000202	3000202
column 1300201	3000202	4000202
#COLUMNLENGTH
Columnlength_20100 168
Columnlength_20101 168
Columnlength_30100 168
Columnlength_30101 168
Columnlength_40100 168
Columnlength_40101 168
Columnlength_20200 168
Columnlength_20201 168
Columnlength_30200 168
Columnlength_30201 168
Columnlength_40200 168
Columnlength_40201 168
Columnlength_1000201 168
Columnlength_1200201 168
Columnlength_1300201 168
#END