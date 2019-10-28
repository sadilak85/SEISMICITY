# --------------------------------------------------------------------------------------------------
# Example 8. 3D RC frame
#		Silvia Mazzoni & Frank McKenna, 2006
# nonlinearBeamColumn element, inelastic fiber section
#

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
set inputFilename "INPUT_multiple.tcl";
  	
# define GEOMETRY -------------------------------------------------------------
# define structure-geometry paramters
set LCol 168;		# column height (parallel to Y axis)	.... set this variable as array and take it from input file
set LBeam 288;		# beam length (parallel to X axis)		.... set this variable as array "
set LGird 288;		# girder length (parallel to Z axis)    .... set this variable as array "

set checkID 0
if [catch {open $inputFilename r} inFileID] {
	puts stderr "Cannot open $inFilename for reading"
} else {
  set flag 0
	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} elseif {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#MASTERNODES"] == 1} {set flag 0}
			}
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach word [split $list] {
					if {$checkID < [string index $word 0]} {
						set NStory [expr [string index $word 0]-1];			# number of stories above ground level
						break
					}
				}
				set checkID [expr [string index $word 0]]
			}
		} else {
				foreach word [split $line] {
					if {$flag == 1} {
						break
					}
				if {[string match $word "#NODES"] == 1} {set flag 1}
				}
			}
		}
		close $inFileID
	}
set NBay 1
set NBayZ 1
if [catch {open $inputFilename r} inFileID] {
	puts stderr "Cannot open $inFilename for reading"
} else {
  set flag 0
	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} elseif {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#MASTERNODES"] == 1} {set flag 0}
			}
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach word [split $list] {
					if {$NBay < [expr 1+[string index $word 1]]} {
						set NBay [expr 1+[string index $word 1]] ;		#NBAY		# number of bays in X direction
					}
					if {$NBayZ < [expr 1+[string index $word 2]]} {
						set NBayZ [expr 1+[string index $word 2]] ;		#NBAYZ		# number of bays in Z direction
					}
					break
				}
			}
		} else {
				foreach word [split $line] {
					if {$flag == 1} {
						break
					}
				if {[string match $word "#NODES"] == 1} {set flag 1}
				}
			}
		}
		close $inFileID
	}
	
if [catch {open $inputFilename r} inFileID] {
	puts stderr "Cannot open $inFilename for reading"
} else {
  set flag 0
	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} elseif {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#MASTERNODES"] == 1} {set flag 0}
			}
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach word [split $list] {
					if {[expr [string index $word 0]] == [expr $NStory+1]} {
						set FreeNodeID $word;	# ID: free node  to output results	
					}
					break
				}
			}
		} else {
				foreach word [split $line] {
					if {$flag == 1} {
						break
					}
				if {[string match $word "#NODES"] == 1} {set flag 1}
				}
			}
		}
		close $inFileID
	}
					
set Dlevel 10000;	# numbering increment for new-level nodes
set Dframe 100;	# numbering increment for new-frame nodes
set FirstColumn 1;							# ID: first column assuming it starts with 1
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

# Section Properties:
set HCol [expr 18*$in];		# square-Column width
set BCol $HCol
set HBeam [expr 24*$in];		# Beam depth -- perpendicular to bending axis
set BBeam [expr 18*$in];		# Beam width -- parallel to bending axis
set HGird [expr 24*$in];		# Girder depth -- perpendicular to bending axis
set BGird [expr 18*$in];		# Girder width -- parallel to bending axis

