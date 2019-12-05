# ------------------------------------------------------
#	CREATE POUNDING
#
#		ZeroLengthImpact3D elements
#		Additional Nodes into Model
#implementation of zeroLengthImpact3D with nodes in 3DOF domain:
# ------------------------------------------------------
if [catch {open [lindex $PoundingInputFileList $numInFile 0] r} inFileID] {
	puts stderr "Cannot open input file for reading Pounding related components"
} else {
  set flag 1
  set flagnodes 0
  set flagconstraints 0
  set flagimpact 0
  set flagelements 0
	foreach line [split [read $inFileID] \n] {
		if {[llength $line] == 0} {
			# Blank line --> do nothing
			continue
		} 
		if {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#EXTRANODES"] == 1} {
					model BasicBuilder -ndm 3 -ndf 3
					set flagnodes 1
					set flagconstraints 0
					set flagimpact 0
					set flagelements 0				
					break
				} elseif {[string match $word "#CONSTRAINTS"] == 1} {
					model BasicBuilder -ndm 3 -ndf 6
					set flagnodes 0
					set flagconstraints 1
					set flagimpact 0
					set flagelements 0
					break
				} elseif {[string match $word "#ZEROLENGTHIMPACT"] == 1} {
					set flagnodes 0
					set flagconstraints 0
					set flagimpact 1
					set flagelements 0
					break
				} elseif {[string match $word "#ZEROLENGTHELEMENTS"] == 1} {
					set flagnodes 0
					set flagconstraints 0
					set flagimpact 0
					set flagelements 1
					break
				} elseif {[string match $word "#POUNDING"] == 1} {
					set flagnodes 0
					set flagconstraints 0
					set flagimpact 0
					set flagelements 0				
					break
				}
				if {$flagnodes == 1} {
					foreach word [split $line] {
						if {[string match $word "node"] == 1} {
							set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
							set tags ""
							foreach tagstmp [split $list] {
								lappend tags $tagstmp
							}
							set nodeID [lindex $tags 0]
							set X [lindex $tags 1]
							set Y [lindex $tags 2]
							set Z [lindex $tags 3]
							node $nodeID $X $Y $Z;		# actually define node
						}	
						break
					}			
				} elseif {$flagconstraints == 1} {
					foreach word [split $line] {
						if {[string match $word "constraint"] == 1} {
							set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
							set tags ""
							foreach tagstmp [split $list] {
								lappend tags $tagstmp
							}
							set MNode [lindex $tags 0]
							set SNode [lindex $tags 1]
							equalDOF $MNode $SNode 1 2 3;	# actually define constraints
						}	
						break
					}
				} elseif {$flagimpact == 1} {
					foreach word [split $line] {
						if {[string match $word "impact"] == 1} {
							set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
							set tags ""
							foreach tagstmp [split $list] {
								lappend tags $tagstmp
							}
							set eltID [lindex $tags 0]
							set nodei [lindex $tags 1]
							set nodej [lindex $tags 2]
							element zeroLengthImpact3D $eltID $nodei $nodej $direction $initGap $frictionRatio $Kt $Kn $Kn2 $Delta_y $cohesion;	#actually define contacts
						}	
						break
					}
				} elseif {$flagelements == 1} {
					foreach word [split $line] {
						if {[string match $word "element"] == 1} {
							set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
							set tags ""
							foreach tagstmp [split $list] {
								lappend tags $tagstmp
							}
							set eltID [lindex $tags 0]
							set nodei [lindex $tags 1]
							set nodej [lindex $tags 2]
							element zeroLength $$eltID $nodei $nodej -mat 6 7 6 -dir 1 2 3; # springs with very low stiffness for convergance of Newton-Raphson method 
						}	
						break
					}
				}
			}; #end of split line 
		}
	}; #end of line read 
	close $inFileID
}
#
#