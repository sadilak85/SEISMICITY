recorder Node -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/Displacement_AllNodes.out -time -node 200101 200102 200201 200202 300101 300102 300201 300202 400101 400102 400201 400202 -dof 1 2 3 disp
recorder Node -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/mode1_AllNodes.out -node 200101 200102 200201 200202 300101 300102 300201 300202 400101 400102 400201 400202 -dof 1 2 3 "eigen1"
recorder Node -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/mode2_AllNodes.out -node 200101 200102 200201 200202 300101 300102 300201 300202 400101 400102 400201 400202 -dof 1 2 3 "eigen2"
recorder Node -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/mode3_AllNodes.out -node 200101 200102 200201 200202 300101 300102 300201 300202 400101 400102 400201 400202 -dof 1 2 3 "eigen3"
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/Force_AllElements.out -time -ele 1020101 1030101 1040101 1020201 1030201 1040201 2020101 2020102 2030101 2030102 2040101 2040102 20100 20101 30100 30101 40100 40101 20200 20201 30200 30201 40200 40201 localForce
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/Force_AllElements_sec_1.out -time -ele 1020101 1030101 1040101 1020201 1030201 1040201 2020101 2020102 2030101 2030102 2040101 2040102 20100 20101 30100 30101 40100 40101 20200 20201 30200 30201 40200 40201 section 1 force
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/Deformation_AllElements_sec_1.out -time -ele 1020101 1030101 1040101 1020201 1030201 1040201 2020101 2020102 2030101 2030102 2040101 2040102 20100 20101 30100 30101 40100 40101 20200 20201 30200 30201 40200 40201 section 1 deformation
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/Force_AllElements_sec_5.out -time -ele 1020101 1030101 1040101 1020201 1030201 1040201 2020101 2020102 2030101 2030102 2040101 2040102 20100 20101 30100 30101 40100 40101 20200 20201 30200 30201 40200 40201 section 5 force
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/Deformation_AllElements_sec_5.out -time -ele 1020101 1030101 1040101 1020201 1030201 1040201 2020101 2020102 2030101 2030102 2040101 2040102 20100 20101 30100 30101 40100 40101 20200 20201 30200 30201 40200 40201 section 5 deformation
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/StressStrain_AllBeamElements_concEle_sec_1.out -time -ele 1020101 1030101 1040101 1020201 1030201 1040201 section 5 fiber 9.5 6.5 1  stressStrain
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/StressStrain_AllBeamElements_reinfEle_sec_1.out -time -ele 1020101 1030101 1040101 1020201 1030201 1040201 section 5 fiber 9.5 6.5 3  stressStrain
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/StressStrain_AllGirderElements_concEle_sec_1.out -time -ele 2020101 2020102 2030101 2030102 2040101 2040102 section 5 fiber 9.5 6.5 1  stressStrain
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/StressStrain_AllGirderElements_reinfEle_sec_1.out -time -ele 2020101 2020102 2030101 2030102 2040101 2040102 section 5 fiber 9.5 6.5 3  stressStrain
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/StressStrain_AllColumnElements_concEle_sec_1.out -time -ele 20100 20101 30100 30101 40100 40101 20200 20201 30200 30201 40200 40201 section 5 fiber 6.5 6.5 1  stressStrain
recorder Element -file c:/Users/gw00161333/SEISMICITY/Bidirectional_Earthquake_GroundMotion/outputs/3Story_1Bay_1Bayz/StressStrain_AllColumnElements_reinfEle_sec_1.out -time -ele 20100 20101 30100 30101 40100 40101 20200 20201 30200 30201 40200 40201 section 5 fiber 6.5 6.5 3  stressStrain