if {$SectionType == "Elastic"} {
	# material properties:
	set fc 4000*$psi;			# concrete nominal compressive strength
	set Ec [expr 57*$ksi*pow($fc/$psi,0.5)];	# concrete Young's Modulus
	set nu 0.2;			# Poisson's ratio
	set Gc [expr $Ec/2./[expr 1+$nu]];  	# Torsional stiffness Modulus
	set J $Ubig;			# set large torsional stiffness
	# column section properties:
	set AgCol [expr $HCol*$BCol];		# rectuangular-Column cross-sectional area
	set IzCol [expr 0.5*1./12*$BCol*pow($HCol,3)];	# about-local-z Rect-Column gross moment of inertial
	set IyCol [expr 0.5*1./12*$HCol*pow($BCol,3)];	# about-local-z Rect-Column gross moment of inertial
	# beam sections:
	set AgBeam [expr $HBeam*$BBeam];		# rectuangular-Beam cross-sectional area
	set IzBeam [expr 0.5*1./12*$BBeam*pow($HBeam,3)];	# about-local-z Rect-Beam cracked moment of inertial
	set IyBeam [expr 0.5*1./12*$HBeam*pow($BBeam,3)];	# about-local-y Rect-Beam cracked moment of inertial
	# girder sections:
	set AgGird [expr $HGird*$BGird];		# rectuangular-Girder cross-sectional area
	set IzGird [expr 0.5*1./12*$BGird*pow($HGird,3)];	# about-local-z Rect-Girder cracked moment of inertial
	set IyGird [expr 0.5*1./12*$HGird*pow($BGird,3)];	# about-local-y Rect-Girder cracked moment of inertial
		
	section Elastic $ColSecTag $Ec $AgCol $IzCol $IyCol $Gc $J
	section Elastic $BeamSecTag $Ec $AgBeam $IzBeam $IyBeam $Gc $J
	section Elastic $GirdSecTag $Ec $AgGird $IzGird $IyGird $Gc $J

	set IDconcCore  1;		# material numbers for recorder (this stressstrain recorder will be blank, as this is an elastic section)
	set IDSteel  2;			# material numbers for recorder (this stressstrain recorder will be blank, as this is an elastic section)

} elseif {$SectionType == "FiberSection"} {
	# MATERIAL parameters 
	source LibMaterialsRC.tcl;	# define library of Reinforced-concrete Materials
	# FIBER SECTION properties 
	# Column section geometry:
	set cover [expr 2.5*$in];	# rectangular-RC-Column cover
	set numBarsTopCol 8;		# number of longitudinal-reinforcement bars on top layer
	set numBarsBotCol 8;		# number of longitudinal-reinforcement bars on bottom layer
	set numBarsIntCol 6;		# TOTAL number of reinforcing bars on the intermediate layers
	set barAreaTopCol [expr 1.*$in*$in];	# longitudinal-reinforcement bar area
	set barAreaBotCol [expr 1.*$in*$in];	# longitudinal-reinforcement bar area
	set barAreaIntCol [expr 1.*$in*$in];	# longitudinal-reinforcement bar area

	set numBarsTopBeam 6;		# number of longitudinal-reinforcement bars on top layer
	set numBarsBotBeam 6;		# number of longitudinal-reinforcement bars on bottom layer
	set numBarsIntBeam 2;		# TOTAL number of reinforcing bars on the intermediate layers
	set barAreaTopBeam [expr 1.*$in*$in];	# longitudinal-reinforcement bar area
	set barAreaBotBeam [expr 1.*$in*$in];	# longitudinal-reinforcement bar area
	set barAreaIntBeam [expr 1.*$in*$in];	# longitudinal-reinforcement bar area

	set numBarsTopGird 6;		# number of longitudinal-reinforcement bars on top layer
	set numBarsBotGird 6;		# number of longitudinal-reinforcement bars on bottom layer
	set numBarsIntGird 2;		# TOTAL number of reinforcing bars on the intermediate layers
	set barAreaTopGird [expr 1.*$in*$in];	# longitudinal-reinforcement bar area
	set barAreaBotGird [expr 1.*$in*$in];	# longitudinal-reinforcement bar area
	set barAreaIntGird [expr 1.*$in*$in];	# longitudinal-reinforcement bar area

	set nfCoreY 12;		# number of fibers in the core patch in the y direction
	set nfCoreZ 12;		# number of fibers in the core patch in the z direction
	set nfCoverY 8;		# number of fibers in the cover patches with long sides in the y direction
	set nfCoverZ 8;		# number of fibers in the cover patches with long sides in the z direction
	# rectangular section with one layer of steel evenly distributed around the perimeter and a confined core.
	BuildRCrectSection $ColSecTagFiber $HCol $BCol $cover $cover $IDconcCore  $IDconcCover $IDSteel $numBarsTopCol $barAreaTopCol $numBarsBotCol $barAreaBotCol $numBarsIntCol $barAreaIntCol  $nfCoreY $nfCoreZ $nfCoverY $nfCoverZ
	BuildRCrectSection $BeamSecTagFiber $HBeam $BBeam $cover $cover $IDconcCore  $IDconcCover $IDSteel $numBarsTopBeam $barAreaTopBeam $numBarsBotBeam $barAreaBotBeam $numBarsIntBeam $barAreaIntBeam  $nfCoreY $nfCoreZ $nfCoverY $nfCoverZ
	BuildRCrectSection $GirdSecTagFiber $HGird $BGird $cover $cover $IDconcCore  $IDconcCover $IDSteel $numBarsTopGird $barAreaTopGird $numBarsBotGird $barAreaBotGird $numBarsIntGird $barAreaIntGird  $nfCoreY $nfCoreZ $nfCoverY $nfCoverZ

	# assign torsional Stiffness for 3D Model
	uniaxialMaterial Elastic $SecTagTorsion $Ubig
	section Aggregator $ColSecTag $SecTagTorsion T -section $ColSecTagFiber
	section Aggregator $BeamSecTag $SecTagTorsion T -section $BeamSecTagFiber
	section Aggregator $GirdSecTag $SecTagTorsion T -section $GirdSecTagFiber
} else {
	puts "No section has been defined"
	return -1
}
set GammaConcrete [expr 150*$pcf];
set QdlCol [expr $GammaConcrete*$HCol*$BCol];	# self weight of Column, weight per length
set QBeam [expr $GammaConcrete*$HBeam*$BBeam];	# self weight of Beam, weight per length
set QGird [expr $GammaConcrete*$HGird*$BGird];	# self weight of Gird, weight per length

