# --------------------------------------------------------------------------------------------------
#	STATIC PUSHOVER ANALYSIS
#		November 2019 S.Adilak
# --------------------------------------------------------------------------------------------------
# Modified, Enhanced, Developed from the Original setup of Opensees Example 8. 
#		Static Pushover - Silvia Mazzoni & Frank McKenna, 2006
#
puts " ------------- Static Pushover Analysis -------------"
#
source LibUnits.tcl;			# define units (kip-in-sec)
source DisplayPlane.tcl;		# procedure for displaying a plane in model
source DisplayModel3D.tcl;		# procedure for displaying 3D perspectives of model
source AreaPolygon.tcl
source subfolderSearch.tcl
# ------------------  Define SECTIONS ------------------------------------------------------
set SectionType FiberSection;		# options: Elastic FiberSection
if {$RCSection=="True"} {
	source BuildRCrectSection.tcl;		# procedure for definining RC fiber section
}
if {$WSection=="True"} {
	source Wsection.tcl; # procedure for definining steel W section
}
# ------------  SET UP -------------------------------------------------------------------------
wipe;				# clear memory of all past model definitions
model BasicBuilder -ndm 3 -ndf 6;	# Define the model builder, ndm=#dimension, ndf=#dofs
#
# ---------------------   Input File Names List  -----------------------------------------------------
set InputDir $inputFilepath;			# set up name of input directory
set Buildingnum 0; # initialize the total number of buildings
source split_inputFileNames.tcl; # take file names, define number of buildings and take the building IDs
#
set dataDir $outputFilepath;			# set up name of data directory
file mkdir "$dataDir"; 			# create data directory
#
set RigidDiaphragm ON ;		# options: ON, OFF. specify this before the analysis parameters are set the constraints are handled differently.
set perpDirn 2;				# perpendicular to plane of rigid diaphragm
set numIntgrPts 5;
# define section tags:
set ColSecTag 1
set BeamSecTag 2
set GirdSecTag 3
set ColSecTagFiber 4
set BeamSecTagFiber 5
set GirdSecTagFiber 6
set SecTagTorsion 70
# ---------------------- Define SECTIONs --------------------------------
if {$RCSection=="True"} {
	source RCrectSectionProperties.tcl
}
if {$WSection=="True"} {
	source WSectionProperties.tcl
}
# ---------------------   CREATE THE MODEL  ----------------------------------------------------------
for {set numInFile 0} {$numInFile <= [expr $Buildingnum-1]} {incr numInFile 1} {
	source Frame3D_Build_RC.tcl ;  			#inputing many building parameters
	source Anglebtw.tcl
	source nodeID2coordXZ.tcl
	source ElementLengths.tcl
	source FloorLoadDistribution.tcl; 		# Dead Load Distribution on Floors among interior Frames with unknown slab geometries
	source Loads_Weights_Masses.tcl; 		# Gravity, Nodal Weights, Lateral Loads, Masses
}
source CreateIDFile.tcl
source Recorder_outputs.tcl;	# OUTPUT RESULTS
if {$Buildingnum>1} {
	source Pounding_buildings.tcl
}
#
# Define DISPLAY -------------------------------------------------------------
DisplayModel3D DeformedShape ;	 # options: DeformedShape NodeNumbers ModeShape
#
# ---------------------  GRAVITY LOADS  -----------------------------------------------------
source Gravity.tcl
#
if {  [info exists RigidDiaphragm] == 1} {
	if {$RigidDiaphragm=="ON"} {
		variable constraintsTypeGravity Lagrange;	#  large model: try Transformation
	};	# if rigid diaphragm is on
};	# if rigid diaphragm exists
constraints $constraintsTypeGravity ;     		# how it handles boundary conditions
numberer RCM;			# renumber dof's to minimize band-width (optimization), if you want to
system BandGeneral ;		# how to store and solve the system of equations in the analysis (large model: try UmfPack)
test EnergyIncr $Tol 6 ; 		# determine if convergence has been achieved at the end of an iteration step
algorithm Newton;			# use Newton's solution algorithm: updates tangent stiffness at every iteration
set NstepGravity 10;  		# apply gravity in 10 steps
set DGravity [expr 1./$NstepGravity]; 	# first load increment;
integrator LoadControl $DGravity;	# determine the next time step for an analysis
analysis Static;			# define type of analysis static or transient

analyze $NstepGravity;		# apply gravity
# ------------------------------------------------- maintain constant gravity loads and reset time to zero
loadConst -time 0.0

set ListiNodePush ""
set ListiFPush ""
for {set numInFile 0} {$numInFile <= [expr $Buildingnum-1]} {incr numInFile 1} {
	for {set j 0} {$j <=[expr [lindex $NStory $numInFile]-1]} {incr j 1} {	
		set LBuilding [lindex $FloorHeight $numInFile $j]
		lappend ListiNodePush [lindex $iNodePush $numInFile $j]
		lappend ListiFPush [lindex $iFPush $numInFile $j]
		set IDctrlNode [lindex $iNodeList $numInFile [expr [llength [lindex $iNodeList $numInFile]]-1] 0];		# node where displacement is read for displacement control
	}
}

