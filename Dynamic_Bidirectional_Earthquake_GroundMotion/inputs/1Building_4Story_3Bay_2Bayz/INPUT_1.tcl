#BUILDING ID 1
#GROUND
node 10101	0.0	0.0	0.0
node 10102	288.0	0.0	0.0
node 10103	576.0	0.0	0.0
node 10104	864.0	0.0	0.0
node 10201	0.0	0.0	288.0
node 10202	288.0	0.0	288.0
node 10203	576.0	0.0	288.0
node 10204	864.0	0.0	288.0
node 10301	0.0	0.0	576.0
node 10302	288.0	0.0	576.0
node 10303	576.0	0.0	576.0
node 10304	864.0	0.0	576.0
#FLOOR #1
node 20101	0.0	168.0	0.0
node 20102	288.0	168.0	0.0
node 20103	576.0	168.0	0.0
node 20104	864.0	168.0	0.0
node 20201	0.0	168.0	288.0
node 20202	288.0	168.0	288.0
node 20203	576.0	168.0	288.0
node 20204	864.0	168.0	288.0
node 20301	0.0	168.0	576.0
node 20302	288.0	168.0	576.0
node 20303	576.0	168.0	576.0
node 20304	864.0	168.0	576.0
#FLOOR #2
node 30101	0.0	336.0	0.0
node 30102	288.0	336.0	0.0
node 30103	576.0	336.0	0.0
node 30104	864.0	336.0	0.0
node 30201	0.0	336.0	288.0
node 30202	288.0	336.0	288.0
node 30203	576.0	336.0	288.0
node 30204	864.0	336.0	288.0
node 30301	0.0	336.0	576.0
node 30302	288.0	336.0	576.0
node 30303	576.0	336.0	576.0
node 30304	864.0	336.0	576.0
#FLOOR #3
node 40101	0.0	504.0	0.0
node 40102	288.0	504.0	0.0
node 40103	576.0	504.0	0.0
node 40104	864.0	504.0	0.0
node 40201	0.0	504.0	288.0
node 40202	288.0	504.0	288.0
node 40203	576.0	504.0	288.0
node 40204	864.0	504.0	288.0
node 40301	0.0	504.0	576.0
node 40302	288.0	504.0	576.0
node 40303	576.0	504.0	576.0
node 40304	864.0	504.0	576.0
#FLOOR #4
node 50101	0.0	672.0	0.0
node 50102	288.0	672.0	0.0
node 50103	576.0	672.0	0.0
node 50104	864.0	672.0	0.0
node 50201	0.0	672.0	288.0
node 50202	288.0	672.0	288.0
node 50203	576.0	672.0	288.0
node 50204	864.0	672.0	288.0
node 50301	0.0	672.0	576.0
node 50302	288.0	672.0	576.0
node 50303	576.0	672.0	576.0
node 50304	864.0	672.0	576.0
#MASTERNODES
node 9902	432.0	168.0	288.0
node 9903	432.0	336.0	288.0
node 9904	432.0	504.0	288.0
node 9905	432.0	672.0	288.0
#RIGID
rigidDiaphragm 2 9902	20101	20102	20103	20104	20201	20202	20203	20204	20301	20302	20303	20304
rigidDiaphragm 2 9903	30101	30102	30103	30104	30201	30202	30203	30204	30301	30302	30303	30304
rigidDiaphragm 2 9904	40101	40102	40103	40104	40201	40202	40203	40204	40301	40302	40303	40304
rigidDiaphragm 2 9905	50101	50102	50103	50104	50201	50202	50203	50204	50301	50302	50303	50304
#BEAM
element nonlinearBeamColumn 1020101	20101	20102 5 2 2
element nonlinearBeamColumn 1020102	20102	20103 5 2 2
element nonlinearBeamColumn 1020103	20103	20104 5 2 2
element nonlinearBeamColumn 1020201	20201	20202 5 2 2
element nonlinearBeamColumn 1020202	20202	20203 5 2 2
element nonlinearBeamColumn 1020203	20203	20204 5 2 2
element nonlinearBeamColumn 1020301	20301	20302 5 2 2
element nonlinearBeamColumn 1020302	20302	20303 5 2 2
element nonlinearBeamColumn 1020303	20303	20304 5 2 2
element nonlinearBeamColumn 1030101	30101	30102 5 2 2
element nonlinearBeamColumn 1030102	30102	30103 5 2 2
element nonlinearBeamColumn 1030103	30103	30104 5 2 2
element nonlinearBeamColumn 1030201	30201	30202 5 2 2
element nonlinearBeamColumn 1030202	30202	30203 5 2 2
element nonlinearBeamColumn 1030203	30203	30204 5 2 2
element nonlinearBeamColumn 1030301	30301	30302 5 2 2
element nonlinearBeamColumn 1030302	30302	30303 5 2 2
element nonlinearBeamColumn 1030303	30303	30304 5 2 2
element nonlinearBeamColumn 1040101	40101	40102 5 2 2
element nonlinearBeamColumn 1040102	40102	40103 5 2 2
element nonlinearBeamColumn 1040103	40103	40104 5 2 2
element nonlinearBeamColumn 1040201	40201	40202 5 2 2
element nonlinearBeamColumn 1040202	40202	40203 5 2 2
element nonlinearBeamColumn 1040203	40203	40204 5 2 2
element nonlinearBeamColumn 1040301	40301	40302 5 2 2
element nonlinearBeamColumn 1040302	40302	40303 5 2 2
element nonlinearBeamColumn 1040303	40303	40304 5 2 2
element nonlinearBeamColumn 1050101	50101	50102 5 2 2
element nonlinearBeamColumn 1050102	50102	50103 5 2 2
element nonlinearBeamColumn 1050103	50103	50104 5 2 2
element nonlinearBeamColumn 1050201	50201	50202 5 2 2
element nonlinearBeamColumn 1050202	50202	50203 5 2 2
element nonlinearBeamColumn 1050203	50203	50204 5 2 2
element nonlinearBeamColumn 1050301	50301	50302 5 2 2
element nonlinearBeamColumn 1050302	50302	50303 5 2 2
element nonlinearBeamColumn 1050303	50303	50304 5 2 2
#BEAMLENGTH
set Beamlength_1020101 288
set Beamlength_1020102 288
set Beamlength_1020103 288
set Beamlength_1020201 288
set Beamlength_1020202 288
set Beamlength_1020203 288
set Beamlength_1020301 288
set Beamlength_1020302 288
set Beamlength_1020303 288
set Beamlength_1030101 288
set Beamlength_1030102 288
set Beamlength_1030103 288
set Beamlength_1030201 288
set Beamlength_1030202 288
set Beamlength_1030203 288
set Beamlength_1030301 288
set Beamlength_1030302 288
set Beamlength_1030303 288
set Beamlength_1040101 288
set Beamlength_1040102 288
set Beamlength_1040103 288
set Beamlength_1040201 288
set Beamlength_1040202 288
set Beamlength_1040203 288
set Beamlength_1040301 288
set Beamlength_1040302 288
set Beamlength_1040303 288
set Beamlength_1050101 288
set Beamlength_1050102 288
set Beamlength_1050103 288
set Beamlength_1050201 288
set Beamlength_1050202 288
set Beamlength_1050203 288
set Beamlength_1050301 288
set Beamlength_1050302 288
set Beamlength_1050303 288
#GIRDER
element nonlinearBeamColumn 2020101	20101	20201 5 3 3
element nonlinearBeamColumn 2020102	20102	20202 5 3 3
element nonlinearBeamColumn 2020103	20103	20203 5 3 3
element nonlinearBeamColumn 2020104	20104	20204 5 3 3
element nonlinearBeamColumn 2020201	20201	20301 5 3 3
element nonlinearBeamColumn 2020202	20202	20302 5 3 3
element nonlinearBeamColumn 2020203	20203	20303 5 3 3
element nonlinearBeamColumn 2020204	20204	20304 5 3 3
element nonlinearBeamColumn 2030101	30101	30201 5 3 3
element nonlinearBeamColumn 2030102	30102	30202 5 3 3
element nonlinearBeamColumn 2030103	30103	30203 5 3 3
element nonlinearBeamColumn 2030104	30104	30204 5 3 3
element nonlinearBeamColumn 2030201	30201	30301 5 3 3
element nonlinearBeamColumn 2030202	30202	30302 5 3 3
element nonlinearBeamColumn 2030203	30203	30303 5 3 3
element nonlinearBeamColumn 2030204	30204	30304 5 3 3
element nonlinearBeamColumn 2040101	40101	40201 5 3 3
element nonlinearBeamColumn 2040102	40102	40202 5 3 3
element nonlinearBeamColumn 2040103	40103	40203 5 3 3
element nonlinearBeamColumn 2040104	40104	40204 5 3 3
element nonlinearBeamColumn 2040201	40201	40301 5 3 3
element nonlinearBeamColumn 2040202	40202	40302 5 3 3
element nonlinearBeamColumn 2040203	40203	40303 5 3 3
element nonlinearBeamColumn 2040204	40204	40304 5 3 3
element nonlinearBeamColumn 2050101	50101	50201 5 3 3
element nonlinearBeamColumn 2050102	50102	50202 5 3 3
element nonlinearBeamColumn 2050103	50103	50203 5 3 3
element nonlinearBeamColumn 2050104	50104	50204 5 3 3
element nonlinearBeamColumn 2050201	50201	50301 5 3 3
element nonlinearBeamColumn 2050202	50202	50302 5 3 3
element nonlinearBeamColumn 2050203	50203	50303 5 3 3
element nonlinearBeamColumn 2050204	50204	50304 5 3 3
#GIRDERLENGTH                                                                     
set Beamlength_2020101 288                    
set Beamlength_2020102 288                    
set Beamlength_2020103 288
set Beamlength_2020104 288
set Beamlength_2020201 288
set Beamlength_2020202 288
set Beamlength_2020203 288                    
set Beamlength_2020204 288                    
set Beamlength_2030101 288
set Beamlength_2030102 288
set Beamlength_2030103 288
set Beamlength_2030104 288
set Beamlength_2030201 288                    
set Beamlength_2030202 288                    
set Beamlength_2030203 288
set Beamlength_2030204 288
set Beamlength_2040101 288
set Beamlength_2040102 288
set Beamlength_2040103 288                    
set Beamlength_2040104 288                    
set Beamlength_2040201 288
set Beamlength_2040202 288
set Beamlength_2040203 288
set Beamlength_2040204 288
set Beamlength_2050101 288                    
set Beamlength_2050102 288                    
set Beamlength_2050103 288
set Beamlength_2050104 288
set Beamlength_2050201 288
set Beamlength_2050202 288
set Beamlength_2050203 288                    
set Beamlength_2050204 288                    
#COLUMN
element nonlinearBeamColumn 20100	10101	20101 5 1 1
element nonlinearBeamColumn 20101	10102	20102 5 1 1
element nonlinearBeamColumn 20102	10103	20103 5 1 1
element nonlinearBeamColumn 20103	10104	20104 5 1 1
element nonlinearBeamColumn 20300	10301	20301 5 1 1
element nonlinearBeamColumn 20301	10302	20302 5 1 1
element nonlinearBeamColumn 20302	10303	20303 5 1 1
element nonlinearBeamColumn 20303	10304	20304 5 1 1
element nonlinearBeamColumn 20200	10201	20201 5 1 1
element nonlinearBeamColumn 20201	10202	20202 5 1 1
element nonlinearBeamColumn 20202	10203	20203 5 1 1
element nonlinearBeamColumn 20203	10204	20204 5 1 1
element nonlinearBeamColumn 30100	20101	30101 5 1 1
element nonlinearBeamColumn 30101	20102	30102 5 1 1
element nonlinearBeamColumn 30102	20103	30103 5 1 1
element nonlinearBeamColumn 30103	20104	30104 5 1 1
element nonlinearBeamColumn 30200	20201	30201 5 1 1
element nonlinearBeamColumn 30201	20202	30202 5 1 1
element nonlinearBeamColumn 30202	20203	30203 5 1 1
element nonlinearBeamColumn 30203	20204	30204 5 1 1
element nonlinearBeamColumn 30300	20301	30301 5 1 1
element nonlinearBeamColumn 30301	20302	30302 5 1 1
element nonlinearBeamColumn 30302	20303	30303 5 1 1
element nonlinearBeamColumn 30303	20304	30304 5 1 1
element nonlinearBeamColumn 40100	30101	40101 5 1 1
element nonlinearBeamColumn 40101	30102	40102 5 1 1
element nonlinearBeamColumn 40102	30103	40103 5 1 1
element nonlinearBeamColumn 40103	30104	40104 5 1 1
element nonlinearBeamColumn 40200	30201	40201 5 1 1
element nonlinearBeamColumn 40201	30202	40202 5 1 1
element nonlinearBeamColumn 40202	30203	40203 5 1 1
element nonlinearBeamColumn 40203	30204	40204 5 1 1
element nonlinearBeamColumn 40300	30301	40301 5 1 1
element nonlinearBeamColumn 40301	30302	40302 5 1 1
element nonlinearBeamColumn 40302	30303	40303 5 1 1
element nonlinearBeamColumn 40303	30304	40304 5 1 1
element nonlinearBeamColumn 50100	40101	50101 5 1 1
element nonlinearBeamColumn 50101	40102	50102 5 1 1
element nonlinearBeamColumn 50102	40103	50103 5 1 1
element nonlinearBeamColumn 50103	40104	50104 5 1 1
element nonlinearBeamColumn 50200	40201	50201 5 1 1
element nonlinearBeamColumn 50201	40202	50202 5 1 1
element nonlinearBeamColumn 50202	40203	50203 5 1 1
element nonlinearBeamColumn 50203	40204	50204 5 1 1
element nonlinearBeamColumn 50300	40301	50301 5 1 1
element nonlinearBeamColumn 50301	40302	50302 5 1 1
element nonlinearBeamColumn 50302	40303	50303 5 1 1
element nonlinearBeamColumn 50303	40304	50304 5 1 1
#COLUMNLENGTH
set Columnlength_20100 168
set Columnlength_20101 168
set Columnlength_20102 168
set Columnlength_20103 168
set Columnlength_20300 168
set Columnlength_20301 168
set Columnlength_20302 168
set Columnlength_20303 168
set Columnlength_20200 168
set Columnlength_20201 168
set Columnlength_20202 168
set Columnlength_20203 168
set Columnlength_30100 168
set Columnlength_30101 168
set Columnlength_30102 168
set Columnlength_30103 168
set Columnlength_30200 168
set Columnlength_30201 168
set Columnlength_30202 168
set Columnlength_30203 168
set Columnlength_30300 168
set Columnlength_30301 168
set Columnlength_30302 168
set Columnlength_30303 168
set Columnlength_40100 168
set Columnlength_40101 168
set Columnlength_40102 168
set Columnlength_40103 168
set Columnlength_40200 168
set Columnlength_40201 168
set Columnlength_40202 168
set Columnlength_40203 168
set Columnlength_40300 168
set Columnlength_40301 168
set Columnlength_40302 168
set Columnlength_40303 168
set Columnlength_50100 168
set Columnlength_50101 168
set Columnlength_50102 168
set Columnlength_50103 168
set Columnlength_50200 168
set Columnlength_50201 168
set Columnlength_50202 168
set Columnlength_50203 168
set Columnlength_50300 168
set Columnlength_50301 168
set Columnlength_50302 168
set Columnlength_50303 168
#END