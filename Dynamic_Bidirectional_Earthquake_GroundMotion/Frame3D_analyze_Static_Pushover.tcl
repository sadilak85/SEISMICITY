# --------------------------------------------------------------------------------------------------
# Example 8. Static Pushover
#                             Silvia Mazzoni & Frank McKenna, 2006
# execute this file after you have built the model, and after you apply gravity
#
puts " ------------- Static Pushover Analysis -------------"
#
# ------------  SET UP -------------------------------------------------------------------------
wipe;				# clear memory of all past model definitions
model BasicBuilder -ndm 3 -ndf 6;	# Define the model builder, ndm=#dimension, ndf=#dofs

puts "Enter the folder name inside the input folder which includes simulation include files: "
gets stdin inputFoldername
set inputFilename "inputs/$inputFoldername/INPUT_"
set InputDir inputs/$inputFoldername;			# set up name of input directory
set FileExt ".tcl"
set outputFilename $inputFoldername
set dataDir outputs/$outputFilename;			# set up name of data directory
file mkdir "$dataDir"; 			# create data directory
source LibUnits.tcl;			# define units (kip-in-sec)
source DisplayPlane.tcl;		# procedure for displaying a plane in model
source DisplayModel3D.tcl;		# procedure for displaying 3D perspectives of model
source BuildRCrectSection.tcl;		# procedure for definining RC fiber section
source python_calls.tcl
#
# Define SECTIONS -------------------------------------------------------------
set SectionType FiberSection;		# options: Elastic FiberSection
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
source SectionProperties.tcl
#
# ---------------------   INPUT DATA from FILE  -----------------------------------------------------
set Buildingnum 0; # initialize the total number of buildings
set ainputFilename ""
source split_inputFileNames.tcl; # take file names, define number of buildings and take the building IDs
#
# ---------------------   CREATE THE MODEL  ----------------------------------------------------------
for {set numInFile 0} {$numInFile <= [expr $Buildingnum-1]} {incr numInFile 1} {
 source Frame3D_Build_RC.tcl ;  			#inputing many building parameters
 source Loads_Weights_Masses.tcl; 		#Gravity, Nodal Weights, Lateral Loads, Masses
}
if {$Buildingnum>1} {
	source Pounding_buildings.tcl
}
puts "Model Built"
#
#
# ---------------------   CREATE OUTPUT FILES  -----------------------------------------------------
for {set numInFile 0} {$numInFile <= [expr $Buildingnum-1]} {incr numInFile 1} {
	source Recorder_outputs.tcl
}
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





# characteristics of pushover analysis
set Dmax [expr 0.1*$LBuilding ];	# maximum displacement of pushover. push to a % drift.
set Dincr [expr 0.0000001*$LBuilding ];	# displacement increment. you want this to be small, but not too small to slow analysis
set Dincr [expr 0.01*$in];
#
# -- STATIC PUSHOVER/CYCLIC ANALYSIS
# create load pattern for lateral pushover load coefficient when using linear load pattern
# need to apply lateral load only to the master nodes of the rigid diaphragm at each floor
pattern Plain 200 Linear {;
	foreach NodePush $iNodePush FPush $iFPush {
			load $NodePush $FPush 0.0 0.0 0.0 0.0 0.0
	}
};		# end load pattern


# Plot displacements -------------------------------------------------------------
recorder plot $dataDir/Disp_FreeNodes$_aBID.out DisplDOF[lindex $iGMdirection 0] 1100 10 400 400 -columns  1 [expr 1+[lindex $iGMdirection 0]] ; # a window to plot the nodal displacements versus time
recorder plot $dataDir/Disp_FreeNodes$_aBID.out DisplDOF[lindex $iGMdirection 1] 1100 410 400 400 -columns 1 [expr 1+[lindex $iGMdirection 1]] ; # a window to plot the nodal displacements versus time

# set up ground-motion-analysis parameters
set DtAnalysis	[expr 0.01*$sec];	# time-step Dt for lateral analysis
set TmaxAnalysis	[expr 10. *$sec];	# maximum duration of ground-motion analysis -- should be 50*$sec

