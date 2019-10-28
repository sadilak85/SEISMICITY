# --------------------------------------------------------------------------------------------------
# Outputting
#

#
# Define RECORDERS -------------------------------------------------------------
set SupportNodeFirst [lindex $iSupportNode $numInFile 0];						# ID: first support node
set SupportNodeLast [lindex $iSupportNode $numInFile [expr [llength [lindex $iSupportNode $numInFile]]-1]];		# ID: last support node 
set MasterNodeFirst [lindex $iMasterNode $numInFile 0];						# ID: first master node
set MasterNodeLast [lindex $iMasterNode $numInFile [expr [llength [lindex $iMasterNode $numInFile]]-1]];			# ID: last master node

set aBID [lindex $BID $numInFile 0]; # assign Building number
set _aBID "_$aBID"

recorder Node -file $dataDir/DFree$_aBID.out -time -node [lindex $FreeNodeID $numInFile 0] -dof 1 2 3 disp;				# displacements of free node
recorder Node -file $dataDir/DMaster$_aBID.out -time -nodeRange $MasterNodeFirst $MasterNodeLast -dof 1 2 3 disp;	# displacements of support nodes
recorder Node -file $dataDir/DBase$_aBID.out -time -nodeRange $SupportNodeFirst $SupportNodeLast -dof 1 2 3 disp;	# displacements of support nodes
recorder Node -file $dataDir/RBase$_aBID.out -time -nodeRange $SupportNodeFirst $SupportNodeLast -dof 1 2 3 reaction;	# support reaction
recorder Drift -file $dataDir/DrNode$_aBID.out -time -iNode $SupportNodeFirst  -jNode [lindex $FreeNodeID $numInFile 0] -dof 1 -perpDirn 2;	# lateral drift
recorder Element -file $dataDir/Fel1$_aBID.out -time -ele $FirstColumn localForce;					# element forces in local coordinates
recorder Element -file $dataDir/ForceEle1sec1$_aBID.out -time -ele $FirstColumn section 1 force;			# section forces, axial and moment, node i
recorder Element -file $dataDir/DefoEle1sec1$_aBID.out -time -ele $FirstColumn section 1 deformation;			# section deformations, axial and curvature, node i
recorder Element -file $dataDir/ForceEle1sec$numIntgrPts$_aBID.out -time -ele $FirstColumn section $numIntgrPts force;			# section forces, axial and moment, node j
recorder Element -file $dataDir/DefoEle1sec$numIntgrPts$_aBID.out -time -ele $FirstColumn section $numIntgrPts deformation;		# section deformations, axial and curvature, node j
set yFiber [expr $HCol/2-$cover];								# fiber location for stress-strain recorder, local coords
set zFiber [expr $BCol/2-$cover];								# fiber location for stress-strain recorder, local coords
recorder Element -file $dataDir/SSconcEle1sec1$_aBID.out -time -ele $FirstColumn section $numIntgrPts fiber $yFiber $zFiber $IDconcCore  stressStrain;	# steel fiber stress-strain, node i
recorder Element -file $dataDir/SSreinfEle1sec1$_aBID.out -time -ele $FirstColumn section $numIntgrPts fiber $yFiber $zFiber $IDSteel  stressStrain;	# steel fiber stress-strain, node i

