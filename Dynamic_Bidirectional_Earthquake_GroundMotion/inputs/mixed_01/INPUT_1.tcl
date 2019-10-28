#BUILDING ID 1
#GROUND
node 10000101	0.0	0.0	0.0
node 10000102	288.0	0.0	0.0
node 10000201	0.0	0.0	288.0
node 10000202	288.0	0.0	288.0
#FLOOR #1
node 20000101	0.0	118.0	0.0
node 20000102	288.0	118.0	0.0
node 20000201	0.0	118.0	288.0
node 20000202	288.0	118.0	288.0
#FLOOR #2
node 30000101	0.0	316.0	0.0
node 30000102	288.0	316.0	0.0
node 30000201	0.0	316.0	288.0
node 30000202	288.0	316.0	288.0
#FLOOR #3
node 40000101	0.0	404.0	0.0
node 40000102	288.0	404.0	0.0
node 40000201	0.0	404.0	288.0
node 40000202	288.0	404.0	288.0
#MASTERNODES
node 900000002	144.0	118.0	144.0
node 900000003	144.0	316.0	144.0
node 900000004	144.0	404.0	144.0
#RIGID
rigidDiaphragm 2 900000002	20000101	20000102	20000201	20000202
rigidDiaphragm 2 900000003	30000101	30000102	30000201	30000202
rigidDiaphragm 2 900000004	40000101	40000102	40000201	40000202
#BEAM
element nonlinearBeamColumn 220020101	20000101	20000102 5 2 2
element nonlinearBeamColumn 220020201	20000201	20000202 5 2 2
element nonlinearBeamColumn 230030101	30000101	30000102 5 2 2
element nonlinearBeamColumn 230030201	30000201	30000202 5 2 2
element nonlinearBeamColumn 240040101	40000101	40000102 5 2 2
element nonlinearBeamColumn 240040201	40000201	40000202 5 2 2
#BEAMLENGTH
set Beamlength_220020101 288
set Beamlength_220020201 288
set Beamlength_230030101 288
set Beamlength_230030201 288	
set Beamlength_240040101 288
set Beamlength_240040201 288
#GIRDER
element nonlinearBeamColumn 320020101	20000101	20000201 5 3 3
element nonlinearBeamColumn 320020102	20000102	20000202 5 3 3
element nonlinearBeamColumn 330030101	30000101	30000201 5 3 3
element nonlinearBeamColumn 330030102	30000102	30000202 5 3 3
element nonlinearBeamColumn 340040101	40000101	40000201 5 3 3
element nonlinearBeamColumn 340040102	40000102	40000202 5 3 3   	
#GIRDERLENGTH
set Beamlength_320020101 288
set Beamlength_320020102 288
set Beamlength_330030101 288
set Beamlength_330030102 288
set Beamlength_340040101 288
set Beamlength_340040102 288
#COLUMN
element nonlinearBeamColumn 110020100	10000101	20000101 5 1 1
element nonlinearBeamColumn 110020101	10000102	20000102 5 1 1
element nonlinearBeamColumn 110020200	10000201	20000201 5 1 1
element nonlinearBeamColumn 110020201	10000202	20000202 5 1 1
element nonlinearBeamColumn 120030100	20000101	30000101 5 1 1
element nonlinearBeamColumn 120030101	20000102	30000102 5 1 1
element nonlinearBeamColumn 120030200	20000201	30000201 5 1 1
element nonlinearBeamColumn 120030201	20000202	30000202 5 1 1
element nonlinearBeamColumn 130040100	30000101	40000101 5 1 1
element nonlinearBeamColumn 130040101	30000102	40000102 5 1 1
element nonlinearBeamColumn 130040200	30000201	40000201 5 1 1
element nonlinearBeamColumn 130040201	30000202	40000202 5 1 1
#COLUMNLENGTH
set Columnlength_110020100 168
set Columnlength_110020101 168
set Columnlength_110020200 168
set Columnlength_110020201 168
set Columnlength_120030100 168
set Columnlength_120030101 168
set Columnlength_120030200 168
set Columnlength_120030201 168
set Columnlength_130040100 168
set Columnlength_130040101 168
set Columnlength_130040200 168
set Columnlength_130040201 168
#END
