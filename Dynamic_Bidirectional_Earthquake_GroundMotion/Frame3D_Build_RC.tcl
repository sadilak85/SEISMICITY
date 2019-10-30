#
#		Model of each buildings
#

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
					if {[string match $word "#FLOOR"] == 1} {
					set flag 0
					break
					}
				}
				if {$flag == 1} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					foreach word [split $list] {
						# BOUNDARY CONDITIONS
						fix $word 1 1 1 0 1 0;		# pin all Ground Floor nodes
						lappend iSupportNodetmp $word
						break
					}
				}
			} else {
				foreach word [split $line] {
					if {[string match $word "#GROUND"] == 1} {
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

# ------------------------  Number of Storeys ------------------------------------------------------
set NStorytmp 0
	if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading number of storeys"
	} else {
	set flag 1
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
					foreach word [split $line] {
						if {[string match $word "#FLOOR"] == 1} {
							set NStorytmp [expr $NStorytmp+1];	 # number of stories above ground level
							break
						}
					}
				}
			} else {break}
		}
	lappend NStory $NStorytmp
	close $inFileID
	}

# ------------------------  Free Node ID for OUTPUT ------------------------------------------------------
	if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading free node ID"
	} else {
	set flag 1
	set FreeNodeIDtmp ""
	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} 
		if {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#MASTERNODES"] == 1} {
					set flag 0
					break
				}
				if {[string match $word "#BUILDING"] == 1} {
					break
				}
				if {[string match $word "#GROUND"] == 1 || [string match $word "#FLOOR"] == 1} {
					break
				} else {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					foreach word [split $list] {
					set FreeNodeIDtmp $word;	# ID: free node  to output results	
					break
					}
				}
			}
		}
	}
	close $inFileID
	}
	lappend FreeNodeID $FreeNodeIDtmp
  
# define structure-geometry paramters
# ------------------------  BEAM LENGTHs ------------------------------------------------------
    if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading ground fix points"
    } else {
      set flag 0
		set LBeamtmp2 ""
		foreach line [split [read $inFileID] \n] {
			if {[llength $line] == 0} {
				# Blank line --> do nothing
				continue
			} elseif {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "#GIRDER"] == 1} {
					set flag 0
					break
					}
				}
				if {$flag == 1} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					
					set LBeamtmp1 ""
					foreach word [split $list] {
						lappend LBeamtmp1 $word
					}
					lappend LBeamtmp2 $LBeamtmp1 
				}
			} else {
				foreach word [split $line] {
					if {[string match $word "#BEAMLENGTH"] == 1} {
						set flag 1
						break
					}
				}
			}
		}
	close $inFileID
	}
	lappend LBeam $LBeamtmp2;	# beam length (parallel to X axis)
  
# ------------------------  GIRDER LENGTHs ------------------------------------------------------
    if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading ground fix points"
    } else {
      set flag 0
		set LGirdtmp2 ""
		foreach line [split [read $inFileID] \n] {
			if {[llength $line] == 0} {
				# Blank line --> do nothing
				continue
			} elseif {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "#COLUMN"] == 1} {
					set flag 0
					break
					}
				}
				if {$flag == 1} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]

					set LGirdtmp1 ""
					foreach word [split $list] {
						lappend LGirdtmp1 $word
					}
					lappend LGirdtmp2 $LGirdtmp1 
				}
			} else {
				foreach word [split $line] {
					if {[string match $word "#GIRDERLENGTH"] == 1} {
						set flag 1
						break
					}
				}
			}
		}
	close $inFileID
	}
	lappend LGird $LGirdtmp2;	# girder length (parallel to Z axis) 

	
# ------------------------  COLUMN LENGTHs ------------------------------------------------------
    if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading ground fix points"
    } else {
      set flag 0
	  set LColtmp2 ""
		foreach line [split [read $inFileID] \n] {
			if {[llength $line] == 0} {
				# Blank line --> do nothing
				continue
			} elseif {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "#END"] == 1} {
					set flag 0
					break
					}
				}
				if {$flag == 1} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					set LColtmp1 ""
					foreach word [split $list] {
						lappend LColtmp1 $word
					}
					lappend LColtmp2 $LColtmp1
				}
			} else {
				foreach word [split $line] {
					if {[string match $word "#COLUMNLENGTH"] == 1} {
						set flag 1
						break
					}
				}
			}
		}
	close $inFileID
	}
	lappend LCol $LColtmp2;  # column height (parallel to Y axis)

