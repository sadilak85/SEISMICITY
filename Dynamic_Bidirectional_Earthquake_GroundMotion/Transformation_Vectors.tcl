#
#	LINEAR TRANSFORMATIONS for EACH ELEMENT
#		to GLOBAL COORDINATES
#			by PERPENDICULAR VECTORS to ELEMENT LOCAL AXIS  
#
# Script Identifying:
#		IDBeamTransf   IDGirdTransf   IDColTransf
# 	(Perpendicular unit vectors to each element axis)
# 	For the Linear Transformation Purpose
# Notes: Script handles element axis directions regardless of their initial directions by user
# 
# Script also calculates each Element Length 
# 	
#	by: Serhat Adilak, 2019
#

# --------- Take all Element ID's with their nodes from INPUT FILE ---------
   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file"
   } else {
      set flag 0
	  set BeamConnect ""
	  set GirderConnect ""
	  set ColumnConnect ""
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#END"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "beam"] == 1} {
						set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
						set BeamConnecttmp ""
						foreach BeamConnecttmp2 [split $list] {
							lappend BeamConnecttmp $BeamConnecttmp2
						}
						lappend BeamConnect $BeamConnecttmp
					}
					if {[string match $word "girder"] == 1} {
						set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
						set GirderConnecttmp ""
						foreach GirderConnecttmp2 [split $list] {
							lappend GirderConnecttmp $GirderConnecttmp2
						}
						lappend GirderConnect $GirderConnecttmp
					}
					if {[string match $word "column"] == 1} {
						set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
						set ColumnConnecttmp ""
						foreach ColumnConnecttmp2 [split $list] {
							lappend ColumnConnecttmp $ColumnConnecttmp2
						}
						lappend ColumnConnect $ColumnConnecttmp
					}
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
lappend iBeamConnect $BeamConnect
lappend iGirderConnect $GirderConnect
lappend iColumnConnect $ColumnConnect

# --------- Take all Node ID's with their coordinates from INPUT FILE ---------						
   if [catch {open [lindex $ainputFilename $numInFile 0] r} inFileID] {
      puts stderr "Cannot open input file"
   } else {
      set flag 0
	  set NodeList ""
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#MASTERNODES"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				foreach word [split $line] {
					if {[string match $word "node"] == 1} {
						set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
						set NodeListtmp ""
						foreach NodeListtmp2 [split $list] {
							lappend NodeListtmp $NodeListtmp2
						}
						lappend NodeList $NodeListtmp
					}
				}
			}
         } else {
            foreach word [split $line] {
               if {$flag == 1} {
                  break
               }
               if {[string match $word "#GROUND"] == 1} {set flag 1}
            }
         }
	  }
      close $inFileID
   }