# --------------------------------------------------------------------------------------------------------------------------------
# define ELEMENTS
# set up geometric transformations of element
#   separate columns and beams, in case of P-Delta analysis for columns
set IDColTransf 1; # all columns
set IDBeamTransf 2; # all beams
set IDGirdTransf 3; # all girds
set ColTransfType Linear ;		# options for columns: Linear PDelta  Corotational 
geomTransf $ColTransfType  $IDColTransf  0 0 1;			# orientation of column stiffness affects bidirectional response.
geomTransf Linear $IDBeamTransf 0 0 1
geomTransf Linear $IDGirdTransf 1 0 0

# --------- CREATE MODEL -----------------------------------------------------
source INPUT.tcl;

set outputfile [open "out.txt" w]
    if [catch {open $inputFilename r} inFileID] {
		puts stderr "Cannot open $inFilename for reading"
    } else {
      set flag 0
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#END"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				puts $outputfile $list
			}
         } else {
            foreach word [split $line] {
               if {$flag == 1} {
                  break
               }
               if {[string match $word "#BEGIN"] == 1} {set flag 1}
            }
         }
      }
      close $inFileID
    }

close $outputfile

# ------ frame configuration
puts "Number of Stories in Y: $NStory Number of bays in X: $NBay Number of bays in Z: $NBayZ"
set NFrame [expr $NBayZ + 1];	# actually deal with frames in Z direction, as this is an easy extension of the 2d model

# ------------------------  Boundary ------------------------------------------------------
# determine support nodes where ground motions are input, for multiple-support excitation
set iSupportNode ""
    if [catch {open $inputFilename r} inFileID] {
		puts stderr "Cannot open $inFilename for reading"
    } else {
      set flag 0
		foreach line [split [read $inFileID] \n] {
			if {[llength $line] == 0} {
				# Blank line --> do nothing
				continue
			} elseif {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "#MASTERNODES"] == 1} {set flag 0}
				}
				if {$flag == 1} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					foreach word [split $list] {
						if {[string index $word 0] eq "1"} {
							# BOUNDARY CONDITIONS
							fix $word 1 1 1 0 1 0;		# pin all Ground Floor nodes
							lappend iSupportNode $word
							break
						} else {break}
					}
				}
			} else {
					foreach word [split $line] {
						if {$flag == 1} {
							break
						}
					if {[string match $word "#NODES"] == 1} {set flag 1}
					}
				}
			}
		}
      close $inFileID

set iMasterNode ""
    if [catch {open $inputFilename r} inFileID] {
      puts stderr "Cannot open $inFilename for reading"
    } else {
      set flag 0
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#RIGID"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach MasterNodeID [split $list] {
					fix $MasterNodeID 0  1  0  1  0  1;		# constrain other dofs that don't belong to rigid diaphragm control
					lappend iMasterNode $MasterNodeID
					break
				}
			}
         } else {
            foreach word [split $line] {
               if {$flag == 1} {
                  break
               }
               if {[string match $word "#MASTERNODES"] == 1} {set flag 1}
            }
         }
      }
      close $inFileID
   }
			
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

# assign masses to the nodes that the columns are connected to 
# each connection takes the mass of 1/2 of each element framing into it (mass=weight/$g)
set iFloorWeight ""
set WeightTotal 0.0
set sumWiHi 0.0;		# sum of storey weight times height, for lateral-load distribution

