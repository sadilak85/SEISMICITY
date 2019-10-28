set outputfile [open $outputFilename$Buildingnum$FileExt w]
    if [catch {open $inputFilename r} inFileID] {
		puts stderr "Cannot open $inputFilename for reading"
    } else {
      set flag 1
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
			foreach word [split $line] {
				if {[string match $word "#BUILDING_ID"] == 1} {
					puts $outputfile $line
					break
				} elseif {[string match $word "#BUILDING_END"] == 1} {
					puts $outputfile "#BUILDING_END"
					close $outputfile
					set Buildingnum [expr $Buildingnum+1]
					lappend ainputFilename $outputFilename$Buildingnum$FileExt
					set outputfile [open $outputFilename$Buildingnum$FileExt w]
					break
				} elseif {[string match $word "#END"] == 1} {
					set flag 0
					puts $outputfile "#END"
					break
				} else {
					puts $outputfile $line
					break
				}
			}
         } else {
		 break
		 }
      }
      close $inFileID
	  close $outputfile
    }