lappend iNodeList $NodeList
#
# -----------------     PERPENDICULAR VECTORS TO EACH ELEMENT AXIS  ------------
# 
# ----------------   FOR BEAMs  -----------------		
set Beamvecxz ""
set Girdervecxz ""
set Columnvecxz ""
set LBeamtmp ""
for {set k 0} {$k <= [expr [llength [lindex $iBeamConnect $numInFile]]-1]} {incr k 1} {;	# For Beams
	set vecxztmp ""
	set LBeamtmp2 ""
	for {set m 0} {$m <= [expr [llength [lindex $iNodeList $numInFile]]-1]} {incr m 1} {
		if {[lindex $iBeamConnect $numInFile $k 1]==[lindex $iNodeList $numInFile $m 0]} {; # search element's first node in Nodelist
			set nodeI [lindex $iNodeList $numInFile $m 0]; # Node ID
			set vecxztmp1x [lindex $iNodeList $numInFile $m 1]; # Node coordinates
			set vecxztmp1y [lindex $iNodeList $numInFile $m 2]
			set vecxztmp1z [lindex $iNodeList $numInFile $m 3]
		}
		if {[lindex $iBeamConnect $numInFile $k 2]==[lindex $iNodeList $numInFile $m 0]} {; # search element's second node in Nodelist
			set nodeJ [lindex $iNodeList $numInFile $m 0]; # Node ID
			set vecxztmp2x [lindex $iNodeList $numInFile $m 1]; # Node coordinates
			set vecxztmp2y [lindex $iNodeList $numInFile $m 2]
			set vecxztmp2z [lindex $iNodeList $numInFile $m 3]
		}
	}
	# Length of each Beam element
	set elementid [lindex $iBeamConnect $numInFile $k 0]
	set tmpelementlength [expr pow(($vecxztmp2x-$vecxztmp1x),2)+pow(($vecxztmp2y-$vecxztmp1y),2)+pow(($vecxztmp2z-$vecxztmp1z),2)]
	set elementlength [expr sqrt($tmpelementlength)]
	lappend LBeamtmp2 $elementid
	lappend LBeamtmp2 $elementlength
	lappend LBeamtmp $LBeamtmp2

# Set element axis direction to default directions first
	if {$vecxztmp1x>$vecxztmp2x} {
		set changetmp $vecxztmp1z
		set vecxztmp1z $vecxztmp2z
		set vecxztmp2z $changetmp
		set changetmp $vecxztmp1x
		set vecxztmp1x $vecxztmp2x
		set vecxztmp2x $changetmp
		set changetmp $nodeI
		set nodeI $nodeJ
		set nodeJ $changetmp
		
		# { x, z } becomes { -z, x } : perpendicular CCW
		set vecxztmpx [expr $vecxztmp1z-$vecxztmp2z]
		set vecxztmpz [expr $vecxztmp2x-$vecxztmp1x]

	} elseif {$vecxztmp1x==$vecxztmp2x} {
		if {$vecxztmp1z<$vecxztmp2z} {
			set changetmp $vecxztmp1z
			set vecxztmp1z $vecxztmp2z
			set vecxztmp2z $changetmp
			set changetmp $vecxztmp1x
			set vecxztmp1x $vecxztmp2x
			set vecxztmp2x $changetmp
			set changetmp $nodeI
			set nodeI $nodeJ
			set nodeJ $changetmp		
		}
			# { x, z } becomes { -z, x } : perpendicular CCW
			set vecxztmpx [expr $vecxztmp1z-$vecxztmp2z]
			set vecxztmpz 0.0
	} else {
		# { x, z } becomes { -z, x } : perpendicular CCW
		set vecxztmpx [expr $vecxztmp1z-$vecxztmp2z]
		set vecxztmpz [expr $vecxztmp2x-$vecxztmp1x]
	}

	set vecxztmpabs [expr {sqrt($vecxztmpx*$vecxztmpx+$vecxztmpz*$vecxztmpz)}]
	set vecxztmpx [expr {$vecxztmpx/$vecxztmpabs}]
	set vecxztmpz [expr {$vecxztmpz/$vecxztmpabs}]

	lappend vecxztmp $vecxztmpx
	lappend vecxztmp $vecxztmpz
	lappend Beamvecxz $vecxztmp
	
	# Update the element Connectivity Nodes to set element axis correctly while creating the element later
	lset iBeamConnect $numInFile $k 1 $nodeI
	lset iBeamConnect $numInFile $k 2 $nodeJ
}
lappend LBeam $LBeamtmp; # {Beam ID,lengths}

