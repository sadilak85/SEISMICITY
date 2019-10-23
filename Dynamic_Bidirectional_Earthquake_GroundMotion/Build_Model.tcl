#
#		Model of each buildings
#
set aBID [lindex $BID $numInFile 0]; # assign Building number
set _aBID "_$aBID"
set checkID 0

	if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading number of storeys"
	} else {
	set flag 0
		foreach line [split [read $inFileID] \n] {
			if {[llength $line] == 0} {
				# Blank line --> do nothing
				continue
			} elseif {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "#MASTERNODES"] == 1} {
						set flag 0
						break
					}
				}
				if {$flag == 1} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					foreach word [split $list] {
						if {$checkID < [string index $word 0]} {
							set NStorytmp [expr [string index $word 0]-1];			# number of stories above ground level  # Assuming right inputting
							break				
						} else {
							break
						}
					}
					set checkID [expr [string index $word 0]]
				}
			} else {
				foreach word [split $line] {
					if {[string match $word "#NODES"] == 1} {
						set flag 1
						break
					}
				}
			}
		}
	lappend NStory $NStorytmp
	close $inFileID
	}

	if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading number of BAYs"
	} else {
	set flag 0
	set NBaytmp 1;	#min number of Bays in X direction
	set NBayZtmp 1;
		foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} elseif {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#MASTERNODES"] == 1} {
					set flag 0
					break
				}
			}
			if {$flag == 1} {
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach word [split $list] {
					if {$NBaytmp < [expr 1+[string index $word 1]]} {
						set NBaytmp [expr 1+[string index $word 1]] ;		#NBAY		# number of bays in X direction
					}
					if {$NBayZtmp < [expr 1+[string index $word 2]]} {
						set NBayZtmp [expr 1+[string index $word 2]] ;		#NBAYZ		# number of bays in Z direction
					}
					break
				}
			}
		} else {
				foreach word [split $line] {
					if {[string match $word "#NODES"] == 1} {
						set flag 1
						break
					}
				}
			}
		}
	lappend NBay $NBaytmp
	lappend NBayZ $NBayZtmp
	close $inFileID
	}
	 lappend NFrame [expr [lindex $NBayZ $numInFile 0] + 1];	# actually deal with frames in Z direction, as this is an easy extension of the 2d model

	
	if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading free node ID"
	} else {
	set flag 0
	set FreeNodeIDtmp ""
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
					if {[expr [string index $word 0]] == [expr [lindex $NStory $numInFile 0]+1]} {
						set FreeNodeIDtmp $word;	# ID: free node  to output results	
					}
					break
				}
			}
		} else {
			foreach word [split $line] {
				if {[string match $word "#NODES"] == 1} {
					set flag 1
					break
				}
			}
		}
	}
	close $inFileID
	}
	lappend FreeNodeID $FreeNodeIDtmp


# --------- CREATE MODEL from input files -----------------------------------------------------
	source [lindex $ainputFilename $numInFile 0]

	
