set iMasterNode ""
set filename "INPUT.txt"
set outname "test.out"


set outputfile [open $outname w]
    if [catch {open $filename r} inFileID] {
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
				puts $outputfile $line
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach MasterNodeID [split $list] {
					set mylist [lreplace $list 0 0]
					puts $mylist
					puts $list
					if {[string index $MasterNodeID 0] eq "1"} {
						lappend iMasterNode $MasterNodeID
						puts orada$iMasterNode
						break
					} else {break}
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
		for {set i 0} {$i <= 2} {incr i 1} {
			 lset iMasterNode $i [expr [lindex $iMasterNode $i]*2];    
		}

		lappend WeightColtmp 0
		lappend WeightColtmp 0
		for {set i 0} {$i <= 4} {incr i 1} {
			lappend WeightCol $WeightColtmp
		}
		for {set i 0} {$i <= 2} {incr i 1} {
			lset WeightCol $i 0 [lindex $iMasterNode $i]
		}
		puts $WeightCol
		puts [llength $WeightCol]

	  close $outputfile
      close $inFileID
   }