# ----------- set up analysis parameters
source LibAnalysisDynamicParameters.tcl;	# constraintsHandler,DOFnumberer,system-ofequations,convergenceTest,solutionAlgorithm,integrator

# ------------ define & apply damping
# RAYLEIGH damping parameters, Where to put M/K-prop damping, switches (http://opensees.berkeley.edu/OpenSees/manuals/usermanual/1099.htm)
#          D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
set xDamp 0.02;					# damping ratio
set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 1.0;
set KinitSwitch 0.0;
set nEigenI 1;		# mode 1
set nEigenJ 3;		# mode 3
set lambdaN [eigen [expr $nEigenJ]];			# eigenvalue analysis for nEigenJ modes
set lambdaI [lindex $lambdaN [expr $nEigenI-1]]; 		# eigenvalue mode i
set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]]; 	# eigenvalue mode j
set omegaI [expr pow($lambdaI,0.5)];
set omegaJ [expr pow($lambdaJ,0.5)];
set alphaM [expr $MpropSwitch*$xDamp*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	# M-prop. damping; D = alphaM*M
set betaKcurr [expr $KcurrSwitch*2.*$xDamp/($omegaI+$omegaJ)];         		# current-K;      +beatKcurr*KCurrent
set betaKcomm [expr $KcommSwitch*2.*$xDamp/($omegaI+$omegaJ)];   		# last-committed K;   +betaKcomm*KlastCommitt
set betaKinit [expr $KinitSwitch*2.*$xDamp/($omegaI+$omegaJ)];         			# initial-K;     +beatKinit*Kini
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 				# RAYLEIGH damping

#  ---------------------------------    perform Dynamic Ground-Motion Analysis
# the following commands are unique to the Uniform Earthquake excitation
set IDloadTag 400;	# for uniformSupport excitation
# Uniform EXCITATION: acceleration input
foreach GMdirection $iGMdirection GMfile $iGMfile GMfact $iGMfact {
	incr IDloadTag;
	set inFile $GMdir/$GMfile.at2
	set outFile $GMdir/$GMfile.g3;			# set variable holding new filename (PEER files have .at2/dt2 extension)
	ReadSMDFile $inFile $outFile dt;			# call procedure to convert the ground-motion file
	set GMfatt [expr $g*$GMfact];			# data in input file is in g Unifts -- ACCELERATION TH
	set AccelSeries "Series -dt $dtInput -filePath $outFile -factor  $GMfatt";		# time series information
	pattern UniformExcitation  $IDloadTag  $GMdirection -accel  $AccelSeries  ;	# create Unifform excitation
}

set Nsteps [expr int($TmaxAnalysis/$DtAnalysis)];
set ok [analyze $Nsteps $DtAnalysis];			# actually perform analysis; returns ok=0 if analysis was successful

if {$ok != 0} {      ;					# analysis was not successful.
	# --------------------------------------------------------------------------------------------------
	# change some analysis parameters to achieve convergence
	# performance is slower inside this loop
	#    Time-controlled analysis
	set ok 0;
	set controlTime [getTime];
	while {$controlTime < $TmaxAnalysis && $ok == 0} {
		set controlTime [getTime]
		set ok [analyze 1 $DtAnalysis]
		if {$ok != 0} {
			puts "Trying Newton with Initial Tangent .."
			test NormDispIncr   $Tol 1000  0
			algorithm Newton -initial
			set ok [analyze 1 $DtAnalysis]
			test $testTypeDynamic $TolDynamic $maxNumIterDynamic  0
			algorithm $algorithmTypeDynamic
		}
		if {$ok != 0} {
			puts "Trying Broyden .."
			algorithm Broyden 8
			set ok [analyze 1 $DtAnalysis]
			algorithm $algorithmTypeDynamic
		}
		if {$ok != 0} {
			puts "Trying NewtonWithLineSearch .."
			algorithm NewtonLineSearch .8
			set ok [analyze 1 $DtAnalysis]
			algorithm $algorithmTypeDynamic
		}
	}
};      # end if ok !0

puts "Ground Motion Done. End Time: [getTime]"