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

	lappend WeightColtmp 0
	lappend WeightColtmp 0
	for {set i 0} {$i <= [expr [llength $LCol]-1]} {incr i 1} {
		lappend WeightCol $WeightColtmp
	}
	for {set i 0} {$i <= [expr [llength $LCol]-1]} {incr i 1} {
		 lset WeightCol $i 1 [expr $QdlCol*[lindex $LCol $i 1]];    # total Column weight
		 lset WeightCol $i 0 [lindex $LCol $i 0]
	}
	lappend WeightBeamtmp 0
	lappend WeightBeamtmp 0
	for {set i 0} {$i <= [expr [llength $LBeam]-1]} {incr i 1} {
		lappend WeightBeam $WeightBeamtmp
	}
	for {set i 0} {$i <= [expr [llength $LBeam]-1]} {incr i 1} {
		 lset WeightBeam $i 1 [expr $QdlBeam*[lindex $LBeam $i 1]];    # total Beam weight
		 lset WeightBeam $i 0 [lindex $LBeam $i 0]
	}
	lappend WeightGirdtmp 0
	lappend WeightGirdtmp 0
	for {set i 0} {$i <= [expr [llength $LGird]-1]} {incr i 1} {
		lappend WeightGird $WeightGirdtmp
	}
	for {set i 0} {$i <= [expr [llength $LGird]-1]} {incr i 1} {
		 lset WeightGird $i 1 [expr $QdlGird*[lindex $LGird $i 1]];    # total Gird weight
		 lset WeightGird $i 0 [lindex $LGird $i 0]
	}

# 
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
  set flag 1
  set floorcounter 0
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
					set floorcounter [expr $floorcounter+1]
					break
				} else {
					if {$floorcounter  == $NStorytmp} {
						set ColWeightFact 1;		# one column in top story
					} else {
						set ColWeightFact 2;		# two columns elsewhere
					}
					set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
					foreach word [split $list] {
						if {[expr [string index $word 2]] == 0} {
							set GirdWeightFact 1;		# 1x1/2girder on exterior frames
						} else {
							set GirdWeightFact 2;		# 2x1/2girder on interior frames
						}
						if {[expr [string index $word 1]] == 0} {
							set BeamWeightFact 1;	# one beam at exterior nodes
						} else {
							set BeamWeightFact 2;	# two beams elewhere
						}
						
						#elidcolumnnodes
						#elidbeamnodes
						#elidgirdnodes
						
						
						set WeightNode [expr $ColWeightFact*$WeightCol/2 + $BeamWeightFact*$WeightBeam/2 + $GirdWeightFact*$WeightGird/2]
						set MassNode [expr $WeightNode/$g];

						set inhalt [expr [string index $word 0]]
						mass $word $MassNode 0. $MassNode 0. 0. 0.;			# define mass
						lset aFloorWeight $numInFile [expr $inhalt-1] [expr [lindex $aFloorWeight $numInFile [expr $inhalt-1]] + $WeightNode];    
						break
					}
					break
				}
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
