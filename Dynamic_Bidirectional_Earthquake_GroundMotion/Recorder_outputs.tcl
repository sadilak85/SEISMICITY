# --------------------------------------------------------------------------------------------------
#
# 				OUTPUTTING THE RESULTS
#
#
# -------------------------------------------------------------

set aBID [lindex $BID $numInFile 0]; # assign Building number
set _aBID "_Building_$aBID"
set _numIntgrPts "_$numIntgrPts"

set SupportNodeFirst [lindex $iSupportNode $numInFile 0];						# ID: first support node
set SupportNodeLast [lindex $iSupportNode $numInFile [expr [llength [lindex $iSupportNode $numInFile]]-1]];			# ID: last support node 
set MasterNodeFirst [lindex $iMasterNode $numInFile 0];						# ID: first master node
set MasterNodeLast [lindex $iMasterNode $numInFile [expr [llength [lindex $iMasterNode $numInFile]]-1]];			# ID: last master node
set AllnodesFirst [lindex $iNodeList $numInFile 0 0]
set AllnodesLast [lindex $iNodeList $numInFile [expr [llength [lindex $iNodeList $numInFile]]-1] 0]
set AllelementsFirst [lindex $iElementwColumns $numInFile 0 0]
set AllelementsLast [lindex $iElementwColumns $numInFile [expr [llength [lindex $iElementwColumns $numInFile]]-1] 0]


# set up name of data directory and create the folder
	set Outdir $dataDir/Building_$aBID
	file mkdir "$Outdir"
	
#For displaying purpose:
recorder Node -file $Outdir/Disp_FreeNodes$_aBID.out -time -node [lindex $FreeNodeID $numInFile 0] -dof 1 2 3 disp; # displacements of free node
# -------------------------------  Node RESULTs ------------------------------------------
recorder Node -file $Outdir/Displacement_AllNodes$_aBID.out -time -nodeRange $AllnodesFirst $AllnodesLast -dof 1 2 3 disp;# displacements of All Nodes
recorder Node -file $Outdir/Reaction_AllNodes$_aBID.out -time -nodeRange $AllnodesFirst $AllnodesLast -dof 1 2 3 reaction;	# support reaction
recorder Drift -file $Outdir/LateralDrift$_aBID.out -time -iNode $SupportNodeFirst  -jNode [lindex $FreeNodeID $numInFile 0] -dof 1 -perpDirn 2;	# lateral drift

# -------------------------------  Element RESULTs ------------------------------------------
recorder Element -file $Outdir/Force_AllElements$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast localForce;				# element forces in local coordinates
recorder Element -file $Outdir/Force_AllElements_sec_1$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast section 1 force;	# section forces, axial and moment, node i
recorder Element -file $Outdir/Deformation_AllElements_sec_1$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast section 1 deformation;	# section deformations, axial and curvature, node i
recorder Element -file $Outdir/Force_AllElements_sec$_numIntgrPts$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast section $numIntgrPts force;	# section forces, axial and moment, node j
recorder Element -file $Outdir/Deformation_AllElements_sec$_numIntgrPts$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast section $numIntgrPts deformation;# section deformations, axial and curvature, node j

if {$RCSection=="True"} {
	set yFiber [expr $HCol/2-$cover];		# fiber location for stress-strain recorder, local coords
	set zFiber [expr $BCol/2-$cover];		# fiber location for stress-strain recorder, local coords
	recorder Element -file $Outdir/StressStrain_AllElements_concEle_sec_1$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast section $numIntgrPts fiber $yFiber $zFiber $IDconcCore  stressStrain;	# Core Concrete stress-strain, node i
	recorder Element -file $Outdir/StressStrain_AllElements_reinfEle_sec_1$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast section $numIntgrPts fiber $yFiber $zFiber $IDSteel  stressStrain;	# steel fiber stress-strain, node i
}
if {$WSection=="True"} {
	set yFiber [expr 0.];								# fiber location for stress-strain recorder, local coords
	set zFiber [expr 0.];								# fiber location for stress-strain recorder, local coords
	recorder Element -file $Outdir/StressStrain_AllElements_reinfEle_sec_1$_aBID.out -time -eleRange $AllelementsFirst $AllelementsLast section $numIntgrPts fiber $yFiber $zFiber stressStrain;	# steel fiber stress-strain, node i
}
#
set outFileNodeIDName $Outdir/NodeIDs.out
set outFileEltIDName $Outdir/ElementIDs.out
 CreateNodeIDFile $iNodeList $numInFile $outFileNodeIDName
 CreateEltIDFile $iElementwColumns $numInFile $outFileEltIDName
#