# characteristics of pushover analysis
set Dmax [expr 0.1*$LBuilding ];	# maximum displacement of pushover. push to a % drift.
set Dincr [expr 0.0000001*$LBuilding ];	# displacement increment. you want this to be small, but not too small to slow analysis
set Dincr [expr 0.01*$in];

# calculated MODEL PARAMETERS, particular to this model
# Set up parameters that are particular to the model for displacement control
set IDctrlDOF 1;					# degree of freedom of displacement read for displacement control


# -- STATIC PUSHOVER/CYCLIC ANALYSIS
# create load pattern for lateral pushover load coefficient when using linear load pattern
# need to apply lateral load only to the master nodes of the rigid diaphragm at each floor
pattern Plain 200 Linear {;
	foreach NodePush $ListiNodePush FPush $ListiFPush {
			load $NodePush $FPush 0.0 0.0 0.0 0.0 0.0
	}
};		# end load pattern

# Define DISPLAY -------------------------------------------------------------
# the deformed shape is defined in the build file
#recorder plot $dataDir/DFree.out Displ-X 1200 10 300 300 -columns 2 1; # a window to plot the nodal displacements versus time
#recorder plot $dataDir/DFree.out Displ-Z 1200 310 300 300 -columns 4 1; # a window to plot the nodal displacements versus time
#  ---------------------------------    perform Static Pushover Analysis
# ----------- set up analysis parameters
source LibAnalysisStaticParameters.tcl;	# constraintsHandler,DOFnumberer,system-ofequations,convergenceTest,solutionAlgorithm,integrator
set fmt1 "%s Pushover analysis: CtrlNode %.3i, dof %.1i, Disp=%.4f %s";	# format for screen/file output of DONE/PROBLEM analysis
# ----------------------------------------------first analyze command------------------------
set Nsteps [expr int($Dmax/$Dincr)];		# number of pushover analysis steps
set ok [analyze $Nsteps];                		# this will return zero if no convergence problems were encountered
# ----------------------------------------------if convergence failure-------------------------
if {$ok != 0} {  
	# if analysis fails, we try some other stuff, performance is slower inside this loop
	set Dstep 0.0;
	set ok 0
	while {$Dstep <= 1.0 && $ok == 0} {	
		set controlDisp [nodeDisp $IDctrlNode $IDctrlDOF ]
		set Dstep [expr $controlDisp/$Dmax]
		set ok [analyze 1];                		# this will return zero if no convergence problems were encountered
		if {$ok != 0} {;				# reduce step size if still fails to converge
			set Nk 4;			# reduce step size
			set DincrReduced [expr $Dincr/$Nk];
			integrator DisplacementControl  $IDctrlNode $IDctrlDOF $DincrReduced
			for {set ik 1} {$ik <=$Nk} {incr ik 1} {
				set ok [analyze 1];                		# this will return zero if no convergence problems were encountered
				if {$ok != 0} {  
					# if analysis fails, we try some other stuff
					# performance is slower inside this loop	global maxNumIterStatic;	    # max no. of iterations performed before "failure to converge" is ret'd
					puts "Trying Newton with Initial Tangent .."
					test NormDispIncr   $Tol 2000 0
					algorithm Newton -initial
					set ok [analyze 1]
					test $testTypeStatic $TolStatic      $maxNumIterStatic    0
					algorithm $algorithmTypeStatic
				}
				if {$ok != 0} {
					puts "Trying Broyden .."
					algorithm Broyden 8
					set ok [analyze 1 ]
					algorithm $algorithmTypeStatic
				}
				if {$ok != 0} {
					puts "Trying NewtonWithLineSearch .."
					algorithm NewtonLineSearch 0.8 
					set ok [analyze 1]
					algorithm $algorithmTypeStatic
				}
				if {$ok != 0} {;				# stop if still fails to converge
					puts [format $fmt1 "PROBLEM" $IDctrlNode $IDctrlDOF [nodeDisp $IDctrlNode $IDctrlDOF] $LunitTXT]
					return -1
				}; # end if
			}; # end for
			integrator DisplacementControl  $IDctrlNode $IDctrlDOF $Dincr;	# bring back to original increment
		}; # end if
	};	# end while loop
};      # end if ok !0
# -----------------------------------------------------------------------------------------------------

if {$ok != 0 } {
	puts [format $fmt1 "PROBLEM" $IDctrlNode $IDctrlDOF [nodeDisp $IDctrlNode $IDctrlDOF] $LunitTXT]
} else {
	puts [format $fmt1 "DONE"  $IDctrlNode $IDctrlDOF [nodeDisp $IDctrlNode $IDctrlDOF] $LunitTXT]
}