#
# ----------------   FOR GIRDERs  ---------------------
#
set LGirdtmp ""
for {set k 0} {$k <= [expr [llength [lindex $iGirderConnect $numInFile]]-1]} {incr k 1} {;	# For Girder
	set vecxztmp ""
	set LGirdtmp2 ""
	for {set m 0} {$m <= [expr [llength [lindex $iNodeList $numInFile]]-1]} {incr m 1} {
		if {[lindex $iGirderConnect $numInFile $k 1]==[lindex $iNodeList $numInFile $m 0]} {; # search element's first node in Nodelist
			set nodeI [lindex $iNodeList $numInFile $m 0]; # Node ID
			set vecxztmp1x [lindex $iNodeList $numInFile $m 1]; # Node coordinates
			set vecxztmp1y [lindex $iNodeList $numInFile $m 2]
			set vecxztmp1z [lindex $iNodeList $numInFile $m 3]
		}
		if {[lindex $iGirderConnect $numInFile $k 2]==[lindex $iNodeList $numInFile $m 0]} {; # search element's second node in Nodelist
			set nodeJ [lindex $iNodeList $numInFile $m 0]; # Node ID
			set vecxztmp2x [lindex $iNodeList $numInFile $m 1]; # Node coordinates
			set vecxztmp2y [lindex $iNodeList $numInFile $m 2]
			set vecxztmp2z [lindex $iNodeList $numInFile $m 3]
		}
	}
	# Length of each girder element
	set elementid [lindex $iGirderConnect $numInFile $k 0]
	set tmpelementlength [expr pow(($vecxztmp2x-$vecxztmp1x),2)+pow(($vecxztmp2y-$vecxztmp1y),2)+pow(($vecxztmp2z-$vecxztmp1z),2)]
	set elementlength [expr sqrt($tmpelementlength)]
	lappend LGirdtmp2 $elementid
	lappend LGirdtmp2 $elementlength
	lappend LGirdtmp $LGirdtmp2

# Set element axis direction to default directions first	
	if {$vecxztmp1x<$vecxztmp2x} {
		if {$vecxztmp1z<$vecxztmp2z} {
			# { x, z } becomes { z, -x } : perpendicular CW
			set vecxztmpx [expr $vecxztmp2z-$vecxztmp1z]
			set vecxztmpz [expr $vecxztmp1x-$vecxztmp2x]		
		} else {
			set changetmp $vecxztmp1z
			set vecxztmp1z $vecxztmp2z
			set vecxztmp2z $changetmp
			set changetmp $vecxztmp1x
			set vecxztmp1x $vecxztmp2x
			set vecxztmp2x $changetmp
			set changetmp $nodeI
			set nodeI $nodeJ
			set nodeJ $changetmp
			# { x, z } becomes { z, -x } : perpendicular CW
			set vecxztmpx [expr $vecxztmp2z-$vecxztmp1z]
			set vecxztmpz [expr $vecxztmp1x-$vecxztmp2x]
		}
	} elseif {$vecxztmp1x>$vecxztmp2x} {
		if {$vecxztmp1z>$vecxztmp2z} {
			set changetmp $vecxztmp1z
			set vecxztmp1z $vecxztmp2z
			set vecxztmp2z $changetmp
			set changetmp $vecxztmp1x
			set vecxztmp1x $vecxztmp2x
			set vecxztmp2x $changetmp
			set changetmp $nodeI
			set nodeI $nodeJ
			set nodeJ $changetmp
		}
		# { x, z } becomes { z, -x } : perpendicular CW
		set vecxztmpx [expr $vecxztmp2z-$vecxztmp1z]
		set vecxztmpz [expr $vecxztmp1x-$vecxztmp2x]		
	} else {
		if {$vecxztmp1z>$vecxztmp2z} {
			set changetmp $vecxztmp1z
			set vecxztmp1z $vecxztmp2z
			set vecxztmp2z $changetmp
			set changetmp $vecxztmp1x
			set vecxztmp1x $vecxztmp2x
			set vecxztmp2x $changetmp
			set changetmp $nodeI
			set nodeI $nodeJ
			set nodeJ $changetmp
		}
		# { x, z } becomes { z, -x } : perpendicular CW
		set vecxztmpx [expr $vecxztmp2z-$vecxztmp1z]
		set vecxztmpz [expr $vecxztmp1x-$vecxztmp2x]
	} 

	set vecxztmpabs [expr {sqrt($vecxztmpx*$vecxztmpx+$vecxztmpz*$vecxztmpz)}]
	set vecxztmpx [expr {$vecxztmpx/$vecxztmpabs}]
	set vecxztmpz [expr {$vecxztmpz/$vecxztmpabs}]

	lappend vecxztmp $vecxztmpx
	lappend vecxztmp $vecxztmpz
	lappend Girdervecxz $vecxztmp

	# Update the element Connectivity Nodes to set element axis correctly while creating the element later	
	lset iGirderConnect $numInFile $k 1 $nodeI
	lset iGirderConnect $numInFile $k 2 $nodeJ
}
lappend LGird $LGirdtmp; # {Girder ID,lengths}
#
#
#
set ivecxztmp ""
lappend ivecxztmp 0.0
lappend ivecxztmp 0.0
lappend ivecxztmp 0.0
lappend ivecxztmp 0.0
set ivecxztmp2 ""
for {set i 0} {$i <= [expr [llength [lindex $iBeamConnect $numInFile]]-1]} {incr i 1} {
	lappend ivecxztmp2 $ivecxztmp
};	# IDTransf = {ElementID, vecxzX, vecxzY, vecxzZ}
lappend IDBeamTransf $ivecxztmp2

