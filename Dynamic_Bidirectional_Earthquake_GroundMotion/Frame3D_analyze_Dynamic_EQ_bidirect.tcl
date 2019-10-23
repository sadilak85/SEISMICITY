# --------------------------------------------------------------------------------------------------
# Example 8. Bidirectional Uniform Eartquake Excitation
#                             Silvia Mazzoni & Frank McKenna, 2006
# execute this file after you have built the model, and after you apply gravity
#
puts " -------------Uniaxial Inelastic Section, Nonlinear Model -------------"
puts " -------------Uniform Earthquake Excitation -------------"

# source in procedures
source ReadSMDfile.tcl;		# procedure for reading GM file and converting it to proper format

# Bidirectional Uniform Earthquake ground motion (uniform acceleration input at all support nodes)
set iGMfile "H-E01140 H-E12140" ;		# ground-motion filenames, should be different files
set iGMdirection "1 3";			# ground-motion direction
set iGMfact "1.5 0.75";			# ground-motion scaling factor
set dtInput 0.00500 ;		    # DT

# define GEOMETRY -------------------------------------------------------------
# define structure-geometry paramters
set LCol 168;		# column height (parallel to Y axis)	.... set this variable as array and take it from input file
set LBeam 288;		# beam length (parallel to X axis)		.... set this variable as array "
set LGird 288;		# girder length (parallel to Z axis)    .... set this variable as array "

# initialize variables for each building as list variables 
set NBay ""
set NBayZ ""
set NStory ""
set NFrame ""
set FreeNodeID ""
set iFPush "";			#lateral load for pushover
set iMasterNode ""
set iNodePush "";		# nodes for pushover/cyclic, vectorized
set iSupportNode ""
set MassTotal ""
set aFloorWeight ""

# SET UP ----------------------------------------------------------------------------
wipe;				# clear memory of all past model definitions
model BasicBuilder -ndm 3 -ndf 6;	# Define the model builder, ndm=#dimension, ndf=#dofs
set dataDir Data;			# set up name of data directory
file mkdir $dataDir; 			# create data directory
set GMdir "GMfiles";		# ground-motion file directory
source LibUnits.tcl;			# define units
source DisplayPlane.tcl;		# procedure for displaying a plane in model
source DisplayModel3D.tcl;		# procedure for displaying 3D perspectives of model
source BuildRCrectSection.tcl;		# procedure for definining RC fiber section

set Dlevel 10000;	# numbering increment for new-level nodes
set Dframe 100;	# numbering increment for new-frame nodes
set FirstColumn 110020100;							# ID: first column assuming it starts with 1   ????????????????????????????????????
# Define SECTIONS -------------------------------------------------------------
set SectionType FiberSection;		# options: Elastic FiberSection

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

# define ELEMENTS tags
# set up geometric transformations of element
#   separate columns and beams, in case of P-Delta analysis for columns
set IDColTransf 1; # all columns
set IDBeamTransf 2; # all beams
set IDGirdTransf 3; # all girds
set ColTransfType Linear ;		# options for columns: Linear PDelta  Corotational

geomTransf $ColTransfType  $IDColTransf  0 0 1;			# orientation of column stiffness affects bidirectional response.
geomTransf Linear $IDBeamTransf 0 0 1
geomTransf Linear $IDGirdTransf 1 0 0
# ---------------------- Define SECTIONs --------------------------------
source Section.tcl

# --------------------------------------------------------------------------------------------------------------------------------
# Define GRAVITY LOADS, weight and masses
# calculate dead load of frame, assume this to be an internal frame (do LL in a similar manner)
# calculate distributed weight along the beam length
#set GammaConcrete [expr 150*$pcf];   		# Reinforced-Concrete floor slabs, defined above
set Tslab [expr 6*$in];			# 6-inch slab
set Lslab [expr $LGird/2]; 			# slab extends a distance of $LGird/2 in/out of plane
set DLfactor 1.0;				# scale dead load up a little
set Qslab [expr $GammaConcrete*$Tslab*$Lslab*$DLfactor]; 
set QdlBeam [expr $Qslab + $QBeam]; 	# dead load distributed along beam (one-way slab)
set QdlGird $QGird; 			# dead load distributed along girder
set WeightCol [expr $QdlCol*$LCol];  		# total Column weight
set WeightBeam [expr $QdlBeam*$LBeam]; 	# total Beam weight
set WeightGird [expr $QdlGird*$LGird]; 	# total Gird weight

# ---------------------   INPUT DATA from FILE  -----------------------------------------------------
set inputFilename "inputs/INPUT_"
#set outputFilename "inputs/INPUT_"
set FileExt ".tcl"

set Buildingnum 0; # initialize the total number of buildings
set ainputFilename ""
#source split_inputFiles.tcl
source split_inputFileNames.tcl

for {set numInFile 0} {$numInFile <= [expr $Buildingnum-1]} {incr numInFile 1} {
 source Build_Model.tcl ;  #loop for inputing many building parameters
}

# ###################
# GRAVITY -------------------------------------------------------------
# define GRAVITY load applied to beams and columns -- eleLoad applies loads in local coordinate axis
pattern Plain 101 Linear {
	for {set i 0} {$i <= [expr [llength $elidcolumn]-1]} {incr i 1} {
		eleLoad -ele [lindex $elidcolumn $i] -type -beamUniform 0. 0. -$QdlCol; 	# COLUMNS
	}
	for {set i 0} {$i <= [expr [llength $elidbeam]-1]} {incr i 1} {
		eleLoad -ele [lindex $elidbeam $i]  -type -beamUniform -$QdlBeam 0.; 	# BEAMS
	}
	for {set i 0} {$i <= [expr [llength $elidgird]-1]} {incr i 1} {
		eleLoad -ele [lindex $elidgird $i]  -type -beamUniform -$QdlGird 0.;	# GIRDS
	}
}; # Pattern plain 101 linear close 
# Define DISPLAY -------------------------------------------------------------
DisplayModel3D DeformedShape ;	 # options: DeformedShape NodeNumbers ModeShape

source Frame3D_build_RCsec.tcl

source attach_buildings.tcl
	
# Define DISPLAY -------------------------------------------------------------
# the deformed shape is defined in the build file
recorder plot $dataDir/DFree$_aBID.out DisplDOF[lindex $iGMdirection 0] 1100 10 400 400 -columns  1 [expr 1+[lindex $iGMdirection 0]] ; # a window to plot the nodal displacements versus time
recorder plot $dataDir/DFree$_aBID.out DisplDOF[lindex $iGMdirection 1] 1100 410 400 400 -columns 1 [expr 1+[lindex $iGMdirection 1]] ; # a window to plot the nodal displacements versus time

# set up ground-motion-analysis parameters
set DtAnalysis	[expr 0.01*$sec];	# time-step Dt for lateral analysis
set TmaxAnalysis	[expr 15. *$sec];	# maximum duration of ground-motion analysis -- should be 50*$sec


# ----------- set up analysis parameters
source LibAnalysisDynamicParameters.tcl;	# constraintsHandler,DOFnumberer,system-ofequations,convergenceTest,solutionAlgorithm,integrator

#constraints Penalty 1.0e5 1.0e5;

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