# ------------------------  Boundary ------------------------------------------------------
# determine support nodes where ground motions are input, for multiple-support excitation
    if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading ground fix points"
    } else {
      set flag 0
	  set iSupportNodetmp ""
		foreach line [split [read $inFileID] \n] {
			if {[llength $line] == 0} {
				# Blank line --> do nothing
				continue
			} elseif {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "#MASTERNODES"] == 1} {
					set flag 0
					break
					}
				}
				if {$flag == 1} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					foreach word [split $list] {
						if {[string index $word 0] eq "1"} {
							# BOUNDARY CONDITIONS
							fix $word 1 1 1 0 1 0;		# pin all Ground Floor nodes
							lappend iSupportNodetmp $word
							break
						} else {break}
					}
				}
			} else {
				foreach word [split $line] {
					if {[string match $word "#NODES"] == 1} {
						set flag 1
						break
					}
				}
			}
		}
	close $inFileID
	}
	lappend iSupportNode $iSupportNodetmp

    if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file for reading constrain dofs rather than rigid diaphragm"
    } else {
      set flag 0
	  set iMasterNodetmp ""
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
					lappend iMasterNodetmp $MasterNodeID
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
  lappend iMasterNode $iMasterNodetmp
 
# assign masses to the nodes that the columns are connected to 
# each connection takes the mass of 1/2 of each element framing into it (mass=weight/$g)
set iFloorWeight ""
set WeightTotal 0.0
set sumWiHi 0.0;		# sum of storey weight times height, for lateral-load distribution
set aFloorWeighttmp ""
# ------------------------- MASS NODE ASSIGNMENT is not CORRECT due to unknown NODAL inputting format
for {set i 1} {$i <= [expr [lindex $NStory $numInFile 0]+1]} {incr i 1} {
	lappend aFloorWeighttmp 0
}
	lappend aFloorWeight $aFloorWeighttmp

if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
	puts stderr "Cannot open input file for reading nodal weights"
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
					if {[expr [string index $word 0]] == [expr [lindex $NStory $numInFile 0]+1]} {
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
						lset aFloorWeight $numInFile [expr $inhalt-1] [expr [lindex $aFloorWeight $numInFile [expr $inhalt-1]] + $WeightNode];    
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
	for {set i 2} {$i <= [expr [lindex $NStory $numInFile 0]+1]} {incr i 1} {
		set WeightTotal [expr $WeightTotal+ [lindex $aFloorWeight $numInFile [expr $i-1]]]
	}

	for {set i 2} {$i <= [expr [lindex $NStory $numInFile 0]+1]} {incr i 1} {
		set sumWiHi [expr $sumWiHi+[lindex $aFloorWeight $numInFile [expr $i-1]]*([expr $i-1])*$LCol];	# sum of storey weight times height, for lateral-load distribution
	}

	for {set i 2} {$i <= [expr [lindex $NStory $numInFile 0]+1]} {incr i 1} {
		lappend iFloorWeight [lindex $aFloorWeight $numInFile [expr $i-1]]
	}
lappend MassTotal [expr $WeightTotal/$g];			# total mass for each building
puts $MassTotal
puts $sumWiHi
puts $aFloorWeight
puts $iFloorWeight

# --------------------------------------------------------------------------------------------------------------------------------
# LATERAL-LOAD distribution for static pushover analysis
# calculate distribution of lateral load based on mass/weight distributions along building height
# Fj = WjHj/sum(WiHi)  * Weight   at each floor j
set iFj ""
for {set level 2} {$level <=[expr [lindex $NStory $numInFile 0]+1]} {incr level 1} { ;	
	set FloorWeight [lindex $iFloorWeight [expr $level-1-1]];
	puts $FloorWeight
	set FloorHeight [expr ($level-1)*$LCol];
	lappend iFj [expr $FloorWeight*$FloorHeight/$sumWiHi*$WeightTotal];		# per floor per building
}
puts $iFj
lappend iNodePush [lindex $iMasterNode $numInFile 0] ;		# nodes for pushover/cyclic, vectorized
lappend iFPush $iFj;				# lateral load for pushover, vectorized for each building (list)

# Define RECORDERS -------------------------------------------------------------
set SupportNodeFirst [lindex $iSupportNode $numInFile 0];						# ID: first support node
set SupportNodeLast [lindex $iSupportNode $numInFile [expr [llength [lindex $iSupportNode $numInFile]]-1]];		# ID: last support node 
set MasterNodeFirst [lindex $iMasterNode $numInFile 0];						# ID: first master node
set MasterNodeLast [lindex $iMasterNode $numInFile [expr [llength [lindex $iMasterNode $numInFile]]-1]];			# ID: last master node

recorder Node -file $dataDir/DFree$_aBID.out -time -node $FreeNodeIDtmp  -dof 1 2 3 disp;				# displacements of free node
recorder Node -file $dataDir/DMaster$_aBID.out -time -nodeRange $MasterNodeFirst $MasterNodeLast -dof 1 2 3 disp;	# displacements of support nodes
recorder Node -file $dataDir/DBase$_aBID.out -time -nodeRange $SupportNodeFirst $SupportNodeLast -dof 1 2 3 disp;	# displacements of support nodes
recorder Node -file $dataDir/RBase$_aBID.out -time -nodeRange $SupportNodeFirst $SupportNodeLast -dof 1 2 3 reaction;	# support reaction
recorder Drift -file $dataDir/DrNode$_aBID.out -time -iNode $SupportNodeFirst  -jNode $FreeNodeIDtmp   -dof 1 -perpDirn 2;	# lateral drift
recorder Element -file $dataDir/Fel1$_aBID.out -time -ele $FirstColumn localForce;					# element forces in local coordinates
recorder Element -file $dataDir/ForceEle1sec1$_aBID.out -time -ele $FirstColumn section 1 force;			# section forces, axial and moment, node i
recorder Element -file $dataDir/DefoEle1sec1$_aBID.out -time -ele $FirstColumn section 1 deformation;			# section deformations, axial and curvature, node i
recorder Element -file $dataDir/ForceEle1sec$numIntgrPts$_aBID.out -time -ele $FirstColumn section $numIntgrPts force;			# section forces, axial and moment, node j
recorder Element -file $dataDir/DefoEle1sec$numIntgrPts$_aBID.out -time -ele $FirstColumn section $numIntgrPts deformation;		# section deformations, axial and curvature, node j
set yFiber [expr $HCol/2-$cover];								# fiber location for stress-strain recorder, local coords
set zFiber [expr $BCol/2-$cover];								# fiber location for stress-strain recorder, local coords
recorder Element -file $dataDir/SSconcEle1sec1$_aBID.out -time -ele $FirstColumn section $numIntgrPts fiber $yFiber $zFiber $IDconcCore  stressStrain;	# steel fiber stress-strain, node i
recorder Element -file $dataDir/SSreinfEle1sec1$_aBID.out -time -ele $FirstColumn section $numIntgrPts fiber $yFiber $zFiber $IDSteel  stressStrain;	# steel fiber stress-strain, node i

# ----- Element IDs for Gravity Loads -------------------------------------------------------
# ------------------------- CREATE Columns ---------------------------------------------------
   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file for reading column elements gravity loads"
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
					lappend elidcolumn $elemID
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
   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file for reading beam element gravity loads"
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
					lappend elidbeam $elemID
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
   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file for reading girder element gravity loads"
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
					lappend elidgird $elemID
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

	puts "Number of Stories in Y: $NStorytmp Number of bays in X: $NBaytmp Number of bays in Z: $NBayZtmp"
#
#