set ivecxztmp2 ""
for {set i 0} {$i <= [expr [llength [lindex $iGirderConnect $numInFile]]-1]} {incr i 1} {
	lappend ivecxztmp2 $ivecxztmp
};	# IDTransf = {ElementID, vecxzX, vecxzY, vecxzZ}
lappend IDGirdTransf $ivecxztmp2

for {set k 0} {$k <= [expr [llength [lindex $iBeamConnect $numInFile]]-1]} {incr k 1} {
	lset IDBeamTransf $numInFile $k 0 [lindex $iBeamConnect $numInFile $k 0]
	# Perpendicular vector to element Axis:
	lset IDBeamTransf $numInFile $k 1 [lindex $Beamvecxz $k 0]
	lset IDBeamTransf $numInFile $k 3 [lindex $Beamvecxz $k 1]
}

for {set k 0} {$k <= [expr [llength [lindex $iGirderConnect $numInFile]]-1]} {incr k 1} {
	lset IDGirdTransf $numInFile $k 0 [lindex $iGirderConnect $numInFile $k 0]
	# Perpendicular vector to element Axis:
	lset IDGirdTransf $numInFile $k 1 [lindex $Girdervecxz $k 0]
	lset IDGirdTransf $numInFile $k 3 [lindex $Girdervecxz $k 1]
}
#
# ----------------   FOR COLUMNs  ---------------------
#
set LColtmp ""
for {set k 0} {$k <= [expr [llength [lindex $iColumnConnect $numInFile]]-1]} {incr k 1} {;	# For Column
	set vecxztmp ""
	set LColtmp2 ""
	for {set n 0} {$n <= [expr [llength [lindex $iBeamConnect $numInFile]]-1]} {incr n 1} {
		if {[lindex $iBeamConnect $numInFile $n 1]==[lindex $iColumnConnect $numInFile $k 1]} {
			set vecxztmpx [lindex $IDBeamTransf $numInFile $n 1]
			set vecxztmpz [lindex $IDBeamTransf $numInFile $n 3]
		} elseif {[lindex $iBeamConnect $numInFile $n 1]==[lindex $iColumnConnect $numInFile $k 2]} {
			set vecxztmpx [lindex $IDBeamTransf $numInFile $n 1]
			set vecxztmpz [lindex $IDBeamTransf $numInFile $n 3]			
		}
		if {[lindex $iBeamConnect $numInFile $n 2]==[lindex $iColumnConnect $numInFile $k 1]} {
			set vecxztmpx [lindex $IDBeamTransf $numInFile $n 1]
			set vecxztmpz [lindex $IDBeamTransf $numInFile $n 3]
		} elseif {[lindex $iBeamConnect $numInFile $n 2]==[lindex $iColumnConnect $numInFile $k 2]} {
			set vecxztmpx [lindex $IDBeamTransf $numInFile $n 1]
			set vecxztmpz [lindex $IDBeamTransf $numInFile $n 3]
		}
	}

	for {set m 0} {$m <= [expr [llength [lindex $iNodeList $numInFile]]-1]} {incr m 1} {
		if {[lindex $iColumnConnect $numInFile $k 1]==[lindex $iNodeList $numInFile $m 0]} {; # search element's first node in Nodelist
			set nodeI [lindex $iNodeList $numInFile $m 0]; # Node ID
			set vecxztmp1x [lindex $iNodeList $numInFile $m 1]; # Node coordinates
			set vecxztmp1y [lindex $iNodeList $numInFile $m 2]
			set vecxztmp1z [lindex $iNodeList $numInFile $m 3]
		}
		if {[lindex $iColumnConnect $numInFile $k 2]==[lindex $iNodeList $numInFile $m 0]} {; # search element's second node in Nodelist
			set nodeJ [lindex $iNodeList $numInFile $m 0]; # Node ID
			set vecxztmp2x [lindex $iNodeList $numInFile $m 1]; # Node coordinates
			set vecxztmp2y [lindex $iNodeList $numInFile $m 2]
			set vecxztmp2z [lindex $iNodeList $numInFile $m 3]
		}
	}	
	
	# Length of each column element
	set elementid [lindex $iColumnConnect $numInFile $k 0]
	set tmpelementlength [expr pow(($vecxztmp2x-$vecxztmp1x),2)+pow(($vecxztmp2y-$vecxztmp1y),2)+pow(($vecxztmp2z-$vecxztmp1z),2)]
	set elementlength [expr sqrt($tmpelementlength)]
	lappend LColtmp2 $elementid
	lappend LColtmp2 $elementlength
	lappend LColtmp $LColtmp2
	#
	lappend vecxztmp $vecxztmpx
	lappend vecxztmp $vecxztmpz
	lappend Columnvecxz $vecxztmp
}
lappend LCol $LColtmp; # {Column ID,lengths}
#
#

