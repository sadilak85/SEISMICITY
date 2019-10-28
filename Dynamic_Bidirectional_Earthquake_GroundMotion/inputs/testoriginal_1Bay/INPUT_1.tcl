#BUILDING ID 1
#GROUND
node 100101	0.0	0.0	0.0
node 100102	288.0	0.0	0.0
node 100201	0.0	0.0	288.0
node 100202	288.0	0.0	288.0
#FLOOR #1
node 200101	0.0	168.0	0.0
node 200102	288.0	168.0	0.0
node 200201	0.0	168.0	288.0
node 200202	288.0	168.0	288.0
#FLOOR #2
node 300101	0.0	336.0	0.0
node 300102	288.0	336.0	0.0
node 300201	0.0	336.0	288.0
node 300202	288.0	336.0	288.0
#FLOOR #3
node 400101	0.0	504.0	0.0
node 400102	288.0	504.0	0.0
node 400201	0.0	504.0	288.0
node 400202	288.0	504.0	288.0
#MASTERNODES
node 900902	144.0	168.0	144.0
node 900903	144.0	336.0	144.0
node 900904	144.0	504.0	144.0
#RIGID
rigidDiaphragm 2 900902	200101	200102	200201	200202
rigidDiaphragm 2 900903	300101	300102	300201	300202
rigidDiaphragm 2 900904	400101	400102	400201	400202
#BEAM
element nonlinearBeamColumn 1020101	200101	200102 5 2 2
element nonlinearBeamColumn 1030101	300101	300102 5 2 2
element nonlinearBeamColumn 1040101	400101	400102 5 2 2
element nonlinearBeamColumn 1020201	200201	200202 5 2 2
element nonlinearBeamColumn 1030201	300201	300202 5 2 2
element nonlinearBeamColumn 1040201	400201	400202 5 2 2
#BEAMLENGTH
set Beamlength_1020101 288
set Beamlength_1030101 288
set Beamlength_1040101 288
set Beamlength_1020201 288	
set Beamlength_1030201 288
set Beamlength_1040201 288
#GIRDER
element nonlinearBeamColumn 2020101	200101	200201 5 3 3
element nonlinearBeamColumn 2020102	200102	200202 5 3 3
element nonlinearBeamColumn 2030101	300101	300201 5 3 3
element nonlinearBeamColumn 2030102	300102	300202 5 3 3
element nonlinearBeamColumn 2040101	400101	400201 5 3 3
element nonlinearBeamColumn 2040102	400102	400202 5 3 3   	
#GIRDERLENGTH
set Beamlength_2020101 288
set Beamlength_2020102 288
set Beamlength_2030101 288
set Beamlength_2030102 288
set Beamlength_2040101 288
set Beamlength_2040102 288
#COLUMN
element nonlinearBeamColumn 20100	100101	200101 5 1 1
element nonlinearBeamColumn 20101	100102	200102 5 1 1
element nonlinearBeamColumn 30100	200101	300101 5 1 1
element nonlinearBeamColumn 30101	200102	300102 5 1 1
element nonlinearBeamColumn 40100	300101	400101 5 1 1
element nonlinearBeamColumn 40101	300102	400102 5 1 1
element nonlinearBeamColumn 20200	100201	200201 5 1 1
element nonlinearBeamColumn 20201	100202	200202 5 1 1
element nonlinearBeamColumn 30200	200201	300201 5 1 1
element nonlinearBeamColumn 30201	200202	300202 5 1 1
element nonlinearBeamColumn 40200	300201	400201 5 1 1
element nonlinearBeamColumn 40201	300202	400202 5 1 1
#COLUMNLENGTH
set Columnlength_20100 168
set Columnlength_20101 168
set Columnlength_30100 168
set Columnlength_30101 168
set Columnlength_40100 168
set Columnlength_40101 168
set Columnlength_20200 168
set Columnlength_20201 168
set Columnlength_30200 168
set Columnlength_30201 168
set Columnlength_40200 168
set Columnlength_40201 168
#END