# ------------------------- MASS NODE ASSIGNMENT is not CORRECT due to unknown NODAL inputting format
array set aFloorWeight {}
for {set i 2} {$i <= [expr $NStory+1]} {incr i 1} {
	set aFloorWeight($i) 0
}

if [catch {open $inputFilename r} inFileID] {
	puts stderr "Cannot open $inFilename for reading"
} else {
  set flag 0
	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} elseif {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#MASTERNODES"] == 1} {set flag 0}
			}
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach word [split $list] {
					if {[expr [string index $word 2]] == 0} {
						set GirdWeightFact 1;		# 1x1/2girder on exterior frames
					} else {
						set GirdWeightFact 2;		# 2x1/2girder on interior frames
					}
					if {[expr [string index $word 0]] == [expr $NStory+1]} {
						set ColWeightFact 1;		# one column in top story
					} else {
						set ColWeightFact 2;		# two columns elsewhere
					}
					if {[expr [string index $word 1]] == 0} {
						set BeamWeightFact 1;	# one beam at exterior nodes
					} else {
						set BeamWeightFact 2;	# two beams elewhere
					}
					set WeightNode [expr $ColWeightFact*$WeightCol/2 + $BeamWeightFact*$WeightBeam/2 + $GirdWeightFact*$WeightGird/2]
					set MassNode [expr $WeightNode/$g];
					
					if {[string index $word 0] ne "1"} {
						set inhalt [expr [string index $word 0]]
						mass $word $MassNode 0. $MassNode 0. 0. 0.;			# define mass
						set aFloorWeight($inhalt) [expr $aFloorWeight($inhalt) + $WeightNode];
					}
					break
				}
			}
		} else {
				foreach word [split $line] {
					if {$flag == 1} {
						break
					}
				if {[string match $word "#NODES"] == 1} {set flag 1}
				}
			}
		}
		close $inFileID
	}
	for {set i 2} {$i <= [expr $NStory+1]} {incr i 1} {
		set WeightTotal [expr $WeightTotal+ $aFloorWeight($i)]
	}

	for {set i 2} {$i <= [expr $NStory+1]} {incr i 1} {
		set sumWiHi [expr $sumWiHi+$aFloorWeight($i)*([expr $i-1])*$LCol];	# sum of storey weight times height, for lateral-load distribution
	}

	for {set i 2} {$i <= [expr $NStory+1]} {incr i 1} {
		lappend iFloorWeight $aFloorWeight($i)
	}
set MassTotal [expr $WeightTotal/$g];						# total mass

#------------------------------------------------------------------------------------------------------------------
#Eigenvalue analysis

set numModes 3
set lambda [eigen  $numModes];

# calculate frequencies and periods of the structure ---------------------------------------------------
set omega {}
set f {}
set T {}
set pi 3.141593

foreach lam $lambda {
	lappend omega [expr sqrt($lam)]
	lappend f [expr sqrt($lam)/(2*$pi)]
	lappend T [expr (2*$pi)/sqrt($lam)]
}

puts "periods are $T"

# --------------------------------------------------------------------------------------------------------------------------------
# LATERAL-LOAD distribution for static pushover analysis
# calculate distribution of lateral load based on mass/weight distributions along building height
# Fj = WjHj/sum(WiHi)  * Weight   at each floor j
set iFj ""
for {set level 2} {$level <=[expr $NStory+1]} {incr level 1} { ;	
	set FloorWeight [lindex $iFloorWeight [expr $level-1-1]];
	set FloorHeight [expr ($level-1)*$LCol];
	lappend iFj [expr $FloorWeight*$FloorHeight/$sumWiHi*$WeightTotal];		# per floor
}
set iNodePush $iMasterNode;		# nodes for pushover/cyclic, vectorized
set iFPush $iFj;				# lateral load for pushover, vectorized