# ----- Element IDs for Gravity Loads -------------------------------------------------------
# ------------------------- CREATE Column IDs ---------------------------------------------------

   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file for reading column elements IDs with its connectivity"
   } else {
      set flag 0
	  set elidcolumnnodestmp ""
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
				set elemID [lreplace $list 3 5]
				lappend elidcolumnnodestmp $elemID
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
   lappend elidcolumnnodes $elidcolumnnodestmp
   
  	if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
		puts stderr "Cannot open input file for reading Floor Heights"
	} else {
	set flag 1
	set floorlevel 0
	set incr 0
	set aFloorHeighttmp "";    # distance between two neighbor floors for each building
 	for {set i 1} {$i <= [lindex $NStory $numInFile 0]} {incr i 1} {
		lappend aFloorHeighttmp 0
	}
	lappend aFloorHeight $aFloorHeighttmp
	
	set FloorHeighttmp "";    # Distance from each floor to the ground for each building
 	for {set i 1} {$i <= [lindex $NStory $numInFile 0]} {incr i 1} {
		lappend FloorHeighttmp 0
	}
	lappend FloorHeight $FloorHeighttmp

	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} 
		if {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#MASTERNODES"] == 1} {
					set flag 0
					break
				}
				if {[string match $word "#BUILDING"] == 1} {
					break
				}
				if {[string match $word "#GROUND"] == 1} {
					break
				}
				if {[string match $word "#FLOOR"] == 1} {
					set floorlevel [expr $floorlevel+1]
					break
				} else {
					if {$flag == 1} {
						if {$floorlevel > $incr} {
							set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
							foreach word [split $list] {
								for {set i 0} {$i <= [expr [llength [lindex $LCol $numInFile]]-1]} {incr i 1} {
									if {[lindex $elidcolumnnodes $numInFile $i 1] == $word || [lindex $elidcolumnnodes $numInFile $i 2] == $word} {
										lset aFloorHeight $numInFile [expr $floorlevel-1] [lindex $LCol $numInFile $i 1];  # assuming all colums same length!!!
										set incr [expr $incr+1]
										break
									}
								}
							break
							}
						}
					}
				}
			}
		}
	}
	close $inFileID
	}
    set FloorHeighttmp 0
	for {set i 1} {$i <= [lindex $NStory $numInFile 0]} {incr i 1} {
		set FloorHeighttmp [expr $FloorHeighttmp + [lindex $aFloorHeight $numInFile [expr $i-1]]]
		lset FloorHeight $numInFile [expr $i-1] $FloorHeighttmp
	}
	
# beams -- parallel to X-axis
# -----------------------   CREATE BEAM IDs  -------------------------------------------------
   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file for reading beam elements IDs with its connectivity"
   } else {
      set flag 0
	  set elidbeamnodestmp ""
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
				set elemID [lreplace $list 3 5]
				lappend elidbeamnodestmp $elemID
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
   lappend elidbeamnodes $elidbeamnodestmp

# girders -- parallel to Y-axis
# ----------------------  CREATE Gird IDs  ------------------------------------------------------
   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file for reading girder elements IDs with its connectivity"
   } else {
      set flag 0
	  set elidgirdnodestmp ""
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
				set elemID [lreplace $list 3 5]
				lappend elidgirdnodestmp $elemID
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
   lappend elidgirdnodes $elidgirdnodestmp

# ------------------------  Exterior Node IDs  ------------------------------------------------------
if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
	puts stderr "Cannot open input file for reading nodal weights"
} else {
  set flag 1
	set floorcounter 0
	set nodecounttmp 0
	set exteriornodes ""
	set nodecount ""
	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} 
		if {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#BUILDING"] == 1} {
					break
				}
				if {[string match $word "#GROUND"] == 1} {
					set flag2 1
					break
				}
				if {[string match $word "#FLOOR"] == 1 || [string match $word "#MASTERNODES"] == 1} {
					set flag2 0
					if {$floorcounter>0} {
						lappend exteriornodes $iexteriornodestmp
						lappend nodecount $nodecounttmp
						set iexteriornodestmp ""
						set nodecounttmp 0
					}
					set floorcounter [expr $floorcounter+1]
					
					if {[string match $word "#MASTERNODES"] == 1} {
						set flag2 1
					} 
					break
				} else {
				  if {$flag2 == 0} {
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					foreach word [split $list] {
						lappend iexteriornodestmp $list
						set nodecounttmp [expr $nodecounttmp+1]
						break
					}
					break
				  }
				}
			}; #end of split line 
		}
	}; #end of line read 
	close $inFileID
	}
	lappend iexteriornodes $exteriornodes; # outermost nodes per floor each building
	
