#BUILDING
set BuildingID 1;							; # a building with 3 Storeys and 1 Bays in each x and z directions
#NODES
node 10000101	0.0	0.0	0.0                	; # corners on Ground Level --> 10000000+COUNTER
node 10000102	288.0	0.0	0.0
node 10000201	0.0	0.0	288.0
node 10000202	288.0	0.0	288.0
node 20000101	0.0	168.0	0.0				; # corners on 1st Floor Level --> 20000000+COUNTER
node 20000102	288.0	168.0	0.0
node 20000201	0.0	168.0	288.0
node 20000202	288.0	168.0	288.0
node 30000101	0.0	336.0	0.0				; # corners on 2nd Floor Level --> 30000000+COUNTER
node 30000102	288.0	336.0	0.0
node 30000201	0.0	336.0	288.0
node 30000202	288.0	336.0	288.0
node 40000101	0.0	504.0	0.0				; # corners on roof level --> 40000000+COUNTER
node 40000102	288.0	504.0	0.0
node 40000201	0.0	504.0	288.0
node 40000202	288.0	504.0	288.0
#MASTERNODES								  # Geometrically center node on each Storey  --> --> 900000000 +COUNTER
node 900000002	144.0	168.0	144.0
node 900000003	144.0	336.0	144.0
node 900000004	144.0	504.0	144.0
#RIGID										  # rigidDiaphragm (MASTERNODE ID's and other NODE ID's on the SAME STOREY PLANE)
rigidDiaphragm 2 900000002	20000101	20000102	20000201	20000202
rigidDiaphragm 2 900000003	30000101	30000102	30000201	30000202
rigidDiaphragm 2 900000004	40000101	40000102	40000201	40000202
#BEAM											# -- ELEMENTs parallel to x axis    
element nonlinearBeamColumn 220020101	20000101	20000102 5 2 2		; # 1st Floor Level --> 220000000 +COUNTER (Tag: 2 for beams+2 for 1st floor)
element nonlinearBeamColumn 220020201	20000201	20000202 5 2 2
element nonlinearBeamColumn 230030101	30000101	30000102 5 2 2		; # 2nd Floor Level --> 230000000 +COUNTER (Tag: 2 for beams+3 for 2nd floor)
element nonlinearBeamColumn 230030201	30000201	30000202 5 2 2
element nonlinearBeamColumn 240040101	40000101	40000102 5 2 2		; # Roof Level --> 240000000 +COUNTER (Tag: 2 for beams+4 for Roof)
element nonlinearBeamColumn 240040201	40000201	40000202 5 2 2
#BEAMLENGTH
set Beamlength_220020101 288
set Beamlength_220020201 288
set Beamlength_230030101 288
set Beamlength_230030201 288	
set Beamlength_240040101 288
set Beamlength_240040201 288
#GIRDER
element nonlinearBeamColumn 320020101	20000101	20000201 5 3 3		; # 1st Floor Level --> 320000000 +COUNTER (Tag: 3 for girder+2 for 1st floor)
element nonlinearBeamColumn 320020102	20000102	20000202 5 3 3
element nonlinearBeamColumn 330030101	30000101	30000201 5 3 3		; # 2nd Floor Level --> 330000000 +COUNTER (Tag: 3 for girder+3 for 2nd floor)
element nonlinearBeamColumn 330030102	30000102	30000202 5 3 3
element nonlinearBeamColumn 340040101	40000101	40000201 5 3 3		; # Roof Level --> 340000000 +COUNTER (Tag: 3 for girder+4 for Roof)
element nonlinearBeamColumn 340040102	40000102	40000202 5 3 3   	
#GIRDERLENGTH
set Beamlength_320020101 288
set Beamlength_320020102 288
set Beamlength_330030101 288
set Beamlength_330030102 288
set Beamlength_340040101 288
set Beamlength_340040102 288
#COLUMN
element nonlinearBeamColumn 110020100	10000101	20000101 5 1 1	; # Ground Level --> 110000000 +COUNTER (Tag: 1 for columns+ 1 for ground level)
element nonlinearBeamColumn 110020101	10000102	20000102 5 1 1
element nonlinearBeamColumn 110020200	10000201	20000201 5 1 1
element nonlinearBeamColumn 110020201	10000202	20000202 5 1 1
element nonlinearBeamColumn 120030100	20000101	30000101 5 1 1	; # 1st Floor Level --> 120000000 +COUNTER (Tag: 1 for columns+2 for 1st floor)
element nonlinearBeamColumn 120030101	20000102	30000102 5 1 1
element nonlinearBeamColumn 120030200	20000201	30000201 5 1 1
element nonlinearBeamColumn 120030201	20000202	30000202 5 1 1
element nonlinearBeamColumn 130040100	30000101	40000101 5 1 1	; # 2nd Floor Level --> 130000000 +COUNTER (Tag: 1 for columns+3 for 2nd floor)
element nonlinearBeamColumn 130040101	30000102	40000102 5 1 1
element nonlinearBeamColumn 130040200	30000201	40000201 5 1 1
element nonlinearBeamColumn 130040201	30000202	40000202 5 1 1
#COLUMNLENGTH
set Columnlength_110020100 168
set Columnlength_110020101 168
set Columnlength_110020200 168
set Columnlength_110020201 168
#END
