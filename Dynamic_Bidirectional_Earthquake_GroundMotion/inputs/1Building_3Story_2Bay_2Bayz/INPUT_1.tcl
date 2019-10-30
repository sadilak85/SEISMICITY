#BUILDING ID 1
#GROUND
node 111101	0.0	0.0	0.0
node 111102	288.0	0.0	0.0
node 111103	576.0	0.0	0.0
node 111201	0.0	0.0	288.0
node 111202	288.0	0.0	288.0
node 111203	576.0	0.0	288.0
node 111301	0.0	0.0	576.0
node 111302	288.0	0.0	576.0
node 111303	576.0	0.0	576.0
#FLOOR #1
node 211101	0.0	168.0	0.0
node 211102	288.0	168.0	0.0
node 211103	576.0	168.0	0.0
node 211201	0.0	168.0	288.0
node 211202	288.0	168.0	288.0
node 211203	576.0	168.0	288.0
node 211301	0.0	168.0	576.0
node 211302	288.0	168.0	576.0
node 211303	576.0	168.0	576.0
#FLOOR #2
node 311101	0.0	336.0	0.0
node 311102	288.0	336.0	0.0
node 311103	576.0	336.0	0.0
node 311201	0.0	336.0	288.0
node 311202	288.0	336.0	288.0
node 311203	576.0	336.0	288.0
node 311301	0.0	336.0	576.0
node 311302	288.0	336.0	576.0
node 311303	576.0	336.0	576.0
#FLOOR #3
node 411101	0.0	504.0	0.0
node 411102	288.0	504.0	0.0
node 411103	576.0	504.0	0.0
node 411201	0.0	504.0	288.0
node 411202	288.0	504.0	288.0
node 411203	576.0	504.0	288.0
node 411301	0.0	504.0	576.0
node 411302	288.0	504.0	576.0
node 411303	576.0	504.0	576.0
#MASTERNODES
node 9902	288.0	168.0	288.0
node 9903	288.0	336.0	288.0
node 9904	288.0	504.0	288.0
#RIGID
rigidDiaphragm 2 9902	211101	211102	211103	211201	211202	211203	211301	211302	211303
rigidDiaphragm 2 9903	311101	311102	311103	311201	311202	311203	311301	311302	311303
rigidDiaphragm 2 9904	411101	411102	411103	411201	411202	411203	411301	411302	411303
#BEAM
element nonlinearBeamColumn 1020101	211101	211102 5 2 2
element nonlinearBeamColumn 1020102	211102	211103 5 2 2
element nonlinearBeamColumn 1030101	311101	311102 5 2 2
element nonlinearBeamColumn 1030102	311102	311103 5 2 2
element nonlinearBeamColumn 1040101	411101	411102 5 2 2
element nonlinearBeamColumn 1040102	411102	411103 5 2 2
element nonlinearBeamColumn 1020201	211201	211202 5 2 2
element nonlinearBeamColumn 1020202	211202	211203 5 2 2
element nonlinearBeamColumn 1030201	311201	311202 5 2 2
element nonlinearBeamColumn 1030202	311202	311203 5 2 2
element nonlinearBeamColumn 1040201	411201	411202 5 2 2
element nonlinearBeamColumn 1040202	411202	411203 5 2 2
element nonlinearBeamColumn 1020301	211301	211302 5 2 2
element nonlinearBeamColumn 1020302	211302	211303 5 2 2
element nonlinearBeamColumn 1030301	311301	311302 5 2 2
element nonlinearBeamColumn 1030302	311302	311303 5 2 2
element nonlinearBeamColumn 1040301	411301	411302 5 2 2
element nonlinearBeamColumn 1040302	411302	411303 5 2 2
#BEAMLENGTH
set Beamlength_1020101 288
set Beamlength_1020102 288
set Beamlength_1030101 288
set Beamlength_1030102 288	
set Beamlength_1040101 288
set Beamlength_1040102 288
set Beamlength_1020201 288
set Beamlength_1020202 288
set Beamlength_1030201 288
set Beamlength_1030202 288	
set Beamlength_1040201 288
set Beamlength_1040202 288
set Beamlength_1020301 288
set Beamlength_1020302 288
set Beamlength_1030301 288
set Beamlength_1030302 288	
set Beamlength_1040301 288
set Beamlength_1040302 288
#GIRDER
element nonlinearBeamColumn 2020101	211101	211201 5 3 3
element nonlinearBeamColumn 2020102	211102	211202 5 3 3
element nonlinearBeamColumn 2020103	211103	211203 5 3 3
element nonlinearBeamColumn 2030101	311101	311201 5 3 3
element nonlinearBeamColumn 2030102	311102	311202 5 3 3
element nonlinearBeamColumn 2030103	311103	311203 5 3 3  
element nonlinearBeamColumn 2040101	411101	411201 5 3 3
element nonlinearBeamColumn 2040102	411102	411202 5 3 3
element nonlinearBeamColumn 2040103	411103	411203 5 3 3
element nonlinearBeamColumn 2020201	211201	211301 5 3 3
element nonlinearBeamColumn 2020202	211202	211302 5 3 3
element nonlinearBeamColumn 2020203	211203	211303 5 3 3 
element nonlinearBeamColumn 2030201	311201	311301 5 3 3
element nonlinearBeamColumn 2030202	311202	311302 5 3 3
element nonlinearBeamColumn 2030203	311203	311303 5 3 3
element nonlinearBeamColumn 2040201	411201	411301 5 3 3
element nonlinearBeamColumn 2040202	411202	411302 5 3 3
element nonlinearBeamColumn 2040203	411203	411303 5 3 3  	
#GIRDERLENGTH
set Beamlength_2020101 288
set Beamlength_2020102 288
set Beamlength_2020103 288
set Beamlength_2030101 288
set Beamlength_2030102 288
set Beamlength_2030103 288
set Beamlength_2040101 288
set Beamlength_2040102 288
set Beamlength_2040103 288
set Beamlength_2020201 288
set Beamlength_2020202 288
set Beamlength_2020203 288
set Beamlength_2030201 288
set Beamlength_2030202 288
set Beamlength_2030203 288
set Beamlength_2040201 288
set Beamlength_2040202 288
set Beamlength_2040203 288
#COLUMN
element nonlinearBeamColumn 20100	111101	211101 5 1 1
element nonlinearBeamColumn 20101	111102	211102 5 1 1
element nonlinearBeamColumn 20102	111103	211103 5 1 1
element nonlinearBeamColumn 30100	211101	311101 5 1 1
element nonlinearBeamColumn 30101	211102	311102 5 1 1
element nonlinearBeamColumn 30102	211103	311103 5 1 1
element nonlinearBeamColumn 40100	311101	411101 5 1 1
element nonlinearBeamColumn 40101	311102	411102 5 1 1
element nonlinearBeamColumn 40102	311103	411103 5 1 1
element nonlinearBeamColumn 20200	111201	211201 5 1 1
element nonlinearBeamColumn 20201	111202	211202 5 1 1
element nonlinearBeamColumn 20202	111203	211203 5 1 1
element nonlinearBeamColumn 30200	211201	311201 5 1 1
element nonlinearBeamColumn 30201	211202	311202 5 1 1
element nonlinearBeamColumn 30202	211203	311203 5 1 1
element nonlinearBeamColumn 40200	311201	411201 5 1 1
element nonlinearBeamColumn 40201	311202	411202 5 1 1
element nonlinearBeamColumn 40202	311203	411203 5 1 1
element nonlinearBeamColumn 20300	111301	211301 5 1 1
element nonlinearBeamColumn 20301	111302	211302 5 1 1
element nonlinearBeamColumn 20302	111303	211303 5 1 1
element nonlinearBeamColumn 30300	211301	311301 5 1 1
element nonlinearBeamColumn 30301	211302	311302 5 1 1
element nonlinearBeamColumn 30302	211303	311303 5 1 1
element nonlinearBeamColumn 40300	311301	411301 5 1 1
element nonlinearBeamColumn 40301	311302	411302 5 1 1
element nonlinearBeamColumn 40302	311303	411303 5 1 1
#COLUMNLENGTH
set Columnlength_20100 168
set Columnlength_20101 168
set Columnlength_20102 168
set Columnlength_30100 168
set Columnlength_30101 168
set Columnlength_30102 168
set Columnlength_40100 168
set Columnlength_40101 168
set Columnlength_40102 168
set Columnlength_20200 168
set Columnlength_20201 168
set Columnlength_20202 168
set Columnlength_30200 168
set Columnlength_30201 168
set Columnlength_30202 168
set Columnlength_40200 168
set Columnlength_40201 168
set Columnlength_40202 168
set Columnlength_20300 168
set Columnlength_20301 168
set Columnlength_20302 168
set Columnlength_30300 168
set Columnlength_30301 168
set Columnlength_30302 168
set Columnlength_40300 168
set Columnlength_40301 168
set Columnlength_40302 168
#END