set exteriorGirdernodesID ""
set exteriornodesID ""
set exteriorGirdernodesID ""
set exteriorBeamnodesID ""	
set aNBayZ ""
set aNFrame ""
for {set k 0} {$k <= [expr [lindex $NStory $numInFile 0]-1]} {incr k 1} {
	set maxX 0.0
	set maxZ 0.0
	set exteriornodestmp2 ""
	set exteriornodesIDtmp ""
	set exteriorGirdernodesIDtmp ""
	set exteriorBeamnodesIDtmp ""
	lappend exteriornodestmp2 [lindex $iexteriornodes $numInFile $k]
	for {set i 0} {$i <= [expr [lindex $nodecount $k]-1]} {incr i 1} {
		if {$maxX <= [lindex $exteriornodestmp2 $numInFile $i 1]} {
			set maxX [lindex $exteriornodestmp2 $numInFile $i 1]
		}
		if {$maxZ <= [lindex $exteriornodestmp2 $numInFile $i 3]} {
			set maxZ [lindex $exteriornodestmp2 $numInFile $i 3]
		}		
	}
	set minX [lindex $exteriornodestmp2 $numInFile 0 1]
	set minZ [lindex $exteriornodestmp2 $numInFile 0 3]
	for {set i 0} {$i <= [expr [lindex $nodecount $k]-1]} {incr i 1} {
		if {$minX > [lindex $exteriornodestmp2 $numInFile $i 1]} {
			set minX [lindex $exteriornodestmp2 $numInFile $i 1]
		}
		if {$minZ > [lindex $exteriornodestmp2 $numInFile $i 3]} {
			set minZ [lindex $exteriornodestmp2 $numInFile $i 3]
		}		
	}
	for {set i 0} {$i <= [expr [lindex $nodecount $k]-1]} {incr i 1} {
		if {$minX == [lindex $exteriornodestmp2 $numInFile $i 1]} {
			lappend exteriornodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
			lappend exteriorGirdernodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
		}
		if {$maxX == [lindex $exteriornodestmp2 $numInFile $i 1]} {
			lappend exteriornodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
			lappend exteriorGirdernodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
		}
		if {$minZ == [lindex $exteriornodestmp2 $numInFile $i 3]} {
			if {$minX != [lindex $exteriornodestmp2 $numInFile $i 1] && $maxX != [lindex $exteriornodestmp2 $numInFile $i 1]} {
				lappend exteriornodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
			}
			lappend exteriorBeamnodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
		}
		if {$maxZ == [lindex $exteriornodestmp2 $numInFile $i 3]} {
			if {$minX != [lindex $exteriornodestmp2 $numInFile $i 1] && $maxX != [lindex $exteriornodestmp2 $numInFile $i 1]} {
				lappend exteriornodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
			}
			lappend exteriorBeamnodesIDtmp [lindex $exteriornodestmp2 $numInFile $i 0]
		}
	}
	lappend exteriornodesID $exteriornodesIDtmp
	lappend exteriorGirdernodesID $exteriorGirdernodesIDtmp
	lappend exteriorBeamnodesID $exteriorBeamnodesIDtmp	
	lappend aNBayZ [expr [llength [lindex $exteriorGirdernodesID $k]]/2-1]
	lappend aNFrame [expr [llength [lindex $exteriorGirdernodesID $k]]/2]
}
	lappend iexteriornodesID $exteriornodesID
	lappend iexteriorGirdernodesID $exteriorGirdernodesID
	lappend iexteriorBeamnodesID $exteriorBeamnodesID
	lappend NBayZ $aNBayZ; #NBAYZ		# number of bays in Z direction
	lappend NFrame $aNFrame;	# actually deal with frames in Z direction, as this is an easy extension of the 2d model

	
#
	puts "Number of Stories in Y: $NStorytmp Number of Frames in each floor: $NFrame"
#
#