set ivecxztmp2 ""
for {set i 0} {$i <= [expr [llength [lindex $iColumnConnect $numInFile]]-1]} {incr i 1} {
	lappend ivecxztmp2 $ivecxztmp
};	# IDTransf = {ElementID, vecxzX, vecxzY, vecxzZ}
lappend IDColTransf $ivecxztmp2

for {set k 0} {$k <= [expr [llength [lindex $iColumnConnect $numInFile]]-1]} {incr k 1} {
	lset IDColTransf $numInFile $k 0 [lindex $iColumnConnect $numInFile $k 0]
	# Perpendicular vector to element Axis:
	lset IDColTransf $numInFile $k 1 [lindex $Columnvecxz $k 0]
	lset IDColTransf $numInFile $k 3 [lindex $Columnvecxz $k 1]
}
# define ELEMENTS tags
# set up geometric transformations of element
#   separate columns and beams, in case of P-Delta analysis for columns
#set IDColTransf 1; # all columns
#set IDBeamTransf 2; # all beams
#set IDGirdTransf 3; # all girds
set ColTransfType Linear ;		# options for columns: Linear PDelta  Corotational
#
puts IDBeamTransf$IDBeamTransf
puts IDGirdTransf$IDGirdTransf
puts IDColTransf$IDColTransf
#
# ----------------  DEFINE TRANSFORMATIONS  ---------------
for {set k 0} {$k <= [expr [llength [lindex $iBeamConnect $numInFile]]-1]} {incr k 1} {
	set vecxzX [lindex $IDBeamTransf $numInFile $k 1]
	set vecxzY [lindex $IDBeamTransf $numInFile $k 2]
	set vecxzZ	[lindex $IDBeamTransf $numInFile $k 3]
	geomTransf Linear [lindex $IDBeamTransf $numInFile $k 0] $vecxzX $vecxzY $vecxzZ
}

for {set k 0} {$k <= [expr [llength [lindex $iGirderConnect $numInFile]]-1]} {incr k 1} {
	set vecxzX [lindex $IDGirdTransf $numInFile $k 1]
	set vecxzY [lindex $IDGirdTransf $numInFile $k 2]
	set vecxzZ	[lindex $IDGirdTransf $numInFile $k 3]
	geomTransf Linear [lindex $IDGirdTransf $numInFile $k 0] $vecxzX $vecxzY $vecxzZ
}

for {set k 0} {$k <= [expr [llength [lindex $iColumnConnect $numInFile]]-1]} {incr k 1} {
	set vecxzX [lindex $IDColTransf $numInFile $k 1]
	set vecxzY [lindex $IDColTransf $numInFile $k 2]
	set vecxzZ	[lindex $IDColTransf $numInFile $k 3]
	# orientation of column stiffness affects bidirectional response.
	geomTransf $ColTransfType [lindex $IDColTransf $numInFile $k 0] $vecxzX $vecxzY $vecxzZ
}
#
#		