# Define RECORDERS -------------------------------------------------------------
set SupportNodeFirst [lindex $iSupportNode 0];						# ID: first support node
set SupportNodeLast [lindex $iSupportNode [expr [llength $iSupportNode]-1]];			# ID: last support node
set MasterNodeFirst [lindex $iMasterNode 0];						# ID: first master node
set MasterNodeLast [lindex $iMasterNode [expr [llength $iMasterNode]-1]];			# ID: last master node
recorder Node -file $dataDir/DFree.out -time -node $FreeNodeID  -dof 1 2 3 disp;				# displacements of free node
recorder Node -file $dataDir/DMaster.out -time -nodeRange $MasterNodeFirst $MasterNodeLast -dof 1 2 3 disp;	# displacements of support nodes
recorder Node -file $dataDir/DBase.out -time -nodeRange $SupportNodeFirst $SupportNodeLast -dof 1 2 3 disp;	# displacements of support nodes
recorder Node -file $dataDir/RBase.out -time -nodeRange $SupportNodeFirst $SupportNodeLast -dof 1 2 3 reaction;	# support reaction
recorder Drift -file $dataDir/DrNode.out -time -iNode $SupportNodeFirst  -jNode $FreeNodeID   -dof 1 -perpDirn 2;	# lateral drift
recorder Element -file $dataDir/Fel1.out -time -ele $FirstColumn localForce;					# element forces in local coordinates
recorder Element -file $dataDir/ForceEle1sec1.out -time -ele $FirstColumn section 1 force;			# section forces, axial and moment, node i
recorder Element -file $dataDir/DefoEle1sec1.out -time -ele $FirstColumn section 1 deformation;			# section deformations, axial and curvature, node i
recorder Element -file $dataDir/ForceEle1sec$numIntgrPts.out -time -ele $FirstColumn section $numIntgrPts force;			# section forces, axial and moment, node j
recorder Element -file $dataDir/DefoEle1sec$numIntgrPts.out -time -ele $FirstColumn section $numIntgrPts deformation;		# section deformations, axial and curvature, node j
set yFiber [expr $HCol/2-$cover];								# fiber location for stress-strain recorder, local coords
set zFiber [expr $BCol/2-$cover];								# fiber location for stress-strain recorder, local coords
recorder Element -file $dataDir/SSconcEle1sec1.out -time -ele $FirstColumn section $numIntgrPts fiber $yFiber $zFiber $IDconcCore  stressStrain;	# steel fiber stress-strain, node i
recorder Element -file $dataDir/SSreinfEle1sec1.out -time -ele $FirstColumn section $numIntgrPts fiber $yFiber $zFiber $IDSteel  stressStrain;	# steel fiber stress-strain, node i

# Define DISPLAY -------------------------------------------------------------
DisplayModel3D DeformedShape ;	 # options: DeformedShape NodeNumbers ModeShape

# GRAVITY -------------------------------------------------------------
# define GRAVITY load applied to beams and columns -- eleLoad applies loads in local coordinate axis
pattern Plain 101 Linear {

# ------------------------- CREATE Columns ---------------------------------------------------
   if [catch {open $inputFilename r} inFileID] {
      puts stderr "Cannot open $inFilename for reading"
   } else {
      set flag 0
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#COLUMNLENGTH"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach elemID [split $list] {
					eleLoad -ele $elemID -type -beamUniform 0. 0. -$QdlCol; 	# COLUMNS
					break
				}
			}
         } else {
            foreach word [split $line] {
               if {$flag == 1} {
                  break
               }
               if {[string match $word "#COLUMN"] == 1} {set flag 1}
            }
         }
      }
      close $inFileID
   }

# beams -- parallel to X-axis
# -----------------------   CREATE BEAMs   -------------------------------------------------
   if [catch {open $inputFilename r} inFileID] {
      puts stderr "Cannot open $inFilename for reading"
   } else {
      set flag 0
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#BEAMLENGTH"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach elemID [split $list] {
					eleLoad -ele $elemID  -type -beamUniform -$QdlBeam 0.; 	# BEAMS
					break
				}
			}
         } else {
            foreach word [split $line] {
               if {$flag == 1} {
                  break
               }
               if {[string match $word "#BEAM"] == 1} {set flag 1}
            }
         }
      }
      close $inFileID
   }

# girders -- parallel to Y-axis
# ----------------------  CREATE Girds  ------------------------------------------------------
   if [catch {open $inputFilename r} inFileID] {
      puts stderr "Cannot open $inFilename for reading"
   } else {
      set flag 0
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#GIRDERLENGTH"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach elemID [split $list] {
					eleLoad -ele $elemID  -type -beamUniform -$QdlGird 0.;	# GIRDS
					break
				}
			}
         } else {
            foreach word [split $line] {
               if {$flag == 1} {
                  break
               }
               if {[string match $word "#GIRDER"] == 1} {set flag 1}
            }
         }
      }
      close $inFileID
   }

}
puts goGravity
# Gravity-analysis parameters -- load-controlled static analysis
set Tol 1.0e-8;			# convergence tolerance for test
variable constraintsTypeGravity Plain;		# default;
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

# -------------------------------------------------------------
puts "Model Built"
#
#