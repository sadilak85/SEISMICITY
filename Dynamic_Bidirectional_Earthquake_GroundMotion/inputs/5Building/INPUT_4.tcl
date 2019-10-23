#BUILDING_ID 4
#NODES
node 10000141	900.0	0.0	0.0
node 10000142	1188.0	0.0	0.0
node 10000241	900.0	0.0	288.0
node 10000242	1188.0	0.0	288.0
node 20000141	900.0	168.0	0.0
node 20000142	1188.0	168.0	0.0
node 20000241	900.0	168.0	288.0
node 20000242	1188.0	168.0	288.0
node 30000141	900.0	336.0	0.0
node 30000142	1188.0	336.0	0.0
node 30000241	900.0	336.0	288.0
node 30000242	1188.0	336.0	288.0
#MASTERNODES
node 900000042	1044.0	168.0	144.0
node 900000043	1044.0	336.0	144.0
#RIGID
rigidDiaphragm 2 900000042	20000141	20000142	20000241	20000242
rigidDiaphragm 2 900000043	30000141	30000142	30000241	30000242
#BEAM
element nonlinearBeamColumn 220020141	20000141	20000142 5 2 2
element nonlinearBeamColumn 220020241	20000241	20000242 5 2 2
element nonlinearBeamColumn 230030141	30000141	30000142 5 2 2
element nonlinearBeamColumn 230030241	30000241	30000242 5 2 2
#BEAMLENGTH
set Beamlength_220020101 288
set Beamlength_220020201 288
set Beamlength_230030101 288
set Beamlength_230030201 288	
#GIRDER
element nonlinearBeamColumn 320020141	20000141	20000241 5 3 3
element nonlinearBeamColumn 320020142	20000142	20000242 5 3 3
element nonlinearBeamColumn 330030141	30000141	30000241 5 3 3
element nonlinearBeamColumn 330030142	30000142	30000242 5 3 3
#GIRDERLENGTH
set Beamlength_320020101 288
set Beamlength_320020102 288
set Beamlength_330030101 288
set Beamlength_330030102 288
#COLUMN
element nonlinearBeamColumn 110020140	10000141	20000141 5 1 1
element nonlinearBeamColumn 110020141	10000142	20000142 5 1 1
element nonlinearBeamColumn 110020240	10000241	20000241 5 1 1
element nonlinearBeamColumn 110020241	10000242	20000242 5 1 1
element nonlinearBeamColumn 120030140	20000141	30000141 5 1 1
element nonlinearBeamColumn 120030141	20000142	30000142 5 1 1
element nonlinearBeamColumn 120030240	20000241	30000241 5 1 1
element nonlinearBeamColumn 120030241	20000242	30000242 5 1 1
#COLUMNLENGTH
set Columnlength_110020100 168
set Columnlength_110020101 168
set Columnlength_110020200 168
set Columnlength_110020201 168
#END